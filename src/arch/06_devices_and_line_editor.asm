; -----------------------------------------------------------------------------
; Architectural module: 06_devices_and_line_editor.asm
; System file designators, RFILL, console callbacks, line editor, and type-ahead.
; Original monolithic line range: 3982-4609.
; Emitted address range: 0x7225-0x7588.
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Built-in file-designator constants and RFILL
; -----------------------------------------------------------------------------
;
; These four entries are dictionary constants, not primitive relations.  Their
; value pointers lead to SYSTEM_OBJECT_TAG descriptors rather than integer
; handler cells.  CON: and LST: are documented public names; PUN: and RDR: are
; compatibility punch/reader designators whose device operations are no-ops in this Spectrum image.

; ============================================================================
; CHAPTER 6 — DEVICES ARE CALLBACK OBJECTS, NOT SPECIAL CASES
; ============================================================================
;
; The parser and printer know only three operations: read a byte, unread a byte,
; and write a byte.  Opening a file object installs callback addresses for those
; operations.  Console, printer, cassette and RFILL can therefore share the same
; term reader and renderer.
;
; Four permanent constants name built-in device objects.  CON: is the keyboard
; and display; LST: is the Sinclair printer; PUN: is a successful discard sink;
; RDR: is a successful empty source.  The latter two are compatibility objects,
; not hidden serial drivers in this Spectrum build.
;
; Special device objects
; ----------------------
; All four permanent names use the same system-file descriptor shape:
;
;       name   direction   implemented behavior
;       CON:   input/out   Spectrum console and display channel
;       LST:   output      Sinclair printer channel
;       PUN:   output      successful discard sink
;       RDR:   input       successful source that supplies no byte
;
; Their descriptor payload is 0xFFFF, distinguishing them from opened cassette
; file objects whose payload points at the mutable file-control block.
con_file_constant_entry:
    defb TERM_TAG_CONSTANT
    defw con_file_descriptor
    defb TERM_TAG_LIST
    defw lst_file_constant_entry
lst_file_constant_entry:
    defb TERM_TAG_CONSTANT
    defw lst_file_descriptor
    defb TERM_TAG_LIST
    defw pun_file_constant_entry
pun_file_constant_entry:
    defb TERM_TAG_CONSTANT
    defw pun_file_descriptor
    defb TERM_TAG_LIST
    defw rdr_file_constant_entry
rdr_file_constant_entry:
    defb TERM_TAG_CONSTANT
    defw rdr_file_descriptor
    defb TERM_TAG_LIST
    defw rfill_constant_entry

rfill_constant_entry:
    defb TERM_TAG_CONSTANT
    defw rfill_value_cell
    defb TERM_TAG_LIST
    defw new_constant_entry
rfill_value_cell:
    defb TERM_TAG_INTEGER
    defw rfill_primitive
rfill_name:
    defb 052h,046h,049h,04ch,04ch,SYSTEM_NAME_TERMINATOR ; "RFILL"

; RFILL installs a readable-output callback that writes into the editable
; keyboard buffer, clears any old buffered input, pretty-prints the supplied
; term list without its outer parentheses, and finally reuses the READ parser
; to bind the second argument.  Variable print-name mappings are deliberately
; retained so unchanged variable spellings map back to their original cells.
; What RFILL does for the user
; ------------------------------
; The normal R primitive reads from a device callback.  RFILL temporarily makes
; an editable in-memory line look like such a device, allowing a relation to use
; the same parser after the user has edited a prompt line.
;
; Pseudocode:
;
;       show editable buffer and collect a completed line
;       install buffer_next_byte as input callback
;       install buffer_unread_byte as unread callback
;       parse requested term(s) through ordinary READ machinery
;       restore the previous device callbacks
;
; This is the bridge between the user-visible line editor and the otherwise
; device-neutral term parser.
rfill_primitive:
    ld hl,rfill_buffer_output_byte
    ld (IO_OUTPUT_CALLBACK_TARGET),hl
    ld a,IO_FORMAT_READABLE
    ld (IO_FORMAT_MODE),a
    ld a,000h
    ld (LINE_EDITOR_LENGTH),a
    ld (LINE_EDITOR_READ_INDEX),a
    ld a,04ch
    ld (LINE_EDITOR_CURSOR_LETTER),a
    ld ix,rfill_dispatch_terms
    jp primitive_argument_dispatch
rfill_dispatch_terms:
    ; Argument 1 must be a bound list/term sequence.
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
    defb rfill_dispatch_output-rfill_dispatch_terms
    defb DISPATCH_REJECT
rfill_dispatch_output:
    ; Argument 2 must be unbound so READ can construct the edited result.
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
    defb rfill_dispatch_complete-rfill_dispatch_output
rfill_dispatch_complete:
    defb rfill_prepare_buffer-rfill_dispatch_complete
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT

; ----------------------------------------------------------------------------
; RFILL TURNS THE PRINTER INTO AN INPUT SOURCE
; ----------------------------------------------------------------------------
;
; RFILL first renders terms into the editable line buffer through a special
; output callback.  It then opens an editing session on that generated text and
; finally parses the edited result through the normal reader.
;
; This is a good example of the callback architecture paying for itself: term
; formatting, editing and parsing are composed without any subsystem knowing it
; is participating in a higher-level operation.
;
rfill_prepare_buffer:
    ld hl,0ffffh
    ld (FRESH_VARIABLE_SOURCE_MAP),hl
    ld hl,(PRIMITIVE_ARG1_VALUE)
    call io_render_argument_sequence
    ret nz
    ld hl,line_editor_read_character
    ld (IO_INPUT_CALLBACK_TARGET),hl
    ld hl,line_editor_unread_character
    ld (IO_UNREAD_CALLBACK_TARGET),hl
    jp read_parse_term_into_result
print_inline_high_bit_string:
    ex (sp),hl
    push af
    call print_high_bit_string
    call console_output_newline
    pop af
    ex (sp),hl
    ret
print_high_bit_string:
    ld a,(hl)
    and 07fh
    ret z
    call console_output_byte
    inc hl
    jr print_high_bit_string
con_file_descriptor:
    defb SYSTEM_OBJECT_TAG
    defw SYSTEM_OBJECT_NO_PAYLOAD
    defb 043h,04fh,04eh,03ah,SYSTEM_NAME_TERMINATOR ; "CON:"
; ----------------------------------------------------------------------------
; CONSOLE INPUT HAS TWO LAYERS
; ----------------------------------------------------------------------------
;
; The low layer obtains bytes from the Spectrum ROM and services BREAK, STOP and
; type-ahead.  The high layer is the editable line buffer.  The parser sees only
; a byte stream, including an unread operation, and is unaware that a user may
; have moved a cursor or inserted text before pressing ENTER.
;
; This separation lets RFILL feed text through the same parser and lets the live
; test harness replace physical keyboard/display I/O without replacing lexical
; or supervisor logic.
;
console_read_character:
    ; Poll the Spectrum console channel.  Operation 6 returns a character in A;
    ; the STOP/BREAK state is checked before the character is accepted.
    ld c,DEVICE_OP_CONSOLE_IO
    ld e,0ffh
    call spectrum_io_dispatch
    or a
    ret nz
    bit 3,(iy+002h)
    ret z
console_backspace_cursor:
    push bc
    push de
    push hl
    call ROM_OUT_CURS_WITHOUT_CHECK
    ld e,008h
    ld c,DEVICE_OP_CONSOLE_IO
    call spectrum_io_dispatch
    pop hl
    pop de
    pop bc
    xor a
    ret
console_input_with_pushback:
    ; Return the oldest locally pushed-back character if one exists; otherwise
    ; block in console_read_character.  The 16-byte queue supports tokenizer
    ; look-ahead without losing type-ahead input.
    push bc
    push de
    push hl
    ld a,(TYPEAHEAD_COUNT)
    or a
    jr z,.console_wait_for_character
    ld c,a
    dec a
    ld (TYPEAHEAD_COUNT),a
    ld de,TYPEAHEAD_BUFFER
    ld a,(de)
    ld hl,TYPEAHEAD_BUFFER+1
    ld b,000h
    ldir
    jr .console_input_restore_registers
; Busy-wait until the Spectrum channel returns a real character.
.console_wait_for_character:
    call console_read_character
    or a
    jr z,.console_wait_for_character
.console_input_restore_registers:
    pop hl
    pop de
    pop bc
    ret
console_output_newline:
    ld a,00dh
console_output_byte:
    push de
    push bc
    push af
    ld c,DEVICE_OP_CONSOLE_IO
    ld e,a
    call spectrum_io_dispatch
    ld a,(CONSOLE_COPY_TO_PRINTER)
    or a
    jr z,console_poll_pending_input
    ld c,DEVICE_OP_PRINTER_OUTPUT
    call spectrum_io_dispatch
    jr console_poll_pending_input
; ----------------------------------------------------------------------------
; POLLING WITHOUT LOSING THE KEY
; ----------------------------------------------------------------------------
;
; Every logical goal passes here.  BREAK raises the interpreter's Break error;
; STOP suspends until another key; ordinary early keystrokes are retained in a
; small type-ahead area so that computation does not make the interface feel
; unresponsive.
;
; The routine must preserve the execution registers expected by the interpreter
; loop.  Its visible effect is therefore only a possible error, pause, or queued
; input byte.
;
; Console control-state table
; ---------------------------
;       condition             action
;       STOP pressed          pause until another key, then resume
;       BREAK pressed         signal the interpreter "Break!" error
;       printer-copy enabled  echo display output to the printer channel
;       key already queued    return queued byte before scanning hardware
;       ordinary key          translate Spectrum key and return its character
;
; The routine checks these in priority order.  A queued byte is semantic input,
; whereas STOP/BREAK and printer-copy are console-control side effects.
console_service_break_and_typeahead:
    push de
    push bc
    push af
; After output, service BREAK/STOP and preserve ordinary type-ahead bytes.
console_poll_pending_input:
    call console_read_character
    or a
    jr z,.console_service_return
    cp 018h
    jp z,signal_break_error
    cp 0e2h
    jr z,.console_wait_while_stopped
    ld b,a
    ld a,(TYPEAHEAD_COUNT)
    cp 010h
    jr z,.console_typeahead_overflow
    push hl
    ld l,a
    inc a
    ld (TYPEAHEAD_COUNT),a
    ld a,b
    ld h,000h
    ld de,TYPEAHEAD_BUFFER
    add hl,de
    ld (hl),a
    pop hl
    jr .console_service_return
.console_typeahead_overflow:
    call console_beep
    jr .console_service_return
.console_wait_while_stopped:
    call console_input_with_pushback
    cp 018h
    jp z,signal_break_error
.console_service_return:
    pop af
    pop bc
    pop de
    ret
lst_file_descriptor:
    defb SYSTEM_OBJECT_TAG
    defw SYSTEM_OBJECT_NO_PAYLOAD
    defb 04ch,053h,054h,03ah,SYSTEM_NAME_TERMINATOR ; "LST:"
lst_output_byte:
    ; Mirror one output byte to the Sinclair printer channel (operation 5),
    ; after servicing BREAK and pending console state via console_service_break_and_typeahead.
    call console_service_break_and_typeahead
    push bc
    push de
    ld e,a
    ld c,DEVICE_OP_PRINTER_OUTPUT
    call spectrum_io_dispatch
    pop de
    pop bc
    cp a
    ret
; Compatibility warning: PUN: is not a Spectrum serial output implementation.
; In this image it accepts output and discards it while reporting success.  Do
; not infer hardware transmission from the historical device name.
pun_file_descriptor:
    defb SYSTEM_OBJECT_TAG
    defw SYSTEM_OBJECT_NO_PAYLOAD
    defb 050h,055h,04eh,03ah,SYSTEM_NAME_TERMINATOR ; "PUN:"

pun_output_byte:
    ; PUN: is retained as an abstract punch designator, but DEVICE_OP 4 has no
    ; Spectrum implementation in this image.  The byte is therefore discarded
    ; after servicing BREAK and pending console state.
    call console_service_break_and_typeahead
    push bc
    push de
    ld e,a
    ld c,DEVICE_OP_PUNCH_OUTPUT
    call spectrum_io_dispatch
    pop de
    pop bc
    cp a
    ret

; Compatibility warning: RDR: is not implemented serial input.  It is a successful
; empty source which returns no byte.  Opened cassette files use a different
; descriptor path and are fully implemented in module 12.
rdr_file_descriptor:
    defb SYSTEM_OBJECT_TAG
    defw SYSTEM_OBJECT_NO_PAYLOAD
    defb 052h,044h,052h,03ah,SYSTEM_NAME_TERMINATOR ; "RDR:"
rdr_input_byte:
    ; One-byte pushback sits at 0x9A84.  When empty, DEVICE_OP 3 falls through
    ; the Spectrum dispatcher and returns A=0/Z: this build has no physical RDR:
    ; backend.  A locally unread byte is still returned normally.
    push hl
    ld hl,RDR_PUSHBACK_BYTE
    ld a,(hl)
    or a
    jr z,.rdr_poll_empty_source
    ld (hl),000h
    cp a
    pop hl
    ret
.rdr_poll_empty_source:
    ld c,DEVICE_OP_READER_INPUT
    call spectrum_io_dispatch
    pop hl
    cp a
    ret
rdr_unread_byte:
    ; Save one look-ahead byte for the next compatibility RDR: callback read.
    ld (RDR_PUSHBACK_BYTE),a
    ret
; The console reader owns a 250-byte editable line buffer.  READ_INDEX marks the
; next character returned to the parser; LENGTH is the entered/editable extent.
; Before ENTER, cursor movement, insertion and deletion redraw only the affected
; suffix.  After ENTER, excess terms remain available to later parser calls.
; ----------------------------------------------------------------------------
; THE LINE EDITOR IS A GAPLESS ARRAY WITH A MOVABLE CURSOR
; ----------------------------------------------------------------------------
;
; The editor stores one contiguous byte string and shifts suffixes on insert or
; delete.  On a 48K machine this is simpler and smaller than maintaining a gap
; buffer, and input lines are short enough that the O(n) movement is acceptable.
;
; Cursor movement is mirrored on screen by reprinting the affected suffix and
; restoring the cursor with backspace control characters.  Boundary attempts
; beep rather than wrapping or corrupting the buffer.
;
; Spectrum ROM UI assumptions
; ---------------------------
; The line editor relies on standard 48K ROM conventions: cursor mode in MODE,
; lower-screen size in DF_SZ, channel pointers in CHANS/CURCHL, and ROM routines
; that draw or erase the cursor.  A general Z80 reader need not know their
; implementation; treat them as a small terminal API whose mutable state must be
; preserved around editing.  Exact system-variable addresses are named in
; module 00 and the supplied Spectrum manual documents their visual behavior.
line_editor_reset:
    xor a
    ld (LINE_EDITOR_LENGTH),a
    ld (LINE_EDITOR_READ_INDEX),a
    ld a,05ah
    ld (LINE_EDITOR_CURSOR_LETTER),a
    ret
; Line-editor state machine (pseudocode)
; ------------------------------------
; This routine interleaves display repair with buffer editing, so read its states
; before its instructions:
;
;       loop:
;           draw cursor at logical insertion point
;           key = read_console_key()
;           erase cursor without disturbing surrounding text
;
;           switch key:
;               LEFT/RIGHT:
;                   move insertion cursor within [line_start, line_end]
;               DELETE:
;                   if cursor > line_start:
;                       cursor--
;                       shift bytes cursor+1 .. line_end left
;                       line_end--
;                       redraw changed suffix
;               printable character:
;                   if buffer full: beep and continue
;                   shift suffix right by one
;                   store key at cursor; cursor++; line_end++
;                   redraw changed suffix
;               ENTER:
;                   append carriage return; return completed character stream
;               BREAK:
;                   signal Break! through the normal error path
;               control/edit command:
;                   execute command-specific cursor or buffer transformation
;
; Invariants maintained after every branch:
;
;       line_start <= cursor <= line_end <= buffer_limit
;       bytes [line_start,line_end) are the logical line
;       the screen is a rendering of that line, never the authoritative copy
;
; The many ROM calls below implement the “draw/erase/redraw” parts; the memory
; moves implement the state transitions.
; Keystroke trace
; ---------------
; Start: buffer="", length=0, insertion cursor=0, read index=0.
;
;   key `A`:
;       buffer="A", length=1, insertion cursor=1
;   cursor-left command:
;       buffer="A", length=1, insertion cursor=0
;   key `B` (insert, not overwrite):
;       buffer="BA", length=2, insertion cursor=1
;   ENTER:
;       editing finishes; read index resets to 0
;   successive callback reads:
;       returns `B` (read index 1), then `A` (read index 2), then CR
;
; Display cursor letters and ROM redraw calls are side effects of the same state
; changes; the logical buffer evolution above is the invariant to follow.
line_editor_read_character:
    push bc
    push hl
    push de
    ld c,b
line_editor_fetch_buffered_character:
    ld a,(LINE_EDITOR_LENGTH)
    ld b,a
    ld a,(LINE_EDITOR_READ_INDEX)
    cp b
    jr nz,line_editor_prepare_return
    ld a,(LINE_EDITOR_CURSOR_LETTER)
    push af
    cp 05ah
    jr nz,.line_editor_open_session
    inc c
    dec c
    jr z,.line_editor_open_session
    ld l,c
    ld h,000h
    call io_print_signed_integer
; No entered bytes remain: switch from buffer playback to interactive editing.
.line_editor_open_session:
    pop hl
    push bc
    ld de,LINE_EDITOR_BUFFER
    ld a,(LINE_EDITOR_LENGTH)
    ld c,a
    ld b,000h
    ld a,h
line_editor_check_entered_line:
    ld hl,line_editor_handle_delete
    push hl
    ld hl,line_editor_command_table
; Search the compact command table before treating the key as ordinary input.
line_editor_begin_edit:
    cp (hl)
    jr nz,line_editor_read_key
    inc hl
    ld a,(hl)
    inc hl
; ----------------------------------------------------------------------------
; EDIT KEYS ARE INTERPRETED BEFORE PRINTABLE CHARACTERS
; ----------------------------------------------------------------------------
;
; ENTER accepts the line, DELETE removes the character to the left, and the
; movement/insert commands update both cursor and buffer.  Z and L are tiny
; command aliases retained from the original interface.  Printable input takes
; the insertion path only after control-key dispatch declines it.
;
; The parser receives a clean character stream later.  None of these editing
; commands become micro-PROLOG tokens.
;
line_editor_command_loop:
    ld h,(hl)
    ld l,a
    jp (hl)
line_editor_read_key:
    push af
    ld a,(hl)
    or a
    jr z,.line_editor_handle_enter
    pop af
    inc hl
    inc hl
    inc hl
    jr line_editor_begin_edit
.line_editor_handle_enter:
    pop af
    pop hl
    call console_beep
line_editor_handle_delete:
    call console_input_with_pushback
    call ascii_fold_lowercase_to_uppercase
    jr line_editor_check_entered_line
; Commit ENTER by appending carriage return and resetting the playback cursor.
line_editor_finish_line:
    call line_editor_echo_suffix
    call console_output_newline
    ld a,00dh
    ld (de),a
    ld a,c
    inc a
    ld (LINE_EDITOR_LENGTH),a
    xor a
    ld (LINE_EDITOR_READ_INDEX),a
    ld a,05ah
    ld (LINE_EDITOR_CURSOR_LETTER),a
    pop hl
    pop bc
    jr line_editor_fetch_buffered_character
; Return one byte from the committed line while preserving the remaining text.
line_editor_prepare_return:
    ld c,a
    inc a
    ld (LINE_EDITOR_READ_INDEX),a
    ld b,000h
    ld hl,LINE_EDITOR_BUFFER
    add hl,bc
    ld a,(hl)
    pop de
    pop hl
    pop bc
    cp a
    ret
line_editor_unread_character:
    push hl
    ld hl,LINE_EDITOR_READ_INDEX
    dec (hl)
    pop hl
    ret
; Table entry format is key byte followed by a little-endian handler word.
; A zero key terminates the scan.  These seven bytes were executable-looking
; garbage in the original linear disassembly.
line_editor_command_table:
    defb 05ah    ; "Z"
    defw line_editor_command_z
    defb 04ch    ; "L"
    defw line_editor_command_l
    defb 000h    ; end marker
line_editor_move_right:
    ld a,b
    cp c
    jp z,console_beep
    inc b
    ld a,(de)
    inc de
    call console_output_byte
    call console_backspace_cursor
    ret
line_editor_move_left:
    ld a,b
    or a
    jp z,console_beep
    dec b
    dec de
    ld a,(de)
    call console_output_byte
    call console_emit_backspace
    call console_emit_backspace
    call console_backspace_cursor
    ret
toggle_printer_mirroring:
    ld a,(CONSOLE_COPY_TO_PRINTER)
    cpl
    ld (CONSOLE_COPY_TO_PRINTER),a
    ret
line_editor_dispatch_control_key:
    ld hl,.line_editor_prompt_string
    call print_high_bit_string
    call console_backspace_cursor
line_editor_dispatch_printable_key:
    call console_input_with_pushback
    cp 00dh
    jp z,line_editor_finish_line
    cp 00ch
    jr nz,.line_editor_key_left
    call line_editor_delete_left
    jr line_editor_dispatch_printable_key
.line_editor_key_left:
    cp 008h
    jr nz,.line_editor_key_right
    call line_editor_move_left
    jr line_editor_dispatch_printable_key
.line_editor_key_right:
    cp 0cch
    jr nz,.line_editor_key_delete
    call toggle_printer_mirroring
    jr line_editor_dispatch_printable_key
.line_editor_key_delete:
    cp 009h
    jr nz,.line_editor_key_insert
    call line_editor_move_right
    jr line_editor_dispatch_printable_key
.line_editor_key_insert:
    cp 018h
    jp z,signal_break_error
    cp 020h
    jr nc,.line_editor_reject_key
    add a,040h
    inc c
    jr z,.line_editor_accept_key
    push af
    ld a,040h
    call line_editor_insert_character
    pop af
.line_editor_reject_key:
    inc c
    jr z,.line_editor_accept_key
    call line_editor_insert_character
    jr line_editor_dispatch_printable_key
.line_editor_accept_key:
    dec c
    call console_beep
    jr line_editor_dispatch_printable_key
; Dot prompt encoded for print_high_bit_string: ordinary ASCII followed by 0.
.line_editor_prompt_string:
    defb 02eh,000h    ; ".", terminator
; Insert at the cursor by shifting the untouched suffix one byte to the right.
line_editor_insert_character:
    call console_output_byte
    push de
    push bc
    push af
    ld a,c
    sub b
    push af
    add a,e
    ld l,a
    jr nc,.line_editor_shift_suffix_right
    inc d
.line_editor_shift_suffix_right:
    ld h,d
    ld e,l
    dec hl
    pop af
    ld c,a
    ld b,000h
    jr z,.line_editor_store_inserted_character
    lddr
.line_editor_store_inserted_character:
    pop af
    pop bc
    pop de
    ld (de),a
    inc de
    inc b
    ld a,b
    cp c
    call line_editor_redraw_after_edit
    ret
; DELETE removes the byte left of the cursor and redraws the changed suffix.
line_editor_delete_left:
    ld a,b
    or a
    jp z,console_beep
    dec de
    dec b
    call console_emit_backspace
    jr line_editor_shift_suffix_left
console_emit_backspace:
    ld a,008h
    call console_output_byte
    ret
line_editor_shift_suffix_left:
    ld a,c
    sub b
    jr z,.line_editor_finish_delete
    push hl
    push de
    push bc
    ld c,a
    ld b,000h
    ld h,d
    ld l,e
    inc hl
    ldir
    pop bc
    pop de
    pop hl
.line_editor_finish_delete:
    dec c
    call line_editor_redraw_after_edit
    ret
line_editor_command_z:
    ld c,b
    jp line_editor_dispatch_control_key
line_editor_command_l:
    ld a,b
    or b
    call nz,console_output_newline
    ld b,000h
    ld de,LINE_EDITOR_BUFFER
    call line_editor_redraw_after_edit
    ld b,000h
    ld de,LINE_EDITOR_BUFFER
    jp line_editor_dispatch_printable_key
line_editor_echo_suffix:
    ld a,b
    cp c
    jr z,.line_editor_echo_character
    ld a,(de)
    call console_output_byte
    inc b
    inc de
    jr line_editor_echo_suffix
.line_editor_echo_character:
    ld a,020h
    jp console_output_byte
; Echo the changed suffix, erase stale screen text and restore cursor position.
line_editor_redraw_after_edit:
    push de
    push bc
    ld a,020h
    call console_output_byte
    call line_editor_echo_suffix
    pop bc
    ld a,c
    sub b
    inc a
    inc a
    push bc
    ld b,a
    call console_emit_backspace
.line_editor_restore_cursor:
    dec b
    jr z,.line_editor_beep_at_boundary
    dec de
    call console_emit_backspace
    jr .line_editor_restore_cursor
.line_editor_beep_at_boundary:
    call console_backspace_cursor
    pop bc
    pop de
    ret
console_beep:
    ld a,0ceh
    jp console_output_byte
; RFILL captures readable printer output directly into the editable line buffer.
rfill_buffer_output_byte:
    push hl
    push de
    push bc
    push af
    ld a,(LINE_EDITOR_LENGTH)
    inc a
    jr z,.rfill_drop_overflow_byte
    ld (LINE_EDITOR_LENGTH),a
    ld (LINE_EDITOR_READ_INDEX),a
    ld c,a
    ld b,000h
    ld hl,LINE_EDITOR_LENGTH
    add hl,bc
    pop af
    ld (hl),a
    jr .rfill_output_restore_registers
.rfill_drop_overflow_byte:
    pop af
.rfill_output_restore_registers:
    pop bc
    pop de
    pop hl
    ret
; NEW is an ordinary dictionary entry whose primitive value is the main
; interpreter reinitialisation entry. The root dictionary reaches it later in
; the circular built-in chain, after RFILL.
new_constant_entry:
    defb TERM_TAG_CONSTANT
    defw new_value_cell
    defb TERM_TAG_LIST
    defw open_constant_entry
new_value_cell:
    defb TERM_TAG_INTEGER
    defw interpreter_entry
new_name:
    defb 04eh,045h,057h,SYSTEM_NAME_TERMINATOR ; "NEW"

