; -----------------------------------------------------------------------------
; Architectural module: 05_lexical_tables.asm
; Lexical classification table and generated variable-name alphabet.
; Original monolithic line range: 3818-3981.
; Emitted address range: 0x710D-0x7224.
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Lexical character classes and generated variable-name alphabet
; -----------------------------------------------------------------------------
; The byte at 0x710D is not executable code.  It is the number of base variable
; print names.  The following 128 bytes are indexed directly by ASCII code.
; input_classify_character returns the selected byte in C, and the same flags
; are used by io_constant_needs_quotes to decide whether a stored spelling can
; be emitted without quotes.
; ============================================================================
; CHAPTER 5 — THE READER'S ALPHABET
; ============================================================================
;
; This module is almost entirely data, but it controls a surprising amount of
; visible behavior.  The 128-byte table assigns orthogonal lexical roles to
; every ASCII character.  The tokenizer consults it to form tokens; the printer
; consults it to decide whether a constant may safely be written without quotes.
;
; A character can belong to more than one class.  '-' is simultaneously graphic,
; alphanumeric and a possible numeric sign.  X/Y/Z/x/y/z are alphanumeric and
; variable prefixes.  This overlap is intentional and is resolved by context,
; not by forcing each character into one exclusive category.
;
; The six prefix characters also define generated variable names.  After X, Y,
; Z, x, y, z the printer repeats the sequence with numeric suffixes.
;
variable_print_prefix_count:
    ; Six generated prefixes are present in the classification table.  Keeping
    ; the count beside the table makes both parser acceptance and printer naming
    ; data-driven and prevents the two alphabets from diverging.
    defb VARIABLE_PRINT_PREFIX_COUNT
; ----------------------------------------------------------------------------
; Each byte below is a bit set, not an enum:
;
;   bit 0  alphanumeric     bit 4  forced single-character token
;   bit 1  decimal digit    bit 5  separator
;   bit 2  list syntax      bit 6  legal variable prefix
;   bit 3  graphic token    bit 7  possible leading sign
;
; Keeping this as data makes lexical policy compact and ensures reader and
; writer cannot silently drift apart.
;
; Representative lexical-class entries
; -----------------------------------
; The table stores combinable bits rather than one exclusive class:
;
;       character   important bits                 consequence
;       '-'         alpha + graphic + sign         name, operator, or -number
;       'X'         alpha + variable-prefix        variable only if rest digits
;       '('         structural                     starts a list
;       space       separator                      ends current token
;       '@'         graphic                        operator; escape only in quotes
;
; Combined bits explain why the scanner sometimes performs one-character
; lookahead instead of choosing a token kind from a single enum value.
; Three complete lexical classifications
; ----------------------------------------
; `-` has ALPHANUMERIC, GRAPHIC and POSSIBLE_SIGN bits.  Lookahead decides whether
; it begins a negative number (`-12`) or belongs to a name/graphic token (`-A`,
; `--`).
;
; `x` has ALPHANUMERIC and VARIABLE_PREFIX bits.  It is a variable only when all
; remaining token characters are digits; `x12` is a variable, `xray` a constant.
;
; `(` has STRUCTURAL status.  It terminates a preceding token even without a
; separator and immediately begins list parsing; it never joins that token.
lexical_character_class_table:
    ; Bit layout (roles may be combined):
    ;   0 alphanumeric, 1 digit, 2 structural, 3 graphic,
    ;   4 single token, 5 separator, 6 variable prefix, 7 numeric sign.
    ; The table is indexed by the complete 7-bit ASCII range.
    defb 000h    ; ASCII 00: ignored/NUL
    defb LEX_CLASS_SEPARATOR,LEX_CLASS_SEPARATOR,LEX_CLASS_SEPARATOR,LEX_CLASS_SEPARATOR
    defb LEX_CLASS_SEPARATOR,LEX_CLASS_SEPARATOR,LEX_CLASS_SEPARATOR,LEX_CLASS_SEPARATOR
    defb LEX_CLASS_SEPARATOR,LEX_CLASS_SEPARATOR,LEX_CLASS_SEPARATOR,LEX_CLASS_SEPARATOR
    defb LEX_CLASS_SEPARATOR,LEX_CLASS_SEPARATOR,LEX_CLASS_SEPARATOR,LEX_CLASS_SEPARATOR
    defb LEX_CLASS_SEPARATOR,LEX_CLASS_SEPARATOR,LEX_CLASS_SEPARATOR,LEX_CLASS_SEPARATOR
    defb LEX_CLASS_SEPARATOR,LEX_CLASS_SEPARATOR,LEX_CLASS_SEPARATOR,LEX_CLASS_SEPARATOR
    defb LEX_CLASS_SEPARATOR,LEX_CLASS_SEPARATOR,LEX_CLASS_SEPARATOR,LEX_CLASS_SEPARATOR
    defb LEX_CLASS_SEPARATOR,LEX_CLASS_SEPARATOR,LEX_CLASS_SEPARATOR,LEX_CLASS_SEPARATOR
    ; ASCII 01..20
    defb LEX_CLASS_GRAPHIC    ; !
    defb LEX_CLASS_SINGLE_TOKEN    ; quote
    defb LEX_CLASS_GRAPHIC,LEX_CLASS_GRAPHIC,LEX_CLASS_GRAPHIC,LEX_CLASS_GRAPHIC
    defb LEX_CLASS_GRAPHIC    ; # $ % & '
    defb LEX_CLASS_STRUCTURAL,LEX_CLASS_STRUCTURAL    ; ( )
    defb LEX_CLASS_GRAPHIC,LEX_CLASS_GRAPHIC,LEX_CLASS_GRAPHIC    ; * + ,
    defb 089h    ; -: alpha + graphic + sign
    defb LEX_CLASS_GRAPHIC,LEX_CLASS_GRAPHIC    ; . /
    defb LEX_CLASS_DIGIT,LEX_CLASS_DIGIT,LEX_CLASS_DIGIT,LEX_CLASS_DIGIT,LEX_CLASS_DIGIT
    defb LEX_CLASS_DIGIT,LEX_CLASS_DIGIT,LEX_CLASS_DIGIT,LEX_CLASS_DIGIT,LEX_CLASS_DIGIT
    ; 0..9
    defb LEX_CLASS_GRAPHIC,LEX_CLASS_GRAPHIC    ; : ;
    defb LEX_CLASS_SINGLE_TOKEN    ; <
    defb LEX_CLASS_GRAPHIC    ; =
    defb LEX_CLASS_SINGLE_TOKEN    ; >
    defb LEX_CLASS_GRAPHIC,LEX_CLASS_GRAPHIC    ; ? @
    defb LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC
    defb LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC
    defb LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC
    defb LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC
    defb LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC
    defb LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC
    defb LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC
    defb LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC    ; A..W
    defb 041h,041h,041h    ; X Y Z: alpha + variable prefix
    defb LEX_CLASS_SINGLE_TOKEN    ; [
    defb LEX_CLASS_GRAPHIC    ; backslash
    defb LEX_CLASS_SINGLE_TOKEN    ; ]
    defb LEX_CLASS_GRAPHIC    ; ^
    defb 009h    ; _: alpha + graphic
    defb LEX_CLASS_GRAPHIC    ; `
    defb LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC
    defb LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC
    defb LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC
    defb LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC
    defb LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC
    defb LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC
    defb LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC
    defb LEX_CLASS_ALPHANUMERIC,LEX_CLASS_ALPHANUMERIC    ; a..w
    defb 041h,041h,041h    ; x y z
    defb LEX_CLASS_SINGLE_TOKEN    ; {
    defb LEX_CLASS_STRUCTURAL    ; |
    defb LEX_CLASS_SINGLE_TOKEN    ; }
    defb LEX_CLASS_GRAPHIC    ; ~
    defb 000h    ; DEL ignored
variable_print_overflow_character:
    defb VARIABLE_PRINT_OVERFLOW_CHAR    ; printed three times after 63 names
; Address-order note: this is device code
; --------------------------------------
; These selectors follow the lexical table only because that is where the bytes
; occur in the original image.  Conceptually they belong to the callback/device
; layer developed in modules 06 and 12.  They patch IO_OUTPUT_CALLBACK_TARGET so
; the renderer above can remain independent of console, printer, discard sink,
; or cassette file implementation.
io_select_output_target:
    ; In: HL = constant descriptor selected as output file, A = formatting mode.
    ; Out: IO_OUTPUT_CALLBACK_TARGET points to a byte-output routine; Z means success.
    ;
    ; Built-in descriptors are recognized by address.  Other constants must be
    ; opened file objects (tag 0x06, state FILE_STATE_WRITING); their callback is
    ; file_output_byte at 0x9602.  A mismatched or unopened name signals File
    ; error through the common error path.
    ld (IO_FORMAT_MODE),a
    ex de,hl
    ld hl,con_file_descriptor
    or a
    sbc hl,de
    jr nz,.io_try_printer_target
    ld hl,console_output_byte
; Publish the selected output routine by rewriting only the JP target word.
.io_install_output_callback:
    ld (IO_OUTPUT_CALLBACK_TARGET),hl
    ret
.io_try_printer_target:
    ld hl,lst_file_descriptor
    or a
    sbc hl,de
    jr nz,.io_try_punch_target
    ld hl,lst_output_byte
    jr .io_install_output_callback
.io_try_punch_target:
    ld hl,pun_file_descriptor
    or a
    sbc hl,de
    jr nz,.io_require_open_output_file
    ld hl,pun_output_byte
    jr .io_install_output_callback
; Non-built-in output designators must name an open writing file object.
.io_require_open_output_file:
    ex de,hl
    ld a,(hl)
    cp 006h
    jp nz,signal_file_error
    call term_load_payload_hl
    ld (ACTIVE_FILE_CONTROL_BLOCK),hl
    ld a,(hl)
    cp 002h
    jp nz,signal_file_error
    ld hl,file_output_callback
    jr .io_install_output_callback
; Provisional file-object model
; -----------------------------
; Input selection recognizes three forms whose descriptors are defined later:
;
;       CON: / RDR: special permanent device objects  -> module 06
;       opened file object with control-block pointer -> module 12
;       RFILL temporary editable-buffer source        -> module 06
;
; For now, read this routine as “validate source object, then install its byte
; callback and unread callback.”  The physical behavior follows in those modules.
io_select_input_source:
    ; In: HL = constant descriptor selected as input file.
    ; Out: IO_INPUT_CALLBACK_TARGET = input-byte callback, IO_UNREAD_CALLBACK_TARGET =
    ; push-back callback, and for CON: IO_OUTPUT_CALLBACK_TARGET = console output callback used by the read prompt.
    ; Opened user files must be state FILE_STATE_READING.
    ex de,hl
    ld hl,con_file_descriptor
    or a
    sbc hl,de
    jr nz,.io_try_reader_source
    ld hl,line_editor_read_character
    ld (IO_INPUT_CALLBACK_TARGET),hl
    ld hl,line_editor_unread_character
    ld (IO_UNREAD_CALLBACK_TARGET),hl
    ld hl,console_output_byte
    ld (IO_OUTPUT_CALLBACK_TARGET),hl
    ret
.io_try_reader_source:
    ld hl,rdr_file_descriptor
    or a
    sbc hl,de
    jr nz,.io_require_open_input_file
    ld hl,rdr_input_byte
    ld (IO_INPUT_CALLBACK_TARGET),hl
    ld hl,rdr_unread_byte
    ld (IO_UNREAD_CALLBACK_TARGET),hl
    ret
; Non-built-in input designators must name an open reading file object.
.io_require_open_input_file:
    ex de,hl
    ld a,(hl)
    cp 006h
    jp nz,signal_file_error
    call term_load_payload_hl
    ld (ACTIVE_FILE_CONTROL_BLOCK),hl
    ld a,(hl)
    cp 001h
    jp nz,signal_file_error
    ld hl,file_input_callback
    ld (IO_INPUT_CALLBACK_TARGET),hl
    ld hl,file_unread_or_refill_callback
    ld (IO_UNREAD_CALLBACK_TARGET),hl
    ret
