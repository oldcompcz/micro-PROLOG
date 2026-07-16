# Resurrected assembler source

`prolog.asm` is the canonical include entry point. The thirteen files in
`arch/` follow the original address order and together emit the interpreter at
`0x6000–0x9777`.

The source is a literate, semantically labelled reconstruction of the original
1983 image. It contains descriptive dot-prefixed local labels, pseudocode,
worked runtime traces, and readable annotations for all identified strings.
Despite the restructuring and comments, its output is byte-for-byte identical
to the interpreter block in `tapes/micro-PROLOG.tap`.

Build from the repository root with `make`. Do not assemble an individual
`arch/*.asm` file: absolute pointers in permanent tagged objects require the
complete modules in the order listed by `src/prolog.asm`.
