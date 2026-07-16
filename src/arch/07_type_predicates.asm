; -----------------------------------------------------------------------------
; Architectural module: 07_type_predicates.asm
; Type predicates, FAIL, NEW, and their system-dictionary entries.
; Original monolithic line range: 4610-4804.
; Emitted address range: 0x7589-0x7662.
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Built-in system dictionary: type predicates and FAIL
; -----------------------------------------------------------------------------
; Each entry has this fixed prefix:
;
;   constant cell : [TERM_TAG_CONSTANT, pointer to value cell]
;   dictionary link: [TERM_TAG_LIST, pointer to next constant entry]
;   value cell    : [TERM_TAG_INTEGER, primitive handler address]
;   name bytes terminated by 0xFF
;
; The primitive handler normally selects a compact argument-dispatch automaton
                               ; and enters primitive_argument_dispatch.

; ============================================================================
; CHAPTER 7 — THE SMALLEST PRIMITIVES SHOW THE DISPATCHER MOST CLEARLY
; ============================================================================
;
; NUM, VAR, LST and CON are almost pure type tests.  Their Z80 handlers are only
; a CP/RET pair; the interesting behavior is in the five-byte dispatch record
; which decides whether the argument reaches the common success or failure
; completion state.
;
; Reading this cluster is the easiest way to understand native relation data:
;
;       dictionary constant -> integer value cell -> handler
;                            -> FF-terminated name
;                            -> compact argument-state table
;
; FAIL bypasses dispatch and returns NZ directly.  SYS is slightly richer: it
; recognizes constants and structures whose predicate denotes a permanent
; system relation rather than a dynamic workspace relation.
;
num_constant_entry:
    defb TERM_TAG_CONSTANT
    defw num_value_cell
    defb TERM_TAG_LIST
    defw var_constant_entry
num_value_cell:
    defb TERM_TAG_INTEGER
    defw num_primitive
num_name:
    defb 04eh,055h,04dh,SYSTEM_NAME_TERMINATOR ; "NUM"
num_primitive:
    ld ix,num_dispatch_state
    jp primitive_argument_dispatch
num_dispatch_state:
    defb DISPATCH_REJECT
    defb type_success_state-num_dispatch_state ; numeric term
    defb type_failure_state-num_dispatch_state ; constant term
    defb type_failure_state-num_dispatch_state ; other bound term
    defb type_failure_state-num_dispatch_state ; unbound variable

var_constant_entry:
    defb TERM_TAG_CONSTANT
    defw var_value_cell
    defb TERM_TAG_LIST
    defw lst_constant_entry
var_value_cell:
    defb TERM_TAG_INTEGER
    defw var_primitive
var_name:
    defb 056h,041h,052h,SYSTEM_NAME_TERMINATOR ; "VAR"
var_primitive:
    ld ix,var_dispatch_state
    jp primitive_argument_dispatch
var_dispatch_state:
    defb DISPATCH_REJECT
    defb type_failure_state-var_dispatch_state ; numeric term
    defb type_failure_state-var_dispatch_state ; constant term
    defb type_failure_state-var_dispatch_state ; other bound term
    defb type_success_state-var_dispatch_state ; unbound variable

lst_constant_entry:
    defb TERM_TAG_CONSTANT
    defw lst_value_cell
    defb TERM_TAG_LIST
    defw con_constant_entry
lst_value_cell:
    defb TERM_TAG_INTEGER
    defw lst_primitive
lst_name:
    defb 04ch,053h,054h,SYSTEM_NAME_TERMINATOR ; "LST"
lst_primitive:
    ld ix,lst_dispatch_state
    jp primitive_argument_dispatch
lst_dispatch_state:
    defb DISPATCH_REJECT
    defb type_failure_state-lst_dispatch_state ; numeric term
    defb type_failure_state-lst_dispatch_state ; constant term
    defb type_success_state-lst_dispatch_state ; list term
    defb type_failure_state-lst_dispatch_state ; unbound variable

con_constant_entry:
    defb TERM_TAG_CONSTANT
    defw con_value_cell
    defb TERM_TAG_LIST
    defw fail_constant_entry
con_value_cell:
    defb TERM_TAG_INTEGER
    defw con_primitive
con_name:
    defb 043h,04fh,04eh,SYSTEM_NAME_TERMINATOR ; "CON"
con_primitive:
    ld ix,con_dispatch_state
    jp primitive_argument_dispatch
con_dispatch_state:
    defb DISPATCH_REJECT
    defb type_failure_state-con_dispatch_state ; numeric term
    defb type_success_state-con_dispatch_state ; constant term
    defb type_failure_state-con_dispatch_state ; other bound term
    defb type_failure_state-con_dispatch_state ; unbound variable

; Completion states shared by NUM, VAR, LST and CON.  At end-of-arguments,
                               ; primitive_argument_dispatch adds byte 0 to IX and jumps there.
type_success_state:
    defb type_predicate_success-type_success_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
type_predicate_success:
    cp a                       ;75f2: set Z
    ret

type_failure_state:
    defb primitive_fail-type_failure_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT

fail_constant_entry:
    defb TERM_TAG_CONSTANT
    defw fail_value_cell
    defb TERM_TAG_LIST
    defw sys_constant_entry
fail_value_cell:
    defb TERM_TAG_INTEGER
    defw primitive_fail
fail_name:
    defb 046h,041h,049h,04ch,SYSTEM_NAME_TERMINATOR ; "FAIL"
primitive_fail:
    or 001h                   ;7607: force NZ
    ret

sys_constant_entry:
    defb TERM_TAG_CONSTANT
    defw sys_value_cell
    defb TERM_TAG_LIST
    defw slash_constant_entry
sys_value_cell:
    defb TERM_TAG_INTEGER
    defw sys_primitive
; SYS examples
; ------------
;   SYS CON:             succeeds: CON: is a permanent system constant/device
;   SYS <module object>  succeeds through the structured/system-object path
;   SYS (a b)            fails: an ordinary user list is structured but is not
;                        one of the recognized system-owned object forms
;
; The two successful dispatcher completions distinguish a direct system constant
; from a tagged structured system object; they do not mean that every list is SYS.
sys_name:
    defb 053h,059h,053h,SYSTEM_NAME_TERMINATOR ; "SYS"
; ----------------------------------------------------------------------------
; SYS ASKS ABOUT OWNERSHIP, NOT SPELLING
; ----------------------------------------------------------------------------
;
; A name may look identical whether it denotes a primitive, imported relation
; or local user relation.  SYS follows the canonical value cell and tests where
; that cell is stored.  Permanent interpreter addresses denote system objects;
; dynamic dictionary-name storage denotes user/module-owned objects.
;
; For an atom list, SYS first extracts its predicate constant and then applies
; the same address test.  The structure itself need not be executed.
;
; System constants versus interned user constants
; -----------------------------------------
; SYS succeeds only for constants whose dictionary entry belongs to the permanent
; system dictionary--primitive names and built-in supervisor constants.  An
; ordinary spelling interned into a module dictionary is still a CONSTANT term,
; so CON succeeds, but SYS does not.  Module 08 explains how dictionary ownership
; makes this distinction a stable pointer test.
sys_primitive:
    ld ix,sys_dispatch_state
    jp primitive_argument_dispatch

; SYS accepts either a constant directly or a structured term whose relation
; name can be reached through its list head.  The two completion states select
; the corresponding address test.
sys_dispatch_state:
    defb DISPATCH_REJECT
    defb DISPATCH_REJECT
    defb sys_constant_completion_state-sys_dispatch_state
    defb sys_structure_completion_state-sys_dispatch_state
    defb DISPATCH_REJECT
sys_constant_completion_state:
    defb sys_test_constant_address-sys_constant_completion_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
sys_structure_completion_state:
    defb sys_test_structure_head-sys_structure_completion_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT

sys_test_constant_address:
    ld hl,(PRIMITIVE_ARG1_VALUE)
sys_test_address:
    call test_dictionary_value_is_dynamic
    or a
    ret
sys_test_structure_head:
    call sys_extract_relation_constant
    ret nz
    jr sys_test_address
sys_extract_relation_constant:
    ld hl,(PRIMITIVE_ARG1_VALUE)
    ld a,(hl)
    cp TERM_TAG_LIST
    ret nz
    call term_load_payload_hl
    ld de,(EXEC_CALLER_ENV_BASE)
    call term_dereference_hl
    cp TERM_TAG_CONSTANT
    ret nz
    call term_load_payload_hl
    ret
; Classify a constant value cell by storage ownership.
;
; In:  HL = canonical dictionary value-cell address
; Out: A=1 and Z when HL lies in the dynamically allocated user-name pool;
;      A=0 and NZ for permanent system/supervisor constants.
;
; ADDCL, DELCL and relation-form KILL use the Z result as their write-permission
; check.  SYS immediately retests A, thereby succeeding only for permanent
; system constants.
test_dictionary_value_is_dynamic:
    push hl
    push de
    ex de,hl
    ld hl,DICTIONARY_DYNAMIC_VALUE_MIN
    xor a
    scf
    sbc hl,de
    rla
    cp 001h
    pop de
    pop hl
    ret

