; -----------------------------------------------------------------------------
; Architectural module: 01_boot_and_executor.asm
; Image origin, cold start, supervisor restart, goal execution, and error routing.
; Original monolithic line range: 376-980.
; Emitted address range: 0x6000-0x6311.
; -----------------------------------------------------------------------------

; ============================================================================
; CHAPTER 1 — FROM POWER-ON TO THE NEXT PROLOG GOAL
; ============================================================================
;
; The interpreter loop is small because most of its state is represented as
; ordinary tagged terms.  A goal is a list, its first element denotes a
; predicate, and the rest is the argument sequence.  A predicate's canonical
; dictionary value says whether the call enters native Z80 or a list of user
; clauses.
;
; Keep one picture in mind while reading this module:
;
;       choose clause -> unify head -> execute body -> return or fail
;              ^                                      |
;              +----------- restore choice -----------+
;
; Success advances through goal-list tails.  Failure restores a saved frame and
; trail boundary.  Errors are different again: they abandon logical execution
; and return to the protected supervisor stack.
;
    org     06000h

; Root list cell for the built-in system dictionary.  Dictionary lookup at
; 0x79EF starts here and follows the linked constant entries beginning with NUM.
; The first four bytes of the image
; -----------------------------
; Address order begins with data, not the callable entry point:
;
;       0x6000  system_dictionary_root   three-byte LIST cell
;       0x6003  interpreter_entry        first executable instruction
;
; BASIC enters at cold_start near the end of the image.  Cold start initializes
; workspace and then jumps here.  The root cell at 0x6000 remains permanently
; addressable and is never executed.
system_dictionary_root:
    defb TERM_TAG_LIST
    defw num_constant_entry

; Cold/restart entry.  It installs a synthetic error continuation on the Z80
; stack, initializes the memory arenas and static supervisor objects, then
; enters the same supervisor execution path used after ABORT and fatal errors.
; The deliberately invalid initial SP is replaced immediately after the saved
; error continuation has been established.
; ----------------------------------------------------------------------------
; BUILDING A SAFE PLACE TO FAIL
; ----------------------------------------------------------------------------
;
; The first useful act is not clearing memory; it is creating a machine-stack
; recovery point.  Spectrum ROM errors and interpreter errors may arrive from
; deep inside parser, printer or primitive code.  By saving one known SP here,
; the system can discard any intervening native CALL frames and restart the
; supervisor without trying to unwind them individually.
;
; The apparent initial SP of 0xFFFF is therefore only scaffolding.  Once the
; synthetic continuation has been pushed, SUPERVISOR_MACHINE_STACK and ERR_SP
; become the trusted return boundary for the whole resident system.
;
interpreter_entry:
    ld sp,0ffffh
    nop
    ld hl,signal_rom_error_plus_three
    push hl
    ld (SUPERVISOR_MACHINE_STACK),sp
    ld (SYSVAR_ERR_SP),sp
    ld hl,0ffffh
    ld (FREE_TERM_OBJECT_HEAD),hl
    call initialize_runtime_workspace
    ld hl,(DICTIONARY_NAME_POOL_BASE_PTR)
    inc hl
    ld (hl),0ffh
    inc hl
    ld (hl),0ffh
; Reset the logical execution registers to the built-in <SUP> program.
; EXEC_NEXT_CLAUSE points at its clause chain, EXEC_CURRENT_GOALS at the initial
; supervisor body, and EXEC_TRAIL_HEAD at the permanent empty-list marker.  A
; root frame is then allocated and made its own caller/choice sentinel.
; ----------------------------------------------------------------------------
; THE ROOT CALL IS AN ORDINARY CALL
; ----------------------------------------------------------------------------
;
; There is no separate top-level evaluator hidden in BASIC.  The permanent
; relation <SUP> is compiled in exactly the same representation as a user
; relation, and restart enters it through the ordinary clause selector.
;
; The root frame points its caller and previous-choice links back to itself.
; Those self-links are sentinels: successful unwinding and failed-choice search
; both stop naturally without another special record type.
;
; What is being selected here?
; ----------------------------
; The permanent supervisor relation is equivalent to this source clause:
;
;       ((<SUP>)
;           (CMOD Module)
;           (P Module)
;           (R Input)
;           (<> Input)
;           (/)
;           (<SUP>))
;
; Its compiled relation value is a normal clause list.  Restart installs that
; relation and lets the ordinary selector build a frame, exactly as it would
; for a user relation.  Module 10 shows the complete tagged graph.
; Post-selection supervisor state
; -------------------------------
; supervisor_restart asks the ordinary clause selector to enter the permanent
; `<SUP>` relation.  Immediately after selection the hot state is conceptually:
;
;       EXEC_CURRENT_FRAME   = newly allocated root/supervisor frame
;       EXEC_CURRENT_GOALS   = first body goal of the selected <SUP> clause
;       EXEC_SELECTED_BODY   = same body stream while entry is completed
;       EXEC_CHOICE_FRAME    = previous choice, unless <SUP> had an alternative
;       EXEC_TRAIL_HEAD      = permanent_empty_list
;       EXEC_FRAME_TOP       = end of the new frame
;
; From this point the supervisor is not a special native loop.  It is an
; ordinary compiled micro-PROLOG clause driven by the evaluator below.
supervisor_restart:
    ld hl,supervisor_main_value_cell
    ld (EXEC_NEXT_CLAUSE),hl
    ld hl,supervisor_main_goal_stream
    ld (EXEC_CURRENT_GOALS),hl
    ld hl,permanent_empty_list
    ld (EXEC_TRAIL_HEAD),hl
    ; Start the root frame at the execution arena base established by cold start.
    ld hl,(EXEC_ARENA_LIMIT)
    ld (EXEC_ALLOCATION_TOP),hl
    call select_clause_and_allocate_frame
    ld hl,(EXEC_FRAME_TOP)
    ld ix,(EXEC_FRAME_TOP)
    ; The root's caller and previous-choice links point to itself, providing
    ; sentinels for both normal return and failure unwinding.
    ld (EXEC_ROOT_FRAME),hl
    ld (EXEC_CURRENT_FRAME),hl
    ld (EXEC_CHOICE_FRAME),hl
    ld (ix+EXEC_FRAME_CALLER),l
    ld (ix+EXEC_FRAME_CALLER+1),h
    ld (ix+EXEC_FRAME_PREVIOUS_CHOICE),l
    ld (ix+EXEC_FRAME_PREVIOUS_CHOICE+1),h
; Execute the first goal in EXEC_CURRENT_GOALS.
;
; EXEC_CURRENT_FRAME supplies the caller environment used to resolve relative
; variable references.  Parsed predicate constants already point directly at
; their dictionary value cells, so normal execution performs no textual relation
; lookup: INTEGER(value) dispatches a native primitive and LIST(value) supplies
; the proper list of compiled user clauses.  Primitive and unifier success is Z;
; NZ is logical Prolog failure and enters the common choice-point rollback path.
;
; Accepted goal forms are:
;   LIST -> atom sequence    ordinary call with predicate plus arguments
;   CONSTANT                zero-argument call (principally native predicates)
; Meta-variable calls have already been dereferenced before this shape test.
; ----------------------------------------------------------------------------
; READING A GOAL WITHOUT READING ITS NAME
; ----------------------------------------------------------------------------
;
; By the time execution reaches this point, textual lookup is over.  The parser
; has interned every predicate constant, so its payload points at a mutable
; dictionary value cell.  The tag of that value is the dispatch decision:
;
;       INTEGER   payload is a native Z80 handler address
;       LIST      payload is a proper list of compiled clauses
;       anything else has no executable definition
;
; This indirection is what lets ADDCL, KILL, modules and garbage collection
; alter a relation while existing compiled terms continue to refer to the same
; canonical constant.
;
; ----------------------------------------------------------------------------
; THE EVALUATOR IN LANGUAGE-LEVEL PSEUDOCODE
; ----------------------------------------------------------------------------
;
; repeat:
;     goal = first(EXEC_CURRENT_GOALS)
;     predicate, arguments = decode_atom(goal)
;
;     if predicate.value is a native handler address:
;         prepare primitive argument slots
;         success = call handler(arguments)
;         if success:
;             commit delayed output bindings
;     else:
;         success = select_clause(predicate.relation_list)
;         if success:
;             success = unify(arguments, selected_head_arguments)
;         if success:
;             install selected clause body as current goals
;
;     if success:
;         if current clause/body has another goal:
;             advance to that goal
;         else:
;             return through completed frames until work remains
;     else:
;         restore newest choice point, untrail, and retry its saved clause tail
;
; This is the map for the rest of modules 01 and 02.  The assembly is compact
; because each phase communicates through the six hot EXEC_* words rather than
; through a large native call stack.
.execute_current_goal:
    ld ix,(EXEC_CURRENT_FRAME)
    ; Cache the frame's environment base because the dereferencer accepts it in
    ; DE and primitive dispatch reuses the same side-specific workspace field.
    ld e,(ix+EXEC_FRAME_LOCAL_BASE)
    ld d,(ix+EXEC_FRAME_LOCAL_BASE+1)
    ld (EXEC_CALLER_ENV_BASE),de
    ; Poll BREAK/STOP handling before every logical goal.
    call console_service_break_and_typeahead
    ld hl,(EXEC_CURRENT_GOALS)
    ld a,(hl)
    ; A goal stream must be a list; anything else is a malformed call.
    cp TERM_TAG_LIST
    jp nz,signal_control_error
    call term_load_payload_hl
    call term_dereference_hl
    ; A list-valued head is an ordinary atom.  A bare constant is accepted as
    ; a zero-argument primitive/relation call.
    cp TERM_TAG_LIST
    jr z,.decode_user_or_builtin_call
    cp TERM_TAG_CONSTANT
    jp nz,signal_control_error
    call term_load_payload_hl
    ld a,(hl)
    cp TERM_TAG_INTEGER
    jp nz,signal_control_error
    ; Bare predicate constants receive the permanent empty argument list.
    ld bc,permanent_empty_list
    ld (EXEC_CALL_ARGUMENTS),bc
    jr .invoke_builtin_handler
; Decode an atom represented as a list spine.
;
; The payload of the outer LIST is the predicate term at stream+0; stream+3 is
; the first argument (or END).  EXEC_CALL_ARGUMENTS deliberately retains that
; tail cell, which lets the generic primitive dispatcher consume arguments and
; lets the user-clause path unify it directly with the selected head tail.
;
; A CONSTANT term payload is not the printed name.  It is the address of the
; constant's mutable dictionary value cell.  INTEGER(value) contains a native
; handler address; LIST(value) is the root of the relation's clause list.
; Atom cell diagram: `(P a b)`
; ---------------------------
;
;       outer goal-list cell
;           LIST -> atom cell
;           tail -> remaining goals
;
;       atom cell / list pair
;           head -> constant P
;           tail -> argument list
;                       head -> constant a
;                       tail -> list cell
;                                   head -> constant b
;                                   tail -> END
;
; The evaluator first separates the outer goal-list node from the atom.  It then
; separates the predicate constant from the argument-list tail.  Confusing these
; four layers is a common source of mistakes when reading the pointer loads.
.decode_user_or_builtin_call:
    call term_load_payload_hl  ;6097: HL = predicate cell at atom stream+0
    inc hl
    inc hl
    inc hl                     ;609c: first-argument/tail cell
    ld (EXEC_CALL_ARGUMENTS),hl
    dec hl
    dec hl
    dec hl                     ;60a2: return to predicate cell for dereference
    call term_dereference_hl
    cp TERM_TAG_CONSTANT
    jp nz,signal_control_error
    call term_load_payload_hl
    ; Dictionary values are tagged terms: INTEGER means native handler; LIST
    ; means the head of a user relation's clause chain.
    ld a,(hl)
    cp TERM_TAG_INTEGER
    jr nz,.dispatch_user_relation
; Invoke a primitive through the handler address stored in its integer value
; cell.  This is a synthetic CALL because Z80 has no CALL (HL):
;
;   push caller environment base
;   push .builtin_handler_return
;   load native address from INTEGER payload
;   JP (HL)
;
; A normal RET in the primitive therefore reaches .builtin_handler_return, which
; pops the preserved environment base.  Primitive handlers signal success/fail
; only through Z/NZ; interpreter errors jump to signal_interpreter_error instead.
; ----------------------------------------------------------------------------
; A CALL THROUGH HL, BUILT FROM THE STACK
; ----------------------------------------------------------------------------
;
; Z80 has JP (HL) but no CALL (HL).  The interpreter manufactures the missing
; instruction by pushing its own continuation and then jumping.  The primitive
; eventually executes RET and arrives at .builtin_handler_return as though a
; real indirect call had existed.
;
; DE, the caller environment base, is pushed below that continuation.  This is
; not merely register preservation: after the native predicate succeeds, the
; interpreter still needs the same environment to dereference the remaining
; caller goals.
;
; Primitive example: `(NUM 7)`
; ---------------------------
; 1. EXEC_CALL_ARGUMENTS is set to the one-element argument tail `(7)`.
; 2. primitive_argument_dispatch dereferences 7, classifies it as numeric, and
;    follows NUM's state-table transition to its terminal state.
; 3. The handler is reached indirectly through the integer stored in NUM's
;    canonical value cell.
; 4. NUM returns Z because 7 is numeric.  There is no delayed output to commit.
; 5. builtin_handler_return advances to the next caller goal or begins return.
.invoke_builtin_handler:
    push de
    ld de,.builtin_handler_return
    push de
    call term_load_payload_hl
    jp (hl)
; Common primitive return.  NZ means logical failure, not a machine error.
; On success, advance from the current goal-list pair to its tail and dereference
; that tail in the caller environment.  LIST continues in the same frame.  END
; starts success popping: completed continuations are followed until a caller
; still has another goal, while live choice frames remain physically allocated.
; Native-handler contract
; -----------------------
; Every primitive returns Z for logical success and NZ for logical failure.
; A handler may fill pending result cells, but it must not advance
; EXEC_CURRENT_GOALS itself.  The common return path commits successful outputs
; and performs the same goal advance/return logic used after user clauses.
.builtin_handler_return:
    pop de
    jp nz,.backtrack_to_latest_choice
    ld hl,(EXEC_CURRENT_GOALS)
    call term_load_payload_hl
    inc hl
    inc hl
    inc hl
    call term_dereference_hl
    ld (EXEC_CURRENT_GOALS),hl
    ; The tail cell is already dereferenced.  END means this frame has no more
    ; goals; otherwise it must be another list cell.
    cp TERM_TAG_END
    ld bc,(EXEC_CURRENT_FRAME)
    ld ix,(EXEC_CURRENT_FRAME)
    jr .resume_caller_or_unwind
; Enter a user-defined relation.  HL still points at the dictionary value cell,
; not merely its payload.  A LIST tag therefore acts as the root relation cursor
; accepted by select_clause_and_allocate_frame.  Any other non-INTEGER value
; means the constant has no executable clauses and raises documented error 2.
; ----------------------------------------------------------------------------
; USER CODE BEGINS AS A CLAUSE CURSOR
; ----------------------------------------------------------------------------
;
; A relation value does not point straight at one clause.  It is the head of a
; proper list whose elements are clause pairs.  EXEC_NEXT_CLAUSE is deliberately
; allowed to contain either the relation root or a retained list tail.  The
; clause selector therefore serves both first entry and retry after failure.
;
; A failed candidate leaves any speculative bindings in place.  The common
; backtracking path will restore the trail before asking the selector for the
; next list element.  Keeping rollback out of the unifier makes both components
; simpler.
;
; Complete fact trace: Parent
; ---------------------------
; Program fact: `((Parent Mary John))`
; Query goal:  `(Parent Mary X)`
;
; 1. The predicate constant in the goal already resolves to Parent's canonical
;    value cell, whose value points to a one-clause proper relation list.
; 2. select_clause_and_allocate_frame enters the sole clause.  This assertion
;    needs no clause locals; the query's X remains in its caller environment.
; 3. The stored head arguments `(Mary John)` are unified with call arguments
;    `(Mary X)`.  Mary compares equal; X is bound to the canonical John term.
; 4. The assertion body is END, so no child goal is installed.
; 5. Return restores the caller's remaining goals and frame.
; 6. Dereferencing query variable X now reaches John.  If a later caller goal
;    fails, the binding is undone only if the relevant choice point requires it.
.dispatch_user_relation:
    cp TERM_TAG_LIST
    jp nz,signal_no_clauses_error
    ld (EXEC_NEXT_CLAUSE),hl
; Select the next clause candidate and create its execution frame.
;
; On an initial call EXEC_NEXT_CLAUSE is the relation value cell; on retry it is
; the saved proper-list tail from the failed frame.  Selector NZ is therefore
; ordinary exhaustion: the already-restored EXEC_CHOICE_FRAME names the next
; older decision.  Selector Z publishes fresh locals, selected head/body and a
; frame snapshot, after which caller and clause environments are set separately
; for two-sided relative-reference dereferencing during head unification.
.try_next_relation_clause:
    call select_clause_and_allocate_frame
    jp nz,.backtrack_to_latest_choice
    ld ix,(EXEC_CURRENT_FRAME) ;60e9: caller frame remains current until match
    ld e,(ix+EXEC_FRAME_LOCAL_BASE)
    ld d,(ix+EXEC_FRAME_LOCAL_BASE+1)
    ld (EXEC_CALLER_ENV_BASE),de ;60f3: right-hand relative-reference base
    ld hl,(EXEC_CURRENT_GOALS)
    call term_load_payload_hl
    call term_dereference_hl
    call term_load_payload_hl
    inc hl
    inc hl
    inc hl
; Match the selected clause head against the current call.
;
; HL is advanced past the selected predicate name, leaving the clause argument
; sequence.  DE receives the caller's argument sequence.  The unifier treats HL
; as the left/clause side (EXEC_CLAUSE_ENV_BASE) and DE as the right/caller side
; (EXEC_CALLER_ENV_BASE).  Partial bindings are intentionally left in place on
; NZ; .backtrack_to_latest_choice performs the exact untrail before retry.
;
; On Z, END at EXEC_SELECTED_BODY identifies an assertion.  LIST identifies a
; rule body which becomes the new goal stream and may trigger deterministic
; tail-frame relocation.
; ----------------------------------------------------------------------------
; TWO ENVIRONMENTS MEET AT THE CLAUSE HEAD
; ----------------------------------------------------------------------------
;
; Relative references in the stored clause belong to the new clause's local
; array.  Relative references in the call belong to its caller.  The unifier is
; therefore given two environment bases, one per side, rather than temporarily
; rewriting either term graph.
;
; If head unification succeeds, the selected body becomes the current goal
; stream.  If the body is END, the clause is a fact and return begins
; immediately.  If the call is in tail position, the following relocation code
; may recycle its caller frame instead of retaining another continuation.
;
; Forward reference: unification
; ------------------------------
; The executor has now chosen a stored clause and must match its head against
; the current call.  Treat unify_term_sequences as a black box on first reading:
;
;       success -> variables may be bound; enter the clause body
;       failure -> leave speculative bindings on the trail; backtrack
;
; Module 02 immediately follows with the term representations, variable cases,
; trail policy, and live examples needed to understand the implementation.
; The following call deliberately treats unification as a black box.  Module 02
; expands it into a type-directed equation solver, including reference following,
; variable orientation, structural recursion, copying, trailing and failure.
unify_call_with_selected_head:
    ex de,hl
    ld hl,(EXEC_SELECTED_HEAD)
    ld b,000h
    call unify_term_sequences
    jp nz,.backtrack_to_latest_choice
    ld hl,(EXEC_SELECTED_BODY)
    ld de,(EXEC_CLAUSE_ENV_BASE)
    call term_dereference_hl
    cp TERM_TAG_END
    jr nz,.enter_selected_clause_body
    ; A fact body is empty.  Begin returning at the newest physical frame.
    ld ix,(EXEC_FRAME_TOP)
; Success-pop a completed call.
;
; Begin at the newest physical frame because deterministic callee frames may sit
; above the logical current frame.  From each record recover the caller's saved
; goal pair, move to its tail, then switch IX through the logical caller link.
; Repeated END tails collapse several deterministic returns in one pass.  The
; logical caller field (+2) and physical adjacency are intentionally distinct.
; Return/unwind pseudocode
; ------------------------
; while selected_body == END:
;     if current_frame == root_frame:
;         supervisor iteration is complete
;         return to supervisor restart/outer control
;     restore caller_frame and caller_remaining_goals from current frame
;     reclaim completed execution-frame/local storage
;     if caller_remaining_goals != END:
;         execute its first goal
;     otherwise continue unwinding the caller
.unwind_completed_frame:
    ; Recover the caller's goal-list cell and advance to the goal after the call.
    ld l,(ix+EXEC_FRAME_CALLER_GOALS)
    ld h,(ix+EXEC_FRAME_CALLER_GOALS+1)
    call term_load_payload_hl
    inc hl
    inc hl
    inc hl
    ; Switch from physical frame traversal to the saved logical caller link.
    ld c,(ix+EXEC_FRAME_CALLER)
    ld b,(ix+EXEC_FRAME_CALLER+1)
    push bc
    pop ix
    ld e,(ix+EXEC_FRAME_LOCAL_BASE)
    ld d,(ix+EXEC_FRAME_LOCAL_BASE+1)
    call term_dereference_hl
    cp TERM_TAG_END
; Resume a non-empty caller goal stream.
;
; BC identifies the logical caller and HL its next goal-list cell.  Physical
; arena reclamation may stop at a newer surviving choice frame, even when that
; frame's logical call has already returned, because backtracking still needs
; its retry cursor, saved trail boundary and caller continuation.
; Three completion cases
; ----------------------
;   body has another goal   -> make that goal current inside the same frame
;   body is END, caller has goals -> restore caller and execute its next goal
;   body is END at root     -> one top-level supervisor/query iteration is done
;
; The code below interleaves these tests to save bytes; this table is the logical
; decision order.
.resume_caller_or_unwind:
    jr z,.unwind_completed_frame
    cp TERM_TAG_LIST
    jp nz,signal_control_error
    ld d,b
    ld e,c
    ld (EXEC_CURRENT_FRAME),de
    ld (EXEC_CURRENT_GOALS),hl
    ; A choice frame must remain allocated even after its logical call returns.
    ld hl,(EXEC_CHOICE_FRAME)
    call compare_hl_de_preserving
    jr nc,.reclaim_completed_frames
    ex de,hl
; Set EXEC_FRAME_TOP to the lower of the resumed caller frame and the newest
; live choice frame.  EXEC_ALLOCATION_TOP follows immediately after that
; 12-byte record, releasing locals and continuations that cannot be revisited.
; This rewind moves only the upward-growing execution/local frontier back to the
; surviving caller.  It cannot remove downward-growing heap objects, and it
; cannot remove locals belonging to an older surviving frame.  Heap reclamation
; is the collector's job; old-variable mutation is the trail's job.
.reclaim_completed_frames:
    ld (EXEC_FRAME_TOP),hl
    ld de,0000ch
    add hl,de
    ld (EXEC_ALLOCATION_TOP),hl
    jp .execute_current_goal
; Install a rule body.  The first part detects a tail-position call whose
; caller frame is the frame just allocated and for which no younger choice point
; must survive.  In that safe case the callee locals/frame are relocated over
; the caller frame, avoiding unbounded frame growth in recursive predicates.
; Recursive `App` trace: entering the rule body
; ---------------------------------------------
; Clauses:
;       ((App () X X))
;       ((App (X|Xs) Ys (X|Zs)) (App Xs Ys Zs))
; Call:
;       (App (a b) (c) R)
;
; The first head fails because `(a b)` is not empty.  The saved retry tail selects
; clause 2 and allocates locals X, Xs, Ys and Zs.  Head unification yields:
;
;       X=a, Xs=(b), Ys=(c), R=(a|Zs)
;
; The selected body `(App Xs Ys Zs)` becomes EXEC_CURRENT_GOALS.  The frame keeps
; the caller's remaining goals and environment.  Recursive selection repeats:
;
;       App (b) (c) Zs  -> X=b, Xs=(), Zs=(b|Zs2)
;       App ()  (c) Zs2 -> base clause, Zs2=(c)
;
; Returning through the two frames leaves R=(a b c).  The source-level recursion
; is therefore a chain of frames whose bodies become current goals one at a time.
.enter_selected_clause_body:
    cp TERM_TAG_LIST
    jp nz,signal_control_error
    ; Preserve the caller call-site while the rule body becomes current.
    ld de,(EXEC_CURRENT_GOALS)
    ld (EXEC_CURRENT_GOALS),hl
    ex de,hl
    call term_load_payload_hl
    inc hl
    inc hl
    inc hl
    ld de,(EXEC_CALLER_ENV_BASE)
    call term_dereference_hl
    cp TERM_TAG_END
    jp nz,.activate_selected_frame
    ; Tail relocation is allowed only when allocation started exactly above the
    ; caller frame and no choice point at/above that frame can require it.
    ld hl,(EXEC_PREVIOUS_FRAME_TOP)
    ld de,(EXEC_CURRENT_FRAME)
    or a
    sbc hl,de
    jp nz,.activate_selected_frame
    ld hl,(EXEC_CHOICE_FRAME)
    or a
    sbc hl,de
    jp nc,.activate_selected_frame
    ld hl,(EXEC_CALLER_ENV_BASE)
    ld de,(EXEC_CLAUSE_ENV_BASE)
    or a
    sbc hl,de
    ex de,hl
    ld bc,(EXEC_CURRENT_GOALS)
    dec hl
    or a
    sbc hl,bc
    jr nc,.tail_relocation_copy_frame
    ld hl,(EXEC_FRAME_TOP)
    or a
    sbc hl,bc
    jr c,.tail_relocation_copy_frame
    ld h,b
    ld l,c
    add hl,de
    ld (EXEC_CURRENT_GOALS),hl
; Tail-call relocation.  Compute the displacement between caller and callee
; local-variable areas, repair references that point into the moved interval,
; copy the continuation snapshot downward, then move the local cells and reset
; both allocation pointers to the compacted layout.
; ----------------------------------------------------------------------------
; LAST-CALL OPTIMIZATION AS MEMORY SURGERY
; ----------------------------------------------------------------------------
;
; This is not a compiler-level tail call; it is performed by the interpreter
; after selecting a rule.  When the caller has no remaining goals and no live
; choice point depends on its old address, the new frame and locals can slide
; down over the caller.
;
; Moving them is the easy part.  The hard part is repairing references which
; point into the relocated interval.  The scan below distinguishes references
; that must move from those that belong to older frames or the heap.  Once the
; twelve-byte continuation and local cells have been shifted, execution resumes
; as though the recursive call had reused the old frame from the start.
;
; Tail-frame relocation pseudocode
; --------------------------------
; if caller has no remaining goals
;    and no younger choice point depends on caller storage:
;       relocation_delta = caller_frame - child_frame
;       for every reference into child local storage:
;           adjust it by relocation_delta
;       copy child frame over caller frame
;       close the local/frame gap
;       update hot frame, local-base and frontier addresses
;       continue as though the child had originally occupied caller's slot
;
; Before:  [caller locals][caller frame][child locals][child frame]
; After:   [adjusted child locals][child frame][free execution space]
;
; This is an optimization only.  Logical caller/choice semantics remain those of
; the unrelocated frames.
.tail_relocation_copy_frame:
    ld bc,(EXEC_CLAUSE_ENV_BASE)
    ld hl,(EXEC_FRAME_TOP)
    or a
    sbc hl,bc
    jr z,.tail_relocation_move_state
    ; Local storage is a multiple of three bytes.  The compact loop uses the
    ; low-byte distance and subtracts two before DJNZ to advance by cells.
    ld b,l
    ld (EXEC_RELOCATION_DELTA),de
    ld hl,(EXEC_CLAUSE_ENV_BASE)
; Scan one three-byte local-variable cell.  Only absolute references into the
; interval being relocated need adjustment.  An unbound destination remains
; unbound; an already bound destination receives a complete copied cell.
; Numeric relocation example
; --------------------------
; Suppose child local L was at 0xA120 and relocation moves the child down by
; 0x0018 bytes.  A reference whose resolved target is L becomes 0xA108.  A
; scalar integer needs no fixup; a pointer outside the moved child-local range
; also remains unchanged.  The range tests below distinguish exactly these cases.
.tail_relocation_fix_local_reference:
    ld a,(hl)
    cp 001h
    jr nz,.tail_relocation_advance_local
    push hl
    call term_load_payload_hl
    ex de,hl
    ld hl,(EXEC_CALLER_ENV_BASE)
    dec hl
    or a
    sbc hl,de
    jr nc,.tail_relocation_finish_local
    ld hl,(EXEC_CURRENT_FRAME)
    or a
    sbc hl,de
    jr c,.tail_relocation_finish_local
    ld a,(de)
    cp 000h
    jr nz,.tail_relocation_copy_existing_binding
    pop hl
    push hl
    ld (hl),TERM_TAG_UNBOUND_VARIABLE
    push de
    ld de,(EXEC_RELOCATION_DELTA)
    add hl,de
    pop de
    ex de,hl
    ld (hl),001h
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    jr .tail_relocation_finish_local
.tail_relocation_copy_existing_binding:
    pop hl
    push hl
    ex de,hl
    push bc
    ld bc,00003h
    ldir
    pop bc
.tail_relocation_finish_local:
    pop hl
.tail_relocation_advance_local:
    inc hl
    inc hl
    inc hl
    dec b
    dec b
    djnz .tail_relocation_fix_local_reference
; Move the 12-byte continuation record first, then move all callee local cells
; from EXEC_CLAUSE_ENV_BASE to EXEC_CALLER_ENV_BASE.  LDIR is safe because the
; destination is below the source in this optimization path.
.tail_relocation_move_state:
    ld de,(EXEC_FRAME_TOP)
    ld hl,(EXEC_CURRENT_FRAME)
    ; Copy the complete six-word snapshot as an indivisible frame record.
    ld bc,EXEC_FRAME_SIZE
    ldir
    ld de,(EXEC_CLAUSE_ENV_BASE)
    ld hl,(EXEC_ALLOCATION_TOP)
    or a
    sbc hl,de
    ld b,h
    ld c,l
    ex de,hl
    ld de,(EXEC_CALLER_ENV_BASE)
    ldir
    ld (EXEC_ALLOCATION_TOP),de
    ; The frame starts exactly twelve bytes below the new allocation top.
    ld hl,-EXEC_FRAME_SIZE
    add hl,de
    ld (EXEC_FRAME_TOP),hl
; Make the newly allocated frame current and continue with its body.  Facts
; reach this point after caller unwinding; rules reach it after the optional
; tail-frame relocation.
.activate_selected_frame:
    ld hl,(EXEC_FRAME_TOP)
    ld (EXEC_CURRENT_FRAME),hl
    jp .execute_current_goal
; Logical failure path shared by native primitives, failed head unification and
; exhausted inner relation searches.
;
; EXEC_CHOICE_FRAME always names the youngest still-open alternative.  Restore
; its six-word snapshot, undo every younger binding, rewind the physical arena,
; and re-enter .try_next_relation_clause using frame+0 as the proper-list retry
; cursor.  If that cursor is END, selector NZ immediately repeats this process at
; the older choice restored from frame+6.  Thus total failure requires no special
; recursive routine: it is repeated restore-and-retry through the choice chain.
; ----------------------------------------------------------------------------
; FAILURE IS STATE RESTORATION
; ----------------------------------------------------------------------------
;
; Logical failure does not return a C-style error code through every caller.
; EXEC_CHOICE_FRAME names the newest frame with another clause.  Restoring that
; frame also restores the exact clause-list tail, caller, goals, older choice,
; trail boundary and allocation top that existed before the failed attempt.
;
; If its retry tail is END, selection fails again and the already-restored older
; choice becomes the next target.  Thus a sequence of exhausted calls unwinds
; iteratively through the same two routines.
;
; Complete retry/rollback trace
; -----------------------------
; Relation R has two clauses.  Clause 1 binds caller variable X=one, then a body
; goal fails; clause 2 can succeed with X=two.
;
; 1. Selecting clause 1 stores the relation-list tail (clause 2) in
;    frame.NEXT_CLAUSE, saves the current trail head, and publishes the frame as
;    EXEC_CHOICE_FRAME.
; 2. Head/body execution changes X's tag and, because X is old, pushes a trail
;    node for X.
; 3. Failure enters restore_choice_and_untrail.  It clears trail targets until
;    the frame's saved boundary, restoring X to UNBOUND.
; 4. All six hot words are restored from the choice frame.  NEXT_CLAUSE now
;    points at clause 2's list node.
; 5. Selection enters clause 2, whose unification binds X=two.
;
; Failure does not search backward through source text.  It restores a machine
; snapshot whose retry cursor is already the exact untried relation-list suffix.
.backtrack_to_latest_choice:
    ld ix,(EXEC_CHOICE_FRAME)
    call restore_choice_and_untrail
    jp .try_next_relation_clause
system_abort:
    call print_inline_high_bit_string    ; print inline high-bit text
system_abort_message:
    defb 0d3h,0f9h,0f3h,0f4h,0e5h,0edh,0a0h
    defb 0c1h,0e2h,0efh,0f2h,0f4h,000h       ; "System Abort"
    jp interpreter_entry    ; restart the interpreter
no_space_error:
    ld hl,nospace_string_start
    jr report_space_error_and_restart
dictionary_full_error:
    ld hl,dictfull_string_start
report_space_error_and_restart:
    call print_high_bit_string
    call line_editor_reset
    ld sp,(SUPERVISOR_MACHINE_STACK)
    jp supervisor_restart
; Convert asynchronous BREAK detection to the documented interpreter error 11.
; The common error path either invokes the user-visible ?ERROR? relation or
; prints the numeric fallback message and returns to the supervisor.
signal_break_error:
    ld hl,ERROR_BREAK
    jr signal_interpreter_error

; The Spectrum ROM leaves its report code in (IY+0).  micro-PROLOG reserves
; 0..4 for its own arithmetic/control/database errors, so the ROM report is
; translated by adding three before entering the common error dispatcher.
signal_rom_error_plus_three:
    ld h,000h
    ld l,(iy+000h)
    inc l
    inc l
    inc l
    jr signal_interpreter_error

; Frequently used fixed error stubs.  Keeping them as nearby JP/JR targets
; avoids repeating immediate error numbers throughout primitive handlers.
signal_control_error:
    ld hl,ERROR_CONTROL
    jr signal_interpreter_error
signal_file_error:
    ld hl,ERROR_FILE
    jr signal_interpreter_error
signal_arithmetic_underflow_error:
    ld hl,ERROR_ARITHMETIC_UNDERFLOW
    jr signal_interpreter_error
; Division by zero and decimal exponent overflow use the same documented code.
arithmetic_overflow_error:
    ld hl,ERROR_ARITHMETIC_OVERFLOW
    jr signal_interpreter_error
signal_no_clauses_error:
    ld hl,ERROR_NO_CLAUSES

; Abort the current proof and report an interpreter error.
;
; In:  HL = documented micro-PROLOG error number
; Does not return to the failing primitive.
;
; The machine stack is first rewound to the protected supervisor boundary, so
; arbitrary native call depth from the failed primitive is discarded.  If the
; cached ?ERROR? dictionary value is a clause list, a small built-in trampoline
; clause is selected and its first local is initialized to the error number;
; normal head unification then calls the user's handler with both the number and
; offending goal.  Without a handler, the numeric fallback is printed.
; ----------------------------------------------------------------------------
; ERRORS ARE NOT FAILURES
; ----------------------------------------------------------------------------
;
; A predicate may fail and invite another clause.  A malformed term, arithmetic
; overflow or file error must instead report a condition and abandon the current
; query.  The protected machine stack established at cold start provides that
; escape hatch.
;
; If the workspace defines ?ERROR?, the permanent adapter invokes it through
; the normal interpreter.  Otherwise the fallback printer emits the numeric
; code and restarts <SUP>.  User-level error handling is therefore layered on
; the same relation mechanism as every other extension.
;
; Error routing in one picture
; ----------------------------
; This code is the machine-level half of a policy completed by the permanent
; supervisor graph in module 10:
;
;       error raised
;           |
;           +-- user ?ERROR? relation exists --> call adapter clause
;           |
;           +-- no handler --------------------> print "Error: n" and restart
;
; The adapter atom is patched during cold start in module 12.  The forward
; references are a consequence of image address order, not circular semantics.
signal_interpreter_error:
    ld sp,(SUPERVISOR_MACHINE_STACK)             ;62a7: discard native frames below supervisor guard
    push hl                    ;62ab: preserve error number across I/O cleanup
    call line_editor_reset             ;62ac: restore console/parser state before reporting
    ld hl,(ERROR_HANDLER_VALUE_CELL) ;62af: cached value of constant "?ERROR?"
    ld a,(hl)
    cp TERM_TAG_LIST           ;62b3: LIST means a user error-handler clause chain
    jr z,.invoke_error_handler

    ; No handler is installed.  Print "Error:  ", the decimal code and newline,
    ; then restart only the logical supervisor state; the interpreter image and
    ; user database remain resident.
    ld hl,error_prefix_string
    call print_high_bit_string             ;62ba: print zero-terminated text
    pop hl                     ;62bd: numeric error code
    call io_print_unsigned_integer             ;62be: print signed integer in HL
    call console_output_newline             ;62c1: terminate the report line
    jp supervisor_restart

; Enter the internal adapter clause for ?ERROR?.  It has one local variable for
; the error number and a head that receives the goal which was active at the
; fault.  From this point the ordinary clause unifier and execution loop are
; reused; errors are not handled by a separate evaluator.
.invoke_error_handler:
    ld hl,error_handler_adapter_clause
    ld (EXEC_NEXT_CLAUSE),hl
    call select_clause_and_allocate_frame
    ld hl,(EXEC_CLAUSE_ENV_BASE)
    pop de                    ;62d3: recover error number
    ld (hl),TERM_TAG_INTEGER
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d

    ; A current goal stream normally begins with LIST(first goal).  Meta-variable
    ; execution can already present the atom directly, so only unwrap when the
    ; outer list cell is present before sharing the normal head-unification path.
    ld hl,(EXEC_CURRENT_GOALS)
    ld a,(hl)
    cp TERM_TAG_LIST
    jp nz,unify_call_with_selected_head
    call term_load_payload_hl
    jp unify_call_with_selected_head

; BLOCK 'nospace_string' (start 0x62e9 end 0x62f7)
; Readable bytes: "No Space left" followed by carriage return (0x0D).
; This path prints through a routine which already knows the block endpoint, so
; no extra NUL terminator is required inside the message.
nospace_string_start:
    defb 04eh
    defb 06fh
    defb 020h
    defb 053h
    defb 070h
    defb 061h
    defb 063h
    defb 065h
    defb 020h
    defb 06ch
    defb 065h
    defb 066h
    defb 074h
    defb 00dh
nospace_string_end:
    nop

; BLOCK 'dictfull_string' (start 0x62f8 end 0x6309)
; Readable bytes: "Dictionary full" followed by carriage return and NUL.
; Unlike the preceding fixed-span print, this block is also usable by a
; zero-terminated text path; hence it carries both the visible CR and a NUL.
dictfull_string_start:
    defb 044h
    defb 069h
    defb 063h
    defb 074h
    defb 069h
    defb 06fh
    defb 06eh
    defb 061h
    defb 072h
    defb 079h
    defb 020h
    defb 066h
    defb 075h
    defb 06ch
    defb 06ch
    defb 00dh
    defb 000h
dictfull_string_end:

; Numeric fallback prefix used when no ?ERROR? definition is installed.  This
; nine-byte text was previously rendered as plausible Z80 instructions.
error_prefix_string:
    defb 045h,072h,072h,06fh,072h,03ah,020h,020h,000h ; "Error:  "
; Select one compiled clause and allocate its locals plus a continuation/choice
; frame.  The relation value itself is a proper micro-PROLOG list, so retries
; retain its tail term rather than an array index or byte offset.
;
; In:  EXEC_NEXT_CLAUSE = LIST term naming the current relation-list suffix
;      EXEC_ALLOCATION_TOP = first free byte in the upward-growing arena
; Out: Z on a selected clause; NZ when the suffix is END or structurally invalid
;      EXEC_SELECTED_HEAD = first term in the compiled clause stream
;      EXEC_SELECTED_BODY = cell immediately after that head term
;      EXEC_CLAUSE_ENV_BASE = first fresh local-variable cell
;      EXEC_FRAME_TOP = address of the new 12-byte record
;
; Proven compiled representation:
;
;   relation cursor:       LIST -> pair
;   pair + 0:              LIST -> compiled clause metadata
;   pair + 3:              next relation cursor (LIST or END)
;   metadata + 0:          INTEGER local-variable count
;   metadata + 3 payload:  clause stream
;   clause stream + 0:     head atom
;   clause stream + 3:     first body goal, or END for an assertion
;
; The machine stack temporarily retains the pair-head cell, metadata pointer and
; local count while the arena-space check runs.  Locals consume three bytes each;
; the selector also reserves the 12-byte frame and a six-byte allocation margin.
