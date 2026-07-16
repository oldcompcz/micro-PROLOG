; -----------------------------------------------------------------------------
; Architectural module: 04_term_io_and_parser.asm
; Term output, parser, tokenizer, variable naming, and file-oriented read/write primitives.
; Original monolithic line range: 2364-3817.
; Emitted address range: 0x6993-0x710C.
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Term output and file-writing primitives
; -----------------------------------------------------------------------------
;
; W and WRITE are the file equivalents of P and PP.  Both require a constant
; file designator followed by a list/sequence term.  The only semantic
; difference is the formatting mode selected before entering the shared term
; printer: W emits raw constants and no final newline, while WRITE emits
; re-readable syntax and terminates the record with ENTER.

; ============================================================================
; CHAPTER 4 — TURNING TERM GRAPHS INTO TEXT, AND TEXT BACK INTO GRAPHS
; ============================================================================
;
; Reader and writer deliberately share more machinery than their sizes suggest.
; Both use callback vectors, both consult the same lexical classification table,
; and both preserve variable identity with small address maps.
;
; The writer has two personalities.  Raw output reproduces a constant's bytes.
; Readable output chooses quoting and escapes so that the reader will recover
; the same term.  The reader, conversely, interns constants immediately, so the
; result of parsing is already in executable dictionary-linked form.
;
; ----------------------------------------------------------------------------
; W AND WRITE ARE THIN FRONTS
; ----------------------------------------------------------------------------
;
; Their dispatch tables validate a file object and a sequence of terms.  The
; actual renderer below knows nothing about console, printer or cassette: it
; emits bytes through the currently installed output callback.
;
; Layout convention used throughout this chapter
; ----------------------------------------------
; Public built-ins are introduced in storage order:
;
;       dictionary CONSTANT cell
;       linked next-entry cell
;       mutable/canonical value cell containing the primitive address
;       FF-terminated printed name
;       executable handler
;       compact argument-dispatch states
;
; Thus the W relation object appears first below, followed shortly by the code
; that implements it.  The same pattern repeats for WRITE, READ, INTOK, LISTP,
; and later primitive clusters.
w_constant_entry:
    defb TERM_TAG_CONSTANT
    defw w_value_cell
    defb TERM_TAG_LIST
    defw write_constant_entry
w_value_cell:
    defb TERM_TAG_INTEGER
    defw w_primitive
w_name:
    defb 057h,SYSTEM_NAME_TERMINATOR ; "W"

w_primitive:
    ld ix,w_dispatch_file
    jp primitive_argument_dispatch

; State 0: argument 1 must be a constant file name.
w_dispatch_file:
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb w_dispatch_terms-w_dispatch_file
    defb DISPATCH_REJECT,DISPATCH_REJECT
; State 1: argument 2 is the term sequence; the dispatcher classifies a list as
; an ordinary bound structure.
w_dispatch_terms:
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
    defb w_dispatch_complete-w_dispatch_terms
    defb DISPATCH_REJECT
; End of arguments: enter the raw-format implementation.
w_dispatch_complete:
    defb w_write_terms-w_dispatch_complete
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT

w_write_terms:
    ld hl,(PRIMITIVE_ARG1_VALUE)
    ld a,IO_FORMAT_RAW
    call io_select_output_target
    ret nz
    jr io_write_sequence_common
write_constant_entry:
    defb TERM_TAG_CONSTANT
    defw write_value_cell
    defb TERM_TAG_LIST
    defw read_constant_entry
write_value_cell:
    defb TERM_TAG_INTEGER
    defw write_primitive
write_name:
    defb 057h,052h,049h,054h,045h,SYSTEM_NAME_TERMINATOR ; "WRITE"

write_primitive:
    ld ix,write_dispatch_file
    jp primitive_argument_dispatch

; WRITE has the same two-argument shape as W.
write_dispatch_file:
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb write_dispatch_terms-write_dispatch_file
    defb DISPATCH_REJECT,DISPATCH_REJECT
write_dispatch_terms:
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
    defb write_dispatch_complete-write_dispatch_terms
    defb DISPATCH_REJECT
write_dispatch_complete:
    defb write_write_terms-write_dispatch_complete
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT

write_write_terms:
    ld hl,(PRIMITIVE_ARG1_VALUE)
    ld a,IO_FORMAT_READABLE
    call io_select_output_target
    ret nz
io_write_sequence_common:
    ; Reset the variable-print-name map.  0xFFFF means that no variable has yet
    ; been assigned X, Y, Z, ... for this output operation.
    ld hl,0ffffh
    ld (FRESH_VARIABLE_SOURCE_MAP),hl
    ld hl,(PRIMITIVE_ARG2_VALUE)
    call io_render_argument_sequence
    ret nz
    ld a,(IO_FORMAT_MODE)
    or a
    ret z
    call io_emit_enter
    cp a
    ret
io_render_argument_sequence:
    ; Contract:
    ;   HL = first term of the sequence to print
    ;   0x986C = selected byte-output callback
    ;   0x986E = IO_FORMAT_RAW or IO_FORMAT_READABLE
    ; Returns Z on a completely printed sequence; malformed tails fail.
    ;
    ; The printer walks list cells recursively.  A space is emitted between
    ; adjacent elements, while an improper-list tail is introduced by '|'.
    ld ix,(EXEC_CURRENT_FRAME)
    ld e,(ix+EXEC_FRAME_LOCAL_BASE)
    ld d,(ix+EXEC_FRAME_LOCAL_BASE+1)
    call term_dereference_hl
    ld b,000h
    cp 010h
    ret z
    cp 003h
    jr nz,io_render_term
io_render_list_items:
    ; HL identifies a proper-list cell.  Render its head, then dereference the
    ; tail cell.  Proper tails loop with a separating space; END terminates;
    ; every other tail is emitted after the explicit micro-PROLOG bar.
    call term_load_payload_hl
    push hl
    call io_render_term
    pop hl
    inc hl
    inc hl
    inc hl
    call term_dereference_hl
    cp 003h
    jr nz,.io_render_improper_tail
    ld a,020h
    call IO_OUTPUT_CALLBACK_JUMP
    jr io_render_list_items
.io_render_improper_tail:
    cp 010h
    ret z
    ld a,07ch
    call IO_OUTPUT_CALLBACK_JUMP
; ----------------------------------------------------------------------------
; ONE RENDERER, DISPATCHED BY TERM TAG
; ----------------------------------------------------------------------------
;
; Dereferencing happens before printing.  A bound variable therefore prints its
; value, while an unbound variable receives a generated name.  Lists are walked
; as proper spines until END; a non-list tail introduces the vertical bar of an
; improper list.
;
; Integer and floating-point rendering avoid Spectrum BASIC formatting so that
; the exact micro-PROLOG lexical rules remain under interpreter control.
;
; Term-rendering dispatch map
; ---------------------------
; After dereferencing, the tag chooses exactly one formatter:
;
;       UNBOUND_VARIABLE  -> generated X, Y, Z, x, y, z, X1... name
;       LIST              -> '(' elements ['|' tail] ')'
;       INTEGER           -> signed decimal integer
;       FLOAT             -> canonical decimal/scientific spelling
;       CONSTANT          -> raw bytes or readable quoted spelling
;       END               -> empty-list/list terminator handling
;       anything else     -> system abort: corrupt term graph
;
; Keeping this table in mind is easier than following the branch chain on a
; first pass.
; Raw versus readable rendering
; -----------------------------
;   term                         raw mode              readable mode
;   ---------------------------  --------------------  ------------------------
;   constant `The man`           The man               "The man"
;   constant containing CR       literal control byte  "@M"-style escaped form
;   improper list (a b|X)        structural raw form   (a b|X)
;   unbound variable cell        generated variable    same stable generated name
;
; Raw mode favors direct device representation.  Readable mode quotes or escapes
; exactly when the lexical table says that reparsing the unquoted bytes would
; change token boundaries or identity.
io_render_term:
    ; Generic readable/raw term renderer.
    ; In: HL = tagged term cell, DE = current environment base, B = nesting.
    ; Out: Z on success.  References are normalized before the tag dispatch,
    ; so the formatting branches see only concrete terms or an unbound cell.
    ; Dereference before choosing the concrete formatter.  B is the current
    ; parenthesis depth and is used by the list/variable formatting paths.
    call term_dereference_hl
    cp 003h
    jr nz,.io_render_integer
    ld a,028h
    call IO_OUTPUT_CALLBACK_JUMP
    inc b
    call io_render_list_items
    dec b
    ld a,029h
    call IO_OUTPUT_CALLBACK_JUMP
    cp a
    ret
.io_render_integer:
    cp 004h
    jr nz,.io_render_float
    call term_load_payload_hl
    jp io_print_signed_integer
.io_render_float:
    cp 00ah
    jr nz,.io_render_empty_list
    call term_load_payload_hl
    jp io_print_float
.io_render_empty_list:
    cp 010h
    jr nz,.io_render_constant
    ld a,028h
    call IO_OUTPUT_CALLBACK_JUMP
    ld a,029h
    call IO_OUTPUT_CALLBACK_JUMP
    cp a
    ret
.io_render_constant:
    cp 008h
    jr nz,.io_render_variable
    call term_load_payload_hl
    inc hl
    inc hl
    inc hl
    jp io_render_constant_spelling
.io_render_variable:
    ; An unbound variable is named by cell identity, not by its discarded source
    ; spelling.  Two parallel two-byte arrays are used: IX-0x80 stores the most
    ; recent cell for each variable identity and IX stores prefix/subscript data.
    ; This gives stable names throughout one W/WRITE/LISTP operation.
    cp 000h
    call nz,system_abort
    push de
    push bc
    push ix
    ex de,hl
    ld ix,VARIABLE_NAME_SPELLING_MAP
    ld c,001h
; ----------------------------------------------------------------------------
; PRINT NAMES ARE ABOUT IDENTITY, NOT ORIGINAL SPELLING
; ----------------------------------------------------------------------------
;
; Parsing discards a variable's source name once identity has been established.
; Printing rebuilds names by assigning ordinals in encounter order:
;
;       X Y Z x y z X1 Y1 Z1 x1 ...
;
; The map is keyed by the dereferenced variable-cell address.  Two occurrences
; of the same cell therefore print the same name; two independent unbound cells
; do not.  This is sufficient for a readable clause even though the user's
; original spelling is unavailable.
;
.io_find_variable_name_mapping:
    ; Scan two-byte records until either the variable cell address matches or
    ; the high byte of the next identity record is 0xFF.  C is the one-based
    ; generated-name ordinal: 1..6 are X,Y,Z,x,y,z; later groups add suffixes.
    ld a,(ix-07fh)
    cp 0ffh
    jr z,.io_create_variable_name_mapping
    ld l,(ix-080h)
    ld h,a
    or a
    sbc hl,de
    jr z,.io_emit_mapped_variable_name
    inc c
    inc ix
    inc ix
    jr .io_find_variable_name_mapping
.io_create_variable_name_mapping:
    ; Register a first-seen variable.  Ordinals 1..63 have generated spellings;
    ; ordinal 64 cannot fit the fixed map and is rendered as three question
    ; marks without installing a record.
    ld a,c
    cp 040h
    jr z,.io_emit_variable_overflow_marker
    ld (ix-080h),e
    ld (ix-07fh),d
    ld (ix-07dh),0ffh
.io_emit_mapped_variable_name:
    ; Generate the spelling and cache its compact representation.  The spelling
    ; record stores the numeric suffix in its low byte and the prefix character
    ; in its high byte, the same BC layout consumed by the input parser.
    ld h,000h
    ld l,c
    call io_emit_generated_variable_name
    ld (ix+000h),e
    ld (ix+001h),d
.io_finish_variable_render:
    pop ix
    pop bc
    pop de
    cp a
    ret
.io_emit_variable_overflow_marker:
    ld a,(variable_print_overflow_character)
    call IO_OUTPUT_CALLBACK_JUMP
    call IO_OUTPUT_CALLBACK_JUMP
    call IO_OUTPUT_CALLBACK_JUMP
    jr .io_finish_variable_render
io_emit_generated_variable_name:
    ; Convert a one-based ordinal into prefix plus optional decimal suffix.
    ; Repeated subtraction by six produces the suffix and the residual selects
    ; one of the six characters carrying LEX_CLASS_VARIABLE_PREFIX.
    push hl
    push bc
    ld a,(variable_print_prefix_count)
    ld b,a
    ld a,l
    ld c,000h
.io_split_variable_name_ordinal:
    cp b
    jr z,.io_scan_variable_prefix_classes
    jr c,.io_scan_variable_prefix_classes
    inc c
    sub b
    jr .io_split_variable_name_ordinal
.io_scan_variable_prefix_classes:
    ; The prefix alphabet is derived from the lexical table rather than copied
    ; into a second string.  This keeps printed variable names synchronized with
    ; precisely the characters the reader recognizes as variable prefixes.
    ld b,a
    ld e,c
    ld hl,lexical_character_class_table
    ld a,000h
.io_seek_next_variable_prefix:
    bit 6,(hl)
    jr nz,.io_emit_variable_prefix
.io_advance_character_class:
    inc hl
    inc a
    jr .io_seek_next_variable_prefix
.io_emit_variable_prefix:
    djnz .io_advance_character_class
    call IO_OUTPUT_CALLBACK_JUMP
    ld d,a
    ld a,c
    or a
    jr z,.io_generated_variable_name_done
    ld l,c
    ld h,000h
    call io_print_unsigned_integer
.io_generated_variable_name_done:
    pop bc
    pop hl
    ret
io_print_signed_integer:
    ; Preserve the caller registers, emit a leading minus for a negative 16-bit
    ; value, form its two's-complement magnitude, then share the unsigned decimal
    ; conversion.  The -32768 case remains representable as magnitude 0x8000.
    push hl
    push af
    bit 7,h
    jr z,.io_print_integer_magnitude
    ld a,02dh
    call IO_OUTPUT_CALLBACK_JUMP
    ld a,h
    cpl
    ld h,a
    ld a,l
    cpl
    ld l,a
    inc hl
.io_print_integer_magnitude:
    call io_print_unsigned_integer
    pop af
    pop hl
    ret
io_print_unsigned_integer:
    ; The stack doubles as a temporary digit vector.  Each division pass leaves
    ; one remainder digit on the native stack and keeps the quotient in HL;
    ; unwinding therefore emits the most-significant digit first.
    ; Convert unsigned HL to decimal by repeated 16-bit division by ten.  The
    ; remainders are stacked and emitted most-significant digit first.
    push hl
    push af
    push de
    push bc
    ld de,0000ah
    ld b,000h
.io_unsigned_integer_division_pass:
    ; Divide HL by ten with a 16-step restoring binary division.  A is the
    ; partial remainder, the transformed HL is the quotient, and B counts the
    ; remainders already stacked for final output.
    call compare_hl_de_preserving
    jr c,.io_push_final_decimal_digit
    xor a
    push bc
    ld b,010h
.io_divide_by_ten_bit:
    add hl,hl
    rla
    sub e
    jr c,.io_restore_division_remainder
    inc hl
    jr .io_continue_division_bit
.io_restore_division_remainder:
    add a,e
.io_continue_division_bit:
    djnz .io_divide_by_ten_bit
    pop bc
    push af
    inc b
    jr .io_unsigned_integer_division_pass
.io_push_final_decimal_digit:
    ld a,l
    push af
    inc b
.io_emit_stacked_decimal_digits:
    pop af
    call io_emit_decimal_digit
    djnz .io_emit_stacked_decimal_digits
    pop bc
    pop de
    pop af
    pop hl
    ret
io_print_float:
    ; Expand the packed six-byte decimal float into the shared arithmetic
    ; workspace, suppress insignificant trailing zeroes, and emit one leading
    ; digit plus a fractional part.  A nonzero decimal exponent is appended as E
    ; followed by a signed integer.
    push hl
    push de
    push bc
    ld de,NUMERIC_WORK_A
    call numeric_unpack_float_to_decimal
    ex de,hl
    bit 3,(hl)
    jr z,.io_float_find_significant_digits
    ld a,02dh
    call IO_OUTPUT_CALLBACK_JUMP
.io_float_find_significant_digits:
    inc hl
    ld a,(hl)
    sub 081h
    ld e,a
    ld b,007h
    ld hl,NUMERIC_WORK_A_LAST_DIGIT
    xor a
.io_float_trim_trailing_zero:
    cp (hl)
    dec hl
    jr nz,.io_float_emit_leading_digit
    djnz .io_float_trim_trailing_zero
    inc b
.io_float_emit_leading_digit:
    ld hl,NUMERIC_WORK_A_FIRST_DIGIT
    call io_emit_next_decimal_digit
    ld a,02eh
    call IO_OUTPUT_CALLBACK_JUMP
.io_float_emit_fraction_digits:
    call io_emit_next_decimal_digit
    djnz .io_float_emit_fraction_digits
    ld a,e
    or a
    jr z,.io_float_render_done
    ld a,045h
    call IO_OUTPUT_CALLBACK_JUMP
    ld l,e
    bit 7,e
    ld h,000h
    jr z,.io_float_emit_exponent_value
    ld h,0ffh
.io_float_emit_exponent_value:
    call io_print_signed_integer
.io_float_render_done:
    pop bc
    pop de
    pop hl
    ret
io_emit_next_decimal_digit:
    inc hl
    ld a,(hl)
io_emit_decimal_digit:
    or 030h
    jp IO_OUTPUT_CALLBACK_JUMP
; ----------------------------------------------------------------------------
; QUOTE ONLY WHEN THE READER WOULD OTHERWISE DISAGREE
; ----------------------------------------------------------------------------
;
; The printer does not use a hand-maintained list of punctuation.  It runs the
; same lexical-class tests as the tokenizer.  A constant may be emitted bare if
; all of its characters form one legal token of the same class; otherwise it is
; quoted.
;
; Inside quotes, @ is the escape prefix.  Control characters are written as the
; printable character sixty-four positions above them, while @ and quote escape
; themselves.  The result is intended to be a round trip, not merely pleasant
; display.
;
; Forward reference: lexical safety
; ---------------------------------
; Readable output must print a constant so the parser reconstructs the same
; token.  The character-class table that answers “safe without quotes?” is in
; module 05 immediately after this chapter.  Conceptually the decision is:
;
;       if spelling is one legal unquoted token and not a number/variable:
;           emit bytes unchanged
;       else:
;           emit '"'
;           escape control bytes, '@', and '"' with '@'
;           emit '"'
;
; Raw W output skips this round-trip check.
io_render_constant_spelling:
    ; Raw mode copies the stored bytes literally.  Readable mode first verifies
    ; that the spelling would be tokenized back as the same constant; otherwise
    ; it surrounds the spelling with quotes and applies the @ escape convention.
    ld a,(IO_FORMAT_MODE)
    or a
    call nz,io_constant_needs_quotes
    jr z,.io_emit_raw_constant_loop
    ld a,022h
    call IO_OUTPUT_CALLBACK_JUMP
.io_emit_quoted_constant_loop:
    ; Stored names end in 0xFF.  Control bytes 1..31 become @A..@_, while @ and
    ; quote are escaped by an additional @.  All other bytes are emitted intact.
    ld a,(hl)
    cp 0ffh
    jr z,.io_close_quoted_constant
    cp 020h
    jr c,.io_escape_control_character
    cp 040h
    jr z,.io_emit_escape_prefix
    cp 022h
    jr z,.io_emit_escape_prefix
    jr .io_emit_constant_character
.io_escape_control_character:
    add a,040h
.io_emit_escape_prefix:
    push af
    ld a,040h
    call IO_OUTPUT_CALLBACK_JUMP
    pop af
.io_emit_constant_character:
    call IO_OUTPUT_CALLBACK_JUMP
    inc hl
    jr .io_emit_quoted_constant_loop
.io_close_quoted_constant:
    ld a,022h
    jp IO_OUTPUT_CALLBACK_JUMP
.io_emit_raw_constant_loop:
    ld a,(hl)
    cp 0ffh
    ret z
    call IO_OUTPUT_CALLBACK_JUMP
    inc hl
    jr .io_emit_raw_constant_loop
io_constant_needs_quotes:
    ; Return NZ when raw output would change token identity.  The first character
    ; chooses an alphanumeric or graphic continuation class; a variable-prefix
    ; spelling is treated specially so a constant such as X is not reread as a
    ; variable.  HL is restored for the subsequent output pass.
    ; Classify the bytes of a constant according to the lexical tables at
    ; 0x710D.  Z means the raw spelling is safe; NZ requests quotes/escapes.
    ; HL is preserved so the caller can immediately emit the chosen spelling.
    push hl
    push bc
    ld a,(hl)
    call input_classify_character
    ld b,c
    bit 6,c
    jr z,.io_test_graphic_constant_spelling
    inc hl
    ld a,(hl)
    cp 0ffh
    jr z,.io_constant_requires_quotes
    ld b,001h
    jr .io_quote_scan_class_match
.io_test_graphic_constant_spelling:
    bit 7,c
    jr z,.io_test_alphanumeric_constant_spelling
    inc hl
    ld a,(hl)
    call input_classify_character
    bit 0,c
    jr nz,.io_allow_digits_after_first_character
    bit 3,c
    jr nz,.io_quote_scan_next_character
    or a
    pop bc
    pop hl
    ret
.io_test_alphanumeric_constant_spelling:
    bit 0,c
    jr nz,.io_allow_digits_after_first_character
    bit 3,c
    jr nz,.io_quote_scan_next_character
    or a
    pop bc
    pop hl
    ret
.io_allow_digits_after_first_character:
    set 1,b
.io_quote_scan_next_character:
    inc hl
    ld a,(hl)
    cp 0ffh
    jr z,.io_quote_test_return
.io_quote_scan_class_match:
    call input_classify_character
    ld a,c
    and b
    jr nz,.io_quote_scan_next_character
.io_constant_requires_quotes:
    or 001h
.io_quote_test_return:
    pop bc
    pop hl
    ret
ascii_fold_lowercase_to_uppercase:
    ; Fold ASCII a..z only.  Spectrum graphics and punctuation are deliberately
    ; unchanged; callers use this for case-insensitive exponent/command tests.
    cp 061h
    ret c
    cp 07bh
    ret nc
    sub 020h
    ret
read_constant_entry:
    defb TERM_TAG_CONSTANT
    defw read_value_cell
    defb TERM_TAG_LIST
    defw intok_constant_entry
read_value_cell:
    defb TERM_TAG_INTEGER
    defw read_primitive
read_name:
    defb 052h,045h,041h,044h,SYSTEM_NAME_TERMINATOR ; "READ"

read_primitive:
    ld ix,read_dispatch_file
    jp primitive_argument_dispatch

; READ file output-variable: a constant source followed by one unbound result.
read_dispatch_file:
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb read_dispatch_output-read_dispatch_file
    defb DISPATCH_REJECT,DISPATCH_REJECT
read_dispatch_output:
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
    defb read_dispatch_complete-read_dispatch_output
read_dispatch_complete:
    defb read_next_term-read_dispatch_complete
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT

; ----------------------------------------------------------------------------
; READ BUILDS EXECUTABLE TERMS DIRECTLY
; ----------------------------------------------------------------------------
;
; READ installs the selected file's input and unread callbacks, clears the
; variable maps, and invokes the recursive parser.  Constants are interned while
; they are recognized; variables become cells or references; lists are allocated
; as six-byte pairs.  There is no later abstract-syntax conversion pass.
;
; Syntax errors restore a protected parser stack and report the common Syntax
; Error condition, so half-built list objects simply become unreachable and are
; left for the collector.
;
read_next_term:
    ; Select the requested input object, clear the variable-spelling map, and
    ; parse exactly one term into primitive argument 2.  EOF/channel errors are
    ; returned unchanged; syntax errors use the protected parser stack below.
    ld hl,(PRIMITIVE_ARG1_VALUE)
    call io_select_input_source
    ret nz
    ld a,0ffh
    ld (FRESH_VARIABLE_MAP_END_HIGH),a
read_parse_term_into_result:
    ; The destination is a caller-owned three-byte result cell.  Nested list
    ; pairs are allocated from the managed six-byte heap, but atomic terms are
    ; written directly to the current DE destination.
    ; DE starts at the dispatcher's result slot for argument 2.  The recursive
    ; parser writes a complete tagged term graph there and advances DE as cells
    ; are allocated.  SP is saved so syntax errors can abandon nested parsing.
    ld de,0980dh
    ld (PARSER_ERROR_STACK),sp
    ld b,000h
; ----------------------------------------------------------------------------
; RECURSIVE DESCENT FOR A LANGUAGE WITH ONE CONSTRUCTOR
; ----------------------------------------------------------------------------
;
; micro-PROLOG has only one structural constructor: the list pair.  The parser
; therefore needs only four broad token outcomes—open parenthesis, close
; parenthesis, vertical bar, or atom.  Proper lists end in END; a bar replaces
; that final END with an explicitly parsed tail term.
;
; Because tokenization returns a class and a temporary spelling buffer, the
; parser can decide whether an alphanumeric token is a variable, number or
; constant without rescanning the input stream.
;
; Worked parser trace: (a b|X)
; --------------------------------
; The token stream is:
;
;       '('   'a'   'b'   '|'   'X'   ')'
;
; Recursive construction proceeds from the explicit tail outward:
;
;       parse X                  -> variable cell X
;       see ')'                  -> finish explicit tail
;       prepend b                -> pair(b, X)
;       prepend a                -> pair(a, pair(b, X))
;       wrap first pair in LIST  -> term representing (a b|X)
;
; Pseudocode:
;
;       parse_list():
;           items = []
;           until token is ')' or '|': items.append(parse_term())
;           tail = END if ')' else parse_term(); require ')'
;           for item in reverse(items): tail = cons(item, tail)
;           return tail
;
; The actual code builds the same graph with protected native-stack recursion
; and six-byte pair allocation.
; Parser-state trace for `(a b|X)`
; ----------------------------------
; 1. `(` pushes an open-list construction frame and initializes an empty owner
;    cursor where the first pair will be linked.
; 2. Token `a` is parsed; a pair object is allocated, its head receives a, and
;    the owner cursor is advanced to that pair's tail cell.
; 3. Token `b` repeats the operation, extending the proper prefix.
; 4. `|` changes state: the next term is not another element but the final tail.
; 5. Variable X is parsed and installed directly into the current tail cursor,
;    replacing the END which would have made the list proper.
; 6. `)` is accepted only after exactly one tail term followed the bar.  The
;    resulting graph is a -> b -> X, represented by two list pairs.
read_parse_term:
    ; Recursive-descent entry.  B is the unmatched-parenthesis depth and DE is
    ; the destination cell.  The tokenizer owns delimiter pushback, so each call
    ; starts exactly at the next token boundary.
    ; Read the next lexical token and convert it into one tagged term.  B counts
    ; unmatched opening parentheses while DE is the destination cursor.
    call input_next_token
    ret nz
read_parse_token:
    ; Parentheses and '|' are structural tokens.  All other tokens are handed
    ; to the atom/number/variable conversion paths below.
    cp 028h
    jr nz,.read_parse_atomic_token
    inc b
.read_parse_list_next_token:
    ; Parse the interior of one list.  A right parenthesis writes the canonical
    ; END cell into the current tail slot.  Otherwise the current token is either
    ; a bar introducing an improper tail or the head of a newly allocated pair.
    call input_next_token
    ret nz
    cp 029h
    jr nz,.read_parse_list_bar_or_element
    dec b
    ld a,010h
    ld (de),a
    ld a,0ffh
    inc de
    ld (de),a
    inc de
    ld (de),a
    dec de
    dec de
    cp a
    ret
.read_parse_list_bar_or_element:
    ; A bar is legal only after at least one list element.  Parse one arbitrary
    ; tail term into the existing tail cell, then require the immediately
    ; following token to be the closing parenthesis.
    cp 07ch
    jr nz,.read_parse_list_element
    call read_parse_term
    ret nz
    call input_next_token
    ret nz
    cp 029h
    jp nz,.syntax_error
    dec b
    cp a
    ret
.read_parse_list_element:
    ; Allocate one six-byte cons pair downward.  Publish LIST(pair) in the owner
    ; cell before recursively filling the pair head, then continue with the pair
    ; tail as the destination for the rest of the list.
    push hl
    call allocate_two_term_cells
    push af
    ld a,003h
    ld (de),a
    pop af
    ex de,hl
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    pop hl
    push de
    call read_parse_token
    pop de
    ret nz
    inc de
    inc de
    inc de
    jr .read_parse_list_next_token
.read_parse_atomic_token:
    ; Alphanumeric token kind 3 may denote a variable; numeric kinds already
    ; carry their tagged payload; all remaining text/special/quoted kinds are
    ; interned through the current module dictionary.
    cp 029h
    jp z,.syntax_error
    cp 003h
    jr nz,.read_accept_numeric_or_constant_token
    call read_decode_variable_token
    jr nz,.read_intern_constant_token
    ld (ix-080h),e
    ld (ix-07fh),d
    jr .read_store_term_cell
.read_accept_numeric_or_constant_token:
    cp 004h
    jr z,.read_store_term_cell
    cp 00ah
    jr z,.read_store_term_cell
.read_intern_constant_token:
    call intern_constant_from_input_buffer
.read_store_term_cell:
    ; Store the tag in A and the two-byte payload in HL into the destination DE.
    ; This common exit is used for numbers, constants, first variables, and
    ; references to prior occurrences of the same source variable.
    ld (de),a
    inc de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    cp a
    ret
.syntax_error:
    ; Abandon every recursive parser frame by restoring the stack captured at
    ; READ entry.  The inline high-bit string is printed, then parsing restarts
    ; with a zero nesting depth rather than returning a partial term graph.
    ld sp,(PARSER_ERROR_STACK)    ; restore parser error stack
    call print_inline_high_bit_string    ; print inline high-bit text
syntax_error_message:
    defb 0d3h,0f9h,0eeh,0f4h,0e1h,0f8h,0a0h
    defb 0c5h,0f2h,0f2h,0efh,0f2h,000h       ; "Syntax Error"
    ld b,000h
    jp read_parse_term    ; resume parser recovery
input_classify_character:
    ; In: A = input byte.  Out: C = orthogonal lexical-role bits, A preserved.
    ; Bytes >=128 bypass the ASCII table and are single-character Spectrum
    ; graphic tokens.  The table also drives readable constant quotation.
    ; Return character-class flags in C.  This table-driven classifier is used
    ; by both the lexical scanner and the quote-safety test in the printer.
    ld c,010h
    bit 7,a
    ret nz
    push hl
    push de
    ld de,lexical_character_class_table
    ld l,a
    res 7,l
    ld h,000h
    add hl,de
    ld c,(hl)
    pop de
    pop hl
    ret
; ----------------------------------------------------------------------------
; REPEATED VARIABLES BECOME REFERENCE CHAINS
; ----------------------------------------------------------------------------
;
; The first occurrence of a spelling creates an unbound cell and records both
; its spelling code and address.  A later occurrence is written as a reference
; to the most recent cell, after which the map advances to the new occurrence.
;
; This short backward chain is cheap to construct and preserves identity.  The
; dereferencer hides the chain during execution, and the clause compiler later
; converts source variables to compact relative environment offsets.
;
; Repeated-variable occurrence chain
; ----------------------------------
; For input `(X X X)`, the parser does not preserve the spelling in every cell.
; It keeps the newest occurrence in a map and links each later occurrence back
; to the previous one:
;
;       X1: [UNBOUND]
;       map[X] = &X1
;
;       X2: [ABSOLUTE_REFERENCE -> X1]
;       map[X] = &X2
;
;       X3: [ABSOLUTE_REFERENCE -> X2]
;       map[X] = &X3
;
; Dereferencing any occurrence reaches X1, so all three denote one logical
; variable.  Updating the map to the newest cell also makes later compilation
; and printing walks short and deterministic.
read_decode_variable_token:
    ; Recognize the restricted variable grammar: one configured prefix followed
    ; only by decimal digits.  On success A/HL describe an unbound cell or a
    ; reference to an earlier occurrence; NZ means the token is an ordinary
    ; alphanumeric constant instead.
    ld hl,DICTIONARY_INPUT_BUFFER
    ld a,(hl)
    call input_classify_character
    bit 6,c
    jr nz,.read_parse_variable_subscript
    or a
    ret
.read_parse_variable_subscript:
    ; B retains the prefix character and C accumulates the numeric subscript.
    ; The spelling key is therefore BC, matching the two-byte spelling records
    ; created by the printer.
    push bc
    ld c,000h
    ld b,a
.read_variable_subscript_loop:
    inc hl
    ld a,(hl)
    cp 0feh
    jr z,.read_search_variable_spelling_map
    cp 030h
    jr c,.read_variable_decode_return
    cp 03ah
    jr c,.read_accumulate_variable_subscript
    or a
    jr .read_variable_decode_return
.read_accumulate_variable_subscript:
    and 00fh
    sla c
    add a,c
    sla c
    sla c
    add a,c
    ld c,a
    jr .read_variable_subscript_loop
.read_search_variable_spelling_map:
    xor a
    ld ix,VARIABLE_NAME_SPELLING_MAP
.read_variable_spelling_search_loop:
    ; IX points into the spelling array at 0x98EF; IX-0x80 addresses the parallel
    ; occurrence-cell array.  Search by prefix/subscript, with 0xFF in the high
    ; byte of the next occurrence record acting as the terminator.
    ld a,(ix-07fh)
    cp 0ffh
    jr z,.read_register_variable_spelling
    ld l,(ix+000h)
    ld h,(ix+001h)
    or a
    sbc hl,bc
    jr z,.read_reuse_variable_cell
    inc ix
    inc ix
    jr .read_variable_spelling_search_loop
.read_reuse_variable_cell:
    ; Repeated variables are represented as backward references to the most
    ; recent occurrence.  Even-addressed cells use ABSOLUTE; odd second cells of
    ; a six-byte pair use the compact NEXT_CELL form after subtracting three.
    ld l,(ix-080h)
    ld h,a
    bit 0,l
    ld a,001h
    jr z,.read_variable_match_return
    dec hl
    dec hl
    dec hl
    ld a,005h
.read_variable_match_return:
    pop bc
    cp a
    ret
.read_register_variable_spelling:
    ; Install a new prefix/subscript key and place a sentinel after it.  The
    ; caller then writes the destination address into the parallel array.  On
    ; every repeated occurrence that address is advanced to the new cell, making
    ; later occurrences form a short backward reference chain.
    ld (ix+000h),c
    ld (ix+001h),b
    ld (ix-07dh),a
    ld a,000h
.read_variable_decode_return:
    pop bc
    ret
; ----------------------------------------------------------------------------
; TOKENIZATION IS TABLE-DRIVEN
; ----------------------------------------------------------------------------
;
; Each ASCII character carries several independent class bits.  The tokenizer
; uses those bits to decide whether to extend the current token, terminate it,
; or return a structural token immediately.  The minus sign is intentionally in
; several classes, so one-character lookahead decides whether it begins a
; number or belongs to an alphanumeric/graphic constant.
;
; Only the first sixty characters of a token are significant.  Excess input is
; still consumed to the true token boundary, preventing the next READ from
; beginning in the middle of an overlong name.
;
input_next_token:
    ; Tokenizer contract:
    ;   Z  -> A is token kind or literal structural character
    ;   NZ -> EOF/device failure propagated from the selected input callback
    ; Token text is FE-terminated in DICTIONARY_INPUT_BUFFER.  One delimiter is
    ; read ahead and returned through the selected unread callback.
    ; Scan one token from the currently selected input callback.  The scanner
    ; skips separators, recognizes quoted escapes, and leaves token text in the
    ; shared buffer at 0x9CA5.  Z indicates a valid token; NZ propagates EOF or
    ; a channel error.
    call IO_INPUT_CALLBACK_JUMP
    ret nz
    call input_classify_character
    bit 5,c
    jr nz,input_next_token
    bit 2,c
    jr z,.input_handle_sign_or_class
    cp a
    ret
.input_handle_sign_or_class:
    ; '-' has three lexical roles.  Peek one byte: before a digit it starts a
    ; signed number; otherwise unread the lookahead and let '-' begin an
    ; alphanumeric/graphic token according to the normal class dispatch.
    bit 7,c
    jr z,.input_dispatch_character_class
    push af
    call IO_INPUT_CALLBACK_JUMP
    jr z,.input_test_signed_number
    pop af
    ret
.input_test_signed_number:
    push bc
    call input_classify_character
    bit 1,c
    pop bc
    jr z,.input_restore_sign_lookahead
    inc sp
    inc sp
    call IO_UNREAD_CALLBACK_JUMP
    ld a,008h
    jp .input_parse_number
.input_restore_sign_lookahead:
    call IO_UNREAD_CALLBACK_JUMP
    pop af
.input_dispatch_character_class:
    bit 1,c
    jr z,.input_dispatch_alpha_or_graphic
    call IO_UNREAD_CALLBACK_JUMP
    ld a,000h
    jp .input_parse_number
.input_dispatch_alpha_or_graphic:
    ; Alphanumeric collection accepts the union encoded in C after bit 1 is set,
    ; allowing letters, digits and the readability hyphen rules to share one
    ; bounded text collector.
    bit 0,c
    jr z,.input_dispatch_graphic_or_quoted
    set 1,c
    call input_collect_token_text
    ld a,003h
    ret
.input_dispatch_graphic_or_quoted:
    ; Graphic runs are maximal sequences matching the initial graphic class.
    ; Quote and bracket-like single tokens take the separate branches below.
    bit 3,c
    jr z,.input_dispatch_quoted_or_single
    call input_collect_token_text
    ld a,002h
    ret
.input_dispatch_quoted_or_single:
    cp 022h
    jr nz,.input_single_token_or_ignore
    ld hl,DICTIONARY_INPUT_BUFFER
    push de
    ld d,03ch
.input_quoted_token_loop:
    ; Read at most 60 significant bytes but continue consuming an overlong
    ; spelling until its closing quote.  @A..@_ decode to control bytes 1..31;
    ; @@ and @quote remain literal characters.
    call IO_INPUT_CALLBACK_JUMP
    jr nz,.input_quoted_token_return
    cp 022h
    jr z,.input_finish_quoted_token
    cp 040h
    jr nz,.input_store_quoted_character
    call IO_INPUT_CALLBACK_JUMP
    jr nz,.input_quoted_token_return
    cp 041h
    jr c,.input_store_quoted_character
    cp 060h
    jr nc,.input_store_quoted_character
    sub 040h
.input_store_quoted_character:
    inc d
    dec d
    jr z,.input_quoted_token_loop
    ld (hl),a
    dec d
    inc hl
    jr .input_quoted_token_loop
.input_finish_quoted_token:
    ld (hl),0feh
    ld a,005h
    cp a
.input_quoted_token_return:
    pop de
    ret
.input_single_token_or_ignore:
    ; Characters marked SINGLE_TOKEN are returned as one-byte constant spellings.
    ; Class-zero bytes (notably NUL and DEL) are ignored by tail-calling the main
    ; scanner rather than becoming tokens.
    bit 4,c
    jp z,input_next_token
    ld h,0feh
    ld l,a
    ld (DICTIONARY_INPUT_BUFFER),hl
    ld a,008h
    cp a
    ret
; ----------------------------------------------------------------------------
; DECIMAL TEXT ENTERS THE SAME WORKSPACE USED BY ARITHMETIC
; ----------------------------------------------------------------------------
;
; Digits, decimal point and exponent are accumulated into the expanded decimal
; workspace used by SUM and TIMES.  Normalization then decides whether the value
; fits the compact signed 16-bit integer form; if not, it is packed into the
; six-byte decimal floating representation.
;
; This shared representation is why input such as 2.34e4 can become the integer
; 23400 without a separate conversion subsystem.
;
; Numeric-token trace: `2.34e4`
; -------------------------------
; Token digits produce significant sequence 2,3,4 with decimal point after the
; first digit.  The explicit exponent +4 shifts the decimal exponent so the
; unpacked decimal workspace represents 23400.  Normalization removes the point,
; and numeric_try_to_integer observes that the exact value fits signed 16-bit
; range.  The final term is therefore INTEGER 23400, not a FLOAT object, matching
; the documented automatic canonicalization of integral decimal input.
.input_parse_number:
    ; Parse into the decimal arithmetic workspace rather than using ROM floats.
    ; A carries the sign/control seed, E tracks the effective decimal exponent,
    ; and up to eight significant digits are retained while excess digits still
    ; adjust scale correctly.
    push de
    push bc
    ld hl,NUMERIC_WORK_A_END
    ld b,012h
.input_clear_decimal_workspace:
    ld (hl),000h
    dec hl
    djnz .input_clear_decimal_workspace
    ld (hl),a
    inc hl
    inc hl
    ld b,009h
    ld e,000h
.input_skip_leading_zeroes:
    call IO_INPUT_CALLBACK_JUMP
    jp nz,.input_numeric_return
    cp 030h
    jr z,.input_skip_leading_zeroes
.input_collect_integer_digits:
    ; Skip leading zeroes, count every integer digit in E, and retain the first
    ; significant digits that fit the decimal workspace.  The first non-digit is
    ; examined for a decimal point or exponent before being pushed back.
    call input_classify_character
    bit 1,c
    jr z,.input_test_decimal_point
    inc e
    dec b
    jr nz,.input_store_integer_digit
    inc b
    jr .input_read_next_integer_character
.input_store_integer_digit:
    inc hl
    and 00fh
    ld (hl),a
.input_read_next_integer_character:
    call IO_INPUT_CALLBACK_JUMP
    jp nz,.input_numeric_return
    jr .input_collect_integer_digits
.input_test_decimal_point:
    cp 02eh
    jr nz,.input_finish_numeric_token
.input_collect_fraction_digits:
    ; Fraction digits occupy remaining precision slots.  Leading fractional
    ; zeroes decrease E even when no significant digit has yet been stored.
    call IO_INPUT_CALLBACK_JUMP
    jr nz,.input_numeric_return
    call input_classify_character
    bit 1,c
    jr z,.input_test_exponent_marker
    dec b
    jr nz,.input_store_fraction_digit
    inc b
    jr .input_collect_fraction_digits
.input_store_fraction_digit:
    inc hl
    and 00fh
    ld (hl),a
    jr .input_collect_fraction_digits
.input_test_exponent_marker:
    cp 045h
    jr z,.input_read_exponent
    cp 065h
    jr nz,.input_finish_numeric_token
.input_read_exponent:
    ; Parse an optional minus and an unsigned decimal exponent.  The explicit
    ; exponent is added to the scale already derived from integer/fraction digit
    ; positions; malformed termination propagates through the normal callback.
    call IO_INPUT_CALLBACK_JUMP
    jr nz,.input_numeric_return
    cp 02dh
    ld d,000h
    jr nz,.input_begin_exponent_digits
    ld d,001h
    ld a,030h
.input_begin_exponent_digits:
    ld b,000h
.input_collect_exponent_digits:
    call input_classify_character
    bit 1,c
    jr z,.input_apply_exponent_sign
    and 00fh
    ld c,a
    sla b
    ld a,b
    sla b
    sla b
    add a,b
    add a,c
    ld b,a
    call IO_INPUT_CALLBACK_JUMP
    jr nz,.input_numeric_return
    jr .input_collect_exponent_digits
.input_apply_exponent_sign:
    push af
    ld a,d
    or a
    ld a,b
    jr z,.input_finish_exponent
    neg
.input_finish_exponent:
    add a,e
    ld e,a
    pop af
.input_finish_numeric_token:
    ; Return the delimiter to the input stream, normalize the decimal workspace,
    ; and canonicalize any exactly representable 16-bit result to INTEGER.  Only
    ; genuinely non-integral/out-of-range values allocate a packed FLOAT object.
    call IO_UNREAD_CALLBACK_JUMP
    ld a,e
    add a,080h
    ld (NUMERIC_WORK_A_EXPONENT),a
    ld hl,NUMERIC_WORK_A
    call decimal_normalize
    call decimal_try_to_integer
    jr nz,.input_keep_float_result
    ex de,hl
    ld a,004h
    jr .input_numeric_return
.input_keep_float_result:
    ex de,hl
    call allocate_two_term_cells
    call numeric_pack_decimal_to_float
    cp a
    ld a,00ah
.input_numeric_return:
    pop bc
    pop de
    ret
input_collect_token_text:
    ; Generic maximal-run collector.  B is the accepted class mask and D is the
    ; remaining 60-byte storage allowance.  Once full, the scanner still consumes
    ; the complete token so the next call begins at the correct delimiter.
    ; Copy a bounded token spelling into 0x9CA5.  D is the remaining capacity
    ; (60 significant characters); extra source characters are consumed but
    ; deliberately not stored, matching the documented constant-name limit.
    ld hl,DICTIONARY_INPUT_BUFFER
    push de
    push bc
    ld d,03ch
    ld b,c
.input_collect_token_loop:
    call input_classify_character
    push af
    ld a,c
    and b
    jr z,.input_finish_text_token
    pop af
    inc d
    dec d
    jr z,.input_token_capacity_exhausted
    ld (hl),a
    inc hl
    dec d
.input_token_capacity_exhausted:
    push bc
    ld b,000h
    call IO_INPUT_CALLBACK_JUMP
    pop bc
    jr nz,.input_text_token_return
    jr .input_collect_token_loop
.input_finish_text_token:
    pop af
    call IO_UNREAD_CALLBACK_JUMP
    ld (hl),0feh
    cp a
.input_text_token_return:
    pop bc
    pop de
    ret
intok_constant_entry:
    defb TERM_TAG_CONSTANT
    defw intok_value_cell
    defb TERM_TAG_LIST
    defw listp_constant_entry
intok_value_cell:
    defb TERM_TAG_INTEGER
    defw intok_primitive
intok_name:
    defb 049h,04eh,054h,04fh,04bh,SYSTEM_NAME_TERMINATOR ; "INTOK"

; INTOK is an internal lexical primitive rather than a documented user-facing
; relation.  It reads one token from a named input source and returns the token
; in the compact form expected by the parser: structural characters become
; 0xFE-prefixed constants, while ordinary tokens are interned/converted.
intok_primitive:
    ld ix,intok_dispatch_file
    jp primitive_argument_dispatch
intok_dispatch_file:
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb intok_dispatch_output-intok_dispatch_file
    defb DISPATCH_REJECT,DISPATCH_REJECT
intok_dispatch_output:
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
    defb intok_dispatch_complete-intok_dispatch_output
intok_dispatch_complete:
    defb intok_read_token-intok_dispatch_complete
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT

intok_read_token:
    ; INTOK exposes the tokenizer as a primitive.  Structural characters are
    ; converted to one-character constants; integer/float payloads are returned
    ; directly; every other spelling is interned in the active dictionary.
    ld hl,(PRIMITIVE_ARG1_VALUE)
    call io_select_input_source
    ret nz
    call input_next_token
    ret nz
    cp 028h
    jr z,.intok_store_structural_token
    cp 029h
    jr z,.intok_store_structural_token
    cp 07ch
    jr nz,.intok_convert_token_kind
.intok_store_structural_token:
    ld l,a
    ld h,0feh
    ld (DICTIONARY_INPUT_BUFFER),hl
    ld a,008h
.intok_intern_token:
    call intern_constant_from_input_buffer
.intok_store_result:
    ld (0980dh),a
    ld (0980eh),hl
    cp a
    ret
.intok_convert_token_kind:
    cp 004h
    jr z,.intok_store_result
    cp 00ah
    jr z,.intok_store_result
    jr .intok_intern_token
; ----------------------------------------------------------------------------
; LISTP DECOMPILES STORED CLAUSES WITHOUT EXECUTING THEM
; ----------------------------------------------------------------------------
;
; Compiled clauses contain relative variable offsets and omit the relation name
; from the stored head.  LISTP walks that representation directly, restores the
; predicate constant for display, and maps each relative offset back to a
; generated variable name.
;
; No temporary execution frame is required.  This matters on a small machine:
; listing a large relation should not consume the same arena space as running it.
;
listp_constant_entry:
    defb TERM_TAG_CONSTANT
    defw listp_value_cell
    defb TERM_TAG_LIST
    defw con_file_constant_entry
listp_value_cell:
    defb TERM_TAG_INTEGER
    defw listp_primitive
; LISTP is the inverse view of ADDCL compilation.  Module 08 shows how source
; `((P X) (Q X))` becomes one local plus RELATIVE 0 references in head and body.
; LISTP walks that stored graph, assigns a generated print name to offset 0, and
; reconstructs both occurrences as the same variable:
;
;       source -> ADDCL compiled graph -> LISTP -> `((P X) (Q X))`
listp_name:
    defb 04ch,049h,053h,054h,050h,SYSTEM_NAME_TERMINATOR ; "LISTP"

; LISTP is a decompiler
; ----------------------
; This is not the ordinary term renderer applied to stored bytes.  Stored clauses
; omit the relation name from the head and encode variables as RELATIVE_REFERENCE
; offsets into a future local environment.  LISTP reconstructs source form:
;
;       stored relation value + compiled metadata + relative variables
;           -> readable ((Relation HeadArgs) BodyGoals...)
;
; It assigns generated variable names directly from relative offsets without
; allocating a live execution frame.  The stored clause layout is introduced in
; module 02 and the ADDCL compiler that creates it appears in module 08.
listp_primitive:
    ld ix,listp_dispatch_file
    jp primitive_argument_dispatch

; LISTP file [selection]
;   no second argument        -> list the current workspace/module
;   bound list/structure      -> list each named relation in the list
;   constant                  -> list one relation or one module
listp_dispatch_file:
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb listp_dispatch_selection-listp_dispatch_file
    defb DISPATCH_REJECT,DISPATCH_REJECT
listp_dispatch_selection:
    defb listp_all-listp_dispatch_selection
    defb DISPATCH_REJECT
    defb listp_dispatch_single-listp_dispatch_selection
    defb listp_dispatch_list-listp_dispatch_selection
    defb DISPATCH_REJECT
listp_dispatch_list:
    defb listp_relation_list-listp_dispatch_list
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
listp_dispatch_single:
    defb listp_single_selection-listp_dispatch_single
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT

listp_all:
    ; LISTP without a selector enumerates the active module environment.  It
    ; prints definitions from the module's dictionary lists using readable mode
    ; and the same callback abstraction as WRITE.
    ld hl,(PRIMITIVE_ARG1_VALUE)
    ld a,IO_FORMAT_READABLE
    call io_select_output_target
    ret nz
    ld hl,(MODULE_CURRENT_OBJECT)
    call term_load_payload_hl
    push hl
    call listp_walk_selection
    pop hl
    inc hl
    inc hl
    inc hl
    call term_load_payload_hl
    inc hl
    inc hl
    inc hl
listp_walk_selection:
    ; Walk a proper selector list.  Constant elements select relation values;
    ; nested module objects are handled by the single-selection path.  Malformed
    ; tails stop without treating arbitrary data as a relation list.
    ; Walk a list of relation/module selectors.  Constant selectors update the
    ; current relation pointer and are emitted by listp_emit_program; nested
    ; list forms are traversed recursively.  TERM_TAG_END terminates cleanly.
    ld a,(hl)
    cp 010h
    ret z
    cp 003h
    ret nz
    call term_load_payload_hl
    ld a,(hl)
    cp 008h
    jr nz,.listp_advance_selection
    push hl
    call term_load_payload_hl
    ld (PRIMITIVE_ARG2_VALUE),hl
    call listp_emit_program_list
    pop hl
.listp_advance_selection:
    inc hl
    inc hl
    inc hl
    jr listp_walk_selection
listp_relation_list:
    ld hl,(PRIMITIVE_ARG1_VALUE)
    ld a,IO_FORMAT_READABLE
    call io_select_output_target
    ret nz
    ld hl,(PRIMITIVE_ARG2_VALUE)
    jr listp_walk_selection
listp_single_selection:
    ld hl,(PRIMITIVE_ARG1_VALUE)
    ld a,IO_FORMAT_READABLE
    call io_select_output_target
    ret nz
    ld hl,(PRIMITIVE_ARG2_VALUE)
.listp_emit_selected_object:
    ; A MODULE selector prints its name, export/import descriptors and member
    ; definitions through a callback walk.  Any non-module value is interpreted
    ; as an ordinary relation clause list.
    ld a,(hl)
    cp TERM_TAG_MODULE
    jr nz,listp_emit_program_list
    push hl
    call listp_emit_constant_name
    pop hl
    call term_load_payload_hl
    push hl
    call listp_pretty_print_term
    pop hl
    push hl
    inc hl
    inc hl
    inc hl
    call term_load_payload_hl
    push hl
    call listp_pretty_print_term
    call io_emit_enter
    ld hl,.listp_emit_module_member_callback
    ld (LIST_WALK_CALLBACK_TARGET),hl
    pop hl
    inc hl
    inc hl
    inc hl
    call walk_proper_list_with_callback
    pop hl
    call walk_proper_list_with_callback
    ld hl,0780dh
    call listp_emit_constant_name
    call io_emit_enter
    cp a
    ret
.listp_emit_module_member_callback:
    ; Callback for module dictionary walks.  Dereference each dictionary node,
    ; install its canonical value cell as the current selection, and print either
    ; a relation definition or a recursively selected module.
    call term_load_payload_hl
    ld (PRIMITIVE_ARG2_VALUE),hl
    ld a,(hl)
    cp 003h
    jr nz,.listp_callback_test_module
    call listp_emit_program_list
    jr .listp_callback_return
.listp_callback_test_module:
    cp TERM_TAG_MODULE
    jp z,.listp_emit_selected_object
.listp_callback_return:
    ret
listp_emit_program_list:
    ; Traverse the linked relation-clause list without instantiating it.  For
    ; each node, skip metadata to the compiled head/body stream and render one
    ; source-like standard-syntax clause.
    ; Emit every clause belonging to the selected relation list.  Each clause
    ; is formatted by listp_emit_clause and followed by its list tail.
    ld a,(hl)
    cp 010h
    ret z
    cp 003h
    ret nz
    call term_load_payload_hl
    push hl
    call term_load_payload_hl
    inc hl
    inc hl
    inc hl
    call term_load_payload_hl
    call listp_emit_clause
    pop hl
    inc hl
    inc hl
    inc hl
    jr listp_emit_program_list
listp_emit_clause:
    ; Reconstruct the omitted relation name before the stored head arguments.
    ; Relative variables are printed from their local offsets, giving consistent
    ; names without allocating an execution frame.
    ; Print one stored clause in standard readable syntax.  The two initial '('
    ; characters account for the outer clause list and its head atom.
    ld a,028h
    call IO_OUTPUT_CALLBACK_JUMP
    call IO_OUTPUT_CALLBACK_JUMP
    push hl
    ld hl,(PRIMITIVE_ARG2_VALUE)
    call listp_emit_constant_name
    pop hl
    push hl
    call listp_pretty_print_tail
    pop hl
.listp_emit_clause_body_goal:
    ; Each body goal is stored as the next three-byte cell in the compiled stream.
    ; Emit it on an indented new line until the stream tail is no longer LIST.
    inc hl
    inc hl
    inc hl
    ld a,(hl)
    cp 003h
    jr nz,.listp_close_clause
    call term_load_payload_hl
    call io_emit_enter
    ld a,020h
    call IO_OUTPUT_CALLBACK_JUMP
    call IO_OUTPUT_CALLBACK_JUMP
    push hl
    call listp_pretty_print_term
    pop hl
    jr .listp_emit_clause_body_goal
.listp_close_clause:
    call listp_pretty_finish_list
io_emit_enter:
    ; All output paths use the callback at 0x986B; emitting ASCII 13 therefore
    ; works for the console, printer, tape file, and RFILL keyboard buffer.
    ld a,00dh
    jp IO_OUTPUT_CALLBACK_JUMP
listp_pretty_print_term:
    ; Pretty-printer for stored (possibly relative) clause terms.  It mirrors the
    ; ordinary renderer but accepts RELATIVE variable cells that only exist in
    ; compiled clauses and therefore cannot be dereferenced without a frame.
    ; Recursive term formatter used by LISTP and RFILL.  Unlike W, it always
    ; emits syntax that the reader can reconstruct, including dotted tails.
    ld a,(hl)
    cp 003h
    jr nz,listp_pretty_print_atomic
    call term_load_payload_hl
    ld a,028h
    call IO_OUTPUT_CALLBACK_JUMP
listp_pretty_print_list_item:
    push hl
    call listp_pretty_print_term
    pop hl
    inc hl
    inc hl
    inc hl
listp_pretty_print_tail:
    ld a,(hl)
    cp 003h
    jr nz,listp_pretty_finish_list
    ld a,020h
    call IO_OUTPUT_CALLBACK_JUMP
    call term_load_payload_hl
    jr listp_pretty_print_list_item
listp_pretty_finish_list:
    cp 010h
    jr nz,.listp_emit_improper_tail
.listp_emit_close_parenthesis:
    ld a,029h
    jp IO_OUTPUT_CALLBACK_JUMP
.listp_emit_improper_tail:
    ld a,07ch
    call IO_OUTPUT_CALLBACK_JUMP
    call listp_pretty_print_term
    jr .listp_emit_close_parenthesis
listp_pretty_print_atomic:
    cp 008h
    jr nz,listp_emit_relative_variable
    call term_load_payload_hl
listp_emit_constant_name:
    inc hl
    inc hl
    inc hl
    jp io_render_constant_spelling
listp_emit_relative_variable:
    ; Convert byte offset 3*n back to generated ordinal n+1.  The multiply-by-85
    ; sequence computes division by three modulo 256 for valid local offsets,
    ; then shares the normal X,Y,Z,x,y,z name generator.
    cp 00ch
    jr nz,.listp_emit_integer
    inc hl
    ld a,(hl)
    ld c,a
    sla c
    add a,c
    sla c
    sla c
    add a,c
    sla c
    sla c
    add a,c
    sla c
    sla c
    add a,c
    ld l,a
    inc l
    ld h,000h
    jp io_emit_generated_variable_name
.listp_emit_integer:
    cp 004h
    jr nz,.listp_emit_float
    call term_load_payload_hl
    jp io_print_signed_integer
.listp_emit_float:
    cp 00ah
    jr nz,.listp_emit_empty_list
    call term_load_payload_hl
    jp io_print_float
.listp_emit_empty_list:
    cp 010h
    call nz,system_abort
    ld a,028h
    call IO_OUTPUT_CALLBACK_JUMP
    ld a,029h
    jp IO_OUTPUT_CALLBACK_JUMP
