; -----------------------------------------------------------------------------
; Architectural module: 11_arithmetic.asm
; Reversible arithmetic relations and decimal numeric engine.
; Original monolithic line range: 9329-11116.
; Emitted address range: 0x8B15-0x9477.
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Arithmetic predicates and numeric conversion
; -----------------------------------------------------------------------------
; SUM and TIMES are reversible three-argument relations.  Their dispatch
; automata accept all-known calls and each of the three useful one-variable
; modes.  The arithmetic core works in an unpacked decimal representation so
; integer and floating-point arguments can be mixed without separate handlers.

; ============================================================================
; CHAPTER 11 — DECIMAL ARITHMETIC AS REVERSIBLE RELATIONS
; ============================================================================
;
; Arithmetic is not exposed as one-way functions.  SUM X Y Z can verify three
; known values or solve for any one unknown; TIMES does the same with
; multiplication and division.  Their dispatch automata select the algebraic
; rearrangement before entering the shared numeric engine.
;
; Integers and floats are first expanded into a common decimal workspace:
;
;       sign/control, biased decimal exponent, guard digit, eight digits
;
; Operations work on those unpacked decimal digits.  The result is normalized
; and packed back to a 16-bit integer whenever possible, otherwise to the
; six-byte packed-BCD floating form.  This keeps mixed arithmetic transparent
; to Prolog code.
;
sum_constant_entry:
    defb TERM_TAG_CONSTANT
    defw sum_value_cell
    defb TERM_TAG_LIST
    defw times_constant_entry
sum_value_cell:
    defb TERM_TAG_INTEGER
    defw sum_primitive
; Reversible SUM modes
; --------------------
;   SUM 2 3 5   verify 2+3=5
;   SUM 2 3 Z   compute Z=5
;   SUM 2 Y 5   compute Y=5-2=3
;   SUM X 2 5   compute X=5-2=3
;
; The five-byte dispatch automaton identifies which one operand is unbound and
; selects the corresponding terminal handler.  All modes convert known operands
; to the common decimal workspace.  Unknown results remain pending in dispatcher
; slots and are bound only after arithmetic returns Z.
sum_name:
    defb 053h,055h,04dh,SYSTEM_NAME_TERMINATOR ; "SUM"

; SUM x y z means x + y = z.  At least two positions must be numeric; the
; remaining position may be an unbound variable and is then calculated.
sum_primitive:
    ld ix,sum_expect_arg1_state
    jp primitive_argument_dispatch

; x known -> inspect y; x unbound -> both y and z must be known.
sum_expect_arg1_state:
    defb DISPATCH_REJECT
    defb sum_x_known_expect_y_state-sum_expect_arg1_state
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb sum_x_unbound_expect_y_state-sum_expect_arg1_state

; x and y known -> z may be known (check) or unbound (addition).
sum_x_known_expect_y_state:
    defb DISPATCH_REJECT
    defb sum_xy_known_expect_z_state-sum_x_known_expect_y_state
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb sum_y_unbound_expect_z_state-sum_x_known_expect_y_state
sum_xy_known_expect_z_state:
    defb DISPATCH_REJECT
    defb sum_all_known_completion-sum_xy_known_expect_z_state
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb sum_z_unbound_completion-sum_xy_known_expect_z_state
sum_all_known_completion:
    defb sum_check_equation-sum_all_known_completion
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
sum_z_unbound_completion:
    defb sum_bind_z-sum_z_unbound_completion
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT

; x known, y unbound: z must be numeric, then y = z - x.
sum_y_unbound_expect_z_state:
    defb DISPATCH_REJECT
    defb sum_bind_y_completion-sum_y_unbound_expect_z_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
sum_bind_y_completion:
    defb sum_bind_y-sum_bind_y_completion
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT

; x unbound: y and z must both be numeric, then x = z - y.
sum_x_unbound_expect_y_state:
    defb DISPATCH_REJECT
    defb sum_x_unbound_expect_z_state-sum_x_unbound_expect_y_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
sum_x_unbound_expect_z_state:
    defb DISPATCH_REJECT
    defb sum_bind_x_completion-sum_x_unbound_expect_z_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
sum_bind_x_completion:
    defb sum_bind_x-sum_bind_x_completion
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT

; Check x+y=z by forming -(x+y)+z and succeeding only when it is zero.
; ----------------------------------------------------------------------------
; SUM'S FOUR DIRECTIONS
; ----------------------------------------------------------------------------
;
; With all arguments bound, add X and Y and compare with Z.  With Z unbound,
; bind it to X+Y.  With X or Y unbound, negate the other known addend and use
; the same decimal addition routine to compute the missing value.
;
; The relation interface is reversible; the decimal engine itself remains one
; straightforward signed addition implementation.
;
sum_check_equation:
    call arithmetic_prepare_three_numbers
    ld hl,NUMERIC_ARG1_BUFFER
    ld de,NUMERIC_ARG2_BUFFER
    ld bc,NUMERIC_WORK_A
    call decimal_add
    ld hl,NUMERIC_WORK_A
    call decimal_toggle_sign
    ld de,NUMERIC_ARG3_BUFFER
    ld bc,NUMERIC_WORK_B
    call decimal_add
    ld hl,NUMERIC_WORK_B
    jp decimal_test_zero

; z := x+y.  Result conversion chooses a compact integer cell whenever the
; value fits; otherwise it allocates and returns a floating-point object.
sum_bind_z:
    call arithmetic_prepare_three_numbers
    ld hl,NUMERIC_ARG1_BUFFER
    ld de,NUMERIC_ARG2_BUFFER
    ld bc,NUMERIC_WORK_A
    call decimal_add
    call numeric_result_from_decimal_buffer
    ld (PRIMITIVE_ARG3_RESULT_TAG),a
    ld (PRIMITIVE_ARG3_RESULT_VALUE),hl
    ret

; x := z-y.
sum_bind_x:
    call arithmetic_prepare_three_numbers
    ld hl,NUMERIC_ARG2_BUFFER
    call decimal_toggle_sign
    ld de,NUMERIC_ARG3_BUFFER
    ld bc,NUMERIC_WORK_A
    call decimal_add
    call numeric_result_from_decimal_buffer
    ld (PRIMITIVE_ARG1_RESULT_TAG),a
    ld (PRIMITIVE_ARG1_RESULT_VALUE),hl
    ret

; y := z-x.
sum_bind_y:
    call arithmetic_prepare_three_numbers
    ld hl,NUMERIC_ARG1_BUFFER
    call decimal_toggle_sign
    ld de,NUMERIC_ARG3_BUFFER
    ld bc,NUMERIC_WORK_A
    call decimal_add
    call numeric_result_from_decimal_buffer
    ld (PRIMITIVE_ARG2_RESULT_TAG),a
    ld (PRIMITIVE_ARG2_RESULT_VALUE),hl
    ret
times_constant_entry:
    defb TERM_TAG_CONSTANT
    defw times_value_cell
    defb TERM_TAG_LIST
    defw less_constant_entry
times_value_cell:
    defb TERM_TAG_INTEGER
    defw times_primitive
; When TIMES solves an unknown factor it uses decimal division.  A known divisor of
; zero is detected in that division path before quotient generation.  The system
; reports the documented arithmetic-overflow error rather than logical failure,
; because the requested arithmetic relation is undefined, not merely false.
times_name:
    defb 054h,049h,04dh,045h,053h,SYSTEM_NAME_TERMINATOR ; "TIMES"

; TIMES x y z means x*y=z.  Its four completions parallel SUM: verify a
; complete equation, calculate z, or divide z by the known factor to bind x/y.
; Reverse multiplication policy
; -----------------------------
; TIMES can solve one unknown by division only when the known divisor is nonzero.
; The decimal divider produces the interpreter's finite eight-digit numeric
; representation; overflow, zero divisor, or a result outside representable
; exponent range signals arithmetic error.  The relation does not require an
; integer quotient--a representable floating result is acceptable--but later
; canonicalization converts an exact in-range integral result back to INTEGER.
times_primitive:
    ld ix,times_expect_arg1_state
    jp primitive_argument_dispatch
times_expect_arg1_state:
    defb DISPATCH_REJECT
    defb times_x_known_expect_y_state-times_expect_arg1_state
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb times_x_unbound_expect_y_state-times_expect_arg1_state
times_x_known_expect_y_state:
    defb DISPATCH_REJECT
    defb times_xy_known_expect_z_state-times_x_known_expect_y_state
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb times_y_unbound_expect_z_state-times_x_known_expect_y_state
times_xy_known_expect_z_state:
    defb DISPATCH_REJECT
    defb times_all_known_completion-times_xy_known_expect_z_state
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb times_z_unbound_completion-times_xy_known_expect_z_state
times_all_known_completion:
    defb times_check_equation-times_all_known_completion
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
times_z_unbound_completion:
    defb times_bind_z-times_z_unbound_completion
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
times_y_unbound_expect_z_state:
    defb DISPATCH_REJECT
    defb times_bind_y_completion-times_y_unbound_expect_z_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
times_bind_y_completion:
    defb times_bind_y-times_bind_y_completion
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
times_x_unbound_expect_y_state:
    defb DISPATCH_REJECT
    defb times_x_unbound_expect_z_state-times_x_unbound_expect_y_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
times_x_unbound_expect_z_state:
    defb DISPATCH_REJECT
    defb times_bind_x_completion-times_x_unbound_expect_z_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
times_bind_x_completion:
    defb times_bind_x-times_bind_x_completion
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT

; Verify x*y=z by comparing the normalized eleven-byte product with z.
; ----------------------------------------------------------------------------
; TIMES REUSES MULTIPLY AND DIVIDE
; ----------------------------------------------------------------------------
;
; The all-known and result-unknown modes multiply.  Solving for either factor
; divides the product by the other factor.  Division by zero and values outside
; the decimal representation enter the common arithmetic-overflow error path,
; not logical failure.
;
times_check_equation:
    call arithmetic_prepare_three_numbers
    ld hl,NUMERIC_ARG1_BUFFER
    ld de,NUMERIC_ARG2_BUFFER
    ld bc,NUMERIC_WORK_A
    call decimal_multiply
    ld hl,NUMERIC_WORK_A
    ld de,NUMERIC_ARG3_BUFFER
    jp decimal_compare_equal

; z := x*y.
times_bind_z:
    call arithmetic_prepare_three_numbers
    ld hl,NUMERIC_ARG1_BUFFER
    ld de,NUMERIC_ARG2_BUFFER
    ld bc,NUMERIC_WORK_A
    call decimal_multiply
    call numeric_result_from_decimal_buffer
    ld (PRIMITIVE_ARG3_RESULT_TAG),a
    ld (PRIMITIVE_ARG3_RESULT_VALUE),hl
    ret

; x := z/y.
times_bind_x:
    call arithmetic_prepare_three_numbers
    ld hl,NUMERIC_ARG2_BUFFER
    ld de,NUMERIC_ARG3_BUFFER
    ld bc,NUMERIC_WORK_A
    call decimal_divide
    call numeric_result_from_decimal_buffer
    ld (PRIMITIVE_ARG1_RESULT_TAG),a
    ld (PRIMITIVE_ARG1_RESULT_VALUE),hl
    ret

; y := z/x.
times_bind_y:
    call arithmetic_prepare_three_numbers
    ld hl,NUMERIC_ARG1_BUFFER
    ld de,NUMERIC_ARG3_BUFFER
    ld bc,NUMERIC_WORK_A
    call decimal_divide
    call numeric_result_from_decimal_buffer
    ld (PRIMITIVE_ARG2_RESULT_TAG),a
    ld (PRIMITIVE_ARG2_RESULT_VALUE),hl
    ret

; Convert the three dispatcher slots to the common decimal work format.
; Integers are expanded directly; floating values are unpacked from their
; six-byte heap representation.
; ----------------------------------------------------------------------------
; THREE ARGUMENTS, THREE WORK SLOTS
; ----------------------------------------------------------------------------
;
; The dispatcher has already saved addresses and tags.  This routine converts
; each numeric argument into its fixed expanded-decimal slot so later operations
; can refer to operands by address rather than repeat type tests.
;
; Integer conversion and float unpacking converge here; result construction at
; numeric_result_from_decimal_buffer performs the reverse convergence.
;
; Common decimal workspace
; ------------------------
; Tagged INTEGER and FLOAT terms are converted to the same scratch layout:
;
;       byte 0      sign/control
;       byte 1      biased decimal exponent
;       byte 2      guard/carry digit
;       bytes 3-10  eight decimal digits, one digit per byte
;
; Three operands occupy parallel work areas.  Reversible SUM/TIMES modes merely
; choose which two are inputs and which slot receives the result.  After an
; operation, packing removes leading/trailing zeroes, rounds as required, and
; tries to return a compact 16-bit INTEGER before constructing a FLOAT.
arithmetic_prepare_three_numbers:
    ld b,003h
    ld ix,PRIMITIVE_ARG1_SLOT
    ld de,NUMERIC_ARG1_BUFFER
.arithmetic_prepare_next_number:
    ld a,(ix+005h)
    cp TERM_TAG_INTEGER
    jr nz,.arithmetic_prepare_float
    ld l,(ix+003h)
    ld h,(ix+004h)
    call integer_to_decimal
.arithmetic_advance_number_slot:
    push de
    ld de,00006h
    add ix,de
    pop de
    ld hl,0000bh
    add hl,de
    ex de,hl
    djnz .arithmetic_prepare_next_number
    ret
.arithmetic_prepare_float:
    cp TERM_TAG_FLOAT
    jr nz,.arithmetic_advance_number_slot
    ld l,(ix+003h)
    ld h,(ix+004h)
    call numeric_unpack_float_to_decimal
    jr .arithmetic_advance_number_slot

; Convert the decimal result at BC back to a micro-PROLOG numeric term.
; Prefer a 16-bit integer; otherwise allocate six bytes and pack a float.
numeric_result_from_decimal_buffer:
    ld h,b
    ld l,c
    call decimal_try_to_integer
    jr nz,.numeric_result_requires_float
    ex de,hl
    ld a,TERM_TAG_INTEGER
    ret
.numeric_result_requires_float:
    ex de,hl
    call allocate_two_term_cells             ; Allocate a six-byte floating-point object.
    call numeric_pack_decimal_to_float
    ld a,TERM_TAG_FLOAT
    cp a
    ret
less_constant_entry:
    defb TERM_TAG_CONSTANT
    defw less_value_cell
    defb TERM_TAG_LIST
    defw sign_constant_entry
less_value_cell:
    defb TERM_TAG_INTEGER
    defw less_primitive
less_name:
    defb 04ch,045h,053h,053h,SYSTEM_NAME_TERMINATOR ; "LESS"

; LESS is overloaded for numeric ordering and lexicographic constant ordering.
; Mixed numeric/constant calls are rejected by the dispatcher itself.
less_primitive:
    ld ix,less_expect_arg1_state
    jp primitive_argument_dispatch
less_expect_arg1_state:
    defb DISPATCH_REJECT
    defb less_numeric_expect_arg2_state-less_expect_arg1_state
    defb less_constant_expect_arg2_state-less_expect_arg1_state
    defb DISPATCH_REJECT,DISPATCH_REJECT
less_numeric_expect_arg2_state:
    defb DISPATCH_REJECT
    defb less_numeric_completion-less_numeric_expect_arg2_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
less_numeric_completion:
    defb less_compare_numbers-less_numeric_completion
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
less_constant_expect_arg2_state:
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb less_constant_completion-less_constant_expect_arg2_state
    defb DISPATCH_REJECT,DISPATCH_REJECT
less_constant_completion:
    defb less_compare_constants-less_constant_completion
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT

; Normalize both numbers, then compare sign, exponent and decimal digits.
; The primitive returns with Z only when the strict less-than relation holds.
; ----------------------------------------------------------------------------
; LESS HAS TWO UNRELATED ORDERS
; ----------------------------------------------------------------------------
;
; Numeric LESS compares signs, exponents and normalized digits.  Constant LESS
; compares stored name bytes lexicographically.  The dispatch table rejects a
; mixed numeric/constant pair before either comparison starts.
;
less_compare_numbers:
    call arithmetic_prepare_three_numbers
    ld hl,NUMERIC_ARG1_BUFFER
    call decimal_test_zero
    jr nz,.less_first_nonzero
    xor a
    ld (NUMERIC_ARG1_BUFFER+1),a
.less_first_nonzero:
    ex de,hl
    ld hl,NUMERIC_ARG2_BUFFER
    call decimal_test_zero
    jr nz,.less_second_nonzero
    xor a
    ld (NUMERIC_ARG2_BUFFER+1),a
.less_second_nonzero:
    ld b,00ah
    ld a,(de)
    cp (hl)
    ret m
    jr z,.less_same_sign
.less_not_less:
    cp a
    ret
.less_same_sign:
    cp 008h                    ; Negative values reverse magnitude ordering.
    jr z,.less_compare_magnitude
    ex de,hl
.less_compare_magnitude:
    inc de
    inc hl
    ld a,(de)
    cp (hl)
    ret c
    jr nz,.less_not_less
    djnz .less_compare_magnitude
    or 001h                    ; Equal numbers are not strictly less.
    ret

; Constants point to FF-terminated byte strings.  Skip the three-byte constant
; cells and compare bytes until a difference or the shared terminator.
less_compare_constants:
    ld hl,(PRIMITIVE_ARG1_VALUE)
    ld de,(PRIMITIVE_ARG2_VALUE)
    inc hl
    inc hl
    inc hl
    inc de
    inc de
    inc de
.less_compare_constant_bytes:
    ld a,(de)
    cp (hl)
    jr nz,.less_constant_difference
    cp SYSTEM_NAME_TERMINATOR
    jr z,.less_constants_equal
    inc hl
    inc de
    jr .less_compare_constant_bytes
.less_constant_difference:
    sub (hl)
    bit 7,a
    ret
.less_constants_equal:
    or 001h
    ret
sign_constant_entry:
    defb TERM_TAG_CONSTANT
    defw sign_value_cell
    defb TERM_TAG_LIST
    defw int_constant_entry
sign_value_cell:
    defb TERM_TAG_INTEGER
    defw sign_primitive
sign_name:
    defb 053h,049h,047h,04eh,SYSTEM_NAME_TERMINATOR ; "SIGN"

; SIGN number output binds output to -1, 0 or +1.  Integer sign comes from the
; 16-bit payload; floating sign is bit 3 of the first byte of the float object.
sign_primitive:
    ld ix,sign_expect_number_state
    jp primitive_argument_dispatch
sign_expect_number_state:
    defb DISPATCH_REJECT
    defb sign_expect_output_state-sign_expect_number_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
sign_expect_output_state:
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
    defb sign_completion_state-sign_expect_output_state
sign_completion_state:
    defb sign_bind_result-sign_completion_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
sign_bind_result:
    ld a,(PRIMITIVE_ARG1_TAG)
    ld hl,(PRIMITIVE_ARG1_VALUE)
    cp TERM_TAG_INTEGER
    jr nz,.sign_float
    ld a,l
    or a
    jr nz,.sign_integer_nonzero
    or h
    jr z,.sign_store_result
.sign_integer_nonzero:
    bit 7,h
    jr nz,.sign_negative
    jr .sign_positive
.sign_float:
    bit 3,(hl)
    jr z,.sign_positive
.sign_negative:
    ld hl,0ffffh
    jr .sign_store_result
.sign_positive:
    ld hl,00001h
.sign_store_result:
    ld a,TERM_TAG_INTEGER
    ld (PRIMITIVE_ARG2_RESULT_TAG),a
    ld (PRIMITIVE_ARG2_RESULT_VALUE),hl
    cp a
    ret
int_constant_entry:
    defb TERM_TAG_CONSTANT
    defw int_value_cell
    defb TERM_TAG_LIST
    defw w_constant_entry
int_value_cell:
    defb TERM_TAG_INTEGER
    defw int_primitive
int_name:
    defb 049h,04eh,054h,SYSTEM_NAME_TERMINATOR ; "INT"

; INT has two independent forms:
;   INT number          succeeds when the value is mathematically integral;
;   INT number output   truncates toward zero and binds output.
; A nonnumeric one-argument call simply fails.  A missing first argument or a
; non-variable second argument is rejected by the compact dispatch automaton.
; ----------------------------------------------------------------------------
; INT IS BOTH A TEST AND A CONVERSION
; ----------------------------------------------------------------------------
;
; Unary INT succeeds only when the value has no fractional decimal digits.
; Binary INT truncates toward zero and binds the second argument.  Large integral
; results may remain floating values; fitting results are canonicalized to the
; compact integer cell.
;
int_primitive:
    ld ix,int_expect_arg1_state
    jp primitive_argument_dispatch
int_expect_arg1_state:
    defb DISPATCH_REJECT
    defb int_numeric_first_state-int_expect_arg1_state
    defb int_nonnumeric_first_state-int_expect_arg1_state
    defb int_nonnumeric_first_state-int_expect_arg1_state
    defb int_unbound_first_state-int_expect_arg1_state
int_numeric_first_state:
    defb int_test_integer-int_numeric_first_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
    defb int_output_state-int_numeric_first_state
int_output_state:
    defb int_truncate_and_bind-int_output_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
int_unbound_first_state:
    defb int_fail-int_unbound_first_state
    defb int_invalid_two_argument_state-int_unbound_first_state
    defb int_invalid_two_argument_state-int_unbound_first_state
    defb int_invalid_two_argument_state-int_unbound_first_state
    defb int_invalid_two_argument_state-int_unbound_first_state
int_invalid_two_argument_state:
    defb int_argument_error-int_invalid_two_argument_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
int_nonnumeric_first_state:
    defb int_fail-int_nonnumeric_first_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
int_fail:
    or 001h
    ret
int_argument_error:
    jp signal_control_error

; One-argument predicate.  Integer-tagged values succeed immediately.  A
; floating value is integral when its exponent leaves no stored fractional
; decimal digits; smaller exponents necessarily carry a fractional part because
; values representable as 16-bit integers are canonicalized to integer cells.
int_test_integer:
    ld ix,PRIMITIVE_ARG1_SLOT
numeric_value_is_integer:
    ld a,(ix+005h)
    cp TERM_TAG_INTEGER
    ret z
    ld l,(ix+003h)
    ld h,(ix+004h)
    inc hl
    ld a,(hl)                  ; Biased decimal exponent in packed float.
    cp 088h                    ; Eight significant digits are all integral.
    ret c
    cp a
    ret

; Two-argument form.  Convert the first slot in place to the nearest integer
; toward zero, then copy its resulting tag/payload into the second result cell.
int_truncate_and_bind:
    ld ix,PRIMITIVE_ARG1_SLOT
    call numeric_truncate_dispatch_argument
    ld a,(PRIMITIVE_ARG1_TAG)
    ld hl,(PRIMITIVE_ARG1_VALUE)
    ld (PRIMITIVE_ARG2_RESULT_TAG),a
    ld (PRIMITIVE_ARG2_RESULT_VALUE),hl
    cp a
    ret

; Normalize one dispatcher argument to an integral value.  Small results become
; ordinary integer cells.  Large results remain floating point, but fractional
; decimal positions in the temporary representation are cleared before it is
; repacked/allocated by numeric_result_from_decimal_buffer.
numeric_truncate_dispatch_argument:
    call numeric_value_is_integer
    ret z
    ld l,(ix+003h)
    ld h,(ix+004h)
    ld de,NUMERIC_ARG1_BUFFER
    call numeric_unpack_float_to_decimal
    ld a,(NUMERIC_ARG1_BUFFER+1)
    sub 080h
    jp p,.numeric_truncate_clear_fraction
    ld a,TERM_TAG_INTEGER
    ld hl,00000h
    jr .numeric_truncate_store_slot
.numeric_truncate_clear_fraction:
    ld b,a
    ld a,008h
    sub b
    ld b,a
    ld hl,NUMERIC_ARG1_BUFFER+10
.numeric_truncate_zero_loop:
    ld (hl),000h
    dec hl
    djnz .numeric_truncate_zero_loop
    ld bc,NUMERIC_ARG1_BUFFER
    call numeric_result_from_decimal_buffer
.numeric_truncate_store_slot:
    ld (ix+003h),l
    ld (ix+004h),h
    ld (ix+005h),a
    ret

; The decimal core never delegates to the Spectrum ROM calculator.  Integers and
; packed floats are expanded to a common sign/exponent/digit workspace; SUM,
; TIMES, LESS, SIGN and INT then share normalization and conversion paths.
;
; Expand a packed six-byte floating value into the internal decimal arithmetic
; form: sign, biased exponent, and eight individual decimal digits.
; Concrete packed-float example: 12.34
; -----------------------------------
; A FLOAT stores eight BCD digits in four bytes plus sign/control and biased
; decimal exponent.  Conceptually 12.34 is normalized as:
;
;       sign = positive
;       digits = 1 2 3 4 0 0 0 0
;       exponent = position placing decimal after the second digit
;
; Packed representation groups digits as 0x12, 0x34, 0x00, 0x00.  Unpacking
; expands each nibble into one workspace byte and inserts a zero guard digit.
; The exact exponent bias is handled arithmetically below; callers operate only
; on the expanded decimal model.
numeric_unpack_float_to_decimal:
    push hl
    push de
    push bc
    push af
    ld a,(hl)
    ld (de),a
    inc hl
    inc de
    ld a,(hl)
    ld (de),a
    inc de
    ld a,000h
    ld (de),a
    ld b,004h
.numeric_unpack_bcd_byte_loop:
    inc de
    inc hl
    ld a,(hl)
    rra
    rra
    rra
    rra
    and 00fh
    ld (de),a
    inc de
    ld a,(hl)
    and 00fh
    ld (de),a
    djnz .numeric_unpack_bcd_byte_loop
    pop af
    pop bc
    pop de
    pop hl
    ret
; Pack sign, biased exponent and eight decimal digits into the six-byte
; micro-PROLOG floating-point heap format (two BCD digits per byte).
numeric_pack_decimal_to_float:
    push hl
    push de
    push bc
    ex de,hl
    ldi
    ldi
    ld b,004h
.numeric_pack_bcd_byte_loop:
    inc hl
    ld a,(hl)
    rlca
    rlca
    rlca
    rlca
    inc hl
    or (hl)
    ld (de),a
    inc de
    djnz .numeric_pack_bcd_byte_loop
    pop bc
    pop de
    pop hl
    ret
; Normalize an expanded decimal value after arithmetic: shift away leading
; zero digits, adjust the exponent, and canonicalize exact zero.
; ----------------------------------------------------------------------------
; NORMALIZATION DEFINES THE CANONICAL DECIMAL FORM
; ----------------------------------------------------------------------------
;
; Leading zeroes are removed by shifting digits and adjusting the decimal
; exponent.  An all-zero mantissa receives the unique zero sign/exponent form.
; Trailing workspace bytes are cleared so later comparisons and packing do not
; observe stale digits.
;
; Nearly every arithmetic path ends here, making this routine the point where
; different calculations are forced into one representation.
;
; Normalization pseudocode
; ------------------------
;       if all digits are zero:
;           sign = positive; exponent = canonical_zero_exponent; return
;
;       while guard/leading digit is zero and exponent can decrease:
;           shift mantissa left one decimal place
;           exponent--
;
;       if guard digit is nonzero after an operation:
;           shift mantissa right one decimal place
;           exponent++
;
;       inspect discarded digit(s) and round retained eight digits
;       if rounding carries out of the first digit:
;           shift right; exponent++
;       reject exponent overflow/underflow according to numeric policy
;
; Sign normalization and zero canonicalization are interleaved with shifts so
; every caller receives one unique representation of the same numeric value.
decimal_normalize:
    push bc
    push de
    push hl
    ld b,009h
    inc hl
    ld c,(hl)
    inc hl
    ld a,(hl)
    or a
    jr z,.decimal_normalize_scan_leading_zero
    inc c
    jp z,arithmetic_overflow_error
    push hl
    push bc
    ld bc,00010h
    add hl,bc
    ld d,h
    ld e,l
    dec hl
    lddr
    pop bc
    pop hl
    xor a
    ld (hl),a
; Skip leading zero digits while decreasing the effective decimal exponent.
.decimal_normalize_scan_leading_zero:
    inc hl
    cp (hl)
    jr nz,.decimal_normalize_shift_digits
    dec b
    jr z,.decimal_normalize_make_zero
    dec c
    jr nz,.decimal_normalize_scan_leading_zero
    jp signal_arithmetic_underflow_error
; Canonical zero has positive sign, exponent 0x80 and all digits cleared.
.decimal_normalize_make_zero:
    pop hl
    push hl
    ld b,009h
    xor a
    ld (hl),a
    inc hl
    ld (hl),080h
.decimal_normalize_clear_zero_digits:
    inc hl
    ld (hl),a
    djnz .decimal_normalize_clear_zero_digits
    jr .decimal_normalize_return
.decimal_normalize_shift_digits:
    pop de
    push de
    inc de
    ld a,c
    ld (de),a
    inc de
    inc de
    ld bc,00008h
    ldir
.decimal_normalize_return:
    pop hl
    pop de
    pop bc
    ret
; Add two expanded decimal values at HL and DE into the work area at BC.
; Sign handling is implemented by ten's-complementing negative mantissas,
; aligning exponents, adding digit-by-digit in BCD, then normalizing.
; ----------------------------------------------------------------------------
; SIGNED ADDITION THROUGH COMPLEMENTED DIGITS
; ----------------------------------------------------------------------------
;
; Operands are aligned by decimal exponent.  If their signs differ, one mantissa
; is complemented and the digit loop still performs addition.  The carry and
; resulting sign determine whether a final complement is needed before
; normalization.
;
; This costs more instructions than binary arithmetic but preserves the decimal
; precision and exponent behavior expected by the original language.
;
; Signed unequal-exponent example
; -------------------------------
; Add 12.3 and -0.45:
;
;       12.3  -> digits 1 2 3 0 ... exponent for tens
;       0.45  -> digits 4 5 0 0 ... exponent two places smaller
;
; First align exponents by shifting the smaller mantissa right:
;
;       12.30
;       -0.45
;
; Opposite signs select magnitude subtraction.  The routine subtracts decimal
; digits with borrow, chooses the sign of the larger magnitude, then normalizes
; 11.85.  Same signs instead use ordinary digit addition with carry.
; Signed alignment example: 12.3 + (-0.45)
; ---------------------------------------
; After unpacking and exponent alignment, conceptual digit windows are:
;
;       + 1 2 . 3 0
;       - 0 0 . 4 5
;
; Sign handling converts the second mantissa to the subtraction form; aligned
; digit addition yields 11.85.  Normalization removes leading/trailing workspace
; zeroes, adjusts the decimal exponent, and keeps guard digits only as long as
; rounding requires them.
decimal_add:
    push hl
    push de
    push bc
    bit 3,(hl)
    call nz,decimal_negate_mantissa
    inc hl
    ex de,hl
    bit 3,(hl)
    call nz,decimal_negate_mantissa
    inc hl
    ex de,hl
    push hl
    push bc
    ld h,b
    ld l,c
    ld b,013h
    xor a
.decimal_add_clear_result:
    ld (hl),a
    inc hl
    djnz .decimal_add_clear_result
    pop bc
    pop hl
    inc bc
    ld a,(de)
    cp (hl)
    jr c,.decimal_add_order_operands
    ex de,hl
.decimal_add_order_operands:
    call decimal_test_zero
    jr z,.decimal_add_copy_primary_operand
    ex de,hl
.decimal_add_copy_primary_operand:
    push bc
    push de
    push hl
    ex de,hl
    ld d,b
    ld e,c
    ld bc,0000ah
    ldir
    pop hl
    pop de
    pop bc
    ld a,(de)
    sub (hl)
    cp 00bh
    jr nc,.decimal_add_resolve_sign
    ld de,00009h
    add hl,de
    ex de,hl
    push af
    add a,009h
    ld l,a
    add hl,bc
    or a
    ld b,009h
; Add aligned digits right-to-left using DAA to retain unpacked BCD digits.
.decimal_add_digit_loop:
    ld a,(de)
    adc a,(hl)
    daa
    ld c,a
    and 00fh
    ld (hl),a
    ld a,c
    cp 00ah
    ccf
    dec hl
    dec de
    djnz .decimal_add_digit_loop
    pop af
    ld b,a
    inc de
    ld a,(de)
    cp 005h
    jr nc,.decimal_add_select_complement_nine
    ld d,000h
    jr .decimal_add_prepare_sign_fixup
.decimal_add_select_complement_nine:
    ld d,009h
.decimal_add_prepare_sign_fixup:
    xor a
    cp b
    jr z,.decimal_add_resolve_sign
; Propagate the final complement/carry state through unused leading positions.
.decimal_add_carry_fixup_loop:
    ld a,c
    cp 00ah
    ccf
    ld a,(hl)
    adc a,d
    daa
    ld c,a
    and 00fh
    ld (hl),a
    dec hl
    djnz .decimal_add_carry_fixup_loop
.decimal_add_resolve_sign:
    pop hl
    push hl
    inc hl
    inc hl
    ld a,(hl)
    cp 005h
    jr c,.decimal_add_normalize_result
    dec hl
    dec hl
    call decimal_negate_mantissa
    ld (hl),008h
.decimal_add_normalize_result:
    pop hl
    push hl
    call decimal_normalize
    pop bc
    pop de
    pop hl
    ret
; Replace the nine decimal mantissa digits by their ten's complement.  The
; sign/exponent bytes are preserved; callers toggle the sign separately.
decimal_negate_mantissa:
    push hl
    push bc
    ld bc,0000ah
    add hl,bc
    ld b,009h
    or a
.decimal_negate_digit_loop:
    ld a,010h
    sbc a,(hl)
    daa
    push af
    and 00fh
    ld (hl),a
    pop af
    cp 00ah
    dec hl
    djnz .decimal_negate_digit_loop
    pop bc
    pop hl
    ret
; Toggle the arithmetic sign bit in the expanded numeric header.
decimal_toggle_sign:
    ld a,(hl)
    xor 008h
    ld (hl),a
    ret
; Return Z only when all significant decimal digits are zero.  Negative
; values return NZ immediately because a normalized negative zero is forbidden.
decimal_test_zero:
    bit 3,(hl)
    ret nz
    push hl
    push bc
    ld b,009h
    inc hl
.decimal_zero_scan_loop:
    inc hl
    ld a,(hl)
    or a
    jr nz,.decimal_zero_test_return
    djnz .decimal_zero_scan_loop
.decimal_zero_test_return:
    pop bc
    pop hl
    ret
; Multiply two eight-digit decimal mantissas.  The routine combines signs and
; exponents first, accumulates partial products in BCD, then normalizes.
; ----------------------------------------------------------------------------
; MULTIPLICATION IS SCHOOLBOOK DECIMAL ARITHMETIC
; ----------------------------------------------------------------------------
;
; Each digit of one mantissa multiplies every digit of the other, with carries
; accumulated into an extended result area.  Exponents add and signs XOR.  The
; guard digit gives normalization and rounding room before the packed eight-digit
; result is produced.
;
; Grade-school multiplication and the guard digit
; ----------------------------------------------
; For short mantissas 12 * 34, the code performs the familiar partial products:
;
;       12 * 4  -> 48
;       12 * 3  -> 36, shifted one digit
;       sum     -> 408
;
; The real loops use eight input digits and a wider temporary result.  The ninth
; guard digit retains the first discarded decimal place, allowing normalization
; and rounding to choose the best eight-digit result rather than silently
; truncating at the workspace boundary.
; Two-digit long-multiplication map
; ---------------------------------
; For 12 x 34 the nested loops correspond to:
;
;       2 x 4 =  8        units partial
;       1 x 4 =  4        tens contribution
;       2 x 3 =  6        shifted tens partial
;       1 x 3 =  3        shifted hundreds partial
;       ----------------
;                 408
;
; The actual engine uses unpacked decimal digits and propagates carries after
; accumulating these shifted partial products.
decimal_multiply:
    push hl
    push de
    push bc
    push ix
    ld a,(de)
    xor (hl)
    ld (bc),a
    inc hl
    inc de
    inc bc
    push bc
    ld c,080h
    ld a,(de)
    sub c
    ld b,a
    ld a,(hl)
    sub c
    add a,b
    jp pe,arithmetic_overflow_error
    add a,c
    pop bc
    ld (bc),a
    push hl
    ld h,b
    ld l,c
    ld b,011h
.decimal_multiply_clear_accumulator:
    inc hl
    ld (hl),000h
    djnz .decimal_multiply_clear_accumulator
    push hl
    pop ix
    pop hl
    ld bc,00009h
    add hl,bc
    ex de,hl
    add hl,bc
    ld b,008h
; Accumulate one multiplier digit across the shifted multiplicand window.
.decimal_multiply_outer_digit_loop:
    push bc
    push ix
    push hl
    ld bc,00900h
; Form and add one BCD partial product digit with carry.
.decimal_multiply_inner_digit_loop:
    push de
    push bc
    ld a,(de)
    ld e,a
    ld d,(hl)
    ld b,004h
    xor a
.decimal_multiply_add_partial_product:
    rr d
    jr nc,.decimal_multiply_store_digit
    add a,e
.decimal_multiply_store_digit:
    rlc e
    djnz .decimal_multiply_add_partial_product
    ld e,000h
    ld b,00ah
.decimal_multiply_advance_partial:
    sub b
    jr c,.decimal_multiply_next_multiplier_digit
    inc e
    jr .decimal_multiply_advance_partial
.decimal_multiply_next_multiplier_digit:
    add a,b
    rlc e
    rlc e
    rlc e
    rlc e
    or e
    add a,(ix+000h)
    daa
    pop bc
    add a,c
    daa
    push af
    and 00fh
    ld (ix+000h),a
    pop af
    rrca
    rrca
    rrca
    rrca
    and 00fh
    ld c,a
    pop de
    dec hl
    dec ix
    djnz .decimal_multiply_inner_digit_loop
    pop hl
    pop ix
    pop bc
    dec de
    dec ix
    djnz .decimal_multiply_outer_digit_loop
    pop ix
    pop hl
    push hl
    call decimal_normalize
    pop bc
    pop de
    pop hl
    ret
; Divide the value at DE by the non-zero value at HL into BC using repeated
; decimal subtraction, one quotient digit at a time.  Division by zero follows
; the common arithmetic-overflow error path.
; ----------------------------------------------------------------------------
; DIVISION GENERATES ONE DECIMAL DIGIT AT A TIME
; ----------------------------------------------------------------------------
;
; Repeated compare/subtract steps choose each quotient digit, then shift the
; remainder for the next place.  Exponents subtract and signs XOR.  A zero
; divisor is detected before digit generation and reports arithmetic overflow.
;
; Decimal division (pseudocode)
; -----------------------------
; This is long division over decimal digit arrays, not binary Z80 division.
;
;       decimal_divide(dividend, divisor):
;           if divisor == 0: arithmetic_error
;           result_sign = dividend.sign XOR divisor.sign
;           result_exponent = dividend.exponent - divisor.exponent
;           remainder = absolute(dividend.mantissa)
;           divisor  = absolute(divisor.mantissa)
;
;           normalize divisor and remainder so their leading digits align
;
;           for each quotient digit, including one guard digit:
;               q = 0
;               while remainder >= divisor:
;                   remainder -= divisor
;                   q++
;               emit q
;               remainder *= 10        ; bring down next decimal place
;
;           result.sign = result_sign
;           result.exponent += alignment adjustment
;           normalize and round using guard digit
;           reject exponent overflow; canonicalize zero
;
; The assembly avoids a general 80-bit compare/subtract abstraction by reusing
; digit-array helpers and carefully rotating workspace roles.  Keep the above
; loop in mind when register ownership appears to change abruptly.
; Short quotient trace: 7 / 2
; ---------------------------
; Start remainder=7.  Trial digit 3 is the largest with 3*2 <= 7; emit 3 and
; subtract 6, leaving remainder 1.  Shift the remainder by one decimal place
; (conceptually 10), choose trial digit 5 because 5*2=10, emit 5 and leave zero.
; The quotient digits are 3.5.  Further generated digits are guard digits; the
; final packer rounds them according to the same eight-significant-digit policy
; used by the other decimal operations.
decimal_divide:
    call decimal_test_zero
    jp z,arithmetic_overflow_error
    push hl
    push de
    push bc
    push ix
    ld a,(de)
    xor (hl)
    ld (bc),a
    inc hl
    inc de
    inc bc
    inc bc
    push bc
    pop ix
    ld c,080h
    ld a,(hl)
    sub c
    ld b,a
    ld a,(de)
    sub c
    sub b
    jp pe,arithmetic_overflow_error
    add a,c
    ld (ix-001h),a
    inc hl
    inc de
    ex de,hl
    push de
    ld de,NUMERIC_WORK_B
    ld bc,00009h
    ldir
    ld b,009h
    xor a
; Choose each quotient digit by repeated trial subtraction of the divisor.
.decimal_divide_trial_digit:
    ld (de),a
    inc de
    djnz .decimal_divide_trial_digit
    pop de
    ex de,hl
    ld de,NUMERIC_WORK_B_DIGIT_WINDOW
    ld bc,00008h
    add hl,bc
    ld b,009h
.decimal_divide_accept_trial:
    ld c,000h
    push bc
.decimal_divide_store_quotient_digit:
    push hl
    push de
    ld b,009h
    or a
; Shift the decimal remainder and bring down the next dividend digit.
.decimal_divide_shift_remainder:
    ld a,(de)
    sbc a,(hl)
    daa
    push af
    and 00fh
    ld (de),a
    pop af
    cp 00ah
    ccf
    dec hl
    dec de
    djnz .decimal_divide_shift_remainder
    pop de
    pop hl
    jr c,.decimal_divide_next_digit
    inc c
    jr .decimal_divide_store_quotient_digit
.decimal_divide_next_digit:
    push hl
    push de
    ld b,009h
    or a
.decimal_divide_finalize:
    ld a,(de)
    adc a,(hl)
    daa
    push af
    and 00fh
    ld (de),a
    pop af
    cp 00ah
    ccf
    dec hl
    dec de
    djnz .decimal_divide_finalize
    pop de
    pop hl
    ld (ix+000h),c
    pop bc
    inc ix
    inc de
    djnz .decimal_divide_accept_trial
    pop ix
    pop hl
    push hl
    call decimal_normalize
    pop bc
    pop de
    pop hl
    ret
    jr nc,.decimal_divide_return
    ret p
    jp arithmetic_overflow_error
.decimal_divide_return:
    ret m
    jp arithmetic_overflow_error
; Compare two normalized eleven-byte decimal records byte-for-byte.  Return Z
; only when sign, exponent and all digits are identical.
decimal_compare_equal:
    push hl
    push de
    push bc
    ld b,00bh
.decimal_compare_byte_loop:
    ld a,(de)
    cp (hl)
    jr nz,.decimal_compare_return
    inc hl
    inc de
    djnz .decimal_compare_byte_loop
.decimal_compare_return:
    pop bc
    pop de
    pop hl
    ret
; Attempt to encode an expanded decimal value as a signed 16-bit integer.
; Z indicates success and DE receives the integer; NZ means a float is needed.
decimal_try_to_integer:
    push hl
    push bc
    inc hl
    push hl
    ld a,(hl)
    sub 080h
    jr c,.decimal_integer_not_representable
    cp 008h
    jr nc,.decimal_integer_not_representable
    ld c,a
    ld b,000h
    adc hl,bc
    ld a,008h
    sub c
    ld b,a
    xor a
.decimal_integer_check_fraction_loop:
    inc hl
    cp (hl)
    jr nz,.decimal_integer_not_representable
    djnz .decimal_integer_check_fraction_loop
    pop de
    ld b,c
    ld hl,00000h
    inc b
    dec b
    jr z,.decimal_integer_apply_sign
    inc de
; Compute result = result*10 + digit with overflow checks after each operation.
.decimal_integer_accumulate_digit:
    inc de
    push bc
    adc hl,hl
    jp pe,.decimal_integer_not_representable
    ld b,h
    ld c,l
    adc hl,hl
    jp pe,.decimal_integer_not_representable
    adc hl,hl
    jp pe,.decimal_integer_not_representable
    adc hl,bc
    jp pe,.decimal_integer_not_representable
    ld a,(de)
    ld c,a
    ld b,000h
    adc hl,bc
    jp pe,.decimal_integer_not_representable
    pop bc
    djnz .decimal_integer_accumulate_digit
.decimal_integer_apply_sign:
    ex de,hl
    pop bc
    pop hl
    bit 3,(hl)
    jr z,.decimal_integer_success_return
    ld a,e
    cpl
    ld e,a
    ld a,d
    cpl
    ld d,a
    inc de
    cp a
.decimal_integer_success_return:
    ret
.decimal_integer_not_representable:
    inc sp
    inc sp
    pop bc
    pop hl
    or 001h
    ret
; Expand signed 16-bit HL into the common sign/exponent/eight-digit decimal
; work format at DE so integer and floating arithmetic share one engine.
integer_to_decimal:
    push hl
    push bc
    push de
    push ix
    ld a,000h
    bit 7,h
    jr z,.integer_decimal_store_sign
    ld a,h
    cpl
    ld h,a
    ld a,l
    cpl
    ld l,a
    inc hl
    ld a,008h
.integer_decimal_store_sign:
    ld (de),a
    inc de
    push de
    ld b,00ah
    xor a
.integer_decimal_clear_digits:
    ld (de),a
    inc de
    djnz .integer_decimal_clear_digits
    ld bc,00080h
    pop ix
    ld de,0000ah
; Repeatedly divide the magnitude by ten and stack remainders as digits.
.integer_decimal_extract_digit_loop:
    push hl
    or a
    sbc hl,de
    pop hl
    jr c,.integer_decimal_push_final_digit
    xor a
    push bc
    ld b,010h
.integer_decimal_divide_by_ten_loop:
    add hl,hl
    rla
    sub e
    jr c,.integer_decimal_restore_remainder
    inc hl
    jr .integer_decimal_continue_division
.integer_decimal_restore_remainder:
    add a,e
.integer_decimal_continue_division:
    djnz .integer_decimal_divide_by_ten_loop
    pop bc
    push af
    inc b
    inc c
    jr .integer_decimal_extract_digit_loop
.integer_decimal_push_final_digit:
    ld a,l
    push af
    inc b
    inc c
.integer_decimal_write_digits:
    pop af
    ld (ix+002h),a
    inc ix
    djnz .integer_decimal_write_digits
    pop ix
    pop de
    inc de
    ld a,c
    ld (de),a
    dec de
    pop bc
    pop hl
    ret
spectrum_io_dispatch:
    ; Central Spectrum/device I/O multiplexer.
    ;
    ; In:  C = DEVICE_OP_* selector.
    ;      E = character for console/printer output, or DE = operation-specific
    ;      identity/buffer address for cassette operations.
    ; Out: A and Z/NZ are operation-specific; DE, HL and IX are restored.
    ;
    ; Operations 0x14 and 0x15 transfer custom type-0xFB records of exactly
    ; 0x10A bytes.  The first 256 bytes are the physical data area and the last
    ; ten bytes are an eight-character file name plus two ASCII block digits.
    ; Operation 0x1A only records the transfer-area address used by the later
    ; block operation.  Operations 3 and 4 have no Spectrum implementation:
    ; they return A=0/Z, making RDR: an empty source and PUN: a discard sink.
    push de
    push hl
    push ix
    ld a,c
    cp DEVICE_OP_PRINTER_OUTPUT
    jr z,device_printer_output
    cp DEVICE_OP_CONSOLE_IO
    jr nz,device_dispatch_file_operation
    ld a,e
    cp 0ffh
    jr z,.device_console_input
; Translate Spectrum control/glyph codes before screen or printer output.
device_translate_output_character:
    cp 0ceh
    jr z,.device_handle_beep_control
    cp 0cfh
    jr nz,.device_output_printable_character
    ld e,000h
    jp device_console_output
.device_output_printable_character:
    cp 0a5h
    jp c,device_console_output
    ld e,03fh
    jp device_console_output
.device_handle_beep_control:
    ld d,000h
    ld e,(iy-002h)
    ld hl,000c8h
    call 003b5h
    jp device_return
; Poll BREAK first, then ask the Spectrum ROM channel for one character.
.device_console_input:
    call device_scan_break_keys
    jp nc,device_return
    res 3,(iy+002h)
    ld hl,(SYSVAR_CHANS)
    ld (SYSVAR_CURCHL),hl
    call ROM_INPUT_AD
    jr nc,.device_console_no_character
    res 0,(iy+007h)
    ld (CONSOLE_LAST_CHARACTER),a
    jp device_return
.device_console_no_character:
    xor a
    jp device_return
; Test the two-key BREAK chord and suppress repeated synthetic BREAK bytes.
device_scan_break_keys:
    ld a,07fh
    in a,(0feh)
    rra
    ret c
    ld a,07fh
    in a,(0feh)
    rra
    rra
    ret c
    ld hl,CONSOLE_LAST_CHARACTER
    ld a,(hl)
    ld (hl),018h
    sub (hl)
    scf
    ccf
    ret z
    ld a,(hl)
    ret
device_printer_output:
    set 1,(iy+001h)
    jr device_translate_output_character
device_dispatch_file_operation:
    ; File/cassette selectors share the same dispatcher.  Unknown selectors,
    ; including the reserved RDR:/PUN: operations 3 and 4, deliberately fall
    ; through to the common zero-success return.
    cp DEVICE_OP_SELECT_TRANSFER_BUFFER
    jr nz,.device_read_tape_block
    ld (TAPE_TRANSFER_BUFFER_PTR),de
    jp .device_return_success
.device_read_tape_block:
    cp DEVICE_OP_READ_TAPE_BLOCK
    jr nz,.device_write_tape_block
    push de
    pop ix
    call tape_increment_block_number
.tape_read_retry:
    ld ix,(TAPE_TRANSFER_BUFFER_PTR)
    push de
    ld de,FILE_CONTROL_TAPE_RECORD_SIZE
    ld a,FILE_TAPE_BLOCK_TYPE
    scf
    call tape_load_custom_record
    pop de
    jr nc,BLOCK_OK___string_end
    ld hl,(TAPE_TRANSFER_BUFFER_PTR)
    inc h
    call tape_validate_or_adopt_identity
    jr nz,READ_ERROR_string_end
    ld ix,BLOCK_OK___string_start
    call tape_print_block_identity
    call tape_erase_status_line
    jr .tape_read_complete

; BLOCK 'BLOCK_OK___string' (start 0x922a end 0x9234)
; Readable fixed-width status text: "BLOCK OK  " (two trailing spaces).
; The width is significant because the status-line update overwrites/erases a
; previous ten-character cassette message without clearing the whole line.
BLOCK_OK___string_start:
    defb 042h
    defb 04ch
    defb 04fh
    defb 043h
    defb 04bh
    defb 020h
    defb 04fh
    defb 04bh
    defb 020h
    defb 020h
BLOCK_OK___string_end:
    ld ix,READ_ERROR_string_start
    jr .tape_read_retry_after_error

; BLOCK 'READ_ERROR_string' (start 0x923a end 0x9244)
; Readable fixed-width status text: "READ ERROR" (ten characters).
READ_ERROR_string_start:
    defb 052h
    defb 045h
    defb 041h
    defb 044h
    defb 020h
    defb 045h
    defb 052h
    defb 052h
    defb 04fh
    defb 052h
READ_ERROR_string_end:
    push hl
    pop ix
; A failed cassette read reports identities and returns to the search/retry path.
.tape_read_retry_after_error:
    call tape_print_block_identity
    call tape_backspace_status_width
    jr .tape_read_retry
.tape_read_complete:
    jr .device_return_success
.device_write_tape_block:
    cp DEVICE_OP_WRITE_TAPE_BLOCK
    jr nz,.device_init_input_identity
    ld b,064h
.tape_write_settle_delay:
    halt
    djnz .tape_write_settle_delay
    ld ix,(TAPE_TRANSFER_BUFFER_PTR)
    defb 0ddh,024h,0cdh        ;illegal sequence
    dec e
    sub e
    call tape_backspace_status_width
    ld ix,(TAPE_TRANSFER_BUFFER_PTR)
    ld de,FILE_CONTROL_TAPE_RECORD_SIZE
    ld a,FILE_TAPE_BLOCK_TYPE
    scf
    call 004c2h
    jr .device_return_success
.device_init_input_identity:
    cp DEVICE_OP_INIT_INPUT_IDENTITY
    jr nz,.device_init_output_identity
    push de
    pop ix
    ld a,030h
    ld (ix+008h),a
    ld (ix+009h),a
    jr .device_return_success
.device_init_output_identity:
    cp DEVICE_OP_INIT_OUTPUT_IDENTITY
    jr nz,.device_return_success
    ex de,hl
    ld de,(TAPE_TRANSFER_BUFFER_PTR)
    inc d
    ld bc,FILE_CONTROL_NAME_SIZE
    ldir
    ld a,030h
    ld (de),a
    inc de
    ld (de),a
    jr .device_return_success
device_console_output:
    ld hl,(SYSVAR_CHANS)
    ld (SYSVAR_CURCHL),hl
    ld a,0ffh
    ld (SYSVAR_SCR_CT),a
    ld a,e
    call ROM_PRINT_A_2
    res 1,(iy+001h)
    bit 0,(iy+002h)
    jr z,.device_return_success
    ld hl,SYSVAR_DF_SZ
    ld a,(hl)
    cp 004h
    jr c,.device_return_success
    ld (hl),003h
    ld a,016h
    ld (SYSVAR_S_POSNL2),a
.device_return_success:
    xor a
device_return:
    pop ix
    pop hl
    pop de
    ret
tape_load_custom_record:
    ; Specialized cassette loader used for continuation records.  It performs
    ; leader/sync acquisition with the Spectrum ROM edge detectors, then enters
    ; the ROM byte loader at 0x059B with IX = selected transfer area, DE = 0x10A
    ; and A = 0xFB.  Carry propagates tape failure back to the retry UI.
    inc d
    ex af,af'
    dec d
    di
    ld a,00fh
    out (0feh),a
    ld hl,0053fh
    push hl
    in a,(0feh)
    rra
    and 020h
    or 002h
    ld c,a
    cp a
.tape_load_failure:
    ret nz
.tape_wait_for_leader:
    call ROM_LD_EDGE_1
    jr nc,.tape_load_failure
    ld hl,00180h
.tape_leader_delay:
    djnz .tape_leader_delay
    dec hl
    ld a,h
    or l
    jr nz,.tape_leader_delay
    call ROM_LD_EDGE_2
    jr nc,.tape_load_failure
.tape_measure_leader:
    ld b,09ch
    call ROM_LD_EDGE_2
    jr nc,.tape_load_failure
    ld a,0c6h
    cp b
    jr nc,.tape_wait_for_leader
    inc h
    jr nz,.tape_measure_leader
.tape_find_sync_pulse:
    ld b,0c9h
    call ROM_LD_EDGE_1
    jr nc,.tape_load_failure
    ld a,b
    cp 0d4h
    jr nc,.tape_find_sync_pulse
    jp 0059bh
device_print_status_character:
    push af
    push de
    ld c,006h
    ld e,a
    call spectrum_io_dispatch
    pop de
    pop af
    ret
tape_increment_block_number:
    ; IX addresses a ten-byte identity.  Bytes +8/+9 are an ASCII decimal
    ; counter, least-significant digit last, wrapping from 99 to 00.
    inc (ix+009h)
    ld a,039h
    cp (ix+009h)
    jr nc,.tape_refresh_status_identity
    ld (ix+009h),030h
    inc (ix+008h)
    cp (ix+008h)
    jr nc,.tape_refresh_status_identity
    ld (ix+008h),030h
.tape_refresh_status_identity:
    call tape_print_block_identity
    call tape_clear_status_tail
    ret
tape_print_block_identity:
    push ix
    ld b,00ah
.tape_print_block_identity_loop:
    ld a,(ix+000h)
    call device_print_status_character
    inc ix
    djnz .tape_print_block_identity_loop
    ld a,020h
    ld b,004h
; Separate expected and encountered block identities with four spaces.
.tape_print_identity_spacing_loop:
    call device_print_status_character
    djnz .tape_print_identity_spacing_loop
    pop ix
    ret
tape_clear_status_tail:
    ld b,00eh
    ld a,020h
.tape_clear_status_spaces:
    call device_print_status_character
    djnz .tape_clear_status_spaces
    call tape_backspace_status_width
    ret
tape_erase_status_line:
    call tape_backspace_status_width
tape_backspace_status_width:
    ld b,00eh
    ld a,008h
.tape_backspace_status_loop:
    call device_print_status_character
    djnz .tape_backspace_status_loop
    ret
tape_validate_or_adopt_identity:
    ; In: DE = expected identity, HL = footer loaded from tape.
    ; A leading space in the expected name acts as a wildcard: adopt the eight
    ; name bytes from the record but retain the locally managed block digits.
    ; Otherwise all ten bytes must match exactly.
    push de
    push hl
    ld a,(de)
    cp 020h
    jr z,.tape_adopt_wildcard_name
    ld b,00ah
.tape_compare_identity_loop:
    ld a,(de)
    cp (hl)
    jr nz,.tape_identity_return
    inc hl
    inc de
    djnz .tape_compare_identity_loop
.tape_identity_matches:
    cp a
.tape_identity_return:
    pop hl
    pop de
    ret
.tape_adopt_wildcard_name:
    ld bc,00008h
    ldir
    jr .tape_identity_matches
file_allocate_control_block:
    ; Allocate the sole 0x134-byte cassette control record.
    ;
    ; In:  HL = canonical dictionary value cell; its stored name begins at HL+3.
    ; Out: that value cell becomes SYSTEM_OBJECT_TAG -> FILE_CONTROL_TABLE.
    ;      The padded eight-byte name is copied to state-0x24, the expected
    ;      identity area used by all later block reads/writes.
    ;
    ; Only one slot exists in the Spectrum build, matching the manual's rule
    ; that only one ordinary file may be open.  An occupied slot raises the
    ; internal "too many files" path.  Allocation alone does not change state;
    ; OPEN or CREATE performs the state transition.
    push af
    push bc
    push hl
    push hl
    ld hl,FILE_CONTROL_TABLE
    ld de,FILE_CONTROL_BLOCK_STRIDE
    ld b,FILE_CONTROL_BLOCK_COUNT
.file_find_free_control_block:
    ld a,(hl)
    or a
    jr z,.file_control_block_found
    add hl,de
    djnz .file_find_free_control_block
    ld hl,00006h
    jp signal_interpreter_error
.file_control_block_found:
    ex de,hl
    pop hl
    push de
    ld (hl),006h
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    push hl
    ld hl,FILE_CONTROL_EXPECTED_IDENTITY
    add hl,de
    ex de,hl
    pop hl
    call file_copy_name_to_control_block
    pop de
    pop hl
    pop bc
    pop af
    ret
file_copy_name_to_control_block:
    ; In: HL = FF-terminated dictionary spelling, DE = eight-byte identity name.
    ; Copy exactly eight characters.  Once the terminator is encountered, hold
    ; HL on it and fill the remaining identity positions with spaces.
    push de
    push hl
    ld b,FILE_CONTROL_NAME_SIZE
.file_copy_name_character:
    ld a,(hl)
    cp 0ffh
    jr nz,.file_store_name_character
    dec hl
    ld a,020h
.file_store_name_character:
    ld (de),a
    inc de
    inc hl
    djnz .file_copy_name_character
    pop hl
    pop de
    ret
file_open_new_input_object:
    ; Allocate a control block for a previously unopened constant, then fall
    ; through to file_open_input_control_block.
    call file_allocate_control_block
file_open_input_control_block:
    ; In: DE = control-state address, HL = canonical file value cell.
    ; Initialize expected sequence digits to 00, run GC before the tape wait, set
    ; state READING and cursor 0xFF, then invoke the ordinary buffered reader.
    ; A successful probe consumes byte zero, so the cursor is decremented back
    ; to zero: the first public READ sees the complete first term.  EOF/failure
    ; leaves NZ and does not perform that rewind.
    push hl
    push de
    push bc
    ld hl,FILE_CONTROL_EXPECTED_IDENTITY
    add hl,de
    ex de,hl
    ld c,DEVICE_OP_INIT_INPUT_IDENTITY
    call spectrum_io_dispatch
    pop bc
    pop de
    call garbage_collect
    push ix
    push de
    pop ix
    ld (ix+FILE_CONTROL_CURSOR),FILE_CURSOR_REFILL_REQUIRED
    ld (ix+FILE_CONTROL_STATE),FILE_STATE_READING
    ld (ix+FILE_CONTROL_UNUSED_FLAG),000h
    pop ix
    ex de,hl
    call file_input_next_byte
    pop hl
    ret nz
    inc de
    inc de
    ex de,hl
    dec (hl)
    cp a
    ret
file_create_new_output_object:
    ; Allocate a new file object, then initialize it for output.
    call file_allocate_control_block
file_initialize_output_control_block:
    ; In: DE = control-state address whose expected name was populated by the
    ; allocator.  Select state+3 as the physical transfer area, build the footer
    ; at state+0x103 from the padded name plus sequence 00, clear the cursor and
    ; publish WRITING state.  The physical data byte at index 255 is never used:
    ; cursor 0xFF is reserved for input refill.
    push af
    push hl
    push ix
    push de
    pop ix
    push de
    inc de
    inc de
    inc de
    ld c,DEVICE_OP_SELECT_TRANSFER_BUFFER
    call spectrum_io_dispatch
    ld hl,FILE_CONTROL_EXPECTED_IDENTITY-FILE_CONTROL_DATA
    add hl,de
    ex de,hl
    ld c,DEVICE_OP_INIT_OUTPUT_IDENTITY
    call spectrum_io_dispatch
    pop de
    ld (ix+FILE_CONTROL_UNUSED_FLAG),000h
    ld (ix+FILE_CONTROL_CURSOR),000h
    ld (ix+FILE_CONTROL_STATE),FILE_STATE_WRITING
    pop ix
    pop hl
    pop af
    ret
file_release_control_block:
    ; Detach an opened file object from its dictionary constant.  The constant
    ; is restored to an unresolved system object while the control block state
    ; becomes FREE.  A writing file is flushed before detachment by the caller.
    push hl
    push de
    push bc
    push af
    push ix
    ld a,(hl)
    cp 006h
    jp nz,signal_file_error
    push hl
    call term_load_payload_hl
    push hl
    pop ix
    ld a,(hl)
    ld (hl),000h
    cp FILE_STATE_WRITING
    pop hl
    ld (hl),010h
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    pop ix
    pop af
    pop bc
    pop de
    pop hl
    ret
file_finish_output:
    ; Append the 0x1A end-of-file byte, flush a partial final block if needed,
    ; then release the file-control block.
    push hl
    call term_load_payload_hl
    ld a,FILE_BUFFER_EOF
    call file_output_byte
    push ix
    push hl
    pop ix
    ld a,(ix+FILE_CONTROL_CURSOR)
    or a
    pop ix
    call nz,file_flush_output_block
    pop hl
    jp file_release_control_block
