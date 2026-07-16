; -----------------------------------------------------------------------------
; Architectural module: 09_graphics_and_machine_io.asm
; Graphics, display, sound, random-number, keyboard, and port-I/O primitives.
; Original monolithic line range: 6627-7304.
; Emitted address range: 0x7FF5-0x83AB.
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Graphics, display, sound, random-number and port-I/O primitives
; -----------------------------------------------------------------------------
; The following ordinary dictionary entries are followed by genuine handlers.
; Their compact argument tables are data: each five-byte state describes the
; accepted type of the next argument and the relative transition to the next
; state or completion routine.

; ============================================================================
; CHAPTER 9 — PRIMITIVES WHICH TOUCH THE SPECTRUM ITSELF
; ============================================================================
;
; Graphics, sound, keyboard and port I/O are the point where the otherwise
; machine-independent term engine meets ZX Spectrum conventions.  Dispatch
; tables still validate and collect arguments, but completion routines convert
; micro-PROLOG integers into ROM coordinates, attribute bytes, port numbers or
; timing values.
;
; The important distinction is between logical relation modes and physical
; side effects.  PNT may draw or inspect depending on which arguments are
; unbound; RND may set a seed or return a bounded value; PIO may read or write.
;
lne_constant_entry:
    defb TERM_TAG_CONSTANT
    defw lne_value_cell
    defb TERM_TAG_LIST
    defw pnt_constant_entry
lne_value_cell:
    defb TERM_TAG_INTEGER
    defw lne_primitive
; Complete readable dictionary name: "LNE".  The bytes are split across two labels
; only because a legacy internal target lands on the suffix.
lne_name:
    defb 04ch                  ; "L"
lne_name_suffix:
    defb 04eh,045h,SYSTEM_NAME_TERMINATOR ; "NE"; legacy target retained

; LNE x1 y1 x2 y2 [attribute1 [attribute2]]
; All four coordinates are numeric.  The optional attribute bytes are numeric
; too; the handler translates micro-PROLOG's signed, centred coordinates to the
; Spectrum ROM coordinate system and calls the ROM line drawer.
; Coordinate conversion example
; ---------------------------
; micro-PROLOG accepts signed coordinates around a logical origin, while the ROM
; drawing routine wants Spectrum screen coordinates and a delta from the current
; point.  For example, drawing from (-10, 5) to (20, -3) conceptually performs:
;
;       start_screen = convert_signed_point(-10, 5)
;       end_screen   = convert_signed_point(20, -3)
;       delta        = end_screen - start_screen = (30, -8)
;       ROM plot(start_screen)
;       ROM draw(delta)
;
; The exact vertical inversion and bounds checks below adapt logical coordinates
; to the Spectrum's bottom-left plotting convention.
lne_primitive:
    call 01cadh                ; Initialise the ROM graphics/attribute state.
    ld ix,lne_expect_x1_state
    jp primitive_argument_dispatch
lne_expect_x1_state:
    defb DISPATCH_REJECT
    defb lne_expect_y1_state-lne_expect_x1_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
lne_expect_y1_state:
    defb DISPATCH_REJECT
    defb lne_expect_x2_state-lne_expect_y1_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
lne_expect_x2_state:
    defb DISPATCH_REJECT
    defb lne_expect_y2_state-lne_expect_x2_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
lne_expect_y2_state:
    defb DISPATCH_REJECT
    defb lne_after_coordinates_state-lne_expect_y2_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
lne_after_coordinates_state:
    defb lne_draw_default_attributes-lne_after_coordinates_state
    defb lne_after_attribute1_state-lne_after_coordinates_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
lne_after_attribute1_state:
    defb lne_draw_one_attribute-lne_after_attribute1_state
    defb lne_after_attribute2_state-lne_after_attribute1_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
lne_after_attribute2_state:
    defb lne_draw_two_attributes-lne_after_attribute2_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT

; ----------------------------------------------------------------------------
; LNE CONVERTS ENDPOINTS TO THE ROM'S DELTA FORM
; ----------------------------------------------------------------------------
;
; The public relation accepts two points and optional attributes.  Spectrum ROM
; drawing expects a start point followed by signed deltas, so the completion
; routine validates coordinates, selects temporary ink/paper state, plots the
; first point and subtracts endpoints before calling the line service.
;
; Attribute changes are temporary unless the relation mode explicitly requests
; a persistent display setting.
;
lne_draw_two_attributes:
    ld a,(PRIMITIVE_ARG6_VALUE) ; Optional mask/OVER-style attribute byte.
    cp 0ffh                    ; FF means that the optional slot was absent.
    call 00d5eh                ; Apply the secondary temporary attribute flags.
lne_draw_one_attribute:
    ld a,(PRIMITIVE_ARG5_VALUE) ; Main Spectrum attribute byte.
    ld (SYSVAR_ATTR_T),a
lne_draw_default_attributes:
    call graphics_normalize_four_coordinates

    ; Translate the first endpoint from signed coordinates to ROM coordinates.
    ld hl,(PRIMITIVE_ARG1_VALUE)
    ld de,00080h               ; x range -128..127 becomes 0..255.
    call graphics_translate_coordinate
    ld c,l
    ld hl,(PRIMITIVE_ARG2_VALUE)
    ld de,00058h               ; y range -88..87 becomes 0..175.
    call graphics_translate_coordinate
    ld b,l
    ld (SYSVAR_COORDS),bc      ; Tell the ROM where the line begins.

    ; Convert the second endpoint into absolute deltas plus direction signs,
    ; which is the parameter form expected by the ROM line-drawing routine.
    push bc
    ld hl,(PRIMITIVE_ARG3_VALUE)
    ld de,00080h
    ld b,c
    call graphics_compute_signed_delta
    pop bc
    ld c,a                     ; |dx|
    push bc
    ld c,d                     ; x direction: +1 or -1
    ld hl,(PRIMITIVE_ARG4_VALUE)
    ld de,00058h
    call graphics_compute_signed_delta
    ld e,c                     ; x direction
    pop bc
    ld b,a                     ; |dy|; D contains y direction
    call 024bah                ; Spectrum ROM line drawer.
    call graphics_restore_permanent_attributes
    cp a                       ; Return Z set: primitive succeeded.
    ret

; Translate a target coordinate and compare it with the already translated
; starting coordinate in B.  Return the magnitude in A and direction in D.
graphics_compute_signed_delta:
    call graphics_translate_coordinate
    ld a,l
    sub b
    ld d,001h
    ret nc
    neg
    ld d,0ffh
    ret

; Add the coordinate bias in DE.  A non-zero high byte means that the signed
; input lay outside the documented screen range, so signal error 10.
; Coordinate examples
; -------------------
; A valid negative logical coordinate is translated around the Spectrum origin;
; for example logical x=-10 becomes the corresponding screen x after the routine's
; centering/sign conversion, not an unsigned wraparound.
;
; A value beyond the accepted logical range fails the bounds test and raises the
; inline ROM error token for "Point off screen" before any pixel is changed.
graphics_translate_coordinate:
    xor a
    add hl,de
    ld a,h
    and a
    ret z
    rst 8
    defb 00ah                  ; Spectrum error token: Point off screen.

; Convert/validate the four coordinate arguments collected by the dispatcher.
graphics_normalize_four_coordinates:
    ld ix,PRIMITIVE_ARG3_SLOT
    call numeric_truncate_dispatch_argument
    ld ix,PRIMITIVE_ARG4_SLOT
    call numeric_truncate_dispatch_argument
; Convert/validate the first two numeric arguments.  PNT and BP enter here.
graphics_normalize_first_two_arguments:
    ld ix,PRIMITIVE_ARG1_SLOT
    call numeric_truncate_dispatch_argument
    ld ix,PRIMITIVE_ARG2_SLOT
    call numeric_truncate_dispatch_argument
    ret

; Graphics operations temporarily replace ATTR_T and related P-FLAG bits.
; Restore their permanent counterparts before returning to the interpreter.
graphics_restore_permanent_attributes:
    ld hl,(SYSVAR_ATTR_P)
    ld (SYSVAR_ATTR_T),hl
    ld hl,SYSVAR_P_FLAG
    call 00d63h
    ret

pnt_constant_entry:
    defb TERM_TAG_CONSTANT
    defw pnt_value_cell
    defb TERM_TAG_LIST
    defw rnd_constant_entry
pnt_value_cell:
    defb TERM_TAG_INTEGER
    defw pnt_primitive
pnt_name:
    defb 050h,04eh,054h,SYSTEM_NAME_TERMINATOR ; "PNT"

; PNT x y [attribute1 [attribute2]] plots a point.  With one or two unbound
; optional arguments, the same primitive reads the current pixel bit and,
; when requested, the containing Spectrum attribute byte.
; ----------------------------------------------------------------------------
; PNT IS BOTH COMMAND AND QUERY
; ----------------------------------------------------------------------------
;
; With bound colour/attribute arguments it plots.  With unbound output slots it
; reads the bitmap bit and, in the four-argument form proved from the dispatcher,
; the containing character cell's attribute byte.
;
; The shared coordinate preparation routine enforces Spectrum screen bounds and
; translates micro-PROLOG's signed integers into the ROM/bitmap conventions.
;
pnt_primitive:
    call 01cadh                ; Initialise the ROM graphics/attribute state.
    ld ix,pnt_expect_x_state
    jp primitive_argument_dispatch
pnt_expect_x_state:
    defb DISPATCH_REJECT
    defb pnt_expect_y_state-pnt_expect_x_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
pnt_expect_y_state:
    defb DISPATCH_REJECT
    defb pnt_after_coordinates_state-pnt_expect_y_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
pnt_after_coordinates_state:
    defb pnt_plot_default_attributes-pnt_after_coordinates_state
    defb pnt_after_attribute1_state-pnt_after_coordinates_state
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb pnt_after_output1_state-pnt_after_coordinates_state
pnt_after_attribute1_state:
    defb pnt_plot_one_attribute-pnt_after_attribute1_state
    defb pnt_after_attribute2_state-pnt_after_attribute1_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
    defb DISPATCH_REJECT        ; Alignment byte not addressed as a state.
pnt_after_attribute2_state:
    defb pnt_plot_two_attributes-pnt_after_attribute2_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
pnt_after_output1_state:
    defb pnt_read_pixel-pnt_after_output1_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
    defb pnt_after_output2_state-pnt_after_output1_state
pnt_after_output2_state:
    defb pnt_read_pixel_and_attribute-pnt_after_output2_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT

pnt_plot_two_attributes:
    ld a,(PRIMITIVE_ARG4_VALUE)
    cp 0ffh
    call 00d5eh                ; Apply secondary temporary attribute flags.
pnt_plot_one_attribute:
    ld a,(PRIMITIVE_ARG3_VALUE)
    ld (SYSVAR_ATTR_T),a
pnt_plot_default_attributes:
    call pnt_prepare_coordinates
    call 022e5h                ; Spectrum ROM PLOT.
    jp pnt_finish

; Return both pieces of display state: the pixel bit in argument 3 and the
; character-cell attribute byte in argument 4.
; Undocumented machine-code mode
; ------------------------------
; `PNT x y Pixel Attribute` can bind two outputs: Pixel receives 0 or 1 from the
; bitmap, Attribute receives the containing character cell's Spectrum attribute
; byte.  This form is proved by the dispatcher and handler writes but is not
; explicitly documented in the supplied manual; keep that evidence status in mind.
pnt_read_pixel_and_attribute:
    call pnt_prepare_coordinates
    ld a,c
    and 0f8h
    rrca
    rrca
    ld c,a
    ld a,b
    rlca
    rlca
    ld b,a
    and 0e0h
    xor c
    ld l,a
    ld a,b
    and 003h
    xor 058h                   ; Form the address in the 0x5800 attribute map.
    ld h,a
    ld a,(hl)
    ld b,000h
    ld c,a
    ld (PRIMITIVE_ARG4_RESULT_VALUE),bc
    ld a,TERM_TAG_INTEGER
    ld (PRIMITIVE_ARG4_RESULT_TAG),a

pnt_read_pixel:
    call pnt_prepare_coordinates
    call 022aah                ; Spectrum ROM POINT; result is encoded in A/B.
    ld b,a
    inc b
    ld a,(hl)
.pnt_extract_pixel_loop:
    rlca
    djnz .pnt_extract_pixel_loop
    and 001h
    ld c,a
    ld (PRIMITIVE_ARG3_RESULT_VALUE),bc
    ld a,TERM_TAG_INTEGER
    ld (PRIMITIVE_ARG3_RESULT_TAG),a
pnt_finish:
    call graphics_restore_permanent_attributes
    cp a
    ret

; Normalise x/y, translate the centred ranges, and return x in C and y in B.
pnt_prepare_coordinates:
    call graphics_normalize_first_two_arguments
    ld hl,(PRIMITIVE_ARG1_VALUE)
    ld de,00080h
    call graphics_translate_coordinate
    ld c,l
    ld hl,(PRIMITIVE_ARG2_VALUE)
    ld de,00058h
    call graphics_translate_coordinate
    ld b,l
    ret

rnd_constant_entry:
    defb TERM_TAG_CONSTANT
    defw rnd_value_cell
    defb TERM_TAG_LIST
    defw bp_constant_entry
rnd_value_cell:
    defb TERM_TAG_INTEGER
    defw rnd_primitive
rnd_name:
    defb 052h,04eh,044h,SYSTEM_NAME_TERMINATOR ; "RND"

; RND, RND n, and RND x n respectively seed from FRAMES, set an explicit seed,
; or bind x to a pseudo-random integer in the range 0 <= x < n.
rnd_primitive:
    ld ix,rnd_initial_state
    jp primitive_argument_dispatch
rnd_initial_state:
    defb rnd_seed_from_frames-rnd_initial_state
    defb rnd_one_numeric_state-rnd_initial_state
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb rnd_expect_bound_state-rnd_initial_state
rnd_expect_bound_state:
    defb DISPATCH_REJECT
    defb rnd_random_result_state-rnd_expect_bound_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
rnd_random_result_state:
    defb rnd_return_bounded_value-rnd_random_result_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
rnd_one_numeric_state:
    defb rnd_seed_from_argument-rnd_one_numeric_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT

rnd_seed_from_frames:
    ld hl,(SYSVAR_FRAMES)
    jr rnd_store_seed
rnd_seed_from_argument:
    ld a,(PRIMITIVE_ARG1_TAG)
    cp TERM_TAG_INTEGER
    ret nz
    ld hl,(PRIMITIVE_ARG1_VALUE)
rnd_store_seed:
    ld (SYSVAR_SEED),hl
    cp a
    ret
rnd_return_bounded_value:
    ld a,(PRIMITIVE_ARG2_TAG)
    cp TERM_TAG_INTEGER
    ret nz
    ld hl,(PRIMITIVE_ARG2_VALUE) ; Exclusive upper bound n.
    call random_update_and_scale
    ld a,TERM_TAG_INTEGER
    ld (PRIMITIVE_ARG1_RESULT_VALUE),bc
    ld (PRIMITIVE_ARG1_RESULT_TAG),a
    cp a
    ret

; Advance the 16-bit generator and scale its new state by the requested bound.
; The high word of seed*n gives a uniformly scaled integer below n in BC.
; ----------------------------------------------------------------------------
; A SMALL MULTIPLICATIVE GENERATOR
; ----------------------------------------------------------------------------
;
; The seed is multiplied by 77 and the high/low product words are folded to form
; the next 16-bit state.  To obtain a result below N, the new seed is multiplied
; by N and the high word of that product is used as the scaled value.
;
; Taking the high word implements floor(seed*N/65536) without division and gives
; every bound the same simple path.
;
; Why the high product word gives a bounded result
; ------------------------------------------------
; Treat the 16-bit seed as an unsigned fraction seed/65536.  Multiplying by a
; bound N yields a 32-bit product; the high word is floor(seed*N/65536), hence:
;
;       0 <= high_word < N
;
; Tiny example with an eight-bit analogy: seed=192, bound=10 gives
; 192*10=1920; high byte floor(1920/256)=7, safely in 0..9.  The real routine
; uses the same idea at 16-bit precision after updating the seed.
random_update_and_scale:
    push hl                    ; Preserve n.
    ld hl,(SYSVAR_SEED)
    ld de,0004dh               ; Multiplicative step, decimal 77.
    ld a,h
    or l
    jr z,.random_zero_seed
    call multiply_u16_hl_de
    and a
    sbc hl,bc                  ; Fold the 32-bit product back to 16 bits.
    jr nc,.random_store_updated_seed
    inc hl
    jr .random_store_updated_seed
.random_zero_seed:
    sbc hl,de                  ; Avoid the absorbing all-zero state.
.random_store_updated_seed:
    ld (SYSVAR_SEED),hl
    pop de                     ; DE = requested bound n.
    call multiply_u16_hl_de
    ld h,b
    ld l,c
    inc hl                     ; Preserve the original routine's flag result.
    ret

; Unsigned 16x16 shift/add multiply.  Input HL*DE; output high word in BC and
; low word in HL.
multiply_u16_hl_de:
    ld b,h
    ld c,l
    ld a,010h
    ld hl,00000h
.multiply_u16_loop:
    add hl,hl
    rl c
    rl b
    jr nc,.multiply_u16_no_add
    add hl,de
    jr nc,.multiply_u16_no_add
    inc bc
.multiply_u16_no_add:
    dec a
    jr nz,.multiply_u16_loop
    ret

bp_constant_entry:
    defb TERM_TAG_CONSTANT
    defw bp_value_cell
    defb TERM_TAG_LIST
    defw cls_constant_entry
bp_value_cell:
    defb TERM_TAG_INTEGER
    defw bp_primitive
bp_name:
    defb 042h,050h,SYSTEM_NAME_TERMINATOR ; "BP"

; BP duration cycles.  Both arguments are normalised to integers, zero values
; suppress the sound, and the Spectrum ROM beeper performs the blocking tone.
bp_primitive:
    ld ix,bp_expect_duration_state
    jp primitive_argument_dispatch
bp_expect_duration_state:
    defb DISPATCH_REJECT
    defb bp_expect_cycles_state-bp_expect_duration_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
bp_expect_cycles_state:
    defb DISPATCH_REJECT
    defb bp_completion_state-bp_expect_cycles_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
bp_completion_state:
    defb bp_sound_note-bp_completion_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
; ----------------------------------------------------------------------------
; BP TRANSLATES LOGICAL NUMBERS INTO BEEPER TIMING
; ----------------------------------------------------------------------------
;
; The Spectrum ROM beeper wants a period and a repeat count, not musical pitch
; names.  BP validates the two integer arguments, derives the timing registers,
; and invokes the ROM while preserving the interpreter's system-variable state.
;
; Spectrum beeper model
; ----------------------
; The ROM beeper is a timing loop that toggles the one-bit speaker output.  It
; accepts a pitch-period value and a duration count rather than a musical note.
; This routine converts micro-PROLOG numeric arguments to those ROM units.  The
; arithmetic below is therefore hardware timing conversion; its audible result
; depends on the 3.5 MHz Spectrum clock and ROM implementation.
bp_sound_note:
    call graphics_normalize_first_two_arguments
    ld hl,(PRIMITIVE_ARG2_VALUE) ; Cycles/frequency parameter.
    ld a,h
    or l
    jr z,.bp_finish
    ld de,(PRIMITIVE_ARG1_VALUE) ; Duration parameter.
    ld a,d
    or e
    jr z,.bp_finish
    call 003b5h                ; Spectrum ROM BEEPER.
.bp_finish:
    cp a
    ret

cls_constant_entry:
    defb TERM_TAG_CONSTANT
    defw cls_value_cell
    defb TERM_TAG_LIST
    defw pio_constant_entry
cls_value_cell:
    defb TERM_TAG_INTEGER
    defw cls_primitive
cls_name:
    defb 043h,04ch,053h,SYSTEM_NAME_TERMINATOR ; "CLS"

; CLS optionally accepts a paper-colour number.  With no argument it preserves
; the current temporary colour.  It clears the display without losing the
; interpreter's NORMAL/HYBRID mode bit.
cls_primitive:
    ld ix,cls_initial_state
    jp primitive_argument_dispatch
cls_initial_state:
    defb cls_preserve_colour-cls_initial_state
    defb cls_colour_state-cls_initial_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
cls_colour_state:
    defb cls_set_colour-cls_colour_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
cls_preserve_colour:
    ld a,(SYSVAR_ATTR_T)
    jr cls_clear_screen
cls_set_colour:
    ld a,(PRIMITIVE_ARG1_TAG)
    cp TERM_TAG_INTEGER
    ret nz
    ld a,(PRIMITIVE_ARG1_VALUE)
    sla a
    sla a
    sla a                      ; Paper colour occupies ATTR bits 3..5.
cls_clear_screen:
    ld (SYSVAR_ATTR_P),a
    push af
    ld a,(iy+002h)
    push af                    ; ROM CLS changes this mode flag; preserve it.
    call 00dafh                ; Spectrum ROM clear-all routine.
    pop af
    ld (iy+002h),a
    pop af
    ld (SYSVAR_ATTR_T),a
    cp a
    ret

pio_constant_entry:
    defb TERM_TAG_CONSTANT
    defw pio_value_cell
    defb TERM_TAG_LIST
    defw external_a8_constant_entry
pio_value_cell:
    defb TERM_TAG_INTEGER
    defw pio_primitive
pio_name:
    defb 050h,049h,04fh,SYSTEM_NAME_TERMINATOR ; "PIO"

; PIO port value writes an integer byte to the Z80 I/O port.  PIO port x, where
; x is unbound, reads the port and returns the byte as an integer.
; ----------------------------------------------------------------------------
; PIO'S MODE IS DETERMINED BY BINDING
; ----------------------------------------------------------------------------
;
; A bound second argument means output: write the byte to the requested 16-bit
; port.  An unbound second argument means input: read the port and bind the
; result.  The relation's dispatch state excludes malformed numeric modes before
; an IN or OUT instruction can occur.
;
; WARNING: direct machine I/O
; ---------------------------
; PIO can read or write arbitrary Z80 port addresses.  On real hardware a write
; may change border/speaker state, paging or peripheral control, and on clones or
; attached hardware it may have other side effects.  This primitive intentionally
; performs no safety filtering; use it only with a known Spectrum port map.
pio_primitive:
    ld ix,pio_expect_port_state
    jp primitive_argument_dispatch
pio_expect_port_state:
    defb DISPATCH_REJECT
    defb pio_expect_value_state-pio_expect_port_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
pio_expect_value_state:
    defb DISPATCH_REJECT
    defb pio_write_state-pio_expect_value_state
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb pio_read_state-pio_expect_value_state
pio_write_state:
    defb pio_write_port-pio_write_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
pio_read_state:
    defb pio_read_port-pio_read_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
pio_write_port:
    call pio_load_integer_port
    ret nz
    ld a,(PRIMITIVE_ARG2_TAG)
    cp TERM_TAG_INTEGER
    ret nz
    ld a,(PRIMITIVE_ARG2_VALUE)
    out (c),a
    cp a
    ret
pio_read_port:
    call pio_load_integer_port
    ret nz
    in a,(c)
    ld c,a
    ld b,000h
    ld (PRIMITIVE_ARG2_RESULT_VALUE),bc
    ld a,TERM_TAG_INTEGER
    ld (PRIMITIVE_ARG2_RESULT_TAG),a
    cp a
    ret
pio_load_integer_port:
    ld a,(PRIMITIVE_ARG1_TAG)
    cp TERM_TAG_INTEGER
    ld bc,(PRIMITIVE_ARG1_VALUE)
    ret

; Structurally this is a dictionary entry in the chain between PIO and BORDER,
; but its one-byte name 0xA8 is encoded and its value 0xFC88 lies outside the
; interpreter image.  Preserve the evidence without inventing a public name.
external_a8_constant_entry:
    defb TERM_TAG_CONSTANT
    defw external_a8_value_cell
    defb TERM_TAG_LIST
    defw border_constant_entry
external_a8_value_cell:
    defb TERM_TAG_INTEGER
    defw 0fc88h
; This one-byte high-bit name 0xA8 belongs to an isolated external/extension
; descriptor whose handler address is outside the interpreter image.  Its
; spelling and purpose remain unresolved; it is intentionally not treated as
; decoded text.
external_a8_name:
    defb 0a8h,SYSTEM_NAME_TERMINATOR

border_constant_entry:
    defb TERM_TAG_CONSTANT
    defw border_value_cell
    defb TERM_TAG_LIST
    defw hybrid_constant_entry
border_value_cell:
    defb TERM_TAG_INTEGER
    defw border_primitive
border_name:
    defb 042h,04fh,052h,044h,045h,052h,SYSTEM_NAME_TERMINATOR ; "BORDER"

; BORDER colour masks the supplied integer to the Spectrum's three border bits,
; updates both hardware and the ROM system variable, and refreshes the lower
; display when the ROM is not already in the relevant mode.
border_primitive:
    ld ix,border_expect_colour_state
    jp primitive_argument_dispatch
border_expect_colour_state:
    defb DISPATCH_REJECT
    defb border_completion_state-border_expect_colour_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
border_completion_state:
    defb border_set_colour-border_completion_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
border_set_colour:
    ld a,(PRIMITIVE_ARG1_TAG)
    cp TERM_TAG_INTEGER
    ret nz
    ld a,(PRIMITIVE_ARG1_VALUE)
    and 007h
    out (0feh),a
    rlca
    rlca
    rlca
    ld (SYSVAR_BORDCR),a
    bit 1,(iy+002h)
    jr nz,.border_finish
    ld a,(SYSVAR_DF_SZ)
    dec a
    ld b,a
    call 00e44h
.border_finish:
    cp a
    ret

hybrid_constant_entry:
    defb TERM_TAG_CONSTANT
    defw hybrid_value_cell
    defb TERM_TAG_LIST
    defw normal_constant_entry
hybrid_value_cell:
    defb TERM_TAG_INTEGER
    defw hybrid_primitive
hybrid_name:
    defb 048h,059h,042h,052h,049h,044h,SYSTEM_NAME_TERMINATOR ; "HYBRID"

; Clear the screen and reserve only the lower four text lines, leaving the main
; display available to graphics.  The argument is deliberately ignored.
hybrid_primitive:
    call 00dafh
    ld a,003h
    ld (DISPLAY_LAST_TEXT_ROW),a              ; Interpreter's last usable lower-screen row.
    set 0,(iy+002h)            ; Remember HYBRID mode independently of ROM CLS.
    ret

normal_constant_entry:
    defb TERM_TAG_CONSTANT
    defw normal_value_cell
    defb TERM_TAG_LIST
    defw inkey_constant_entry
normal_value_cell:
    defb TERM_TAG_INTEGER
    defw normal_primitive
normal_name:
    defb 04eh,04fh,052h,04dh,041h,04ch,SYSTEM_NAME_TERMINATOR ; "NORMAL"

; Restore full-screen text mode and the ROM's normal two-line lower display.
; Like HYBRID, a supervisor-command argument is ignored by the primitive.
normal_primitive:
    res 0,(iy+002h)
    call 00dafh
    ld a,002h
    ld (DISPLAY_LAST_TEXT_ROW),a
    ld (SYSVAR_DF_SZ),a
    cp a
    ret

inkey_constant_entry:
    defb TERM_TAG_CONSTANT
    defw inkey_value_cell
    defb TERM_TAG_LIST
    defw sum_constant_entry
inkey_value_cell:
    defb TERM_TAG_INTEGER
    defw inkey_primitive
inkey_name:
    defb 049h,04eh,04bh,045h,059h,SYSTEM_NAME_TERMINATOR ; "INKEY"

; Internal single-key primitive.  It accepts one unbound output, scans and
; decodes the Spectrum keyboard, resets transient keyboard mode state, then
; reuses CHAROF's one-character-constant constructor.
inkey_primitive:
    ld ix,inkey_expect_output_state
    jp primitive_argument_dispatch
inkey_expect_output_state:
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
    defb inkey_completion_state-inkey_expect_output_state
inkey_completion_state:
    defb inkey_read_key-inkey_completion_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
inkey_read_key:
    call 0028eh                ; ROM keyboard matrix scan.
    ld c,000h
    jr nz,.inkey_no_key
    ld a,e
    inc a
    jr nz,.inkey_decode
.inkey_no_key:
    ld a,0feh                  ; Internal no-key/special sentinel.
    jr .inkey_finish_decode
.inkey_decode:
    call 0031eh                ; Test modifiers and derive a key class.
    jr c,.inkey_extended_decode
    cp 027h
    jr nz,.inkey_finish_decode
    ld a,019h                  ; Normalise the ROM's special quote-key code.
    jr .inkey_finish_decode
.inkey_extended_decode:
    dec d
    ld e,a
    call 00333h                ; ROM key-code decoder.
.inkey_finish_decode:
    ld l,a
    xor a
    ld (SYSVAR_MODE),a         ; Return the keyboard to neutral cursor mode.
    res 3,(iy+030h)
    jp charof_intern_character_constant                  ; Construct and bind a one-character constant.

; Twelve-byte cold-start image copied to MODULE_CURRENT_CELL.  The root
; module object is named "&"; its descriptor starts with an empty export list
; and links to the mutable root import/local pair in workspace RAM.
; ----------------------------------------------------------------------------
; THE LAST BYTES HERE ARE A COLD-START TEMPLATE
; ----------------------------------------------------------------------------
;
; Startup copies this small tagged structure into mutable workspace.  It seeds
; the current module and dictionary environment before the permanent supervisor
; program is selected.  Keeping the template beside permanent machine-I/O data
; makes the following compiled supervisor graph start at a clean architectural
; boundary.
;
supervisor_workspace_template:
    defb TERM_TAG_CONSTANT    ; current-module constant cell
    defw root_module_object
    defb TERM_TAG_LIST    ; current descriptor/program pointer
    defw root_module_descriptor
    defb TERM_TAG_END    ; root import dictionary starts empty
    defw 0ffffh
    defb TERM_TAG_END    ; root local dictionary starts empty
    defw 0ffffh
