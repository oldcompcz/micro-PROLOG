; -----------------------------------------------------------------------------
; Architectural module: 02_clause_unification_and_allocation.asm
; Clause selection, execution records, unification, trailing, term copying, heap allocation, and primitive dispatch.
; Original monolithic line range: 981-1889.
; Emitted address range: 0x6312-0x6712.
; -----------------------------------------------------------------------------

; ============================================================================
; CHAPTER 2 — CLAUSES, VARIABLES, BINDINGS AND THE TRAIL
; ============================================================================
;
; This module is the mechanical heart of Prolog.  Clause selection creates
; fresh variables, unification makes tentative equations true, and the trail
; records exactly those mutations which would otherwise survive a retry.
;
; The implementation gains much of its compactness from one discipline:
; allocation is monotonic between choice points.  Young frames and young heap
; objects vanish by rewinding frontiers.  Only mutations to older variables
; need explicit trail records.
;
; ----------------------------------------------------------------------------
; SELECTING A CLAUSE ALSO CONSTRUCTS ITS WORLD
; ----------------------------------------------------------------------------
;
; Stored clauses contain relative variable numbers, not live variable cells.
; Selection reads the local count, reserves N three-byte cells, clears their
; tags to UNBOUND, and makes their base the clause environment.  The compiled
; head and body can then use offsets 0, 3, 6 ... to refer to those fresh cells.
;
; The twelve bytes following the locals are a snapshot of the hot execution
; words.  If another clause remains, this frame is published as the newest
; choice point.  If not, it remains only as a continuation.
;
; Worked clause-selection example
; -------------------------------
; Suppose relation R has two clauses and the first clause needs two locals:
;
;       relation value -> [clause-1 | clause-2 | END]
;       incoming call  =  (R a)
;
; Selecting clause 1 creates a 12-byte frame and two unbound local cells:
;
;       next clause        = cursor pointing at clause-2
;       caller frame       = previous current frame
;       caller goals       = goals after (R a)
;       previous choice    = older global choice point
;       saved trail        = current trail head
;       local base         = address of local X
;
;       locals:  X=[UNBOUND]  Y=[UNBOUND]
;
; Because clause-2 exists, this frame becomes the newest choice point.  If head
; unification later fails, restoration reinstalls the saved six words and calls
; the selector again with the clause-2 cursor.  If clause 1 were the last clause,
; its frame would still be a continuation but would not hide the older choice
; point.
; Concrete stored-clause example
; ------------------------------
; Source: `((P X) (Q X))`
;
; ADDCL stores one metadata record with local_count=1.  The head argument X and
; body argument X are both `[RELATIVE_REFERENCE | 0]`.  On each selection:
;
;       local_base+0 = [UNBOUND_VARIABLE | ----]
;
; Both stored references resolve to that fresh cell.  A second invocation gets a
; different local_base and therefore a different logical X without changing the
; read-only clause graph.
select_clause_and_allocate_frame:
    ld hl,(EXEC_FRAME_TOP)
    ld (EXEC_PREVIOUS_FRAME_TOP),hl
    ld hl,(EXEC_NEXT_CLAUSE)   ;6318: root list or retained tail from a prior try
    ld a,(hl)
    cp TERM_TAG_LIST           ;631c: END/malformed suffix means no candidate
    ret nz                     ;631e: preserve NZ for logical failure
    call term_load_payload_hl  ;631f: HL = pair head containing current clause
    ld a,(hl)
    cp TERM_TAG_LIST           ;6323: each relation element must be a clause list
    ret nz

    ; Save the pair-head address because pair+3 is the retry tail.  The second
    ; payload is the compiled metadata object whose first cell is the local count.
    push hl                    ;6326: relation pair head
    call term_load_payload_hl  ;6327: HL = metadata local-count cell
    push hl                    ;632a: metadata base
    ld a,(hl)
    cp TERM_TAG_INTEGER
    call nz,system_abort       ;632e: corrupt compiled clause is not Prolog failure
    call term_load_payload_hl  ;6331: HL = unsigned local count N
    push hl                    ;6334: retained for the initialization loop
    push hl                    ;6335: duplicate N for multiplication
    ; Convert N cells to 3*N bytes without a multiply routine: 2*N + N.
    add hl,hl
    pop de
    add hl,de
    ; Require locals + 12-byte frame + a six-byte allocation safety reserve.
    ld de,EXEC_FRAME_SIZE+(2*TERM_CELL_SIZE)
    add hl,de
    ld de,(EXEC_ALLOCATION_TOP)
    add hl,de
    ld de,(TERM_HEAP_CURSOR)
    ; The execution arena grows upward toward the downward-growing managed heap.
    call compare_hl_de_preserving
    jr c,.allocate_clause_locals
    ; One collection retry is permitted before reporting No Space.
    call garbage_collect
    ld de,(TERM_HEAP_CURSOR)
    or a
    sbc hl,de
    jp nc,no_space_error
; Space is available.  Zero the clause's local-variable cells so each starts as
; TERM_TAG_UNBOUND_VARIABLE, and leave HL at the frame address immediately after
; them.  A zero local count skips the loop without changing the layout.
.allocate_clause_locals:
    pop bc
    ld b,c
    inc b
    dec b
    ld hl,(EXEC_ALLOCATION_TOP)
    ; Relative references in the compiled head/body are offsets from this base.
    ld (EXEC_CLAUSE_ENV_BASE),hl
    jr z,.build_execution_frame   ;6362: zero locals leaves frame at allocation top
.initialize_clause_local:
    ; Only the tag must be cleared.  The two payload bytes are semantically dead
    ; until unification binds the cell, matching the rollback convention.
    ld (hl),TERM_TAG_UNBOUND_VARIABLE
    inc hl
    inc hl
    inc hl
    djnz .initialize_clause_local
; Decode the selected clause head and body pointers, advance
; EXEC_NEXT_CLAUSE to the next candidate, and copy the six hot execution words
; into the new record.  If another clause remains, this frame becomes the newest
; choice point; otherwise it is only a return continuation.
; New-call fields versus preserved continuation
; ------------------------------------------
;   created for the selected call:
;       NEXT_CLAUSE   retry tail after the chosen clause
;       LOCAL_BASE    fresh locals allocated for this invocation
;
;   copied from the caller/hot state:
;       CALLER        logical return frame
;       CALLER_GOALS  goals to resume after this call
;       PREV_CHOICE   older global choice ancestry
;       SAVED_TRAIL   rollback boundary at call entry
.build_execution_frame:
    ld (EXEC_FRAME_TOP),hl
    pop hl                     ;636e: metadata local-count cell
    inc hl
    inc hl
    inc hl                     ;6371: metadata+3 contains the clause-stream reference
    call term_load_payload_hl  ;6372: HL = head atom at stream+0
    ld (EXEC_SELECTED_HEAD),hl
    inc hl
    inc hl
    inc hl                     ;637a: body begins one term cell after the head
    ld (EXEC_SELECTED_BODY),hl
    pop hl                     ;637e: relation pair head retained at 6326
    inc hl
    inc hl
    inc hl                     ;6381: pair+3 is the proper-list tail used for retry
    ld (EXEC_NEXT_CLAUSE),hl
    ; Snapshot exactly the six contiguous execution words defined above.
    ld hl,EXEC_NEXT_CLAUSE
    ld de,(EXEC_FRAME_TOP)
    ld bc,EXEC_FRAME_SIZE
    ldir
    ld (EXEC_ALLOCATION_TOP),de
    ld hl,(EXEC_NEXT_CLAUSE)
    ld a,(hl)
    ; A proper-list END proves determinism for this call: the frame remains a
    ; return continuation but does not replace the older global choice point.
    cp TERM_TAG_END
    ret z

    ; Any non-END suffix means another clause may be tried.  Publish this frame
    ; as the newest choice point; CP A is the two-byte idiom that forces Z before
    ; returning to the common success path.
    ld hl,(EXEC_FRAME_TOP)
    ld (EXEC_CHOICE_FRAME),hl
    cp a
    ret
; Restore a failed choice point and undo every binding made since it was saved.
;
; In:  IX = frame at EXEC_CHOICE_FRAME
; Out: Z set; the hot six-word execution state is restored from IX
; Clobbers: AF, BC, DE, HL; IX remains the selected choice frame
;
; EXEC_FRAME_SAVED_TRAIL is a pointer boundary, not a count.  The current trail
; is walked until that exact pointer is reached.  Every traversed node names one
; variable whose tag was changed from UNBOUND; restoring only the zero tag is
; sufficient because an unbound cell's payload is ignored.  The frame snapshot
; then restores EXEC_TRAIL_HEAD, so the discarded nodes become unreachable.
; ----------------------------------------------------------------------------
; ROLLBACK: FIRST UNDO MUTATIONS, THEN RESTORE CONTROL
; ----------------------------------------------------------------------------
;
; A trail boundary belongs to a choice point.  Nodes newer than that boundary
; describe variables whose tags changed from UNBOUND after the choice was made.
; Walking back to the boundary and clearing those tags recreates the old logical
; state; payload bytes need not be restored because an unbound payload is dead.
;
; Only after variables are repaired are the six hot words copied back from the
; frame.  This order matters: trail links and their targets are interpreted in
; the still-current address space, before allocation pointers are rewound.
;
; Rollback pseudocode
; -------------------
; choice = EXEC_CHOICE_FRAME
; boundary = choice.SAVED_TRAIL
;
; while EXEC_TRAIL_HEAD != boundary:
;     node = EXEC_TRAIL_HEAD
;     target = decode_trail_target(node.target)
;     target.tag = UNBOUND_VARIABLE
;     EXEC_TRAIL_HEAD = node.previous
;
; restore NEXT_CLAUSE, CALLER, CALLER_GOALS, PREV_CHOICE,
;         SAVED_TRAIL and LOCAL_BASE from choice
; retry clause selection at restored NEXT_CLAUSE
restore_choice_and_untrail:
    ; Stop untrailing at the trail head saved before this clause attempt.
    ld e,(ix+EXEC_FRAME_SAVED_TRAIL)
    ld d,(ix+EXEC_FRAME_SAVED_TRAIL+1)
    ld hl,(EXEC_TRAIL_HEAD)
; Walk one two-cell trail node.
;
; HL = current node, DE = saved boundary.  Cell 0 is a context-specific target
; descriptor; cell 1 is always LIST(previous-node).  Execution-arena targets use
; tag 0x0C with an absolute payload.  Heap targets use ABSOLUTE_REFERENCE for the
; first cell of a six-byte object or REFERENCE_NEXT_CELL for its second cell.
; Two trail target forms
; ----------------------
; Execution-cell node:
;       target tag RELATIVE_REFERENCE, payload = fixed address 0xA010
;       decoded target is exactly 0xA010; clear byte at 0xA010.
;
; Heap second-cell node:
;       target tag REFERENCE_NEXT_CELL, payload = pair base 0xE200
;       decoded target is 0xE203; clear byte at 0xE203.
;
; In both cases the node's second cell supplies the previous trail node.  The
; target payload is decoded before its tag is overwritten.
.untrail_next_binding:
    ; Pointer equality with the saved boundary terminates rollback; no tag
    ; sentinel is needed between a choice frame and its descendants.
    push hl
    or a
    sbc hl,de
    pop hl
    jr z,.restore_choice_snapshot
    ; Preserve the node address while decoding cell 0 into a target address.
    ld a,(hl)
    push hl
    push af
    call term_load_payload_hl
    pop af
    ; END is the permanent empty trail.  REFERENCE_NEXT_CELL requires one extra
    ; cell step before reaching the variable that was bound.
    ; END is tolerated as a non-target marker.  The two real target encodings
    ; differ only in whether the payload already names the exact variable cell.
    cp TERM_TAG_END
    jr z,.untrail_follow_previous_node
    cp TERM_TAG_REFERENCE_NEXT_CELL
    jr nz,.untrail_clear_variable_tag
    ; NEXT_CELL payloads name the even first cell of a heap pair; advance to
    ; the odd second cell that was actually bound.
    inc hl
    inc hl
    inc hl
    ; The old payload need not be restored: tag zero makes it semantically dead.
.untrail_clear_variable_tag:
    ld (hl),TERM_TAG_UNBOUND_VARIABLE
    ; Cell 1 begins exactly TERM_CELL_SIZE bytes after the target descriptor.
.untrail_follow_previous_node:
    pop hl
    inc hl
    inc hl
    inc hl
    ld a,(hl)
    ; A malformed trail link is an internal-corruption condition, not logical
    ; Prolog failure.
    cp TERM_TAG_LIST
    call nz,system_abort
    call term_load_payload_hl
    jr .untrail_next_binding
; All younger bindings are undone.  Restore the six execution words from the
; choice frame and set EXEC_FRAME_TOP to the restored allocation top minus one
; frame, so select_clause_and_allocate_frame can overwrite the failed attempt.
    ; IX points at the failed choice frame throughout; LDIR copies the complete
    ; hot-state image, including the saved trail boundary and prior choice link.
.restore_choice_snapshot:
    push ix
    pop hl
    ; Restore all six words, including the next clause and previous choice link.
    ld de,EXEC_NEXT_CLAUSE
    ld bc,EXEC_FRAME_SIZE
    ldir
    ; The restored allocation top is immediately after the failed frame.  Move
    ; EXEC_FRAME_TOP back one record so the retry can overwrite it in place.
    ld hl,(EXEC_ALLOCATION_TOP)
    ld bc,-EXEC_FRAME_SIZE
    add hl,bc
    ld (EXEC_FRAME_TOP),hl
    ret
; Unify two terms, or two successive cells of a list spine.
;
; In:  HL = left term, normally from the selected clause environment
;      DE = right term, normally from the caller environment
;      B.0/B.1 = provenance flags saying that left/right was reached through a
;                reference; the initial caller supplies B=0
; Out: Z on success, NZ on structural or scalar mismatch
; Side effects: may bind one or more variables and append trail nodes
;
; The routine does not roll back its own partial bindings.  Failure propagates
; to the choice-point path, which calls restore_choice_and_untrail.  Relative
; references are based independently on EXEC_CLAUSE_ENV_BASE and
; EXEC_CALLER_ENV_BASE.  Lists recurse over their head cells and then tail cells;
; floats compare the complete six-byte packed representation.  No occurs-check
; branch is present in this core.
    ; Dereference the left operand first.  Relative references are clause-local
    ; offsets; absolute and next-cell forms may chain arbitrarily.
; ----------------------------------------------------------------------------
; UNIFICATION AS A SMALL SET OF CASES
; ----------------------------------------------------------------------------
;
; Unification repeatedly dereferences both sides and then asks one question:
; what are the two resulting tags?
;
;       variable / anything   bind or link the variable
;       list / list            unify heads, then continue with tails
;       float / float          compare all six representation bytes
;       same atomic tag        compare the 16-bit payload
;       different tags         fail
;
; There is no local undo and no occurs check.  A later mismatch may therefore
; leave earlier bindings installed; the caller converts NZ into choice-point
; rollback.  This is both smaller and faster than making every recursive
; unification step transactional.
;
; Dereference cases used by the unifier
; --------------------------------------
; Before comparing two terms, normalize each side:
;
;       ABSOLUTE_REFERENCE  -> load its address and continue
;       REFERENCE_NEXT_CELL -> advance to the adjacent value cell
;       RELATIVE_REFERENCE  -> environment_base + stored offset
;       anything else       -> stop; this is the current term
;
; The unifier then handles four broad cases:
;
;       variable / anything  -> bind or link, trailing if required
;       list / list           -> unify head, then tail
;       float / float         -> compare all six bytes
;       atomic / atomic       -> tags and payloads must agree
;
; A failed comparison returns nonzero but intentionally leaves mutations for
; the choice-point restoration path to undo.
; ----------------------------------------------------------------------------
; COMPLETE TYPE-DIRECTED UNIFICATION ALGORITHM
; ----------------------------------------------------------------------------
;
; unify_sequence(left, right):
;     repeat for corresponding cells:
;         left,  left_provenance  = dereference(left)
;         right, right_provenance = dereference(right)
;
;         if left and right are the same cell:
;             succeed for this cell
;         else if right is UNBOUND:
;             bind right to left; trail right if old
;         else if left is UNBOUND:
;             bind left to right; trail left if old
;         else if base_tag(left) != base_tag(right):
;             fail
;         else if scalar/atomic:
;             compare complete values; fail if unequal
;         else if LIST:
;             unify(head(left), head(right))
;             unify(tail(left), tail(right))
;         else:
;             apply the tag-specific equality rule
;
;         advance to the next enclosing sequence cell
;     return Z on success, NZ on the first contradiction
;
; Mutations are speculative.  Unification does not undo them on local failure;
; the choice-point rollback path restores trailed cells if search backtracks.
unify_term_sequences:
    ld a,(hl)
    cp TERM_TAG_RELATIVE_REFERENCE
    jr nz,.unify_left_follow_absolute
    ; B.0/B.1 remember that the original operands were reached through a
    ; reference.  Binding uses this to decide whether structural copying is needed.
    set UNIFY_LEFT_WAS_REFERENCED_BIT,b
    ; Convert the stored offset into an address in the selected clause
    ; environment without disturbing the caller-side DE operand.
    call term_load_payload_hl
    push de
    ld de,(EXEC_CLAUSE_ENV_BASE)
    add hl,de
    pop de
.unify_left_reload_tag:
    ld a,(hl)
    ; Absolute references carry the exact target address in their payload.
.unify_left_follow_absolute:
    cp TERM_TAG_ABSOLUTE_REFERENCE
    jr nz,.unify_left_follow_next_cell
    set UNIFY_LEFT_WAS_REFERENCED_BIT,b
    call term_load_payload_hl
    jr .unify_left_reload_tag
    ; NEXT_CELL names the preceding cell and is used for odd second cells in a
    ; six-byte allocation.
.unify_left_follow_next_cell:
    cp TERM_TAG_REFERENCE_NEXT_CELL
    jr nz,.unify_dereference_right
    set UNIFY_LEFT_WAS_REFERENCED_BIT,b
    call term_load_payload_hl
    inc hl
    inc hl
    inc hl
    jr .unify_left_reload_tag
    ; Repeat the same reference normalization for the caller-side term, using
    ; its independent environment base for relative references.
; Provenance bits used in this routine:
;       bit 0  left operand was reached through one or more references
;       bit 1  right operand was reached through one or more references
; They record lifetime/origin risk only; they do not encode success or term type.
.unify_dereference_right:
    ld a,(de)
    cp TERM_TAG_RELATIVE_REFERENCE
    jr nz,.unify_right_follow_absolute
    ; Resolve the caller-side relative reference against its own environment.
    set UNIFY_RIGHT_WAS_REFERENCED_BIT,b
    ex de,hl
    call term_load_payload_hl
    push de
    ld de,(EXEC_CALLER_ENV_BASE)
    add hl,de
    pop de
    ex de,hl
.unify_right_reload_tag:
    ld a,(de)
    ; Keep HL fixed while term_load_payload_de follows the right chain.
.unify_right_follow_absolute:
    cp TERM_TAG_ABSOLUTE_REFERENCE
    jr nz,.unify_right_follow_next_cell
    set UNIFY_RIGHT_WAS_REFERENCED_BIT,b
    call term_load_payload_de
    jr .unify_right_reload_tag
    ; The provenance bit remains set even after several chained references; the
    ; copier later needs only the fact that some reference was crossed.
.unify_right_follow_next_cell:
    cp TERM_TAG_REFERENCE_NEXT_CELL
    jr nz,.unify_right_unbound_case
    set UNIFY_RIGHT_WAS_REFERENCED_BIT,b
    call term_load_payload_de
    inc de
    inc de
    inc de
    jr .unify_right_reload_tag
; A contains the resolved RIGHT tag here.
; If the right side is unbound, either both registers name the same cell (an
; immediate success) or the right variable must be linked/copied to the left
; source.  If the right side is bound, control continues by testing whether the
; left side is the unbound destination.
; Source-level orientation at entry:
;       destination = the dereferenced right cell, known UNBOUND
;       source      = the resolved left term
; The mirror branch later swaps these roles when the left cell is unbound.
.unify_right_unbound_case:
    ; Tag zero is an unbound variable cell.
    ; A still holds the resolved right tag.  Test right-variable first because
    ; it allows the common source=HL, destination=DE convention.
    cp TERM_TAG_UNBOUND_VARIABLE
    jr nz,.unify_test_left_unbound
    ; With A=0, this is also the left-variable test.  Two references to the same
    ; physical cell require no write and therefore no trail entry.
    cp (hl)
    jr nz,.unify_bind_right_to_left
    call compare_hl_de_preserving
    ret z
    ; Copy/link the left source into the right variable.  If the left source was
    ; reached through a reference, resolve that source explicitly before deciding
    ; which variable cell was modified and must be trailed.
; ----------------------------------------------------------------------------
; LINKING VARIABLES WITHOUT DUPLICATING THEM
; ----------------------------------------------------------------------------
;
; Copying an unbound cell would create a second independent variable.  Instead,
; one cell becomes a reference to the other.  The chosen reference form depends
; on where the target lives and whether it is the first or second cell of a
; six-byte heap object.
;
; Address ordering is not cosmetic.  It helps avoid fragile forward links and
; lets the collector reason about object ownership from aligned object bases.
; Before the tag is changed, trail_variable_if_needed decides whether the old
; unbound state must be remembered for a future retry.
;
; A trailed target is known to have been UNBOUND before this operation.  Rollback
; therefore needs to restore only its tag, not preserve an arbitrary old payload.
; This is why callers may perform the binding write immediately before or after
; the trail-age decision without losing semantic state.
.unify_bind_right_to_left:
    bit UNIFY_LEFT_WAS_REFERENCED_BIT,b
    ld bc,(EXEC_CLAUSE_ENV_BASE)
    jr z,.unify_copy_source_to_destination
    push de
    push hl
    call copy_source_resolve_reference
    pop hl
    pop de
    ; Variable-variable linking may choose either endpoint as the cell to mutate.
    ; The endpoint that no longer has tag zero is the one recorded on the trail.
    ld a,(de)
    cp TERM_TAG_UNBOUND_VARIABLE
    jr nz,trail_variable_if_needed
    ex de,hl
    jr trail_variable_if_needed
; The right side is bound.  Test whether LEFT is the unbound destination.
; Exchanging HL and DE establishes the common copier convention:
;     HL = source value, DE = unbound destination.
; If both sides are bound, compare their tags and payloads directly.
    ; A fresh load is necessary because A currently contains the right tag.
; Repeated-variable failure: `same(X,X)` against `same(1,2)`
; ----------------------------------------------------------------
; The stored head contains two RELATIVE 0 cells, both resolving to one fresh X.
; First argument: X is unbound, so it is bound to integer 1 and trailed if old.
; Second argument: dereferencing X now reaches 1; comparing it with 2 returns NZ.
; The failed unifier leaves X bound to 1.  Only restore_choice_and_untrail later
; clears X back to UNBOUND before another clause is tried.
.unify_test_left_unbound:
    ld a,(hl)
    cp TERM_TAG_UNBOUND_VARIABLE
    jr nz,.unify_compare_bound_terms
    ; Swap a bound right source and unbound left destination into copier order.
    ex de,hl
    bit UNIFY_RIGHT_WAS_REFERENCED_BIT,b
    ld bc,(EXEC_CALLER_ENV_BASE)
    jr z,.unify_copy_source_to_destination
    push de
    call copy_source_resolve_reference
    pop de
    jr trail_variable_if_needed
; Bound terms must have identical tags.  END succeeds immediately; floats are
; compared by their six-byte records; list payloads recurse; other scalar terms
; compare their two-byte payloads directly.
    ; Different tags can never unify.  Matching END cells terminate a list spine
    ; without inspecting their ignored payload bytes.
.unify_compare_bound_terms:
    ld a,(de)
    cp (hl)
    ret nz
    cp TERM_TAG_END
    ret z
    ; Floating values are indirect six-byte records, not inline payloads.
    cp TERM_TAG_FLOAT
    jr nz,.unify_compare_payload_or_list
    call term_load_payload_hl
    ex de,hl
    call term_load_payload_hl
    ; Float equality is representation equality over all six packed bytes.
    ld b,006h
.unify_compare_float_byte:
    ld a,(de)
    cp (hl)
    ret nz
    inc hl
    inc de
    djnz .unify_compare_float_byte
    ret
    ; term_load_payload_de leaves Z from the preceding CP intact; Z therefore
    ; still means the matching tag was LIST and selects recursive structure work.
.unify_compare_payload_or_list:
    ; LIST recurses; all remaining matching tags compare their payload pointers
    ; or inline values directly.
    cp TERM_TAG_LIST
    call term_load_payload_hl
    call term_load_payload_de
    jr z,.unify_nested_list_cells
    or a
    sbc hl,de
    ret
; Both terms are list structures.  Preserve the environment-reference flags
; while recursively unifying the current elements, then advance one three-byte
; cell on each side and continue with the list tails.
    ; Save the outer list cursors and provenance mask around recursive head
    ; unification.  Only after success are both cursors advanced to their tails.
; Structural example: `(a b|X)` with `(a b c)`
; ------------------------------------------------
; LIST recursion first compares heads a/a.  It then recurses into tails, compares
; b/b, and reaches X versus `(c)`.  X is unbound, so it is bound to the remaining
; one-element list.  The result is X=(c).  Each nested call returns Z before the
; enclosing sequence advances.
.unify_nested_list_cells:
    push de
    push hl
    push bc
    call unify_term_sequences
    pop bc
    pop hl
    pop de
    ret nz
    inc de
    inc de
    inc de
    inc hl
    inc hl
    inc hl
    jp unify_term_sequences
    ; copy_term_for_binding performs the actual write.  Trail recording follows
    ; it safely because the pre-binding state is always the same zero tag.
; Copying is required only when a surviving older variable would otherwise point
; into temporary clause/local storage which may vanish when the current frame is
; reclaimed.  Scalars and stable heap terms can be referenced directly; an
; environment-dependent structure must be copied into managed heap storage first.
.unify_copy_source_to_destination:
    push de
    call copy_term_for_binding
    pop de
; Record a variable binding on the trail only when rollback cannot discard it.
;
; In:  DE = address of the variable cell whose tag has just been overwritten,
;           or is about to be overwritten by a caller
; Out: Z set; DE restored; no term cell is modified here
; Clobbers: AF, HL; IX is preserved
;
; This routine is deliberately separate from the write that performs a binding.
; A trail entry stores only the variable address because every trailed variable
; was unbound before the write.  Fresh locals above the active choice frame are
; reclaimed with their frame and therefore need no trail record.
; ----------------------------------------------------------------------------
; THE AGE TEST
; ----------------------------------------------------------------------------
;
; Trailing every binding would be correct but wasteful.  A variable younger than
; the current choice point will disappear when the execution or heap frontier
; is rewound, so restoring its tag serves no purpose.  An older variable will
; survive and must be named by a trail node.
;
; Trail nodes are ordinary six-byte managed objects: the first cell identifies
; the variable, the second links to the previous node.  Cut and garbage
; collection can inspect or splice this list using the same tagged-term tools as
; the rest of the interpreter.
;
; Mutation/trailing timeline
; --------------------------
; The helper records an old variable, not the new value.  Both caller orders are
; valid because the original state is always the same UNBOUND cell:
;
;       caller A:  trail_if_old(X) -> write binding into X
;       caller B:  write binding into X -> trail_if_old(X)
;
; Pseudocode:
;
;       if X was allocated after the current choice point:
;           return                    ; rewind will discard it
;       if X is already represented by the current trail head:
;           return                    ; avoid duplicate undo entries
;       push trail node { target: X, previous: trail_head }
;
; Backtracking never needs the previous payload: restoring tag UNBOUND is enough
; because only unbound cells are mutated by the binding paths.
; Trail age-test decision tree
; ----------------------------
; if target is an execution/local cell allocated after choice.LOCAL_BASE:
;     do not trail; frame/frontier rewind removes it
; else if target is an older execution/local cell:
;     trail its fixed absolute address using the execution-target marker
; else if target is the first cell of a heap pair:
;     trail pair base as ABSOLUTE_REFERENCE
; else if target is the second cell of a heap pair:
;     trail pair base as REFERENCE_NEXT_CELL
;
; The trail records only mutations which survive ordinary frontier restoration.
trail_variable_if_needed:
    push de
    push ix
    ; The choice frame's local base separates old variables (must trail) from
    ; fresh clause locals (discarded automatically on backtracking).
    ld ix,(EXEC_CHOICE_FRAME)
    ld l,(ix+EXEC_FRAME_LOCAL_BASE)
    ld h,(ix+EXEC_FRAME_LOCAL_BASE+1)
    pop ix
    or a
    ; Unsigned local-base - target: carry means target is numerically newer/higher.
    sbc hl,de
    jr c,.trail_target_newer_than_choice_local_base
    ; Targets at or below the saved local base belong to an older fixed execution
    ; region and always survive retry; mark them with the trail-only 0x0C form.
    ld a,TRAIL_TARGET_EXECUTION_CELL
    jr .trail_allocate_node
; DE is numerically above the choice frame's local base.  Such a cell may be
; either a fresh local in the current execution arena or a managed-heap cell.
; TERM_HEAP_CURSOR separates the two: addresses below the cursor are discarded
; with the failed frame; addresses at or above it survive and must be trailed.
; Numeric age example
; -------------------
; Assume choice.LOCAL_BASE=0xA000 and TERM_HEAP_CURSOR=0xE000.
;
;       target 0xA012  young execution local -> no trail; rewind removes it
;       target 0x9FF0  old execution local   -> trail fixed address 0x9FF0
;       target 0xE103  heap pair second cell -> trail pair base 0xE100 + NEXT
;
; Execution storage grows upward; heap storage grows downward.  The address
; comparisons below decide which restoration mechanism owns the target.
.trail_target_newer_than_choice_local_base:
    ld hl,(TERM_HEAP_CURSOR)
    ; The initial carry makes the comparison inclusive: carry after SBC means
    ; target >= TERM_HEAP_CURSOR.
    scf
    sbc hl,de
    jr c,.trail_heap_target_choose_reference_form
    ; The target lies between the choice local base and heap cursor: it is a
    ; discardable fresh execution cell, so no trail allocation is required.
    jr .trail_variable_done
; Heap allocations are six-byte pairs aligned to an even address.  Their first
; term cell is therefore even and can be named directly.  The second cell is
; odd; its trail descriptor stores the preceding even object base with the
; REFERENCE_NEXT_CELL tag, and untrailing adds one TERM_CELL_SIZE.
.trail_heap_target_choose_reference_form:
    ; Even heap addresses are pair bases; odd addresses are their second cells.
    bit 0,e
    ld a,TRAIL_TARGET_HEAP_CELL
    jr z,.trail_allocate_node
    ld a,TRAIL_TARGET_HEAP_NEXT_CELL
    ; Store the even pair base, not the odd second-cell address.
    dec de
    dec de
    dec de
; Allocate two cells for a trail node.  The first records a reference to the
; variable being changed; the second is a list-tail link to EXEC_TRAIL_HEAD.
; Publish the new node only after both cells are complete.
    ; Keep A=target tag and DE=encoded target across allocation; the allocator
    ; explicitly saves and restores both registers.
.trail_allocate_node:
    call allocate_two_term_cells
    push hl
    ld (hl),a
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    ; Construct the link only after cell 0 is complete, then publish the new head
    ; as the final write so the collector never sees a half-linked trail.
    ld de,(EXEC_TRAIL_HEAD)
    ; Second cell links the new trail node to the previous head.
    ld (hl),TERM_TAG_LIST
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    pop hl
    ld (EXEC_TRAIL_HEAD),hl
    ; CP A is the compact idiom used throughout the interpreter to return success.
.trail_variable_done:
    pop de
    cp a
    ret
; Copy or link a source term into an unbound destination cell.
;
; In:  HL = source term, DE = destination cell, BC = source environment base
; Out: destination represents the same logical term; Z is preserved as success
; Clobbers: AF, HL, DE internally; BC is preserved across scalar copying
;
; Scalar cells are copied verbatim after reference resolution.  A LIST allocates
; a fresh two-cell pair, writes the destination list pointer first, then copies
; the source head and tail cells recursively.  Relative references are resolved
; against BC so the result never retains a clause-template offset.
    ; LIST is the only recursively copied tag.  Constants, integers, floats and
    ; END cells are scalar three-byte cells; float payloads continue to point at
    ; their separately managed six-byte value object.
; ----------------------------------------------------------------------------
; COPYING ONLY WHEN A REFERENCE WOULD ESCAPE
; ----------------------------------------------------------------------------
;
; Most bindings can point directly at an existing term.  A structured value in
; temporary clause storage is different: if the frame later disappears, a
; surviving older variable must not retain a dangling reference into it.
;
; This copier walks the term graph and materializes the needed structure in
; managed storage.  Literal cells are copied verbatim; lists recurse; unbound
; variables are linked so repeated occurrences remain the same logical
; variable.  It is therefore a graph copy, not a byte copy.
;
; Why copy instead of merely pointing?
; --------------------------------
; Consider binding an old variable X to a temporary list `(a b)` built in the
; current clause's local area.  A direct pointer would become dangling when the
; frame is discarded.  The copier preserves the logical value in managed heap
; storage:
;
;       source locals:       [LIST -> pair(a, pair(b, END))]
;       copy to heap:         [LIST -> new pair/new pair]
;       bind X:               [ABSOLUTE_REFERENCE -> heap copy]
;
; Existing stable heap objects may be shared.  Terms whose cells belong to
; temporary execution storage are recursively copied; repeated variables are
; remapped so sharing inside the copied term is preserved.
; Graph-copy pseudocode and sharing invariant
; ------------------------------------------
; copy(term, source_environment):
;     term = resolve references relative to source_environment
;     if term is scalar:
;         copy one cell
;     if term is LIST:
;         allocate destination pair
;         copy head into first cell
;         copy tail into second cell
;     if term is UNBOUND variable:
;         if this source variable was copied before:
;             reference the same destination representative
;         else:
;             allocate/register one destination variable representative
;
; Invariant: the result contains no pointer into temporary execution storage and
; preserves sharing.  Two occurrences of one source variable remain two
; references to one destination variable, never two independently fresh values.
copy_term_for_binding:
    ld a,(hl)
    cp TERM_TAG_LIST
    jr nz,copy_source_follow_relative_reference
    push hl
    ; Allocate the destination cons pair before descending, making the outer list
    ; cell valid even while the two child cells are still END placeholders.
    call allocate_two_term_cells
    ex de,hl
    ld (hl),TERM_TAG_LIST
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    pop hl
    call term_load_payload_hl
    push de
    push hl
    ; Copy the current head cell; the loop then advances source and destination by
    ; one cell to copy the tail descriptor in the same way.
    call copy_term_for_binding
    pop hl
    pop de
    inc hl
    inc hl
    inc hl
    inc de
    inc de
    inc de
    jr copy_term_for_binding
    ; BC is the source environment base selected by the unifier before entry.
copy_source_follow_relative_reference:
    cp TERM_TAG_RELATIVE_REFERENCE
    jr nz,copy_source_follow_absolute_reference
    call term_load_payload_hl
    add hl,bc
copy_source_resolve_reference:
    ld a,(hl)
    jr copy_source_follow_relative_reference
    ; Absolute and NEXT_CELL chains are normalized until a real source tag appears.
copy_source_follow_absolute_reference:
    cp TERM_TAG_ABSOLUTE_REFERENCE
    jr nz,.copy_source_follow_next_cell_reference
    call term_load_payload_hl
    jr copy_source_resolve_reference
.copy_source_follow_next_cell_reference:
    cp TERM_TAG_REFERENCE_NEXT_CELL
    jr nz,.copy_source_into_destination
    call term_load_payload_hl
    inc hl
    inc hl
    inc hl
    jr copy_source_resolve_reference
; Two unbound variables must become one equivalence class, not two independent
; zero cells.  Address ordering plus execution-arena classification chooses
; which cell receives the reference.  If the referenced endpoint is the odd
; second cell of a six-byte object, encode its even base with NEXT_CELL.
; Non-variable scalar cells are copied verbatim.
    ; Clearing the destination tag before variable-variable orientation ensures
    ; either endpoint is visibly unbound while the reference direction is chosen.
; Sharing trace
; -------------
; Copy source list `(X X)`.  The first X creates destination variable D and adds
; source-X -> D to the copy map.  The second X finds that entry and emits another
; reference to D.  Binding D later changes both printed occurrences together.
.copy_source_into_destination:
    cp TERM_TAG_UNBOUND_VARIABLE
    jr nz,.copy_scalar_cell
    ld (de),a
    ; Put the numerically higher endpoint in HL and lower endpoint in DE.
    call compare_hl_de_preserving
    jr nc,.copy_unbound_choose_reference_orientation
    ex de,hl
.copy_unbound_choose_reference_orientation:
    ; Arena classification decides which endpoint may safely hold the reference
    ; across tail-frame movement and stack rollback.  Heap collection itself does
    ; not move objects.
    call gc_test_dynamic_arena_address
    ld a,TERM_TAG_ABSOLUTE_REFERENCE
    jr nc,.copy_unbound_choose_next_cell_reference
    ex de,hl
    jr .copy_unbound_write_reference
    ; When the chosen target is an odd second cell, back up to the pair base and
    ; use NEXT_CELL so one reference identifies both the reusable object base and
    ; the exact second cell.  This is also the form understood by trail filtering.
.copy_unbound_choose_next_cell_reference:
    bit 0,l
    jr z,.copy_unbound_write_reference
    dec hl
    dec hl
    dec hl
    ld a,TERM_TAG_REFERENCE_NEXT_CELL
    ; Final exchange selects the endpoint to overwrite and leaves DE as payload.
.copy_unbound_write_reference:
    ex de,hl
    ld (hl),a
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    ret
    ; LDIR copies tag and payload together.  BC is saved because it remains the
    ; relative-reference base for subsequent cells in a copied list.
.copy_scalar_cell:
    push bc
    ld bc,TERM_CELL_SIZE
    ldir
    pop bc
    ret
; Follow every reference form understood by the execution engine.
;
; In:  HL = address of a tagged term cell
;      DE = environment base used only by TERM_TAG_RELATIVE_REFERENCE
; Out: HL = first non-reference cell, A = its tag
; Clobbers: AF; DE is preserved
;
; REFERENCE_NEXT_CELL stores the address of the preceding cell in a six-byte
; object and therefore advances exactly one TERM_CELL_SIZE after loading it.
    ; Unlike the two-sided unifier, this helper does not track provenance; it is
    ; used by primitive dispatch and parser/printer paths that need only the value.
term_dereference_hl:
    ld a,(hl)
    cp TERM_TAG_RELATIVE_REFERENCE
    jr nz,.term_dereference_follow_absolute
    call term_load_payload_hl
    add hl,de
.term_dereference_reload_tag:
    ld a,(hl)
.term_dereference_follow_absolute:
    cp TERM_TAG_ABSOLUTE_REFERENCE
    jr nz,.term_dereference_follow_next_cell
    call term_load_payload_hl
    jr .term_dereference_reload_tag
.term_dereference_follow_next_cell:
    cp TERM_TAG_REFERENCE_NEXT_CELL
    ret nz
    call term_load_payload_hl
    inc hl
    inc hl
    inc hl
    jr .term_dereference_reload_tag
; Allocate one six-byte/two-cell term object.
;
; Out: HL = even-aligned object base; DE and AF restored
; Allocation order:
;   1. pop a reusable object from FREE_TERM_OBJECT_HEAD;
;   2. allocate downward from TERM_HEAP_CURSOR while above the execution arena;
;   3. run one garbage collection and retry;
;   4. report No Space if six bytes would cross EXEC_ALLOCATION_TOP.
;
; Both tags are preinitialized to END before return, making an interrupted or
; partially constructed object safe for the collector to scan.
    ; FREE_TERM_OBJECT_HEAD is 0xFFFF when empty.  Reused objects carry the next
    ; free-object pointer in the payload of their first cell.
; ----------------------------------------------------------------------------
; THE UNIVERSAL SIX-BYTE ALLOCATOR
; ----------------------------------------------------------------------------
;
; Lists, trail nodes, copied structures and several primitive results all need
; pairs of term cells.  Allocation first reuses an interior object from the free
; chain.  If that chain is empty, the downward heap frontier is moved by six
; bytes.  A collection is attempted once before reporting No Space.
;
; New objects are initialized with END markers.  Besides making partial
; construction safe, those markers give the collector and error paths a valid
; graph even if a routine aborts between filling the first and second cells.
;
; The two-ended arena and allocation choice
; ---------------------------------------
; Execution records grow upward; six-byte heap objects grow downward:
;
;       execution_top -->       free gap       <-- heap_cursor
;
; Allocation proceeds in this order:
;
;       if free_object_list is nonempty:
;           unlink and reuse one interior six-byte hole
;       else if heap_cursor - 6 stays above execution_top + safety_margin:
;           heap_cursor -= 6
;       else:
;           garbage_collect()
;           retry the same decision
;           fail with "No Space left" if the gap is still too small
;
; The collector never moves live objects, so a reused free-list node and a new
; edge allocation have identical pointer stability.
; The allocator always reserves an observed six-byte safety margin before allowing
; the execution and heap frontiers to approach.  The exact historical rationale
; for choosing one object is not independently proved; treat it as a verified
; allocator invariant, not as a fully recovered design explanation.
allocate_two_term_cells:
    push de
    push af
    ld de,(FREE_TERM_OBJECT_HEAD)
    ld hl,0ffffh
    or a
    sbc hl,de
    jr nz,.allocate_reuse_free_object
    ; If the descending cursor has reached the GC threshold, collect before
    ; committing another six-byte decrement.
    ld hl,(TERM_HEAP_COLLECTION_TRIGGER)
    ld de,(TERM_HEAP_CURSOR)
    or a
    sbc hl,de
    ex de,hl
    jr c,.allocate_from_heap_cursor
    ; Collection may either rebuild the free-object chain or move the heap cursor;
    ; inspect both results before choosing the retry path.
    call garbage_collect
    ld de,(FREE_TERM_OBJECT_HEAD)
    ld hl,0ffffh
    or a
    sbc hl,de
    jr z,.allocate_heap_cursor_after_collection
    ; Pop one object from the intrusive free list while returning its old base.
.allocate_reuse_free_object:
    ex de,hl
    push hl
    call term_load_payload_hl
    ld (FREE_TERM_OBJECT_HEAD),hl
    pop hl
    jr .allocate_initialize_two_cells
.allocate_heap_cursor_after_collection:
    ld hl,(TERM_HEAP_CURSOR)
    ; Heap allocation is downward in exact six-byte units, preserving even
    ; alignment and the first/second-cell parity convention used by NEXT_CELL.
.allocate_from_heap_cursor:
    ld de,-TRAIL_NODE_SIZE
    add hl,de
    ld de,(EXEC_ALLOCATION_TOP)
    push hl
    or a
    sbc hl,de
    pop hl
    ; Crossing EXEC_ALLOCATION_TOP would collide with active frames/locals.
    jp c,no_space_error
    ld (TERM_HEAP_CURSOR),hl
    ; Only tags are initialized; callers immediately overwrite the payloads they
    ; own.  END makes those payloads irrelevant until construction is complete.
.allocate_initialize_two_cells:
    ; Initialize both cells to END so a partially constructed object is always
    ; safe for the collector to inspect.
    ld (hl),TERM_TAG_END
    inc hl
    inc hl
    inc hl
    ld (hl),TERM_TAG_END
    dec hl
    dec hl
    dec hl
    pop af
    pop de
    ret
; Load the 16-bit payload of the cell addressed by DE, preserving HL.
; In: DE = tagged cell address
; Out: DE = payload, HL preserved
term_load_payload_de:
    ex de,hl
    call term_load_payload_hl
    ex de,hl
    ret
; Compare unsigned HL with DE without changing either register pair.
; Returns the flags from HL-DE; callers use C/Z for arena and frame ordering.
compare_hl_de_preserving:
    push hl
    or a
    sbc hl,de
    pop hl
    ret
; Generic primitive-relation argument dispatcher.
;
; IX addresses a compact state table.  For every argument the resolved term tag
; selects one of four transition bytes; the transition advances IX to the next
; state.  When TERM_TAG_END is reached, byte 0 is interpreted as a relative jump
; to the primitive implementation.  A transition value of 0xFF rejects the call.
; Interpret a compact five-byte-per-state primitive signature.  IX names the
; current state, the argument stream is dereferenced one term at a time, and
; six-byte scratch slots retain both values and writable output destinations.
; On handler return, successful output slots are committed and trailed using
; the same mutation rules as ordinary unification.
; ----------------------------------------------------------------------------
; A TINY INTERPRETER INSIDE THE INTERPRETER
; ----------------------------------------------------------------------------
;
; Native relations are often multi-modal: SUM can check three known values or
; solve for any one unknown; PNT can draw or return screen information; OPEN and
; CLOSE demand particular object kinds.  Encoding all combinations as Z80
; branches in every primitive would dominate the resident image.
;
; Instead, IX points at a five-byte dispatch state.  The dereferenced argument
; class chooses one relative transition byte, and primitive-specific code runs
; only after the state machine reaches a completion address.  The six-byte
; scratch records preserve each argument's tag, address and environment facts
; for that completion routine.
;
; Decoding a five-byte primitive state
; -----------------------------------
; Each state stores one completion displacement and four transitions selected
; by the next argument's normalized kind:
;
;       byte 0  completion/handler jump
;       byte 1  numeric term transition
;       byte 2  constant transition
;       byte 3  other bound term transition
;       byte 4  unbound variable transition
;
; Example: NUM X
;
;       X is an integer or float -> transition to success state
;       X is any other bound term -> transition to failure state
;       X is unbound              -> transition to failure state
;       end of argument list      -> execute the state's completion byte
;
; Later modules express these bytes as label differences, so reading a dispatch
; table is equivalent to reading a tiny deterministic type automaton.
; Delayed-output trace: `SUM X 2 5`
; ----------------------------------
; 1. State table sees argument 1 as UNBOUND and records X's destination address.
; 2. Arguments 2 and 5 dereference as numeric values and select the reverse-SUM
;    terminal mode "solve first operand".
; 3. The arithmetic handler computes 5-2=3 and writes INTEGER 3 to the pending
;    result half of X's six-byte scratch slot.  X itself is still UNBOUND.
; 4. Handler returns Z.  Only now does the common commit pass bind X to 3 and
;    trail X when its age requires it.
; 5. If classification or arithmetic had returned NZ, commit would be skipped and
;    X would remain untouched.  Scratch slots make primitive failure atomic.
primitive_argument_dispatch:
    ld de,00006h
    ld b,008h
    ld hl,09807h
; Clear all eight six-byte argument slots to the rejected/unset marker.
.dispatch_initialize_argument_slots:
    ld (hl),0ffh
    add hl,de
    djnz .dispatch_initialize_argument_slots
    push ix
    ld ix,(EXEC_CURRENT_FRAME)
    exx
    ld e,(ix+EXEC_FRAME_LOCAL_BASE)
    ld d,(ix+EXEC_FRAME_LOCAL_BASE+1)
    ld (EXEC_CALLER_ENV_BASE),de
    ld ix,09807h
    ld (PRIMITIVE_DISPATCH_SLOT_CURSOR),ix
    pop ix
; Dereference the next call argument and select a transition by term class.
.dispatch_scan_next_argument:
    ld hl,(EXEC_CALL_ARGUMENTS)
    call term_dereference_hl
    cp 010h
    jr nz,.dispatch_decode_argument_list
    ld a,(ix+000h)
    cp 0ffh
    jp z,.dispatch_validate_terminal_state
    ld e,a
    ld d,000h
    ld hl,.dispatch_commit_output_arguments
    push hl
    push ix
    pop hl
    add hl,de
    jp (hl)
; Commit recorded output bindings only after the primitive handler succeeds.
; Commit invariant: until the handler has returned Z, every original output
; variable remains unchanged.  Pending results are private scratch values.  On
; NZ the common path discards them and performs ordinary logical failure.
.dispatch_commit_output_arguments:
    ret nz
    ld de,00006h
    exx
    ld b,008h
    ld ix,09807h
; Walk each populated result slot and bind its original unbound destination.
.dispatch_commit_slot_loop:
    ld a,(ix+000h)
    cp 0ffh
    jr z,.dispatch_advance_commit_slot
    ld e,(ix+001h)
    ld d,(ix+EXEC_FRAME_CALLER)
    ld l,(ix+EXEC_FRAME_CALLER+1)
    ld h,(ix+EXEC_FRAME_CALLER_GOALS)
    cp 000h
    jr z,.dispatch_advance_commit_slot
    ld a,(hl)
    cp 000h
    jp nz,signal_control_error
    ld a,(ix+000h)
    ld (hl),a
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    dec hl
    dec hl
    ex de,hl
    call trail_variable_if_needed
.dispatch_advance_commit_slot:
    exx
    add ix,de
    exx
    djnz .dispatch_commit_slot_loop
    ret
; Require a proper call-argument list before recording the next slot.
.dispatch_decode_argument_list:
    cp 003h
    jp nz,signal_control_error
    call term_load_payload_hl
    inc hl
    inc hl
    inc hl
    ld (EXEC_CALL_ARGUMENTS),hl
    dec hl
    dec hl
    dec hl
    call term_dereference_hl
    ld b,a
    cp 000h
    jr nz,.dispatch_classify_bound_argument
    ld a,(ix+EXEC_FRAME_CALLER_GOALS)
    cp 0ffh
    jp z,signal_control_error
    push ix
    ld ix,(PRIMITIVE_DISPATCH_SLOT_CURSOR)
    ld (ix+000h),000h
    ld (ix+001h),l
    ld (ix+EXEC_FRAME_CALLER),h
    pop ix
; Store resolved value, original destination and selected transition state.
; Local six-byte scratch-slot view
; --------------------------------
;       +0 classification/state byte
;       +1..+2 original output destination (when argument was unbound)
;       +3 result/value tag
;       +4..+5 result/value payload
; The IX offset aliases resemble frame offsets only because both records are six
; or twelve-byte packed structures; this slot is not an execution frame.
.dispatch_record_argument_state:
    push ix
    ld ix,(PRIMITIVE_DISPATCH_SLOT_CURSOR)
    ld (ix+EXEC_FRAME_CALLER+1),l
    ld (ix+EXEC_FRAME_CALLER_GOALS),h
    ld (ix+EXEC_FRAME_CALLER_GOALS+1),b
    ld c,a
    ld b,000h
    exx
    add ix,de
    ld (PRIMITIVE_DISPATCH_SLOT_CURSOR),ix
    pop ix
    exx
    add ix,bc
    jp .dispatch_scan_next_argument
.dispatch_classify_bound_argument:
    cp 00ah
    jr z,.dispatch_follow_numeric_transition
    cp 004h
    jr nz,.dispatch_test_constant_argument
.dispatch_follow_numeric_transition:
    ld a,(ix+001h)
    cp 0ffh
    jr z,.dispatch_validate_terminal_state
    jr .dispatch_follow_selected_transition
.dispatch_test_constant_argument:
    cp 008h
    jr nz,.dispatch_test_list_or_end_argument
    ld a,(ix+EXEC_FRAME_CALLER)
    cp 0ffh
    jr z,.dispatch_validate_terminal_state
.dispatch_follow_selected_transition:
    push af
    call term_load_payload_hl
    pop af
    jr .dispatch_record_argument_state
.dispatch_test_list_or_end_argument:
    cp 010h
    jr z,.dispatch_follow_other_bound_transition
    cp 003h
    call nz,system_abort
.dispatch_follow_other_bound_transition:
    ld a,(ix+EXEC_FRAME_CALLER+1)
    cp 0ffh
    jr nz,.dispatch_record_argument_state
; A terminal state is valid only when its reject vector has the expected shape.
; Reject example
; --------------
; Calling `(SUM apple 2 X)` reaches a DISPATCH_REJECT transition because `apple`
; is neither numeric nor an allowed unbound operand in that state.  This is a
; malformed logical call, so the dispatcher returns failure/control error before
; the arithmetic handler runs; it is not arithmetic overflow or a file error.
.dispatch_validate_terminal_state:
    push ix
    pop hl
    ld b,004h
    ld a,0ffh
.dispatch_validate_reject_vector:
    cp (hl)
    ret nz
    inc hl
    djnz .dispatch_validate_reject_vector
    cp (hl)
    jp nz,signal_control_error
    or a
    ret
; Mark-and-collect garbage collector for the shared evaluation area.
;
; The execution stack grows upward from EXEC_ALLOCATION_TOP.  Six-byte heap
; objects grow downward from TERM_HEAP_CURSOR.  Objects never move during this
; collector: reachable objects receive bit 7 in their tag, unreachable interior
; objects are threaded into FREE_TERM_OBJECT_HEAD, and unreachable objects at
; the low heap edge are removed by advancing TERM_HEAP_CURSOR.  Consequently no
; forwarding table or general pointer-rewrite phase exists.
;
; Collection phases:
;   1. mark local variables in every physically allocated frame;
;   2. mark fixed interpreter, module/dictionary and primitive-dispatch roots;
;   3. remove dead trail nodes and mark the retained trail objects;
;   4. repair each frame's saved-trail boundary after trail filtering;
;   5. prune unreferenced constants from dictionary lists;
;   6. trim the heap edge, sweep interior objects and rebuild the free list;
;   7. recompute free bytes and the adaptive next-collection trigger.
;
; Physical frame traversal uses field +10: the previous physical frame is
; (local-base - EXEC_FRAME_SIZE), independently of the logical caller link.
