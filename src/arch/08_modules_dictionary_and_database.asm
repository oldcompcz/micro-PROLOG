; -----------------------------------------------------------------------------
; Architectural module: 08_modules_dictionary_and_database.asm
; Cut, module management, constant interning, relation database mutation, and string/database primitives.
; Original monolithic line range: 4805-6626.
; Emitted address range: 0x7663-0x7FF4.
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Control and module-management dictionary cluster
; -----------------------------------------------------------------------------

; ============================================================================
; CHAPTER 8 — CHANGING THE PROGRAM WHILE IT IS RUNNING
; ============================================================================
;
; This long module contains the facilities which make micro-PROLOG an
; interactive environment rather than a fixed interpreter: cut, modules,
; constant interning, clause insertion and deletion, and string/character
; conversion.
;
; The common theme is stable identity.  Every constant has one canonical mutable
; value cell.  Modules move dictionary nodes rather than cloning names.  ADDCL
; splices list links rather than relocating existing clauses.  KILL clears a
; canonical value and lets the collector recover the now-unreachable graph.
;
slash_constant_entry:
    defb TERM_TAG_CONSTANT
    defw slash_value_cell
    defb TERM_TAG_LIST
    defw comment_constant_entry
slash_value_cell:
    defb TERM_TAG_INTEGER
    defw slash_primitive
; End-to-end cut example
; ----------------------
; Consider two clauses for choose/1 and a body goal q/0 which itself has two
; alternatives:
;
;       choose(X) :- q(X), /, r(X).
;       choose(fallback).
;
; Before `/`, the global choice ancestry can contain both the retry tail for the
; second choose clause and a younger choice created while solving q.  The current
; choose frame remembers the choice point which existed on entry.  Cut assigns
; that saved ancestor to EXEC_CHOICE_FRAME, making both younger alternatives
; unreachable.  Trail nodes are not blindly deleted: targets belonging to
; surviving storage remain valid, while targets in discarded execution storage
; are neutralized so later untrailing treats them as no-ops.
slash_name:
    defb 02fh,SYSTEM_NAME_TERMINATOR ; "/" — commit/cut

; Low-level Prolog cut/commit primitive.
;
; In:  EXEC_CURRENT_FRAME = frame of the clause whose body contains "/"
; Out: Z (the goal always succeeds)
; Side effects:
;   - EXEC_CHOICE_FRAME is reset to the choice point that existed on entry to
;     the invoking clause;
;   - choice points created by preceding body goals and remaining clauses for
;     the invoking call become unreachable;
;   - selected fixed-address trail descriptors are neutralized so later rollback
;     cannot write into execution cells discarded by the commit.
;
; The manual describes this as cutting both alternatives of earlier goals in the
; clause and untried clauses of the call that invoked it.  The first effect is a
; single assignment from frame+6.  The second trail pass does not unlink nodes;
; it changes only qualifying TERM_TAG_RELATIVE_REFERENCE descriptors to END.
; ----------------------------------------------------------------------------
; CUT FORGETS ALTERNATIVES, NOT BINDINGS
; ----------------------------------------------------------------------------
;
; The current frame remembers the choice point which existed on entry.  Slash
; restores that older pointer, making all younger alternatives unreachable.
; Trail nodes are not unlinked, because bindings made before and after the cut
; may still need to be undone by an older choice point.
;
; Instead, targets in discarded execution storage are changed to END.  The
; ordinary untrailer treats such nodes as no-ops while still following their
; predecessor links.  This avoids rebuilding the trail during cut.
;
; Reading prerequisite
; --------------------
; This chapter assumes the execution-frame, choice-point, trail, and collector
; models from modules 01-03.  In particular, cut does not “delete clauses”; it
; resets the newest reachable choice point and neutralizes trail targets that
; belonged only to discarded execution storage.
slash_primitive:
    ld ix,(EXEC_CURRENT_FRAME) ;766e: frame for the clause containing the cut

    ; Every frame snapshots the previously active choice point before it can
    ; publish itself.  Restoring that link atomically discards this frame as a
    ; clause alternative and all younger nested choice frames.
    ld l,(ix+EXEC_FRAME_PREVIOUS_CHOICE)
    ld h,(ix+EXEC_FRAME_PREVIOUS_CHOICE+1)
    ld (EXEC_CHOICE_FRAME),hl
    push hl
    pop ix                     ;767d: IX = retained older choice frame

    ; Its saved trail head is the rollback boundary that remains meaningful
    ; after the cut.  Nodes newer than it are scanned but remain linked.
    ld e,(ix+EXEC_FRAME_SAVED_TRAIL)
    ld d,(ix+EXEC_FRAME_SAVED_TRAIL+1)
    ld hl,(EXEC_TRAIL_HEAD)

; Inspect one trail node between the current head and the retained boundary.
;
; HL = current trail node
; DE = saved trail boundary of the retained older choice point
;
; Heap target forms (ABSOLUTE_REFERENCE and REFERENCE_NEXT_CELL) remain valid
; managed objects and are never changed here.  The reused RELATIVE_REFERENCE
; form identifies a fixed execution-arena target.  When that target is at or
; above the retained boundary, the target descriptor is replaced by END; the
; ordinary untrailer already treats END as a no-op target and still follows the
; node's second-cell link.
.cut_scan_trail_nodes:
    call compare_hl_de_preserving ;7687: boundary reached => Z success return
    ret z
    ld a,(hl)                   ;768b: target descriptor tag
    cp TRAIL_TARGET_EXECUTION_CELL
    jr nz,.cut_follow_previous_trail_node

    push hl                     ;7690: retain node while inspecting target address
    call term_load_payload_hl   ;7691: HL = fixed execution cell
    or a
    sbc hl,de                   ;7695: target below retained boundary remains live
    pop hl
    jr c,.cut_follow_previous_trail_node
    ld (hl),TERM_TAG_END        ;769a: suppress future untrail write to discarded cell

.cut_follow_previous_trail_node:
    inc hl
    inc hl
    inc hl                      ;769e: second cell is LIST(previous trail node)
    call term_load_payload_hl
    jr .cut_scan_trail_nodes

comment_constant_entry:
    defb TERM_TAG_CONSTANT
    defw comment_value_cell
    defb TERM_TAG_LIST
    defw cmod_constant_entry
comment_value_cell:
    defb TERM_TAG_INTEGER
    defw comment_primitive
comment_name:
    defb 02fh,02ah,SYSTEM_NAME_TERMINATOR ; "/*"
comment_primitive:
    cp a                       ;76b0: ignore all arguments and succeed
    ret

cmod_constant_entry:
    defb TERM_TAG_CONSTANT
    defw cmod_value_cell
    defb TERM_TAG_LIST
    defw opmod_constant_entry
cmod_value_cell:
    defb TERM_TAG_INTEGER
    defw cmod_primitive
; Module visibility example
; -------------------------
; Module M:
;       exports = (E)
;       imports = (I)
;       locals  = (L)
;
; Descriptor graph:
;       M.value -> MODULE -> [ exports:(E) | pair(imports:(I), locals:(L)) ]
;
; A call made while M is current searches: permanent system dictionary, E, I,
; then L.  Another module can see E through import/export wiring but cannot see L.
; Nodes are moved between dictionary lists; their canonical value cells are not
; duplicated.
cmod_name:
    defb 043h,04dh,04fh,044h,SYSTEM_NAME_TERMINATOR ; "CMOD"
cmod_primitive:
    ld ix,cmod_argument_state
    jp primitive_argument_dispatch
cmod_argument_state:
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
    defb cmod_completion_state-cmod_argument_state ; one unbound output argument
cmod_completion_state:
    defb cmod_return_current_module-cmod_completion_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
cmod_return_current_module:
    ld hl,(MODULE_CURRENT_OBJECT)
    ld (09808h),hl
    ld a,TERM_TAG_CONSTANT
    ld (09807h),a
    cp a
    ret

opmod_constant_entry:
    defb TERM_TAG_CONSTANT
    defw opmod_value_cell
    defb TERM_TAG_LIST
    defw crmod_constant_entry
opmod_value_cell:
    defb TERM_TAG_INTEGER
    defw opmod_primitive
opmod_name:
    defb 04fh,050h,04dh,04fh,044h,SYSTEM_NAME_TERMINATOR ; "OPMOD"
opmod_primitive:
    ld ix,opmod_argument_state
    jp primitive_argument_dispatch
opmod_argument_state:
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb opmod_completion_state-opmod_argument_state ; module-name constant
    defb DISPATCH_REJECT,DISPATCH_REJECT
opmod_completion_state:
    defb opmod_open_module-opmod_completion_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT

; Enter an existing module.
;
; In:  PRIMITIVE_ARG1_VALUE -> dictionary value cell of the requested name
; Out: Z on success, NZ if the name does not currently denote a module
; Side effects on success:
;   MODULE_CURRENT_OBJECT     = the named MODULE value cell
;   MODULE_CURRENT_DESCRIPTOR = its four-cell descriptor
;
; Opening is legal only while the root workspace module is current.  The
; descriptor address is obtained from the MODULE cell payload; no structure is
; copied, so subsequent clause lookup immediately uses the module's own export,
; import and local dictionaries.
opmod_open_module:
    ld hl,(PRIMITIVE_ARG1_VALUE)
    ld a,(hl)
    cp TERM_TAG_MODULE
    ret nz
    call require_root_module_current
    ld (MODULE_CURRENT_OBJECT),hl
    call term_load_payload_hl
    ld (MODULE_CURRENT_DESCRIPTOR),hl
    cp a
    ret

; Enforce the root-only precondition shared by OPMOD and CRMOD.
;
; HL is preserved for the caller.  A violation does not return: it raises the
; documented "Illegal use of modules" error (number 12).
require_root_module_current:
    push hl
    ld de,(MODULE_CURRENT_OBJECT)
    ld hl,root_module_object
    or a
    sbc hl,de
    jp nz,signal_illegal_module_use
    pop hl
    ret
crmod_constant_entry:
    defb TERM_TAG_CONSTANT
    defw crmod_value_cell
    defb TERM_TAG_LIST
    defw clmod_constant_entry
crmod_value_cell:
    defb TERM_TAG_INTEGER
    defw crmod_primitive
crmod_name:
    defb 043h,052h,04dh,04fh,044h,SYSTEM_NAME_TERMINATOR ; "CRMOD"
crmod_primitive:
    ld ix,crmod_module_name_state
    jp primitive_argument_dispatch
crmod_module_name_state:
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb crmod_export_list_state-crmod_module_name_state ; module name constant
    defb DISPATCH_REJECT,DISPATCH_REJECT
crmod_export_list_state:
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
    defb crmod_import_list_state-crmod_export_list_state ; export list
    defb DISPATCH_REJECT
crmod_import_list_state:
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
    defb crmod_completion_state-crmod_import_list_state ; import list
    defb DISPATCH_REJECT
crmod_completion_state:
    defb crmod_create_module-crmod_completion_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT

; Create and enter an empty module.
;
; Dispatcher arguments:
;   arg1  module-name constant; its value cell must still be END
;   arg2  proper list of exported constant names
;   arg3  proper list of imported constant names
;
; The new module reuses arg1's existing dictionary value cell as the named
; MODULE object.  Two six-byte heap objects form its descriptor:
;
;   descriptor +0  copy of export list
;   descriptor +3  LIST -> second pair
;   second +0      copy of import list
;   second +3      END, initially empty local dictionary
;
; Export names have already been interned in the root local dictionary while the
; CRMOD call was read.  The callback below moves each corresponding dictionary
; list node from root locals to root imports, implementing the rule that the root
; module automatically imports every name exported by a loaded module.
; ----------------------------------------------------------------------------
; A MODULE IS THREE DICTIONARIES
; ----------------------------------------------------------------------------
;
; Exports, imports and locals are separate dictionary lists held by a compact
; descriptor.  Creating a module reuses the canonical value cell of the module
; name, allocates the descriptor terms, and moves exported dictionary nodes from
; root locals to root imports.
;
; Moving nodes preserves both name storage and relation value identity.  Other
; compiled terms which already point at an exported constant continue to point
; at the same cell after the module boundary is created.
;
; Module object diagram
; ---------------------
; Every module name's canonical value cell points at a two-object descriptor:
;
;       module name value: [MODULE -> descriptor A]
;
;       descriptor A:      [exports dictionary | -> descriptor B]
;       descriptor B:      [imports dictionary | locals dictionary]
;
; Lookup order is permanent system names, exports, imports, then locals.  The
; root module uses the same shape, but its import and local dictionaries are the
; mutable workspace lists at fixed addresses.  Creating a module allocates the
; two descriptors, installs the three lists, and moves exported dictionary nodes
; into root imports so their canonical value cells keep stable identity.
crmod_create_module:
    ld hl,(PRIMITIVE_ARG1_VALUE)
    ld a,(hl)
    cp 010h
    jp nz,signal_illegal_module_use
    call test_dictionary_value_is_dynamic
    jp nz,signal_illegal_module_use
    push hl
    ld hl,(MODULE_CURRENT_OBJECT)
    call term_load_payload_hl
    inc hl
    inc hl
    inc hl
    call term_load_payload_hl
    ld (MODULE_ROOT_IMPORT_CELL_PTR),hl
    inc hl
    inc hl
    inc hl
    ld (MODULE_ROOT_LOCAL_CELL_PTR),hl
    pop hl
    call require_root_module_current
    ld (MODULE_CURRENT_OBJECT),hl
    ex de,hl
    call allocate_two_term_cells
    ld (MODULE_CURRENT_DESCRIPTOR),hl
    ex de,hl
    ld (hl),003h
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(PRIMITIVE_ARG2_VALUE)
    ld bc,00003h
    ldir
    call allocate_two_term_cells
    ex de,hl
    ld (hl),003h
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(MODULE_CURRENT_OBJECT)
    ld (hl),TERM_TAG_MODULE
    ld hl,(PRIMITIVE_ARG3_VALUE)
    ld bc,00003h
    ldir
    ld hl,.module_export_name_callback
    ld (LIST_WALK_CALLBACK_TARGET),hl
    ld hl,(PRIMITIVE_ARG2_VALUE)
    call walk_proper_list_with_callback
    cp a
    ret

; CRMOD callback for one export-name constant.
;
; The exported constant must not already have a relation/module/file value.  Its
; exact dictionary node is then removed from ROOT_MODULE_LOCAL_DICTIONARY and
; pushed onto ROOT_MODULE_IMPORT_DICTIONARY without allocating or copying the
; constant.  Consequently all modules and the root share one canonical value
; cell for an exported name.
.module_export_name_callback:
    call term_load_payload_hl
    ld a,(hl)
    cp 010h
    jr nz,.module_creation_rollback_error
    ex de,hl
    ld hl,(MODULE_ROOT_LOCAL_CELL_PTR)

; HL points at the list cell that owns the candidate root-local node; DE is the
; exported constant's value-cell address.  Keeping the predecessor cell rather
; than only the current pair makes removal a three-byte splice.
.module_find_export_in_root_locals:
    ld a,(hl)
    cp 010h
    jp z,.module_creation_rollback_error
    push hl
    call term_load_payload_hl
    push hl
    call term_load_payload_hl
    or a
    sbc hl,de
    jr nz,.module_advance_root_local_entry
    pop hl
    pop de
    push hl
    inc hl
    inc hl
    inc hl
    ld bc,00003h
    ldir
    dec hl
    dec hl
    dec hl
    ex de,hl
    ld hl,(MODULE_ROOT_IMPORT_CELL_PTR)
    ld bc,00003h
    ldir
    pop de
    ld hl,(MODULE_ROOT_IMPORT_CELL_PTR)
    ld (hl),003h
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    ret
.module_advance_root_local_entry:
    pop hl
    pop af
    inc hl
    inc hl
    inc hl
    jr .module_find_export_in_root_locals

; CRMOD failed after the module-name value cell had been converted.  Mark that
; cell END again, restore the root module as current, and report error 12.  Heap
; objects allocated for the incomplete descriptor become ordinary unreachable
; garbage and are reclaimed by the collector.
.module_creation_rollback_error:
    ld hl,(MODULE_CURRENT_OBJECT)
    ld (hl),010h
    call close_to_root_module
    jp signal_illegal_module_use
clmod_constant_entry:
    defb TERM_TAG_CONSTANT
    defw clmod_value_cell
    defb TERM_TAG_LIST
    defw space_constant_entry
clmod_value_cell:
    defb TERM_TAG_INTEGER
    defw clmod_primitive
clmod_name:
    defb 043h,04ch,04dh,04fh,044h,SYSTEM_NAME_TERMINATOR ; "CLMOD"
clmod_primitive:

; CLMOD implementation and shared emergency exit from failed CRMOD.
; The root object and descriptor are static, so closing requires only restoring
; these two workspace pointers.  CLMOD deliberately ignores its command argument.
close_to_root_module:
    ld hl,root_module_object
    ld (MODULE_CURRENT_OBJECT),hl
    call term_load_payload_hl
    ld (MODULE_CURRENT_DESCRIPTOR),hl
    cp a
    ret

; Delete a named non-current, non-root module (the module form of KILL).
;
; The module's value cell is first changed to END so the name becomes ordinary
; and reusable.  Each export node is moved from the root import dictionary back
; to the root local dictionary, with its relation value cleared.  Finally every
; constant owned solely by the module's local dictionary releases its name-pool
; blocks.  The descriptor and clause graphs are left unreachable for GC.
;
; Deleting the current module or the permanent root module fails normally rather
; than signalling an interpreter error.
; ----------------------------------------------------------------------------
; DELETION REVERSES OWNERSHIP, THEN RELIES ON GC
; ----------------------------------------------------------------------------
;
; A module cannot delete itself or the permanent root.  For an ordinary module,
; exported nodes move back to root locals, private names are returned to the
; bitmap pool, and canonical relation values are cleared.
;
; Clause lists and descriptor terms are not walked and freed one by one.  Once
; links from dictionaries are gone they are simply unreachable, which is exactly
; the case the garbage collector is designed to handle.
;
; Ownership-preserving dictionary splice
; ------------------------------------
; Exported names are moved, never copied.  For one node N:
;
;       before:
;           root imports -> ... -> N -> next
;           module exports -> N -> next_export
;
;       deletion action:
;           unlink N from root imports
;           relink N at root locals
;           clear N.value if it denotes a relation owned by the module
;
; Because N itself survives, every compiled pointer to N's canonical value cell
; remains valid.  Only list ownership changes; unreachable module descriptors
; and clauses are left for GC.
delete_module_object:
    ld de,(PRIMITIVE_ARG1_VALUE)
    ld a,(de)
    cp TERM_TAG_MODULE
    ret nz
    ld hl,(MODULE_CURRENT_OBJECT)
    or a
    sbc hl,de
    jr nz,.module_delete_begin
.module_delete_rejected:
    or 001h
    ret
.module_delete_begin:
    ld hl,root_module_object
    or a
    sbc hl,de
    jr z,.module_delete_rejected
    ld a,010h
    ld (de),a
    ld hl,root_module_object
    call term_load_payload_hl
    inc hl
    inc hl
    inc hl
    call term_load_payload_hl
    ld (MODULE_ROOT_IMPORT_CELL_PTR),hl
    inc hl
    inc hl
    inc hl
    ld (MODULE_ROOT_LOCAL_CELL_PTR),hl
    ld hl,.module_remove_export_callback
    ld (LIST_WALK_CALLBACK_TARGET),hl
    ex de,hl
    call term_load_payload_hl
    push hl
    call walk_proper_list_with_callback
    pop hl
    inc hl
    inc hl
    inc hl
    call term_load_payload_hl
    inc hl
    inc hl
    inc hl

; Walk the deleted module's local dictionary and return each descriptor's
; variable-length name allocation to DICTIONARY_ALLOCATION_BITMAP.  Export and
; import constants are shared and therefore are not released here.
.module_release_local_dictionary:
    ld a,(hl)
    cp 010h
    ret z
    call term_load_payload_hl
    push hl
    call term_load_payload_hl
    call release_dictionary_name_storage
    pop hl
    inc hl
    inc hl
    inc hl
    jr .module_release_local_dictionary

; Module-deletion callback for one exported constant.
;
; Clear any clauses still attached to the shared value cell, locate its list node
; in the root import dictionary, unlink it, and prepend the same node to the root
; local dictionary.  This reverses the node transfer performed by CRMOD.
.module_remove_export_callback:
    push hl
    push de
    push bc
    inc hl
    ld c,(hl)
    inc hl
    ld b,(hl)
    ld h,b
    ld l,c
    call clear_owned_relation_value
    ld hl,(MODULE_ROOT_IMPORT_CELL_PTR)
.module_find_export_in_root_imports:
    ld a,(hl)
    cp 003h
    jr nz,.module_remove_export_return
    inc hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    push hl
    call term_load_payload_hl
    or a
    sbc hl,bc
    pop hl
    jr nz,.module_advance_root_import_entry
    dec de
    dec de
    inc hl
    inc hl
    inc hl
    ld bc,00003h
    ldir
    ex de,hl
    ld hl,(MODULE_ROOT_LOCAL_CELL_PTR)
    inc hl
    inc hl
    dec de
    ld bc,00003h
    lddr
    dec de
    dec de
    inc hl
    ld (hl),003h
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
.module_remove_export_return:
    pop bc
    pop de
    pop hl
    ret
.module_advance_root_import_entry:
    inc hl
    inc hl
    inc hl
    jr .module_find_export_in_root_imports

; Central module-constraint violation.  Error 12 is "Illegal use of modules" in
; Appendix C of the reference manual.
signal_illegal_module_use:
    ld hl,ERROR_ILLEGAL_MODULE_USE
    jp signal_interpreter_error
space_constant_entry:
    defb TERM_TAG_CONSTANT
    defw space_value_cell
    defb TERM_TAG_LIST
    defw internal_fresh_copy_constant_entry
space_value_cell:
    defb TERM_TAG_INTEGER
    defw space_primitive
space_name:
    defb 053h,050h,041h,043h,045h,SYSTEM_NAME_TERMINATOR ; "SPACE"
space_primitive:
    ld ix,space_argument_state
    jp primitive_argument_dispatch
space_argument_state:
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
    defb space_completion_state-space_argument_state ; one unbound output argument
space_completion_state:
    defb space_collect_and_report-space_completion_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
space_collect_and_report:
    call garbage_collect
    ld a,(TERM_HEAP_FREE_BYTES_HIGH)
    rrca
    rrca
    and 03fh
    ld l,a
    ld h,000h
    ld a,004h
    ld (09808h),hl
    ld (09807h),a
    cp a
    ret
; Hidden ordinary dictionary entry whose stored one-byte name is 0xCE.
; Clearing bit 7 gives ASCII "N", but no documented public primitive can yet be
; matched to that spelling. The handler is nevertheless clear: it recursively
; copies a term while remapping source variables to fresh destination variables.
internal_fresh_copy_constant_entry:
    defb TERM_TAG_CONSTANT
    defw internal_fresh_copy_value_cell
    defb TERM_TAG_LIST
    defw charof_constant_entry
internal_fresh_copy_value_cell:
    defb TERM_TAG_INTEGER
    defw internal_fresh_copy_primitive
; The following stored one-byte name is an encoded internal identifier 0xCE.
; Its public glyph/spelling is not proved and is intentionally not rendered as
; low-seven-bit ASCII.  The primitive semantics are known independently.
internal_fresh_copy_name_encoded:
    defb 0ceh,SYSTEM_NAME_TERMINATOR
; The unresolved printed name is not semantically required
; -------------------------------------------------
; The one-byte spelling 0xCE is historically unresolved, but its handler contract
; is fully reconstructed: recursively copy a term while replacing each distinct
; source variable with one fresh destination variable.  Permanent supervisor
; clauses call it by pointer, not by human-readable spelling, so understanding
; or testing the copy semantics does not depend on guessing the glyph.
internal_fresh_copy_primitive:
    ld de,(EXEC_CALLER_ENV_BASE)
    ld hl,(EXEC_CALL_ARGUMENTS)
    call term_dereference_hl
    cp 003h
    ret nz
    call term_load_payload_hl
    push hl
    call term_dereference_hl
    ld (EXEC_CALL_ARGUMENTS),hl
    pop hl
    inc hl
    inc hl
    inc hl
    call term_dereference_hl
    cp 003h
    ret nz
    call term_load_payload_hl
    ld bc,09807h
    ld a,0ffh
    ld (FRESH_VARIABLE_MAP_END_HIGH),a
    call copy_term_with_fresh_variables
    ld hl,09807h
    ld de,(EXEC_CALL_ARGUMENTS)
    ld bc,00003h
    ldir
    cp a
    ret
; Fresh-variable example
; ----------------------
; Source term `(p X X Y)` contains two distinct variables.  The copy map evolves:
;
;       first X -> allocate X' and remember source-X -> X'
;       second X -> reuse X'
;       first Y -> allocate Y' and remember source-Y -> Y'
;
; Result: `(p X' X' Y')`.  Sharing is preserved, but no destination variable is
; identical to any source variable.  This is the operation needed by CL and
; meta-level supervisor code when exposing stored clauses safely.
copy_term_with_fresh_variables:
    push hl
    push bc
; Resolve references before deciding whether to copy, recurse or remap a variable.
.copy_term_resolve_source:
    call term_dereference_hl
    push de
    ld de,(EXEC_CALL_ARGUMENTS)
    or a
    push hl
    sbc hl,de
    pop hl
    pop de
    jr z,.copy_term_detect_self_reference
    cp 003h
    jr nz,.copy_term_non_list
    push hl
    call allocate_two_term_cells
    ld a,003h
    ld (bc),a
    inc bc
    ld a,l
    ld (bc),a
    inc bc
    ld a,h
    ld (bc),a
    ld b,h
    ld c,l
    pop hl
    call term_load_payload_hl
    call copy_term_with_fresh_variables
    inc hl
    inc hl
    inc hl
    inc bc
    inc bc
    inc bc
    jr .copy_term_resolve_source
.copy_term_non_list:
    cp 000h
    jr nz,.copy_term_detect_self_reference
    ld ix,FRESH_VARIABLE_SOURCE_MAP
; Assign one fresh destination variable per distinct source-variable identity.
.copy_term_unbound_variable:
    ld a,(ix+001h)
    cp 0ffh
    jr z,.copy_term_reuse_variable_mapping
    push de
    ld d,a
    ld e,(ix+000h)
    call compare_hl_de_preserving
    pop de
    jr z,.copy_term_literal_cell
    inc ix
    inc ix
    inc ix
    inc ix
    jr .copy_term_unbound_variable
; Repeated source variables become references to the existing fresh cell.
.copy_term_reuse_variable_mapping:
    ld (ix+000h),l
    ld (ix+001h),h
    ld (ix+002h),c
    ld (ix+003h),b
    ld (ix+005h),0ffh
    ld a,000h
    ld (bc),a
    jr .copy_term_return
.copy_term_literal_cell:
    ld l,(ix+002h)
    bit 0,l
    ld h,(ix+003h)
    ld a,001h
    jr z,.copy_term_advance_pair
    ld a,005h
    dec hl
    dec hl
    dec hl
.copy_term_advance_pair:
    ld (bc),a
    inc bc
    ld a,l
    ld (bc),a
    inc bc
    ld a,h
    ld (bc),a
    jr .copy_term_return
; Preserve a source self-reference without recursing indefinitely.
.copy_term_detect_self_reference:
    push de
    ld d,b
    ld e,c
    ld bc,00003h
    ldir
    pop de
.copy_term_return:
    pop bc
    pop hl
    ret

; Intern the constant whose temporary spelling starts at DICTIONARY_INPUT_BUFFER
; and ends with 0xFE.
;
; Search order is deliberately visibility order:
;   1. permanent system dictionary;
;   2. current module exports;
;   3. current module imports;
;   4. current module locals.
;
; On a hit:  A=TERM_TAG_CONSTANT, HL=canonical value cell.
; On a miss: allocate a variable-length descriptor in the dictionary name pool,
;            prepend a new constant node to the current local dictionary and
;            return its END value cell.
;
; The dictionary lists contain canonical constants, so pointer identity of value
; cells is sufficient for module export/import splicing and relation lookup.
; ----------------------------------------------------------------------------
; INTERNING MAKES TEXTUAL EQUALITY INTO POINTER EQUALITY
; ----------------------------------------------------------------------------
;
; Lookup searches the permanent system dictionary, current exports, imports and
; locals in that order.  An existing spelling returns its canonical value cell.
; A new spelling obtains bitmap-managed name blocks and a fresh dictionary node.
;
; The temporary reader spelling ends in 0xFE while stored names end in 0xFF.
; The comparator treats either marker as end-of-name, allowing lookup without
; rewriting the temporary token buffer first.
;
intern_constant_from_input_buffer:
    push de
    push bc
    xor a
    ld (DICTIONARY_INPUT_GUARD),a
    ld de,DICTIONARY_INPUT_BUFFER
    ld hl,system_dictionary_root
    call find_named_constant_in_dictionary
    jp z,.intern_restore_and_return
    ld hl,(MODULE_CURRENT_OBJECT)
    call term_load_payload_hl
    push hl
    call find_named_constant_in_dictionary
    jr z,.intern_search_next_dictionary
    pop hl
    inc hl
    inc hl
    inc hl
    call term_load_payload_hl
    push hl
    call find_named_constant_in_dictionary
    jr z,.intern_search_next_dictionary
    pop hl
    inc hl
    inc hl
    inc hl
    ld (MODULE_ROOT_LOCAL_CELL_PTR),hl
    push hl
    call find_named_constant_in_dictionary
; Continue lookup through exports, imports and locals before allocating a name.
.intern_search_next_dictionary:
    inc sp
    inc sp
    jr z,.intern_restore_and_return
    call allocate_two_term_cells
    push hl
    inc hl
    inc hl
    inc hl
    ld de,(MODULE_ROOT_LOCAL_CELL_PTR)
    ex de,hl
    ld bc,00003h
    ldir
    pop de
    ld hl,(MODULE_ROOT_LOCAL_CELL_PTR)
    ld (hl),003h
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,DICTIONARY_INPUT_BUFFER
    call measure_dictionary_name_blocks
    call allocate_dictionary_name_storage
    jr z,.intern_allocate_local_name
    call garbage_collect
    call allocate_dictionary_name_storage
    jr z,.intern_allocate_local_name
    ld hl,(MODULE_ROOT_LOCAL_CELL_PTR)
    inc de
    inc de
    inc de
    ex de,hl
    ld bc,00003h
    ldir
    jp dictionary_full_error
; No dictionary owns the spelling: reserve bitmap blocks for a local descriptor.
.intern_allocate_local_name:
    ex de,hl
    ld (hl),008h
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    ex de,hl
    push hl
    ld (hl),010h
    inc hl
    inc hl
    inc hl
    ld de,DICTIONARY_INPUT_BUFFER
; Install the canonical mutable value cell and splice the descriptor into locals.
.intern_link_new_descriptor:
    ld a,(de)
    ld (hl),a
    cp 0feh
    jr z,.intern_return_existing_constant
    inc hl
    inc de
    jr .intern_link_new_descriptor
.intern_return_existing_constant:
    ld (hl),0ffh
    pop hl
    cp a
.intern_restore_and_return:
    ld a,008h
    pop bc
    pop de
    ret

; Search one proper dictionary list for DICTIONARY_INPUT_BUFFER.
;
; In:  HL -> owning LIST/END cell, DE -> 0xFE-terminated input spelling
; Out: Z and HL -> matching constant value cell; NZ if the list ends
;
; Stored names begin immediately after the value cell and use 0xFF.  A match
; therefore requires byte equality plus the asymmetric 0xFE/0xFF terminator pair.
find_named_constant_in_dictionary:
    ld a,(hl)
    cp 003h
    ret nz
    call term_load_payload_hl
    ld a,(hl)
    cp 008h
    call nz,system_abort
    push hl
    call term_load_payload_hl
    push hl
    push de
    inc hl
    inc hl
    inc hl
.compare_dictionary_name_bytes:
    ld a,(de)
    cp (hl)
    jr nz,.dictionary_name_mismatch
    inc hl
    inc de
    jr .compare_dictionary_name_bytes
.dictionary_name_mismatch:
    cp 0feh
    jr nz,.advance_dictionary_entry
    ld a,(hl)
    cp 0ffh
    jr nz,.advance_dictionary_entry
    pop de
    pop hl
    pop af
    cp a
    ret
.advance_dictionary_entry:
    pop de
    pop hl
    pop hl
    inc hl
    inc hl
    inc hl
    jr find_named_constant_in_dictionary

; Compute the contiguous bitmap mask needed for one dictionary descriptor.
;
; In:  HL -> input name terminated by 0xFE or an existing name terminated by 0xFF
; Out: B = high-aligned run of one bits, one bit per eight-byte pool block
;
; The first block spends three bytes on the value cell and one on the terminator,
; leaving four name bytes.  Every further block contributes eight bytes.  Thus
; lengths 0..4 need 0x80, 5..12 need 0xC0, and the maximum 60-byte name uses 0xFF.
measure_dictionary_name_blocks:
    ld b,080h
    push hl
    push de
    ld d,005h
.measure_dictionary_name_next_byte:
    ld a,(hl)
    cp 0feh
    jr z,.measure_dictionary_name_done
    cp 0ffh
    jr nz,.measure_dictionary_name_count_byte
.measure_dictionary_name_done:
    pop de
    pop hl
    ret
.measure_dictionary_name_count_byte:
    inc hl
    dec d
    jr nz,.measure_dictionary_name_next_byte
    ld d,008h
    sra b
    jr .measure_dictionary_name_next_byte

; First-fit allocation from the dictionary name pool.
;
; In:  B = high-aligned contiguous block mask from measure_dictionary_name_blocks
; Out: Z and HL = first byte of the allocated descriptor, or NZ when full
;
; DICTIONARY_ALLOCATION_BITMAP uses one=free, zero=allocated.  The routine tests
; every bit alignment, including runs crossing a bitmap-byte boundary, clears the
; claimed bits, then converts the linear bit number to base + number*8.
; ----------------------------------------------------------------------------
; NAMES LIVE IN EIGHT-BYTE BLOCKS
; ----------------------------------------------------------------------------
;
; The first block contains the three-byte mutable value cell, up to four name
; characters and a terminator.  Further blocks contribute eight more characters
; each.  A bit value of one means free, and first-fit search may cross bitmap
; byte boundaries.
;
; Stable name addresses are worth the modest fragmentation: constants embedded
; throughout compiled clauses can keep direct pointers to their value cells.
;
; Bitmap allocation examples
; --------------------------
; One bitmap bit owns one eight-byte name-pool block.  The first block also holds
; the three-byte canonical value cell, leaving room for four name bytes plus the
; terminator:
;
;       name length 4   -> 1 block -> mask 10000000b
;       name length 5   -> 2 blocks -> mask 11000000b
;       name length 13  -> 3 blocks -> mask 11100000b
;
; Runs may cross bitmap-byte boundaries.  A 1 bit means free; allocation clears
; the chosen run, and release sets exactly the same bits again.
allocate_dictionary_name_storage:
    push bc
    push de
    ld hl,DICTIONARY_ALLOCATION_BITMAP
    ld c,000h
.dictionary_allocator_scan_bitmap_byte:
    ld a,(hl)
    or a
    jr nz,.dictionary_allocator_try_byte
    inc hl
.dictionary_allocator_advance_bit_index:
    inc c
    jr nz,.dictionary_allocator_scan_bitmap_byte
    or 001h
    pop de
    pop bc
    ret
.dictionary_allocator_try_byte:
    ld d,008h
    inc hl
    ld e,(hl)
.dictionary_allocator_test_alignment:
    push af
    xor b
    and b
    jr z,.dictionary_allocator_claim_bits
    pop af
    dec d
    jr z,.dictionary_allocator_advance_bit_index
    rl e
    rl a
    jr .dictionary_allocator_test_alignment
.dictionary_allocator_claim_bits:
    pop af
    push af
    xor b
    ld b,a
    pop af
    ld a,d
.dictionary_allocator_rotate_claim_mask:
    rl e
    rl b
    dec a
    jr nz,.dictionary_allocator_rotate_claim_mask
    rl e
    ld (hl),b
    dec hl
    ld (hl),e
    ld a,008h
    sub d
    ld b,000h
    sla c
    rl b
    sla c
    rl b
    sla c
    rl b
    or c
    ld c,a
    sla c
    rl b
    sla c
    rl b
    sla c
    rl b
    ld hl,(DICTIONARY_NAME_POOL_BASE_PTR)
    add hl,bc
    cp a
    pop de
    pop bc
    ret

; Return a dictionary descriptor's complete variable-length allocation.
;
; In: HL -> descriptor value cell; its stored name follows at HL+3
;
; The address determines the starting bitmap bit.  Re-measuring the stored name
; reconstructs the exact run length, after which the aligned mask is ORed back
; into the bitmap.  No heap object is involved: dictionary names have their own
; non-moving pool and allocator.
release_dictionary_name_storage:
    push de
    push bc
    push hl
    push hl
    ld de,(DICTIONARY_NAME_POOL_BASE_PTR)
    or a
    sbc hl,de
    ld b,000h
    ld d,b
    sla l
    rl h
    sla l
    rl h
    ld c,h
    sla l
    rl d
    sla l
    rl d
    sla l
    rl d
    ld hl,DICTIONARY_ALLOCATION_BITMAP
    add hl,bc
    ex (sp),hl
    inc hl
    inc hl
    inc hl
    call measure_dictionary_name_blocks
    or a
    ld c,000h
    inc d
    dec d
    jr z,.dictionary_release_publish_bits
.dictionary_release_align_mask:
    rr b
    rr c
    dec d
    jr nz,.dictionary_release_align_mask
.dictionary_release_publish_bits:
    pop hl
    ld a,(hl)
    or b
    ld (hl),a
    inc hl
    ld a,(hl)
    or c
    ld (hl),a
    pop hl
    pop bc
    pop de
    ret
charof_constant_entry:
    defb TERM_TAG_CONSTANT
    defw charof_value_cell
    defb TERM_TAG_LIST
    defw stringof_constant_entry
charof_value_cell:
    defb TERM_TAG_INTEGER
    defw charof_primitive
charof_name:
    defb 043h,048h,041h,052h,04fh,046h,SYSTEM_NAME_TERMINATOR ; "CHAROF"
; ----------------------------------------------------------------------------
; CHAROF AND STRINGOF BRIDGE TERMS AND BYTE STRINGS
; ----------------------------------------------------------------------------
;
; These relations are reversible where their argument modes allow it.  CHAROF
; may verify a character/code pair, obtain a code from a one-character constant,
; or construct that constant from a code.  STRINGOF similarly packs and unpacks
; between constants and lists of character constants.
;
; Their dispatch automata choose the direction before the handlers run.  The
; handlers can therefore assume that exactly the required arguments are bound
; and that output slots are genuine unbound variables.
;
charof_primitive:
    ld ix,charof_first_argument_state
    jp primitive_argument_dispatch

; CHAROF supports all three documented modes: both arguments known, character
; known/code variable, and character variable/code known.
charof_first_argument_state:
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb charof_second_after_constant-charof_first_argument_state
    defb DISPATCH_REJECT
    defb charof_second_after_variable-charof_first_argument_state
charof_second_after_constant:
    defb DISPATCH_REJECT
    defb charof_compare_state-charof_second_after_constant
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb charof_return_code_state-charof_second_after_constant
charof_compare_state:
    defb charof_compare_completion-charof_compare_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
charof_return_code_state:
    defb charof_return_code_completion-charof_return_code_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
charof_second_after_variable:
    defb DISPATCH_REJECT
    defb charof_return_character_state-charof_second_after_variable
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
charof_return_character_state:
    defb charof_return_character_completion-charof_return_character_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
charof_compare_completion:
    ld a,(09812h)
    cp 004h
    ret nz
    ld hl,(PRIMITIVE_ARG1_VALUE)
    inc hl
    inc hl
    inc hl
    ld a,(PRIMITIVE_ARG2_VALUE)
    cp (hl)
    ret
charof_return_code_completion:
    ld hl,(PRIMITIVE_ARG1_VALUE)
    inc hl
    inc hl
    inc hl
    ld l,(hl)
    ld h,000h
    ld a,004h
    ld (0980eh),hl
    ld (0980dh),a
    cp a
    ret
charof_return_character_completion:
    ld a,(09812h)
    cp 004h
    ret nz
    ld hl,(PRIMITIVE_ARG2_VALUE)
charof_intern_character_constant:
    ld h,0feh
    ld (DICTIONARY_INPUT_BUFFER),hl
    call intern_constant_from_input_buffer
    ld (09807h),a
    ld (09808h),hl
    cp a
    ret
stringof_constant_entry:
    defb TERM_TAG_CONSTANT
    defw stringof_value_cell
    defb TERM_TAG_LIST
    defw addcl_constant_entry
stringof_value_cell:
    defb TERM_TAG_INTEGER
    defw stringof_primitive
; STRINGOF modes
; --------------
;   unpack:  STRINGOF "ABC" X
;            X is unbound; produce character list (A B C), no new constant.
;
;   pack:    STRINGOF X (A B C)   [conceptual argument orientation by dispatcher]
;            constant side is unbound; validate character codes, intern "ABC",
;            and bind the output to its canonical constant value cell.
;
;   compare: STRINGOF "ABC" (A B C)
;            both sides known; compare without allocating or interning a new name.
;
; The compact state table chooses the mode solely from which argument is unbound
; and from the resolved term classes.
stringof_name:
    defb 053h,054h,052h,049h,04eh,047h,04fh,046h,SYSTEM_NAME_TERMINATOR ; "STRINGOF"
; STRINGOF reversible modes
; --------------------------
;       STRINGOF Constant List
;
;       Constant bound, List variable  -> allocate list of character constants
;       Constant variable, List bound  -> validate characters and intern string
;       both bound                     -> compare exact spelling
;       both variables                 -> reject: relation has no finite choice
;
; The dispatcher distinguishes these modes before the recursive conversion, so
; the code below can specialize allocation, construction, or comparison.
stringof_primitive:
    ld ix,stringof_first_argument_state
    jp primitive_argument_dispatch

; STRINGOF either unpacks a constant into a character list, checks an existing
; list against a constant, or packs a character list into an unbound constant.
stringof_first_argument_state:
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
    defb stringof_second_after_list-stringof_first_argument_state
    defb stringof_second_after_variable-stringof_first_argument_state
stringof_second_after_variable:
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb stringof_unpack_state-stringof_second_after_variable
    defb DISPATCH_REJECT,DISPATCH_REJECT
stringof_unpack_state:
    defb stringof_unpack_completion-stringof_unpack_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
stringof_second_after_list:
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb stringof_compare_state-stringof_second_after_list
    defb DISPATCH_REJECT
    defb stringof_pack_state-stringof_second_after_list
stringof_pack_state:
    defb stringof_pack_completion-stringof_pack_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
stringof_compare_state:
    defb stringof_compare_completion-stringof_compare_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
stringof_unpack_completion:
    ld hl,09807h
    ld bc,(PRIMITIVE_ARG2_VALUE)
    inc bc
    inc bc
    inc bc
    jp stringof_unpack_next_character
stringof_compare_completion:
    ld hl,(PRIMITIVE_ARG1_VALUE)
    ld bc,(PRIMITIVE_ARG2_VALUE)
    inc bc
    inc bc
    inc bc
    ld de,(EXEC_CALLER_ENV_BASE)
    jr stringof_compare_tail
stringof_pack_completion:
    ld hl,(PRIMITIVE_ARG1_VALUE)
    ld de,(EXEC_CALLER_ENV_BASE)
    ld ix,DICTIONARY_INPUT_BUFFER
    ld b,03ch
; Consume one-character constants from a proper list into the 60-byte name buffer.
.stringof_pack_list_loop:
    call term_dereference_hl
    cp 003h
    jr nz,.stringof_pack_finish_constant
    call term_load_payload_hl
    push hl
    call term_dereference_hl
    cp 008h
    jr z,.stringof_pack_copy_character
    cp 000h
    jp z,signal_control_error
    pop hl
    ret
.stringof_pack_copy_character:
    call term_load_payload_hl
    inc hl
    inc hl
    inc hl
    inc b
    dec b
    jr z,.stringof_pack_advance_tail
    dec b
    ld a,(hl)
    ld (ix+000h),a
    inc ix
.stringof_pack_advance_tail:
    inc hl
    ld a,(hl)
    pop hl
    cp 0ffh
    ret nz
    inc hl
    inc hl
    inc hl
    jr .stringof_pack_list_loop
; Terminate the collected spelling and intern or reuse its canonical constant.
.stringof_pack_finish_constant:
    cp 010h
    ret nz
    ld a,0feh
    ld (ix+000h),a
    call intern_constant_from_input_buffer
    ld (0980eh),hl
    ld (0980dh),a
    cp a
    ret
; Compare one list character with the next stored constant-name byte.
.stringof_compare_character:
    push hl
    call term_dereference_hl
    cp 008h
    jr nz,.stringof_compare_unbound_character
    call term_load_payload_hl
    inc hl
    inc hl
    inc hl
    inc hl
    ld a,(hl)
    cp 0ffh
    jr z,.stringof_compare_byte
.stringof_compare_fail:
    pop hl
    ret
.stringof_compare_byte:
    dec hl
    ld a,(bc)
    cp (hl)
.stringof_compare_restore:
    pop hl
    ret nz
    inc bc
    inc hl
    inc hl
    inc hl
; Advance in lockstep through the list tail and constant spelling terminator.
stringof_compare_tail:
    call term_dereference_hl
    cp 010h
    jr nz,.stringof_compare_non_end_tail
    ld a,(bc)
    cp 0ffh
    ret
.stringof_compare_non_end_tail:
    cp 003h
    jr nz,.stringof_compare_bind_variable_tail
    ld a,(bc)
    cp 0ffh
    jr nz,.stringof_compare_follow_list
    or 001h
    ret
.stringof_compare_follow_list:
    call term_load_payload_hl
    jr .stringof_compare_character
.stringof_compare_bind_variable_tail:
    cp 000h
    ret nz
    ex de,hl
    push bc
    call trail_variable_if_needed
    pop bc
    ex de,hl
; Expand the next stored name byte into a singleton constant term in a list pair.
stringof_unpack_next_character:
    ld a,(bc)
    cp 0ffh
    jr nz,.stringof_unpack_allocate_pair
    ld (hl),010h
    ret
.stringof_unpack_allocate_pair:
    push hl
    call allocate_two_term_cells
    ex de,hl
    pop hl
    ld (hl),003h
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    ex de,hl
    call stringof_store_character_term
    inc bc
    inc hl
    inc hl
    inc hl
    jr stringof_unpack_next_character
.stringof_compare_unbound_character:
    cp 000h
    jr nz,.stringof_compare_fail
    call stringof_store_character_term
    push hl
    push de
    push bc
    ex de,hl
    call trail_variable_if_needed
    pop bc
    pop de
    pop hl
    jr .stringof_compare_restore
stringof_store_character_term:
    push bc
    push de
    push hl
    ld a,(bc)
    ld l,a
    ld h,0feh
    ld (DICTIONARY_INPUT_BUFFER),hl
    call intern_constant_from_input_buffer
    ex de,hl
    pop hl
    push hl
    ld (hl),a
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    pop hl
    pop de
    pop bc
    ret
addcl_constant_entry:
    defb TERM_TAG_CONSTANT
    defw addcl_value_cell
    defb TERM_TAG_LIST
    defw kill_constant_entry
addcl_value_cell:
    defb TERM_TAG_INTEGER
    defw addcl_primitive
; Complete ADDCL compilation trace
; ------------------------------
; Enter source clause: `((P X X) (Q X))`.
;
; 1. Parser has chained all three source occurrences to one variable identity.
; 2. P is separated as the relation constant; its canonical local value cell is
;    the owner cursor for the relation list.
; 3. First occurrence of X is assigned local offset 0.  Both later occurrences
;    find the same source-cell representative and reuse offset 0.
; 4. Stored head arguments become RELATIVE 0, RELATIVE 0.
; 5. Stored body atom Q carries RELATIVE 0.
; 6. Metadata records local_count=1 and points to the compiled stream.
; 7. A new clause pair is linked at the requested owner cursor; the former suffix
;    becomes the pair's next-clause tail.
addcl_name:
    defb 041h,044h,044h,043h,04ch,SYSTEM_NAME_TERMINATOR ; "ADDCL"
; ADDCL Clause [Position]
;
; Compile a caller-owned clause term into the persistent database format and
; splice it into the current module's locally owned relation.  The one-argument
; form appends; the two-argument form inserts after the requested zero-based
; position, with an over-large position also degenerating to append.
;
; The transformation is intentionally destructive only to the freshly copied
; heap graph: the relation name is removed from the stored head, an INTEGER
; local-count metadata cell is built, and source variables are replaced by
; RELATIVE_REFERENCE offsets into the fresh local environment allocated on each
; later call.  No database mutation is trailed, so backtracking does not undo it.
;
; Failure modes:
;   - malformed clause or position: logical failure (NZ);
;   - primitive/imported/file/module relation name: error 4 (ADDCL error).
; ----------------------------------------------------------------------------
; ADDCL IS A COMPILER AS WELL AS A LIST OPERATION
; ----------------------------------------------------------------------------
;
; The entered clause is source-shaped: its head includes the relation name and
; repeated variables are represented by parser reference chains.  Stored clauses
; use a different form.  ADDCL removes the predicate name, assigns each distinct
; variable a relative local offset, records the local count, and copies the
; transformed head/body into managed storage.
;
; Only then is a new clause pair spliced at the requested owner cursor.  Existing
; clause addresses remain stable, which keeps active choice points valid.
;
; Worked ADDCL compilation
; ------------------------
; Source clause:
;
;       ((R X X Y) (S Y))
;
; Assume R's dictionary value cell is owned by the current module.  ADDCL
; transforms it to a reusable compiled clause:
;
;       1. remove relation name R from the stored head;
;       2. assign distinct source variables local offsets:
;              X -> 0,  Y -> 3
;       3. rewrite occurrences:
;              head args -> [REL 0, REL 0, REL 3]
;              body S Y  -> [S, REL 3]
;       4. store metadata local_count = 2 and pointer to the clause stream;
;       5. allocate a new clause-pair node;
;       6. splice it through the owner cursor at the requested position.
;
; Pseudocode:
;
;       addcl(source_clause, position = append):
;           relation = validate_head_and_find_owned_value_cell(source_clause)
;           cursor = locate_insertion_owner(relation, position)
;           variable_map = {}
;           compiled = copy_clause(source_clause without relation_name):
;               variable v -> RELATIVE_REFERENCE(3 * index(variable_map, v))
;               other term -> recursively copy
;           metadata = { local_count: len(variable_map), stream: compiled }
;           new_pair = cons(metadata, cursor.value)
;           cursor.value = new_pair
;
; Stored relative references become real fresh cells only when module 02 selects
; the clause and allocates its local environment.
addcl_primitive:
    ld hl,(EXEC_CALL_ARGUMENTS)
    ld ix,(EXEC_CURRENT_FRAME)
    ld e,(ix+EXEC_FRAME_LOCAL_BASE)
    ld d,(ix+EXEC_FRAME_LOCAL_BASE+1)
    ld (EXEC_CALLER_ENV_BASE),de
    call term_dereference_hl
    cp TERM_TAG_LIST
    ret nz
    ld de,09807h
    call term_load_payload_hl
    ld (EXEC_CALL_ARGUMENTS),hl
    ld c,000h
    ld a,0ffh
    ld (FRESH_VARIABLE_MAP_END_HIGH),a
    call compile_clause_term_with_relative_variables
    ld hl,09807h
    call term_load_payload_hl
    ld (DATABASE_NEW_CLAUSE_PAIR),hl
    ld a,(hl)
    cp TERM_TAG_LIST
    ret nz
    call term_load_payload_hl
    ld a,(hl)
    cp TERM_TAG_CONSTANT
    ret nz
    ld a,TERM_TAG_LIST
    ld (0980dh),a
    ld (0980eh),hl
    push hl
    call term_load_payload_hl
    ld (DATABASE_RELATION_VALUE_CELL),hl
    call test_dictionary_value_is_dynamic
    jp nz,.addcl_permission_error
    ex de,hl
    ld hl,(MODULE_CURRENT_OBJECT)
    call term_load_payload_hl
    inc hl
    inc hl
    inc hl
    call term_load_payload_hl
.addcl_scan_local_dictionary:
    ld a,(hl)
    cp TERM_TAG_END
    jr z,.addcl_relation_is_locally_owned
    cp TERM_TAG_LIST
    call nz,system_abort
    call term_load_payload_hl
    push hl
    call term_load_payload_hl
    or a
    sbc hl,de
    jr z,.addcl_permission_error
    pop hl
    inc hl
    inc hl
    inc hl
    jr .addcl_scan_local_dictionary
.addcl_relation_is_locally_owned:
    pop hl
    inc hl
    inc hl
    inc hl
    push hl
    push bc
    ld bc,00003h
    ld de,(DATABASE_NEW_CLAUSE_PAIR)
    ldir
    pop bc
    dec de
    dec de
    dec de
    pop hl
    ld (hl),TERM_TAG_LIST
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(0980eh)
    ld d,000h
    ld e,c
    ld (hl),TERM_TAG_INTEGER
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    call allocate_two_term_cells
    ld de,(0980eh)
    ld (DATABASE_NEW_CLAUSE_PAIR),hl
    ld (hl),TERM_TAG_LIST
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(EXEC_CALL_ARGUMENTS)
    inc hl
    inc hl
    inc hl
    ld de,(EXEC_CALLER_ENV_BASE)
    call term_dereference_hl
    cp TERM_TAG_END
    jr nz,.addcl_decode_requested_position
    ld bc,ADDCL_APPEND_POSITION
    jr .addcl_find_insertion_cursor
.addcl_decode_requested_position:
    cp TERM_TAG_LIST
    ret nz
    call term_load_payload_hl
    call term_dereference_hl
    cp TERM_TAG_INTEGER
    ret nz
    call term_load_payload_hl
    ld c,l
    ld b,h
.addcl_find_insertion_cursor:
    ld hl,(DATABASE_RELATION_VALUE_CELL)
    call relation_cursor_skip_clauses
    ld a,(hl)
    cp TERM_TAG_LIST
    jr z,.addcl_splice_new_clause
    cp TERM_TAG_END
    jr z,.addcl_splice_new_clause
.addcl_permission_error:
    ld hl,00004h
    jp signal_interpreter_error
.addcl_splice_new_clause:
    ld de,(DATABASE_NEW_CLAUSE_PAIR)
    push de
    push hl
    inc de
    inc de
    inc de
    ld bc,00003h
    ldir
    pop hl
    pop de
    ld (hl),TERM_TAG_LIST
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    cp a
    ret
; Copy one term graph into ADDCL's persistent clause representation.
;
; In:  HL = source term cell in caller environment
;      DE = destination cell (scratch cell or allocated heap object)
;      C  = number of distinct clause variables already assigned
;      FRESH_VARIABLE_SOURCE_MAP = source-address table, high-byte 0xFF sentinel
; Out: copied term at DE; C increased for each first-seen variable
;      every variable encoded as RELATIVE_REFERENCE with payload 3*ordinal
;
; Lists allocate one six-byte pair and recurse over head and tail.  Bound leaves
; are copied verbatim after dereferencing.  Repeated source variables reuse the
; same relative offset, preserving variable identity within the stored clause.
; ----------------------------------------------------------------------------
; COMPILING VARIABLES TO ENVIRONMENT OFFSETS
; ----------------------------------------------------------------------------
;
; The temporary variable map gives the first distinct source variable offset 0,
; the next offset 3, and so on.  Repeated occurrences reuse the same offset.
; At run time the clause selector allocates that many unbound cells and supplies
; their base as EXEC_CLAUSE_ENV_BASE.
;
; This is the essential compilation performed by the resident system: names and
; parser reference chains disappear, leaving compact relative references which
; are cheap to instantiate on every call.
;
; Repeated variables are recognized by source-variable cell identity, not by their
; printed spelling.  The parser has already linked repeated spellings into one
; representative chain.  The temporary compiler map associates that representative
; with one relative offset.  After every occurrence is rewritten, the stored
; clause contains only offsets, so the temporary map can be discarded safely.
compile_clause_term_with_relative_variables:
    push hl
    push de
.compile_clause_next_cell:
    push de
    ld de,(EXEC_CALLER_ENV_BASE)
    call term_dereference_hl
    pop de
    cp TERM_TAG_LIST
    jr nz,.compile_clause_copy_variable_or_leaf
    push hl
    push de
    call allocate_two_term_cells
    pop de
    ex de,hl
    ld (hl),TERM_TAG_LIST
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    pop hl
    call term_load_payload_hl
    call compile_clause_term_with_relative_variables
    inc hl
    inc hl
    inc hl
    inc de
    inc de
    inc de
    jr .compile_clause_next_cell
.compile_clause_copy_variable_or_leaf:
    cp TERM_TAG_UNBOUND_VARIABLE
    jr nz,.compile_clause_copy_literal_cell
    ld a,TERM_TAG_RELATIVE_REFERENCE
    ld (de),a
    inc de
    ld b,000h
    ld ix,FRESH_VARIABLE_SOURCE_MAP
.compile_clause_scan_variable_map:
    ld a,(ix+001h)
    cp 0ffh
    jr z,.compile_clause_add_variable_mapping
    push de
    ld d,a
    ld e,(ix+000h)
    call compare_hl_de_preserving
    pop de
    jr z,.compile_clause_write_relative_variable
    inc b
    inc b
    inc b
    inc ix
    inc ix
    jr .compile_clause_scan_variable_map
.compile_clause_add_variable_mapping:
    ld (ix+000h),l
    ld (ix+001h),h
    ld (ix+003h),0ffh
    inc c
.compile_clause_write_relative_variable:
    ex de,hl
    ld (hl),b
    inc hl
    ld (hl),000h
    jr .compile_clause_return
.compile_clause_copy_literal_cell:
    push bc
    ld bc,00003h
    ldir
    pop bc
.compile_clause_return:
    pop de
    pop hl
    ret
; Private two-argument relation used by the permanent DELCL program.  Its
; printed name is "*", but it is not linked into either public dictionary.
; Keeping a private value cell lets the built-in Prolog wrapper invoke the
; machine operation through the ordinary relation-call mechanism.
internal_delete_clause_value_cell:
    defb TERM_TAG_INTEGER
    defw internal_delete_clause_primitive
internal_delete_clause_name:
    defb 02ah,SYSTEM_NAME_TERMINATOR ; "*"

; Validate the private call (* Relation Position).  The compact dispatch states
; accept a constant relation followed by an integer position.
internal_delete_clause_primitive:
    ld ix,internal_delete_relation_state
    jp primitive_argument_dispatch
internal_delete_relation_state:
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb internal_delete_position_state-internal_delete_relation_state
    defb DISPATCH_REJECT,DISPATCH_REJECT
internal_delete_position_state:
    defb DISPATCH_REJECT
    defb internal_delete_completion_state-internal_delete_position_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
internal_delete_completion_state:
    defb internal_delete_completion-internal_delete_completion_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT

; Delete the Nth clause of an owned relation by replacing the cursor cell that
; names it with the deleted pair's tail.  The relation list is a proper cons
; chain, so deletion is a three-byte link splice and does not move any clause.
;
; Dispatcher scratch:
;   ARG1 value = canonical relation value cell
;   ARG2 value = one-based clause position
; Out: Z when the selected clause exists and was unlinked; NZ otherwise.
; ----------------------------------------------------------------------------
; DELETION PATCHES THE OWNER CELL
; ----------------------------------------------------------------------------
;
; The first clause is owned by the relation value cell; later clauses are owned
; by the preceding pair's tail.  Once the desired owner cursor is found,
; deletion copies the removed pair's tail over that cursor.
;
; The removed metadata and term graph are left untouched.  No active pointer can
; reach them through the relation list, so eventual collection is sufficient.
;
internal_delete_completion:
    ld hl,(PRIMITIVE_ARG1_VALUE)
    call test_dictionary_value_is_dynamic
    ret nz
    ld a,(PRIMITIVE_ARG2_TAG)
    cp TERM_TAG_INTEGER
    ret nz
    ld bc,(PRIMITIVE_ARG2_VALUE)
    dec bc
    call relation_cursor_skip_clauses
    ld a,(hl)
    cp TERM_TAG_LIST
    ret nz
    push hl
    call term_load_payload_hl
    inc hl
    inc hl
    inc hl
    pop de
    ld bc,00003h
    ldir
    cp a
    ret
; Private four-argument relation used by CL.  It has the same printed name "*"
; as the deletion helper but a distinct canonical value cell and handler.
internal_fetch_clause_value_cell:
    defb TERM_TAG_INTEGER
    defw internal_fetch_clause_primitive
internal_fetch_clause_name:
    defb 02ah,SYSTEM_NAME_TERMINATOR ;7eee: "*"

; Validate (* Relation HeadArgs Body Position).  Relation and Position are
; inputs; HeadArgs and Body must be unbound output variables.
internal_fetch_clause_primitive:
    ld ix,internal_fetch_relation_state
    jp primitive_argument_dispatch
internal_fetch_relation_state:
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb internal_fetch_head_output_state-internal_fetch_relation_state
    defb DISPATCH_REJECT,DISPATCH_REJECT
internal_fetch_head_output_state:
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
    defb internal_fetch_body_output_state-internal_fetch_head_output_state
internal_fetch_body_output_state:
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
    defb internal_fetch_position_state-internal_fetch_body_output_state
internal_fetch_position_state:
    defb DISPATCH_REJECT
    defb internal_fetch_completion_state-internal_fetch_position_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
internal_fetch_completion_state:
    defb internal_fetch_completion-internal_fetch_completion_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT

; Retrieve the Nth compiled clause without exposing its stored relative
; variables.  The normal clause selector allocates a temporary fresh local
; environment, then the generic copier materializes independent head/body terms
; into the primitive output slots.  The temporary execution frame is discarded
; before return and the caller's global choice point is restored.
internal_fetch_completion:
    ld hl,(PRIMITIVE_ARG1_VALUE)
    ld a,(PRIMITIVE_ARG4_TAG)
    cp TERM_TAG_INTEGER
    ret nz
    ld bc,(PRIMITIVE_ARG4_VALUE)
    dec bc
    call relation_cursor_skip_clauses
    ld a,(hl)
    cp TERM_TAG_LIST
    ret nz
    ld (EXEC_NEXT_CLAUSE),hl
    ld hl,(EXEC_CHOICE_FRAME)
    push hl
    call select_clause_and_allocate_frame
    pop hl
    ld (EXEC_CHOICE_FRAME),hl
    ld bc,(EXEC_CLAUSE_ENV_BASE)
    ld de,PRIMITIVE_ARG2_RESULT_TAG
    ld hl,(EXEC_SELECTED_HEAD)
    call copy_term_for_binding
    ld de,PRIMITIVE_ARG3_RESULT_TAG
    ld hl,(EXEC_SELECTED_BODY)
    call copy_term_for_binding
    ld (EXEC_ALLOCATION_TOP),bc
    ld hl,(EXEC_PREVIOUS_FRAME_TOP)
    ld (EXEC_FRAME_TOP),hl
    cp a
    ret
; Advance through a relation's proper clause list without decoding clauses.
;
; In:  HL = owner cell containing LIST(first pair), another tail cell, or END
;      BC = number of clauses to skip
; Out: HL = cursor cell after BC clauses; Z only when BC reached zero
;      NZ if the relation ended or became malformed before the requested point
;
; Returning the owner cell rather than the pair itself is what allows ADDCL and
; DELCL to splice a link with a single three-byte copy.
relation_cursor_skip_clauses:
    ld a,c
    cp b
    jr nz,.relation_cursor_skip_next
    or a
    ret z
.relation_cursor_skip_next:
    ld a,(hl)
    cp TERM_TAG_LIST
    ret nz
    call term_load_payload_hl
    inc hl
    inc hl
    inc hl
    dec bc
    jr relation_cursor_skip_clauses
kill_constant_entry:
    defb TERM_TAG_CONSTANT
    defw kill_value_cell
    defb TERM_TAG_LIST
    defw abort_constant_entry
kill_value_cell:
    defb TERM_TAG_INTEGER
    defw kill_primitive
kill_name:
    defb 04bh,049h,04ch,04ch,SYSTEM_NAME_TERMINATOR ; "KILL"
; KILL Name | (Name...) | ALL | Module
;
; The dispatcher separates a single constant from an explicit list.  A single
; module object is delegated to module deletion; ALL derives the current
; module's local dictionary and clears every owned relation.  Relation values
; are changed to END in place, so canonical constants and dictionary nodes stay
; valid and the now-unreachable clause graphs are reclaimed later by GC.
kill_primitive:
    ld ix,kill_first_argument_state
    jp primitive_argument_dispatch
kill_first_argument_state:
    defb DISPATCH_REJECT,DISPATCH_REJECT
    defb kill_single_constant_state-kill_first_argument_state
    defb kill_list_state-kill_first_argument_state
    defb DISPATCH_REJECT
kill_single_constant_state:
    defb kill_single_constant_completion-kill_single_constant_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
kill_list_state:
    defb kill_list_completion-kill_list_state
    defb DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT,DISPATCH_REJECT
kill_single_constant_completion:
    ld de,(PRIMITIVE_ARG1_VALUE)
    ld hl,SUPERVISOR_ALL_VALUE_CELL
    or a
    sbc hl,de
    jr z,kill_all_owned_relations
    ex de,hl
    ld a,(hl)
    cp TERM_TAG_MODULE
    jp z,delete_module_object
; Clear one user-owned relation value for relation-form KILL.
;
; HL is the canonical value cell of the named constant.  END is accepted as an
; already-empty relation.  A LIST value is reset to END only when the value cell
; belongs to the dynamic dictionary pool; permanent primitives, imported names,
; files and modules are rejected without mutation.
; Operational warning: ADDCL, DELCL and KILL mutate the persistent relation
; database.  These writes are not logical variable bindings, are not placed on
; the unification trail, and are not undone when Prolog backtracks.  Reclamation
; of detached clause graphs is deferred to garbage collection.
clear_owned_relation_value:
    ld a,(hl)
    cp TERM_TAG_END
    ret z
    cp TERM_TAG_LIST
    ret nz
    call test_dictionary_value_is_dynamic
    ret nz
    ld (hl),TERM_TAG_END
    ret
kill_all_owned_relations:
    ld hl,(MODULE_CURRENT_OBJECT)
    call term_load_payload_hl
    inc hl
    inc hl
    inc hl
    call term_load_payload_hl
    inc hl
    inc hl
    inc hl
    jr kill_relation_list_loop
kill_list_completion:
    ld hl,(PRIMITIVE_ARG1_VALUE)
kill_relation_list_loop:
    ld a,(hl)
    cp TERM_TAG_END
    ret z
    cp TERM_TAG_LIST
    jp nz,signal_control_error
    call term_load_payload_hl
    push hl
    ld a,(hl)
    cp TERM_TAG_CONSTANT
    jr nz,.kill_advance_relation_list
    call term_load_payload_hl
    call clear_owned_relation_value
.kill_advance_relation_list:
    pop hl
    inc hl
    inc hl
    inc hl
    jr kill_relation_list_loop
abort_constant_entry:
    defb TERM_TAG_CONSTANT
    defw abort_value_cell
    defb TERM_TAG_LIST
    defw lne_constant_entry
abort_value_cell:
    defb TERM_TAG_INTEGER
    defw abort_primitive
abort_name:
    defb 041h,042h,04fh,052h,054h,SYSTEM_NAME_TERMINATOR ; "ABORT"
abort_primitive:
    ld sp,(SUPERVISOR_MACHINE_STACK)
    jp supervisor_restart
