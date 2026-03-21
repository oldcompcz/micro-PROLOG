# Sinclair ZX Spectrum®
# micro-PROLOG
# Programmer's Reference Manual

Authors: F G McCabe, K L Clark, D R Brough

This manual describes the micro-PROLOG system from the programmer's point of view. It describes the syntax of micro-PROLOG, the various built-in features, and how to interact with the system.

First published in 1984, Sinclair Research Ltd, 25 Willis Road Cambridge CB1 2AQ England

# Contents

```text
1 Introduction
  1.1 micro-PROLOG
  1.2 User preparation
  1.3 Notation conventions

2 Standard Syntax of micro-PROLOG
  2.1 Character set
  2.2 Numbers
  2.3 Constants
  2.4 Variables
    2.4.1 A note on separators
  2.5 Lists
    2.5.1 The list constructor |
    2.5.2 List patterns
  2.6 Atoms
  2.7 Clauses
  2.8 Comments
    2.8.1 Comment conditions
    2.8.2 Comment clauses
  2.9 Meta-variable
    2.9.1 Meta-variable as a predicate symbol
    2.9.2 Meta-variable as an atom
    2.9.3 Meta-variable as the tail of the body of a clause
  2.10 Lexical syntax
    2.10.1 Token boundaries
    2.10.2 Special tokens
    2.10.3 Alpha-numeric tokens
    2.10.4 Number tokens
    2.10.5 Graphic tokens
    2.10.6 Quoted tokens
    2.10.7 The lexical rules

3 The micro-PROLOG supervisor
  3.1 Entering clauses and issuing commands
    3.1.1 Entering clauses
    3.1.2 Command format
    3.1.3 The LIST command
    3.1.4 The query command ?
      3.1.4.1 Interrupts and errors
      3.1.4.2 Other uses of the query command
    3.1.5 User defined relations as commands
    3.1.6 Multi-argument commands
    3.1.7 LOAD and SAVE commands
      3.1.7.1 File names
      3.1.8 The DICT relation
      3.1.9 The KILL command
      3.1.10 Restarting micro-PROLOG
      3.1.11 Display modes
      3.1.12 Using the Sinclair Printer
  3.2 Pragmatic considerations for programmers

4 Utility modules
  4.1 Tracing execution
  4.2 Spypoint tracing
    4.2.1 The spy command
    4.2.2 The spying relation
    4.2.3 The spying command
    4.2.4 The unspy command
  4.3 The micro-PROLOG structure editor
    4.3.1 Edit commands
    4.3.2 Cursor movement commands
    4.3.3 Edit change commands
    4.3.4 Restructuring lists
    4.3.5 Further extension
  4.4 Editing modules
    4.4.1 The unwrap command
    4.4.2 The wrap command
    4.4.3 The save-mods command

5 SIMPLE PROLOG
  5.1 Syntax of sentences accepted by SIMPLE
    5.1.1 Simple sentence
    5.1.2 Conditional sentence
  5.2 The relations and commands defined by program-mod
    5.2.1 add
    5.2.2 list
    5.2.3 delete
    5.2.4 kill
    5.2.5 accept
    5.2.6 edit
    5.2.7 cedit
    5.2.8 function
    5.2.9 "?REV-P?"
  5.3 The relations and commands exported by query-mod
    5.3.1 is
    5.3.2 which (all)
    5.3.3 one
    5.3.4 save
    5.3.5 load
    5.3.6 APPEND, ON, true-of
    5.3.7 CONS, @, #, =
    5.3.8 *, %, +, -, PROD
    5.3.9 defined, reserved
    5.3.10 Parse-of-S, Parse-of-ConjC, Parse-of-SS,
           Parse-of-Cond, Parse-of-CC
    5.3.11 "FIND:" and "?VAR TRANS?"
  5.4 Using expressions in sentences — the module exptran-mod
    5.4.1 Expression conditions
    5.4.2 Equality conditions
    5.4.3 Syntax of expressions
    5.4.4 Warning on the use of | in expressions
    5.4.5 The relation Expression-Parse
    5.4.6 When the expression handler is not needed
  5.5 The error handler errmess-mod
    5.5.1 data-rel relations
  5.6 Using the relation is-told
    5.6.1 Example uses of is-told
    5.6.2 Using is-told from DEFTRAP error handler
  5.7 Tracing SIMPLE queries using SIMTRACE
    5.7.1 The relations exported by simtrace-mod
  5.8 Graphics queries
    5.8.1 draw
    5.8.2 show

6 The MICRO extension to the supervisor
  6.1 The relations exported by micro-mod
    6.1.1 add
    6.1.2 delete
    6.1.3 edit
    6.1.4 cedit
    6.1.5 kill
    6.1.6 list
    6.1.7 load
    6.1.8 save
    6.1.9 reserved
    6.1.10 space
    6.1.11 is
    6.1.12 which, all
    6.1.13 one
    6.1.14 accept
    6.1.15 APPEND, ON, true-of
    6.1.16 CONS, @, #, =, function
    6.1.17 *, %, +, -,
  6.2 Expressions in MICRO clauses
    6.2.1 The # relation
    6.2.2 The = relation
    6.2.3 Syntax of expressions
    6.2.4 Killing exptran-mod
  6.3 The error handler errtrap-mod
    6.3.1 Example error recovery
  6.4 Using the is-told relation
    6.4.1 Example use of is-told
    6.4.2 Using is-told from the error handler
  6.5 Tracing and structure editing
  6.6 Graphics queries
    6.6.1 draw
    6.6.2 show

7 Built-in programs
  7.1 Arithmetic operations
    7.1.1 SUM
    7.1.2 TIMES
    7.1.3 LESS
    7.1.4 INT
    7.1.5 SIGN
  7.2 String operations
    7.2.1 LESS
    7.2.2 STRINGOF
    7.2.3 CHAROF
  7.3 Console I/O operations
    7.3.1 R
    7.3.2 P
    7.3.3 PP
    7.3.4 RFILL
  7.4 File I/O operations
    7.4.1 OPEN
    7.4.2 CREATE
    7.4.3 CLOSE
    7.4.4 READ
    7.4.5 WRITE
    7.4.6 W
    7.4.7 Special file names
  7.5 Graphics, colour and sound primitives
    7.5.1 HYBRID
    7.5.2 NORMAL
    7.5.3 LNE
    7.5.4 PNT
    7.5.5 CLS
    7.5.6 BORDER
    7.5.7 Setting INK and PAPER colours and attributes
    7.5.8 BP
  7.6 Type predicates
    7.6.1 NUM
    7.6.2 INT
    7.6.3 CON
    7.6.4 LST
    7.6.5 SYS
    7.6.6 VAR
  7.7 Logical operators
    7.7.1 OR
    7.7.2 NOT
    7.7.3 IF
    7.7.4 EQ
    7.7.5 ?
    7.7.6 FORALL
    7.7.7 ISALL
    7.7.8 !
  7.8 Database operations
    7.8.1 CL
    7.8.2 ADDCL
    7.8.3 DELCL
    7.8.4 Undoing the effect of ADDCL or DELCL
    7.8.5 KILL
  7.9 Library procedures
    7.9.1 LIST
    7.9.2 LISTP
    7.9.3 SAVE
    7.9.4 LOAD
  7.10 Module construction facilities
    7.10.1 CMOD
    7.10.2 CRMOD
    7.10.3 OPMOD
    7.10.4 CLMOD
  7.11 Miscellaneous predicates
    7.11.1 NEW
    7.11.2 QT
    7.11.3 /
    7.11.4 FAIL
    7.11.5 ABORT
    7.11.6 /*
    7.11.7 SPACE
    7.11.8 <SUP>
    7.11.9 DICT
    7.11.10 RND
    7.11.11 PIO
```

## Appendices

```text
A micro-PROLOG distribution system
B Keyboard control and line editor
C Error messages and error handling
D Pragmatic considerations for programmers
E Pragmatics of Spectrum file handling

REFERENCES
```

## Warning

This manual is not an introduction to micro-PROLOG programming. It is intended to be used as a reference manual by the programmer who already has some knowledge of PROLOG programming to the extent covered by the companion Sinclair *micro-PROLOG Primer* or the Clocksin & Mellish text [1981]. For an introductory text on the general ideas of logic programming we recommend the book *Logic for Problem Solving* [Kowalski 1979].

The reader should also have some knowledge of the Sinclair ZX Spectrum; in particular, knowledge of how to connect the Spectrum to a tape recorder and TV, and knowledge of how to use the keyboard. The booklets that accompany the ZX Spectrum contain this information. The *Spectrum micro-PROLOG Primer*, which will have been supplied with the implementation, also contains information on the use of the Spectrum.



# Chapter 1
# Introduction

This *Programmer's Reference Manual* describes the micro-PROLOG logic programming system for use on the Sinclair ZX Spectrum. PROLOG is a computer language based on symbolic logic, in particular the clausal form of logic and resolution inference [Robinson 1965, 1979]. micro-PROLOG is an interpreted version of PROLOG tailored for interactive use on microcomputers. It is the end product of three years of continuous development in the field of PROLOG systems on micros. It is a mature system, which, although it runs on a microcomputer, does not sacrifice any significant features of the PROLOG systems on much larger computers; indeed, it contains some features not available in some of the large machine implementations.

The first PROLOG (which stands for PROgramming in LOGic) was implemented in 1972 in Marseilles by Colmerauer and Roussell [Colmerauer 1973] as an interpreter in the medium level programming language ALGOL-W. A more efficient and improved interpreter was then built in 1973 [Roussell 1975], this time in FORTRAN. This implementation reached a wide audience in countries as far afield as Poland, Hungary, USA, Canada, Sweden, Portugal, Belgium and the UK.

Building on and extending the implementation techniques of the Marseilles PROLOG, there have been several other implementations, the principal ones being the Edinburgh DEC-10 PROLOG [Warren *et al.* 1978], Waterloo PROLOG [Roberts 1977], the Hungarian M-PROLOG [Szeredi 1982] and a new implementation from Marseilles [Kanoui & Van Caneghem 1980]. The Edinburgh implementation incorporates a compiler, the first to be written for the language.

Recently, interest in PROLOG has been stimulated by the Japanese decision to use it as the core language for which they will design their fifth generation computers. The Japanese interest derived from the 'academic export' of the Marseilles and DEC-10 implementations to Japan.

## 1.1 micro-PROLOG

To allow a compact and efficient implementation, mostly written in assembler, the syntax of the directly interpreted programs — the standard syntax — and the built-in supervisor of micro-PROLOG are quite rudimentary. The standard syntax is very close to the list syntax of LISP and the supervisor is a small micro-PROLOG program that provides only the necessary program development and query facilities.

The facilities of the supervisor are described in Chapter 3. The most important feature of the supervisor is that it is extensible. By loading other micro-PROLOG programs, wrapped up as *modules*, one can considerably enhance the program development and query facilities of the built-in supervisor. Several such supervisor extension modules are provided with the micro-PROLOG system.

Modules are an important program structuring facility of micro-PROLOG — which is one of a very few implementations of PROLOG to support modules. micro-PROLOG modules are named collections of relation definitions that communicate with other programs via import/export name lists. All other names used in the module are local to the module. This localised name feature enables modules developed at different times, or by different programmers, to be used together without fear of a name clash. Finally, exported names of relations defined in the module can be used in other programs as though they were primitive relations of micro-PROLOG, hence the role of modules in extending the facilities of the supervisor.

One collection of supervisor extension modules — in the file SIMPLE of the distribution tape — accepts program clauses and queries expressed in the sugared, easy-to-read sentence syntax introduced in the *micro-PROLOG Primer*. It compiles these into the standard syntax; it also incorporates an interactive program text editor which first decompiles program clauses so that they can be edited in the sentence syntax. The facilities of SIMPLE and the syntax of SIMPLE programs are introduced in the *micro-PROLOG Primer* and fully described in Chapter 5.

Another suite of program modules, in the file MICRO, provides all the program development and query modes of SIMPLE, but for programs and queries written in the standard syntax augmented with functional expressions. The facilities provided by the MICRO modules are described in Chapter 6.

Other utility modules are provided in the files

```text
EDITOR      {a program editor}
TRACE       {a full trace package}
SPYTRACE    {allows spy-tracing of individual programs}
MODULES     {helps the construction and editing of
             modules}
SIMTRACE    {a trace package for use with SIMPLE}
DEFTRAP     {a simple error handler}
ERRTRAP     {an error handling and recovery utility}
SIMSHOW     {graphics query extensions to SIMPLE}
MICSHOW     {graphics query extensions to MICRO}
```

The EDITOR, TRACE, SPYTRACE and MODULES programs are described in Chapter 4. SIMTRACE, DEFTRAP, SIMSHOW and SIMPLE are described in Chapter 5. ERRTRAP, MICSHOW and MICRO are described in Chapter 6. EXPTRAN and TOLD can both be optionally loaded with SIMPLE or MICRO and the effects are described in the appropriate chapters.

All these utility modules can be optionally loaded as extensions to the built-in supervisor and deleted when they are no longer needed. Newcomers to micro-PROLOG programming usually start by using the SIMPLE extension as described in the *micro-PROLOG Primer*, and then, when they are completely conversant with all its facilities, move over to using MICRO or their own micro-PROLOG implemented aid to program development. Experienced micro-PROLOG programmers, like LISP programmers, have no problem using the micro-PROLOG standard syntax.

## 1.2 User preparation

So that you will be able to be able to exploit the full power of the Sinclair ZX Spectrum micro-PROLOG we recommend that you study the *micro-PROLOG Primer*, doing all the exercises using the system. (Sample solutions are given in an appendix of the *Primer*.) Then read the whole of this *Reference Manual*. An effort to become fully conversant with all the facilities of micro-PROLOG will be well rewarded.

## 1.3 Notation conventions

The *Manual* includes many examples of small micro-PROLOG programs to illustrate the use of some facility. All example programs are given in heavy type. Heavy type is also used when giving the name of a relation or module in the text.

In specifying the syntax of some micro-PROLOG constructs, angle brackets `‹ ›` surrounding a type name are used to indicate that a field or sub-expression can be any instance of the indicated type. For example

```text
LOAD ‹file name›
```

is used to indicate that any allowed file name can be used in the LOAD command. `‹type1›` and `‹type2›` will be used when two uses of the same type can be different; the use of the different subscripts does not imply that they must be different.

One syntactic category, that of `‹term›`, is used so often that the abbreviations `t`, `t1`, `t2` etc. are used for `‹term›`, `‹term1›`, `‹term2›`. The form

```text
t1 ... tk
```

is used to indicate a sequence of `k` terms. Unless the condition `k>0` is explicitly given, this form includes the case when there are no terms in the sequence. Again, the use of the different subscripts does not imply that the terms must be different, only that they may be different.

`‹enter›` is used to indicate the pressing of the ENTER key. `‹enter›` stands for the character that is input (ASCII code decimal 13) by the Spectrum keyboard when the ENTER key is pressed.

Finally, some example programs in the *Reference Manual* will be given with associated comments between `{ }` brackets. They are not part of the program and should not be typed if you enter the program. micro-PROLOG does not accept comments in this form.


# Chapter 2
# Standard syntax of micro-PROLOG

The standard syntax of micro-PROLOG is modelled on LISP syntax [McCarthy 1962]. If a richer syntax is desired it has to be supported by a front end micro-PROLOG program that compiles into the standard syntax. In this chapter we describe the standard syntax.

In Chapter 5, we will describe a more user friendly syntax that is compiled into the standard syntax by the SIMPLE extension for the supervisor. The SIMPLE supported syntax is just one option for a more elaborate syntax.

There are only four different kinds of syntactic objects that micro-PROLOG knows about: *Numbers*, *Constants*, *Variables* and *Lists*. They are all different kinds of *Term*.

The only data constructor in micro-PROLOG is the list constructor `|` (the vertical bar on the keyboard read as `:` followed by `.`). Lists constructed using `|` can be written in a specially condensed syntax as in DEC-10 PROLOG and LISP. Other PROLOG systems do allow other kinds of data constructors; these can be easily simulated (with no great loss of efficiency) using lists.

## 2.1 Character set

micro-PROLOG uses the 7-bit ASCII character set, together with the extra Spectrum graphics characters corresponding to ASCII codes 128 to 143. Characters are represented internally as 8-bit integers in the range 1 to 126. The ASCII characters corresponding to 0 and 127 are not legal in micro-PROLOG, and are ignored if used. The accepted characters, for the codes 1 to 127 and 128 to 143 are given in Appendix A of the Spectrum BASIC manual.

## 2.2 Numbers

Numbers are either integers in the range `-32767` to `32767`, or floating point numbers.

A positive integer is written as a contiguous sequence of digit characters, with no leading sign character, eg, `0 30 1025 32767`.

A negative integer is written with the leading sign character `-` contiguously followed by a positive integer. For example, `-1 -30 & -32767` are all negative numbers. If a sign character does not have a positive integer contiguously following it, then it is not regarded as the sign of a number. Thus `-` on its own is a valid syntactic object, differing from any number.

Floating point numbers can have up to eight digits of precision, and an exponent in the range `-127` to `127`. They are written in a fairly conventional notation; some example floating point numbers are:

```text
2.34    10.3e99    12.003e-100    -0.9
```



One and only one decimal point must be present in a floating point number. As with an integer, it must start with a digit or a minus sign and a digit. The `e` exponent is optional, but if used it must be contiguous to the number and must be contiguously followed by an integer. The following are *not* floating point numbers:

```text
.9       {starts with .}
3e-22    {no .}
34 e3    {space before e}
-.7e45   {no digit after -}
56e4.8   {exponent not an integer}
```

No matter how they are entered, floating point numbers are always displayed in a standard format, which depends on the magnitude of the number. If the number is in the range `-10<x<10` then it is displayed with the leading digit followed by the fractional part, as in:

```text
4.2345678
```

Otherwise, floating point numbers are displayed in the standard scientific notation:

```text
9.9999999e99
```

but with only the significant digits displayed; trailing `0`s after the `.` are suppressed.

As with integers, only negative floating point numbers have a sign character in front of them; positive floating point numbers do *not* have a sign character. If you enter `+6.86` micro-PROLOG will interpret this as a sequence of two terms, the constant `+` and the positive number `6.86`.

micro-PROLOG attempts to handle the conversion between integers and floating point numbers in a generally automatic and transparent way. In particular, integers and floating point numbers can be mixed in any way in arithmetic computations, and the results are represented as 16-bit integers *if they can be*. So, for example, the number entered as

```text
2.34e4
```

will be represented internally as the integer

```text
23400
```

## 2.3 Constants

Constants are the simple unstructured objects of micro-PROLOG. They are used to name individuals such as `fred`, `A1`. They are also used to name relations such as `member-of`, `father-of`.

A constant is normally written as an alphabetical character (a letter), followed by a sequence of letters and digits (though see definition of variable below). This is similar to the way identifiers are written in conventional programming languages. The `-` character also counts as an alphabetic character in a sequence of letters and digits. This can be used to split up long names with several English words. Constants can also be written using the non-alphanumeric characters such as `. ! ,` etc. This kind of constant is written as any sequence of symbolic characters (or graphic characters supported by the machine) other than:

```text
( ) |
```

which have a special syntactic role, and

```text
{ } [ ] < >
```

which are always interpreted as single character constants.

The symbols that can be used to form a symbolic constant include:

```text
! # $ % & ' = - ↑ ~ @ ` ; : , . / + * ?
```

Thus,

```text
**    !    ??    -    :=
```

are all symbolic constants.

Note: The character "↑" is ZX Spectrum version of "^".

Finally, a constant can also be written as a quoted sequence of characters, in which case there are no restrictions on the characters that can be used in the constant. A quoted constant consists of a sequence of characters surrounded by the double quote character: `"`. Examples of quoted constants are:

```text
"4"    "The man"    "?ERROR?"    "$100"    "<SUP>"
```

A quoted constant can include a space, as in `"The man"`. Outside a quoted string a space acts as a separator. Thus

```text
The man
```

is a sequence of *two* constants.

ASCII codes that do not correspond to keyboard characters can also be included in a quoted constant. This is useful for testing arbitrary ASCII character input, or for sending control characters to the display (see section 7.3.2 on the use of the `P` print primitive).

To put an ASCII control character with decimal code `N` in a quoted constant enter `@` followed by the keyboard character with ASCII decimal code `N+64`. Thus, `@P` denotes the ASCII character with decimal code `16` (HEX code `10` - the INK control code) because the keyboard character `P` has ASCII decimal code `80`. micro-PROLOG will convert the two character sequence `@P` in the quoted constant into the single ASCII character with decimal code `16`. All the ASCII character codes are given in Appendix A of the Spectrum BASIC manual. *When you list the program* the occurrence of the single character with ASCII decimal code `16` in the constant will be displayed as the two character sequence `@P`.

Thus, in a quoted constant, `@` acts as an escape character causing micro-PROLOG to interpret the next character in a special way. There are two exceptions to this rule to allow the escape character and the quote character to appear in strings. To enter `@` in a string you must use `@@`. Thus, `"@P@@"` is the constant comprising two characters: control code HEX `10` followed by `@`. Notice that the convention that `@@` represents `@` means that you cannot use the `@` escape to put the ASCII control code `0` into a string. Since `@` has decimal code `64`, `0` would normally be denoted by `@@` (`64-64`), but micro-PROLOG treats this as `@`.



An `@` character followed by the quote character means a quote character in the string.

```text
"A quoted @" string"
```

has the text:

```text
A quoted " string
```

Although constants can be of any length, only the first 60 characters of a constant are significant, and only these 60 characters are stored. This applies to quoted constants as well as other kinds of constant.

## 2.4 Variables

Variables are represented by alphanumeric names which consist of a single letter optionally followed by a contiguous positive integer which has the role of a subscript. The first character must be one of the *variable prefix characters*, which in standard micro-PROLOG are: `x`, `y`, `z`, `X`, `Y` and `Z`.

So, for example, `x`, `X1` and `Y30` are variable names since they consist of a variable prefix character contiguously followed (if at all) only by digits, whereas `yes`, `x12c` are *not* variable names. The integer which follows the variable prefix character should be in the range `1 ... 127`, otherwise two apparently distinct names will be mapped to the same variable.

**WARNING:** `x` and `x0` are the same variable because `x` is implicitly subscripted with `0`. Similarly, `x3` and `x03` are the same variable because `3` and `03` are the same integer subscript. The subscript is not the digit sequence but the positive integer that the sequence denotes.

When a term is read in, and a variable is recognised in the term, the variable is converted into a special internal form and the actual variable name used is discarded. All occurrences of the same variable name in the term are converted into the same internal form. However, when the term is printed the original names of the variables are not available. Instead, the variables in the term are displayed with names taken from the sequence `X, Y, Z, x, y, z, X1, ..., z1, ...`. The first variable in the term is given the name `X`, the second is given the name `Y`, and so on.

### 2.4.1 A note on separators

Variables, constants and numbers are generally separated by one or more of the separator characters: `<space>` or `<enter>`. The actual number of separators is not important.

See section 2.10 for a fuller description of micro-PROLOG's lexical syntax. A separator character is not always necessary for micro-PROLOG to determine the end of one syntactic object and the beginning of another. On the other hand, insertion of a separator never does any harm.

## 2.5 Lists

Lists are the structured objects of micro-PROLOG. The simplest list is the empty list

```text
()
```

which is written as a pair of parentheses (separated by any number of spaces, including none). If there are terms inside the parentheses we have a non-empty list. Thus

```text
(2 3 5)
```

is a list of the three integers 2, 3, 5. The spaces between the integers are important. The list

```text
(235)
```

is the list of one integer 235.

Any term, including another list, can be an object in a list. For example,

```text
((2 3) apple x (-2.3 &&))
```

is a list of four objects:

```text
a sublist (2 3) of the two integers 2, 3
the constant apple
the variable x
a sublist of two objects:
the floating point number -2.3 and the graphic constant &&.
```

As in LISP, sublists can be nested to arbitrary depth, eg:

```text
((a (b c)) ((d)) ((e) f) h)
```

is a list of three sublists.

### 2.5.1 The list constructor |

Internally, non-empty lists are represented as structures built up from the empty list by a sequence of `|`-constructions. `|` is the micro-PROLOG list constructor analogous to the LISP dot. For example,

```text
(a b c)
```

is represented internally as

```text
(a|(b|(c|())))
```

The innermost expression `(c|())` represents the list constructed from the empty list by adding `c` as a front element. That is, `(c|())` is the internal representation of the single element list `(c)`. So `(b|(c|()))` is the list `(c)` with `b` added as a front element. In other words, it is the internal representation of the list `(b c)`. Finally,

```text
(a|(b|(c|())))
```

is the list `(b c)` with `a` added as a front element, which is the list `(a b c)`.

The notation `(t1 t2 .... tn)` for a list of `n` terms is just an accepted abbreviation for the explicitly constructed list

```text
(t1|(t2|....(tn|())....))
```

More generally,

```text
(t1 t2....tn|t)
```

is an accepted abbreviation for the explicit construction

```text
(t1|(t2|....|(tn|t)....))
```

when `t`, as well as each of `t1 .... tn`, is any term - ie a number, constant, variable or list. The `|` should be read as: *followed by*. The above term is the list of the `k` elements `t1, t2, ...., tk` followed by `t`.



Examples

```text
(a b c|x)
```

is the list comprising the sequence `a`, `b`, `c` *followed by* `x`. A list term of the form

```text
(t1|t2)
```

is the list comprising the term `t1` followed by `t2`. In LISP parlance, `t1` is the *head* (or CAR) of the list and `t2` is the *tail* (or CDR) of the list.

### 2.5.2 List patterns

Any list term with variables is a list pattern. The above

```text
(a b c|x)
```

is a list pattern representing any list that begins with the constants `a`, `b`, `c` in that order. Since `x` may be the empty list, the list `(a b c)` is covered by this pattern. List patterns have a crucial role in micro-PROLOG. Relations over lists are defined using list patterns. Further examples of list patterns are

```text
1        (x|y)
```

represents any list comprising at least one element `x`. Again, since `y` can be the empty list, this includes the single element list `(x)`. Note that `(x)` is also a list pattern, representing any list of exactly one element.

```text
2        ((x|y)|z)
```

represents any list that starts with a non-empty list (the pattern `(x|y)`). Since `z` and `y` can both be the empty list, the list pattern `((x))`, denoting a singleton list with a singleton list as its only element, is a special case of the pattern `((x|y)|z)`.

```text
3        (x1 x2 (x3 x4))
```

is a list of three elements, whose third element is a list of two elements.

```text
4        (x1 x2|y)
```

is a list of at least two elements `x1 x2`, in that order. It covers the case of a list of exactly two elements since `y` may be `()`.

In each of the above patterns the variables represent any term, including lists. There are no types in micro-PROLOG over and above types of list structures represented by list patterns. Variables always represent any term.

```text
5        (x1 x2|(x3 x4))
```

is the list of two elements `x1`, `x2` *followed by* the list of two elements `x3`, `x4`. In other words, it is the list

```text
(x1 x2 x3 x4)
```

which is an equivalent pattern. Both are represented internally as

```text
(x1|(x2|(x3|(x4|()))))
```

Although the bar is the only data constructor in micro-PROLOG, which is a major difference between it and other PROLOGs, other constructors can easily be simulated by using list notation. In most PROLOGs, any constant `f` can be introduced as a data constructor with `f`-structures denoted as terms of the form

```text
f(t1,...,tn)
```



In micro-PROLOG, you can represent this, as in LISP, as the list

```text
(f T1 ... Tn)
```

where `Ti` is the list representing the term `ti` (for `i = 1 to n`) and the terms are separated by spaces, not by commas.

All micro-PROLOG constructs are expressed in terms of the four types of term discussed so far: Numbers, Constants, Variables and Lists. The higher level syntactic constructs, such as atoms and clauses make use of these basic objects, and they are generally list structures.

If you want to start developing micro-PROLOG programs using the SIMPLE system we suggest that you consult Appendix A or the Spectrum *micro-PROLOG Primer* on how to enter micro-PROLOG and then follow the examples and exercises in the *Primer*. You need read the rest of this Chapter only when you have reached Chapter 9 of the *Primer*.

## 2.6 Atoms

Atomic formulae, or atoms, are the primitive sentence forms out of which program statements and queries are constructed. In the usual syntax of predicate logic an atomic formula is an expression of the form

```text
R(t1,...,tn)
```

where `R` is a relation name (more formally, *predicate symbol*) and `t1,...,tn` are its argument terms. In micro-PROLOG, the atomic formula is written as the list

```text
(R t1 .. tn)
```

comprising the relation name followed by the sequence of arguments. There are no separating commas. Spaces are used if needed (see section 2.10).

*Example*

```text
(father-of tom bill)
```

is the atom which expresses the relation of father-of between tom and bill. The relation name of an atom, that is the head of the atom list, must be a constant. (But see section 2.9).

## 2.7 Clauses

All PROLOG program statements correspond to a restricted form of sentence of predicate logic called *Horn Implications*, or *definite clauses*. These are sentences of the general form

```text
<atom> if <atom1> and <atom2> and ... and <atomk> where k > 0
```

in which each variable appearing in the sentence represents any term. In the micro-PROLOG standard syntax the logical connectives `if` and `and` are dropped, and the clause becomes the list of atoms

```text
(<atom> <atom1>...<atomk>)
```

Since each atom is itself a list, a clause is a list of sublists in which each sublist is a list that begins with a constant which is a relation name (but see section 2.9 for exceptions). The first atom is the *head* of the clause; the remaining atoms comprise the *body* of the clause.



Examples

```text
1       ((father-of tom bill))
```

is the unconditional statement that the atom

```text
(father-of tom bill)
```

represents a true fact.

```text
2       ((App () x x))
```

is the unconditional statement that for all `x`

```text
(App () x x)
```

is an instance of the Append relation.

```text
3       ((App (x|y) z (x|y1)) (App y z y1))
```

is the conditional statement that for all `x`, `y`, `z` and `y1`

```text
(App (x|y) z (x|y1))
```

is an instance of the Append relation if

```text
(App y z y1)
```

is an instance of the Append relation. These are both true statements when `(App x y z)` is understood to mean that `z` is the result of appending (concatenating) a list `x` to the front of a list `y`. Note the role of the patterns `(x|y)` and `(x|y1)` in the second clause. They tell us that the clause deals with the case of a non-empty front list and the repeated `x` in the two patterns tells us that the first element of the front list becomes the first element of the concatenation.

## 2.8 Comments

Since micro-PROLOG is first and foremost an interactive system, comments in the form of text in a source file that is ignored on loading are not supported. However, comments can be inserted in a program as statements about some comment relation, or as comment conditions in a clause.

### 2.8.1 Comment conditions

The built-in relation `/*` is a multi-argument relation that is always true. Thus an atom with `/*` as its relation name, followed by any term or sequence of terms, is always skipped over by the micro-PROLOG interpreter.

*Example*

```text
((App () x x)
    (/* App is the concatenation relation for lists))
```

is a commented assertion about the `App` relation. It will be slightly slower in use than the uncommented assertion.

### 2.8.2 Comment clauses

The relation name used for comment clauses can be chosen by the programmer; however, it cannot be `/*`. No clauses are allowed that make statements about the primitive relations of micro-PROLOG. An attempt to enter such a clause results in an error.



Suppose the programmer uses the relation name `comment`. The clause

```text
((comment App (the concatenation relation for lists)))
```

adds the same information about the `App` relation. The main difference is that it is not embedded in the `App` program and so is not automatically shown in a listing of the `App` program. The comment for `App` must be retrieved either by listing the `comment` relation or by querying the `comment` relation. We deal with listing and querying in the next chapter.

## 2.9 Meta-variables

*You may skip this section the first time you read this manual.*

As an extension to the clausal syntax described above, variables can appear in certain positions in a clause to name 'meta-level' components of the clause.

A variable can be used in place of the predicate symbol of an atom in the body, it can name a whole atom in the body, or it can be used to name the 'rest' of the body. These various uses of variables in the bodies of clauses are called the 'meta-variable' facility. This is to indicate that at run-time the variables concerned will be bound to terms which become the relevant components of the clause.

The meta-variable is very important to the usability of micro-PROLOG. It enables many of the second order programs found in LISP (say) to be expressed succinctly in micro-PROLOG.

When the micro-PROLOG interpreter makes use of a clause containing a meta-variable, the variable must have been given a value by the time that the meta-variable condition is reached. Moreover the value must be a valid syntactic item for the position of the meta-variable in the clause.

So, if the meta variable replaces a relation name, it must have been given a value which is a constant; if it replaces an atom it must have been given a value which is an atom list; if it replaces the remainder of the body, it must have a value which is a list of atoms. If this is not the case, an error is signalled.

### 2.9.1 Meta-variable as a Predicate Symbol

A variable can be used as the predicate symbol of an atom in the *body* of a clause. (The head atom of a clause must always have a constant as the predicate symbol. This names the relation that the clause is *about*.) A predicate symbol meta-variable must be bound to a constant before the atom is evaluated. The constant is taken as the predicate symbol of the atom for this call.

This form of the meta-variable can be used to implement the equivalent of the MAP functions in LISP. It is also similar to the facilities to pass procedures as parameters commonly found in more conventional programming languages such as Pascal, ALGOL etc.

In the example program below, `Apply` applies a test to each of the elements of its list argument. A call to `Apply` takes the form: `(Apply OK <list>)` and it succeeds if `(OK y)` is true of each element `y` of `<list>`. The `x` argument, the relation to apply to each element of the list, must be given in any call to `Apply`.

```text
((Apply x ()))
((Apply x (y|Y))
    (x y)
    (Apply x Y))
```

### 2.9.2 Meta-variable as an atom

A variable can also be used instead of an atom in the body of a clause. In this case the variable must be bound to a term which names an atom when the variable is 'called'.

This variant of the meta-variable is used to implement some of the meta-level extensions to the language. For example, the following program 'evaluates' a list as though it were a list of atoms

```text
((Eval ()))
((Eval (x|X))
    x
    (Eval X))
```

This use of the meta-variable does not have a direct counterpart in Pascal; it would correspond to passing an *expression* as a parameter to a procedure. The closest comparison is with the call-by-name mechanism in ALGOL [Naur 1962].

### 2.9.3 Meta-variable as the tail of the body of a clause

The final variant of the meta-variable is its use as the tail of the body of a clause or as the entire body of a clause. A variable in this case represents a list of procedure calls, rather than just a single call. For example, the following program encodes the disjunctive operator OR (available as a built-in program)

```text
((OR x y)|x)
((OR x y)|y)
```

The use of the bar in these two clauses implies that the variables `x` & `y` name lists of atoms, and during execution they must be bound to lists of the correct format. Each list is interpreted as the body of the clause.

Again, this use of the meta-variable has a loose counterpart in conventional programming languages; in particular the closest comparison is with the *label* parameter passing mechanism of ALGOL 60. The replacement body is 'jumped to' rather than being called as with the meta-variable as atom.

## 2.10 Lexical syntax

In this section we describe in more detail the lexical syntax that micro-



PROLOG uses; you can omit it on a first reading of the manual.

The lexical syntax determines how the sequence of characters input to micro-PROLOG (either from the console or from a file) are grouped together into *tokens*.

In some sense the notion of token is a generalisation of word, in that tokens form the smallest groups of characters that can have a meaning associated with them; for example numbers, names and special symbols such as `(`, `|` and `)` are all tokens. However, the lexical rules themselves do not attach meaning to tokens, they merely define what tokens are. In micro-PROLOG there are five different types of token: special tokens, alpha-numeric tokens, number tokens, graphic tokens, and quoted tokens.

### 2.10.1 Token boundaries

The boundaries between tokens are determined by *separator characters* and by certain changes in token type. For example, a number token can be immediately followed by a graphic token since they are of different type; however, two successive number tokens must be separated by at least one separator character. The separator characters are `<space>` and `<enter>`. Apart from their role as token separators, separator characters are ignored on input (but see quoted tokens below).

### 2.10.2 Special tokens

Special tokens consist of single characters, called special characters. Three special tokens form part of the list syntax of micro-PROLOG

```text
( ) |
```

while the others are always regarded as single character constants by micro-PROLOG (even though they are also bracket characters)

```text
[ ] < > { }
```

The use of one of these special characters always marks a token boundary. They do not need to be preceded or followed by any separator.

### 2.10.3 Alpha-numeric tokens

Alpha-numeric tokens are defined in a similar way to identifiers in normal programming languages. They consist of a letter (lower or upper case letter) followed by a sequence of letters, digits. The sign character can also be used in alpha-numeric tokens to aid readability. Some example alpha-numeric tokens are

```text
A    A1    x    A1b3fred    father-of    A-1    -A
```

An alpha-numeric token must be separated from a preceding alpha- numeric token and from a following number token by at least one separator.



### 2.10.4 Number tokens

Numeric tokens are tokens which denote integers or floating point numbers; they are described in section 2.2.

A numeric token must be separated from a preceding number or alpha-numeric token and from a following number token.

### 2.10.5 Graphic tokens

Graphic tokens are names which are built up from the non-alpha-numeric (and non-special) characters. The sign character can also appear in graphic tokens - such characters as `: = %` etc. Some example graphic tokens are

```text
-    =    :    ::    ??    /+    '-%    &
```

Graphic tokens need only be separated from preceding or following graphic tokens.

### 2.10.6 Quoted tokens

The final kind of token is the quoted token. This is used when the lexical roles of characters need to be ignored; it allows arbitrary characters to be grouped together as a single token. A quoted token is a quote character `"` followed by an arbitrary sequence of characters (excepting the quote character itself) and terminated by another quote character. The quote character can be inserted in the token by prefixing it with the escape character `@` (see section 2.3).

Quoted tokens do not need to be preceded or followed by a separator.

### 2.10.7 The lexical rules

The parser in micro-PROLOG has the relatively simple task of recognising tokens, converting tokens into variables, numbers and constants and constructing lists out of the token sequences that begin with `(` and end with `)`. There is a fairly close correspondence between the lexical token types and the distinctions the parser needs to make: numbers are made from numeric tokens, graphic tokens and quoted tokens form constants.

```text
Numbers          Constants
123   456        %   $   "A string including spaces"
```

The remaining kind of token, the alpha-numeric token, is recognised either as a variable or as a constant by the parser. micro-PROLOG recognises variables by examining the first character of alpha-numeric tokens (called the prefix character). If this character is a variable prefix character and the rest of the token is made up of digits then the token is read as a variable, otherwise it is taken to be a constant

```text
variable          constant
z123              zebra
```



In Spectrum micro-PROLOG the variable prefix characters are `x`, `y`, `z`, `X`, `Y` and `Z`.

Finally, when the parser encounters an open bracket, `(`, it constructs a list out of the sequence of terms parsed from the following token sequence that terminates with the corresponding closing bracket, `)`.



[Blank page with printed page number 18]



# Chapter 3
# The micro-PROLOG supervisor

micro-PROLOG is an interactive system. The top level interaction with the user is controlled through a special built-in micro-PROLOG program called the *supervisor*.

The micro-PROLOG supervisor provides a simple operating environment for the user. It allows programs to be entered, executed, edited, saved and loaded on files using various micro-PROLOG primitive relations as commands. In this chapter we describe the user interface to the supervisor and we illustrate the use of several primitive relations of micro-PROLOG that serve as useful supervisor commands.

The supervisor is an integral part of the micro-PROLOG interpreter; it is always present and cannot be deleted. The supervisor is called as soon as you enter micro-PROLOG. It is a non-terminating program which controls all your interactions with micro-PROLOG. The supervisor program, for the relation name `"SUP"`, is given in Chapter 7.

## 3.1 Entering clauses and issuing commands

If you need to know how to enter micro-PROLOG, refer to Appendix A. You can then follow the examples in this chapter using your ZX Spectrum.

As mentioned in Appendix A the

```text
&.
```

prompt that you get when you enter micro-PROLOG comprises an `&` printed out by the supervisor to tell you that it is ready to accept a clause or a command, and the read prompt `.` displayed by the terminal read primitive of micro-PROLOG. It is displayed because the supervisor, which is a micro- PROLOG program, immediately tries to read user input from the terminal. The supervisor accepts two kinds of user input; clauses or single argument commands. A command comprises the name of some single argument relation (a *unary relation*) followed by its single argument. The single argument relation can either be one of the primitive single argument relations of micro-PROLOG, all of which are fully described in Chapter 7, or it can be a user defined single argument relation. The supervisor does not distinguish between the two kinds of relations. The effect of this is to allow the user to define new supervisor 'commands'. Commands and clauses should be entered only when you get the `&.` prompt; however, see Appendix B for details of a limited type-ahead facility.

### 3.1.1 Entering clauses

To enter a clause you simply type the clause in response to the `&.` prompt and then press the ENTER or RETURN key. The clause is added to the program at the end of the sequence of clauses currently defining the relation of the head of the clause. For example:

```text
&.((Parent Mary John))<return>
&.((Parent Peter John))<return>
&.((App () x x))<return>
&.((App (x|X) Y (x|Z))<return>
1. (App X Y Z))<return>
&.
```

There is no supervisor command to enter a clause at a position other than at the end of the current sequence of clauses for its relation. To do this, you have to use the primitive `ADDCL` relation in a query command (see section 3.1.4 below), or the clause EDITOR (described in Chapter 4), or the MICRO extension to the supervisor (see Chapter 6).

Notice that the last clause is entered over two lines and that at the beginning of the second line the prompt is `1.` instead of `&.`. The `1.` prompt is issued by the keyboard read primitive because it knows that the term that is the clause for `App` is not yet finished even though the RETURN key has been pressed. It knows this because the parentheses of the first line do not balance. There is one right parenthesis to come; the `1` of the prompt tells you that it is waiting for this. For more information on entering clauses, or any list term, over several lines, refer to Appendix B. This Appendix also describes the micro-PROLOG line editor which can be used for editing the text of an input line before RETURN or ENTER is pressed.

### 3.1.2 Command format

The general format of a supervisor command is:

```text
&.<Command name><Command argument>
```

where the command name is a constant, and the command argument is a term whose exact form is dependent on the actual command. The command argument is what would be the single argument if the command name were used as a unary relation in a program. The supervisor knows when you have entered a command because the first thing it reads is a constant which is the command name. If the first thing you enter in response to the `&.` prompt is a list, it assumes that this is a clause and tries to add it to your program using the `ADDCL` primitive. If the list term does not satisfy the syntactic constraints of a clause you will get the `ADDCL` error message and the entered list will be ignored. If the first thing that you enter is a number, the supervisor will display a `?` response and ignore the number. `?` is the supervisor response that you will also get whenever a command fails.

### 3.1.3 THE LIST COMMAND

The micro-PROLOG clauses that you have entered can be listed at the console with the `LIST` command. When a program is listed it is displayed in an indented format to aid readability of the program.

```text
LIST ALL
```



lists the entire program.

```text
LIST <relation name>
```

lists all the clauses (in the current program) for the named relation. Finally,

```text
LIST (<relation name1> ... <relation namek>)
```

lists the programs for each of a list of named relations.

```text
&.LIST ALL
((App () X X))
((App (X|Y) Z (X|x))
    (App Y Z x))
((Parent Mary John))
((Parent Peter John))
&.LIST Parent
((Parent Mary John))
((Parent Peter John))
&.
```

The variables that appear in a listed clause will usually be different from the ones you used when you entered the clause. This is because, as we noted in section 2.4, variables are converted into a special internal form when a term such as a clause is read in. The name of the variable is lost; only its positions within the term are remembered.

When the term is listed, each variable is given a print name from the sequence of names `X`, `Y`, `Z`, `x`, `y`, `z`, `X1`, ... etc. The first variable in the term is displayed as `X`, the next as `Y` and so on. That is why the second `App` clause is listed as above.

### 3.1.4 The query command ?

micro-PROLOG programs can be queried using the primitive query relation `?`. This takes as its single argument a list of atoms which represents a conjunction of conditions to be solved. It can also be viewed as a sequence of *goals* or *procedure calls* each of which invokes the (generally) non- deterministic program for its relation. The way in which micro-PROLOG tries to find a solution to the conjunction of conditions is fully described in the *Primer*.

If a solution to the `?` query is found, then the supervisor displays its normal prompt:

```text
&.?((Parent x1 x))
&.
```

The query to show that someone `x1` is the parent of someone `x` succeeds.

If a solution cannot be found, ie the query fails, then a `?` is displayed before the next prompt:

```text
&.?((Parent x1 x2)(Parent x2 x1))
?
&.
```

The query to show that someone `x1` is the parent of someone `x2` and that the found `x2` is also the parent of the found `x1` has failed.



micro-PROLOG does not automatically print any response if the evaluation of the `?` query succeeds. If you want to see the values for variables for the found solution you must add an extra `PP` condition/call to the list. For example, to find the name of a Parent of John use the query:

```text
&.?((Parent x John)(PP The parent of John is x))
The parent of John is Mary
&.
```

`PP` is a built-in multi-argument relation that always succeeds with the side-effect of displaying its sequence of arguments at the terminal.

In Chapters 5 and 6, we describe other forms of query that automatically display the solutions.

#### 3.1.4.1 Interrupts and errors

Two interrupt keys are provided to interrupt the execution of any command. If the STOP key (SYMBOL SHIFT + A) is pressed, execution is suspended. Execution continues when any key is pressed. This is particularly useful when listing a large program with the `LIST` command.

To break into an execution the BREAK key (SYMBOL SHIFT + SPACE) is used. When a break is detected the `"Break!"` error is signalled and the execution is interrupted. Appendix C gives a complete list of the signalled error conditions of micro-PROLOG. It also describes how a signalled error can be trapped by a program for the reserved relation name `"?ERROR?"`. It gives an example definition of the relation, which is an error trap program that displays a short description of the error together with the call being evaluated when the error occurred.

You should always have some definition for `"?ERROR?"` present. The `ERRTRAP` file contains a module that exports a definition for this relation. It provides a sophisticated error trap and recovery utility; its facilities are described in the MICRO chapter, Chapter 6. However, you can load and use it separately from the MICRO system; see the description of `LOAD` in section 3.1.7.

#### 3.1.4.2 Other uses of the query command

The primitive relation `ADDCL` can be used in a query command to add a clause at a specified position in the current sequence of clauses for its relation. Thus

```text
?((ADDCL ((Parent John James)) 1))
```

will add the clause

```text
((Parent John James))
```

after the current first clause for the `Parent` relation. Since we already have

```text
((Parent Mary John))
((Parent Peter John))
```

the new clause will be inserted between these two clauses.

Individual clauses can be deleted using `DELCL`. This has a unary form and a binary form. In the unary form the single argument is the clause to be deleted. In this form it can be used as a command, eg

```text
DELCL ((Parent Peter John))
```

In the binary form its arguments are a relation name and the position of the clause to be deleted. In this form it must be used inside a query command, eg

```text
?((DELCL Parent 2))
```

deletes the current second clause for the `Parent` relation. See Chapter 7 (sections 7.8.2 and 7.8.3) for a complete description of the `ADDCL` and `DELCL` relations. See also section 4.3 for an explanation of how to add and delete and reposition clauses using the EDITOR.

### 3.1.5 User defined relations as commands

As we remarked earlier, any unary relation can be used as a command including relations defined by our own micro-PROLOG programs. This allows us to define new 'commands' to the system. For example, suppose that we have added the clause:

```text
((Show x) (? (x))(PP x))
```

which uses the supervisor query command `?` as an ordinary unary relation. By using `Show` as a command relation with a command of the form

```text
&.Show (<atom1> <atom2> .. <atomk>)
```

the `Show` program is invoked as though it were called with query

```text
?((Show (<atom1> <atom2> .. <atomk>)))
```

It evaluates the list of atoms and then prints the list in its solved form, ie, with variables replaced by their answer bindings.

The `?` command that we saw above is itself defined as a unary relation by the clause

```text
((? X)|X)
```

This clause uses the meta-variable feature described in section 2.9 in which the body of the clause is replaced by the value of the variable `X`. All other supervisor commands, such as `LIST`, are themselves just built-in micro- PROLOG programs for unary relations.

### 3.1.6 Multi-argument commands

Sometimes it is convenient to enter a command which has several arguments. One way to do this is to define it as a unary relation that takes a list of its parameters as its single argument. `?` is rather like this; its single argument is a list of any number of conditions to solve. Alternatively, we can define the command as a program for a unary relation that immediately reads in its extra arguments.

As an example

```text
((addcl X)
    (R Y)
    (ADDCL Y X))
```

is a program for a relation that can be used as though it were a two argument command. An example use is

```text
&.addcl 1 ((Parent John James))
```



When executed, the first argument, the `1`, is read in by the supervisor and becomes the single argument to the `addcl` call. This invokes the single clause for the relation which immediately reads in the next term (the clause to be added) using the primitive `R` relation. Then the two argument `ADDCL` is called with the position `X` and the clause `Y`. Compare this with the direct use of `ADDCL` using `?` that we gave earlier.

### 3.1.7 LOAD and SAVE commands

A user program can be saved in a file and subsequently loaded back into the workspace. The two supervisor commands `SAVE` and `LOAD` respectively save and load the user's programs.

The formats of the load and save commands are

```text
LOAD <file name>
SAVE <file name>
```

The `<file name>` must be different from that of any of your relations or currently loaded modules. If it is not you will get the `"File error"` error on trying to obey the command. If you get any error which returns you to supervisor mode during a `LOAD` you should `CLOSE` the file with a

```text
CLOSE <file name>
```

command because the file which was automatically opened for the `LOAD` will have been left open. If you do not close the file, a new attempt to `LOAD` or `SAVE` a file will get the `"Too many files error"` because only one file can be open at any time.

#### 3.1.7.1 File names

A file name may be any constant. The file name given in a micro-PROLOG `LOAD` or `SAVE` command must be different from that of any relation or module name. Using only uppercase letters in a file name helps to avoid that problem.

The `LOAD` command reads a program from the named file. If the program is not a module, it adds the program into the user's workspace as if it were typed in. Any program already in the workspace is not disturbed in any way by the `LOAD`: each new clause is added to the end of the current sequence of clauses for its relation. In this way, the programmer can have a library of programs, on a number of different files, which are loaded in as required when building up a new program.

The `SAVE` command saves the program currently in the workspace. The entire workspace is saved, ie, all the clauses that are listed in response to a `LIST ALL` command. A subsequent `LOAD` of the file containing the saved program will add the program to the workspace.

To save the programs for named relations only you need to use the two argument form of `SAVE` in a query command.

```text
?((SAVE FAMILY (Parent Male Female)))
```

will save all the clauses for the relations `Parent`, `Male` and `Female` in the file `FAMILY` on the current storage device. The second argument to `SAVE` is a list of the relations to be saved.

`SAVE` does not delete any program from the workspace. To do that you need to use `DELCL` or the `KILL` command described below.

### 3.1.8 The DICT relation

Do not worry about using long relation names, as all constants in a user program are stored in a dictionary and uses of the constants in the program become pointers into the dictionary. You can see this dictionary by executing

```text
LIST DICT
```

What you will see is something of the form

```text
((DICT & () (...) App Parent John .............)
```

which is a clause for the relation `DICT`, which is a multi-argument relation. The first three arguments are:

```text
1   the constant & which is part of top-level &. prompt and is the name of the
    workspace area,
2   the empty list, and
3   a list that will be empty unless you have loaded any modules; if you have,
    the second list will be all the names exported by currently loaded modules.
```

The remaining arguments are all the constants used in the workspace program.

The workspace name `&` is there because this is also the form in which you will see the dictionary of a module once the module has been opened (see section 7.10). `&` is the name of the special root module which is the workspace area. The first argument of `DICT` is always the name of the current module. For any module other than the root module the second argument will not be the empty list, it will be the list of all the exported names of that module.

The garbage collector clears constants from the workspace dictionary once there is no longer a reference to them in the program.

### 3.1.9 The KILL command

The `KILL` command can be used to delete all the clauses for a particular relation or list of relations.

```text
KILL Parent
```

deletes all clauses for `Parent` and

```text
KILL (Parent App)
```

deletes all clauses for `Parent` and `App`.

```text
KILL ALL.
```

will delete all clauses in the current workspace. It should be used with care, and usually only after the use of `SAVE`. A final form of use of `KILL` is

```text
KILL <module name>
```

This gets rid of a loaded module.

### 3.1.10 Restarting micro-PROLOG

To restart micro-PROLOG use the command



```text
NEW.
```

The dot following the command is used to give a dummy argument to `NEW`. Remember that all commands invoked directly from the supervisor level must have one argument even though it may be ignored; we could have typed `NEW m` but the dot saves our having to insert a space to separate the tokens.

To exit from micro-PROLOG to BASIC, simply turn off the power supply to the Spectrum and turn it on again. You will then be back in BASIC.

### 3.1.11 Display modes

When you enter micro-PROLOG the display is in the NORMAL mode. Lines are displayed starting at the top of the screen, and the whole screen is used for text display. You can limit the display of text to the bottom four lines of the display by entering the HYBRID mode with the command

```text
HYBRID.
```

Again, the `.` or some other ignored argument must be given so that the supervisor can recognise it as a command.

In `HYBRID` mode the top 20 lines of the display are left clear for graphics display. The graphics primitives available in Spectrum micro-PROLOG are described in Chapter 7.

To return the display to the NORMAL mode, enter

```text
NORMAL.
```

Both display commands also clear the display. To clear the display in NORMAL mode without changing to HYBRID mode do a

```text
CLS <colour number>
```

where `<colour number>` gives the new colour for the background of the display.

```text
CLS 7
```

will clear the screen and make the background white.

### 3.1.12 Using the Sinclair Printer

You can arrange that any text subsequently written to the screen display is copied on to the Sinclair Printer by typing `TO` (SYMBOL SHIFT + F). So `LIST ALL` for example will now list all the clauses on the screen and simultaneously produce hard copy on the printer. This will continue until you type `TO` again.



# Chapter 4
# Utility modules

The micro-PROLOG system comes complete with a considerable number of utility modules. These are micro-PROLOG programs, wrapped up as modules for convenience, to provide useful facilities for the user. Appendix E describes the pragmatics of micro-PROLOG file access for various storage media.

## 4.1 Tracing execution

A trace program is provided with the system as a module with the name `trace-mod` in the tape file `TRACE`. The trace module allows, interactively, selective tracing of the execution of a query.

To use the trace program execute a `LOAD TRACE` command. This will load the module that is in the file. To get rid of the program when you have finished tracing do a `KILL trace-mod`. Note the asymmetry. To bring in a module you do a `LOAD` using the name of the file that contains it. To delete it you do a `KILL` using the name of the module. Nearly all the utility modules provided have a name of the form: `<name>-mod` where `<NAME>` is the name of the file that contains them.

The module exports the relation name `??`. This is used in exactly the same way as the supervisor `?` query command, eg

```text
&.??(<atom1>...<atomk>)
```

The difference is that you are lead through the evaluation of the query step-by-step, a call at a time.

When entering a call for the first time a message of the form

```text
<call id>(R <seq. of args of call>)
```

is displayed at the console. The term printed represents the call/condition just before any attempt at evaluation, with all of the known values of variables substituted in place. The `<call id>` is a list of numbers identifying the ancestry of the call back to the original query. The length of the list corresponds to the depth of the evaluation. As an example, the list

```text
(1 3 2)
```

identifies the call as the first condition of the body of a clause invoked to solve the third condition of the body of a clause invoked to solve the second condition of the original query.

If the relation name `R` of the call refers to one of the micro-PROLOG primitives (all described in Chapter 7) then the call is immediately executed. The logical primitives `IF`, `OR`, `NOT`, `ISALL` and `FORALL` are exceptions; however, they can be traced - see below. If the call is for a user defined relation then the message `trace?` is also printed and the read prompt displayed. One of the allowed trace responses must then be entered.

The trace responses allow selective tracing of the program. For example, low level (or already debugged) programs can be skipped by responding `n`, ie, no tracing. The allowed trace responses are

```text
n (for no), y (for yes) s (for succeed), f (for fail), q (for quit)
```

```text
1. n
```

If `n` is entered the call is executed without tracing. In this case one of two things normally happens: either the call is solved or the attempt to solve it fails. If it fails then the message

```text
<call id> failing (R <seq. of arguments of call>)
```

is displayed and the system backtracks. This failure may cause backtracking on calls that were previously solved if there are no untried ways of solving them. Each time there is backtracking on a call, the call is displayed with the failing message.

If the evaluation of a call succeeds then the message

```text
<call id> solved (R <seq. of instantiated arguments of call>)
```

is displayed. In this case the call is printed with the answer bindings substituted, so that you can see the result of the evaluation just completed. If the call was the last in the body of a clause then the immediate ancestor of the call is also solved, in which case a solved message is displayed for it too.

After solving a call, remaining unsolved calls are entered and traced in turn. This continues until the last call of the original query is solved or until its first call is failed.

```text
2. y
```

Entering `y` allows the tracing of the evaluation of the call. The trace program looks for a clause to match the call. If no clause matches the call, the *failing* message described above is displayed. If there is a clause that matches (ie a clause whose head atom unifies with the call) the message

```text
<call id> matches clause n
```

is displayed. The `n` is the position of the clause in the sequence of clauses for relation of the call.

If the clause that matches the call is an assertion, then since there are no atoms to trace inside the body of the clause, the call has been solved and a *solved* message displayed. Otherwise each of the atoms in the body of the clause is entered and traced in turn. On entering the body of any clause that matches the call the `<call id>` is extended by a first number that identifies the position of the call in the body of the clause.

```text
3. s
```

Entering `s` arbitrarily solves a call. The immediate response is a printing of the call with the solved message. The trace program does not try to use any clauses for the call, nor does it instantiate any variables in the call.

```text
4. f
```

Entering `f` arbitrarily fails the call, and to cause the evaluation to backtrack. The failing message for the call is displayed.

```text
5. q
```

Entering `q` quits the trace evaluation. Use it to obtain a quick exit and return to the supervisor.

The trace program insists that a legal trace response is entered. If an erroneous response is input the program displays the message

```text
ENTER y n s(for succeed) f(for fail) q(for quit)
```

and prompts you again. When you are asked whether you want tracing inside one of the logical primitives `IF`, `OR`, `NOT`, `ISALL` or `FORALL` the allowed responses are only `y` or `n`, but this restriction is indicated by the prompt `trace?(y/n)`. To this prompt, any response but `y` is taken as `n`.

Warning

The use of the trace program greatly increases space demands on the heap and stack; thus programs which run without tracing may well run out of space when traced.

As we mentioned earlier, the trace program, being a module, will not be loaded into the user program workspace. So when you do a `LIST ALL` you will not see any of the trace program. (A `LIST ??` enables you to see the clauses for `??` since this is an exported relation of the module.) Loading the trace module does however reduce the amount of space available for user programs. It should therefore be deleted when you have finished using it with the `KILL trace-mod` command; you can always re-load it when required.

## 4.2 Spypoint tracing

Sometimes, all that you want to trace is the entry/exit behaviour of a program. A utility module called `spytrace-mod` in the file `SPYTRACE` enables you to spypoint trace a program in this way. To use the module enter a `LOAD SPYTRACE` command. To get rid of it when you have finished, enter a `KILL spytrace-mod`, and a `KILL spypoints` to get rid of a clause in the workspace that will have been put there by the `SPYTRACE` program. Loading the program adds the clause

```text
((spypoints on))
```

to your workspace program. This is a message that causes entry/exit information to be given for all the spy specified relations.

The module exports three relations: `spy`, `unspy`, `spying`. The first two are unary relations that are used as commands. The `spying` relation has two uses, as a command to turn the tracing on and off (this manipulates the `spypoints` clause), and as a two argument relation to give entry/exit information for a particular call.



### 4.2.1 The spy command

If you want to have entry/exit information for all calls for a user defined relation `R`, do a

```text
spy R
```

command. If you now `LIST R` you will find an extra clause has been added to the front of its program. The spy command has added the clause.

```text
((R|X)
    (spypoints on)    {check that spy relations should be traced}
    (/)               {execute / to prevent other clauses being used
                       to solve this call}
    (spying R X))     {evaluate (R|X) call using the other clauses
                       giving some trace information}
```

The `"{" , "}"` bracketed comments will not appear. If the `((spypoints on))` clause is not in the workspace, the user provided clauses for `R` will be used to solve the call in the normal way. If it is present, the call `(R|X)` is evaluated by the call `(spying R X)` to the spying relation.

You cannot spy a micro-PROLOG primitive relation or any relation exported by a module. The attempt to do so will result in the `"Cannot add clauses for"` error being signalled as the spy command tries to add the extra clause.

### 4.2.2 The spying relation

This takes two arguments, the name of the relation `R` of the call to be entry/exit traced and the list `X` of the arguments of the call.

The evaluation of

```text
(spying R X)
```

is equivalent to the evaluation of

```text
(R|X)
```

except that some trace information is given as the call is evaluated. On entry, a message of the form

```text
<call id> : R <list X of arguments of call>
```

is displayed. The `<call id>` is an integer. The `<call id>` is increased on each call of `spying` and decreased if the call fails. During the evaluation of the call to `R` it is identified in subsequent trace messages by the `<call id>`.

As each user supplied clause that matches the call is tried the message

```text
<call id> matches clause <clause number>
```

is displayed. The `<clause number>` is the position of the clause in the listing of all the clauses for `R` including the clause added by the spy command. So the first user clause for `R` has clause number 2.

If the call is solved using this clause the message

```text
<call id> solved R <list X of instantiated arguments>
```

is displayed giving any solution bindings for the call.

Finally, if the call fails, the message

```text
<call id> backtracking on R <list of original arguments X>
```



is displayed. After this message, the `<call id>` will be re-used to identify a different spying call.

The spying relation can be used directly in user supplied clauses and queries. For example, the query

```text
?((spying father-of (tom X))(spying male (X)))
```

will give you trace information on the evaluation of the two calls even if `father-of` and `male` are not spy specified relations.

### 4.2.3 The spying command

The command

```text
spying on
```

switches on the spypoint tracing of all the spy specified relations. It adds the clause

```text
((spypoints on))
```

to the workspace program and removes the clause

```text
((spypoints off))
```

if it is present.

The command

```text
spying off
```

will remove the

```text
((spypoints on))
```

clause from the workspace and replace it by

```text
((spypoints off))
```

It switches off the spying of all the spy specified relations. By LISTing the `spypoints` relation you can see whether the spying is on or off.

### 4.2.4 The unspy command

The command

```text
unspy R
```

will remove the extra clause added for `R` by the spy command. It stops all the automatic spying of calls to `R`.

## 4.3 The micro-PROLOG structure editor

The micro-PROLOG structure editor takes into account the list structure of micro-PROLOG clauses and terms, and allows the PROLOG programmer to edit programs within the micro-PROLOG environment. Since the editor is itself written in micro-PROLOG it is easy to extend and modify. At any moment the editor is focused on a *current term* which has an *immediate context*; the list that the current term is in. To act as an `aide-memoire` the editor uses the current term to form its prompt when the editor is ready to accept a command. At the top-most level of editing a program (where the current term is one of the clauses of the program and the context is the list of clauses for a relation) the editor prefixes the prompt with a number; this number indicates the position, within the list of clauses, of the current clause.



If at any time the current term `pointer` is not a term or clause in the program then the editor displays `No term` or `No clause` as its prompt. The commands allow changing the current term, changing the context, moving or deleting or modifying the current term, and inserting new terms.

### 4.3.1 Edit commands

Before using the editor it is necessary to LOAD the editor module (called `editor-mod`) using the command

```text
LOAD EDITOR
```

To delete it when you have finished use

```text
KILL editor-mod
```

The editor is invoked using the command

```text
EDIT <relation name>
```

for example to edit the `likes` program enter

```text
EDIT likes
```

The editor uses the first clause in the program (if the program is non-empty) as the initial current term. In the case of the `likes` program this could be

```text
[1] ((likes John Mary)).
```

If there are no clauses for `likes` you will get

```text
[0] No clause.
```

in which case the first thing you should do is add a clause using the `a` command. The editor offers a handy tool for building new programs as well as for modifying existing ones.

When the editor displays its prompt it is ready to accept an *edit command*, which at the top level can be any of the `a` (append), `b` (back), `c` (copy), `e` (enter), `f` (fix), `i` (insert), `k` (kill), `m` (move), `n` (next), `o` (out), `s` (substitute), `t` (text), `v` (variables) commands. The edit commands are divided into two groups: those which move the current term pointer in the structure of the terms being edited, and those which change the terms in some way.

### 4.3.2 Cursor movement commands

There are four commands which can be used to walk over the program; `n`, `b`, `e` and `o`.

```text
1. The n (next) command changes the current term to the next term to the
right in the immediate context. At the top level this means move to the next
clause. As an example, if the current term is (A B), and the immediate context
is (C (A B) (D)) then the n command moves the current term to (D)
```

```text
(A B).n
(D).
```

whereas at the top-level we get the next clause

```text
[1] ((likes John Mary)).n
[2] ((likes X Y) (knows X Y) (likes Y X))
```

If the current term was already at the last term in the immediate context, or if it was the last clause in the program, the pointer is stepped on, but the current term becomes `No term`, (or `No clause` at the top level) indicating that it is not actually pointing to a term or clause. It is impossible to step beyond this point.

```text
2. The b (back) command is the inverse of the n command. It is used to step
back to the term to the left of the current term in the immediate context, or
to step to the previous clause. To undo the effect of the previous n command
above
```

```text
(D).b
(A B).

[2] ((likes X Y) (knows X Y) (likes Y X)).b
[1] ((likes John Mary)).
```

If the current term were already the first term, then the `b` command steps back to in front of it, again causing the prompt to become `No term` (`No clause`), eg

```text
(A B).b
C.b
No term.

[1] ((likes John Mary)).b
[0] No clause.
```

It is not possible to move before this point.

```text
3. The e (enter) command steps 'into' a term or clause so as to edit its
components. The term being stepped into must be a list structure. Note that
you cannot get 'inside' a number, constant or variable using these structure
move commands. To change these you must use the t (text) or the s
(substitute) command. The immediate context becomes the list term just
entered, and the current term is the first element (if any) of that list. So in our
example, if we enter the list (A B) we change our immediate context and
point to A
```

```text
(A B).e
A.
```

or

```text
[2] ((likes X Y) (knows X Y) (likes Y X)).e
(likes X Y).n
(knows X Y).n
(likes X Y).
```

Note what happens as we step along the entered clause. As we reach each atom it is printed with the variables in the atom assigned print names from the list `X, Y, Z, x, ...`. This means that sometimes it will appear that the editor has changed the variable names.

As we moved to the `(knows X Y)` atom of the clause we actually got the same names displayed by accident. When we moved to the `(likes Y X)` atom of the clause this was displayed as `(likes X Y)`. Within this atom, the `Y` that we saw when the whole clause is displayed is the first variable, so its print name is `X`. The variable we now see as `X` is the variable that we saw as `Y` at the whole clause level.

This change of names as we enter and then step along a clause can be a little disconcerting. It does not matter unless you want to change a variable in a clause. To do this you should use the `t` text edit command at the whole clause level or at least at a term level in the clause that covers all the occurrences of the variable you want to change. Alternatively, you should use the `f` and `v` commands described below to temporarily fix the variables of a clause as constants. Changing or adding a new variable is then achieved by changing or adding new `vars` constants.

```text
4. The o (out) command is the inverse of the e (enter) command. The current
immediate context becomes the current term, and the 'old' immediate
context (prior to the corresponding e command) is re-established as the
immediate context. The o command is also used to exit the editor, when at
the top level
```

```text
(likes X Y).o
[2] ((likes X Y) (knows X Y) (likes Y X)).o
Edit of likes finished
&.
```

The `o` command may fail if the entered term has been incorrectly changed. This will happen if on returning to the outer level the predicate symbol of the head of the clause has been changed to a variable or the name of a primitive relation. When an edit command fails the editor responds with a `?` and re-prompts at the appropriate level. If you change the relation that a clause is about to another allowed program relation name you will be asked if you want the clause added to the program for the new relation; if you respond `yes`, you will be asked for the position for the clause; this should be a positive integer. The clause will be inserted after the current clause at that position.

You can reach any sub-term of a program with these four cursor control commands. In the next section we look at those edit commands that directly change the current term.

### 4.3.3 Edit change commands

There are nine commands which directly affect the current term; these are `i` (insert) a new term, `a` (append) a new term, `k` (kill) the current term, `s` (substitute) another term, `t` (text) edit the term, `c` (copy) a clause, `m` (move) the term, `f` (fix) the variables as `vars` constants in a clause and `v` introduce variables for the `vars` constants of a clause. The `c`, `f` and `v` commands can only be used at the top clause level and the `s` command is only available below the clause level.

```text
1. The i (insert) command inserts a term before the current term. The i is
```



followed by the term to insert as in

```text
(A B).i (F)
(F).
```

The new term just inserted becomes the new current term, the old one can be regained by stepping on to it with the `n` command.

At the top level the `i` command inserts a new clause into the program. In this case the form of the clause is checked to ensure that at least the clause is for the relation currently being edited. If it is not, or the clause is incorrectly formed, the insert fails and the old term is re-displayed as the prompt.

```text
[1] ((likes John Mary)).i ((likes Bill Mary))
[1] ((likes Bill Mary)).n
[2] ((likes John Mary)).
```

```text
2. The a (append) command appends a new term (or clause) after the current
term; otherwise it is like the i command.
```

```text
3. The k (kill) command deletes the current term from the immediate context.
The term (or clause) to the left of the deleted term in the immediate context
becomes the new current term, if there is not a previous term (or clause) then
the current term becomes No term (No clause). We can delete a particular
element of a list by using a sequence of cursor movement commands to
move to the required term and then using the k command.
```

For example, to delete the third element of `(A B C D)`

```text
(A B C D).e
A.n
B.n
C.k
B.o
(A B D).
```

```text
4. The s (substitute) command replaces the current term with a new term.
The argument to s is a pair

(t1 t2)
```

The term `t1` is unified with the current term, and then the current term is replaced by `t2`. The use of unification allows quite powerful pattern matching, but more importantly the specification of the replacement can make use of variables bound in this match. For example, to reverse the first two elements of a list

```text
(A B C D).s ((x y|z)(y x|z))
(B A C D).
```

*Note:* the `s` command is not available at the top level.

```text
5. The t (text) command allows the current term to be changed using the line
editor described in Appendix B. It displays the term on one or more lines of
the screen and positions the cursor at the beginning of the line. (The term
```



must be no more than 250 characters.) You are in the edit mode of the line editor in a state equivalent to having just executed the `l` command. The edit mode commands described in Appendix B are available to modify the text of the term. When you press the RETURN key, the system reads the text back in and replaces the current term by it.

If you use `t` to modify a term which is a component of a clause be careful not to change the displayed names of any variables that also occur outside the term. If you leave the names unchanged then the link between these `global` variables with their occurrences outside the term will be restored on exit from the text edit. This is possible because the primitive `RFILL` relation (see section 7.3.4) used by the `t` command remembers the print name it assigns to each variable (which has a unique internal name) before it puts the text of the term into the keyboard buffer. When it reads in the text it replaces the occurrences of these remembered print names with the original internal names of the variables. This re-establishes the link with the variable occurrences in the rest of the clause when the reconstructed term is inserted in the clause. Alternatively, you can fix all the variables of the clause as constants using the `f` edit command.

```text
6. The c (copy) command allows you to copy a clause; it can be used only at
the clause level. It is very useful when you are building up a program in which
two or more clauses differ only slightly. You insert one, then copy it using c. c
places the copy after the copied clause and makes it the current clause. You
then edit the copy to give the variant of the first clause.

7. The m (move) command allows you to move a term within the current
context. At the top level it repositions a clause within the sequence of clauses
for its relation. m takes one argument, an integer which gives the
displacement to the right or left within the current context. A positive integer n
moves the term to the right (forwards) n positions, a negative integer -n
moves it to the left (backwards) n positions. You cannot move the term
outside the current context. If you give too large a right move the term is
simply placed at the right end; too large a left move puts it at the left end.
The moved term remains the current term after the move.
```

```text
[1] ((likes Bill Mary)).m 1
[2] ((likes Bill Mary)).b
[1] ((likes John Mary)).n
[2] ((likes Bill Mary)).m -4
[1] ((likes Bill Mary)).
```

```text
8. The f command allows you to temporarily fix all or some of the variables of
a clause as constants. It can only be used at the top clause level and it can
only be used once — a second f applied to the same clause before the effect
of the first has been undone with the v command described below will fail. Its
form of use is
```



```text
f (constant1 constant2 ... constantk)
```

The result is that the first `k` variables of the clause will be replaced by the `k` constants given in the list following the `f` and when the clause is displayed an extra atom

```text
(vars constant1 constant2 ... constantk)
```

will appear as a new last condition of the clause to remind you which constants in the clause are really variables. To change a variable you now change the constant that has replaced the variable. To add a new variable, use a new constant and then record that it is a constant standing for a variable by editing the `vars` atom so that it includes the new constant.

*Example*

```text
[2] ((likes X Y) (knows X Y) (likes Y X)).f (person1 person2)
[2] ((likes person1 person2) (knows person1 person2) (likes person2
person1) (vars person1 person2))
```

```text
9. The v (vars) command reverses the f command. Again it can be used only
at the clause level. It replaces all the constants given in the vars condition at
the end of the current clause by new variables throughout the rest of the
clause. Each occurrence of the same vars constant gets replaced by the same
new variable. After the substitution, the vars atom is removed from the
displayed clause.
```

*Example*

We can continue the above example use of `f` in order to add a new condition which requires `person2` to be female.

```text
[2] ((likes person1 person2) (knows person1 person2) (likes person2
person1) (vars person1 person2)).e
(likes person1 person2).a (female person2)
(female person2).o
[2] ((likes person1 person2) (female person2) (knows person1
person2) (likes person2 person1) (vars person1 person2)).v
[2] ((likes X Y) (female Y) (knows X Y) (likes Y X))
```

To add this extra condition without using `f` and `v` we would have to use the `t` command at the clause level to text edit in the new condition `(female Y)`.

*Exiting the edit without doing a v*

If you exit the edit of the definition of a relation in which you have used `f` but you have not undone its effect with a `v` command you will still be able to use the clause in the normal way. If you `LIST` the program you will see that all the `vars` constants have actually been replaced by new variables as when you do a `v` but there will be an extra `/*` comment condition as the first condition of the clause. This will be of the form

```text
(/* vars (X1 constant1) (X2 constant2) ... (Xk constantk))
```

where `constant1 ... constantk` are the `vars` constants of the clause that were given in the `vars` atom just before you exited the edit and `X1 ... Xk` are the variables that now appear in place of these constants.

*Example*

Suppose that in the above example we exit the edit before doing the `v`. If we list `likes` the second clause will be displayed as

```text
((likes X Y)
    (/* vars (X person1) (Y person2))
    (female Y)
    (knows X Y)
    (likes Y X))
```

In fact, it was saved in this form even during the edit. The editor automatically converts clauses that have a first condition which is a comment associating constants with variables into the special form in which the variables are replaced by the associated constants when you are about to edit the clause. It also maps the `/*` comment into the `vars` last atom of the clause. The `f` command adds such a condition to the clause, relying on the editor to display it in the right form, and the `v` command simply deletes the comment. This means that if we now start to re-edit `likes` we will see the clause in the form in which it was last displayed by the editor.

```text
EDIT likes
[1] ((likes John Mary)).n
[2] ((likes person1 person2) (knows person1 person2) (likes person2
person1) (vars person1 person2))
```

Finally, if we use the editor to develop programs we can even enter clauses which use constants instead of variables. All we need do is to make sure that this special use of constants is signalled to the editor by the appropriate `vars` condition at the end of the clause.

*Example*

```text
EDIT append
[0] No clause.a
((append () list list)
    (vars list))
[1] ((append () list list) (vars list)).a
((append (h|t) list (h|t1))
    (append t list t1)
    (vars h t list t1))
[2] ((append (h|t) list (h|t1)) (append t list t1) (vars h t t1 list)).o
Edit of append finished
&.LIST append
((append () X X)
    (/* vars (X list)))
((append (X|Y) Z (X|x))
    (/* vars (X h) (Y t) (Z list) (x t1))
    (append Y Z x))
&.
```



### 4.3.4 Restructuring lists

Given the importance of lists in micro-PROLOG, it is essential to be able to repair an arbitrarily damaged list. Where it is just a sub-term of a list that is damaged, the above commands are sufficient. However, a problem arises if some parentheses have been put in the wrong places. For example, a left parenthesis can be easily missed as in

```text
[1] ((Prog A X) PR X Y)
```

and a right parenthesis can be put in too far to the left, as in

```text
[2] ((Prog A X)(PR) X Y)
```

or too far to the right, as in

```text
[3] ((Prog A X (PR X Y)))
```

What this means is that the clause has the wrong sub-list structure. The editor has two simple primitives which can be used to re-structure the sublists of a clause: `w` (wrap) and `u` (unwrap).

```text
1. The w (wrap) command takes a number of terms from the immediate
context and wraps them up into a list, which becomes the current term. The
w command has an argument: the number of terms to wrap starting from the
current term. If 0 (zero) is used then no terms are wrapped, ie, the empty list
() is inserted. If 1 (one) is used then the current term only is wrapped, if 2
(two) then the current plus the next term (to the right) are wrapped, and so
on up to the number of the remaining terms in the immediate context.
```

For example, to wrap up the middle two elements of `(A B C D)`

```text
(A B C D).e
A.n
B.w 2
(B C).o
(A (B C) D).
```

```text
2. The u (unwrap) command is the inverse of the wrap command. The
current term must be a list; the effect is to remove the outer pair of
parentheses of the list. The first element of the list becomes the current term,
and the other elements are inserted into the immediate context. To undo the
effect of the wrap above we could perform the following sequence
```

```text
(A (B C) D).e
A.n
(B C).u
B.o
(A B C D).
```

Now we can see how to use these two commands to repair the various terms we showed above.



Case 1: `((Prog A X) PR X Y)`

This case is quite simple; we wrap up the sub-list `PR X Y` into a single list, so that it is put into the correct form

```text
[1] ((Prog A X) PR X Y).e
(Prog A X).n
PR.w 3
(PR X Y).o
[1] ((Prog A X)(PR X Y)).
```

Case 2: `((Prog A X)(PR) X Y)`

This case is a little more complex; a right parenthesis has been inserted too far to the left. To repair this we need to unwrap the list `(PR)`, and re-wrap including the missing arguments

```text
[2] ((Prog A X)(PR) X Y).e
(Prog A X).n
(PR).u
PR.w 3
(PR X Y).o
[2] ((Prog A X)(PR X Y)).
```

Case 3: `((Prog A X (PR X Y)))`

Here, we have first to wrap up the sub-list `Prog A X` to form an atom of the right form

```text
[3] ((Prog A X (PR X Y))).e
(Prog A X (PR X Y)).e
Prog.w 3
(Prog A X).o
((Prog A X)(PR X Y)).
```

Now we have one too many pairs of parenthesis at this level, so we unwrap

```text
((Prog A X)(PR X Y)).u
(Prog A X).o
[3] ((Prog A X)(PR X Y)).
```

This last unwrap has `removed` the right parenthesis that was too far to the right.

The above three examples illustrate the `w` and `u` commands. All three could also be handled using the `t` command at the top level to edit each clause as character text.

### 4.3.5 Further extension

This editor represents a first attempt at the development of a term-oriented structure editor for micro-PROLOG. Further possibilities for improvement are context searching and combining commands with a repeat count. Since the editor is itself written in micro-PROLOG these enhancements should be quite straightforward.



## 4.4 Editing modules

The modules section of Chapter 7 gives a description of modules and the problem of editing a user program that has been wrapped up as a module. Only workspace programs can be easily edited using the above structure editor; what we need is a utility that allows modules to be unwrapped into workspace programs, and then, after editing, allows them to be wrapped up again as modules.

The `MODULES` file of the distribution system contains such a utility program called `modules-mod`. Before use it must be loaded with a `LOAD MODULES` command; `KILL modules-mod` will get rid of it and recover its space.

The module exports three relations — `unwrap`, `wrap` and `save-mods` — that are used as commands. All commands require access to files: see Appendix E. The `unwrap` command creates a temporary file containing the clauses of the module which are reloaded for editing. The `wrap` command reSAVEs the edited clauses as a wrapped up module in a file. As the supervisor `SAVE` only allows one module to be saved, the `save-mods` command is provided to save several modules in one file — `MICRO` and `SIMPLE` are examples of this. The `wrap` and `unwrap` commands of this module are quite different from the `w` and `u` editor commands described above.

### 4.4.1 The unwrap command

To transfer the clauses of a module named `M` into the workspace for editing, first SAVE any existing workspace program, then do a `KILL ALL` to clear the workspace, then do an

```text
unwrap M
```

command. The message

```text
Unwrapping module M onto scratch file
```

will be displayed and you will be prompted with any file control actions required to save and reload the module clauses. When the load is complete you will get the message

```text
M now in the workspace
```

All the clauses owned by the module will be in the workspace along with an extra clause

```text
((Module M <export list> <import list>))
```

which gives the name `M` of the unwrapped module and its export and import name lists. You can now edit or add to the clauses in the workspace using the structure editor described above. You can also edit the extra `Module` clause to change the name of the module or to change its export/import lists. But do not delete it — it is used by the `wrap` command to reconstruct the module.

### 4.4.2 The wrap command

When you have finished editing the unwrapped module do a

```text
wrap <file name>
```

command. This command uses the information in the `Module` clause in the workspace to create a module containing all the other clauses in the workspace which it then saves as a file. It also clears the workspace.

On entering the command you will get the message

```text
Saving module M in file <file name>
```

and you will then be prompted with any file control actions required for saving the module as a file. When the save is complete you will get the message

```text
Workspace clear
```

If you want to use the newly edited module, LOAD the module in the normal way. By explicitly adding a `Module` clause to a workspace program you can use `wrap` as a quick way of creating and saving new modules.

### 4.4.3 The save-mods command

`save-mods` can be used to save more than one module in a file. When you LOAD the file all the modules it contains will be loaded. Its form of use is:

```text
save-mods <file name> <list of module names>
```

eg:

```text
save-mods file1 (sort-mod any-mod)
```

As with `wrap` and `unwrap` you will be prompted with any file control actions required.



# Chapter 5
# SIMPLE PROLOG

SIMPLE provides quite an elaborate extension to the facilities of the built-in supervisor. It provides commands to add, delete and text edit programs and supports several high level forms of query. The most important feature is that it allows clauses to be entered and queries to be posed using a much more user friendly syntax than the basic syntax described in Chapter 2. The SIMPLE syntax for clauses is much closer to the syntax of English. SIMPLE is therefore a very attractive system for newcomers to micro-PROLOG programming; it is the system described in the *Primer*.

The form of clause accepted by SIMPLE is called a *sentence* because its syntax is so different. The program development commands of SIMPLE compile sentences into clauses and map the clauses back into sentences when they are displayed. For most uses, the programmer does not need to know anything about the syntax of clauses, only the syntax of SIMPLE sentences. However, you can always see the sentences in their compiled clause form by using the `LIST` supervisor command. In contrast, the list command of SIMPLE maps the clauses back into sentence form before displaying them.

To use SIMPLE you execute a `LOAD SIMPLE` command. However, note the warning at the beginning of the next chapter on MICRO. None of the MICRO modules should be present when you load in SIMPLE. The file `SIMPLE` which will be loaded contains three modules called

```text
query-mod
program-mod {also in the file PROGRAM}
errmess-mod
```

`query-mod` is the module which defines and exports all the relations that compile and de-compile SIMPLE sentences; it also includes the definitions of the query commands and other pre-defined relations supported by SIMPLE. `program-mod` is the module that defines all the program development commands, for example, the commands to add, delete and list SIMPLE sentences. It can be optionally killed, with a

```text
KILL program-mod
```

command, when a program has been developed in order to free space for the evaluation of queries. When the program needs to be edited or added to, this module can then be loaded from the file `PROGRAM` which only contains the module with a

```text
LOAD PROGRAM
```

command. Finally, `errmess-mod` is a very simple error handling module. It exports the definition of a relation called `?ERROR?`. When this relation is defined the micro-PROLOG interpreter calls its program on encountering a runtime error. The `?ERROR?` program in `errmess-mod` displays the condition currently being evaluated together with a more meaningful error message than the default error messages. For more information on error handling consult Appendix C. The messages given by `errmess-mod` are very similar to those of the example error handler given in that Appendix. The module can be killed and replaced by the `errtrap-mod` error handler described in section 6.3, or by one called `deftrap-mod` which is described below.

Three other modules in the files `EXPTRAN`, `TOLD` and `SIMSHOW` can be optionally loaded and used with SIMPLE. The first file contains the module `exptran-mod`. When this is present expressions can be used in sentences and these are compiled into a sequence of conditions that evaluate the expression. The second file contains the module `told-mod` which defines and exports the relation `is-told`. This can be used in a straightforward way to write interactive programs — programs that ask for information by posing queries to the user. The `is-told` program can also be invoked from the error handlers `deftrap-mod` and `errtrap-mod`. The third file allows graphics queries from SIMPLE.

## 5.1 Syntax of sentences accepted by SIMPLE

A sentence is either a *simple sentence* or a *conditional sentence*.

### 5.1.1 Simple sentences

Simple sentences have four forms: infix, postfix, prefix and single condition.

infix simple sentences have the form:

```text
<term> R <term>
```

where `R` is a constant which is the name of a two argument (binary) relation. The terms on either side of `R` are the two arguments of the binary relation, eg

```text
John likes Mary
x LESS 45
```

Postfix simple sentences have the form

```text
<term> R
```

where `R` is a constant which is the name of a single argument (unary) relation, eg

```text
Tom male         {male is the unary relation}
x a-father       {a-father is the unary relation}
```

Prefix simple sentences have the form

```text
R(<term1> <term2> .. <termk>)
```

where `R` is a constant which is the name of a `k` argument relation. The list of terms following `R` are the `k` arguments of the relation and are separated only by spaces, eg

```text
SUM(X 5 34)
APPEND( (2 3) (4 5) X)
```

Sentences about binary relations and unary relations can be entered in this prefix form but will always be displayed by SIMPLE in the infix or postfix form, eg

```text
Bill likes x    can be entered as    likes(Bill x)
x male          can be entered as    male(x)
```

Single condition simple sentences have the form

```text
C
```

where `C` is a constant that names a 0-argument relation or condition, eg

```text
FAIL
/
Bill-likes-Mary {the hyphens make it one constant}
```

### 5.1.2 Conditional sentence

Conditional sentences have the form

```text
<simple sentence> if <conjunctive condition>
```

where a conjunctive condition is either a condition or a conjunction of the form

```text
<condition> and <conjunctive condition>
```

`&` is an accepted abbreviation for `and`.

A condition is either a simple sentence or a complex condition. A complex condition may be

```text
1. a negated condition of the form

   not <condition>
```

or

```text
not (<conjunctive condition>)
```

eg

```text
not x male
not (x male and x likes Mary)
```

```text
2. an isall condition of the form

   <term> isall (<term> : <conjunctive condition>)
```

eg

```text
x isall (y : Bill father-of y and y male)
```

```text
3. a forall condition of the form

   (forall <conjunctive condition> then <conjunctive condition>)
```

eg

```text
(forall Tom father-of y then y male and y married)
```

The outer brackets are essential.

```text
4. an or condition of the form

   (either <conjunctive condition> or <conjunctive condition>)
```

eg

```text
(either x likes Peter or Peter likes x & Sally likes x)
```

Again the outer brackets are essential.

```text
5. an equality condition of the form

   <expression> = <expression>
```

```text
6. an expression condition of the form

   R #( <expression> <expression> ... <expression> )
```



Expressions are terms of a special form; their syntax is given in section 5.3 below. Expressions can be used only if the optional `EXPTRAN` has been loaded.

The syntax of terms is as described in Chapter 2 — with one difference: the control characters allowed in quoted constants in clauses should not be used in sentences. If they are, they will not be displayed in the correct form by the SIMPLE list command and may well upset the way the sentence is displayed.

*Example conditional sentences*

```text
PRED(x y z) if PQ(x y z) and y LESS z
x likes y if y female and not y likes Peter
x GE y if not y LESS x
PRED(x y z1) if x LESS y and not(PR(y z x) & QUALIFY(x)) and
z1=(x*y+z)
x all-the-sons-of y if x isall (z : y parent-of z & z male)
only-has-sons(x) if (forall x parent-of y then y male)
x parent-of y if (either x father-of y or x mother-of y)
```

## 5.2 The relations and commands defined by program-mod

We will describe the program development commands defined in and exported from `program-mod` briefly here; a more tutorial introduction to the use of SIMPLE will be found in the *Primer*.

### 5.2.1 add

The `add` command allows you to add a sentence to the current workspace program. The sentence to be added must be enclosed in parentheses — thus the argument to `add` is a list of terms that conforms to the syntax of a sentence. One form of the command is

```text
add (<sentence>)
```

eg

```text
&. add (Peter likes x if not x likes John)
&. add (Tom likes Mary)
&.
```

The sentence will be compiled into a clause and added to the end of the current list of clauses for the relation that the sentence is about. In this case, the sentence is about the relation `likes`.

To add into the middle of a program, use the form

```text
add n (<sentence>)
```

where the number `n` refers to the position that the new sentence should occupy in the listing of the sentences for its relation. For example, to add to the beginning of the `likes` relation use

```text
&. add 1 (Tom likes John)
&.
```

Whenever you add a sentence about a new relation, the relation name will be recorded in a `dict` assertion which is automatically added to your workspace program by the `add` command; to see all these relation names, list the `dict` relation.



### 5.2.2 list

The `list` command displays the program on the screen. To display the whole of your program type `list all`.

```text
&. list all
Tom likes John
Peter likes X if
    not X likes John
Tom likes Mary
&.
```

Note that the clauses are displayed in sentence form. The `list` command de-compiles the clauses back into sentences before displaying them. You will see all the sentences for the relations recorded in the `dict` relation.

To display a single relation, the `likes` relation say, use

```text
&. list likes
```

This uses the alternative form of the command

```text
list <relation name>
```

You can only list relations recorded by a `dict` assertion.

To print a program on the ZX Printer press the `TO` key (`SYMBOL SHIFT + F`) before doing a `list all`. Everything sent to the screen from now on will be copied to the printer until you press `TO` again.

To see all the currently defined relation names use

```text
&. list dict
```

You will see all the relation names about which you have added a sentence, providing you have not killed the relation.

### 5.2.3 delete

This deletes a single clause from the program. It may be used in two ways

```text
delete (<sentence>)
delete <relation name> n
```

where `n` is the position of the sentence to be deleted, eg

```text
&. delete likes 2
&. delete (Tom likes John)
```

which leaves only `Tom likes Mary`.

### 5.2.4 kill

`kill` will delete an entire relation using the form

```text
kill <relation name>
```

So, to delete all the clauses for the `likes` relation, type

```text
&. kill likes
```

To get rid of the entire workspace program — you should normally only do this after a save — use

```text
&. kill all
```

You will be asked if you really want to do this with the question

```text
Entire program ?(yes/no)
```

The `yes` response causes all relations recorded by a `dict` assertion to be killed.



Finally, to get rid of a module use the form

```text
kill <module-name>
&. kill exptran-mod
```

will get rid of the expression parser after you have used it to compile expressions in some added sentences.

All the uses of `kill` report the successful deletion of the program or module. When a program for a relation is killed its entry in the `dict` relation is also deleted. After a `kill all` the `dict` relation will be empty.

### 5.2.5 accept

The `accept` command can be used as an aid in adding a lot of simple sentences for a relation. It enables a sequence of simple sentences to be added without the need to repeatedly use the `add` command. An example use is:

```text
&. accept likes
likes.(John Mary)
likes.(John Peter)
likes.(Mary John)
likes.end
&.
```

The `accept` command prompts for a simple sentence (in prefix form) with the name of the relation involved. The list of arguments of the sentence are then entered. You can continue entering sentences in this way until you enter `end`. The above example is equivalent to

```text
&.add(John likes Mary)
&.add(John likes Peter)
&.add(Mary likes John)
```

### 5.2.6 edit

The line editor (see Appendix B for details) can be used to edit an individual sentence by using this `edit` command. The edit command is invoked as follows

```text
&.edit likes 1   {the relation followed by the sentence number}
1 (John likes Mary)
```

The sentence (in parentheses) will be displayed, preceded by the number which is its position, and both the sentence and its position can then be edited using the line editor commands. Like `list`, `edit` maps clauses back into sentence form before displaying them. It then re-compiles them into clauses on exit from the edit when `ENTER` or `RETURN` is pressed.

You can reposition a sentence by changing its position number, whether or not you have edited it. In the above example, changing the position number `1` to `2` will move the sentence to the second position in the listing of `likes`. The old second sentence will therefore become the new first sentence. You may change, but should never delete, the position for the sentence from the beginning of the edit line, since this is used when you exit the edit to determine where the edited sentence should be added. The old sentence is deleted just before the edited version is added to the program. If you change the name of the relation that the sentence is about you will be told that this has been done with the message

```text
relation changed to...
```

on exit from the edit.

You can only edit relations with names recorded in the `dict` relation and the sentence you want to edit must be such that to display it in sentence form preceded by its position needs fewer than the line editor limit of 256 characters.

### 5.2.7 cedit

`cedit` is used in exactly the same way as `edit`; the difference is that the old version of the sentence is not deleted. The command is very useful for building programs in which two or more sentences differ only slightly.

*Example*

```text
&.add (y greater-of (y z) if not y LESS z)
&.cedit greater-of 1
1 (X greater-of (X Y) if not X LESS Y)
```

This line can now be edited to

```text
2 (Y greater-of (X Y) if not Y LESS X)
```

as an alternative to explicitly adding it as a second sentence.

### 5.2.8 function

This command is used to declare that a relation is to be used as a function in expressions; its use is fully described in section 5.4.

### 5.2.9 `"?REV-P?"`

This is the relation that is used to map each clause for a relation from its standard form (see MICRO in Chapter 6) into a list which when displayed using the `P` primitive of micro-PROLOG will be the sentence form of the clause formatted with each condition of the sentence on a new line. It does this by inserting control character constants in the sentence list that it generates from the clause. It is used by the `list` command. The `Parse-of-S` relation described in the next section is more general in that it can be used to generate clauses from sentences as well as sentences from clauses. When `Parse-of-S` generates a sentence from a clause no control character constants are inserted so that if the sentence is then displayed using `P` or `PP` it will not be formatted.

The form of use of `"?REV-P?"` is

```text
"?REV-P?"(X Y)
```

where `X` is a clause and `Y` is a variable.



*Example of the use of `"?REV-P?"`*

```text
&.?( ("?REV-P?" ((likes X Y)(likes Y X)(female Y)) x) (P | x))
X likes Y if
Y likes X and
Y female &.
```

Note: This query uses the primitive `?` described in Chapter 3 and the standard form of micro-PROLOG. The condition `(P | x)` is used rather than `(P x)` so that terms of the sentence list `x` will be treated as a sequence of different arguments and displayed without the outer parentheses. If `(P x)` were used the display would be

```text
(X likes Y if
Y likes X and
Y female)
```

## 5.3 The relations and commands exported by query-mod

### 5.3.1 is

The `is` command makes a YES/NO query of the program. It has the form

```text
is (<conjunctive condition>)
```

with the single argument a bracketed conjunctive condition. If the conjunctive condition can be solved, the response is `YES`; otherwise it is `NO`. For example

```text
&. is (John likes Mary)
YES
&. is (SUM(2 3 x) & x LESS 5)
NO
```

### 5.3.2 which-all is an accepted synonym

The `which` query finds all answers to some condition of a specified form. The syntax of the command is

```text
which (<sequence of terms> : <conjunctive condition>)
```

where `<sequence of terms>` denotes the form of the answer required, and the `<conjunctive condition>` is the query to be evaluated. For example, to find all the people that like John, use

```text
&. which(x : x likes John)
Peter
Mary
No (more) answers
&.
```

To find the pairs of people who like each other

```text
&. all(x y like each other : x likes y and y likes x)
John Mary like each other
Mary John like each other
No (more) answers
```



Note the use of the constants in the sequence of answer terms to make up an answer message. The sequence of answer terms can be of any length and can contain any form of term. The answers are displayed by the micro-PROLOG primitive `PP`.

To compute the sum of 3 and 5

```text
&.which(x : SUM(3 5 x))
8
No (more) answers
```

### 5.3.3 one

The `one` query is similar to `which`, except that it prompts after each solution has been found with

```text
more(y/n)?
```

a `y` response gives the next answer if there is one, an `n` response terminates the query evaluation.

```text
&.one(x : x likes John)
Peter
more(y/n)?.y
Mary
more(y/n).y
No (more) answers
&.
```

### 5.3.4 save

The entire workspace program can be saved - in clause form, not in sentence form - for later use with this command. The use of the `save` command is

```text
&. save <file name>
```

where `<file name>` is a file name in the normal micro-PROLOG form (see section 3.3.6.1).

The `<file name>` must be different from any relation name in the program. The saved program can subsequently be reloaded using `load`.

The major difference between the `save` of SIMPLE and the supervisor `SAVE` described in Chapter 3 is that `save` prompts you with any file control actions required whereas the supervisor `SAVE` does not.

### 5.3.5 load

The `load` command is used to re-load a previously saved program. Its use is

```text
&. load <file name>
```

It is a lower case synonym for the supervisor `LOAD` described in Chapter 3.

### 5.3.6 APPEND, ON, true-of

`query-mod` includes and exports definitions of two useful list processing programs for the relation names `APPEND` and `ON`. In sentence form, their definitions are:



```text
APPEND(() X X)
APPEND((X|Y) Z (X|x))
   if APPEND(Y Z x)
X ON (X|Y)
X ON (Y|Z)
   if X ON Z
```

The `APPEND` relation has many uses. It can be used in exactly the same way as the `append` relation of the *Primer*. The relation `ON` can be used to find members of a list or test for membership in the same way as the `belongs-to` relation described in the *Primer*.

*Example*

We can use it to join two lists

```text
&.which (x : APPEND ((fish chips) (salt vinegar) x))
(fish chips (salt vinegar))
No (more) answers
&.
```

`true-of` can be used when the relation name of a prefix form condition or its argument list is to be given as the value of a variable. Its form of use is

```text
<variable or relation name> true-of <list pattern>
```

The `<variable>` must be a relation name `R` by the time that the condition is evaluated. The `<list pattern>` represents the list of arguments for the relation. `true-of` gives the power of the predicate symbol and argument list meta-variables of the standard syntax (see Chapter 2) to programs entered in sentence form.

You will find the clause form definition of `true-of` in the next chapter. The definition exported from `query-mod` cannot be given in sentence form.

*Example*

```text
add (x true-of-all Y if (forall y ON Y then x true-of y))
```

defines and adds a relation `true-of-all` that can be used to test if all elements of a list `Y` have some property given as argument `x`. Notice that since `x` names a property - a unary relation - the second argument of `true-of` is a unit list `(y)` comprising the element to be tested.

```text
is(likes true-of-all ((John Mary)(John Peter)))
```

checks that both John Mary and John Peter are in the `likes` relation.

The `<list pattern>` of a `true-of` condition can be a variable representing a list of any number of arguments. The use of variables in this way is not restricted to `true-of` conditions. Any simple sentence, written in prefix form, can have its list of arguments represented by a variable. As an example

```text
which(x : likes X)
```

can be used to find all the pairs in the `likes` relation. It is a shorthand for

```text
which((x y) : likes (x y))
```

The use of a single variable as the argument following a relation is always a shorthand for a list of different variables, one for each argument of the relation. This, and `true-of`, are the only `meta syntax` forms allowed in SIMPLE programs.

### 5.3.7 CONS, @, #, =

`CONS` and `@` are used in expressions which are dealt with in the next section. The `#` and `=` relations are only used together with expressions and are also described in the next section. `query-mod` does not actually contain a definition of `=`, but it cannot be defined in a user program because it has a special role in the syntax of sentences.

### 5.3.8 `*`, `%`, `+`, `-`

The `query-mod` module exports definitions for the auxiliary arithmetic relations `*`, `%`, `+`, `-`. The auxiliary relations `*`, `%`, `+`, `-` are recognised as arithmetic operators in expressions. The `query-mod` definitions of the operators are

```text
+(X Y Z) if SUM(X Y Z)
-(X Y Z) if SUM(Y Z X)
*(X Y Z) if TIMES(X Y Z)
%(X Y Z) if TIMES(Y Z X)
```

### 5.3.9 defined, reserved

`defined` can be used to check if a relation name has any defining sentences. It can only be used in this checking mode.

```text
&.is(likes defined)
YES
&.is(animal defined)
NO
```

`reserved` can be used to find all the SIMPLE reserved words.

```text
&.which(x : reserved x)
```

returns a list of all the names exported by the currently loaded modules, with the names `dict`, `func` and `data-rel` appended to the front. Although these last three are not exported by any of the SIMPLE modules, they have a special role in SIMPLE programs and should not be used as normal relation names. We have already encountered `dict`. The role of `func` will be explained in the next section and the role of `data-rel` in section 5.5 on `errmess-mod`.

### 5.3.10 Parse-of-S, Parse-of-ConjC, Parse-of-SS, Parse-of-Cond, Parse-of-CC

These are the relations used by `query-mod` to compile and de-compile sentences into clauses.

#### 5.3.10.1 Parse-of-S

```text
X Parse-of-S Y
```



holds when `X` is the clause version of the sentence list `Y`, e.g.

```text
((likes X Y)(likes Y X)) Parse-of-S (X likes Y if Y likes X)
```

It can be used to parse a sentence list into a clause with a condition of the form

```text
X Parse-of-S <sentence list>
```

or to de-compile a clause into a sentence list with

```text
<clause> Parse-of-S Y
```

#### 5.3.10.2 Parse-of-ConjC

```text
Parse-of-ConjC(X Y Z)
```

holds when `Y` is the atom list form of the conjunctive condition list `Z` starting with one of the constants in the list `X`, e.g.

```text
Parse-of-ConjC((&) ((likes Tom Y)(NOT male Y)) (& Tom likes Y & Y male))
```

It can be used for parsing conjunctive conditions with a condition of the form

```text
Parse-of-ConjC(<starters> X (<conjunctive condition list>))
```

where `<conjunctive condition list>` must start with one of the constants in the list `<starters>`, or for de-compiling lists of atoms into conjunctive conditions

```text
Parse-of-ConjC((<constant>) <atom list> (<constant>|Y))
```

#### 5.3.10.3 Parse-of-SS

```text
Parse-of-SS(X Y Z)
```

holds when `X` is the atom form of the simple sentence which is formed from the sequence of terms on the list `Y` up to the list `Z`, that is, `X` is the atom form of the difference between the lists `Y` and `Z` - see Chapter 6 of the *Primer* for more information on difference pairs.

*Example*

```text
Parse-of-SS((likes X Y) (X likes Y if Y likes X) (if Y likes X))
```

It can be used for finding and parsing the front simple sentence of a list with a condition of the form

```text
Parse-of-SS(X <sentence list> Y)
```

`X` will become the atom and `Z` the remainder of the sentence list.

To map an atom into a simple sentence use the condition of the form

```text
Parse-of-SS(<atom> Y ())
```

where the remainder is given as the empty list. A condition

```text
Parse-of-SS(<atom> Y Z)
```

will give `Y` the list pattern value

```text
(<simple sentence form of atom> | Z)
```

*Example*

```text
Parse-of-SS((likes x y) Y Z)
```

gives `Y` the value `(x likes y | Z)`.

#### 5.3.10.4 Parse-of-CC

```text
Parse-of-CC(X Y Z)
```

holds when `X` is the atom form of the complex condition represented by the difference between the lists `Y` and `Z`. It has the same uses as `Parse-of-SS`.

#### 5.3.10.5 Parse-of-Cond

```text
Parse-of-Cond(X Y Z)
```

holds when `X` is the atom form of the condition which is the difference between lists `Y` and `Z`. It has the same uses as `Parse-of-SS`. Reflecting the syntax definition of a condition that we gave at the beginning of this Chapter, `Parse-of-Cond` is defined by the two rules

```text
Parse-of-Cond(X Y Z) if Parse-of-SS(X Y Z)
Parse-of-Cond(X Y Z) if Parse-of-CC(X Y Z)
```

### 5.3.11 `"FIND:"` and `"?VARTRANS?"`

Both these relations are used internally by the parse programs and are of little use in user programs. They are exported from `query-mod` only because they are used by other modules.

## 5.4 Using expressions in sentences - the module exptran-mod

Expressions can be used in equality conditions and expression conditions in sentences and queries when the optional module `exptran-mod` has been loaded with a `load EXPTRAN` command. The expressions are actually compiled into a relational form by the single relation `Expression-Parse` exported by `exptran-mod`.

### 5.4.1 Expression conditions

Expression conditions have the form

```text
R # (E1 E2 ... Ek)
```

where `R` is the name of a relation and `E1 ... Ek` are expressions, i.e. terms of a certain form. The `#` is the signal that `E1 ... Ek` are not normal arguments but that some or all of them contain arithmetic operators and function calls. The syntax of expressions is formally defined below; for now, we shall just look for examples.

*Example*

```text
LESS # ((2*x) (5+y))
```

is a `LESS` condition with arguments the values of the expressions `(2*x)`, `(5+y)`. When it comes to be evaluated, the variables `x` and `y` should have been given values.

The relational form into which the condition is compiled is

```text
(X LESS Y) # (* (2 x X) and + (5 y Y))
```

The `#` in this form should be read as *where*. So this condition is read as

```text
X LESS Y where X is 2 * x and Y is 5 + y
```

This is the sentence syntax form of what is produced by `Expression-Parse`. It is what will be displayed if you `kill exptran-mod` after the expression condition has been entered or if you add `rel-form` to your program and list the sentence in which it is used (see section 5.3.5 below).



The relational form of an expression condition

```text
R # (E1 E2 .. Ek)
```

is

```text
(R)(t1 t2 ... tk)) # (<conjunctive condition>)
```

The evaluation of the conjunctive condition will produce values for the variables in the terms `t1`, `t2`, ... `tk` so that they become the values of the original expressions `E1`, `E2`, ... `Ek`. In our `LESS` example, the terms are the variables `X`, `Y` and the evaluation of the conjunctive condition

```text
* (2 x X) and + (5 y Y)
```

will result in `X` having the value of `(2*x)` and `Y` the value of `(5+y)`.

When a compiled `#` condition is evaluated, the conjunctive condition that produces the values of the expression arguments is evaluated first; then the `R` condition. On backtracking, only the `R` condition will be retried for alternative solutions, since there will be no alternative solutions for the evaluation of the expression values.

*Example*

The condition

```text
salary # (x (12*157))
```

is compiled into the relational form

```text
(x salary X) # (* (12 157 X))
```

The `*` condition computes the value of `(12*157)` and the evaluation of the `#` condition will reduce to the evaluation of

```text
x salary 1884
```

in order to find an `x` with recorded salary of `1884`. Backtracking will result in different values for `x` being sought but will not cause the re-computation of the value `1884`.

Details of the standard syntax form of a compiled expression condition, and the definition of `#` that is exported from `query-mod`, and which is used to evaluate `#` conditions, are given in Chapter 6. The MICRO definition of `#` relation is exactly the same as the `query-mod` definition.

### 5.4.2 Equality conditions

An equality condition has the form

```text
E1 = E2
```

where `E1` and `E2` are expressions. It is a shorthand notation for the expression condition

```text
EQ#(E1 E2)
```

Thus, the two expression arguments `E1`, `E2` of an equality condition are evaluated and then their values are checked for identity using the primitive `EQ` relation. `EQ` is itself defined by the sentence

```text
EQ(X X)
```

So, if one of the expressions is a variable, this will result in the variable being given the value of the other expression.



*Examples*

```text
x = (y * 67 + z)
```

can be used to give `x` the value of the bracketed expression if `y` and `z` have values at the time that the condition is evaluated. If they do not, a `Too many variables` error message displays either a call to `SUM` or a call to `TIMES`.

```text
0 = (2*x*x + 7*x - 23)
```

can be used to check that the value of `x` satisfies the equation

```text
2x^2 + 7x = 23
```

Note that it cannot be used to *find* the roots of the equation.

### 5.4.3 Syntax of expressions

An expression may be an arithmetic expression, a function call, or some other term.

An arithmetic expression is a list of the form

```text
(<expression> <operator> <expression>)
```

where the operator is one of the following:

```text
*         for multiply
% or /    for divide
+         for addition
- or ~    for subtraction. Note: ~ is safer because of the other
          syntactic roles of -. If you use - you should always
          surround it with spaces.
```

The outermost brackets of an arithmetic expression are essential - so an arithmetic expression is just a three element list whose second element is an operator. However, if the expression arguments of this operator are also arithmetic expressions the inner brackets around them may be dropped in accordance with the following precedence

```text
* / %     equal - left associative
greater than
+ -       equal - left associative
```

*Examples*

```text
(x * y + 3 / z)        equivalent to ((x * y) + (3 / z))
(x + y / (5 + z))      equivalent to (x + (y / (5 + z)))
(x * y / 5 + z)        equivalent to (((x * y) / 5) + z)
```

`query-mod` exports definitions for the operators `* % + -`. Uses of `/` and `~` in expressions are mapped into conditions for `%` and `-` respectively. Any use of `~` or `/` in an expression will subsequently be displayed as a use of `-` or `%`.

A function call is a list of the form

```text
(R E1 ... En-1)
```

where `E1 ... En-1` are expressions and `R` is an n-ary relation name that has been declared a function with the command

```text
function R
```

The expressions are the first `n-1` arguments of what would otherwise be given as an expression condition of the form

```text
R # (E1 ... En-1 x)
```



The `x` found by the evaluation of this condition is the value denoted by the function call `(R E1 ... En-1)`. Notice that this means that relations should be declared as functions only if the value of the last argument of the relation is uniquely determined by values for the preceding arguments.

*Example*

Suppose the relations `div` and `mod` are defined by the rules

```text
div(x y z) if TIMES(y z1 x) & INT(z1 z)
mod(x y z) if div(x y z1) & z = (z ~ y * z1)
```

(Note the essential use of `~`. If `-` had been used the `z-y` would have been parsed as a constant resulting in the call to `TIMES` failing; this would cause the evaluation of `mod` to fail. However `z ~ y` is recognised by the lexical analyser as three terms `z`, `~` and `y` and hence as a use of the subtraction operator.)

`INT` is a primitive of micro-PROLOG that can be used either to test if a number is an integer or to find the integer part of a number, as here. So, `div(x y z)` can be used to find the integer divisor `z` of `x` and `y` and `mod(x y z)` can be used to find the remainder `z` of the integer division of `x` by `y`. For both `div` and `mod` the last argument is functionally determined by the first two arguments. So, we can declare these relations as functions

```text
function div
function mod
```

and then use them in expressions:

```text
x = ((mod 85 23) * 34)
LESS # ((div 500 x) 23)
```

If you forget to declare that some relation `R` is a function before using it in an expression the expression parser of `exptran-mod` will assume that the function call is just a list that has as its first element a constant. However, it will tell you this by giving you the message

```text
R assumed not to be a function
```

If the expression was in a query you will get the wrong answers. If the expression was used in an added sentence you can easily recover from the error. Declare `R` as a function and edit the sentence. Just call the line editor and then immediately exit it with `<return>`. The editor de-compiles the clause for the original sentence, mapping compiled expressions back into source form; it re-compiles them on exit. This time it will recognise the use of `R` as a function call because of the declaration.

A function `R` declaration causes an `R func` sentence to be added to the user workspace program. It is this that causes the expression parser to treat a list beginning with `R` as a function call when it appears in an expression. You can examine what functions have been declared with a

```text
which(x : func(x))
```

query. Alternatively, you can list the `func` relation. If you kill a relation that has been declared a function, the `func` sentence for the relation will be automatically deleted. Note, however, that this only happens if you use the



`kill` command of SIMPLE. If you use the supervisor `KILL` neither the `func` sentence nor the `dict` sentence for the relation will be deleted.

### 5.4.4 Warning on the use of `|` in expressions

You will see from the above discussion on the problem of undeclared function names that lists can be given as arguments to function calls in expressions. As an example

```text
x = (APPEND (1 2) (APPEND (3 4) (5 6)))
```

can be used to append three lists. As we remarked earlier, the relation `APPEND` is defined in and exported from `query-mod`. It is also recognised by the expression parser as a function name, so you do not need to declare it as a function in order to use it in expressions. However,

```text
x = (3 | APPEND y z))
```

cannot be used to make `x` the list `3` followed by the concatenation of the lists `y` and `z`. This is because, as a micro-PROLOG term, the list

```text
(3 | APPEND y z))
```

is just another way of writing the list

```text
(3 APPEND y z)
```

in which the function call sublist has disappeared. So the expression parser sees a list of four elements and leaves it unchanged. The moral is that the term following `|` in an expression can never be a function call. When you do want to denote the rest of a list by a function call, you must use an explicit `CONS` function call (as in LISP) to construct the list instead of the primitive `|`. The above `=` condition needs to be re-expressed as

```text
x = (CONS 3 (APPEND y z))
```

Like `APPEND`, `CONS` is defined in and exported from `query-mod` and is recognised as a function in expressions. Its definition, in sentence form, is

```text
CONS(X Y (X|Y))
```

Finally, there is the predefined apply function `@`. Its definition, which can only be given in clause form, is given in section 6.1.16. It applies its first argument to the rest of its arguments. An example of its use is in the expression

```text
x = (@ y 3 4)
```

If `y` is bound to `*` when this is evaluated, `x` will be bound to `12`. The `@` is needed. If you instead use

```text
x = (y 3 4)
```

then `(y 3 4)` is not recognised as a function call. The equality is compiled into

```text
EQ(x (y 3 4)) # ()
```

with an empty condition for the argument evaluation. It will result in `x` being
bound to the list `(* 3 4)` when evaluated. `@` is the expression equivalent of
the `true-of` sentence condition and the predicate meta-variable (see Chapter
2) for atoms.

### 5.4.5 The relation Expression-Parse

Expressions occurring in equality conditions and expression conditions are compiled into relational form using the relation `Expression-Parse` that is exported from the module `exptran-mod`. This same relation is used to de-compile the expressions when a clause is listed or edited.

```text
Expression-Parse(X Y Z)
```

holds when `Y` is the term `X` with all the expression sublists replaced by new variables and `Z` is the list of atoms, the evaluation of which will give these new variables the values of the expressions of `X`. For example

```text
Expression-Parse((x * y + (fact z)) X ((* x y x1)(fact z x2)(+ x1 x2 X)))
```

It can be used to parse expressions with a condition of the form

```text
Expression-Parse(<expression> X Y)
```

or to de-compile expressions with

```text
Expression-Parse(X <term> <atom list>)
```

### 5.4.6 When the expression handler is not needed

If you `kill` the `exptran-mod` module after you have entered some sentences using expressions, the expressions will then be displayed in the compiled relational form even by the `list` and `edit` commands. This is because a check is made to see if the module is present before `Expression-Parse` is used to de-compile expressions.

If the `exptran-mod` module is present then the expressions are displayed in the normal expression form. This means that you can have the convenience of using expressions in sentences whilst you are developing a program. Then, when you want to start using the program, you can get rid of `exptran-mod` with a

```text
kill exptran-mod
```

command to make more space available for the query evaluations. Of course, you will not be able to use expressions in the queries to the program.

If you do enter a sentence or query that uses expressions with the `exptran-mod` module not present, you will get an error message of the form

```text
No definition for relation
trying: Expression-Parse(<expression> <variable> <variable>)
```

If you are using one of the alternative error handlers `deftrap-mod` or `errtrap-mod` you can recover from this error and return to the interrupted compilation of the expression - but more on this later. Otherwise you should load the `exptran-mod` module with a

```text
load EXPTRAN
```

command and re-enter the sentence or query.

You can see the compiled relational form of any expression in a program, even when `exptran-mod` is present, by adding the sentence `rel-form` to your program with

```text
&.add (rel-form)
```

Now, when you list or edit the program, compiled expressions will not be put back into expression form but will be displayed in relational form.

Note that the relational form of an expression condition can be edited and it will be compiled back into clause form on exit from the edit.

The display of the relational forms will continue until you delete the `rel-form` sentence. It is useful if you want to check that you did not make a mistake in an expression and that what you intended is what has been recognised and compiled.

## 5.5 The error handler errmess-mod

On a runtime error the error handler `errmess-mod` that is loaded as part of SIMPLE just prints out a message identifying the error - the messages are similar to the ones given by the example error handler in Appendix C - along with the condition it was trying to evaluate when the error occurred. The current query or command is aborted and you are then returned immediately to the supervisor; the `&.` prompt will appear for a new query or command.

An alternative error handler, allowing you to recover from the very common error of not having a definition for a relation of the condition about to be evaluated (through forgetfulness or misspelling) is in the file `DEFTRAP` of the distribution tape. You can switch to this error handler by executing the following pair of commands in the order given

```text
kill errmess-mod
load DEFTRAP
```

It is important that you do the `kill` first. This is because `errmess-mod` and the module `deftrap-mod` that is loaded from the file `DEFTRAP` both export definitions for the error trap relation `?ERROR?` (see Appendix C). If you do the `load` first you will get the error `Illegal use of modules`.

The only difference between `errmess-mod` and `deftrap-mod` is that the error `No sentences for relation` is specially handled by `deftrap-mod`. The condition that was being evaluated, that which contains the undefined relation, is displayed followed by the prompt

```text
error&(? for info).
```

`error&` is the prompt you will continue to get whilst in this error state with the evaluation in which the error occurred suspended. Entering `?` produces the message

```text
to quit enter: q
or enter: tell (see manual)
or enter: / <any command (eg / add (sentence), / load file)
to continue enter: c
```

If you enter any first response other than `q`, `tell`, `/` or `c` you will again get the `?` for info.

The `q` causes an `ABORT` to the top level supervisor which is what normally happens with the `errmess-mod` handler.

`tell` invokes `is-told` (see below) with argument the offending condition. It enables the condition to be answered interactively during the current query evaluation, which is useful for `top-down` development of programs. You can define the higher level relations in terms of lower level relations whose programs are yet to be constructed. Then, when you query the partly developed program and get the `No sentences for relation` message for a lower level relation you can supply the answer to the condition using `tell`. But note, your actual answers, although used, are not remembered so later calls to `R` may ask you the same question again. `tell` adds the sentence

```text
R x if (R x) is-told
```

to your program so on a subsequent use of `R` you will automatically be queried by `is-told`. When you want to add a proper definition for `R` you should delete this clause.

`/` allows you to add any number of sentences for the undefined relation. In fact, you can enter any commands providing each is preceded by the `/`, the escape symbol that allows a command to be entered while in the error state.

`c` exits the error handler and retries the suspended query evaluation in the context of the changes you have made.

Loading a file is the appropriate recovery response if you have killed a module such as `exptran-mod` and you get an error message such as

```text
No sentences for relation
trying: Expression-Parse((X*Y) Z x)
error&(? for info).
```

This will happen if you forgetfully use an `=` or `#` condition in a query, or in a sentence that you are adding to the program, after you have got rid of the `exptran-mod` module. The recovery response is

```text
/ load EXPTRAN
c
```

and the parsing will continue from the point at which the error occurred.

A final example concerns the appropriate recovery action if you have misspelt a relation name: say you have used `fatherof` instead of `father-of`, you can recover by adding a sentence that defines `fatherof` as `father-of`. When the query evaluation is over you can edit the program to correct the spelling error and delete the definition of `fatherof`.

```text
No sentences for relation
trying : fatherof (X bill)
error&(? for info). / add (x fatherof y if x father-of y)
error&. c
```

Notice that the error handler displays the condition in the prefix form.

For an even more sophisticated way of handling errors, kill `errmess-mod` and load the MICRO error handler - in the file `ERRTRAP` - described in Chapter 6.

### 5.5.1 data-rel relations

Sometimes, usually when a relation is being used to record facts, it is more convenient if micro-PROLOG interprets having no sentences for a relation as a failure to solve the condition rather than as an error. The `errmess-mod`, `deftrap-mod` and `errtrap-mod` error handlers can be informed that they are to treat a particular relation `R` in this way simply by adding the sentence

```text
R data-rel
```



to your program. Before displaying the `No sentences for relation` error message, each error handler checks to see if there is such a sentence about the relation. If there is, the message is not displayed and the evaluation continues as though there had been sentences but none had matched the condition being evaluated, e.g.

```text
&.add(jolly data-rel)
&.which(x : Tom father-of x & x jolly)
No (more) answers
```

even if we have no sentences for `jolly`.

## 5.6 Using the relation is-told

`is-told` is a multi-argument relation exported from the module `told-mod`. When evaluated, an `is-told` condition displays its sequence of arguments followed by a `?` and waits for a response. If there is just one argument, which is a list, this is displayed without the outer brackets. The responses and their effects are as follows.

| Response | Effect |
|||
| `yes` | The `is-told` condition for the displayed argument is assumed to be true. Backtracking will not cause the question to be posed again. |
| `no` | The `is-told` condition is assumed false - i.e. it fails. |
| `ans ..` | The `..` is a sequence of terms, one for each different variable in the displayed message. The `is-told` condition is solved for values of the variables given in the response. The i-th term in the response sequence becomes the value for the i-th variable in the displayed message in the left to right order of the text. |
| `just ..` | The same as `ans` except that on backtracking you are not asked for another solution. It is assumed to be the last solution to the `is-told` condition. |

*Example*

If the `is-told` condition is

```text
(X likes Y) is-told
```

the message and response

```text
X likes Y ? ans tom bill
```

makes `X = tom` and `Y = bill`. Backtracking will result in the message being re-displayed when an alternative solution can be given. This repeated prompting for new solutions on backtracking continues until you enter `no` or `just`.

### 5.6.1 Example uses of is-told

*Example 1*

```text
which(percent z : (mark x outof y) is-told & z=(x/y*100))
```

sets up an interaction that can be used to convert pairs of numbers to percentages. An example interaction is



```text
mark X outof Y ? ans 20 40
percent 50
mark X outof Y ? ans 15 60
percent 25
mark X outof Y ? just 40 120
percent 3.3333333E1
No (more) answers
```

*Example 2*

```text
x is-male if x known-male

x is-male if not x known-male &
    (x a male) is-told & (x known-male) add
```

defines `is-male` in such a way that the user is queried whenever an `is-male` condition is encountered with argument given but not recorded as a `known-male`. A `yes` response to the question such as

```text
keith a male ?
```

results in the `keith is-male` condition that provoked the question being solved and a `keith known-male` sentence being added to the program. A `no` response results in the condition failing.

### 5.6.2 Using is-told from DEFTRAP error handler

The `tell` response of the `DEFTRAP` error handler will invoke `is-told` with argument the error condition for the undefined relation which you can then answer interactively. If you use the `tell` response and you have not loaded `TOLD` you can still recover from the error by loading the file when you get the second error message. The interaction will be something like

```text
No sentences for relation
trying : father-of (tom X)
error&(? for info).tell
No sentences for relation
trying : is-told (father-of (tom X))
error&(? for info). / load TOLD
error&.c
father-of (tom X) ?
```

and you can now continue by answering the `father-of(tom X)` question in the manner described above. You have recovered from an error encountered in an error recovery action! You are now out of the error state.

## 5.7 Tracing SIMPLE queries using SIMTRACE

The `TRACE` program described in Chapter 4 can be loaded and used to trace evaluations of programs developed using SIMPLE. The drawback of using this program, especially for beginning programmers, is that its `??` query form has the query expressed as a list of atoms and conditions are displayed as atoms during the trace. In fact, to use `TRACE`, none of the SIMPLE modules need be present; they are best deleted to make more space available for the trace.

A version of the trace facility, `SIMTRACE`, makes use of some of the exported relations of `query-mod` which allows the user to trace `is` and `all` queries posed using the SIMPLE syntax. It also gives more information during the evaluation - it gives information about the failed matches as well as the successful matches - and it displays the conditions being evaluated as SIMPLE syntax conditions. It is a useful program for a beginner to use to sharpen his understanding of how micro-PROLOG evaluates queries using backtracking. But because at least the `query-mod` module must also be present, and because tracing takes up a lot of space, only relatively small programs can be traced using `SIMTRACE`.

The trace program is in the file `SIMTRACE` of the distribution tape. To use it do a `load SIMTRACE`. It is advisable to kill `program-mod` first to make more space. `SIMTRACE` contains one program module called `simtrace-mod`; when you have finished do a `kill simtrace-mod`.

The `SPYTRACE` program described in Chapter 4 can also be used to set up spypoints on programs developed and queried using SIMPLE. That there are spypoints on a program will not prevent the use of `SIMTRACE`. However, you will not be able to trace the evaluations of conditions for spypoint relations. You have to `unspy` the relation if you want to trace it using `SIMTRACE`.

Finally, to free space for the trace we suggest that you get rid of the `program-mod` module with a

```text
kill program-mod
```

before loading `SIMTRACE`. After you have finished tracing and have killed `simtrace-mod` you can reload this module from the file `PROGRAM`.

### 5.7.1 The relations exported by simtrace-mod

`simtrace-mod` exports two relations: `dis-trace` and `all-trace`. They are used in exactly the same way as the `is` and `all` queries of `query-mod`. To trace the query

```text
all(x : Tom parent-of x & x male)
```

use

```text
all-trace(x : Tom parent-of x & x male)
```

The trace will take you through the evaluation step by step. As each condition is reached, the condition is displayed in the form

```text
<condition identifier> : <condition>
```

where the condition identifier is a list of integers that also gives the `history` of the condition back to the original query. All the conditions of the original query have a single integer identification which is the position in the query. In the above query, `Tom parent-of x` will have the identifier `(1)` and `x male` the identifier `(2)`. Whenever a rule is applied, the identifier grows by one number. The identifier `(2 1)` tells you that the condition is the second condition in the rule currently being used to evaluate the first condition of the original query. The identifier `(3 2 1)` tells you that it is the third condition of the rule currently being used to solve the second condition of the rule being used to solve the first condition of the original query.

When the condition displayed is for a relation in your program (one recorded in the `dict` relation) you will also get the prompt

```text
trace ?
```

and the tracing will be suspended until you respond. The responses are the same as those for the `TRACE` of Chapter 4. They are

```text
y  to trace the evaluation of the condition,
n  not to trace it; only the solutions to the condition will be shown,
q  to quit the trace entirely,
s  to resume the trace with the condition, as displayed, assumed solved, and
f  to resume the trace with the condition, as displayed, assumed failed,
   i.e. assumed to have no solution.
```

If you enter any other response you will be reminded of the allowed responses and prompted again.

The tracer will also prompt you when it reaches a complex condition such as an `isall`. This time the prompt will be

```text
trace ?(y/n)
```

indicating that `y` and `n` are the only responses. In fact, any response other than `y` is taken as `n`. A `y` response enables you to trace inside the evaluation of the complex condition.

When a condition for one of your program relations is traced you will be told which sentence is being used to try to solve the condition with a message of the form

```text
matching I : <condition> with head of N : <conclusion of sentence>
```

where `I` is the condition identifier and `N` is the number of the sentence being used - the position in the listing of the sentences for the relation of the condition. You will be told whether the sentence matches the condition. If it does, the result of the match will be displayed. Then, if the matched sentence has preconditions, these will be displayed as

```text
new query : <precondition(s) of the matched sentence>
```

and the trace will continue with the evaluation of each of the conditions of the new query. The identifier for each of these conditions will be the identifier for the condition just matched with an extra condition number at the front.

When a condition is solved you will get the message

```text
<condition identifier> solved : <condition in solved form>
```

When backtracking results in an alternative solution for a condition being sought, you will get the message

```text
retrying <condition identifier> ..
```

Finally, when a condition cannot be solved, or when all solutions have been tried and the evaluation is backtracking to find alternative solutions to preceding conditions, you will get the message

```text
<condition identifier> failing: <condition>
```



## 5.8 Graphics queries

A special version of `which` called `show` can be used to display answers graphically. It is available on file `SIMSHOW`, containing the module `simshow-mod`. `Simshow-mod` exports two relations `draw` and `show`.

### 5.8.1 draw

The `draw` unary relation can be used as a command or as a program relation. It invokes any user picture definition that matches its single argument, providing the argument is not a variable. If there is no picture definition that matches the argument, and the argument is a list, it recurses down the list trying to find picture definitions for each term on the list, calling any which match. A call to `draw` always succeeds.

*Example*

Suppose that the user program contains the picture definitions

```text
sam picture if PNT(0 0)
(line x1 y1 x2 y2) picture if LNE(x1 y1 x2 y2)
```

that make use of the graphics primitives `PNT` and `LNE` described in section 7.5. The command

```text
draw sam
```

will cause a point to be drawn at the centre of the graphics display area. The command

```text
draw ((line -15 -20 15 -20)(line 15 -20 15 20))
```

will draw two lines at right angles.

### 5.8.2 show

The `show` query command has exactly the same format as the `which` command. It will give all the solutions to a query of a certain form. However, as each answer is given, the answer is also drawn using the above `draw` relation. The command should be used when the display is in hybrid mode - see section 7.5.

*Example*

```text
between(x x z)
between(x y z) if SUM(y 5 Y) & Y LESS z & between(x Y z)

picture((pnt x y)) if PNT(x y)

show((pnt x y) : between(x -88 60) & SUM(x 20 y))
```

will cause all the points on the line `y = x + 20` to be displayed at five pixel intervals between the `x` coordinates `-88` and `60`. At the same time the answers

```text
(pnt -88 -68)
(pnt -83 -63)
(pnt 57 77)
```

will be scrolled in the text area.



(blank page; printed page number `68` only)

# Chapter 6
# The MICRO extension to the supervisor

The `MICRO` file of the distribution system contains two modules called `micro-mod` and `errtrap-mod`, and the modules `exptran-mod` and `told-mod` in the files `EXPTRAN` and `TOLD` can be optionally loaded as with SIMPLE. The `errtrap-mod` module is also supplied in the file `ERRTRAP`.

`micro-mod` is the main module containing definitions for the program development commands and other useful relations. The commands are similar to those provided by the SIMPLE system described in Chapter 5. The major difference is that the facts and rules that can be entered using MICRO are essentially standard syntax clauses. However, there is one elaboration; in the clause arguments of the MICRO `add` and `delete` commands, and in clauses entered using the two MICRO `edit` commands, expressions can be used as arguments to `=` and `#` conditions. Expressions can be used only if the optional `exptran-mod` is present.

The `errtrap-mod` module is an error handler. The error handling allowed by `errtrap-mod` is quite sophisticated and is described below.

Note that any program developed under the SIMPLE system can be loaded and queried using MICRO.

**WARNING** If you want to switch from using SIMPLE to using MICRO, or vice versa, you must first kill all the modules of the SIMPLE system before you load MICRO. This is because the modules of the two systems export common relation names. The attempt to load a module that exports a name already exported by another module gives an error. The safest thing to do when switching between the two program development systems is to save your user program, initialise micro-PROLOG using `NEW.`, and `LOAD` in the other system.

## 6.1 The relations exported by micro-mod

To use the facilities of MICRO do a `LOAD MICRO` command. To get rid of it you must kill each of its modules with

```text
KILL errtrap-mod
KILL micro-mod
```

### 6.1.1 add

`add` has two uses.



```text
(1) add <clause>
```

will add the clause to the end of the list of clauses for its relation. Except when the clause contains expressions or uses `vars` constants, it is equivalent to directly entering the clause as described in Chapter 2.

```text
(2) add n <clause> where n is a positive integer
```

This adds a clause at the position indicated by the positive integer. It is equivalent to

```text
?((ADDCL <clause> m)) where m is n-1
```

if the clause contains no expressions. This means that if there are already at least `n-1` clauses for the relation, the added clause becomes the new `n`th clause. It is inserted before the old `n`th clause if there is one. If there are not already `n-1` clauses for the relation it is added as a new last clause.

### 6.1.2 delete

`delete` also has two uses:

```text
(1) delete <clause>
```

Except when the clause contains expressions, it is equivalent to

```text
DELCL <clause>
```

with the added feature that if there is no such clause you will get the message `No such clause.`

```text
(2) delete <relation name> n where n is a positive integer
```

will delete the current `n`th clause for `<relation-name>`. It is equivalent to

```text
?((DELCL <relation name> n))
```

with the added feature that if there is no current `n`th clause, you will get the message `No such clause.`

### 6.1.3 edit

The `edit` command can be used to text edit a clause and/or reposition a clause. Its use is

```text
edit <relation name> n where n is a positive integer.
```

The result is that the `n`th clause for the named relation together with the number `n` will be displayed as

```text
n <clause>
```

and both can be edited using the line editor described in Chapter 2. If `n` is changed, it is taken as the new position for the edited clause, ie, the position that would be used in an `add` command. If the relation that the clause is about (ie the relation of the head atom) is changed, then the new `n` is taken to be the position for adding the changed clause to the sequence of clauses for the new relation. The old clause is always deleted immediately before the edited version is added.

The main difference between `edit` and the `t` command of the structure editor is that any compiled expressions in the clause are de-compiled back to expressions before the clause is displayed. This de-compiling takes place only if `exptran-mod` is present. If it is not present then the clause will be displayed with all expressions in their compiled form.

### 6.1.4 cedit

`cedit` has the same form of use as `edit`. The difference is that the old clause is not deleted. Useful for building up a definition of a relation where the clauses have common components, cf the `c` command of the structure editor. As with `edit`, compiled expressions are de-compiled and displayed as expressions if `exptran-mod` is present. They are then re-compiled on exit from the edit.

### 6.1.5 kill

`kill` has the same uses as the primitive `KILL` command of the supervisor. The only difference is that the use to delete entire workspace program is

```text
kill all    (note the lower case all)
```

and you are asked to confirm that the entire program is to be deleted. The memory space that is available when the workspace is cleared is also displayed. This space is the value given by the built-in micro-PROLOG relation `SPACE` (see section 7.1.7). The other uses of `kill` are

```text
kill <relation name>
kill <module name>
kill <list of relation names>
```

Each reports the successful deletion of the corresponding programs.

### 6.1.6 list

`list` has the same uses as the supervisor command `LIST` except that a request to list the entire workspace program is

```text
list all    (with lower case all)
```

Compiled expressions are displayed in their compiled form.

### 6.1.7 load

```text
load <file name>
```

`load` has the same effect as the supervisor `LOAD <file name>` command. The only difference is that immediately after entering the command a message of the form

```text
... K free
```

will be displayed, giving you the amount of space available for the program of the file.

### 6.1.8 save

```text
save <file name>
```

`save` has exactly the same meaning as the supervisor `SAVE <file name>` command. It saves the entire workspace program on the named file. The one difference is that you will be prompted with any file control actions required for saving (see Appendix E).



### 6.1.9 reserved

A call `(reserved x)`, where `x` is a variable, will result in `x` being bound to a list of all the names exported by the currently loaded modules. This is useful for reminding you of the names of these exported relations, as they are names you cannot use for your own program relations.

The attempt to add a clause for a primitive relation or a relation exported by a loaded module results in the `Cannot add clauses for ...` error message. You cannot avoid this error by adding clauses for the exported relation before you load the module; this will result in the `Illegal use of modules` error message. The programs inside modules are protected. To change them you should use the module utility described in section 4.4.

### 6.1.10 space

The command

```text
space.
```

- note that the `.` or some other argument term is needed - will give the
current space left as a number of Kbytes. It is equivalent to the query

```text
?((SPACE x)(PP x K free))
```

which uses the primitive `SPACE` relation (see section 7.1.7).

### 6.1.11 is

```text
is <list of atoms>
```

Except when the list of atoms contains expressions, which it compiles before evaluating the atom list, its effect is almost the same as the supervisor query command

```text
? <list of atoms>
```

However, if the evaluation is successful, `YES` is displayed; otherwise `NO` is displayed.

### 6.1.12 which, all

```text
which (<term> <atom1> <atom2>...<atomk>)
```

Again, any expressions are compiled before the command is executed. The effect is the display of `<term>` for each different solution of the query

```text
?(<atom1> <atom2>...<atomk>)
```

*Example*

```text
which((x y) (APPEND x y (1 2 3)))
```

produces the answer

```text
(() (1 2 3))
((1) (2 3))
((1 2) (3))
((1 2 3) ())
No (more) answers
```

`APPEND` is a relation defined in and exported from `micro-mod`; see below. `all` is an accepted synonym for `which`.



*Example*

```text
all((x common) (ON x (T H O M A S)) (ON x (J A M E S)))
```

produces an answer such as

```text
(M common)
(A common)
(S common)
No (more) answers
```

### 6.1.13 one

The use of `one` is similar to that of `which`

```text
one(<term> <atom1> <atom2>...<atomk>)
```

It will also display `<term>` for each solution of the sequence of atoms given in the query. The difference is that after each solution is displayed, it prompts with

```text
more?(y/n)
```

If you enter `y`, it will give the next solution, if any; any other response stops the evaluation. Again any expressions in the query condition are first compiled before the query is answered.

### 6.1.14 accept

`accept` enables a sequence of single atom clauses for a relation to be entered quite quickly. Its use is

```text
accept <relation name>
```

You will then receive the relation name as a prompt and you need only enter the list of arguments for the single atom clause that you want to enter. You can continue in this way until you enter `end`.

*Example*

```text
&.accept male
male.(tom) {(tom) is entered, male. is the prompt}
male.(bill)
male.(john)
male.end
```

will add the clauses

```text
((male tom))
((male bill))
((male john))
```

to the end of the `male` program.

### 6.1.15 APPEND, ON, true-of

We have already mentioned that `micro-mod` defines and exports the list processing relation `APPEND`. Its definition is

```text
((APPEND () X X))
((APPEND (X|Y) Z (X|x))
   (APPEND Y Z x))
```



`micro-mod` also exports another useful list processing relation, `ON`. It can be used to find members of a list or test for membership. Its definition in `micro-mod` is

```text
((ON X (X|Y)))
((ON X (Y|Z))
   (ON X Z))
```

`true-of` has the definition

```text
((true-of X Y)
   (X|Y))
```

You need never use this relation in programs entered using MICRO. Any use of a call `(true-of X Y)` can be replaced by `(X|Y)`. However, the relation may have been used in some sentence form of a clause entered using the SIMPLE extension of the supervisor described in Chapter 5. It is included in `micro-mod` so that programs developed using SIMPLE can be loaded and queried when using MICRO, as mentioned at the beginning of this Chapter.

### 6.1.16 CONS, @, #, =, function

The definitions of the `CONS` and `@` relations are:

```text
((CONS X Y (X|Y)))
((@ X | Y)
   (X | Y))
```

They are used in expressions. The `#` and `=` relations are only used together with expressions, and are described in the next section. `micro-mod` does not actually contain a definition of `=`, but it cannot be defined in a user program because it has a special role in the syntax of MICRO programs. `function` is the command that is used to declare a relation as a function before using it in expressions; see section 6.2.3.

### 6.1.17 `*`, `%`, `+`, `-`

`micro-mod` exports the following definitions for the auxiliary arithmetic relations `*`, `%`, `+`, `-`.

`TIMES` and `SUM` are primitive arithmetic relations of micro-PROLOG implemented in machine code. The auxiliary relations are recognised as arithmetic operators in expressions.

```text
((+ X Y Z) (SUM X Y Z))
((- X Y Z) (SUM Y Z X))
((* X Y Z) (TIMES X Y Z))
((% X Y Z) (TIMES Y Z X))
```

These definitions are the same as those given in section 5.3.8 which are exported from `query-mod`.

## 6.2 Expressions in MICRO clauses

You can use expressions as arguments to certain calls in the body of clauses that are entered using the `add`, `edit` or `cedit` commands described above. The expressions can be used as arguments to calls that use the two relation names `=` and `#`.

The three commands just mentioned scan each clause before adding it to the workspace. If any call has the relation name `=`, or the relation name `#` followed by a first argument which is a constant, the expression arguments of the call are compiled into a list of relation calls which becomes an argument of a compiled form of the original `=` or `#` call. You see this compiled form when you `list` or `LIST` the clause.

However, when you edit the clause using `edit` or `cedit` the compiled call is mapped back into its source form before it is displayed. The `delete <clause>` command also compiles `=` and `#` calls before it scans for the clause to delete.

Expression arguments to `=` and `#` calls are also allowed in `is`, `which` and `all` queries. Expressions are compiled and de-compiled using the relation `Expression-Parse` which is exported from the optional module `exptran-mod`. Before you use expressions you should load the module with

```text
LOAD EXPTRAN
```

### 6.2.1 The # relation

Source calls to `#`, ie, calls that will be compiled, have the form

```text
(# R E1 E2...Ek)
```

where `R` is a relation name and `E1 ... Ek` are expressions. The expressions are the arguments of the relation call, which is really to the relation `R`. The `#` signals that these arguments to `R` are not just ordinary terms, but are expressions; terms that contain calls to functions and arithmetic operations. A `#` atom in a MICRO clause is the equivalent of an expression condition in a SIMPLE sentence. The atom `(R # E1 ... Ek)` would be the expression condition `R#(E1 ... Ek)`.

*Example*

```text
(# LESS (2 * 3) (5 + 7))
```

is a call to the relation `LESS` with arguments the values of the expressions `(2 * 3)` and `(5 + 7)`. This source call will be compiled into the target call

```text
(# (LESS X Y) ((* 2 3 X)(+ 5 7 Y)))
```

in which a list of atoms that will evaluate the expressions `(2 * 3)` and `(5 + 7)` appears as the second argument. The first argument is the call to the relation `LESS` with arguments the variables which have the values of `(2 * 3)` and `(5 + 7)` when this list of atoms is evaluated.

This `#` call is logically equivalent to the three ordinary calls

```text
(* 2 3 x)(+ 5 7 y)(LESS x y)
```

The definition of `#`, which is exported from `micro-mod`, is

```text
((# X Y)(/? Y)
   X)
```

Thus `#` evaluates the atom list `Y` before it evaluates the call `X`. Note the use of the backtracking control primitive `/`. This prevents backtracking on the atom list evaluation, ie, on the evaluation of the arguments to the call `X`. However, it does not prevent backtracking on the evaluation of `X`.



*Example*

```text
(# salary x (2 * y))
```

will be compiled into

```text
(# (salary x z) ((* 2 y z)))
```

If the value of `y` is known at the time the call is evaluated, the `*` call will compute `z`, and the evaluation of the `#` call will reduce to the evaluation of

```text
(salary x N)    where N is some number
```

Backtracking will result in different values being sought for `x`, but not in the re-computation of `N`.

### 6.2.2 The = relation

Uses of `=` have the form

```text
(= E1 E2)
```

where `E1` and `E2` are expressions. It is equivalent to

```text
(# EQ E1 E2)
```

ie, to a call of the primitive `EQ` relation with arguments the values of the expressions `E1`, `E2`. An `=` atom in a MICRO clause is the equivalent of an equality condition in a SIMPLE sentence.

*Example*

```text
(= (2 * x) (3 + y))
```

is equivalent to

```text
(# EQ (2 * x) (3 + y))
```

and will be compiled into

```text
(# (EQ X Y) ((* 2 x X)(+ 3 y Y)))
```

The `EQ` relation is a primitive of micro-PROLOG and is defined by the single clause

```text
((EQ X X))
```

So, an `=` call evaluates its arguments and then unifies them. When the values are numbers, as they are here, this amounts to checking that they are identical. When one of them is a variable, as in

```text
(= x (234/23))
```

it will result in `x` being given the value of the expression `(234/23)` ie `1.0173913E1`.

### 6.2.3 Syntax of expressions

Section 5.4.3 describes the syntax of expressions and tells you how a relation `R` may be declared a function, using the

```text
function R
```

command, and then used in expressions. This command adds a

```text
((func R))
```

clause to the workspace program. The `func` clause is not automatically deleted when you kill the relation `R`. So you should delete it yourself if you do kill a relation that has been declared a function.

As with SIMPLE, you can recover from the error of not having declared a relation as a function before using it in an expression in a clause. You will get the warning message from `exptran-mod`

```text
R assumed not to be a function
```

edit the clause and immediately exit from the editor. The expression is de-compiled before it is displayed, and re-compiled on exit. This time the use of `R` as a function name will be recognised.

### 6.2.4 Killing exptran-mod

The `exptran-mod` module occupies between `2K` and `3K` of program memory. After it has been used to compile expressions in the clauses of some entered program it can be killed. You will not of course be able to use expressions in any of the queries to the program. If you do, or you forgetfully add a clause containing expressions when `exptran-mod` is not present, you will get an error message of the form

```text
No clauses for (Expression-Parse <expression> <var> <var>)
```

This is because the `add` command has found some use of an expression and has tried to call the `Expression-Parse` relation exported by `exptran-mod`. The error message has been displayed by the `errtrap-mod` error handler. You can recover from the error by loading the `EXPTRAN` file which contains just `exptran-mod`; the details are in the next section.

You will not get this error message when you try to edit a clause with compiled expressions, even though `Expression-Parse` is normally also called by the `edit` commands to de-compile expressions. This is because before `Expression-Parse` is called to de-compile expressions a check is made to see if the `exptran-mod` module is present.

If `exptran-mod` is not present, the expressions are displayed in their compiled form. This means that you can use `exptran-mod` when you are developing a program and want to use the convenient shorthand provided by expressions. Then, for serious use of the program where space might be at a premium, you can kill the module; you can re-load it when you want it again.

## 6.3 The error handler errtrap-mod

The module `errtrap-mod` in file `ERRTRAP` exports the relation `"?ERROR?"`. As described in Appendix C, if this relation is defined by some loaded module or workspace program, the micro-PROLOG interpreter will call the `"?ERROR?"` program when it encounters a runtime error. The program for `"?ERROR?"` given in `errtrap-mod` then displays a message of the form

```text
<short phrase describing the error> <atom of the call>
error&(? for info).
```

The short phrase for the error is similar to the one given by the example `"?ERROR?"` program given in Appendix C. You will continue to get the `error&` prompt while in an error trap state. The query evaluation that caused the error is suspended. There are now various options that allow recovery action to be taken and the suspended evaluation to be resumed.



You can obtain a brief description of these options by entering `?`. You will then see displayed

```text
to quit enter : q
to fail call enter : f
to succeed call enter : s
to line edit call and resume enter : e
or enter / <any command (eg / add <clause>, / load file)
or enter : tell
to resume enter : c
error&.
```

The responses are as follows.

**q response** quits the suspended evaluation and returns you to the supervisor. After the `q` you will get the normal supervisor prompt `&.` and you can use any of the supervisor or MICRO supported commands in the normal way.

**f response** resumes suspended query evaluation, but with the error-invoking call assumed to have no solution, ie, to have failed.

**s response** is the same as for `f`, except that the call is assumed to have been solved with its current arguments.

**e response** re-displays the offending call with the line editor of micro-PROLOG in edit mode. You can line edit the call in any way but if you want to leave variables in the call you should use the variable names displayed in the call. When you exit from the line editor, the evaluation will be resumed but with the offending call replaced by its edited form.

Note that you have not edited the program; you have only changed the call for this one execution in order to avoid the error. Generally, you should also have edited the clause that led to the error using the `/ <command>` response, or you should edit the program when the current query evaluation finishes.

**/ <command> response** where `/` is the escape character that enables you to enter any supervisor command or MICRO command. This must be the command name followed by its arguments. You cannot just enter a clause; you must use `add` or `ADDCL` to do this. You can thus edit your program, list it, load files, or add new clauses. An example of a `/ load file` recovery response is given below.

**tell response**
calls the `is-told` relation exported by the module
`told-mod` with argument the offending call which
can then be answered interactively as described in
section 5.5. It is useful for top-down programming
- you can use relations in your program before
defining them. Then, when you get the error
`No clauses for` when the call on the relation is
reached you can provide the answer or answers to
the condition in response to the `is-told` prompts
without having to give the definition. But note that
your answers are not saved. A subsequent use of
the relation in the current query may force you to
give the same answers. The only way to avoid this is
to load a file with a program for the relation, or to
add some clauses to define it. The use of `tell` is also
in many cases an alternative to editing the call.

**c response** should only be given after you have executed one or more commands that will ensure that the error will not occur when the evaluation is resumed - for example, if you have added some clauses for a relation after getting the `No clauses for` error message and are now ready to continue with the suspended evaluation. The evaluation is resumed at the point where the offending call was tried, so the call is re-evaluated.

If you enter any other response you will get the `?` message.

### 6.3.1 Example error recovery

1. Suppose that you have killed `exptran-mod` or you have not loaded it
and then you use an expression in a query or added clause. You will get an
error message of the form

```text
No clauses for (Expression-Parse <expression> <var> <var>)
error&(? for info).
```

The `.` is the prompt for you to enter a response.

```text
error&(? for info). / load EXPTRAN
error&.c
```

2. Suppose that you have misspelled a relation name in some call of a
program clause, using say `parentof` instead of `parent-of`. You will get an error
message of the form



```text
No clauses for (parentof .. ..)
error&(? for info).
```

There are three ways to recover.

1. You can use `e` to edit the call and change `parentof` to `parent-of`. But
remember that this change applies only to this call; if the clause with the
misspelled relation is used again you will get the error again.

2. You can add a clause defining `parentof` as `parent-of` and then resume
with the responses

```text
/ add ((parentof X Y)(parent-of X Y))
c
```

This avoids the error on this and all subsequent uses of the incorrect clause. After the current query evaluation is over you can find the misspelling, edit it, and then delete this added clause. This is perhaps the best recovery response.

3. You can list the clauses in which you think the misspelling appears and
then edit the offending clause. This removes the problem for subsequent uses
of the clause but not for any currently active uses which includes the current
error. To avoid a recurrence of the current error, either do (2), deleting the
new clause when the current evaluation is finished, or edit the call, or enter
`tell` to invoke `is-told` with argument the offending call.

## 6.4 Using the is-told relation

`is-told` is a multi-argument relation exported from the module `told-mod` in the file `TOLD`. When evaluated it displays its sequence of arguments followed by a `?` and waits for a response. If there is just one argument, which is a list, this is displayed without the outer brackets. The responses and their effects are fully described in section 5.6. To use `is-told` in MICRO programs you must load the module with a

```text
LOAD TOLD
```

### 6.4.1 Example uses of is-told

These are the same examples as given in section 5.6 but using the query commands of MICRO and its clause syntax.

```text
(1) all((percent z) (is-told mark x outof y) (= z (x/y*100)))
```

sets up an interaction that can be used to convert pairs of numbers to percentages. A possible interaction is

```text
mark X outof Y ? ans 20 40
(percent 50)
mark X outof Y ? ans 15 60
(percent 25)
mark X outof Y ? just 40 120
(percent 3.3333333E1)
No (more) answers
```



```text
(2) ((is-male x) (known-male x))
    ((is-male x) (NOT known-male x)
       (is-told (x a male)) (ADDCL ((known-male x))))
```

defines `is-male` in such a way that the user is queried whenever an `is-male` condition is encountered with argument given but not recorded as a `known-male`. A `yes` response to the question such as

```text
keith a male ?
```

results in the `(is-male keith)` condition that invoked the query being solved and a `((known-male keith))` assertion being added to the program. A `no` response results in the condition failing.

### 6.4.2 Using is-told from the error handler

The `tell` response of the `errtrap-mod` error handler calls `is-told` with argument the error atom. You can then provide one or more answers to the condition using any of the `is-told` responses. If you use `tell` and the `is-told` has not been loaded you can still continue. The interaction will be of the form

```text
No clauses for (father-of tom X)
error&(? for info).tell
No clauses for (is-told ((father-of tom X)))
error&(? for info). / load told
error&.c
(father-of tom X) ? .
```

and you can now continue by answering the `(father-of tom X)` question in the manner as described above. You have recovered from an error encountered in an error recovery action. You are now out of the error state.

## 6.5 Tracing and structure editing

Both the `TRACE` and `SPYTRACE` utilities described in Chapter 4 can be loaded and used in conjunction with MICRO. If you use `TRACE` it might be useful to kill the optional modules `exptran-mod` and `told-mod` before tracing in order to gain space. You can re-load them after the trace. Alternatively, you can kill all four MICRO modules, and re-load all four with a `LOAD MICRO` after the trace.

The structure editor in `EDITOR` described in Chapter 4 can also be loaded and used with MICRO.

## 6.6 Graphics queries

A special version of `which` called `show` which can be used to display answers graphically is available on file `MICSHOW`. This contains the module `micshow-mod` and exports two relations, `draw` and `show`.

### 6.6.1 draw

The `draw` unary relation can be used as a command or as a program relation. It invokes any user `picture` definition that matches its single argument, provided that the argument is not a variable. If there is not picture definition that matches the argument, and the argument is a list, it recurses down the list trying to find picture definitions for each term on the list, calling any which match. A call to `draw` always succeeds.

*Example*

Suppose that the user program contains the picture definitions

```text
((picture sam)(PNT 0 0))
((picture (line x1 y1 x2 y2))(LNE x1 y1 x2 y2))
```

that make use of the graphics primitives `PNT` and `LNE` described in section 7.5.

The command

```text
draw sam
```

will cause a point to be drawn at the centre of the graphics display area. The command

```text
draw ((line -15 -20 15 -20)(line 15 -20 15 20))
```

will draw two lines at right angles.

### 6.6.2 show

The `show` query command has exactly the same format as the `which` command. It will give all the solutions to a query of a certain form; however, as each answer is given, it is also drawn using the above `draw` relation. The command should be used when the display is in hybrid mode; see section 7.5.

*Example*

```text
((between x x z))
((between x y z)(SUM y 5 Y)(LESS Y z)(between x Y z))
((picture (pnt x y))(PNT x y))
show ((pnt x y) (between x -88 60)(SUM x 20 y))
```

will cause all the points on the line `y = x + 20` to be displayed at five pixel intervals between the `x` coordinates `-88` and `60`. At the same time the answers

```text
(pnt -88 -68)
(pnt -83 -63)
(pnt 57 77)
```

will be scrolled in the text area.



# Chapter 7
# Built-in programs

A special feature of the built-in programs in micro-PROLOG is that they model program defined relations as closely as possible. For example, the `SUM` relation can be viewed as though it were defined by a set of facts about addition, and the `TIMES` relation as though it were defined by the various `'times tables'`. This is because the built-in programs attempt to simulate the different patterns of use of the relation; the `SUM` built-in program is able not only to add up numbers, but also to subtract them.

For reasons relating to efficient implementation, micro-PROLOG compromises on the ideal of supporting every possible use and generally allows only some of the possible uses of its built-in programs. In particular, the assembler coded built-in programs only support the deterministic uses of the relations they represent.

However, in general, each built-in program has several uses. This helps to minimise the number of names the programmer has to know, and also helps to keep micro-PROLOG programs `'invertible'` - able to support different patterns of use for the relations they define.

If a particular call to a built-in program is an illegal use (for example if `SUM` is called with two or more arguments as variables) then the system raises a `Control Error`. An error of this kind usually occurs only if there are too many variables in the call.

There are over 50 built-in programs, divided into a number of functional groups: the arithmetic operations, string operations, console and file input/output operations, graphics, colour and sound primitives, type predicates, database operations, logical operations, library procedures, module construction facilities, and miscellaneous predicates. We take each group in turn and describe the formats and semantics of each built-in program. For the relations that are implemented entirely as micro-PROLOG programs embedded in the supervisor we also give defining programs. It is these programs that will be displayed if you `LIST` the relations.

In introducing each relation we give its form of use, a comment (inside `{}` brackets) which gives a brief description of its meaning, and the restrictions, if any, on its use. The restrictions concern the arguments that must be known, or the arguments that must be variables, when a condition for the relation is evaluated. When the argument can be any term we indicate this by using `a t`, `t1` etc in that argument position in the form of use. When the argument must always be known at the time of evaluation, and must be a particular type of value, we give the value type in the form of use. For example, if a particular argument to a relation must be an integer at the time of evaluation the type `<integer>` will appear in that argument position in the form of use.



Remember that each primitive unary relation can also be used as a supervisor command - see Chapter 3.

## 7.1 Arithmetic Operations

The arithmetic relations `SUM`, `TIMES`, `LESS`, `INT`, and `SIGN`, cater for the normal operations of addition, subtraction, multiplication, division and comparison on integer and floating point numbers.

### 7.1.1 SUM

```text
(SUM x y z) {x + y = z}
```

At least two arguments - which must be numbers - must be given.

`SUM` is true of three numbers when the first two add up to the third. The numbers involved can be integer, floating point or a mixture of the two types. The `SUM` primitive can be used in three ways.

1. **Check a sum.** If all arguments are given then `SUM` succeeds only if the first
two numbers add up to the third. For example, `(SUM 20 30 50)` is true, as is
`(SUM 1.5 0.3 1.8)` and `(SUM 23.6 -0.6 23)`.

2. **Add two numbers together.** If the first two arguments are numbers and
the third a variable then the call succeeds by instantiating the third argument
to the sum of the first two. For example, `(SUM 30 -2 x)` binds `x` to `28`, and
`(SUM 30 2.5 y)` will instantiate `y` to `32.5`.

3. **Subtract two numbers.** If the third argument is a number, and either the
first or the second is also a number (with the remaining argument a variable)
then the call succeeds by binding the variable in the call to the result of
subtracting the first (or second) number from the third. For example, `(SUM x
3 15)` binds `x` to `12`, as does `(SUM 3 x 15)`.

If an addition or subtraction results in an overflow (or underflow), then micro-PROLOG signals an appropriate error. This causes any resident `?ERROR?` program to be invoked as for other kinds of signalled error; see Appendix A.

micro-PROLOG uses eight digits of accuracy in its arithmetic calculations, and the exponent can range from `-99` to `99`. Truncation (towards zero) rather than rounding is performed if the number of significant digits in a calculation is more than eight.

### 7.1.2 TIMES

```text
(TIMES x y z) {x * y = z}
```

At least two arguments - which must be numbers - must be given.

The `TIMES` relation can be used to multiply, divide or to check a multiplication.



1. **Check a product.** If `TIMES` is called with all three arguments numbers,
then the product of the first two numbers is checked against the third
number. If they are the same the call succeeds; otherwise it fails. For
example, `(TIMES 3 4 12)` is true, as is `(TIMES 0.5 -3 -1.5)`.

2. **Multiplication.** If `TIMES` is called with just the first two arguments given,
and the third argument a variable, the call succeeds by binding the variable to
the product of the two numbers. The call `(TIMES 3 -4 x)` results in `x` being
bound to `-12`.

3. **Division.** There are two forms of the `TIMES` program which can be used
for division. Both involve the division of the third argument of the `TIMES` call
by either the first or second argument depending on which is known at the
time. The remaining argument is instantiated to the quotient of the two given
numbers.

```text
(TIMES x 10 30)    {x is bound to 3}
(TIMES 10 x 25)    {x is bound to 2.5}
```

The division of an integer by another integer may of course result in a floating point number. Similarly, if two floating point numbers are divided it is possible that the quotient is an integer. Any necessary conversions between the two kinds of numbers are performed automatically.

If a division by zero is attempted an `Arithmetic overflow` error is signalled.

### 7.1.3 LESS

```text
(LESS <number1> <number2>)
{<number1> is less than <number2>}
```

The `LESS` built-in predicate implements the inequality test for numbers. Only one arithmetic usage is allowed, where both arguments are given and are numbers. In this case the call succeeds if the first number is numerically less than the second; if they are equal or if the first number is greater than the second the call fails. For example, `(LESS 2 3)` is true, as is `(LESS -1 1.32)`; but neither `(LESS 10 9)` nor `(LESS 4.4 4.4)` is true.

`LESS` can also be used to compare constants, see section 7.2.1 below.

### 7.1.4 INT

```text
(INT <number> y) {y the nearest integer to <number> between 0 and <number>}
```

`y` must be a variable at call.

The `INT` primitive can be used to find the nearest integer to a given number. The nearest integer (truncating towards zero) is returned as the value of `y`. This two-argument form of `INT` can only be used in this single mode. A one-argument form of use is described in section 7.6.2.

The nearest integer to a large floating point number may not be representable as an integer in the range `-32767 ... 32767`. In this case, a floating point number is still used to represent the result though it will have an integer value.

The nearest integer to `1.9` (towards zero) is `1`: `(INT 1.9 x)` binds `x` to `1`. The call `(INT -134513.456 y)` instantiates `y` to the number `-134513`, which, because it cannot fit in 16 bits, is given as the floating point number `1.34513E5`.

### 7.1.5 SIGN

```text
(SIGN <number> y) {<number> > 0, y = 1
                   <number> = 0, y = 0
                   <number> < 0, y = -1}
```

`y` must be a variable at time of call.

The `SIGN` primitive returns the sign of its numeric first argument in the second argument. Only one use is permitted where the first argument is a given number - which can be integer or floating point - and the second argument is an unbound variable.

For example, `(SIGN -3 x)` instantiates `x` to `-1`, `(SIGN 0 y)` binds `y` to `0`, and `(SIGN 25.67 z)` binds `z` to `1`.

## 7.2 String operations

In micro-PROLOG, strings can be represented and manipulated as lists of characters. A string in packed form is a constant. There is a primitive `STRINGOF` relation that can be used to convert between strings as character lists and constants. `LESS` can be used to test the lexicographical order of constants and `CHAROF` can be used to convert between characters and their ASCII codes.

### 7.2.1 LESS

```text
(LESS <constant1> <constant2>)
{<constant1> lexicographically less than <constant2>}
```

Similar to the inequality test for numbers, this test for constants tests that the first argument (which must be a given constant) is textually less than the second (which must also be a given constant). The ordering used is the lexicographical ordering, based on the ordering of the underlying ASCII character set.

For example, `(LESS FRED FREDDY)` succeeds since `FRED` is lexicographically less than `FREDDY`.

### 7.2.2 STRINGOF

```text
(STRINGOF x y) {x is a list of characters of constant y}
```

Either `x` must be a list or list pattern and `y` a constant, or `x` must be a character list and `y` a variable.

The `STRINGOF` relation can be used either to convert a constant into a list of its constituent characters, or to pack a list of characters into a single constant. There are essentially two forms of use.



1. **Unpacking.** To produce a list of characters from a constant, the second
argument must be a constant (not a number or list) at the time of evaluation.
The result is the unification of the first argument with the list of characters of
the constant. If the empty constant `""` is given its list of characters is the
empty list `()`.

```text
(STRINGOF x fred) results in x being bound to the list (fred), and
(STRINGOF x "A ") binds x to the list (A  ).
```

For unpacking, the first argument may be given as a list or a list pattern. This allows comparison of a list of characters with the constant, and the use of a pattern allows a particular character of the constant to be picked up as the binding of a variable.

```text
(STRINGOF (f r x d) fred)    {x = e}
(STRINGOF (f r|x) fred)      {x = (e d)}
(STRINGOF (f r|x) gerry)     {fails}
```

A given list of characters must be just that: a list of constants which have single character names.

2. **Packing.** This takes a list of characters and produces a constant from it. It is
the inverse of the unpack use.

```text
(STRINGOF (f r e d) x)    {x = fred}
(STRINGOF () x)           {x = ""}
```

### 7.2.3 CHAROF

```text
(CHAROF x y) {x is character with code y}
```

At least one argument must be given.

The `CHAROF` primitive implements a mapping between single character constants and the ASCII coding sequence. Three uses are allowed: where either `x` or `y` or both are known at the time of the call. Some examples of its use are

```text
(CHAROF A 65)
(CHAROF B x)        {x is instantiated to 66}
(CHAROF y 32)       {y is instantiated to " "}
```

In fact, if the `x` argument is given it can be any constant; the ASCII code is then the code of the first character of the constant.

```text
(CHAROF FRED z)     {z is bound to 70}
```

`CHAROF` interprets its second, integer argument modulo 256. Hence

```text
(CHAROF x 258)
```

is equivalent to

```text
(CHAROF x 2)
```

## 7.3 Console I/O operations

The input/output facilities are divided into two groups: console I/O and file I/O. Console I/O reads terms from the keyboard and displays them on the console. File I/O (section 7.4) transfers terms to and from the backing storage system. In fact the console I/O primitives are defined in terms of the file I/O primitives as we shall see below.

The I/O facilities described here are the first example of a non-logical feature of micro-PROLOG. This is because they depend on their behaviour (reading and writing terms) for their meaning. However, the power of PROLOG as a systems programming language arises in large measure from its combination of declarative and imperative features.

There are four built-in programs for dealing with Console I/O: `R` (Read), `P` (Print), `PP` (P-Print) and `RFILL`, which respectively read a term from the console, print a sequence of terms, pretty print a sequence of terms, and `'pre-fill'` the keyboard buffer with a sequence of terms.

### 7.3.1 R

```text
(R x) {x the next term typed on keyboard}
```

`x` must be a variable at time of call.

The `Read` program reads a single term from the keyboard and binds its argument to the term it reads in. It must be called with a variable as its argument; otherwise a `Control Error` is signalled. If there is already a term in the keyboard buffer (see Chapter 3) this will be the value returned; otherwise the read prompt `.` is displayed and the evaluation will suspend until a term is entered.

Any variables in the entered term are converted to the special internal form for variables in which the variable name used in the term is discarded. However, different occurrences of the same variable in the term will be converted into the same internal form. The internal form for each variable of the term will be different from the internal form of any other variable in the program, ie, it will be an entirely new variable. It will also be different from the internal form assigned to a variable of any other term that has been read in, or will be read in, even if the variables have the same name. In micro-PROLOG the scope of a variable name is the term in which it appears.

See section 3.1 for details of how micro-PROLOG accepts terms from the keyboard.

The `R` primitive side-effects the keyboard buffer removing the first term from the buffer. A call to `R` only has one solution. A backtracking return to the call will not result in an attempt to find an alternative solution by reading in the next term. The second attempt to solve the call will fail. The call will be re-solved only if an earlier call has an alternative solution and this leads to a fresh attempt to solve the `R` call. At that point, the next term in the buffer will be read.

### 7.3.2 P

```text
(P t1 t2 .. tk) {display t1 t2 .. tk on the console}
```

The `Print` program displays its sequence of any number of arguments. It takes any number of arguments each of which can be any term; the terms will be displayed separated by a single space. There is no automatic new line on completion. A subsequent `P` or `PP` will therefore start one character position after the preceding `P` finished its display.

The `P` primitive displays constants in its argument terms as the sequence of their component characters. Thus a constant that would have to be quoted on input (see Chapter 2) will be displayed without the quotes. This means that any control characters in the constant (see section 2.3), which appear as `@<char>` combinations in the quoted form, are sent to the output device as control characters. A control character in a constant will therefore produce the effect that it is supposed to produce on the display.

For example, the Spectrum uses ASCII code decimal 17 to signal a change of paper colour. This character can be entered into a quoted constant as `@Q` since `Q` has ASCII code 81 (17+64). This paper colour control must be followed by the colour number - an ASCII character with code 0 to 7 which can be generated using `CHAROF` (see later in this chapter). However, you can enter the ASCII code 0 using the key `CAT` (`SYMBOL SHIFT + 9` in `E` mode) and the codes 1 to 7 using `@A`, `@B`, ..., `@G` since `A` to `G` have the ASCII codes 65 (1+64) to 71 (7+64). So,

```text
(P "@Q@F")
```

will set the paper colour to yellow. Using this unary form as a command, the `P` command

```text
P "@Q@F"
```

will therefore also change the paper colour to yellow.

You can move the cursor by using the constant `@V` which will produce ASCII decimal code 22, the Spectrum `AT` control code, followed by two ASCII characters giving the line and character position. Thus

```text
(P "@V@D@Fapples")
```

will display the text `apples` in column 6 of line 4 on the screen. This is because `@D` and `@F` denote the ASCII codes 4 and 6. The `AT` cursor control is described in Chapter 15 of the Spectrum BASIC manual and all the ASCII control codes are given in Appendix A of that manual.

Variables occurring in the sequence of displayed argument terms are given the names `X`, `Y`, `Z`, `x`, `y`, `z`, `X1`, ..., `z1`, `X2` and so on, corresponding to the order that the variables are encountered during the print. The first variable encountered is given the name `X`, the second one the name `Y` and so on. The same internal form variable appearing in more than one term of the displayed sequence of terms will have the same print name. So, if the first variable that appeared in `t1` also appears in `t2`, it will be displayed as `X` in both terms. If there are more than 128 different variables, then subsequent variables are displayed as `???`.

### 7.3.3 PP

```text
(PP t1 t2 ... tk)    {Pretty Print t1 t2 ... tk on the console}
```

The `PP` program displays its sequence of `t1 ... tk` arguments in a standard format. It is very similar to the `P` program except that a carriage return/line feed automatically occurs after the terms are displayed. In other words, `PP` always terminates the display of its arguments by sending the `<enter>` character to the screen display. This means that a subsequent `P` or `PP` starts at the beginning of a new line. Moreover, `PP` displays constants that would need to be quoted on input in quoted form. `PP` displays the terms in such a way as to guarantee that if they were read back in, the same terms would be re-constructed - except for variables which are always new.

Control characters occurring in the quoted constants are displayed in the `@<char>` format. As an example of the difference between `P` and `PP`

```text
(P "(The man")
```

displays

```text
(The man
```

whereas the call

```text
(PP "(The man")
```

displays

```text
"(The man" <enter>
```

on the console.

Since the `PP` program always finishes by sending an `<enter>` character, a call to `PP` with no arguments, `(PP)`, will move the cursor to the beginning of a new line.

### 7.3.4 RFILL

```text
(RFILL (t1 t2 ... tk) x)
    {clear, then pre-fill, the keyboard buffer with t1 t2 ... tk and then read
     a term into x}
```

`x` must be a variable at time of call.

The `RFILL` program is used to invoke the built-in line editor with the sequence of terms `t1 t2 ... tk` given as the elements of its first (list) argument already in the keyboard buffer. The terms, as displayed, can then be edited using the line editor. When `<return>` is entered, the first term in the buffer - usually the edited form of `t1` - is automatically read in to become the binding of the variable `x`. The edited forms of `t2 ... tk`, if they were given in the call, must be explicitly read in using `R` since they will be left in the keyboard buffer. `RFILL` displays constants in the `PP` format so that they can be read back in.

`RFILL` remembers the print names given to each internal form variable in `t1`. When the edited version of the displayed `t1` is read back in as the binding of `x`, each of these remembered variable names is converted back into the internal form variable that appeared in the original `t1`. Variables' names in the edited form of `t1`, which are the same after editing, thus become the same *internal variables* as those that appeared in the `t1` argument to `RFILL`.

This facility for remembering variable names is necessary for the use of `RFILL` for editing programs, particularly when it is used from within a structure editor to edit a component of a clause. `RFILL` is used in this way by the structure editor described in section 4.3.4. It is invoked by the `t` command. `RFILL` is also used by the `e` error recovery command of the `errtrap-mod` module described in section 6.3. The facility for remembering variable names is essential for this as well.



Note that, although a list of terms must be given as the second argument to `RFILL`, the list is displayed without the outer level of parentheses.

`RFILL` also has the side effect of clearing any previous contents of the keyboard buffer. If several terms have previously been typed on a line, any `unused` terms will be discarded when `RFILL` is invoked.

As we have already mentioned, `RFILL` is used by the `t` command of the structure editor. It is also used by the `edit` commands of both SIMPLE and MICRO. As an example, a simplified version of the editor of MICRO is defined by

```text
((edit x)                 {command: edit relation x}
 (R y)                    {read the clause number}
 (CL ((x|z)|z1) y y)      {find the yth clause of x}
 (RFILL (((x|z)|z1)) z)   {invoke line editor with the clause in the
                          buffer}
 (ADDCL z y)              {add the edited clause z to the program}
 (DELCL x y))             {delete the old clause for x}
```

For an explanation of the other primitives see Section 7.8.

## 7.4 File I/O operations

Spectrum micro-PROLOG supports text files. The character sequence of a file can be interpreted as a sequence of micro-PROLOG terms with the syntax described in Chapter 2. These terms can be written out and read in using the file primitives `READ`, `W` and `WRITE`. Only one file may be open during an evaluation at any one time; an attempt to have more files open results in the `Too many files opened` error. This error is most likely to occur if file transfer is aborted for some reason and the file is not closed. The supervisor primitives `LOAD` and `SAVE` make use of the file I/O primitives to load and save micro-PROLOG programs as text files. They automatically open the program file and close it on completion. However, if they are aborted or do not properly terminate due to an error, the file will be left open.

```text
CLOSE <program file name>
```

using the name of the program file, should be used to close the file.

### 7.4.1 OPEN

```text
(OPEN <file-name>)    {open named file for reading}
```

This built-in program opens a file for reading. The `<file-name>` argument is a constant which names the file. The `OPEN` sets up an input buffer for the file and reads the first block into this buffer. A subsequent `READ` that uses the file name gets its term from this buffer filled by the `OPEN`.

### 7.4.2 CREATE

```text
(CREATE <file-name>)    {create and open a new file for writing}
```

This opens the named file for writing. If the file is already open for writing then the `File error` is signalled. It creates an output buffer for the file.



### 7.4.3 CLOSE

```text
(CLOSE <file-name>)    {close down the named file}
```

There are no special actions associated with closing a file which is being read; however, a file which is being written to must be explicitly closed down in order to flush the output buffer and add the end of file mark character to the last block written on to the tape.

The `CLOSE` primitive performs this operation and releases the file from micro-PROLOG. It is also used to release files opened for read access.

### 7.4.4 READ

```text
(READ <file-name> x)    {x is the next term on the named file,
                         x must be a variable at the time of call}
```

The `READ` primitive reads the next term from the named file and binds its argument to the term. It finds the term by taking characters from the input buffer associated with the file and by automatically refilling the buffer by reading the next block it finds in the file. It refills the buffer when it needs to look beyond the last character of the buffer in order to complete the term it is reading. Please see Appendix E for the pragmatics of particular file storage media.

### 7.4.5 WRITE

```text
(WRITE <file-name> (t1 t2 ... tk))
    {write the sequence of terms t1 t2 ... tk on the named file in PP
     format}
```

The sequence of terms `t1 t2 ... tk` is written on to the file in the same form as the `PP` program. This ensures that any term written on to a file can be subsequently read back in as the same term, with the exception of variables which are renamed. At the end of the transfer of `t1 ... tk` an `<enter>` character is sent to the file.

### 7.4.6 W

```text
(W <file-name> (t1 t2 ... tk))
    {write the sequence of terms t1 t2 ... tk on the named file in P format}
```

`W` has exactly the same effect as `WRITE` except that the terms are written in the same way that `P` displays terms on the console.

Note that terms written using `W` will not be re-readable as terms if they contain any constants that would need to be quoted on input. The `W` does not complete the transfer with an `<enter>` character.

Both `W` and `WRITE` handle variables in the same way as the `P` and `PP` primitives. Each occurrence of a variable throughout the list of terms `(t1 ... tk)` is given the same print name in the sequence of terms written to the file.

### 7.4.7 Special file names

The two `serial` communications channels, the console and the printer, are denoted by special file names. These are:



```text
"CON:"    {the console device (I/O)}
"LST:"    {the printer device}
```

These special file names can be used in any of the above file I/O primitives. WRITing to the `LST:` file will actually print directly on to the printer.

The `R`, `P` and `PP` commands are defined by the following supervisor programs using `READ`, `W` and `WRITE` and the special file name `CON:`.

```text
((R X)
 (READ "CON:" X))

((P|X)
 (W "CON:" X))

((PP|X)
 (WRITE "CON:" X))
```

Note how the use of the meta-variable as the list of arguments (see section 2.9) makes `P` and `PP` multi-argument relations. The sequence of argument terms given in the call is passed on as a single list of terms to the `W` and `WRITE` primitives.

## 7.5 Graphics, colour and sound primitives

micro-PROLOG has primitives for exploiting the graphics facilities of the Spectrum. The coordinates used by micro-PROLOG for describing a position on the screen are different from those used by the Spectrum BASIC. The graphics area pixel points are denoted in micro-PROLOG by a horizontal (`x`) coordinate ranging from `-128` to `127` and a vertical (`y`) coordinate ranging from `-88` to `87`. The point `(-128 -88)` is at the bottom left of the graphics display area (which is all but the bottom two lines of the text display area) and the point `(127 87)` is at the top right. The reader should consult the Spectrum BASIC manual for more information on Spectrum graphics.

### 7.5.1 HYBRID

```text
(HYBRID)    {changes the display to hybrid mode}
```

The `HYBRID` primitive clears the screen and changes the display mode so that only the bottom four lines of the text display area are used by the supervisor and I/O primitives of micro-PROLOG. This leaves the first 20 lines of the text display area available for the graphics display. But notice that there is a two line overlap between the lines given by the Spectrum to the graphics area and the bottom 4 lines of the text area. To avoid displaying graphics in the top two lines of the text area you should restrict the `y` coordinate so that it is never more negative than `-72`.

If used as a command, the primitive must be given an (ignored) argument. For example,

```text
HYBRID m<enter>
```

The editors or `RFILL` should not be used in `HYBRID` mode since there is insufficient space on the screen to hold the terms being manipulated.

### 7.5.2 NORMAL

```text
(NORMAL)    {returns the screen to normal mode}
```

It is the opposite of `HYBRID`. If used as a command, it must also be given an (ignored) argument.

### 7.5.3 LNE

```text
(LNE x1 y1 x2 y2)          {draw the line from (x1 y1) to (x2 y2)}
(LNE x1 y1 x2 y2 z)        {draw the line with attributes defined by the
                            integer z}
(LNE x1 y1 x2 y2 z1 z2)    {draw the line with attributes defined by
                            integers z1 and z2}
```

The arguments `x1 y1 x2 y2` must be integers in the allowed ranges. If they are not, the `Point off screen` error is signalled. If no attribute codes are given, the line is displayed as black on a white background.

One or two attribute-defining numbers can be given as extra arguments. The first number defines the flash mode, the brightness, the paper background colour for the character positions through which the line passes, and the ink colour of the line. Its value should be

```text
128 * <flash code> + 64 * <brightness code>
+ 8 * <paper colour number> + <ink colour number>
```

The `<flash code>` and `<brightness code>` are both either `0` or `1` and have the same effect as in Spectrum BASIC. A `1` sets the flash or brightness on. The colour numbers must be between `0` and `7` and have the meanings:

```text
Colour number    Colour
0                black
1                blue
2                red
3                magenta
4                green
5                cyan
6                yellow
7                white
```

If a second attribute number is given, its value should be

```text
64 * <back code> + 16 * <fore code> + 4 * <inverse code> + <over code>
```

All the codes are either `0` or `1`.

```text
<back code> = 1     means background contrasts with foreground
<fore code> = 1     means foreground contrasts with background
<inverse code> = 1  means paper and ink colours are reversed
<over code> = 1     means that line display is 'ored' with and does
                    not replace any existing display that it passes
                    through
```

**Warning** Great care should be exercised when setting attributes as they are global settings and can cause later input to be invisible or unreadable.



### 7.5.4 PNT

```text
(PNT x y {z1 z2})    {display a point at (x y) with attributes
                      defined by optional z1 z2}
```

The attribute codes are as for `LNE`. If no attributes are given the point is displayed as black on a white background.

The use

```text
(PNT x y z)
```

where `x` and `y` are the coordinates of a point and `z` is a variable will return in `z` the first integer code for the attributes of the `x, y` point of the current display.

### 7.5.5 CLS

```text
(CLS)                  {clears the screen without changing the
                        colour}
(CLS <colour number>)  {clears the screen to the given paper colour}
```

The `CLS` primitive can be used to clear the screen and optionally to set the paper colour - the background colour of the area of the screen used for text and graphics. As an example, the command

```text
CLS 6
```

will clear the screen and set the paper colour to yellow.

### 7.5.6 BORDER

```text
(BORDER <colour number>)    {sets the border to given colour}
```

### 7.5.7 Setting INK and PAPER colours and attributes

These are changed by sending control sequences to the screen using the `P` primitive (see section 7.3).

### 7.5.8 BP

```text
(BP <duration> <cycles>)    {sounds a note of (approximately) the given
                            frequency in cycles per second}
```

The length of the note satisfies the (approximate) relation

```text
<length> in seconds = <duration> * 300,000 / <cycles>
```

**Warning** This predicate cannot be interrupted as it disables all keyboard interrupts, so if you specify a very long duration or a very short or negative number of cycles you will just have to wait till it finishes!

## 7.6 Type Predicates

The type predicates test a single argument for its type, ie, whether it is a number, constant, list or unbound variable.

### 7.6.1 NUM

```text
(NUM x)    {x is a number}
```

The `NUM` built-in predicate tests to see if its single argument is numeric or not. If it is a number, the call succeeds; if it is an unbound variable, a constant or a list then the call fails. For example, `(NUM 3)` and `(NUM -1.3e9)` succeed (are true), whereas `(NUM bill)` and `(NUM x)`, with `x` unbound, fail (are false).



### 7.6.2 INT

```text
(INT x)    {x is an integer}
```

The `INT` predicate, in its single argument form, checks its argument for being an integer. A number is classed as an integer even if it is a large integer that has to be represented as a floating point number. Hence `(INT 3.45e9)` is true. The call fails if the argument is an unbound variable or a non-integer value.

### 7.6.3 CON

```text
(CON x)    {x is a constant}
```

The `CON` built-in predicate tests if its single argument is a constant. For example `(CON foo)` succeeds, whereas `(CON ())`, and `(CON 1)` both fail. If the argument is not a constant (including the case where it is a variable) then the call fails.

### 7.6.4 LST

```text
(LST x)    {x is a list}
```

The `LST` predicate is true of lists, including the empty list. If the single argument is not a list, (again including the case where it is an unbound variable), the call fails.

### 7.6.5 SYS

```text
(SYS t)    {t is an atom for a primitive relation}
```

`SYS` tests to see if its argument is a call to a built-in relation, ie, one of the relations described in this Chapter. It succeeds if it is; it fails if it is an atom for any other relation.

### 7.6.6 VAR

```text
(VAR x)    {at the time of the call x is an unbound variable}
```

The `VAR` built-in type predicate checks to see if its argument is currently a variable. It is non-logical because a successful call is invalidated if the variable is subsequently bound.

## 7.7 Logical operators

The basic clausal form of logic programs, which is limited to the implicit `and` between the calls in the body of a clause, is extended via the logical operator primitives of micro-PROLOG. These are supervisor programs that implement: disjunction `OR`, negation-as-failure `NOT`, conditional alternatives `IF`, identity `EQ`, sequential solution `?`, test-on-all the solutions to a query `FORALL`, list-of-all solutions to a query `ISALL`, and the restriction to a single solution `!`. These can be used to increase the efficiency and the readability of micro-PROLOG programs. They also raise the level of the language, making it more powerful and expressive.



### 7.7.1 OR

```text
(OR <atom list1> <atom list2>)
    {either the query ?<atom list1> or the query ?<atom list2> can be solved
     (is true)}
```

The disjunctive operator `OR` has two arguments, each of which is a list of atoms. An `OR` call succeeds if either of its component queries is solved. For example

```text
(OR ((father-of x y)) ((mother-of x y)))
```

succeeds if either `(father-of x y)` or `(mother-of x y)` succeeds (is true).

An empty goal (named by the empty list `()`) always succeeds, and hence if used as an argument to `OR` acts as a `true` branch.

The supervisor definition of `OR` is

```text
((OR X Y)|X)
((OR X Y)|Y)
```

This uses the `meta-variable as the rest of the clause` form (see section 2.9). From the definition we can see that the `either` branch is tried first (it is the first clause). Only when there are no more solutions to this branch will a solution to the `else` branch be sought. A `/` placed in the `either` branch will cut out the `else` branch option when it is evaluated. Thus, the `/` in

```text
(OR ((test X)/(process X Y)) ((default X Y)))
```

will cut out the `else` branch if `(test X)` succeeds. See below for more information on `/`. A `/` in any of the logical operators only has an effect on the backtracking within the operator. It has no effect on the backtracking evaluation of the other conditions in the clause or query in which the logical operator appears.

### 7.7.2 NOT

```text
(NOT <relation-name> t1 t2 ... tk)                 (A)
    {the condition (<relation-name> t1 t2 ... tk) fails (is false)}
```

The `NOT` operator implements negation-as-failure [Clark 1978]. It denotes the negation of the call

```text
(<relation-name> t1 t2 ... tk)                     (B)
```

The negation `(A)` succeeds if, and only if, the unnegated call `(B)` fails.

There is an implicit assumption that the program definition of the relation is *complete*; that all the positive instances can be inferred from the program definition. On this assumption, it is correct to assume that a condition is false (hence that its negation is true) if an attempt to prove the condition fails.

A negated condition can only be used for testing; it cannot be used to find any values for variables in the condition such that the condition is false. Indeed, the more correct reading of the call is

```text
show that
    there are no x1,...,xn such that
        (<relation-name> t1 ... tk)
```

where the `x1,...,xn` are all the variables in the call at the time that it is evaluated. This means that the reading and effect of a program which uses



`NOT` can be affected by the position of the `NOT`.

As an example,

```text
?((parent-of john x)(NOT male x))
```

is read: show that `john` has a child who is not (provable) male, whereas

```text
?((NOT male x)(parent-of john x))
```

must be read

```text
show that
    there is no x such that x is male and
    show that there is an x who is a child of john
```

This reading is forced because the `x` in `(NOT male x)` will be unbound when the condition is evaluated. The `(NOT male x)` condition will fail if there is at least one way of showing that there is a male.

The fact that `NOT`, implemented as `failure to prove`, is only an approximation to the logical negation is evident in the use of a double `NOT`. The queries

```text
?((parent-of tom X)(PP X))
?((NOT NOT parent-of tom X)(PP X))
```

are *logically* equivalent. However, with the first, the name of any found child of `tom` will be printed, with the second the unbound variable `X` will be printed. The double `NOT` succeeds if `(parent-of tom X)` succeeds but it will leave the variable `X` unbound. The first query is read

```text
show that
    there is an X such that (parent-of tom X)
    and display the found X
```

The second is read

```text
show that
    there is an X such that (parent-of tom X) and
    then show that there is an X that can be displayed
```

The second reading derives from the fact that the `X` in the negated condition is unbound when it is evaluated.

The positive aspect of this imperfection of `NOT` is that double negations can be used to test if a condition succeeds *without* binding any variable in the condition.

**RULE OF THUMB:** Place negated, test conditions on a variable (or variables) after positive conditions/calls that can be used to find values for the variable(s).

The supervisor definition of `NOT` is

```text
((NOT|X) X
         / FAIL)          {If X is provable then (NOT|X) must fail}
((NOT|X))                {else, (NOT|X) is proven}
```

Note the essential use of `/` to prevent the use of the second clause if `X` succeeds. It also makes sure that `X` is only proven once.

Only when there is no proof of `X` will the second clause be used. This confirms `(NOT X)` without instantiating any variables - hence the restriction of `NOT` to test use.

### 7.7.3 IF

```text
(IF <atom> <atom list1> <atom list2>)
    {either <atom> and <atom list1> can be solved (are true)
     or (NOT | <atom>) and <atom list2> can be solved (are true)}
```

The `IF` is a conditional alternative. Its use is equivalent to

```text
(OR ((<atom> / <atom list1>)) ((<atom list2>))
```

which uses `/` to prevent the use of the `or` branch if the `<atom>` test is solved. The `IF` form is more declarative. The declarative equivalent using `OR` would be

```text
((OR ((<atom> <atom list1>)) ((NOT | <atom>) <atom list2>))
```

with an explicit `(NOT | <atom>)` on the `else` branch. This form is much less efficient than the `IF` or the `OR` using `/` because of the repeated evaluation of `<atom>` in the second branch.

A definition of a relation `R` of the form

```text
((R ...) (IF (P ...) (<bodyA>) (<bodyB>)))
```

is (almost) equivalent to a definition using the pair of clauses

```text
((R ...) (P ...) <bodyA>)
((R ...) (NOT P ...) <bodyB>)
```

The difference is that in the `IF` definition the test `(P ...)` is only ever evaluated once.

The use of conditionals in this way is a mixed blessing because less use can be made of unification. For example in the two clauses for `R` above it could be that the heads of the two clauses would naturally be slightly different. When the conditional form is used the head must be the `most general` of the two, with extra equalities in the conditional branches to bind the variables in the head to the terms that they should be. For example

```text
((sort (x y|Z) (x|Z1))
 (LESS x y)
 (sort (y|Z) Z1))
((sort (x y|Z) (y|Z1))
 (NOT LESS x y)
 (sort (x|Z) Z1))
```

must be absorbed into

```text
((sort (x y|Z) Z2)
 (IF (LESS x y)
     ((EQ Z2 (x|Z1)) (sort (y|Z) Z1))
     ((EQ Z2 (y|Z1)) (sort (x|Z) Z1))))
```

which is much less readable. A non-declarative solution is to use `/` after the test of the first clause and to drop the test in the second.

```text
((sort (x y|Z) (x|Z1)) (LESS x y) / (sort (y|Z) Z1))
((sort (x y|Z) (y|Z1)) (sort (x|Z) Z1))
```

The supervisor definition of `IF` uses `/` in just this way. It is



```text
((IF X Y Z) X / | Y)
((IF X Y Z) | Z)
```

As with `OR`, a `/` placed inside the `then` or the `else` branch of an `IF` only effects the backtracking within that branch.

### 7.7.4 EQ

```text
(EQ t1 t2)    {t1 is identical to t2}
```

The supervisor definition of `EQ` is

```text
((EQ X X))
```

so the effect of the evaluation of an `EQ` condition is the attempted unification of its two argument terms.

```text
(EQ (x1 x2) (A B))    results in x1=A, x2=B.
(EQ (a|z) (x y c))    results in x=a, z=(y c).
```

### 7.7.5 ?

```text
(? <atom list>)    {true if the sequence of atoms in <atom list>
                    can be solved (are all true)}
```

The supervisor definition of `?` is

```text
((? x)|x)
```

`?` can be used when the syntax for a condition requires a single atom but you want to `pass` a `conjunction` of atoms. An example is the `IF` condition of which the test must be an atom. The form

```text
(IF (? <atom list>) (...) (...))
```

enables you to have several conditions for the test.

As a supervisor command, `?` is the primitive query form of micro- PROLOG. The more elaborate query forms of MICRO and SIMPLE are all defined using `?`. For example, the following is the definition of the `which` of MICRO:

```text
((which (X|Y))            {X is the answer pattern, Y the query}
 (? Y)                    {solve Y}
 (PP X)                   {display answer pattern X for this
                          solution}
 FAIL)                    {backtrack to find next solution}

((which (X|Y))            {when first clause fails}
 (PP No (more) answers))  {there are no more answers to Y}
```

### 7.7.6 FORALL

```text
(FORALL <atom list1> <atom list2>)
    {for all the solutions of <atom list1>, <atom list2> can be solved}
```

`FORALL` is a very high level concept, and can often replace explicit recursions in a program.

The following program defines `prime number` using `FORALL`. It is a specification that can be used as a prime checking program.

A positive prime number `x` is a number such that none of the integers `y` in the range `2 <= y < x` divide `x`. That is, for each `y` in this range it is not the case that `y` divides `x`. This definition is formalised as

```text
((prime x)
 (FORALL ((in-range 2 x y))
          ((NOT divides y x))))
```

where `in-range` and `divides` are

```text
((in-range x y x))
((in-range x y z)
 (SUM x 1 x1)
 (LESS x1 y)
 (in-range x1 y z))

((divides x y)
 (TIMES x z y)
 (INT z))
```

This program is not a very efficient program for checking prime numbers, but it is an obviously correct one.

A `(FORALL <atom list1> <atom list2>)` condition is solved if, and only if, the pair of conditions

```text
(? <atom list1>) (NOT ? <atom list2>)
```

does not have a solution, in other words, if there is no way of solving `<atom list1>` so that `<atom list2>` cannot be solved. Hence, the supervisor definition of `FORALL` is

```text
((FORALL X Y) (NOT ? ((? X)(NOT ? Y))))
```

After the evaluation of a `FORALL` all variables in the `<atom list>` arguments of the condition are left unbound.

### 7.7.7 ISALL

```text
(ISALL t t1 <atom1> <atom2> ... <atomk>)    f > 0
    {t is the list of all the t1s such that the query ?(<atom1> ... <atomk>) is
     solved}
```

`ISALL` can only be used to instantiate variables in `t`.

Each element in the list `t` is a copy of the value the term `t1` is given by each different solution to the query. At the end of the evaluation all variables in `t1` and the `<atom>` conditions are left unbound.

The solutions found are neither unique nor sorted: if a different solution to the query results in the same value of `t1` then a second copy of this value appears on the list `t`. The values for `t1` appear on `t` in the reverse of the order in which the solutions to the query condition are found, so the first value of `t1` on `t` corresponds to the last solution of the query, and the last value of `t1` on `t` corresponds to the first solution of the query. `t` is usually given as a variable in the call and the evaluation binds the variable to the list of solutions. However, `t` can be a list or a list pattern. If it is a list, the elements on `t` must be in the order in which they would be found by an evaluation in which `t` was given as a variable - which is the reverse of the order in which solutions to the query are found. Since this order is not easy to predict, this checking role for `ISALL` is not very useful. Example uses of `ISALL` are

```text
(ISALL x y (father-of tom y)(male y))
    {makes x the list of all the sons of tom in the reverse of the order they
     are found}
(ISALL (x|y) (z1 z2) (gives bill z1 z2))
    {checks that bill gives at least one thing z1 to someone z2 and makes
     x the last (z1 z2) pair found, y the other solutions in reverse order}
(ISALL (x1 y1) y (mother-of mary y))
    {checks that mary has exactly two children, and finds their names in
     the list (x1 y1)}
(ISALL (bill) y (father-of tom y))
    {checks that bill is the only child of tom}
```

`ISALL` is not defined entirely as a micro-PROLOG program. The following definition approximates the built-in definition

```text
((ISALL X Y|Z)
 (init x ())                          {initialise value assertion for x to
                                      ()}
 (FORALL ((? Z)) ((update x Y)))      {for all the solutions to (? Z)
                                      update the value assertion for x
                                      with the value of Y}
 (DELCL ((value x X))))               {X is the final value of x}

((init x Y)
 (DELCL ((index x)))                  {find and delete index assertion to
                                      get}
 (SUM x 1 Z)                          {an index value for x}
 (ADDCL ((index Z)))                  {add new index assertion}
 (ADDCL ((value x Y))))               {add initial value of x assertion}

((update x Y)
 (DELCL ((value x Z)))                {find and delete old value
                                      assertion for x}
 (ADDCL ((value x (Y|Z)))))           {add new value assertion for x
                                      with added Y}

((index 1))                           {initial index assertion}
```

The use of the `index` assertions allows nested `ISALL`s.

The built-in definition of `ISALL` does not use the relatively slow additions and deletions to the database to keep track of the partial list of solutions to the query, it directly updates a list of partial solutions. Its evaluation is very fast; the time taken to find the list of solutions is only a little longer than the time taken to search for all the solutions to the query condition.

You can use `ISALL` to define a `count` relation that counts the number of different solutions to a query. The following definition, which uses a tail recursive `list-count`, will take little longer than the time to search together with the time to count to the number of found solutions



```text
((count X Y|Z)
 (ISALL X1 Y|Z)
 (list-count X1 0 X))

((list-count () y y))
((list-count (X|Y) y z)
 (SUM y 1 y1)
 (list-count Y y1 z))
```

### 7.7.8 !

```text
(! <relation name> t1 ... tk)
    {the first solution to (<relation name> t1 ... tk)}
```

The evaluation of the `!` call reduces to the evaluation of the atom that follows the `!` in the call. However, it restricts the evaluation to just one solution. On backtracking, no further ways of solving the condition are sought. The call

```text
(! likes x tom)
```

should be read `the first x who likes tom`.

`!` provides useful control information when you know that there will only be one way of solving the condition. It cuts out the redundant search on backtracking and should be used in preference to `/` where applicable. It is particularly useful for test calls that will be evaluated against a large number of assertions. In the MICRO `which` query

```text
which(x (parent-of tom x)(male x))
```

each found child of `tom` is checked for being male. The backtracking search results in alternative and redundant `proofs` of the `(male x)` condition being sought before another child of `tom` is found. In consequence, the entire set of `male` assertions will be scanned for each found child. By using

```text
which(x (parent-of tom x)(! male x))
```

the scan of the `male` assertions is abandoned as soon as the found `x` is confirmed as a male.

The supervisor definition of `!` is

```text
((!|X) X /)
```

It is the `/` that prevents the search for a second solution.

## 7.8 Database operations

micro-PROLOG has three primitives that enable clauses to be accessed, added and deleted from the user's workspace at run-time. The ability to add and delete clauses is needed in order to implement extensions to the supervisor. It also enables the database to be used as a scratchpad memory. An example of this latter use is the definition of `ISALL` given above. Being able to pick up the clauses for a relation allows the definition of alternative query evaluation strategies. An example of an alternative evaluator is given below.



### 7.8.1 CL

This has two forms of use, a single-argument form and a three-argument form:

```text
(CL X)      {X is a clause in the program}
(CL X Y Z)  {X is a clause at position Z in the sequence of
             clauses for its relation with Z >= Y}
```

At time of evaluation of either call, `X` must be a clause or a clause pattern in which at least the relation name of the head atom is given as a constant. For the three argument form `Y` must also be given as a positive integer; `Z` can be a variable or be given.

This program accesses clauses from the user's workspace (or the currently opened module). It is one of the few built-in programs that is at all non-deterministic as it can be used to backtrack through an entire relation. The important constraint on `CL` is that the relation name of the head atom of the clause to be found must be given. For example

```text
(CL ((At|x)|X))
```

succeeds if there are any `At` clauses in the workspace, so this form of use can test if a relation is defined before a call to the relation is made; a call to an undefined relation signals an error.

In the example call, if there are clauses for `At`, variable `x` is bound to the arguments of the head atom of the first clause, and the variable `X` is bound to the (possibly empty) list of atoms that make up the body of the clause. Backtracking will result in an alternative (later) clause being sought for the `At` relation.

For the most general use, the clause argument is a pattern of the form

```text
((<relation name>|Y)|Z)
```

The three-argument form of `CL` can be used to find particular clauses in the program; the second argument must be given. It gives the position of the clause from which the search begins. The last argument is the position of the found clause.

```text
(CL ((likes John|x)|y) 1 X)
```

binds `x` to the position of the clause that matches `((likes John|x)|y)` with the search starting at the first clause. Backtracking results in an alternative clause being sought that matches the clause pattern. If there is one, its (later) position will be given as the value of `X` and the rest of its structure will be given in the bindings for `x` and `y`.

We can also use the three argument form to pick up a specific clause. To do this, we use the most general pattern for a clause for the relation and give the clause position.

```text
(CL ((likes|x)|y) 4 4)
```

will bind `x` and `y` to the argument list and the body of the 4th clause for `likes`
- if it exists; if it does not, the call fails.

The single argument `CL` behaves almost as if a micro-PROLOG program is stored as a sequence of `CL` clauses with the actual program clauses as argument terms. The evaluation of a `CL` call is then a search through these `CL` clauses. This is almost true. The sequence of `CL` clauses is implicitly represented by the relation names in the dictionary which `point` to the sequence of clauses that define them.

However the restriction that the predicate symbol must be known at the time of the call means that `CL` can only be used to search through the clauses of a single relation; it cannot be used to search through all the clauses in the workspace.

`CL` can be used to define a query evaluator.

```text
((question ())           {a question with no conditions is true}
((question (X|Y))        {a non-empty question is true}
 (CL (X|Z))              {if there is a clause (X|Z) matching X}
 (question Z)            {whose body Z is true}
 (question Y))           {and the remaining conditions Y are true}
```

This makes use of `CL` to find a clause that solves `X` in such a way that the rest of the question can be solved. Failure to solve `Y` will first result in backtracking on the evaluation of the body `Z`, and finally on the search for an alternative matching clause. For questions and programs that do not use `/`, it is equivalent to the supervisor `?`.

By collecting all the matching clauses as a list, we can try the clauses in an order different from their order in the program. An alternative recursive clause for `question` is

```text
((question (X|Y))
 (ISALL z (X|Z1) (CL (X|Z1)))    {z are the clauses matching X}
 (select (X|Z) z)                {(X|Z) is a selected clause}
 (question Z)
 (question Y))
```

The definition of `select` determines the order in which clauses for the condition `X` are tried. As an example

```text
((select x z)
 (sort z z1)
 (member-of z z1))
```

can be used to select the clauses in order of increasing number of atoms in the body given suitable definitions of `sort` and `member-of`.

Elaborations of this approach enable one to program breadth-first evaluation of queries (as distinct from depth-first with backtracking).

### 7.8.2 ADDCL

This also has two uses:

```text
(ADDCL X)        {add X as a new last clause for its relation}
(ADDCL X <int>)  {add X as a clause after clause <int> for its
                  relation}
```

For both uses, at the time of evaluation `X` must be a list term that satisfies the syntax of a clause. In particular the relation name of the head atom must be given as a constant. For the second use, `<int>` must be a non-negative integer.

The clause added is a copy of the list term `X` in which any unbound variables of the term become variables in the added clause. This convention, that unbound variables in the `name` `X` denote variables in the clause to be added is logically not very satisfactory; however, all PROLOG implementations use this convention. It enables clauses to be read in using the `R` primitive and then added to the program using `ADDCL`.

`R` converts variable names in the read-in clause term into internal form unbound variables. `ADDCL` then copies the clause term, mapping the unbound variables into special variable names in the added clause. This `R`, `ADDCL` cycle is how the supervisor accepts new program clauses - see the definition of `<SUP>` below.

When a clause is picked up by the micro-PROLOG interpreter during an evaluation, or when it is retrieved using `CL`, the special variable names of the clause are converted back into entirely new internal form variables, just as though the clause had been read-in. So each use of the clause gets a fresh copy, with a new set of variables different from any other variables currently in the evaluation. This allocation of new internal form variables - which are actually locations where pointers to values for the variables will be stored when the variables are bound - for the variable names of an accessed clause is exactly the same as the allocation of new locations for the variables of a procedure that takes place in a conventional recursive programming language.

If `ADDCL` is used with a single argument then the clause is added to the end of the appropriate program. Otherwise it is inserted after the clause whose position is given as the second argument. If `0` is used as the clause number, the clause is inserted at the front of the program.

```text
(ADDCL ((append () x x)) 0)
```

adds the clause

```text
((append () x x))
```

to the front of the `append` program. If a position is given that is beyond the last clause for the relation, the clause is added as a new last clause.

**RESTRICTION:** clauses cannot be added for primitive relations nor for relations exported by some loaded module. An attempt to do so signals an error.

### 7.8.3 DELCL

```text
(DELCL X)                    {delete the first clause matching
                              X}
(DELCL <relation name> <int>) {delete the <int>th clause for
                              <relation name>}
```

`X` must satisfy the syntax of a clause. In particular, the relation name of the head atom must be given.

The primitive `DELCL` is used to delete clauses from the workspace (or currently opened module). In the first form, the program is searched for a clause matching `X`. The first one found is deleted. If none is found, the call fails. In the second form the clause to be deleted is specified by a relation name and a clause position. Again, if the specified clause does not exist, the call fails.

```text
(DELCL ((append | x1) | x2))
```

will cause the first clause for `append` (if there is one) to be deleted. However, it will also bind the variables `x1` and `x2` to the head arguments and body of the clause respectively. So this form of `DELCL` can retrieve information from the deleted clause. An example of this use is in the definition of `ISALL` given above. In particular, the definition of the auxiliary relation `update` uses `ADDCL` and `DELCL` to manipulate the database as a scratch pad memory.

**RESTRICTION:** clauses for primitive relations or relations exported from loaded modules cannot be deleted. An attempt to do so signals an error.

### 7.8.4 Undoing the effect of ADDCL or DELCL

The effect of an `ADDCL` or a `DELCL` is *not* undone on backtracking over the call. The adding or deleting of a clause is a side effect on the state of the program in the same way that `R` and `PP` are a side-effect on the state of the terminal. We can never undo the effect of an `R` or `PP`, but we can undo the effect of `ADDCL` or `DELCL` - by doing the opposite.

The following clauses define `soft` `addcl` and `delcl` relations whose effect is undone on backtracking. This is subject to the proviso that a `/` has not been evaluated after the call that cuts out their `else` branches.

```text
((addcl X)
 (OR ((ADDCL X)) ((DELCL X))))

((delcl X)
 (OR ((DELCL X)) ((ADDCL X))))
```

Both relations need the clause to be unambiguously specified - to be uniquely determined by the argument `X`. If it is not, the `DELCL` of the `addcl` definition may delete a different clause that happens to match `X`, and the `ADDCL` of the `delcl` definition may add a more general clause than the one deleted.

Notice that `delcl` may not add the clause back in the same position, so it is only useful when the position of the clause is not important. This is usually the case when you are manipulating a database of single atom clauses.

### 7.8.5 KILL

```text
(KILL R)               {delete all clauses for relation R}
(KILL (R1 ... Rk))    {delete all clauses for each of R1...Rk}
(KILL ALL)             {delete all clauses from workspace or all those
                        owned by the currently opened module}
(KILL <module name>)   {delete the named module}
```

`R` and `R1 ... Rk` must be relation names.

The `KILL` primitive deletes all clauses for a single relation, all those for a list of relations, or all those that can be deleted. When working in the workspace (the supervisor prompt is `&.`) only user relations in the workspace can be



KILLed. A `KILL ALL` will delete all the clauses from the workspace but will not delete any loaded module. This must be deleted with the last form of use `KILL <module name>`.

When working in an opened module (see below) `KILL` can be used to delete all clauses for relations that are owned by the module. The main use of `KILL` is as a supervisor command.

## 7.9 Library procedures

These allow programs to be saved, loaded, and listed.

### 7.9.1 LIST

```text
(LIST R)               {list program for relation R}
(LIST (R1 ... Rk))     {list program for each of R1 ... Rk}
(LIST ALL)             {list programs for all workspace relations or all
                        relations owned by currently opened module}
(LIST <module name>)   {list the named module}
```

`R` `R1` ... `Rk` must be relation names.

The `LIST` primitive lists the specified programs, in a standard format, at the console.

```text
(LIST ALL)
```

lists the whole program, (apart from any loaded modules), and

```text
(LIST (Likes Fred Angie))
```

lists the programs for `Likes`, `Fred` & `Angie`.

Modules are listed in the form in which they are `SAVE`d - see below.

### 7.9.2 LISTP

```text
(LISTP <file name>)               {list all the workspace programs to
                                   the named file}
(LISTP <filename> R)             {list program for R to the named
                                   file}
(LISTP <filename> <module-name>) {list named module to the named
                                   file}
(LISTP <filename> (R1 ... Rn))   {list the programs for the relations
                                   in the list to the named file}
```

`LISTP` is a generalisation of `LIST` in which programs can be written out in usual display format but to a named file rather than to the console. In fact `LIST` is defined in terms of `LISTP`:

```text
((LIST ALL)
 / (LISTP "CON:"))
((LIST X)
 (LISTP "CON:" X))
```

The file must have been explicitly `OPEN`ed before `LISTP` is used, and `CLOSE`d afterwards.

### 7.9.3 SAVE

```text
(SAVE <file name>)                  {save entire program in named
                                     file}
(SAVE <file name> (R1 ... Rk))      {save only programs for given
                                     relations}
(SAVE <file name> <module name>)    {save named module in named
                                     file}
```

See Appendix E on pragmatics of file handling on the Spectrum.

For the first form of use the entire program saved will be the workspace program if working in the workspace. If working in an opened module it will be all the clauses owned by the module.

The supervisor command

```text
SAVE PROGRAM1
```

saves the entire program on the tape file `PROGRAM1`.

Programs are saved as a sequence of clauses in the same format in which they are displayed by `LIST`. Modules are saved in a special format - see the next section on modules. It is also the format in which modules are displayed by `LIST`. The clauses are written out as a sequence of characters. `SAVE` uses the `WRITE` primitive to write out the clauses. See Appendix E for the pragmatics of different file storage media.

The other two forms cannot be used directly as supervisor commands as they have two arguments. For a command to save a module, you must use a query of the form

```text
?((SAVE <file name> <module name>))
```

`SAVE` does not delete the saved program(s). Moreover, it automatically opens the file for writing, and then closes it on successful completion.

**WARNING:** File names, relation names and module names must be distinct. If you inadvertently use a name for more than one of these roles you will get an error. If you attempt to save a program on a file, the file name you use must not be the same as any current relation name or any loaded module.

The error can occur when you are loading a file with the `LOAD` command described below and the `LOAD` reaches a clause for a relation that has the name of a loaded module or has the same name as the file from which you are loading the program. On the error the `LOAD` will be abandoned with the file left open. So you should `CLOSE` the file from which you were `LOAD`ing if this occurs. If you are using an error handler (see Appendix C) the offending relation name will appear in the `ADDCL` call that caused the error.

To avoid this type of error, use different forms of name for relations, modules and files. Most of the micro-PROLOG distribution modules have a name of the form `<name>-mod`, where `<NAME>` is the file in which they are supplied. If you always use a postfix `-mod` for module names, you should avoid the error.



### 7.9.4 LOAD

```text
(LOAD <file name>)    {load the program from named file}
```

This program reads the named file and adds all the clauses in the file to the workspace or the currently opened module.

If the file contains a saved module, the clauses are loaded as a module and do not enter the workspace. Note: a module can only be loaded when working in the workspace (the supervisor prompt is `&.`); you cannot load a module when working in an opened module. The attempt to do so signals an error. You can only load into an opened module files consisting entirely of program clauses.

As each clause on the file is read in, it is added to the end of the current program for its relation. If there are clauses for the relation before the load, all the loaded clauses will be added after the existing clauses. The `LOAD` does not overwrite the current workspace program or any currently loaded module in the way that the BASIC `LOAD` does. If you really want to start with a fresh workspace program read in from the file you must do a `KILL ALL` before the `LOAD`. You can get rid of the entire workspace and all current modules using the `NEW` primitive described in the next section.

`LOAD` automatically opens the file and then closes it on successful completion of the `LOAD`. But see the warning given at the end of section 7.9.3 regarding a file with containing clauses for a relation that conflict with the file name or some module name. If you get this error, or any other error, during the `LOAD` the file will be left open and should be explicitly closed using a `CLOSE` command. Another possible error on loading a program file concerns the names of exported relations of current modules. If the program you are loading into the workspace contains a clause for a relation that is defined and exported by a current module you will get the `Illegal use of modules` error.

In general, you should get rid of programs and modules when you have finished with them by using `KILL` - obviously after first saving them to a file if you wish to keep a copy. You can always re-load them when they are needed again. `KILL`ing programs frees memory space for the evaluation of queries and for other programs.

## 7.10 Module construction facilities

micro-PROLOG has facilities for constructing modules. These are named micro-PROLOG programs (sequences of clauses) which communicate with workspace programs and other modules via import/export name lists. Names used in the module that are not in the import/export lists are local to the module and are invisible from outside it. Different modules can therefore use the same local names with no name clash. On the other hand, constants that do need to be communicated across the module must be in the import or export list.



A module has five components:

*a name* (which is a micro-PROLOG constant)

*an export list*: a list of constants which are being "made available" outside the module. These are usually the names of relations of the module. An exported relation can be used in a workspace program or command as though it were a primitive relation when the module is loaded. An exported relation name can also be imported by another module and used by the other module as though it were a primitive.

*an import list*: a list of constants that the module imports from the outside. This must include the names of relations defined in the workspace or exported from some other module that need to be accessed from inside the module. It must also include all the "data" constants used in the module that need to be communicated across the module, eg constants which may be used in calls to exported relations of the module and must be recognised by the module or constants used in the module to calls to imported relations which will need to be recognised outside the module. Such communicated "data" constants can be given in either the import or export list, but it is good practice to restrict the export list to exported relation names.

*a local dictionary*: constants appearing in the module which are private to that module.

*the module program*: all the clauses owned by the module. These are the programs for all the relation names of the export list and the local dictionary.

The export list, the import list, and the local dictionary have no names in common. The relations accessible by a module are the relations defined by the clauses it owns and the relations with names in the import list.

Modules are `LOAD`ed and `SAVE`d automatically by the `LOAD` and `SAVE` programs. For the `LOAD` the same form of call is used, `(LOAD <file name>),` even if the file contains a module. This is possible because files containing modules have a different structure to ordinary program files and this is recognised by the `LOAD` which then handles the file in a special way. For the `SAVE` there is a special three argument form for modules

```text
(SAVE <file name> <module name>)
```

This saves the named module on the specified file in the form

```text
<module name>
<export list>
<import list>
: {clauses owned by the module}
CLMOD
```



The local dictionary is not saved because this is automatically reconstructed by the `LOAD`.

Warning: if you use a text editor to develop a module program file the terminating `CLMOD` must be followed by a `<return>`.

The `LIST` program can also be used to list the contents of a module

```text
(LIST <module name>)
```

will display the module on the screen in the form that it is saved on a file.

You can enter and exit loaded modules with the `OPMOD` and `CLMOD` commands described below. Entering a module makes it the *current module*.

The supervisor uses the current module's name as its prompt, so if the current module is called `query-mod` then instead of the `&.` prompt we get the prompt:

```text
query-mod.
```

The top-level prompt `&.` is in fact the name of the root module `&` which is also the workspace. The root module has a special role. On loading micro-PROLOG the root module becomes the current module. It exports no names but it imports all the names exported by the loaded modules. As a module is loaded, the import list of `&` grows. Finally, other modules can only be loaded when `&` is the current module.

A supervisor `LIST ALL` will list all the clauses owned by the current module, and all clauses entered at the keyboard or added using `ADDCL` are added to the current module. An attempt to add or delete a clause for an imported name of the current module signals an error.

It is possible to have a program in a module which when called adds clauses to an imported relation of the module but the program cannot be called while the module is the current module. For example, the SIMPLE front end program imports the relation name `dict`. It maintains this relation for the user by adding and deleting clauses from it. It can do this because when the `dict` clauses are added and deleted the root module `&` is the current module and `dict` is not an imported relation of the workspace - it is a relation owned by the workspace.

The local dictionary of the current module is the dictionary used by all the I/O primitives of micro-PROLOG. When a constant is read-in, it is looked up in the local dictionary of the current module. If it is not present, it is added to the local dictionary. This means that any module program that is to be called from a workspace query, which reads in and tests for certain constants in the input, must import all the constant names it needs to recognise. For, when they are read-in, `&` will be the current module and the constants will enter the local dictionary of the workspace. The program in the module will not be able to recognise them unless it imports their names.

There are four primitives connected with modules: `CMOD`, `CRMOD`, `OPMOD` and `CLMOD`.



### 7.10.1 CMOD

```text
(CMOD x)    {x is the name of current module}
```

`x` must be a variable at call. The `CMOD` program simply returns the name of the current module. It is used, for example, by the supervisor to print out the name of the module as part of its top-level prompt.

### 7.10.2 CRMOD

```text
(CRMOD <module name> <export list> <import list>)
    {create an empty module and make it the current module}
```

`CRMOD` creates a new module with name `<module name>` and with the given export and import constant lists. It then enters it, ie, makes it the current module. The `<export list>` and the `<import list>` are as defined above.

`CRMOD` can only be used when `&` is the current module. The `<module name>` cannot be the same as the name of any relation accessible by `&`. It must also be different from the name of any other current module and any opened file. Finally, none of the exported names can be the names of workspace relations or relations exported by other current modules. If any of these constraints is flouted the `Illegal use of modules` error is raised.

Having created a module you can enter clauses into it using all the facilities of the resident supervisor described in Chapter 3. But note that you will not be able to `LOAD` and use the structure editor (of Chapter 4) or any of the other program development utilities while in the new module. The only way you can use the editor to help develop or modify a program inside a created module is to import the name `EDIT` and all the names of the edit commands into the module. The editor must be loaded whilst at the root module (`&`) level, but it can be called from inside the new module.

A more convenient method of developing a program that is to be wrapped up in a module is to develop it first as a workspace program which is saved in the normal way. You then use `CRMOD` to create the shell for the new module. On entry, `LOAD` the saved workspace program, then exit the module with the `CLMOD` described below. You can now `SAVE` the new module using the special form for modules. Alternatively, use the `MODULES` utility described in Chapter 4 which supports the construction and modification of modules.

`CRMOD` is used by the `LOAD` primitive when it encounters a module name in the file. It creates a module using the name and the export and import lists that immediately follow the name. It then reads in all the clauses that follow up to the end of module mark `CLMOD` in the file. Each clause is added to the newly created module, which temporarily becomes the current module. On reaching the `CLMOD` the module is exited and the current module is again the `&` workspace module. If there is an error on loading, or you interrupt the load with a break (`SYMBOL SHIFT` and `SPACE`) you will find that you are in the temporarily entered module. You should do a `KILL ALL` to clear out the partially loaded module and then a `CLMOD.` before attempting to continue.



### 7.10.3 OPMOD

```text
(OPMOD <module name>)    {make named module the
                          current module}
```

`OPMOD` enters the already existing named module and makes it the new current module.

### 7.10.4 CLMOD

```text
CLMOD    {close current non-root module and return to
          &}
```

`CLMOD` drops out of the current module back into the root `&` module. It is not possible to drop out of the root module. As a supervisor command `CLMOD` must be given an (ignored) argument, for example

```text
CLMOD.
```

with `.` as the ignored argument.

## 7.11 Miscellaneous predicates

In this section we draw together a rag-bag of primitives not covered above. These include the dictionary relation and some control primitives.

### 7.11.1 NEW

```text
(NEW)    {initialise micro-PROLOG}
```

This primitive re-initialises micro-PROLOG, emptying the dictionary and clearing the workspace of all programs and modules.

As a supervisor command it must be given an ignored argument, eg

```text
NEW m
```

### 7.11.2 QT

```text
QT    {quit micro-PROLOG and return to BASIC}
```

This predicate is not present in all versions of micro-PROLOG. If it is available, executing this program will cause an exit from the micro-PROLOG system into BASIC. Alternatively, the power may be switched off and then on again (taking care that no cartridges are in the Microdrives if you have them). As a command it must be given an (ignored) argument, eg

```text
QT m
```

### 7.11.3 /

```text
/    {always true but with a side effect on evaluation}
```

The `/` is a very low level primitive which provides control of backtracking. Its main use is to implement some of the logical primitives of micro-PROLOG such as `!`, `IF`, `OR` and `NOT` (see section 7.7). These should always be used in preference to `/` where possible, since `/` can make a program behave rather unexpectedly or obscure its meaning.

When executed as a call in the body of an invoked clause, its effect is to cut out all the as-yet-untried clauses for the call which invokes the clause, and all the alternative untried evaluation paths for the calls that precede the `/` in the clause.



Suppose that a clause of the form

```text
((R ...) (R1 ...) (R2 ...) / (R3 ...))
```

is invoked by some `R`-atom call. The calls `(R1 ...)` and `(R2 ...)` are evaluated in the normal way with any necessary backtracking in order to find a solution to both calls. If they can both be solved, the `/` is executed. Slash always "succeeds"; it is used for its side effect.

It suppresses all further backtracking on the evaluation of the `(R1 ...)` and `(R2 ...)` calls that would normally occur on a subsequent failure or when trying to find all the solutions to a condition. It also prevents any later as-yet-untried clauses for `R` from being used to solve the particular `R`-atom call that invoked the clause.

In other words, if the `(R3 ...)` call should now fail, then the call that invoked the clause now immediately fails. If the slash had not been there, a failure of `(R3 ...)` would have resulted in alternative ways of solving the `(R1 ...)` and `(R2 ...)` calls being explored, and then in alternative clauses for `R` being tried. The `/` cuts out all these alternatives.

### 7.11.4 FAIL

```text
FAIL    {false}
```

The `FAIL` predicate always evaluates to false. This is used to unconditionally fail a branch of the proof; `FAIL` has no clauses, but the interpreter knows about it and does not signal a `No clauses for` error. It is used in the implementation of the `NOT` predicate.

### 7.11.5 ABORT

```text
ABORT    {abort the current supervisor command}
```

The `ABORT` primitive cancels the current supervisor command that is being executed and returns to the supervisor. It is used in the error handlers.

### 7.11.6 /*

```text
(/* t1 t2 ... tk)    {t1 ... tk is true}
```

The `/*` is the comment predicate. It ignores its sequence of any number of argument terms (including none) and always succeeds with no side-effect. `/*` can be used within clauses to provide comments or as a "no-op" relation.

Its definition is equivalent to the program

```text
((/* |X))
```

### 7.11.7 SPACE

```text
(SPACE x)    {x is the number of Kbytes left in workspace}
```

The `SPACE` primitive returns in its single argument the number of Kilobytes (1024 bytes) of space that are currently left in the workspace.

Before actually returning this number it calls the internal garbage collector, which has the effect of making sure that all the known garbage is removed.



### 7.11.8 <SUP>

```text
<SUP>    {the ever-running supervisor program}
```

The supervisor control program can be listed as the program for the predicate symbol `<SUP>`. It is a very simple program with just a few clauses. Its main function is to add clauses that are entered and to call other programs invoked by commands.

```text
(("SUP")
    (CMOD Y)        {find the current module name}
    (P Y)           {print module name as prompt}
    (R X)           {read in next term}
    ("~" X)/        {process term deterministically (the /)}
    ("SUP"))        {tail recurse - loop back to handle next
                    command}

(("~" X)
    (CON X)         {read-in term is a constant ie a unary relation/
                    command name}
    (R Y)           {read in its single argument}
    (X Y))          {execute command by calling the relation}

(("~" (X|Y))       {read-in term is a micro-PROLOG clause}
    (ADDCL (X|Y)))  {add it to the program}

(("~" X)           {command fails, or illegal input}
    (PP ?))         {display ?}
```

The `<SUP>` primitive is invoked as soon as the micro-PROLOG interpreter and the supervisor have been loaded. Its evaluation terminates only on a fatal error or a `QT`.

### 7.11.9 DICT

```text
(DICT x y z|X)    {y z and X are respectively, the export list, the
                  import list, and the local dictionary of the
                  current module x}
```

The `DICT` relation defines the dictionary of the current module. If you do a `LIST DICT` you will get a clause of the above form listed. You can also call `DICT` to pick up any of its arguments. Note that `DICT` is a multi-argument relation. After the import list `z` is a sequence `X` of all the local constants of the current module. Garbage collection will remove from `X` all constants no longer in use.

### 7.11.10 RND

```text
(RND)      {Initialise the random number seed to the
           'frames' count}
(RND n)    {Initialise the seed to the given integer n}
(RND x n)  {x is a random integer in the range 0 <= x < n
           where n must be given}
```



### 7.11.11 PIO

```text
(PIO m n)    {Send value n to port m}
(PIO m x)    {x is the current value on given port m}
```



# APPENDIX A
## micro-PROLOG distribution system

The Spectrum micro-PROLOG distribution system comprises the following 15 files:

```text
PROLOG

TRACE      SPYTRACE
EDITOR     MODULES

SIMPLE     DEFTRAP
EXPTRAN    TOLD
SIMTRACE   PROGRAM
SIMSHOW

MICRO      ERRTRAP
MICSHOW
```

It is currently supplied on a cassette and some files are provided on both sides of the tape for convenience.

The `PROLOG` file contains the `PROLOG` interpreter with the built-in micro-PROLOG supervisor program. All the other files contain micro- PROLOG programs wrapped up as modules. They provide optionally loaded extensions to the built-in supervisor.

The facilities of the first four are described in Chapter 4, the next seven are described in Chapter 5, and the last three are described in Chapter 6.

To enter the micro-PROLOG cassette tape system:

1. Set up your ZX Spectrum as described in the ZX Spectrum *Introduction*.
2. Put the micro-PROLOG distribution tape in the cassette recorder for
   reading from the beginning of side A.
3. Enter the BASIC command `LOAD "PROLOG"` or `LOAD ""`; `ENTER`.
4. Start the recorder to send information to the Spectrum by pressing the
   `PLAY` key.

When the micro-PROLOG interpreter has finished loading, stop the tape. A message such as the following will appear on your screen.

```text
Spectrum micro-PROLOG ...
(C) 1983 LPA Ltd.
... Bytes free
&.
```

The first two lines are the Spectrum micro-PROLOG banner. The message `...BYTES FREE` indicates how much memory is available for storing and executing your micro-PROLOG programs. This memory will be used for the dictionary - where all your program constants are stored; for the heap - where your programs and their execution-time data are stored; and for the stack - which is used to record the state of the execution of a program.

Approximately 19% of the available memory is dedicated to the dictionary. The rest is allocated to the evaluation area where programs are kept and the queries are evaluated. The micro-PROLOG primitive `SPACE` tells you the free space in the evaluation area only.

The last line of the banner starts with an `&.`. This is the system level prompt which is output by the micro-PROLOG supervisor. It indicates that the supervisor is waiting for input from the console keyboard.



# APPENDIX B
## Keyboard control and line editor

When reading from the keyboard micro-PROLOG prompts the user for input with a `.` prompt and displays a flashing `L` cursor. The top-level `&.` prompt that micro-PROLOG gives you on entry is made up of `&` the workspace name and `.` the read prompt.

As characters are typed the cursor moves to the right and the typed characters are stored in a special *keyboard buffer*. They are only "read" by micro-PROLOG after you have pressed `ENTER`. Until you press `ENTER`, you can edit the sequence of characters that you have typed using the `DELETE` and cursor control keys. Just position the cursor within the current line of text using the cursor controls and then either delete characters to the left of the cursor (by pressing the `DELETE` key), or insert characters to the left of the cursor by typing the characters. If you try to move the cursor outside the current line of typed text the beep will sound and the cursor will not move.

The keyboard buffer holds up to 250 characters, so a "line" of up to 250 characters can be edited in this way. Of course, all these characters will not appear on the same screen display line, which has only 32 characters. When the characters reach the end of a line, the displayed text will automatically move to a new line without your having to press `ENTER`. You can press `ENTER` if you like, but you will not then be able to edit the characters you have just typed.

The cursor control will only move back over the display lines that have been automatically generated by the Spectrum display program. It will not move back over a new display line produced if you press `ENTER`. So, do not press the `ENTER` key until you are confident that you do not want to edit the sequence of characters you have typed in response to the read prompt. Pressing `ENTER` makes that sequence an *entered line*.

Warning: the transition from one display line to another is carried out automatically by the Spectrum display control program. micro-PROLOG has no knowledge of the fact that there has been a transition to a new display line since the `<ENTER>` character does not appear in the keyboard buffer. This means that the automatic transition to a new display line is not a token boundary (see section 2.10) in the way that `SPACE` and `<ENTER>` are. If the token that finishes at the right end of one display line needs to be separated from the one that starts the next line you need to type a space in front of the token on the second line.

Any number of terms can be typed on a line, and a list term can be spread over many lines. Any excess terms (terms are read one at a time) are saved in the buffer until the next console read is executed, in which case the next term in the buffer is read and no prompt is displayed. However, excess terms in the input buffer are discarded if there is a reported error (other than Syntax error) before they are read. Errors cause the keyboard buffer to be flushed.



### Cursor letters

Immediately after displaying the read prompt `.` micro-PROLOG always displays a flashing `L` indicating that it is expecting a normal keyboard character. As in BASIC, if you do a `CAPS LOCK` the cursor will change to a flashing `C`. If you do a `GRAPHICS` shift it will change to a flashing `G`. Finally, if you type the `CAPS SHIFT` and `SYMBOL SHIFT` key combination in order to go into the extended mode of the keyboard, the cursor will change to a flashing `E`. This will be for the next character only; after that it will revert to a flashing `L`.

### Type ahead

Even before an input prompt is displayed, ie before an input request is given, you can enter up to 16 characters by typing ahead. The characters will not be echoed on the TV screen until the input request is given. If you type more than 16 characters ahead, the beep will sound.

### Multi-line terms and right parenthesis prompts

Constants, variable names and numbers cannot be split across entered lines because the `<ENTER>` character is a separator. List terms can be split over more than one entered line.

If you press `ENTER` before the list term is complete you will get a prompt of the form `n.`, where `n` is the number of right brackets needed to complete the list. For example, we might have entered the `App` clause

```text
((App () x x))
```

over four entered lines

```text
&(( <enter>
2.App( <enter>
3.x <enter>
2.)) <enter>
&.
   (cursor position)
```

The `2.`, `3.` and `2.` on the second, third and fourth lines respectively are the bracket count components of the read prompts.

You will find the bracket count prompt very useful when you enter lists and, in particular, clauses. If you are unsure about the number of closing right brackets you need, but you are sure that you do not want to do any editing of the current line, press `ENTER`. The prompt will tell you how many right brackets you need to finish off the list.



# APPENDIX C
## Error messages and error handling

micro-PROLOG has relatively few error conditions, and most of them can be trapped by a micro-PROLOG program. The errors are divided into two groups - the numbered errors and the message errors. All the numbered errors can be trapped. When a numbered error occurs, if there are clauses for the relation `"?ERROR?"`, the program for the relation is called with a call of the form:

```text
("?ERROR?" <error number> <error call>)
```

This call replaces the error call passed as the second argument, that is the call that was being evaluated when the error occurred. Thus, if the call to the `"?ERROR?"` program succeeds, possibly binding variables in its error call second argument, the error call is assumed to have succeeded and the evaluation continues with the next call. If the call to the `"?ERROR?"` program fails, the error call is assumed to have failed. The call to the error handler may also result in an `ABORT` to the supervisor.

If there are no clauses for the `"?ERROR?"` relation, the message

```text
Error: n
```

where `n` is the error number, is displayed. The current evaluation is then aborted and you are returned to the supervisor.

Note that when the SIMPLE front end is loaded, these error messages comprise both number and explanation. If SIMPLE is not loaded, only error numbers appear.

### The numbered errors

The errors, and their numbers, are:

`0` Arithmetic overflow. If a call to an arithmetic primitive results in a number which cannot be represented then an arithmetic overflow is signalled. This includes the case of division by zero.

`1` Arithmetic underflow. This error arises when a number becomes too small to represent (the exponent becomes too negative).

`2` Clause error. There are no clauses defined for the call being executed. Some PROLOG systems merely fail the call if there are no clauses for its relation. In micro-PROLOG you can simulate that behaviour by having a special clause in the `"?ERROR?"` program to `FAIL` the `"?ERROR?"` call for error number 2.

`3` Control error. The built-in primitives in micro-PROLOG often require a minimum number of arguments to be given at the time of the call. This error occurs if the arguments to a call to such a primitive are underspecified. The error is also signalled if the evaluation has reached the use of a meta-variable (see Chapter 2) and the meta-variable is unbound or has a value of the wrong form. There is a strong possibility that the calls in some clause or query are incorrectly ordered, and that the call that would bind the unbound variable has not yet been evaluated.

`4` `ADDCL` error. This error is signalled when you try to add a clause for a relation name which is a primitive of micro-PROLOG, or is imported to the current module, or is the name of a currently opened file.

`5` File error. This error is signalled when an error arises during a file operation. For example, if you try to open a file using a file name which is also the name of a program relation you will get this error, as you will if you try to open a file for writing that is already open.

`6` Too many files error. Spectrum micro-PROLOG allows only one file to be opened at any one time. If you try to open more than one file you will get this error message. The message often appears because a program file is left open after another kind of error has occurred during a `LOAD`. The solution is to close the program file.

`7` Out of text area error. You will get this error if you try to position the cursor using control characters in a quoted constant argument to the `P` primitive and the position is outside the text area. If you are in hybrid mode, this means outside the bottom four lines of text.

`11` Break! This error is signalled when the user presses `BREAK` at the console except during an input or output operation which is signalled as error 5 or 15.

`12` Module error. This error is signalled whenever there is an illegal use of modules. It occurs when you try to `CRMOD` or `LOAD` a module other than at the root module level, or if the new module has a relation name in its export list and the relation is already defined by some program.

`13` Out of graphics area error. Similar to error 7, this occurs if you try to use the graphics primitives to draw a line or point outside the graphics area.

`15` Break! during I/O error. The `BREAK` key has been pressed during some read or write operation.

`22` Illegal colour error. Occurs if you use a primitive that specifies a colour with a colour code outside the range 0 to 7.

The following program is an example of a simple error handler which just reports the error with a short message and then aborts to the top-level supervisor

```text
(("?ERROR?" X Y)
  (P-code X Z)/
  (P Z Y)(PP)
  ABORT)
((P-code 0 "Arithmetic overflow"))
((P-code 1 "Arithmetic underflow"))
((P-code 2 "No clauses for"))
((P-code 3 "Control error"))
((P-code 4 "Error in adding clause"))
((P-code 5 "File error"))
((P-code 6 "Too many files opened at once"))
((P-code 7 "Cursor outside text area"))

((P-code 11 "Break!"))
((P-code 12 "Illegal use of modules"))
((P-code 13 "Line or point off screen"))
((P-code 15 "Break! during I/O"))
((P-code 22 "Illegal colour"))
((P-code X (Error X)))
```

A simple alteration will allow the error 2 to be treated as a failure. All that is needed is to add the following clause to the `"?ERROR?"` program:

```text
(("?ERROR?" 2 x)
  / FAIL)
```

This must be placed before the main `"?ERROR?"` clause. The `/` followed by the `FAIL` causes the error call given as the `x` argument to fail.

A further refinement is to treat error 2 as a failure to solve the condition only if the relation is declared a `data-rel` relation by some clause

```text
((data-rel R))
```

in the program. The extra clause for `"?ERROR?"` is then

```text
(("?ERROR?" 2 (X|Y))
  (CL ((data-rel X)))
  / FAIL)
```

The error handlers `errmess-mod`, `deftrap-mod` and `errtrap-mod` all treat error 2 in this way. The use of `CL` prevents another error 2 arising should there be no `data-rel` clauses. `CL` is described in Chapter 9 of the *micro-PROLOG Primer* or Chapter 7 of this *Manual*.

### Message errors

There are some errors from which it is not possible to recover. When such errors occur, a message is displayed and there is a default effect that cannot be changed. The error messages and the effects are:

**Dict error** There is no space left in the dictionary for new constants. The evaluation is `ABORT`ed and you are returned to the supervisor.

**Out of space** Garbage collection is not able to free enough space for the current evaluation to continue. You are `ABORT`ed to the supervisor.

**File not found** There has been an attempt to `OPEN` a file not on the currently logged Microdrive. (If you are using a cassette, see Appendix E.) The `OPEN` call is failed but the evaluation continues.

**Syntax error** Occurs when a term is being read in. It is displayed if there are too many right brackets or there is more than one term following a `|`. In either case the read continues with the extra brackets or terms ignored.

**System abort** This arises when micro-PROLOG detects an inconsistency within the system. It means that a vital internal data structure has been destroyed and micro-PROLOG cannot proceed. You are aborted out of micro-PROLOG to BASIC.



In practice, you should never get a system abort, though there are situations where the programmer can cause one. The simplest case arises in trying to execute the following program

```text
((abort-micro (x))
  (abort-micro x))
```

This causes overflow in the garbage collector and there is no reliable way of recovering from it.

Another situation which can cause a system abort lies in certain uses of `DELCL`. If you delete a clause that is still in use you are likely to get a system abort if there is a garbage collection before the use of the clause is completed.



# APPENDIX D
## Pragmatic considerations for programmers

The principal limiting resource in micro-PROLOG is space; micro-PROLOG therefore incorporates a number of space saving features. To maximise their effect you should be aware of them; this Appendix describes some of them and how they operate. Note that space saving does not affect the logic of the running program - only whether a program can run in the space available.

The features of micro-PROLOG which affect the space used by a program are:

### 1. Organisation

The evaluation area in micro-PROLOG is organised as a stack and a heap. The stack contains the activation records and the locations for the variables of the evaluation. The stack grows with recursion and normally pops only on backtracking. It records the state of the evaluation of the current supervisor command. The heap contains the values of variables. It also contains the program clauses and other permanent data objects.

Periodically the stack and heap grow too close to each other, at which time the heap is garbage collected. The point at which this is done is automatically computed by the system depending on the available memory and the relative sizes of the stack and heap.

The garbage collector operates on the "mark and collect" system, which means that all space currently being used is "marked", then unmarked space in the heap is collected together into a list. The heap is also "cut down" if there is free space at the end of it. The usual effect is that a clear region of memory is left between the stack and heap, allowing execution to continue. However, if the garbage collector fails to find sufficient space the evaluation aborts with the message `No space left`.

Note that the allocation algorithm means that as memory gets tight the garbage collector is called more and more often; this can have a dramatic effect on the performance of the system. Normally, garbage collection takes about a quarter of a second and is not a big overhead.

### 2. Success popping

micro-PROLOG performs special actions when a procedure call has been deterministic, ie when it has been solved using the last clause for its relation and the evaluation of each of the calls in the body of the clause has been deterministic. When such a deterministic call is solved, the activation record for the clause that solved the call is popped off the stack (it will always be at the top of the stack) in exactly the same way that the record of a procedure invocation is popped in a conventional recursive programming language. The activation record can be discarded because it will not be needed to determine what next clause to try in order to solve the call should there be backtracking to the call.

The alternative situation, where either the evaluation of one of the calls in the body of the clause was not deterministic or it is not the last clause, means that the activation record must be left on the stack.



The expert programmer can give control information that allows a success popping even when the evaluation of the call appears to have been non-deterministic, that is, when there are still untried clauses for the call or untried clauses for one or more calls solved during the evaluation of the call. He can do this by inserting the `!`, only one solution required, primitive immediately before the call or the `/` backtracking control primitive in the body of the clause (see Chapter 7).

If a `/` is evaluated in the body of an invoked clause it has the effect of popping from the stack any activation records left there by the evaluation of the calls that precede the `/` in the clause, so the evaluation of these calls is now deemed to have been deterministic. It also makes micro-PROLOG treat the clause as though it were the last clause for the call that invoked the clause. In consequence, a `/` at the end of a clause always results in a success popping of the stack if the use of the clause solves some call.

### 3. Tail recursion

Tail recursion is the name given to that form of recursion which is actually equivalent to a loop. micro-PROLOG can detect this special case of recursion, and when a tail recursive call is also deterministic micro-PROLOG does not grow the stack when entering the call.

A classic example of the power of tail recursion in saving space is during a list append. If we write the append program as

```text
((append () x x))
((append (x|X) Y (x|Z))
  (append X Y Z))
```

then for all the deterministic uses of the program the stack does not grow during the evaluation for any length of input list. The recursive definition of append is executed as though it were written as a `WHILE` loop.

The general conditions for a tail recursion optimisation are as follows. Consider a clause of the form

```text
((R t1..tk) (A1)..(An))
```

in which `(A1) ... (An)` are atoms in the body of the clause. Suppose that it is invoked by some call `(R t'1...t'k)`. If the evaluation of the calls `(A1)...(An-1)` is deterministic, success popping of their evaluation traces will leave the activation record corresponding to the use of the clause at the top of the stack.

Further suppose that there are no other clauses to try for the call `(R...)` that invoked the clause, in other words, the above is either the last clause for `R` or a `/` was executed in the body of the clause. In this situation, the activation record for the clause is not needed for backtracking on the call. If the last but one atom in the clause is `/` these first two conditions will be satisfied because of the effect of its evaluation.

Finally, let us suppose that `(An)` is now matched with the last clause for its relation, so the activation record of this new clause does not need to be left on the stack for possible backtracking on `(An)`. In this circumstance, the activation record is thrown away and replaced by the activation record of the clause invoked by the last call `(An)`.

Note that `(An)` need not be a call of the relation `R`, so the tail recursion optimisation of micro-PROLOG is a generalisation of the tail recursion that corresponds to iteration.

### 4. Non-structure sharing

micro-PROLOG is a so-called "non-structure sharing" implementation. Briefly this means that when a variable is bound during a unification its value is explicitly computed and placed, if necessary, in the heap.

The effect of this, together with garbage collection, success popping and tail recursion, is to limit the amount of data currently in the stack and heap to that which is actually needed, though it does lead to an overall increase in memory turn-over. It also has a space benefit in that for certain simple, but common, cases the value a variable takes occupies less space than in the more normal "structure-sharing" implementations of PROLOG.

To take full advantage of the success popping and tail recursion space saving optimisations, the programmer should try to ensure that micro- PROLOG can always detect determinism in a program. This means, for example, putting the base case of a program (such as that for append) before the general case, and using the `IF` condition and `!` or `/` where they are applicable (see Chapter 7). Programs optimised for space in this way tend to be less optimal with respect to speed of execution, and vice versa.

# APPENDIX E
## Pragmatics of file handling in Spectrum micro-PROLOG

Storing micro-PROLOG files on cassette tapes needs rather more care than storing them on disks or microdrives. In general when using development systems such as MICRO or SIMPLE or utilities such as MODULES, you will be prompted when to start or stop the tape recorder. However the main built-in supervisor commands which operate on files assume that the tape has been positioned and the recorder set up before a file operation is performed.

### 1. LOAD

Before you use this command, position the tape at the start of the file from which you want to read. You should start the tape sending to the computer (PLAY) after you have pressed ENTER for the LOAD command.

Files are stored on the tape as a sequence of named and numbered blocks of characters. When you are loading a file, micro-PROLOG will tell you which block it is currently looking for on the tape. At the beginning of the LOAD of a file PROGRAM it will tell you that it is looking for block 1 of PROGRAM by displaying a message PROGRAM 01 at the left of the screen. If you have not positioned the tape correctly at the beginning of the file it will just keep reading and ignoring blocks of other files until it finds the block for which it is searching. It will tell you about each block it finds, say block 4 of another file FILE1, by displaying FILE1 04 at the right of the display as it reads it. This will continue until it reads the block it is looking for, when it will display BLOCK OK on the right of the screen. After a short pause it will then increment the expected block number in the message at the left of the screen. So, when it has read block 1 of PROGRAM, it will tell you that it is now looking for block 2 of PROGRAM by changing the message at the bottom left of the screen to PROGRAM 02. To speed up the search, you can stop the tape, do a fast wind to where you think the file is, and start the tape again. It is a good idea to go through the distribution tape when you receive it noting down the counter reading on your tape recorder for each micro-PROLOG file so that you can find them again easily. Remember to KILL each module before LOADing the next as some cannot coexist - see the relevant descriptions.

Because micro-PROLOG is doing some processing as each block of characters is read in, it may very occasionally miss the next block of the file it is loading if the workspace is nearly full. In this case, micro-PROLOG will tell you that it has missed the block by leaving the block count unchanged in the left hand message and by displaying a right hand message which gives the actual block read. For example, if it is looking for block 4 of PROGRAM and instead reads block 5, the message PROGRAM 04 will remain at the left of the screen and the message PROGRAM 05 will be displayed at the right. You can recover from this by very briefly re-winding over the missed block and allowing it to be read again. Even if you go back too far it does not matter; the LOAD will ignore all blocks until it finds block 4. This is also the appropriate recovery action if you initially position the tape beyond the beginning of the file.

Finally, if there is a read error during a block read, the message READ ERROR will be displayed and micro-PROLOG will tell you that it is still looking for that block by not changing the message in the top left of the screen. You can also try to recover from this error by re-winding the tape over the incorrectly read block so that micro-PROLOG can try to read it again.

### 2. SAVE

Before you use this command, position the tape at the place where you wish to record and check that the leads are connected correctly for recording. You should start the tape for writing (press RECORD) before you press the ENTER key to enter the SAVE command. micro-PROLOG will start sending information to the cassette recorder as soon as you press ENTER, so the recorder should already be recording. As each block of the file is sent to the recorder a message giving the file name and current block number is displayed at the left of the screen.

When the LOAD or SAVE is completed you will get the `&.` supervisor prompt; you should then stop the tape.



# REFERENCES

Clark K L (1978) 'Negation as Failure' *Logic and data bases* (H Gallaire and J Minker, Eds), Plenum Press, New York, pp293-322.

Clark K L, Ennals J R, McCabe F (1983) *A micro-PROLOG Primer*, Logic Programming Associates Ltd.

Clark K L, McCabe F (1979) 'Control facilities of IC-PROLOG' *Expert systems in the Micro-Electronic Age* (D Michie, Ed), Edinburgh University Press.

Clark K L, McCabe F (1984) *micro-PROLOG: programming in logic*, Prentice-Hall International.

Clocksin W F, Mellish C S (1981) *Programming in Prolog* Springer-Verlag, New York.

Colmerauer A (1973) 'Les systemes-Q ou un Formalisme pour Analyser et Synthetiser des Phrases sur Ordinateur'. Publication interne No 43, Dept d'Informatique, Universite de Montreal.

Colmerauer A (1978) 'Metamorphosis grammars' *Natural language communication with computers* (L Bolc, Ed), Lecture notes in computer science No 63, Springer-Verlag, pp133-89.

Kanoui H, Van Canaghem M (1980) *Implementing a very high level language on a very low cost computer.* Group d'Intelligence Artificielle, Universite d'Aix-Marseille, Luminy.

Knuth D E (1968) *The art of computer programming*, pp147-51. Addison Wesley. Volume II, Semi-numerical algorithms.

Kowalski R A (1974) 'Predicate logic as programming language'. *Proc IFIP* 74, North Holland Publishing Co, Amsterdam, pp569-74.

Kowalski R A (1979) *Logic for Problem Solving*. Artificial Intelligence Series, North Holland Inc, New York.

McCarthy J, Abrahams P W, Edward D G, Hart T P, Levin M I (1962) *Revised report on the algorithmic language Algol 60.* IFIP 1962.

Moss C D S (1979) *A new grammar for Algol 68.* Dep Rep 79/6, Imperial College, London.

Naur P, Ed (1962) *Revised report on the algorithmic language Algol 60.* IFIP 1962.

Pereira L, Pereira F, Warren D (1978) *User's guide to DEC system 10 PROLOG.* Dept AI, University of Edinburgh.

Roberts G W (1977) *An implementation of PROLOG*, MSc thesis, Waterloo, Ontario, Canada.

Robinson J A (1965) 'A machine oriented logic based on the resolution principle'. *J ACM* 12 (January 1965), pp23-41.

Robinson J A (1979) *Logic: form and function.* Edinburgh University Press.

Roussel P (1975) *PROLOG: manuel de reference et d'utilisation* groupe d'intelligence artificielle, Universite d'Aix-Marseille, Luminy, Sept 1975.

Szeredi P *et al.* *MPROLOG user's manual.* Institute for co-ordination of computer techniques. Hungary, 1368 Budapest, POB 224.

Van Emden M H, Kowalski R A (1976) 'The semantics of predicate logic as a programming language'. *J. ACM*, Vol 23, No 4, pp733-42.


# Sinclair ZX Spectrum  micro-PROLOG Reference Manual

This *Manual* is designed to follow on from the *micro-PROLOG Primer* which was supplied as part of the micro-PROLOG software package for your ZX Spectrum.

PROLOG is a computer language based on symbolic logic; micro-PROLOG is an interpreted version tailored for interactive use on microcomputers. It is a mature system which, although adapted for the microcomputer, sacrifices none of the significant features of PROLOG - indeed, it contains features not available in some of the large-machine implementations.

PROLOG sets the standard for future computer languages; this *Manual* is essential reading for anyone wishing to play a part in its development.

