; -----------------------------------------------------------------------------
; Architectural module: 03_garbage_collector.asm
; Non-moving mark-and-collect garbage collector and generic list walking.
; Original monolithic line range: 1890-2363.
; Emitted address range: 0x6713-0x6992.
; -----------------------------------------------------------------------------

; ============================================================================
; CHAPTER 3 — A NON-MOVING COLLECTOR FOR A POINTER-RICH LANGUAGE
; ============================================================================
;
; At first glance a compacting collector would seem attractive on a 48K
; machine.  micro-PROLOG chooses the opposite trade-off: live objects never
; move.  Stable addresses simplify variable references, dictionary values,
; execution frames, trail nodes and compiled terms.  The cost is an intrusive
; free list for holes left between live objects.
;
; Collection has five visible acts:
;
;   1. mark roots in every execution frame and fixed interpreter structure;
;   2. filter the trail, retaining only nodes that still matter;
;   3. repair frame trail boundaries after that filtering;
;   4. prune weak dictionary entries and mark reachable term graphs;
;   5. trim dead edge objects and thread interior garbage into the free list.
;
; Bit 7 of each tag is borrowed as the mark.  Sweep clears it again, so normal
; execution never pays for a separate mark bitmap.
;
; Six-object collection example
; -----------------------------
; Imagine the downward heap contains six objects, H0 nearest the execution gap:
;
;       low address                                      high address
;       H0(dead) H1(live) H2(dead) H3(live) H4(dead) H5(dead edge)
;
; Roots reach H1 and H3.  Collection performs:
;
;       mark H1, H3
;       trim H5 and then H4 from the heap edge
;       keep H3 at its original address
;       thread interior H2 into the free-object list
;       keep H1 at its original address
;       trim H0 only when it lies at the new low edge; otherwise thread it too
;       clear mark bits on H1 and H3
;
; No pointer is rewritten.  Edge garbage enlarges the contiguous gap; interior
; garbage becomes reusable six-byte nodes.
; Complete collector pseudocode
; -----------------------------
; mark every local in every physically allocated frame
; mark fixed roots: hot goals/body, error root, modules, dictionaries, arg slots
; filter trail:
;     keep nodes whose target is fixed execution storage or marked live heap
;     unlink neutralized/dead-target nodes
; repair every frame.SAVED_TRAIL which named a removed node
; prune weak dynamic dictionary entries not reached by any live term
; trim consecutive dead objects from the low heap edge by moving HEAP_CURSOR
; sweep remaining heap objects:
;     live -> clear mark, leave at same address
;     garbage object -> thread six-byte object into intrusive free list
; count contiguous and free-list bytes and set next 75-percent GC threshold
garbage_collect:
    push af
    push hl
    push de
    push bc
    push ix
    ; Mark every local environment in physical allocation order, not merely the
    ; logical caller chain.  Suspended alternatives can be absent from the caller
    ; chain but still own locals referenced by their saved goals and trail state.
    ld ix,(EXEC_FRAME_TOP)
; ----------------------------------------------------------------------------
; PHYSICAL FRAMES, NOT MERELY CALLERS
; ----------------------------------------------------------------------------
;
; A suspended choice frame may no longer lie on the logical caller chain, but it
; still owns locals and a retry continuation.  The collector therefore walks
; frames by physical layout: each frame's local base tells how many local cells
; precede it and where the previous physical frame ends.
;
; Every local is a possible root.  So are the currently selected head/body,
; active goals, module dictionaries and occupied primitive argument slots.
;
; "Physical frame" means the contiguous allocation sequence recovered from each
; frame's LOCAL_BASE and the fixed twelve-byte frame size.  This traversal does
; not follow logical CALLER links and does not follow PREVIOUS_CHOICE links;
; suspended frames can own live locals even when absent from either ancestry.
.gc_mark_next_physical_frame:
    ; EXEC_FRAME_LOCAL_BASE points to the first local cell.  The byte distance
    ; from that base to IX is exactly three times the local-variable count.
    ld e,(ix+EXEC_FRAME_LOCAL_BASE)
    ld d,(ix+EXEC_FRAME_LOCAL_BASE+1)
    push ix
    pop hl
    or a
    sbc hl,de
    jr z,.gc_advance_to_previous_physical_frame
    ; The distance is below 256 bytes by construction.  B holds the byte count;
    ; subtracting two explicitly and one via DJNZ advances one three-byte cell.
    ld b,l
    ex de,hl
.gc_mark_next_local_cell:
    ; HL is one local cell.  gc_mark_term_graph follows only dynamic-arena
    ; references, so static clauses and dictionary templates are not modified.
    push bc
    call gc_mark_term_graph
    pop bc
    inc hl
    inc hl
    inc hl
    dec b
    dec b
    djnz .gc_mark_next_local_cell
.gc_advance_to_previous_physical_frame:
    push ix
    pop de
    ld hl,(EXEC_ROOT_FRAME)
    or a
    sbc hl,de
    jr z,.gc_mark_fixed_roots
    ld e,(ix+EXEC_FRAME_LOCAL_BASE)
    ld d,(ix+EXEC_FRAME_LOCAL_BASE+1)
    ; The preceding physical frame lies twelve bytes below this frame's local base.
    ld ix,-EXEC_FRAME_SIZE
    add ix,de
    jr .gc_mark_next_physical_frame
.gc_mark_fixed_roots:
    ; Hot execution roots can point into heap values even when no frame local
    ; currently names them.  Mark them before examining the module registries.
    ld hl,(EXEC_CURRENT_GOALS)
    call gc_mark_term_graph
    ld hl,(EXEC_SELECTED_BODY)
    call gc_mark_term_graph
    ld hl,GC_ERROR_HANDLER_ROOT
    call gc_mark_term_graph
    ; The two dictionary/module registries are proper lists.  Install the GC
    ; callback in the generic JP trampoline and visit every registered object.
    ld hl,gc_mark_module_callback
    ld (LIST_WALK_CALLBACK_TARGET),hl
    ld hl,GC_DICTIONARY_ROOT_A
    call walk_proper_list_with_callback
    ld hl,GC_DICTIONARY_ROOT_B
    call walk_proper_list_with_callback
    ld hl,(MODULE_CURRENT_OBJECT)
    call gc_mark_module_callback
    ; Primitive dispatch keeps up to eight six-byte argument slots alive while
    ; a built-in handler executes.  0xFF in the first byte denotes an unused slot.
    ld b,008h
    ld de,00006h
    ld hl,09807h
.gc_mark_next_primitive_argument:
    ld a,(hl)
    cp 0ffh
    jr z,.gc_begin_trail_filter
    push bc
    call gc_mark_term_graph
    pop bc
; ----------------------------------------------------------------------------
; THE TRAIL IS BOTH ROOT SET AND GARBAGE
; ----------------------------------------------------------------------------
;
; A retained trail node keeps its target object reachable because rollback may
; need to clear that variable later.  But cut can neutralize a target, and a
; trail node aimed into an otherwise dead heap object no longer serves any
; future choice point.
;
; Filtering is done in place by patching predecessor links around dead nodes.
; No second list is built.  This is why saved trail boundaries in frames need a
; later repair pass: a boundary may have named a node which has just been
; removed.
;
; Trail-filter trace with a dead middle target
; --------------------------------------------
; Before (head first): N3 -> N2 -> N1 -> END
;       N3 targets live execution cell
;       N2 targets unmarked/dead heap object
;       N1 targets marked live heap object
;
; The incoming-link cursor initially names EXEC_TRAIL_HEAD.  N3 is retained and
; marked, so the cursor moves to N3.previous.  N2 is dead, so N3.previous is
; patched directly to N1; the cursor stays at N3.previous in case more dead nodes
; follow.  N1 is retained and marked.  If a frame saved N2 as its boundary, the
; repair pass follows N2.previous to N1 and stores N1 in that frame.
.gc_begin_trail_filter:
    ; This label is also the common slot-advance path.  DE is one six-byte slot.
    add hl,de
    djnz .gc_mark_next_primitive_argument
    ; Filter the trail in place.  BC addresses the link word that must name the
    ; next retained node: initially EXEC_TRAIL_HEAD, later a kept node's +4 link.
    ld hl,(EXEC_TRAIL_HEAD)
    ld bc,EXEC_TRAIL_HEAD
    ld de,permanent_empty_list
.gc_filter_next_trail_node:
    ; A trail node is retained when its target is a fixed execution cell or a
    ; marked live heap cell.  END targets (neutralized by cut) and targets in
    ; unmarked heap objects are bypassed by patching the preceding link word.
    call compare_hl_de_preserving
    jr z,.gc_repair_frame_trail_roots
    ld a,(hl)
    cp 010h
    jr z,.gc_unlink_trail_node
    cp 00ch
    jr z,.gc_keep_trail_node
    cp 001h
    jr z,.gc_test_trail_heap_target
    cp 005h
    call nz,system_abort
.gc_test_trail_heap_target:
    ; ABSOLUTE_REFERENCE and REFERENCE_NEXT_CELL both resolve to the mutated heap
    ; cell.  Its mark bit states whether the containing value survived root marking.
    push hl
    call term_load_payload_hl
    bit TERM_MARK_BIT_INDEX,(hl)
    pop hl
    jr nz,.gc_keep_trail_node
.gc_unlink_trail_node:
    ; Skip this node by copying its previous-node pointer over the incoming link.
    ; BC deliberately remains unchanged so consecutive dead nodes collapse too.
    inc hl
    inc hl
    inc hl
    call term_load_payload_hl
    ld a,l
    ld (bc),a
    inc bc
    ld a,h
    ld (bc),a
    dec bc
    jr .gc_filter_next_trail_node
.gc_keep_trail_node:
    ; Trail nodes are ordinary heap objects.  Mark the first cell so sweeping
    ; preserves all six bytes, then make BC address this node's previous link.
    set TERM_MARK_BIT_INDEX,(hl)
    inc hl
    inc hl
    inc hl
    ld b,h
    ld c,l
    inc bc
    call term_load_payload_hl
    jr .gc_filter_next_trail_node
; Only saved trail-boundary words are repaired here.  LOCAL_BASE, caller links,
; choice links, term references and all live heap addresses remain unchanged.
; That narrow mutation is a direct consequence of the collector being non-moving.
.gc_repair_frame_trail_roots:
    ; Filtering may have removed the exact node saved by a frame.  For every
    ; physical frame, advance its saved boundary to the first retained marked
    ; node (or the permanent empty-list sentinel).
    ld de,(EXEC_ROOT_FRAME)
    ld hl,(EXEC_FRAME_TOP)
.gc_repair_next_frame_trail:
    call compare_hl_de_preserving
    jr z,.gc_begin_sweep
    push hl
    pop ix
    ; Repair only the frame's saved trail boundary.  The local-base field and
    ; the frame itself remain unchanged because this collector never relocates
    ; execution records or live heap objects.
    ld l,(ix+EXEC_FRAME_SAVED_TRAIL)
    ld h,(ix+EXEC_FRAME_SAVED_TRAIL+1)
    ld bc,permanent_empty_list
.gc_follow_dead_trail_prefix:
    ; A retained trail node has bit 7 set by .gc_keep_trail_node.  Unmarked nodes
    ; are no longer linked from EXEC_TRAIL_HEAD but can still be named by an old
    ; frame boundary, so follow their +3 previous-node cell until a live boundary.
    push hl
    or a
    sbc hl,bc
    pop hl
    jr z,.gc_store_repaired_frame_trail
    bit TERM_MARK_BIT_INDEX,(hl)
    jr nz,.gc_store_repaired_frame_trail
    inc hl
    inc hl
    inc hl
    call term_load_payload_hl
    jr .gc_follow_dead_trail_prefix
.gc_store_repaired_frame_trail:
    ld (ix+EXEC_FRAME_SAVED_TRAIL),l
    ld (ix+EXEC_FRAME_SAVED_TRAIL+1),h
    ld c,(ix+EXEC_FRAME_LOCAL_BASE)
    ld b,(ix+EXEC_FRAME_LOCAL_BASE+1)
    ld hl,-EXEC_FRAME_SIZE
    add hl,bc
    jr .gc_repair_next_frame_trail
; ----------------------------------------------------------------------------
; SWEEP WITHOUT RELOCATION
; ----------------------------------------------------------------------------
;
; The heap grows downward.  Dead objects at its low edge form one contiguous
; run, so reclaiming them means advancing TERM_HEAP_CURSOR.  Dead objects inside
; the live range cannot be merged without moving survivors; each becomes a
; six-byte free-list node instead.
;
; The sweep simultaneously clears mark bits on survivors and counts both the
; contiguous gap and interior holes.  Three quarters of the resulting free-byte
; total is added to the execution frontier to set the next collection trigger.
; This avoids collecting on every small allocation while still leaving a safety
; margin before the two arenas collide.
;
; Before/after sweep sketch
; -------------------------
; Low edge -> D0 D1 L2 D3 L4 <- high edge
;              D=dead, L=marked live
;
; Edge trim advances HEAP_CURSOR past D0 and D1.  L2 remains at its exact address
; and has bit 7 cleared.  Interior D3 becomes a six-byte free-list node.  L4
; remains at its address and has its mark cleared.  No surviving pointer changes.
.gc_begin_sweep:
    ; Dictionary constants live in a separate dictionary arena.  Their mark bits
    ; are consumed here: dead constants are deleted from dictionary lists and
    ; their name-storage allocation is returned to the dictionary allocator.
    call gc_prune_dictionary_roots
    ld hl,(TERM_HEAP_CURSOR)
    ld de,00006h
.gc_trim_low_heap_edge:
    ; Heap allocation is downward.  Unmarked objects nearest the stack are simply
    ; dropped by moving TERM_HEAP_CURSOR upward; they need no free-list nodes.
    bit TERM_MARK_BIT_INDEX,(hl)
    jr nz,.gc_sweep_heap_objects
    add hl,de
    jr .gc_trim_low_heap_edge
.gc_sweep_heap_objects:
    ; DE becomes the new low heap boundary.  Sweep from EXEC_ARENA_ORIGIN downward
    ; in exact six-byte objects.  Alternate HL accumulates reclaimed interior bytes.
    ld (TERM_HEAP_CURSOR),hl
    ex de,hl
    ld hl,(EXEC_ARENA_ORIGIN)
    ld bc,FREE_TERM_OBJECT_HEAD
    exx
    push de
    push hl
    ld de,00006h
    ld hl,00000h
    exx
.gc_sweep_next_object:
    ; Move from the high heap edge to the preceding six-byte object.  Marked
    ; objects are kept and unmarked; garbage objects are linked through payload
    ; bytes +1/+2, yielding an intrusive singly linked free-object list.
    dec hl
    dec hl
    dec hl
    dec hl
    dec hl
    dec hl
    push hl
    or a
    sbc hl,de
    pop hl
    jr c,.gc_finish_free_list
    bit TERM_MARK_BIT_INDEX,(hl)
    res TERM_MARK_BIT_INDEX,(hl)
    jr nz,.gc_sweep_next_object
    ld a,l
    ld (bc),a
    ld a,h
    inc bc
    ld (bc),a
    ld b,h
    ld c,l
    inc bc
    exx
    add hl,de
    exx
    jr .gc_sweep_next_object
.gc_finish_free_list:
    ; Terminate the last link word with 0xFFFF.  The alternate-register byte count
    ; plus the contiguous stack/heap gap is the exact total allocatable capacity.
    ld a,0ffh
    ld (bc),a
    inc bc
    ld (bc),a
    exx
    push hl
    ld hl,(TERM_HEAP_CURSOR)
    ld de,(EXEC_ALLOCATION_TOP)
    or a
    sbc hl,de
    pop de
    add hl,de
    ld (TERM_HEAP_FREE_BYTES),hl
    ld d,h
    ld e,l
    srl h
    rr l
    srl h
    rr l
    ex de,hl
    or a
    sbc hl,de
    ld de,(EXEC_ALLOCATION_TOP)
    add hl,de
    ld (TERM_HEAP_COLLECTION_TRIGGER),hl
    pop hl
    pop de
    exx
    pop ix
    pop bc
    pop de
    pop hl
    pop af
    ret
; Mark a reachable term graph rooted at HL.
;
; All traversed dynamic cells use bit 7 as a temporary mark.  Odd tags are
; pointer-bearing term forms and are followed through their payload; CONSTANT
; marks its dictionary descriptor when that descriptor is dynamically allocated;
; FLOAT marks its six-byte value record when it lies in the dynamic arena.
;
; The routine avoids the native Z80 stack for graph recursion.  Instead it pushes
; pending sibling-cell addresses and counts them in B.  Overflow of the 8-bit
; pending count is treated as structural corruption/System Abort.
; ----------------------------------------------------------------------------
; MARKING A GRAPH WITH A VERY SMALL NATIVE STACK
; ----------------------------------------------------------------------------
;
; Terms are graphs, not trees: variables and list tails may share substructure.
; The mark bit prevents revisiting an object and therefore prevents cycles from
; recursing forever.  Atomic cells stop immediately; reference cells follow
; their targets; list objects visit both constituent cells.
;
; The routine is careful to recurse only when the target lies in the dynamic
; arena.  Pointers into permanent program data and fixed workspace are roots or
; immutable leaves, not heap objects to mark.
;
; Reading marked tags safely
; --------------------------
; During the mark phase bit 7 is temporary GC state, not part of the term kind:
;
;       stored_tag = base_tag | 0x80
;       base_tag   = stored_tag & 0x7F
;
; Every structural test in this routine first masks or separately tests that
; bit.  A marked LIST is still a LIST, a marked CONSTANT is still a CONSTANT,
; and a second visit stops recursion rather than reinterpreting the tag.
; Mark-graph pseudocode, including cycles
; --------------------------------------
; mark(term):
;     dereference/locate containing managed object
;     if outside managed arena: return
;     if object.marked: return          ; terminates cycles/rational trees
;     set object.marked                 ; mark before following children
;     for each child reference implied by its tag:
;         mark(child)
;
; Mark-before-descend is essential because micro-PROLOG can construct cyclic
; structures when no occurs check prevents a variable from reaching itself.
gc_mark_term_graph:
    ld b,001h
    push hl
.gc_mark_visit_cell:
    ; Ignore an existing mark in the tag while classifying the term form.
    ld a,(hl)
    res TERM_MARK_BIT_INDEX,a
    bit 0,a                    ; odd tags carry a pointer payload
    jr z,.gc_mark_non_reference_cell
    call term_load_payload_hl
    bit TERM_MARK_BIT_INDEX,(hl)
    jr nz,.gc_mark_return_or_next_sibling
    call gc_test_dynamic_arena_address
    jr c,.gc_mark_return_or_next_sibling
    set TERM_MARK_BIT_INDEX,(hl)
    push hl
    inc b
    call z,system_abort
    jr .gc_mark_visit_cell
.gc_mark_non_reference_cell:
    ; Constants refer into the separately managed dictionary/name arena.  The
    ; range test at test_dictionary_value_is_dynamic identifies descriptors whose lifetime is collectible.
    cp TERM_TAG_CONSTANT
    jr nz,.gc_mark_float_or_atomic_cell
    call term_load_payload_hl
    call test_dictionary_value_is_dynamic
    jr nz,.gc_mark_return_or_next_sibling
    set TERM_MARK_BIT_INDEX,(hl)
    jr .gc_mark_return_or_next_sibling
.gc_mark_float_or_atomic_cell:
    ; A FLOAT cell points to a six-byte numeric record.  Mark only records inside
    ; the dynamic evaluation arena; integer, END and unbound cells have no child.
    cp TERM_TAG_FLOAT
    jr nz,.gc_mark_return_or_next_sibling
    call term_load_payload_hl
    bit TERM_MARK_BIT_INDEX,(hl)
    jr nz,.gc_mark_return_or_next_sibling
    call gc_test_dynamic_arena_address
    jr c,.gc_mark_return_or_next_sibling
    set TERM_MARK_BIT_INDEX,(hl)
.gc_mark_return_or_next_sibling:
    dec b
    pop hl
    ret z
    inc hl
    inc hl
    inc hl
    jr .gc_mark_visit_cell
; Test whether HL lies in the dynamic evaluation arena.
;
; Return NC for EXEC_ALLOCATION_TOP <= HL <= EXEC_ARENA_ORIGIN; return C for
; static interpreter data, dictionary storage, ROM, or addresses above the arena.
; The mark walker follows and marks only NC addresses.  No relocation is implied.
gc_test_dynamic_arena_address:
    push de
    ex de,hl
    ld hl,(EXEC_ALLOCATION_TOP)
    scf
    sbc hl,de
    ccf
    jr c,.gc_address_test_return
    ld hl,(EXEC_ARENA_ORIGIN)
    or a
    sbc hl,de
.gc_address_test_return:
    ex de,hl
    pop de
    ret
; Consume dictionary mark bits and remove dead constants from the two registry
; roots.  These lists are weak ownership structures: merely appearing in a
; dictionary must not keep an otherwise unused constant alive.
; ----------------------------------------------------------------------------
; DICTIONARY ENTRIES ARE WEAK OWNERS OF NAMES
; ----------------------------------------------------------------------------
;
; A dictionary node should not keep an otherwise unused constant alive merely
; because the name can be looked up.  The collector therefore treats relation
; values and module dictionaries as roots, but removes dynamic dictionary nodes
; whose canonical value and name storage are no longer reachable.
;
; Module descriptors require one extra descent: exports, imports and locals are
; separate dictionaries linked through tagged terms.  The callback walker lets
; the same proper-list traversal visit each without hard-coding another loop.
;
; Forward reference: dictionary ownership
; ---------------------------------
; Dictionary descriptors act like weakly retained name objects: the dictionary
; list itself is a root, but entries whose descriptors are otherwise unreachable
; may be removed.  The ownership reason becomes clear in module 08, where each
; module has export, import, and local dictionaries and deleted relations leave
; their canonical names available for pruning.  Here the collector only needs
; the mechanical policy: retain marked descriptors; splice out unmarked ones.
; Dynamic dictionary entries are weak names.  A name does not keep its value alive
; merely because its bytes occupy the name pool.  If no live term reaches the
; dynamic constant, GC may unlink/release the entry.  A later occurrence of the
; same spelling can then be interned into a new canonical value cell; pointer
; identity is stable only while the dictionary entry remains live.
gc_prune_dictionary_roots:
    ld hl,GC_DICTIONARY_ROOT_A
    call gc_prune_dictionary_chain
    ld hl,GC_DICTIONARY_ROOT_B
; Prune one proper dictionary list in place.
;
; Each outer LIST element points to a CONSTANT cell whose payload names the actual
; dictionary descriptor.  A marked descriptor is retained and unmarked.  An
; unmarked END descriptor is released from the dictionary allocator and the outer
; cons cell is deleted by copying its tail over itself.  MODULE descriptors are
; retained and their local dictionary list is pruned recursively.
gc_prune_dictionary_chain:
    ld a,(hl)
    cp 003h
    jr nz,.gc_dictionary_chain_end
    push hl
    call term_load_payload_hl
    push hl
    ld a,(hl)
    res TERM_MARK_BIT_INDEX,a
    cp 010h
    jr z,.gc_dictionary_advance_outer_list
    cp 008h
    call nz,system_abort
    call term_load_payload_hl
    ld a,(hl)
    bit TERM_MARK_BIT_INDEX,a
    res TERM_MARK_BIT_INDEX,a
    ld (hl),a
    jr nz,.gc_dictionary_keep_or_descend_module
    cp 010h
    jr nz,.gc_dictionary_keep_or_descend_module
    call release_dictionary_name_storage
    pop hl
    res TERM_MARK_BIT_INDEX,(hl)
    inc hl
    inc hl
    inc hl
    pop de
    push de
    ld bc,00003h
    ldir
    pop hl
    jr gc_prune_dictionary_chain
.gc_dictionary_keep_or_descend_module:
    cp TERM_TAG_MODULE
    jr nz,.gc_dictionary_advance_outer_list
    call term_load_payload_hl
    inc hl
    inc hl
    inc hl
    call term_load_payload_hl
    inc hl
    inc hl
    inc hl
    call gc_prune_dictionary_chain
.gc_dictionary_advance_outer_list:
    pop hl
    pop af
    inc hl
    inc hl
    inc hl
    jr gc_prune_dictionary_chain
.gc_dictionary_chain_end:
    cp 010h
    call nz,system_abort
    ret
; Walk a proper LIST chain and call the target installed behind the JP at
; LIST_WALK_CALLBACK_JUMP for each head term.  The callback receives HL = head
; term.  Mark bits are ignored during structural validation so the walker can be
; reused by module construction, deletion, listing and garbage collection.
; Callback trampoline as pseudocode
; ---------------------------------
; Z80 has no indirect CALL instruction, so the interpreter patches the operand
; of a stable JP instruction and calls through that address:
;
;       LIST_WALK_CALLBACK_TARGET = address(callback)
;       walk(list):
;           while list != END:
;               require list.tag == LIST
;               head, list = pair(list)
;               call LIST_WALK_CALLBACK_JUMP(head)
;
; The callback receives HL = head term and returns normally to the walker because
; the stable JP is reached through CALL.  The same walker is therefore reused by
; GC, module construction, deletion, and listing.
; Callback walker pseudocode
; --------------------------
; while list != END:
;     require LIST cell
;     element = list.head
;     push address of walker's continuation
;     jump (not call) through LIST_WALK_CALLBACK_TARGET
;     ; callback RET consumes the continuation pushed by the walker
;     list = list.tail
;
; The callback owns no additional native return address.  It is entered by JP
; after the walker synthesizes exactly the address which callback RET must use.
walk_proper_list_with_callback:
    ld a,(hl)
    res TERM_MARK_BIT_INDEX,a
    cp 010h
    ret z
    cp 003h
    call nz,system_abort
    call term_load_payload_hl
    push hl
    call LIST_WALK_CALLBACK_JUMP
    pop hl
    inc hl
    inc hl
    inc hl
    jr walk_proper_list_with_callback
; GC callback for a dictionary/module registry element.
;
; Mark the registry constant itself, then inspect its payload.  Ordinary LIST
; payloads are marked as term graphs.  MODULE objects additionally own program,
; import/export and local-dictionary structures that require explicit traversal.
gc_mark_module_callback:
    set TERM_MARK_BIT_INDEX,(hl)
    call term_load_payload_hl
    ld a,(hl)
    res TERM_MARK_BIT_INDEX,a
    cp 003h
    jp z,gc_mark_term_graph
    cp TERM_TAG_MODULE
    ret nz
    call term_load_payload_hl
    push hl
    call gc_mark_term_graph
    pop hl
    set TERM_MARK_BIT_INDEX,(hl)
    inc hl
    inc hl
    inc hl
    ld a,(hl)
    cp 003h
    ret nz
    call term_load_payload_hl
    set TERM_MARK_BIT_INDEX,(hl)
    push hl
    call gc_mark_term_graph
    pop hl
    inc hl
    inc hl
    inc hl
    jp walk_proper_list_with_callback
