; micro-PROLOG resurrection source — v025 second-review improvements
;
; The emitted image remains byte-for-byte identical to the 1983 distribution.
; This file is intentionally only an architectural include order.  The source
; modules preserve the original address order because many permanent tagged
; objects contain absolute pointers into later modules.

include "src/arch/00_definitions.asm"
include "src/arch/01_boot_and_executor.asm"
include "src/arch/02_clause_unification_and_allocation.asm"
include "src/arch/03_garbage_collector.asm"
include "src/arch/04_term_io_and_parser.asm"
include "src/arch/05_lexical_tables.asm"
include "src/arch/06_devices_and_line_editor.asm"
include "src/arch/07_type_predicates.asm"
include "src/arch/08_modules_dictionary_and_database.asm"
include "src/arch/09_graphics_and_machine_io.asm"
include "src/arch/10_supervisor_programs.asm"
include "src/arch/11_arithmetic.asm"
include "src/arch/12_cassette_file_system.asm"
