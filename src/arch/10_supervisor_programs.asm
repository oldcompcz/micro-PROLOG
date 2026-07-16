; -----------------------------------------------------------------------------
; Architectural module: 10_supervisor_programs.asm
; Permanent compiled supervisor dictionary and clause graph.
; Original monolithic line range: 7305-9328.
; Emitted address range: 0x83AC-0x8B14.
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Permanent logical supervisor programs
; -----------------------------------------------------------------------------
; These relations are stored as compiled tagged clause graphs. They are data,
; not executable Z80. Their source-level definitions are audited against the
; Programmer's Reference Manual and rendered by tools/audit_supervisor_programs.py.

; -----------------------------------------------------------------------------
; Permanent supervisor relation NOT
; -----------------------------------------------------------------------------
; Negation-as-failure. The first clause proves the meta-call once, cuts, then fails;
; the empty second clause succeeds only when the meta-call has no proof.
; ============================================================================
; CHAPTER 10 — PART OF THE INTERPRETER IS WRITTEN IN PROLOG
; ============================================================================
;
; The next 1.8K is not Z80 code at all.  It is a permanent graph of tagged terms
; representing twenty dictionary entries and twenty-seven compiled clauses.
; The supervisor, logical operators, LIST, LOAD, SAVE, CL and DELCL are therefore
; extensions expressed in the language they supervise.
;
; Each cluster follows the same physical grammar:
;
;       dictionary entry -> canonical value cell -> proper list of clause pairs
;       clause pair      -> metadata/local count -> head and body term stream
;
; The many labels are intentionally explicit.  They let a reader follow one
; compiled clause as a graph instead of seeing an undifferentiated sea of DEFB
; and DEFW directives.
;
; The comments before each relation give its readable micro-PROLOG form.  The
; cells which follow are the exact resident representation of that form.
;
; How to read the permanent graphs
; --------------------------------
; This chapter is data, not a long executable routine.  Each section first states
; the reconstructed micro-PROLOG clause, then lists the exact tagged cells that
; encode it.  Read the clause as the semantic source and use the cells to verify
; representation details:
;
;       CONSTANT/value cells -> relation identity
;       LIST cells           -> atom and clause structure
;       RELATIVE references  -> clause variables
;       END cells            -> proper-list terminators
;
; The graph is intentionally verbose because every absolute pointer must remain
; byte-exact.
; Reading rule for permanent supervisor graphs
; --------------------------------------------
; Read the reconstructed source-level clause in the prose first.  Then treat the
; following tagged cells as a serialized proof of that clause: relation list,
; metadata, stream, atoms and argument tails.  Binary address order is not the
; pedagogical order of the program.
supervisor_not_constant_entry:
    defb TERM_TAG_CONSTANT    ; constant 'NOT'
    defw supervisor_not_value_cell
supervisor_term_83af:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_eq_constant_entry
    defw supervisor_eq_constant_entry
supervisor_not_value_cell:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_83b9
    defw supervisor_term_83b9
supervisor_not_name:
    defb 04eh,04fh,054h,0ffh    ; "NOT"
supervisor_term_83b9:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_83bf
    defw supervisor_term_83bf
supervisor_term_83bc:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_83dd
    defw supervisor_term_83dd
supervisor_term_83bf:
    defb TERM_TAG_INTEGER    ; integer/local-count 1
    defw 00001h
supervisor_term_83c2:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_83c5
    defw supervisor_term_83c5
supervisor_term_83c5:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V0
    defw 00000h
supervisor_term_83c8:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_83cb
    defw supervisor_term_83cb
supervisor_term_83cb:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V0
    defw 00000h
supervisor_term_83ce:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_83d1
    defw supervisor_term_83d1
supervisor_term_83d1:
    defb TERM_TAG_CONSTANT    ; constant '/'
    defw slash_value_cell
supervisor_term_83d4:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_83d7
    defw supervisor_term_83d7
supervisor_term_83d7:
    defb TERM_TAG_CONSTANT    ; constant 'FAIL'
    defw fail_value_cell
supervisor_term_83da:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_83dd:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_83e3
    defw supervisor_term_83e3
supervisor_term_83e0:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_83e3:
    defb TERM_TAG_INTEGER    ; integer/local-count 1
    defw 00001h
supervisor_term_83e6:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_83e9
    defw supervisor_term_83e9
supervisor_term_83e9:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V0
    defw 00000h
supervisor_term_83ec:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh

; -----------------------------------------------------------------------------
; Permanent supervisor relation EQ
; -----------------------------------------------------------------------------
; Identity/unification relation: the one clause repeats the same local variable in both
; argument positions, so ordinary head unification performs EQ.
; ----------------------------------------------------------------------------
; EQ is the purest example: one clause, ((EQ X X)).  Both argument positions
; contain the same relative variable offset, so ordinary head unification
; performs equality testing without a native primitive.
;
; Runtime trace: `(EQ X 3)`
; -------------------------
; EQ is stored as the one-clause assertion `((EQ X X))`.  Selection allocates one
; fresh local because the compiled head contains RELATIVE 0 twice.  Call/head
; unification binds that local to caller X on the first argument, then dereferences
; the same local for the second argument and unifies it with integer 3.  Ordinary
; unification therefore implements equality; there is no special EQ native code.
supervisor_eq_constant_entry:
    defb TERM_TAG_CONSTANT    ; constant 'EQ'
    defw supervisor_eq_value_cell
supervisor_term_83f2:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_if_constant_entry
    defw supervisor_if_constant_entry
supervisor_eq_value_cell:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_83fb
    defw supervisor_term_83fb
supervisor_eq_name:
    defb 045h,051h,0ffh    ; "EQ"
supervisor_term_83fb:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8401
    defw supervisor_term_8401
supervisor_term_83fe:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_8401:
    defb TERM_TAG_INTEGER    ; integer/local-count 1
    defw 00001h
supervisor_term_8404:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8407
    defw supervisor_term_8407
supervisor_term_8407:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_840d
    defw supervisor_term_840d
supervisor_term_840a:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_840d:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V0
    defw 00000h
supervisor_term_8410:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_83e9
    defw supervisor_term_83e9

; -----------------------------------------------------------------------------
; Permanent supervisor relation IF
; -----------------------------------------------------------------------------
; Conditional relation. Clause 1 evaluates the test, cuts alternatives, and continues
; with the then-goal list; clause 2 continues with the else-goal list.
; ----------------------------------------------------------------------------
; IF has two clauses.  The first evaluates the condition, cuts, and then jumps
; into the true body supplied as a meta-variable tail.  The second falls through
; to the false body.  Cut is what prevents backtracking from reconsidering the
; false branch after the condition has succeeded.
;
; IF committed-choice trace
; -------------------------
; The two clauses are logically:
;
;       IF Cond Then Else :- Cond, !, Then.
;       IF Cond Then Else :- Else.
;
; If Cond succeeds, cut removes the second IF clause and any alternatives created
; while proving Cond; Then runs.  If Cond fails before the cut, normal clause
; retry selects the second clause and Else runs.  Thus the tiny permanent graph
; implements deterministic if-then-else with ordinary Prolog control machinery.
supervisor_if_constant_entry:
    defb TERM_TAG_CONSTANT    ; constant 'IF'
    defw supervisor_if_value_cell
supervisor_term_8416:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_or_constant_entry
    defw supervisor_or_constant_entry
supervisor_if_value_cell:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_841f
    defw supervisor_term_841f
supervisor_if_name:
    defb 049h,046h,0ffh    ; "IF"
supervisor_term_841f:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8425
    defw supervisor_term_8425
supervisor_term_8422:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_844f
    defw supervisor_term_844f
supervisor_term_8425:
    defb TERM_TAG_INTEGER    ; integer/local-count 3
    defw 00003h
supervisor_term_8428:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_842b
    defw supervisor_term_842b
supervisor_term_842b:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8431
    defw supervisor_term_8431
supervisor_term_842e:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8443
    defw supervisor_term_8443
supervisor_term_8431:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V0
    defw 00000h
supervisor_term_8434:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8437
    defw supervisor_term_8437
supervisor_term_8437:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V1
    defw 00003h
supervisor_term_843a:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_843d
    defw supervisor_term_843d
supervisor_term_843d:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V2
    defw 00006h
supervisor_term_8440:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_8443:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V0
    defw 00000h
supervisor_term_8446:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8449
    defw supervisor_term_8449
supervisor_term_8449:
    defb TERM_TAG_CONSTANT    ; constant '/'
    defw slash_value_cell
supervisor_term_844c:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V1
    defw 00003h
supervisor_term_844f:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8455
    defw supervisor_term_8455
supervisor_term_8452:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_8455:
    defb TERM_TAG_INTEGER    ; integer/local-count 3
    defw 00003h
supervisor_term_8458:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_845b
    defw supervisor_term_845b
supervisor_term_845b:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8431
    defw supervisor_term_8431
supervisor_term_845e:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V2
    defw 00006h

; -----------------------------------------------------------------------------
; Permanent supervisor relation OR
; -----------------------------------------------------------------------------
; Disjunction implemented by two clauses whose bodies are the first and second goal lists.
; ----------------------------------------------------------------------------
; OR is simply two clauses whose bodies are the two meta-variable argument
; lists.  Prolog's own clause choice supplies disjunction; no native OR opcode is
; necessary.
;
; OR choice trace
; ---------------
; OR has two clauses whose bodies are the two supplied goal lists.  Selecting the
; first clause publishes a choice frame whose NEXT_CLAUSE points to the second.
; If the first branch succeeds, execution continues normally; if later search
; backtracks into OR, rollback restores that frame and installs the second body.
; Disjunction is thus ordinary clause choice plus meta-body substitution.
supervisor_or_constant_entry:
    defb TERM_TAG_CONSTANT    ; constant 'OR'
    defw supervisor_or_value_cell
supervisor_term_8464:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_cl_constant_entry
    defw supervisor_cl_constant_entry
supervisor_or_value_cell:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_846d
    defw supervisor_term_846d
supervisor_or_name:
    defb 04fh,052h,0ffh    ; "OR"
supervisor_term_846d:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8473
    defw supervisor_term_8473
supervisor_term_8470:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_848b
    defw supervisor_term_848b
supervisor_term_8473:
    defb TERM_TAG_INTEGER    ; integer/local-count 2
    defw 00002h
supervisor_term_8476:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8479
    defw supervisor_term_8479
supervisor_term_8479:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_847f
    defw supervisor_term_847f
supervisor_term_847c:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V0
    defw 00000h
supervisor_term_847f:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V0
    defw 00000h
supervisor_term_8482:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8485
    defw supervisor_term_8485
supervisor_term_8485:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V1
    defw 00003h
supervisor_term_8488:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_848b:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8491
    defw supervisor_term_8491
supervisor_term_848e:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_8491:
    defb TERM_TAG_INTEGER    ; integer/local-count 2
    defw 00002h
supervisor_term_8494:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8497
    defw supervisor_term_8497
supervisor_term_8497:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_847f
    defw supervisor_term_847f
supervisor_term_849a:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V1
    defw 00003h
permanent_empty_list:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
static_end_cell_84a0:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh

; -----------------------------------------------------------------------------
; Permanent CL and DELCL supervisor programs
; -----------------------------------------------------------------------------
; These bytes are compiled micro-PROLOG clauses, not Z80 instructions.  Their
; source-level meaning is:
;
;   ((CL X) (/) (CL X 1 Y))
;
;   ((CL ((R|H)|B) Start Found)
;       (* R FreshH FreshB Start)
;       (OR ((EQ (H B Found) (FreshH FreshB Start)))
;           ((SUM Start 1 Next)
;            (CL ((R|H)|B) Next Found))))
;
;   ((DELCL ((R|H)|B))
;       (CL ((R|H)|B) 1 Position)
;       (/)
;       (* R Position))
;
;   ((DELCL R Position) (* R Position))
;
; The two private relations printed as "*" have distinct value cells: one fetches
; a fresh copy of a numbered clause for CL, the other unlinks a numbered clause
; for DELCL.  The physical order below follows the original shared term graph;
; several sublists are deliberately reused rather than duplicated.

; ----------------------------------------------------------------------------
; CL demonstrates the division of labor between permanent Prolog and private
; machine helpers.  Prolog code enumerates positions, performs pattern matching
; and exposes nondeterminism.  A hidden native relation fetches one numbered
; stored clause with fresh variables.
;
; CL / DELCL graph-navigation legend
; --------------------------------------
; Treat the source-level clause below as primary.  One actual path through labels
; has the form:
;
;   supervisor_cl_value_cell
;       -> cl_unary_relation_pair          relation-list node
;       -> cl_unary_metadata               local count + stream pointer
;       -> cl_unary_stream                 head atom followed by body goals
;       -> cl_unary_head_arguments         argument-list tail of head atom
;       -> cl_unary_first_body_goal        first body atom
;       -> ... -> END
;
; At each LIST pair, the first cell is the element/head and the adjacent second
; cell is the tail.  Follow labels, not numeric adjacency, when reconstructing the
; large serialized program.
supervisor_cl_constant_entry:
    defb TERM_TAG_CONSTANT
    defw supervisor_cl_value_cell
supervisor_cl_dictionary_link:
    defb TERM_TAG_LIST
    defw supervisor_delcl_constant_entry
supervisor_cl_value_cell:
    defb TERM_TAG_LIST
    defw cl_unary_relation_pair
supervisor_cl_name:
    defb 043h,04ch,SYSTEM_NAME_TERMINATOR ; "CL"

; Unary wrapper clause: ((CL X) (/) (CL X 1 Y)).
cl_unary_relation_pair:
    defb TERM_TAG_LIST
    defw cl_unary_metadata
cl_unary_next_clause_cursor:
    defb TERM_TAG_LIST
    defw cl_enumerator_relation_pair
cl_unary_metadata:
    defb TERM_TAG_INTEGER
    defw 0002h
cl_unary_metadata_stream:
    defb TERM_TAG_LIST
    defw cl_unary_stream
cl_unary_stream:
    defb TERM_TAG_LIST
    defw STATIC_ARGS_V0
cl_unary_stream_body:
    defb TERM_TAG_LIST
    defw cl_unary_body_cut
cl_unary_body_cut:
    defb TERM_TAG_CONSTANT
    defw slash_value_cell
cl_unary_body_after_cut:
    defb TERM_TAG_LIST
    defw cl_unary_body_recursive_call
cl_unary_body_recursive_call:
    defb TERM_TAG_LIST
    defw cl_unary_recursive_atom
cl_unary_body_end:
    defb TERM_TAG_END
    defw 0ffffh
cl_unary_recursive_atom:
    defb TERM_TAG_CONSTANT
    defw supervisor_cl_value_cell
cl_unary_recursive_arguments:
    defb TERM_TAG_LIST
    defw cl_unary_recursive_clause_arg
cl_unary_recursive_clause_arg:
    defb TERM_TAG_RELATIVE_REFERENCE
    defw 0000h
cl_unary_recursive_start_tail:
    defb TERM_TAG_LIST
    defw cl_unary_recursive_start_arg
cl_unary_recursive_start_arg:
    defb TERM_TAG_INTEGER
    defw 0001h
cl_unary_recursive_found_tail:
    defb TERM_TAG_LIST
    defw STATIC_ARGS_V1

; Three-argument nondeterministic enumerator clause.
cl_enumerator_relation_pair:
    defb TERM_TAG_LIST
    defw cl_enumerator_metadata
cl_enumerator_relation_end:
    defb TERM_TAG_END
    defw 0ffffh
cl_enumerator_metadata:
    defb TERM_TAG_INTEGER
    defw 0008h
cl_enumerator_metadata_stream:
    defb TERM_TAG_LIST
    defw cl_enumerator_stream
cl_enumerator_stream:
    defb TERM_TAG_LIST
    defw cl_enumerator_head_arguments
cl_enumerator_stream_body:
    defb TERM_TAG_LIST
    defw cl_enumerator_body_fetch

; Head arguments: (((R|H)|B) Start Found).
cl_enumerator_head_arguments:
    defb TERM_TAG_LIST
    defw cl_shared_clause_pattern
cl_enumerator_head_tail:
    defb TERM_TAG_LIST
    defw cl_enumerator_start_arg
cl_shared_clause_pattern:
    defb TERM_TAG_LIST
    defw cl_shared_head_pattern
cl_shared_clause_body_tail:
    defb TERM_TAG_RELATIVE_REFERENCE
    defw 0006h                                 ; B = V2
cl_shared_head_pattern:
    defb TERM_TAG_RELATIVE_REFERENCE
    defw 0000h                                 ; R = V0
cl_shared_head_arguments_tail:
    defb TERM_TAG_RELATIVE_REFERENCE
    defw 0003h                                 ; H = V1
cl_enumerator_start_arg:
    defb TERM_TAG_RELATIVE_REFERENCE
    defw 0009h                                 ; Start = V3
cl_enumerator_found_tail:
    defb TERM_TAG_LIST
    defw cl_enumerator_found_arg
cl_enumerator_found_arg:
    defb TERM_TAG_RELATIVE_REFERENCE
    defw 000ch                                 ; Found = V4
cl_enumerator_head_end:
    defb TERM_TAG_END
    defw 0ffffh

; The OR goal is physically stored before the preceding fetch goal and linked
; into place by cl_enumerator_body_fetch_tail below.
cl_enumerator_body_or:
    defb TERM_TAG_LIST
    defw cl_enumerator_or_atom
cl_enumerator_body_end:
    defb TERM_TAG_END
    defw 0ffffh
cl_enumerator_or_atom:
    defb TERM_TAG_CONSTANT
    defw SUPERVISOR_OR_VALUE_CELL
cl_enumerator_or_arguments:
    defb TERM_TAG_LIST
    defw cl_enumerator_or_first_branch
cl_enumerator_or_first_branch:
    defb TERM_TAG_LIST
    defw cl_enumerator_match_branch
cl_enumerator_or_second_branch_tail:
    defb TERM_TAG_LIST
    defw cl_enumerator_recursive_branch

; First body goal: private fetch helper (* R FreshH FreshB Start).
cl_enumerator_body_fetch:
    defb TERM_TAG_LIST
    defw cl_enumerator_fetch_atom
cl_enumerator_body_fetch_tail:
    defb TERM_TAG_LIST
    defw cl_enumerator_body_or
cl_enumerator_fetch_atom:
    defb TERM_TAG_CONSTANT
    defw internal_fetch_clause_value_cell
cl_enumerator_fetch_arguments:
    defb TERM_TAG_LIST
    defw cl_enumerator_fetch_relation
cl_enumerator_fetch_relation:
    defb TERM_TAG_RELATIVE_REFERENCE
    defw 0000h                                 ; R
cl_enumerator_fetch_head_tail:
    defb TERM_TAG_LIST
    defw cl_enumerator_fetch_head
cl_enumerator_fetch_head:
    defb TERM_TAG_RELATIVE_REFERENCE
    defw 000fh                                 ; FreshH = V5
cl_enumerator_fetch_body_tail:
    defb TERM_TAG_LIST
    defw cl_enumerator_fetch_body
cl_enumerator_fetch_body:
    defb TERM_TAG_RELATIVE_REFERENCE
    defw 0012h                                 ; FreshB = V6
cl_enumerator_fetch_position_tail:
    defb TERM_TAG_LIST
    defw cl_enumerator_fetch_position
cl_enumerator_fetch_position:
    defb TERM_TAG_RELATIVE_REFERENCE
    defw 0009h                                 ; Start = V3
cl_enumerator_fetch_end:
    defb TERM_TAG_END
    defw 0ffffh

; First OR branch: ((EQ (H B Found) (FreshH FreshB Start))).
cl_enumerator_match_branch:
    defb TERM_TAG_LIST
    defw cl_enumerator_match_atom
cl_enumerator_match_branch_end:
    defb TERM_TAG_END
    defw 0ffffh
cl_enumerator_match_atom:
    defb TERM_TAG_CONSTANT
    defw SUPERVISOR_EQ_VALUE_CELL
cl_enumerator_match_arguments:
    defb TERM_TAG_LIST
    defw cl_enumerator_expected_tuple_cell
cl_enumerator_expected_tuple_cell:
    defb TERM_TAG_LIST
    defw cl_enumerator_expected_tuple
cl_enumerator_actual_tuple_tail:
    defb TERM_TAG_LIST
    defw cl_enumerator_actual_tuple_cell
cl_enumerator_expected_tuple:
    defb TERM_TAG_RELATIVE_REFERENCE
    defw 0003h                                 ; H
cl_enumerator_expected_body_tail:
    defb TERM_TAG_LIST
    defw cl_enumerator_expected_body
cl_enumerator_expected_body:
    defb TERM_TAG_RELATIVE_REFERENCE
    defw 0006h                                 ; B
cl_enumerator_expected_position_tail:
    defb TERM_TAG_LIST
    defw cl_enumerator_expected_position
cl_enumerator_expected_position:
    defb TERM_TAG_RELATIVE_REFERENCE
    defw 000ch                                 ; Found
cl_enumerator_expected_end:
    defb TERM_TAG_END
    defw 0ffffh
cl_enumerator_actual_tuple_cell:
    defb TERM_TAG_LIST
    defw cl_enumerator_fetch_head              ; (FreshH FreshB Start)
cl_enumerator_actual_end:
    defb TERM_TAG_END
    defw 0ffffh

; Second OR branch: increment Start and recurse.
cl_enumerator_recursive_branch:
    defb TERM_TAG_LIST
    defw cl_enumerator_increment_goal
cl_enumerator_recursive_branch_end:
    defb TERM_TAG_END
    defw 0ffffh
cl_enumerator_increment_goal:
    defb TERM_TAG_LIST
    defw cl_enumerator_sum_atom
cl_enumerator_increment_goal_tail:
    defb TERM_TAG_LIST
    defw cl_enumerator_recursive_goal
cl_enumerator_sum_atom:
    defb TERM_TAG_CONSTANT
    defw sum_value_cell
cl_enumerator_sum_arguments:
    defb TERM_TAG_LIST
    defw cl_enumerator_sum_start
cl_enumerator_sum_start:
    defb TERM_TAG_RELATIVE_REFERENCE
    defw 0009h                                 ; Start
cl_enumerator_sum_one_tail:
    defb TERM_TAG_LIST
    defw cl_enumerator_sum_one
cl_enumerator_sum_one:
    defb TERM_TAG_INTEGER
    defw 0001h
cl_enumerator_sum_next_tail:
    defb TERM_TAG_LIST
    defw cl_enumerator_sum_next
cl_enumerator_sum_next:
    defb TERM_TAG_RELATIVE_REFERENCE
    defw 0015h                                 ; Next = V7
cl_enumerator_sum_end:
    defb TERM_TAG_END
    defw 0ffffh
cl_enumerator_recursive_goal:
    defb TERM_TAG_LIST
    defw cl_enumerator_recursive_atom
cl_enumerator_recursive_goal_end:
    defb TERM_TAG_END
    defw 0ffffh
cl_enumerator_recursive_atom:
    defb TERM_TAG_CONSTANT
    defw supervisor_cl_value_cell
cl_enumerator_recursive_arguments:
    defb TERM_TAG_LIST
    defw cl_enumerator_recursive_pattern_cell
cl_enumerator_recursive_pattern_cell:
    defb TERM_TAG_LIST
    defw cl_shared_clause_pattern
cl_enumerator_recursive_next_tail:
    defb TERM_TAG_LIST
    defw cl_enumerator_recursive_next
cl_enumerator_recursive_next:
    defb TERM_TAG_RELATIVE_REFERENCE
    defw 0015h                                 ; Next
cl_enumerator_recursive_found_tail:
    defb TERM_TAG_LIST
    defw cl_enumerator_found_arg               ; Found then END

; ----------------------------------------------------------------------------
; DELCL uses CL to find the first matching clause, cuts to commit to that match,
; then calls a private positional deletion helper.  The documented high-level
; behavior is thus visible directly in this compiled graph.
;
supervisor_delcl_constant_entry:
    defb TERM_TAG_CONSTANT
    defw supervisor_delcl_value_cell
supervisor_delcl_dictionary_link:
    defb TERM_TAG_LIST
    defw 08620h                                ; next entry: LOAD
supervisor_delcl_value_cell:
    defb TERM_TAG_LIST
    defw delcl_pattern_relation_pair
supervisor_delcl_name:
    defb 044h,045h,04ch,043h,04ch,SYSTEM_NAME_TERMINATOR ; "DELCL"

; Clause 1: find the first matching pattern, cut, then delete its position.
delcl_pattern_relation_pair:
    defb TERM_TAG_LIST
    defw delcl_pattern_metadata
delcl_pattern_next_clause_cursor:
    defb TERM_TAG_LIST
    defw delcl_position_relation_pair
delcl_pattern_metadata:
    defb TERM_TAG_INTEGER
    defw 0004h
delcl_pattern_metadata_stream:
    defb TERM_TAG_LIST
    defw delcl_pattern_stream
delcl_pattern_stream:
    defb TERM_TAG_LIST
    defw delcl_pattern_head_arguments
delcl_pattern_stream_body:
    defb TERM_TAG_LIST
    defw delcl_pattern_body_cl
delcl_pattern_head_arguments:
    defb TERM_TAG_LIST
    defw cl_shared_clause_pattern
delcl_pattern_head_end:
    defb TERM_TAG_END
    defw 0ffffh

; Goal 1: (CL Pattern 1 Position).
delcl_pattern_body_cl:
    defb TERM_TAG_LIST
    defw delcl_pattern_cl_atom
delcl_pattern_body_after_cl:
    defb TERM_TAG_LIST
    defw delcl_pattern_body_cut
delcl_pattern_cl_atom:
    defb TERM_TAG_CONSTANT
    defw supervisor_cl_value_cell
delcl_pattern_cl_arguments:
    defb TERM_TAG_LIST
    defw delcl_pattern_cl_pattern_cell
delcl_pattern_cl_pattern_cell:
    defb TERM_TAG_LIST
    defw cl_shared_clause_pattern
delcl_pattern_cl_one_tail:
    defb TERM_TAG_LIST
    defw delcl_pattern_cl_one
delcl_pattern_cl_one:
    defb TERM_TAG_INTEGER
    defw 0001h
delcl_pattern_cl_position_tail:
    defb TERM_TAG_LIST
    defw cl_enumerator_fetch_position          ; Position = V3, then END

; Goals 2 and 3: cut, then private delete helper.
delcl_pattern_body_cut:
    defb TERM_TAG_CONSTANT
    defw slash_value_cell
delcl_pattern_body_after_cut:
    defb TERM_TAG_LIST
    defw delcl_pattern_body_delete
delcl_pattern_body_delete:
    defb TERM_TAG_LIST
    defw delcl_pattern_delete_atom
delcl_pattern_body_end:
    defb TERM_TAG_END
    defw 0ffffh
delcl_pattern_delete_atom:
    defb TERM_TAG_CONSTANT
    defw internal_delete_clause_value_cell
delcl_pattern_delete_arguments:
    defb TERM_TAG_LIST
    defw delcl_pattern_delete_relation
delcl_pattern_delete_relation:
    defb TERM_TAG_RELATIVE_REFERENCE
    defw 0000h                                 ; R
delcl_pattern_delete_position_tail:
    defb TERM_TAG_LIST
    defw cl_enumerator_fetch_position          ; Position = V3, then END

; Clause 2: direct positional form (DELCL Relation Position).
delcl_position_relation_pair:
    defb TERM_TAG_LIST
    defw delcl_position_metadata
delcl_position_relation_end:
    defb TERM_TAG_END
    defw 0ffffh
delcl_position_metadata:
    defb TERM_TAG_INTEGER
    defw 0002h
delcl_position_metadata_stream:
    defb TERM_TAG_LIST
    defw delcl_position_stream
delcl_position_stream:
    defb TERM_TAG_LIST
    defw STATIC_ARGS_V0_V1
delcl_position_stream_body:
    defb TERM_TAG_LIST
    defw delcl_position_body
delcl_position_body:
    defb TERM_TAG_LIST
    defw delcl_position_delete_atom
delcl_position_body_end:
    defb TERM_TAG_END
    defw 0ffffh
delcl_position_delete_atom:
    defb TERM_TAG_CONSTANT
    defw internal_delete_clause_value_cell
delcl_position_delete_arguments:
    defb TERM_TAG_LIST
    defw STATIC_ARGS_V0_V1

; -----------------------------------------------------------------------------
; Remaining permanent supervisor programs
; -----------------------------------------------------------------------------
; LOAD/SAVE/LIST, the top-level supervisor, console wrappers, logical helpers,
; the dynamic DICT view and the error adapter all use the same compiled-clause
; representation as user relations. Every cell below is immutable static data.

; -----------------------------------------------------------------------------
; Permanent supervisor relation LOAD
; -----------------------------------------------------------------------------
; LOAD opens a file and delegates its term stream to two private "*" relations.
; The private workers recognize EOF/module markers, create modules, add clauses, and loop.
; ----------------------------------------------------------------------------
; LOAD is a loop written as two clauses.  The first opens the file and delegates
; each read object to private workers which distinguish clauses from module
; wrappers.  The second clause closes the file when the reader reaches its end
; condition.
;
; LOAD call graph
; ---------------
;       supervisor command LOAD File
;           |
;           +-- public clause 1: OPEN File, stream_worker(File)
;           |                         |
;           |                         +-- READ next object
;           |                         +-- item_worker(Object)
;           |                               +-- ADDCL ordinary clause
;           |                               +-- install module object
;           |                               +-- stop at EOF
;           |                         +-- recurse
;           |
;           +-- public clause 2: CLOSE File
;
; The private workers use the internal printed name `*`; their distinct canonical
; value cells, not the spelling alone, determine which helper is called.
; LOAD traces
; -----------
; Ordinary clause file item:
;       OPEN -> READ item -> classify as clause -> ADDCL -> READ next -> EOF -> CLOSE
;
; Module file item:
;       OPEN -> READ module wrapper -> classify module object -> install module
;       descriptor/export/import structures -> READ next -> EOF -> CLOSE
;
; The public two-clause LOAD program owns opening and guaranteed closing.  Private
; `*` workers perform the read/classify loop; ordinary source and modules share
; the same cassette term reader.
supervisor_load_constant_entry:
    defb TERM_TAG_CONSTANT    ; constant 'LOAD'
    defw supervisor_load_value_cell
supervisor_term_8623:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_save_constant_entry
    defw supervisor_save_constant_entry
supervisor_load_value_cell:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_862e
    defw supervisor_term_862e
supervisor_load_name:
    defb 04ch,04fh,041h,044h,0ffh    ; "LOAD"
supervisor_term_862e:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8634
    defw supervisor_term_8634
supervisor_term_8631:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_864c
    defw supervisor_term_864c
supervisor_term_8634:
    defb TERM_TAG_INTEGER    ; integer/local-count 1
    defw 00001h
supervisor_term_8637:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_863a
    defw supervisor_term_863a
supervisor_term_863a:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88af
    defw supervisor_term_88af
supervisor_term_863d:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8640
    defw supervisor_term_8640
supervisor_term_8640:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8646
    defw supervisor_term_8646
supervisor_term_8643:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_868d
    defw supervisor_term_868d
supervisor_term_8646:
    defb TERM_TAG_CONSTANT    ; constant 'OPEN'
    defw open_value_cell
supervisor_term_8649:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88af
    defw supervisor_term_88af
supervisor_term_864c:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8652
    defw supervisor_term_8652
supervisor_term_864f:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_8652:
    defb TERM_TAG_INTEGER    ; integer/local-count 1
    defw 00001h
supervisor_term_8655:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8658
    defw supervisor_term_8658
supervisor_term_8658:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88af
    defw supervisor_term_88af
supervisor_term_865b:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8796
    defw supervisor_term_8796
load_stream_worker_value_cell:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8663
    defw supervisor_term_8663
load_stream_worker_name:
    defb 02ah,0ffh    ; "*"
supervisor_term_8663:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8669
    defw supervisor_term_8669
supervisor_term_8666:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_8669:
    defb TERM_TAG_INTEGER    ; integer/local-count 2
    defw 00002h
supervisor_term_866c:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_866f
    defw supervisor_term_866f
supervisor_term_866f:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88af
    defw supervisor_term_88af
supervisor_term_8672:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8675
    defw supervisor_term_8675
supervisor_term_8675:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_867b
    defw supervisor_term_867b
supervisor_term_8678:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8681
    defw supervisor_term_8681
supervisor_term_867b:
    defb TERM_TAG_CONSTANT    ; constant 'READ'
    defw read_value_cell
supervisor_term_867e:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_847f
    defw supervisor_term_847f
supervisor_term_8681:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8687
    defw supervisor_term_8687
supervisor_term_8684:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_868d
    defw supervisor_term_868d
supervisor_term_8687:
    defb TERM_TAG_CONSTANT    ; constant '*'
    defw load_item_worker_value_cell
supervisor_term_868a:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_847f
    defw supervisor_term_847f
supervisor_term_868d:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8693
    defw supervisor_term_8693
supervisor_term_8690:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_8693:
    defb TERM_TAG_CONSTANT    ; constant '*'
    defw load_stream_worker_value_cell
supervisor_term_8696:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88af
    defw supervisor_term_88af
load_item_worker_value_cell:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_869e
    defw supervisor_term_869e
load_item_worker_name:
    defb 02ah,0ffh    ; "*"
supervisor_term_869e:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_86a4
    defw supervisor_term_86a4
supervisor_term_86a1:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_86c2
    defw supervisor_term_86c2
supervisor_term_86a4:
    defb TERM_TAG_INTEGER    ; integer/local-count 1
    defw 00001h
supervisor_term_86a7:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_86aa
    defw supervisor_term_86aa
supervisor_term_86aa:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_86b0
    defw supervisor_term_86b0
supervisor_term_86ad:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_86bc
    defw supervisor_term_86bc
supervisor_term_86b0:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V0
    defw 00000h
supervisor_term_86b3:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_86b6
    defw supervisor_term_86b6
supervisor_term_86b6:
    defb TERM_TAG_CONSTANT    ; constant 'CLMOD'
    defw 0780dh
supervisor_term_86b9:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_86bc:
    defb TERM_TAG_CONSTANT    ; constant '/'
    defw slash_value_cell
supervisor_term_86bf:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_86b6
    defw supervisor_term_86b6
supervisor_term_86c2:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_86c8
    defw supervisor_term_86c8
supervisor_term_86c5:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_86ec
    defw supervisor_term_86ec
supervisor_term_86c8:
    defb TERM_TAG_INTEGER    ; integer/local-count 2
    defw 00002h
supervisor_term_86cb:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_86ce
    defw supervisor_term_86ce
supervisor_term_86ce:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_86d4
    defw supervisor_term_86d4
supervisor_term_86d1:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_86e0
    defw supervisor_term_86e0
supervisor_term_86d4:
    defb TERM_TAG_CONSTANT    ; constant '@0000'
    defw 00000h
supervisor_term_86d7:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_86da
    defw supervisor_term_86da
supervisor_term_86da:
    defb TERM_TAG_CONSTANT    ; constant '?'
    defw supervisor_query_value_cell
supervisor_term_86dd:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_86e0:
    defb TERM_TAG_CONSTANT    ; constant '/'
    defw slash_value_cell
supervisor_term_86e3:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_86e6
    defw supervisor_term_86e6
supervisor_term_86e6:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_867b
    defw supervisor_term_867b
supervisor_term_86e9:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8a61
    defw supervisor_term_8a61
supervisor_term_86ec:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_86f2
    defw supervisor_term_86f2
supervisor_term_86ef:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8746
    defw supervisor_term_8746
supervisor_term_86f2:
    defb TERM_TAG_INTEGER    ; integer/local-count 4
    defw 00004h
supervisor_term_86f5:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_86f8
    defw supervisor_term_86f8
supervisor_term_86f8:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_847f
    defw supervisor_term_847f
supervisor_term_86fb:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_86fe
    defw supervisor_term_86fe
supervisor_term_86fe:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8704
    defw supervisor_term_8704
supervisor_term_8701:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_870a
    defw supervisor_term_870a
supervisor_term_8704:
    defb TERM_TAG_CONSTANT    ; constant 'CON'
    defw con_value_cell
supervisor_term_8707:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8485
    defw supervisor_term_8485
supervisor_term_870a:
    defb TERM_TAG_CONSTANT    ; constant '/'
    defw slash_value_cell
supervisor_term_870d:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8710
    defw supervisor_term_8710
supervisor_term_8710:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8716
    defw supervisor_term_8716
supervisor_term_8713:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8722
    defw supervisor_term_8722
supervisor_term_8716:
    defb TERM_TAG_CONSTANT    ; constant 'READ'
    defw read_value_cell
supervisor_term_8719:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_871c
    defw supervisor_term_871c
supervisor_term_871c:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V0
    defw 00000h
supervisor_term_871f:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_843d
    defw supervisor_term_843d
supervisor_term_8722:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8728
    defw supervisor_term_8728
supervisor_term_8725:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_872e
    defw supervisor_term_872e
supervisor_term_8728:
    defb TERM_TAG_CONSTANT    ; constant 'READ'
    defw read_value_cell
supervisor_term_872b:
    defb TERM_TAG_LIST    ; list/pair link -> 085fch
    defw 085fch
supervisor_term_872e:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8734
    defw supervisor_term_8734
supervisor_term_8731:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_8734:
    defb TERM_TAG_CONSTANT    ; constant 'CRMOD'
    defw 07729h
supervisor_term_8737:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_873a
    defw supervisor_term_873a
supervisor_term_873a:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V1
    defw 00003h
supervisor_term_873d:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8740
    defw supervisor_term_8740
supervisor_term_8740:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V2
    defw 00006h
supervisor_term_8743:
    defb TERM_TAG_LIST    ; list/pair link -> 0853fh
    defw 0853fh
supervisor_term_8746:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_874c
    defw supervisor_term_874c
supervisor_term_8749:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_874c:
    defb TERM_TAG_INTEGER    ; integer/local-count 3
    defw 00003h
supervisor_term_874f:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8752
    defw supervisor_term_8752
supervisor_term_8752:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8758
    defw supervisor_term_8758
supervisor_term_8755:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88eb
    defw supervisor_term_88eb
supervisor_term_8758:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V2
    defw 00006h
supervisor_term_875b:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88e5
    defw supervisor_term_88e5

; -----------------------------------------------------------------------------
; Permanent supervisor relation SAVE
; -----------------------------------------------------------------------------
; SAVE creates the destination, sends the requested relation/module list through LISTP,
; then closes the file so the final EOF marker and partial tape block are flushed.
; ----------------------------------------------------------------------------
; SAVE composes three existing relations: CREATE, LISTP and CLOSE.  Because LISTP
; already understands compiled clauses and the file layer is callback-based, no
; dedicated native save engine is required.
;
supervisor_save_constant_entry:
    defb TERM_TAG_CONSTANT    ; constant 'SAVE'
    defw supervisor_save_value_cell
supervisor_term_8761:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_list_constant_entry
    defw supervisor_list_constant_entry
supervisor_save_value_cell:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_876c
    defw supervisor_term_876c
supervisor_save_name:
    defb 053h,041h,056h,045h,0ffh    ; "SAVE"
supervisor_term_876c:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8772
    defw supervisor_term_8772
supervisor_term_876f:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_8772:
    defb TERM_TAG_INTEGER    ; integer/local-count 2
    defw 00002h
supervisor_term_8775:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8778
    defw supervisor_term_8778
supervisor_term_8778:
    defb TERM_TAG_LIST    ; list/pair link -> 084fdh
    defw 084fdh
supervisor_term_877b:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_877e
    defw supervisor_term_877e
supervisor_term_877e:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8784
    defw supervisor_term_8784
supervisor_term_8781:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_878a
    defw supervisor_term_878a
supervisor_term_8784:
    defb TERM_TAG_CONSTANT    ; constant 'CREATE'
    defw create_value_cell
supervisor_term_8787:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88af
    defw supervisor_term_88af
supervisor_term_878a:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8790
    defw supervisor_term_8790
supervisor_term_878d:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8796
    defw supervisor_term_8796
supervisor_term_8790:
    defb TERM_TAG_CONSTANT    ; constant 'LISTP'
    defw listp_value_cell
supervisor_term_8793:
    defb TERM_TAG_LIST    ; list/pair link -> 084fdh
    defw 084fdh
supervisor_term_8796:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_879c
    defw supervisor_term_879c
supervisor_term_8799:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_879c:
    defb TERM_TAG_CONSTANT    ; constant 'CLOSE'
    defw close_value_cell
supervisor_term_879f:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88af
    defw supervisor_term_88af

; -----------------------------------------------------------------------------
; Permanent supervisor relation LIST
; -----------------------------------------------------------------------------
; LIST ALL cuts to the all-program path; the general clause forwards its argument to LISTP.
supervisor_list_constant_entry:
    defb TERM_TAG_CONSTANT    ; constant 'LIST'
    defw supervisor_list_value_cell
supervisor_term_87a5:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_all_constant_entry
    defw supervisor_all_constant_entry
supervisor_list_value_cell:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_87bd
    defw supervisor_term_87bd
supervisor_list_name:
    defb 04ch,049h,053h,054h,0ffh    ; "LIST"

; -----------------------------------------------------------------------------
; Permanent supervisor relation ALL
; -----------------------------------------------------------------------------
; ALL is a marker constant with no clauses.
supervisor_all_constant_entry:
    defb TERM_TAG_CONSTANT    ; constant 'ALL'
    defw supervisor_all_value_cell
supervisor_term_87b3:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_query_constant_entry
    defw supervisor_query_constant_entry
supervisor_all_value_cell:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_all_name:
    defb 041h,04ch,04ch,0ffh    ; "ALL"
supervisor_term_87bd:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_87c3
    defw supervisor_term_87c3
supervisor_term_87c0:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_87ed
    defw supervisor_term_87ed
supervisor_term_87c3:
    defb TERM_TAG_INTEGER    ; integer/local-count 0
    defw 00000h
supervisor_term_87c6:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_87c9
    defw supervisor_term_87c9
supervisor_term_87c9:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_87cf
    defw supervisor_term_87cf
supervisor_term_87cc:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_87d5
    defw supervisor_term_87d5
supervisor_term_87cf:
    defb TERM_TAG_CONSTANT    ; constant 'ALL'
    defw supervisor_all_value_cell
supervisor_term_87d2:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_87d5:
    defb TERM_TAG_CONSTANT    ; constant '/'
    defw slash_value_cell
supervisor_term_87d8:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_87db
    defw supervisor_term_87db
supervisor_term_87db:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_87e1
    defw supervisor_term_87e1
supervisor_term_87de:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_87e1:
    defb TERM_TAG_CONSTANT    ; constant 'LISTP'
    defw listp_value_cell
supervisor_term_87e4:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_87e7
    defw supervisor_term_87e7
supervisor_term_87e7:
    defb TERM_TAG_CONSTANT    ; constant 'CON:'
    defw con_file_descriptor
supervisor_term_87ea:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_87ed:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_87f3
    defw supervisor_term_87f3
supervisor_term_87f0:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_87f3:
    defb TERM_TAG_INTEGER    ; integer/local-count 1
    defw 00001h
supervisor_term_87f6:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_87f9
    defw supervisor_term_87f9
supervisor_term_87f9:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88af
    defw supervisor_term_88af
supervisor_term_87fc:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_87ff
    defw supervisor_term_87ff
supervisor_term_87ff:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8805
    defw supervisor_term_8805
supervisor_term_8802:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_8805:
    defb TERM_TAG_CONSTANT    ; constant 'LISTP'
    defw listp_value_cell
supervisor_term_8808:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_880b
    defw supervisor_term_880b
supervisor_term_880b:
    defb TERM_TAG_CONSTANT    ; constant 'CON:'
    defw con_file_descriptor
supervisor_term_880e:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88af
    defw supervisor_term_88af

; -----------------------------------------------------------------------------
; Permanent supervisor relation ?
; -----------------------------------------------------------------------------
; The query relation replaces its body with the supplied goal list.
; Meta-body trace: `?((P a)(Q a))`
; ---------------------------------
; The permanent query clause is effectively `((? X)|X)`.  Unification binds X to
; the supplied two-goal list.  Because X is the tail of the clause body, entering
; the selected clause installs that list itself as EXEC_CURRENT_GOALS:
;
;       first execute (P a), then execute (Q a)
;
; No separate evaluator is called; the ordinary body-entry mechanism accepts a
; runtime-supplied list of atoms.
supervisor_query_constant_entry:
    defb TERM_TAG_CONSTANT    ; constant '?'
    defw supervisor_query_value_cell
supervisor_term_8814:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_main_constant_entry
    defw supervisor_main_constant_entry
supervisor_query_value_cell:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_881c
    defw supervisor_term_881c
supervisor_query_name:
    defb 03fh,0ffh    ; "?"
supervisor_term_881c:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8822
    defw supervisor_term_8822
supervisor_term_881f:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_8822:
    defb TERM_TAG_INTEGER    ; integer/local-count 1
    defw 00001h
supervisor_term_8825:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8828
    defw supervisor_term_8828
supervisor_term_8828:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88af
    defw supervisor_term_88af
supervisor_term_882b:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V0
    defw 00000h

; -----------------------------------------------------------------------------
; Permanent supervisor relation <SUP>
; -----------------------------------------------------------------------------
; The permanent supervisor loop prints the current module prompt, reads one term,
; dispatches it through <>, cuts the selected action, and tail-recurses.
; ----------------------------------------------------------------------------
; <SUP> IS THE READ-EVAL LOOP
; ----------------------------------------------------------------------------
;
; It prints the current module prompt, reads one term, dispatches it through the
; private <> relation, cuts away alternative command interpretations, and calls
; itself again.  Restarting the interpreter merely selects this permanent
; relation as the root goal.
;
supervisor_main_constant_entry:
    defb TERM_TAG_CONSTANT    ; constant '<SUP>'
    defw supervisor_main_value_cell
supervisor_term_8831:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_dispatch_constant_entry
    defw supervisor_dispatch_constant_entry
supervisor_main_value_cell:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_883d
    defw supervisor_term_883d
supervisor_main_name:
    defb 03ch,053h,055h,050h,03eh,0ffh    ; "<SUP>"
supervisor_term_883d:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8843
    defw supervisor_term_8843
supervisor_term_8840:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_8843:
    defb TERM_TAG_INTEGER    ; integer/local-count 2
    defw 00002h
supervisor_term_8846:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8849
    defw supervisor_term_8849
supervisor_term_8849:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_main_goal_stream:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_884f
    defw supervisor_term_884f
supervisor_term_884f:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8855
    defw supervisor_term_8855
supervisor_term_8852:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_885b
    defw supervisor_term_885b
supervisor_term_8855:
    defb TERM_TAG_CONSTANT    ; constant 'CMOD'
    defw cmod_value_cell
supervisor_term_8858:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8485
    defw supervisor_term_8485
supervisor_term_885b:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8861
    defw supervisor_term_8861
supervisor_term_885e:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8867
    defw supervisor_term_8867
supervisor_term_8861:
    defb TERM_TAG_CONSTANT    ; constant 'P'
    defw supervisor_print_value_cell
supervisor_term_8864:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8485
    defw supervisor_term_8485
supervisor_term_8867:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_886d
    defw supervisor_term_886d
supervisor_term_886a:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8873
    defw supervisor_term_8873
supervisor_term_886d:
    defb TERM_TAG_CONSTANT    ; constant 'R'
    defw supervisor_read_value_cell
supervisor_term_8870:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88af
    defw supervisor_term_88af
supervisor_term_8873:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8879
    defw supervisor_term_8879
supervisor_term_8876:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_887f
    defw supervisor_term_887f
supervisor_term_8879:
    defb TERM_TAG_CONSTANT    ; constant '<>'
    defw supervisor_dispatch_value_cell
supervisor_term_887c:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88af
    defw supervisor_term_88af
supervisor_term_887f:
    defb TERM_TAG_CONSTANT    ; constant '/'
    defw slash_value_cell
supervisor_term_8882:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8885
    defw supervisor_term_8885
supervisor_term_8885:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_888b
    defw supervisor_term_888b
supervisor_term_8888:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_888b:
    defb TERM_TAG_CONSTANT    ; constant '<SUP>'
    defw supervisor_main_value_cell
supervisor_term_888e:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh

; -----------------------------------------------------------------------------
; Permanent supervisor relation <>
; -----------------------------------------------------------------------------
; Top-level input dispatcher: constants become unary commands, lists become clauses,
; and all other or failed inputs print the question-mark response.
; ----------------------------------------------------------------------------
; <> classifies top-level input using ordinary clauses:
;
;   a constant     read one more term and call it as a unary command
;   a list         add it as a clause
;   anything else print ?
;
; This small program is why new unary relations automatically become supervisor
; commands without changing native Z80.
;
; Three top-level input traces
; ----------------------------
; 1. Command input: `LIST Parent`
;       first term is constant LIST -> read one more term -> call (LIST Parent)
;
; 2. Clause input: `((Parent Mary John))`
;       first term is a LIST -> call ADDCL with that clause
;
; 3. Invalid top-level atom: `123`
;       neither command constant nor clause list -> PP `?`
;
; The three permanent <> clauses below encode exactly these alternatives in this
; order.
supervisor_dispatch_constant_entry:
    defb TERM_TAG_CONSTANT    ; constant '<>'
    defw supervisor_dispatch_value_cell
supervisor_term_8894:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_dict_constant_entry
    defw supervisor_dict_constant_entry
supervisor_dispatch_value_cell:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_889d
    defw supervisor_term_889d
supervisor_dispatch_name:
    defb 03ch,03eh,0ffh    ; "<>"
supervisor_term_889d:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88a3
    defw supervisor_term_88a3
supervisor_term_88a0:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88d3
    defw supervisor_term_88d3
supervisor_term_88a3:
    defb TERM_TAG_INTEGER    ; integer/local-count 2
    defw 00002h
supervisor_term_88a6:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88a9
    defw supervisor_term_88a9
supervisor_term_88a9:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88af
    defw supervisor_term_88af
supervisor_term_88ac:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88b5
    defw supervisor_term_88b5
supervisor_term_88af:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V0
    defw 00000h
supervisor_term_88b2:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_88b5:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88bb
    defw supervisor_term_88bb
supervisor_term_88b8:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88c1
    defw supervisor_term_88c1
supervisor_term_88bb:
    defb TERM_TAG_CONSTANT    ; constant 'CON'
    defw con_value_cell
supervisor_term_88be:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88af
    defw supervisor_term_88af
supervisor_term_88c1:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88c7
    defw supervisor_term_88c7
supervisor_term_88c4:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88cd
    defw supervisor_term_88cd
supervisor_term_88c7:
    defb TERM_TAG_CONSTANT    ; constant 'R'
    defw supervisor_read_value_cell
supervisor_term_88ca:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8485
    defw supervisor_term_8485
supervisor_term_88cd:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_847f
    defw supervisor_term_847f
supervisor_term_88d0:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_88d3:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88d9
    defw supervisor_term_88d9
supervisor_term_88d6:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88f7
    defw supervisor_term_88f7
supervisor_term_88d9:
    defb TERM_TAG_INTEGER    ; integer/local-count 2
    defw 00002h
supervisor_term_88dc:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88df
    defw supervisor_term_88df
supervisor_term_88df:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88e5
    defw supervisor_term_88e5
supervisor_term_88e2:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88eb
    defw supervisor_term_88eb
supervisor_term_88e5:
    defb TERM_TAG_LIST    ; list/pair link -> 084fdh
    defw 084fdh
supervisor_term_88e8:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_88eb:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88f1
    defw supervisor_term_88f1
supervisor_term_88ee:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_88f1:
    defb TERM_TAG_CONSTANT    ; constant 'ADDCL'
    defw addcl_value_cell
supervisor_term_88f4:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88e5
    defw supervisor_term_88e5
supervisor_term_88f7:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88fd
    defw supervisor_term_88fd
supervisor_term_88fa:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_88fd:
    defb TERM_TAG_INTEGER    ; integer/local-count 1
    defw 00001h
supervisor_term_8900:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8903
    defw supervisor_term_8903
supervisor_term_8903:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88af
    defw supervisor_term_88af
supervisor_term_8906:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8909
    defw supervisor_term_8909
supervisor_term_8909:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_890f
    defw supervisor_term_890f
supervisor_term_890c:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_890f:
    defb TERM_TAG_CONSTANT    ; constant 'PP'
    defw supervisor_print_readable_value_cell
supervisor_term_8912:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8915
    defw supervisor_term_8915
supervisor_term_8915:
    defb TERM_TAG_CONSTANT    ; constant '?'
    defw supervisor_query_value_cell
supervisor_term_8918:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh

; -----------------------------------------------------------------------------
; Permanent supervisor relation DICT
; -----------------------------------------------------------------------------
; DICT is backed directly by the mutable current-module workspace object, so listings
; and calls always observe the live export/import/local dictionaries.
supervisor_dict_constant_entry:
    defb TERM_TAG_CONSTANT    ; constant 'DICT'
    defw supervisor_dict_value_cell
supervisor_term_891e:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_read_constant_entry
    defw supervisor_read_constant_entry
supervisor_dict_value_cell:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8929
    defw supervisor_term_8929
supervisor_dict_name:
    defb 044h,049h,043h,054h,0ffh    ; "DICT"
supervisor_term_8929:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_892f
    defw supervisor_term_892f
supervisor_term_892c:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_892f:
    defb TERM_TAG_INTEGER    ; integer/local-count 0
    defw 00000h
supervisor_term_8932:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8935
    defw supervisor_term_8935
supervisor_term_8935:
    defb TERM_TAG_LIST    ; list/pair link -> MODULE_CURRENT_CELL
    defw MODULE_CURRENT_CELL
supervisor_term_8938:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
root_module_descriptor:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_893e:
    defb TERM_TAG_LIST    ; list/pair link -> 09a93h
    defw 09a93h

; -----------------------------------------------------------------------------
; Permanent supervisor relation R
; -----------------------------------------------------------------------------
; R is the console READ wrapper.
supervisor_read_constant_entry:
    defb TERM_TAG_CONSTANT    ; constant 'R'
    defw supervisor_read_value_cell
supervisor_term_8944:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_print_constant_entry
    defw supervisor_print_constant_entry
supervisor_read_value_cell:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_894c
    defw supervisor_term_894c
supervisor_read_name:
    defb 052h,0ffh    ; "R"
supervisor_term_894c:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8952
    defw supervisor_term_8952
supervisor_term_894f:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_8952:
    defb TERM_TAG_INTEGER    ; integer/local-count 1
    defw 00001h
supervisor_term_8955:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8958
    defw supervisor_term_8958
supervisor_term_8958:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88af
    defw supervisor_term_88af
supervisor_term_895b:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_895e
    defw supervisor_term_895e
supervisor_term_895e:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8964
    defw supervisor_term_8964
supervisor_term_8961:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_8964:
    defb TERM_TAG_CONSTANT    ; constant 'READ'
    defw read_value_cell
supervisor_term_8967:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_896a
    defw supervisor_term_896a
supervisor_term_896a:
    defb TERM_TAG_CONSTANT    ; constant 'CON:'
    defw con_file_descriptor
supervisor_term_896d:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88af
    defw supervisor_term_88af

; -----------------------------------------------------------------------------
; Permanent supervisor relation P
; -----------------------------------------------------------------------------
; P is the raw console-output wrapper around W.
supervisor_print_constant_entry:
    defb TERM_TAG_CONSTANT    ; constant 'P'
    defw supervisor_print_value_cell
supervisor_term_8973:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_print_readable_constant_entry
    defw supervisor_print_readable_constant_entry
supervisor_print_value_cell:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_897b
    defw supervisor_term_897b
supervisor_print_name:
    defb 050h,0ffh    ; "P"
supervisor_term_897b:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8981
    defw supervisor_term_8981
supervisor_term_897e:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_8981:
    defb TERM_TAG_INTEGER    ; integer/local-count 1
    defw 00001h
supervisor_term_8984:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8987
    defw supervisor_term_8987
supervisor_term_8987:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V0
    defw 00000h
supervisor_term_898a:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_898d
    defw supervisor_term_898d
supervisor_term_898d:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8993
    defw supervisor_term_8993
supervisor_term_8990:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_8993:
    defb TERM_TAG_CONSTANT    ; constant 'W'
    defw w_value_cell
supervisor_term_8996:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_89c3
    defw supervisor_term_89c3

; -----------------------------------------------------------------------------
; Permanent supervisor relation PP
; -----------------------------------------------------------------------------
; PP is the readable console-output wrapper around WRITE.
supervisor_print_readable_constant_entry:
    defb TERM_TAG_CONSTANT    ; constant 'PP'
    defw supervisor_print_readable_value_cell
supervisor_term_899c:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_once_constant_entry
    defw supervisor_once_constant_entry
supervisor_print_readable_value_cell:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_89a5
    defw supervisor_term_89a5
supervisor_print_readable_name:
    defb 050h,050h,0ffh    ; "PP"
supervisor_term_89a5:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_89ab
    defw supervisor_term_89ab
supervisor_term_89a8:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_89ab:
    defb TERM_TAG_INTEGER    ; integer/local-count 1
    defw 00001h
supervisor_term_89ae:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_89b1
    defw supervisor_term_89b1
supervisor_term_89b1:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V0
    defw 00000h
supervisor_term_89b4:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_89b7
    defw supervisor_term_89b7
supervisor_term_89b7:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_89bd
    defw supervisor_term_89bd
supervisor_term_89ba:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_89bd:
    defb TERM_TAG_CONSTANT    ; constant 'WRITE'
    defw write_value_cell
supervisor_term_89c0:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_89c3
    defw supervisor_term_89c3
supervisor_term_89c3:
    defb TERM_TAG_CONSTANT    ; constant 'CON:'
    defw con_file_descriptor
supervisor_term_89c6:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88af
    defw supervisor_term_88af

; -----------------------------------------------------------------------------
; Permanent supervisor relation !
; -----------------------------------------------------------------------------
; ! executes its meta-call and then cuts away further solutions.
supervisor_once_constant_entry:
    defb TERM_TAG_CONSTANT    ; constant '!'
    defw supervisor_once_value_cell
supervisor_term_89cc:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_isall_constant_entry
    defw supervisor_isall_constant_entry
supervisor_once_value_cell:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_89d4
    defw supervisor_term_89d4
supervisor_once_name:
    defb 021h,0ffh    ; "!"
supervisor_term_89d4:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_89da
    defw supervisor_term_89da
supervisor_term_89d7:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_89da:
    defb TERM_TAG_INTEGER    ; integer/local-count 1
    defw 00001h
supervisor_term_89dd:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_89e0
    defw supervisor_term_89e0
supervisor_term_89e0:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V0
    defw 00000h
supervisor_term_89e3:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_89e6
    defw supervisor_term_89e6
supervisor_term_89e6:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V0
    defw 00000h
supervisor_term_89e9:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_89ec
    defw supervisor_term_89ec
supervisor_term_89ec:
    defb TERM_TAG_CONSTANT    ; constant '/'
    defw slash_value_cell
supervisor_term_89ef:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_89f2:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V3
    defw 00009h
supervisor_term_89f5:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_89f8
    defw supervisor_term_89f8
supervisor_term_89f8:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V4
    defw 0000ch
supervisor_term_89fb:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_89fe
    defw supervisor_term_89fe
supervisor_term_89fe:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V5
    defw 0000fh
supervisor_term_8a01:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V6
    defw 00012h

; -----------------------------------------------------------------------------
; Permanent supervisor relation ISALL
; -----------------------------------------------------------------------------
; ISALL uses the private fresh-copy relation and a mutable accumulator to collect every
; solution in reverse discovery order while leaving query variables unbound afterward.
supervisor_isall_constant_entry:
    defb TERM_TAG_CONSTANT    ; constant 'ISALL'
    defw supervisor_isall_value_cell
supervisor_term_8a07:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_forall_constant_entry
    defw supervisor_forall_constant_entry
supervisor_isall_value_cell:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8a13
    defw supervisor_term_8a13
supervisor_isall_name:
    defb 049h,053h,041h,04ch,04ch,0ffh    ; "ISALL"
supervisor_term_8a13:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8a19
    defw supervisor_term_8a19
supervisor_term_8a16:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_8a19:
    defb TERM_TAG_INTEGER    ; integer/local-count 4
    defw 00004h
supervisor_term_8a1c:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8a1f
    defw supervisor_term_8a1f
supervisor_term_8a1f:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8a25
    defw supervisor_term_8a25
supervisor_term_8a22:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8a31
    defw supervisor_term_8a31
supervisor_term_8a25:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V2
    defw 00006h
supervisor_term_8a28:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8a2b
    defw supervisor_term_8a2b
supervisor_term_8a2b:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V0
    defw 00000h
supervisor_term_8a2e:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V1
    defw 00003h
supervisor_term_8a31:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8a37
    defw supervisor_term_8a37
supervisor_term_8a34:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_8a37:
    defb TERM_TAG_CONSTANT    ; constant 'OR'
    defw supervisor_or_value_cell
supervisor_term_8a3a:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8a3d
    defw supervisor_term_8a3d
supervisor_term_8a3d:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8a49
    defw supervisor_term_8a49
supervisor_term_8a40:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8a43
    defw supervisor_term_8a43
supervisor_term_8a43:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8a85
    defw supervisor_term_8a85
supervisor_term_8a46:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_8a49:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8a4f
    defw supervisor_term_8a4f
supervisor_term_8a4c:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8a5b
    defw supervisor_term_8a5b
supervisor_term_8a4f:
    defb TERM_TAG_CONSTANT    ; constant 'Î'
    defw internal_fresh_copy_value_cell
supervisor_term_8a52:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8a55
    defw supervisor_term_8a55
supervisor_term_8a55:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V3
    defw 00009h
supervisor_term_8a58:
    defb TERM_TAG_LIST    ; list/pair link -> permanent_empty_list
    defw permanent_empty_list
supervisor_term_8a5b:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8a61
    defw supervisor_term_8a61
supervisor_term_8a5e:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8a67
    defw supervisor_term_8a67
supervisor_term_8a61:
    defb TERM_TAG_CONSTANT    ; constant '?'
    defw supervisor_query_value_cell
supervisor_term_8a64:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8485
    defw supervisor_term_8485
supervisor_term_8a67:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8a6d
    defw supervisor_term_8a6d
supervisor_term_8a6a:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_83d7
    defw supervisor_term_83d7
supervisor_term_8a6d:
    defb TERM_TAG_CONSTANT    ; constant 'Î'
    defw internal_fresh_copy_value_cell
supervisor_term_8a70:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8a73
    defw supervisor_term_8a73
supervisor_term_8a73:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V3
    defw 00009h
supervisor_term_8a76:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8a79
    defw supervisor_term_8a79
supervisor_term_8a79:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8a7f
    defw supervisor_term_8a7f
supervisor_term_8a7c:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_8a7f:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V0
    defw 00000h
supervisor_term_8a82:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V3
    defw 00009h
supervisor_term_8a85:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8a8b
    defw supervisor_term_8a8b
supervisor_term_8a88:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_8a8b:
    defb TERM_TAG_CONSTANT    ; constant 'EQ'
    defw supervisor_eq_value_cell
supervisor_term_8a8e:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8a91
    defw supervisor_term_8a91
supervisor_term_8a91:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V2
    defw 00006h
supervisor_term_8a94:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8a97
    defw supervisor_term_8a97
supervisor_term_8a97:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V3
    defw 00009h
supervisor_term_8a9a:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh

; -----------------------------------------------------------------------------
; Permanent supervisor relation FORALL
; -----------------------------------------------------------------------------
; FORALL is encoded as negation of a counterexample: NOT (? X, NOT ? Y).
supervisor_forall_constant_entry:
    defb TERM_TAG_CONSTANT    ; constant 'FORALL'
    defw supervisor_forall_value_cell
supervisor_term_8aa0:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_forall_value_cell:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8aad
    defw supervisor_term_8aad
supervisor_forall_name:
    defb 046h,04fh,052h,041h,04ch,04ch,0ffh    ; "FORALL"
supervisor_term_8aad:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8ab3
    defw supervisor_term_8ab3
supervisor_term_8ab0:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_8ab3:
    defb TERM_TAG_INTEGER    ; integer/local-count 2
    defw 00002h
supervisor_term_8ab6:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8ab9
    defw supervisor_term_8ab9
supervisor_term_8ab9:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_847f
    defw supervisor_term_847f
supervisor_term_8abc:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8abf
    defw supervisor_term_8abf
supervisor_term_8abf:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8ac5
    defw supervisor_term_8ac5
supervisor_term_8ac2:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_8ac5:
    defb TERM_TAG_CONSTANT    ; constant 'NOT'
    defw supervisor_not_value_cell
supervisor_term_8ac8:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8acb
    defw supervisor_term_8acb
supervisor_term_8acb:
    defb TERM_TAG_CONSTANT    ; constant '?'
    defw supervisor_query_value_cell
supervisor_term_8ace:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8ad1
    defw supervisor_term_8ad1
supervisor_term_8ad1:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8ad7
    defw supervisor_term_8ad7
supervisor_term_8ad4:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_8ad7:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8add
    defw supervisor_term_8add
supervisor_term_8ada:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8ae3
    defw supervisor_term_8ae3
supervisor_term_8add:
    defb TERM_TAG_CONSTANT    ; constant '?'
    defw supervisor_query_value_cell
supervisor_term_8ae0:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_88af
    defw supervisor_term_88af
supervisor_term_8ae3:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8ae9
    defw supervisor_term_8ae9
supervisor_term_8ae6:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_8ae9:
    defb TERM_TAG_CONSTANT    ; constant 'NOT'
    defw supervisor_not_value_cell
supervisor_term_8aec:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8a61
    defw supervisor_term_8a61
; Cold-start dependency
; ---------------------
; This permanent clause contains a template atom whose relation-value pointer is
; patched during cold_start in module 12 to the canonical `?ERROR?` dictionary
; cell.  The graph is immutable in shape but its workspace copy receives the
; live pointer, allowing user code to replace the relation definition without
; rebuilding the adapter.
; Error-routing trace
; -------------------
; Suppose native code raises error N while goal G is current.
; 1. Restore the protected native stack and normal console callbacks.
; 2. Select the permanent adapter clause and initialize its local error-number
;    cell with N while preserving the current goal term G.
; 3. Unify/call the interned `?ERROR?` relation with the error context.
; 4. If a user handler exists, ordinary clause execution runs it.
; 5. Otherwise the adapter/fallback prints `Error:  N`, newline, and restarts the
;    supervisor.  Native stack recovery occurs before any Prolog-level handler.
error_handler_adapter_clause:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8af2
    defw supervisor_term_8af2
supervisor_term_8af2:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8af8
    defw supervisor_term_8af8
supervisor_term_8af5:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
supervisor_term_8af8:
    defb TERM_TAG_INTEGER    ; integer/local-count 2
    defw 00002h
supervisor_term_8afb:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8afe
    defw supervisor_term_8afe
supervisor_term_8afe:
    defb TERM_TAG_RELATIVE_REFERENCE    ; relative variable V1
    defw 00003h
supervisor_term_8b01:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_8b04
    defw supervisor_term_8b04
supervisor_term_8b04:
    defb TERM_TAG_LIST    ; list/pair link -> GC_ERROR_HANDLER_ROOT
    defw GC_ERROR_HANDLER_ROOT
supervisor_term_8b07:
    defb TERM_TAG_END    ; END / empty-list sentinel
    defw 0ffffh
error_handler_root_template:
    defb TERM_TAG_CONSTANT    ; constant '@0000'
    defw 00000h
supervisor_term_8b0d:
    defb TERM_TAG_LIST    ; list/pair link -> supervisor_term_847f
    defw supervisor_term_847f

; Named module object for the permanent workspace module.  As with every
; dictionary constant, the stored name follows its three-byte value cell.
root_module_object:
    defb TERM_TAG_MODULE
    defw root_module_descriptor
root_module_name:
    defb 026h,DICTIONARY_STORED_TERMINATOR    ; "&"
