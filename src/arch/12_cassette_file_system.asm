; -----------------------------------------------------------------------------
; Architectural module: 12_cassette_file_system.asm
; OPEN/CREATE/CLOSE and the cassette file-control subsystem.
; Original monolithic line range: 11117-11666.
; Emitted address range: 0x9478-0x9777.
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; OPEN / CREATE / CLOSE dictionary cluster
; -----------------------------------------------------------------------------

; ============================================================================
; CHAPTER 12 — A FILE SYSTEM MADE FROM NUMBERED TAPE RECORDS
; ============================================================================
;
; Spectrum cassette I/O has no directory and no random access.  micro-PROLOG
; builds a sequential file abstraction by writing custom type-0xFB records.  A
; ten-byte footer contains an eight-character padded filename and a two-digit
; decimal block number.  OPEN searches the tape until the expected identity is
; encountered; CREATE emits records in increasing order.
;
; One 0x134-byte control block exists, so only one dynamic cassette file can be
; open at a time.  Its 256-byte transfer area carries 255 data bytes: cursor 0xFF
; is reserved to mean that an input refill is needed.
;
open_constant_entry:
    defb TERM_TAG_CONSTANT
    defw open_value_cell
    defb TERM_TAG_LIST
    defw create_constant_entry
open_value_cell:
    defb TERM_TAG_INTEGER
    defw open_primitive
open_name:
    defb 04fh,050h,045h,04eh,SYSTEM_NAME_TERMINATOR ; "OPEN"

open_primitive:
    ld ix,open_dispatch_file
    jp primitive_argument_dispatch
open_dispatch_file:
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb open_dispatch_complete-open_dispatch_file
    defb DISPATCH_REJECT,DISPATCH_REJECT
open_dispatch_complete:
    defb open_file-open_dispatch_complete
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT

; ----------------------------------------------------------------------------
; OPEN PREPARES THE EXPECTATION BEFORE SEARCHING THE TAPE
; ----------------------------------------------------------------------------
;
; The filename is padded to eight bytes and block number 00 is installed in the
; expected-identity area.  The control block enters reading state, then the ROM
; wrapper scans records until both footer fields match.
;
; The first byte of the accepted block is preserved for READ.  Unrelated records
; and later block numbers are skipped rather than silently accepted, allowing a
; user to reposition the tape and retry a missed block.
;
; Numbered-block search example
; -----------------------------
; Suppose OPEN expects `FAMILY 00`, but the tape stream contains:
;
;       OTHER 00, FAMILY 01, NOISE, FAMILY 00
;
; The loader accepts only the exact filename plus expected block number.  It
; skips OTHER 00, reports/ignores the premature FAMILY 01 while continuing to
; search for the missing block, skips unrelated records, and finally accepts
; FAMILY 00.  After acceptance it advances the expected identity to FAMILY 01.
; This policy permits recovery when the tape is positioned before a mixture of
; unrelated or out-of-order records.
open_file:
    ; A file name can be either an unopened dictionary constant or an existing
    ; tag-0x06 object.  Existing READING objects are reopened/refreshed; a fresh
    ; constant receives a newly allocated control block.
    ld hl,(PRIMITIVE_ARG1_VALUE)
    ld a,(hl)
    cp 006h
    jr z,.open_existing_system_object
    cp 010h
    jp nz,signal_control_error
    call test_dictionary_value_is_dynamic
    jp nz,signal_control_error
    jp file_open_new_input_object
.open_existing_system_object:
    call test_dictionary_value_is_dynamic
    jr z,.open_existing_dynamic_file
    cp a
    ret
.open_existing_dynamic_file:
    push hl
    call term_load_payload_hl
    ex de,hl
    pop hl
    ld a,(de)
    cp FILE_STATE_WRITING
    jr nz,.open_initialize_input_state
    call file_finish_output
    call file_allocate_control_block
.open_initialize_input_state:
    jp file_open_input_control_block
create_constant_entry:
    defb TERM_TAG_CONSTANT
    defw create_value_cell
    defb TERM_TAG_LIST
    defw close_constant_entry
create_value_cell:
    defb TERM_TAG_INTEGER
    defw create_primitive
create_name:
    defb 043h,052h,045h,041h,054h,045h,SYSTEM_NAME_TERMINATOR ; "CREATE"

create_primitive:
    ld ix,create_dispatch_file
    jp primitive_argument_dispatch
create_dispatch_file:
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb create_dispatch_complete-create_dispatch_file
    defb DISPATCH_REJECT,DISPATCH_REJECT
create_dispatch_complete:
    defb create_file-create_dispatch_complete
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT

; ----------------------------------------------------------------------------
; CREATE CLAIMS THE SAME CONTROL BLOCK FOR OUTPUT
; ----------------------------------------------------------------------------
;
; Writing starts with an empty cursor and block number 00.  Recreating an
; existing non-writing file object reinitializes it; attempting to create over a
; live writer is rejected so buffered data cannot be abandoned accidentally.
;
create_file:
    ; CREATE rejects incompatible/open states, allocates a new output object for
    ; a plain constant, or reinitializes a reusable tag-0x06 object.
    ld hl,(PRIMITIVE_ARG1_VALUE)
    ld a,(hl)
    cp 006h
    jr z,.create_existing_system_object
    cp 010h
    jp nz,signal_control_error
    call test_dictionary_value_is_dynamic
    jp nz,signal_control_error
    call file_create_new_output_object
    cp a
    ret
.create_existing_system_object:
    call test_dictionary_value_is_dynamic
    jr z,.create_existing_dynamic_file
    cp a
    ret
.create_existing_dynamic_file:
    push hl
    call term_load_payload_hl
    ex de,hl
    ld a,(de)
    cp FILE_STATE_WRITING
    jr nz,.create_reinitialize_nonwriting_file
    push ix
    push de
    pop ix
    ld hl,FILE_CONTROL_EXPECTED_IDENTITY
    add hl,de
    ld c,DEVICE_OP_INIT_OUTPUT_IDENTITY
    call spectrum_io_dispatch
    ld (ix+FILE_CONTROL_UNUSED_FLAG),000h
    ld (ix+FILE_CONTROL_CURSOR),000h
    pop ix
    pop hl
    cp a
    ret
.create_reinitialize_nonwriting_file:
    pop hl
    call file_initialize_output_control_block
    cp a
    ret
close_constant_entry:
    defb TERM_TAG_CONSTANT
    defw close_value_cell
    defb TERM_TAG_LIST
    defw supervisor_not_constant_entry
close_value_cell:
    defb TERM_TAG_INTEGER
    defw close_primitive
close_name:
    defb 043h,04ch,04fh,053h,045h,SYSTEM_NAME_TERMINATOR ; "CLOSE"

close_primitive:
    ld ix,close_dispatch_file
    jp primitive_argument_dispatch
close_dispatch_file:
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb close_dispatch_complete-close_dispatch_file
    defb DISPATCH_REJECT,DISPATCH_REJECT
close_dispatch_complete:
    defb close_file-close_dispatch_complete
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT

; ----------------------------------------------------------------------------
; CLOSE IS PART OF THE FILE FORMAT
; ----------------------------------------------------------------------------
;
; An output file is not complete until byte 0x1A has been appended and the final
; partial block has been written.  CLOSE performs both operations before marking
; the control block free.  Merely losing the file object would therefore leave
; no logical EOF on tape.
;
close_file:
    ; CLOSE only accepts a live tag-0x06 file object.  Writing objects receive
    ; an EOF marker and final flush before the object is detached.
    ld hl,(PRIMITIVE_ARG1_VALUE)
    ld a,(hl)
    cp 006h
    ret nz
    call test_dictionary_value_is_dynamic
    jr z,.close_existing_dynamic_file
    cp a
    ret
.close_existing_dynamic_file:
    call term_load_payload_hl
    ex de,hl
    ld a,(de)
    ld hl,(PRIMITIVE_ARG1_VALUE)
    cp FILE_STATE_WRITING
    push hl
    push de
    call z,file_finish_output
    pop de
    pop hl
    ld a,000h
    ld (de),a
    ld (hl),010h
    ld a,00dh
    call console_output_byte
    cp a
    ret
; ----------------------------------------------------------------------------
; BUFFERING HIDES PHYSICAL RECORD BOUNDARIES
; ----------------------------------------------------------------------------
;
; Bytes fill payload positions 0 through 0xFE.  Filling the last usable position
; triggers a physical write, resets the cursor and increments the two-character
; decimal block number.  The term printer can consequently emit one continuous
; stream without knowing where tape records divide it.
;
file_output_byte:
    ; In: HL = control-state address, A = byte to append.
    ; Require WRITING state.  Store at data[cursor], then increment the one-byte
    ; cursor.  Index 0xFE is the 255th and final usable payload byte; after it is
    ; written the block is flushed.  Index 0xFF is deliberately unused because
    ; the reader needs cursor 0xFF as its refill sentinel.
    push af
    ld a,(hl)
    cp FILE_STATE_WRITING
    jp nz,signal_file_error
    pop af
    push af
    push hl
    push de
    inc hl
    inc hl
    ld e,(hl)
    inc (hl)
    ld d,000h
    inc hl
    add hl,de
    ld (hl),a
    ld a,e
    cp FILE_CONTROL_USABLE_DATA_SIZE-1
    pop de
    pop hl
    call z,file_flush_output_block
    pop af
    cp a
    ret
; Physical cassette record
; ------------------------
; The Spectrum ROM wrapper writes one custom block:
;
;       type byte outside payload: 0xFB
;       payload length:             0x10A = 266 bytes
;
;       payload offsets 0x000-0x0FF  256-byte transfer area
;                       0x100-0x107  padded eight-character filename
;                       0x108-0x109  two ASCII decimal block digits
;
; Only transfer offsets 0x00-0xFE are normal file bytes; cursor 0xFF is the
; refill/flush sentinel.  Thus each physical record contributes 255 logical data
; bytes.  ROM_LD_EDGE_* and the save wrapper provide pulse-level transport.
file_flush_output_block:
    ; In: HL = control-state address.
    ; Reset cursor before the slow transfer, select data at state+3, then write
    ; exactly 0x10A bytes using the expected identity at state-0x24.  The device
    ; layer increments the footer block number immediately before ROM SA_BYTES.
    ; The unwritten physical payload byte and any unused tail retain old data;
    ; logical EOF is defined solely by the explicit 0x1A marker written on CLOSE.
    push af
    push bc
    push hl
    push de
    ld d,h
    ld e,l
    push hl
    inc hl
    inc hl
    ld (hl),000h
    inc hl
    ex de,hl
    ld c,DEVICE_OP_SELECT_TRANSFER_BUFFER
    call spectrum_io_dispatch
    pop hl
    ld de,FILE_CONTROL_EXPECTED_IDENTITY
    add hl,de
    ex de,hl
    ld c,DEVICE_OP_WRITE_TAPE_BLOCK
    call spectrum_io_dispatch
    pop de
    pop hl
    pop bc
    pop af
    ret
; ----------------------------------------------------------------------------
; READ SEES A STREAM, THE CALLBACK SEES BLOCKS
; ----------------------------------------------------------------------------
;
; Cursor 0xFF requests the next physical record.  Once loaded, ordinary reads
; return buffered bytes and advance the cursor.  The 0x1A logical EOF marker is
; deliberately persistent: repeated reads at end of file continue to report EOF
; instead of consuming it as source text.
;
; Input/refill state machine
; --------------------------
;       request next byte:
;           if cursor != 0xFF:
;               byte = buffer[cursor++]
;               if byte == EOF(0x1A): keep EOF visible for future reads
;               return byte
;
;           search tape for expected filename+block number:
;               skip unrelated records
;               report encountered wrong identity and continue/retry
;               on matching record:
;                   increment expected block number
;                   cursor = 0
;                   return first buffered byte through ordinary path
;               on ROM/device failure: signal file error
;
; EOF persistence is deliberate: parsers and repeated READ calls observe a stable
; end condition rather than consuming it and accidentally refilling past it.
file_input_next_byte:
    ; In: HL = control-state address.  Out: A = next byte and Z on success; NZ
    ; denotes EOF or transfer failure.
    ;
    ; Cursor 0xFF means no usable byte remains.  Refill selects state+3, asks the
    ; device layer to read one 266-byte record using the expected identity at
    ; state-0x24, then retries from cursor zero.  Bytes at indexes 0..0xFE are
    ; consumable.  A 0x1A marker is immediately unread by decrementing the active
    ; cursor, so every later READ observes stable EOF rather than running into
    ; stale bytes beyond the marker.
    push de
    push bc
    push hl
.file_input_retry_or_consume:
    push hl
    ld a,(hl)
    cp FILE_STATE_READING
    jr nz,.file_input_return
    inc hl
    inc hl
    ld a,(hl)
    cp FILE_CURSOR_REFILL_REQUIRED
    jr nz,.file_input_consume_buffered_byte
    ld (hl),000h
    ld c,DEVICE_OP_SELECT_TRANSFER_BUFFER
    ex de,hl
    inc de
    call spectrum_io_dispatch
    dec de
    dec de
    dec de
    ld hl,FILE_CONTROL_EXPECTED_IDENTITY
    add hl,de
    ex de,hl
    ld c,DEVICE_OP_READ_TAPE_BLOCK
    call spectrum_io_dispatch
    or a
    jr nz,.file_input_return
    pop hl
    jr .file_input_retry_or_consume
.file_input_consume_buffered_byte:
    ld e,a
    inc (hl)
    ld d,000h
    inc hl
    add hl,de
    ld a,(hl)
    cp FILE_BUFFER_EOF
    jr z,.file_input_eof_marker
    cp a
    jr .file_input_return
.file_input_eof_marker:
    call file_unread_or_refill_callback
    or a
.file_input_return:
    pop hl
    pop hl
    pop bc
    pop de
    ret
file_output_callback:
    ; Adapter installed in 0x986C for W/WRITE/LISTP.  It appends A to the file
    ; object selected in 0x9B6D and refreshes interpreter heap pointers after a
    ; possible buffer flush/garbage collection.
    push hl
    ld hl,(ACTIVE_FILE_CONTROL_BLOCK)
    call file_output_byte
    call console_service_break_and_typeahead
    pop hl
    ret
file_input_callback:
    ; Adapter installed in 0x9866 for READ/INTOK.
    push hl
    ld hl,(ACTIVE_FILE_CONTROL_BLOCK)
    call console_service_break_and_typeahead
    call file_input_next_byte
    pop hl
    ret
; Numbered-block search trace
; ---------------------------
; Expected identity: `FILE    03`.
;
;   encountered unrelated `OTHER   00` -> ignore and continue tape search
;   encountered later    `FILE    04` -> report mismatch/search onward; do not
;                                      change expected identity to 04
;   encountered exact    `FILE    03` -> accept, preserve first payload byte,
;                                      and increment expectation only for the
;                                      subsequent logical refill
;
; Searching past a later block permits the user to reposition/replay the tape to
; supply the missing exact block.  Silent advancement would corrupt file order.
file_unread_or_refill_callback:
    ; Adapter installed in 0x9869 for tokenizer look-ahead on an opened file.
    push hl
    ld hl,(ACTIVE_FILE_CONTROL_BLOCK)
    inc hl
    inc hl
    dec (hl)
    pop hl
    ret
; Load the 16-bit payload field of a tagged cell.
; In:  HL = tagged cell address
; Out: HL = little-endian payload
term_load_payload_hl:
    inc hl
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ret
; ----------------------------------------------------------------------------
; COLD START LAYS OUT THE ENTIRE DYNAMIC MACHINE
; ----------------------------------------------------------------------------
;
; This routine clears fixed state, initializes the active seventy-byte portion
; of the dictionary bitmap, establishes the upward execution and downward heap
; frontiers, creates permanent sentinels, initializes the file control block and
; copies the module/supervisor templates.
;
; The banner's free-byte figure measures from the dictionary pool base to the
; initial heap boundary.  Dictionary names consume a fixed 4,480-byte share;
; the remaining 19,673 bytes form the shared evaluation arena.
;
initialize_runtime_workspace:
    call print_inline_high_bit_string

; BLOCK 'INTRO_string' (start 0x962c end 0x9663)
; Readable high-bit startup banner (bit 7 cleared for display):
;       "   SPECTRUM micro-PROLOG T1.0"
;       carriage return
;       "     (c) 1983  L P A Ltd"
; The bytes remain high-bit encoded because print_inline_high_bit_string uses the
; high bit as the stored-text convention.
INTRO_string_start:
    defb 0a0h
    defb 0a0h
    defb 0a0h
    defb 0d3h
    defb 0d0h
    defb 0c5h
    defb 0c3h
    defb 0d4h
    defb 0d2h
    defb 0d5h
    defb 0cdh
    defb 0a0h
    defb 0edh
    defb 0e9h
    defb 0e3h
    defb 0f2h
    defb 0efh
    defb 0adh
    defb 0d0h
    defb 0d2h
    defb 0cfh
    defb 0cch
    defb 0cfh
    defb 0c7h
    defb 0a0h
    defb 0d4h
    defb 0b1h
    defb 0aeh
    defb 0b0h
    defb 00dh
    defb 0a0h
    defb 0a0h
    defb 0a0h
    defb 0a0h
    defb 0a0h
    defb 0a8h
    defb 0e3h
    defb 0a9h
    defb 0a0h
    defb 0b1h
    defb 0b9h
    defb 0b8h
    defb 0b3h
    defb 0a0h
    defb 0a0h
    defb 0cch
    defb 0a0h
    defb 0d0h
    defb 0a0h
    defb 0c1h
    defb 0a0h
    defb 0a0h
    defb 0cch
    defb 0f4h
    defb 0e4h
INTRO_string_end:
    xor (hl)
    nop
    ld hl,DICTIONARY_NAME_POOL_START
    ld (DICTIONARY_NAME_POOL_BASE_PTR),hl
    ld hl,0ffffh
    ld (FREE_TERM_OBJECT_HEAD),hl
    ld a,0c3h
    ld (IO_INPUT_CALLBACK_JUMP),a
    ld (IO_UNREAD_CALLBACK_JUMP),a
    ld (IO_OUTPUT_CALLBACK_JUMP),a
    ld (LIST_WALK_CALLBACK_JUMP),a
    ld hl,console_output_byte
    ld (IO_OUTPUT_CALLBACK_TARGET),hl
    ld hl,(SUPERVISOR_MACHINE_STACK)
    ld bc,0fc01h
    add hl,bc
    res 0,l
    ld (EXEC_ARENA_ORIGIN),hl
    ld (TERM_HEAP_CURSOR),hl
    ld (hl),080h
    ld de,(DICTIONARY_NAME_POOL_BASE_PTR)
    or a
    sbc hl,de
    push hl
    call io_print_unsigned_integer
    call print_inline_high_bit_string

; BLOCK 'BYTESFREE_string' (start 0x96a4 end 0x96b0)
; Readable high-bit text: " Bytes free " (leading and trailing spaces).
BYTESFREE_string_start:
    defb 0a0h
    defb 0c2h
    defb 0f9h
    defb 0f4h
    defb 0e5h
    defb 0f3h
    defb 0a0h
    defb 0c6h
    defb 0f2h
    defb 0e5h
    defb 0e5h
    defb 0a0h
BYTESFREE_string_end:
    nop
    pop hl
    srl h
    rr l
    push hl
    srl h
    rr l
    srl h
    rr l
    push hl
    srl h
    rr l
    pop bc
    add hl,bc
    ld a,l
    and 0c0h
    ld l,a
    push hl
    add hl,de
    ld (EXEC_ARENA_LIMIT),hl
    ld (EXEC_ALLOCATION_TOP),hl
    pop hl
    sla l
    rl h
    sla l
    rl h
    ld b,h
    ld hl,DICTIONARY_ALLOCATION_BITMAP
; Mark exactly the calculated active bitmap span free; following bytes stay zero.
.initialize_dictionary_bitmap_loop:
    ld (hl),0ffh
    inc hl
    djnz .initialize_dictionary_bitmap_loop
    pop de
    ld hl,(EXEC_ARENA_ORIGIN)
    or a
    sbc hl,de
    ld (TERM_HEAP_COLLECTION_TRIGGER),hl
    ld a,05ah
    ld (LINE_EDITOR_CURSOR_LETTER),a
    xor a
    ld (CONSOLE_COPY_TO_PRINTER),a
    ld (TYPEAHEAD_COUNT),a
    ld (RDR_PUSHBACK_BYTE),a
    ld de,LINE_EDITOR_READ_INDEX
    ld (de),a
    inc de
    inc a
    ld (de),a
    inc de
    ld a,00dh
    ld (de),a
    ld b,FILE_CONTROL_BLOCK_COUNT
    ld hl,FILE_CONTROL_TABLE
    ld de,FILE_CONTROL_BLOCK_STRIDE
    ld a,000h
; Cold start releases every configured file-control slot by clearing its state.
.initialize_file_control_blocks:
    ld (hl),a
    add hl,de
    djnz .initialize_file_control_blocks
    ld hl,term_load_payload_hl
    ld (00031h),hl
    ld a,0c3h
    ld (00030h),a
    ld hl,supervisor_workspace_template
    ld de,MODULE_CURRENT_CELL
    ld bc,0000ch
    ldir
    ld hl,error_handler_root_template
    ld de,GC_ERROR_HANDLER_ROOT
    ld bc,00006h
    ldir
    ld hl,_ERROR__string_start
    ld de,DICTIONARY_INPUT_BUFFER
    ld bc,00008h
    ldir
    call intern_constant_from_input_buffer
    ld (09b1ah),hl
    ret

; BLOCK '_ERROR__string' (start 0x9749 end 0x974f)
; Readable interning seed: "?ERROR?".  Cold start copies these bytes into the
; temporary name buffer and interns the canonical error-handler constant.
_ERROR__string_start:
    defb 03fh
    defb 045h
    defb 052h
    defb 052h
    defb 04fh
    defb 052h
    defb 03fh
_ERROR__string_end:

; High-bit-set build/version stamp. Clearing bit 7 gives
; "~t5.37 28 Aug 83"; the first two display glyphs remain to be decoded.
version_stamp_high_bit:
    defb 0feh,0f4h,0b5h,0aeh,0b3h,0b7h,0a0h,0b2h
    defb 0b8h,0a0h,0c1h,0f5h,0e7h,0a0h,0b8h,0b3h
version_stamp_high_bit_end:

; BASIC starts the machine-code system with RANDOMIZE USR 38752.
; ----------------------------------------------------------------------------
; THE BASIC LOADER ENTERS HERE
; ----------------------------------------------------------------------------
;
; Cold start resets the Spectrum display/input state, prints the resident banner
; and version stamp, initializes workspace, and jumps to interpreter_entry.  All
; later restarts bypass the banner and re-enter through the protected supervisor
; path, preserving the distinction between loading the system and abandoning a
; query.
;
; Why cold start is at the end
; ----------------------------
; The source follows original binary address order, so the conceptual beginning
; appears in the final module.  BASIC actually enters here first.  Cold start:
;
;       establish protected native stack
;       copy permanent workspace templates into mutable RAM
;       partition dictionary pool and two-ended execution/heap arena
;       initialize callbacks, module roots, trail, free list, and screen state
;       patch the ?ERROR? adapter target
;       jump to interpreter_entry at 0x6003
;
; After this one-time path, normal reading proceeds from module 01.  The unusual
; placement is therefore an image-layout fact, not the runtime control order.
; Although cold_start is physically near the end of the image, it establishes the
; initial state assumed at the beginning of module 01: fixed workspace copied,
; module/root dictionaries installed, heap and execution frontiers initialized,
; trail set to permanent_empty_list, callbacks installed, then control enters
; interpreter_entry and supervisor_restart.
cold_start:
    xor a
    ld (SYSVAR_MODE),a
    ld a,030h
    ld (SYSVAR_ATTR_P),a
    ld (SYSVAR_ATTR_T),a
    jp interpreter_entry

; High-bit-set initials "DRB" (manual co-author D. R. Brough), followed by
; reserved zero bytes. This is data and is not reached from cold_start.
author_signature_high_bit:
    defb 0c4h,0d2h,0c2h    ; "DRB" with bit 7 set
    defb 000h,000h,000h
    defb 000h,000h,000h
image_end:
