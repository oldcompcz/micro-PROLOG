; z80dasm 1.1.3
; command line: z80dasm -a -t -l -g 24576 -b blocks.txt prolog.bin

; ROM routines

ROM_LD_EDGE_1:                 equ 005e7h
ROM_LD_EDGE_2:                 equ 005e3h
ROM_OUT_CURS_WITHOUT_CHECK:    equ 018e8h
ROM_INPUT_AD:                  equ 015e6h
ROM_PRINT_A_2:                 equ 015f2h


    org     06000h

l6000h:
    inc bc                     ;6000    03      .                  (flow from: )
    adc a,c                    ;6001    89      .                  (flow from: 6000)
    ld (hl),l                  ;6002    75      u                  (flow from: 6001)
l6003h:
    ld sp,0ffffh               ;6003    31 ff ff    1 . .          (flow from: 6002)
    nop                        ;6006    00      .                  (flow from: 6003)
    ld hl,l6286h               ;6007    21 86 62    ! . b          (flow from: 6006)
    push hl                    ;600a    e5      .                  (flow from: 6007)
    ld (09803h),sp             ;600b    ed 73 03 98     . s . .    (flow from: 600a)
    ld (05c3dh),sp             ;600f    ed 73 3d 5c     . s = \    (flow from: 600b)
    ld hl,0ffffh               ;6013    21 ff ff    ! . .          (flow from: 600f)
    ld (0985bh),hl             ;6016    22 5b 98    " [ .          (flow from: 6013)
    call sub_9629h             ;6019    cd 29 96    . ) .          (flow from: 6016)
    ld hl,(09805h)             ;601c    2a 05 98    * . .          (flow from: 9748)
    inc hl                     ;601f    23      #                  (flow from: 601c)
    ld (hl),0ffh               ;6020    36 ff   6 .                (flow from: 601f)
    inc hl                     ;6022    23      #                  (flow from: 6020)
    ld (hl),0ffh               ;6023    36 ff   6 .                (flow from: 6022)
l6025h:
    ld hl,l8834h               ;6025    21 34 88    ! 4 .          (flow from: 6023)
    ld (09841h),hl             ;6028    22 41 98    " A .          (flow from: 6025)
    ld hl,l884ch               ;602b    21 4c 88    ! L .          (flow from: 6028)
    ld (09845h),hl             ;602e    22 45 98    " E .          (flow from: 602b)
    ld hl,l849dh               ;6031    21 9d 84    ! . .          (flow from: 602e)
    ld (09849h),hl             ;6034    22 49 98    " I .          (flow from: 6031)
    ld hl,(09837h)             ;6037    2a 37 98    * 7 .          (flow from: 6034)
    ld (0984bh),hl             ;603a    22 4b 98    " K .          (flow from: 6037)
    call sub_6312h             ;603d    cd 12 63    . . c          (flow from: 603a)
    ld hl,(0983dh)             ;6040    2a 3d 98    * = .          (flow from: 639b)
    ld ix,(0983dh)             ;6043    dd 2a 3d 98     . * = .    (flow from: 6040)
    ld (0983fh),hl             ;6047    22 3f 98    " ? .          (flow from: 6043)
    ld (09843h),hl             ;604a    22 43 98    " C .          (flow from: 6047)
    ld (09847h),hl             ;604d    22 47 98    " G .          (flow from: 604a)
    ld (ix+002h),l             ;6050    dd 75 02    . u .          (flow from: 604d)
    ld (ix+003h),h             ;6053    dd 74 03    . t .          (flow from: 6050)
    ld (ix+006h),l             ;6056    dd 75 06    . u .          (flow from: 6053)
    ld (ix+007h),h             ;6059    dd 74 07    . t .          (flow from: 6056)
l605ch:
    ld ix,(09843h)             ;605c    dd 2a 43 98     . * C .    (flow from: 6059 6167 624c)
    ld e,(ix+00ah)             ;6060    dd 5e 0a    . ^ .          (flow from: 605c)
    ld d,(ix+00bh)             ;6063    dd 56 0b    . V .          (flow from: 6060)
    ld (09853h),de             ;6066    ed 53 53 98     . S S .    (flow from: 6063)
    call sub_7310h             ;606a    cd 10 73    . . s          (flow from: 6066)
    ld hl,(09845h)             ;606d    2a 45 98    * E .          (flow from: 734b)
    ld a,(hl)                  ;6070    7e      ~                  (flow from: 606d)
    cp 003h                    ;6071    fe 03   . .                (flow from: 6070)
    jp nz,l6290h               ;6073    c2 90 62    . . b          (flow from: 6071)
    call sub_9623h             ;6076    cd 23 96    . # .          (flow from: 6073)
    call sub_6575h             ;6079    cd 75 65    . u e          (flow from: 9628)
    cp 003h                    ;607c    fe 03   . .                (flow from: 658a)
    jr z,l6097h                ;607e    28 17   ( .                (flow from: 607c)
    cp 008h                    ;6080    fe 08   . .                (flow from: 607e)
    jp nz,l6290h               ;6082    c2 90 62    . . b          (flow from: 6080)
    call sub_9623h             ;6085    cd 23 96    . # .          (flow from: 6082)
    ld a,(hl)                  ;6088    7e      ~                  (flow from: 9628)
    cp 004h                    ;6089    fe 04   . .                (flow from: 6088)
    jp nz,l6290h               ;608b    c2 90 62    . . b          (flow from: 6089)
    ld bc,l849dh               ;608e    01 9d 84    . . .          (flow from: 608b)
    ld (0984fh),bc             ;6091    ed 43 4f 98     . C O .    (flow from: 608e)
    jr l60b3h                  ;6095    18 1c   . .                (flow from: 6091)
l6097h:
    call sub_9623h             ;6097    cd 23 96    . # .          (flow from: 607e)
    inc hl                     ;609a    23      #                  (flow from: 9628)
    inc hl                     ;609b    23      #                  (flow from: 609a)
    inc hl                     ;609c    23      #                  (flow from: 609b)
    ld (0984fh),hl             ;609d    22 4f 98    " O .          (flow from: 609c)
    dec hl                     ;60a0    2b      +                  (flow from: 609d)
    dec hl                     ;60a1    2b      +                  (flow from: 60a0)
    dec hl                     ;60a2    2b      +                  (flow from: 60a1)
    call sub_6575h             ;60a3    cd 75 65    . u e          (flow from: 60a2)
    cp 008h                    ;60a6    fe 08   . .                (flow from: 658a)
    jp nz,l6290h               ;60a8    c2 90 62    . . b          (flow from: 60a6)
    call sub_9623h             ;60ab    cd 23 96    . # .          (flow from: 60a8)
    ld a,(hl)                  ;60ae    7e      ~                  (flow from: 9628)
    cp 004h                    ;60af    fe 04   . .                (flow from: 60ae)
    jr nz,l60dbh               ;60b1    20 28     (                (flow from: 60af)
l60b3h:
    push de                    ;60b3    d5      .                  (flow from: 6095 60b1)
    ld de,l60bch               ;60b4    11 bc 60    . . `          (flow from: 60b3)
    push de                    ;60b7    d5      .                  (flow from: 60b4)
    call sub_9623h             ;60b8    cd 23 96    . # .          (flow from: 60b7)
    jp (hl)                    ;60bb    e9      .                  (flow from: 9628)
l60bch:
    pop de                     ;60bc    d1      .                  (flow from: 663d 6679 768a 7823 7e37)
    jp nz,l624fh               ;60bd    c2 4f 62    . O b          (flow from: 60bc)
    ld hl,(09845h)             ;60c0    2a 45 98    * E .          (flow from: 60bd)
    call sub_9623h             ;60c3    cd 23 96    . # .          (flow from: 60c0)
    inc hl                     ;60c6    23      #                  (flow from: 9628)
    inc hl                     ;60c7    23      #                  (flow from: 60c6)
    inc hl                     ;60c8    23      #                  (flow from: 60c7)
    call sub_6575h             ;60c9    cd 75 65    . u e          (flow from: 60c8)
    ld (09845h),hl             ;60cc    22 45 98    " E .          (flow from: 658a)
    cp 010h                    ;60cf    fe 10   . .                (flow from: 60cc)
    ld bc,(09843h)             ;60d1    ed 4b 43 98     . K C .    (flow from: 60cf)
    ld ix,(09843h)             ;60d5    dd 2a 43 98     . * C .    (flow from: 60d1)
    jr l6144h                  ;60d9    18 69   . i                (flow from: 60d5)
l60dbh:
    cp 003h                    ;60db    fe 03   . .                (flow from: 60b1)
    jp nz,l62a4h               ;60dd    c2 a4 62    . . b          (flow from: 60db)
    ld (09841h),hl             ;60e0    22 41 98    " A .          (flow from: 60dd)
l60e3h:
    call sub_6312h             ;60e3    cd 12 63    . . c          (flow from: 60e0 6256)
    jp nz,l624fh               ;60e6    c2 4f 62    . O b          (flow from: 639b 63a3)
    ld ix,(09843h)             ;60e9    dd 2a 43 98     . * C .    (flow from: 60e6)
    ld e,(ix+00ah)             ;60ed    dd 5e 0a    . ^ .          (flow from: 60e9)
    ld d,(ix+00bh)             ;60f0    dd 56 0b    . V .          (flow from: 60ed)
    ld (09853h),de             ;60f3    ed 53 53 98     . S S .    (flow from: 60f0)
    ld hl,(09845h)             ;60f7    2a 45 98    * E .          (flow from: 60f3)
    call sub_9623h             ;60fa    cd 23 96    . # .          (flow from: 60f7)
    call sub_6575h             ;60fd    cd 75 65    . u e          (flow from: 9628)
    call sub_9623h             ;6100    cd 23 96    . # .          (flow from: 658a)
    inc hl                     ;6103    23      #                  (flow from: 9628)
    inc hl                     ;6104    23      #                  (flow from: 6103)
    inc hl                     ;6105    23      #                  (flow from: 6104)
l6106h:
    ex de,hl                   ;6106    eb      .                  (flow from: 6105)
    ld hl,(09851h)             ;6107    2a 51 98    * Q .          (flow from: 6106)
    ld b,000h                  ;610a    06 00   . .                (flow from: 6107)
    call sub_63edh             ;610c    cd ed 63    . . c          (flow from: 610a)
    jp nz,l624fh               ;610f    c2 4f 62    . O b          (flow from: 6481 64ae 6504)
    ld hl,(0984dh)             ;6112    2a 4d 98    * M .          (flow from: 610f)
    ld de,(09855h)             ;6115    ed 5b 55 98     . [ U .    (flow from: 6112)
    call sub_6575h             ;6119    cd 75 65    . u e          (flow from: 6115)
    cp 010h                    ;611c    fe 10   . .                (flow from: 658a)
    jr nz,l616ah               ;611e    20 4a     J                (flow from: 611c)
    ld ix,(0983dh)             ;6120    dd 2a 3d 98     . * = . 
l6124h:
    ld l,(ix+004h)             ;6124    dd 6e 04    . n .          (flow from: 6144)
    ld h,(ix+005h)             ;6127    dd 66 05    . f .          (flow from: 6124)
    call sub_9623h             ;612a    cd 23 96    . # .          (flow from: 6127)
    inc hl                     ;612d    23      #                  (flow from: 9628)
    inc hl                     ;612e    23      #                  (flow from: 612d)
    inc hl                     ;612f    23      #                  (flow from: 612e)
    ld c,(ix+002h)             ;6130    dd 4e 02    . N .          (flow from: 612f)
    ld b,(ix+003h)             ;6133    dd 46 03    . F .          (flow from: 6130)
    push bc                    ;6136    c5      .                  (flow from: 6133)
    pop ix                     ;6137    dd e1   . .                (flow from: 6136)
    ld e,(ix+00ah)             ;6139    dd 5e 0a    . ^ .          (flow from: 6137)
    ld d,(ix+00bh)             ;613c    dd 56 0b    . V .          (flow from: 6139)
    call sub_6575h             ;613f    cd 75 65    . u e          (flow from: 613c)
    cp 010h                    ;6142    fe 10   . .                (flow from: 658a)
l6144h:
    jr z,l6124h                ;6144    28 de   ( .                (flow from: 60d9 6142)
    cp 003h                    ;6146    fe 03   . .                (flow from: 6144)
    jp nz,l6290h               ;6148    c2 90 62    . . b          (flow from: 6146)
    ld d,b                     ;614b    50      P                  (flow from: 6148)
    ld e,c                     ;614c    59      Y                  (flow from: 614b)
    ld (09843h),de             ;614d    ed 53 43 98     . S C .    (flow from: 614c)
    ld (09845h),hl             ;6151    22 45 98    " E .          (flow from: 614d)
    ld hl,(09847h)             ;6154    2a 47 98    * G .          (flow from: 6151)
    call sub_65f1h             ;6157    cd f1 65    . . e          (flow from: 6154)
    jr nc,l615dh               ;615a    30 01   0 .                (flow from: 65f6)
    ex de,hl                   ;615c    eb      .                  (flow from: 615a)
l615dh:
    ld (0983dh),hl             ;615d    22 3d 98    " = .          (flow from: 615a 615c)
    ld de,0000ch               ;6160    11 0c 00    . . .          (flow from: 615d)
    add hl,de                  ;6163    19      .                  (flow from: 6160)
    ld (0984bh),hl             ;6164    22 4b 98    " K .          (flow from: 6163)
    jp l605ch                  ;6167    c3 5c 60    . \ `          (flow from: 6164)
l616ah:
    cp 003h                    ;616a    fe 03   . .                (flow from: 611e)
    jp nz,l6290h               ;616c    c2 90 62    . . b          (flow from: 616a)
    ld de,(09845h)             ;616f    ed 5b 45 98     . [ E .    (flow from: 616c)
    ld (09845h),hl             ;6173    22 45 98    " E .          (flow from: 616f)
    ex de,hl                   ;6176    eb      .                  (flow from: 6173)
    call sub_9623h             ;6177    cd 23 96    . # .          (flow from: 6176)
    inc hl                     ;617a    23      #                  (flow from: 9628)
    inc hl                     ;617b    23      #                  (flow from: 617a)
    inc hl                     ;617c    23      #                  (flow from: 617b)
    ld de,(09853h)             ;617d    ed 5b 53 98     . [ S .    (flow from: 617c)
    call sub_6575h             ;6181    cd 75 65    . u e          (flow from: 617d)
    cp 010h                    ;6184    fe 10   . .                (flow from: 658a)
    jp nz,l6246h               ;6186    c2 46 62    . F b          (flow from: 6184)
    ld hl,(09857h)             ;6189    2a 57 98    * W .          (flow from: 6186)
    ld de,(09843h)             ;618c    ed 5b 43 98     . [ C .    (flow from: 6189)
    or a                       ;6190    b7      .                  (flow from: 618c)
    sbc hl,de                  ;6191    ed 52   . R                (flow from: 6190)
    jp nz,l6246h               ;6193    c2 46 62    . F b          (flow from: 6191)
    ld hl,(09847h)             ;6196    2a 47 98    * G .          (flow from: 6193)
    or a                       ;6199    b7      .                  (flow from: 6196)
    sbc hl,de                  ;619a    ed 52   . R                (flow from: 6199)
    jp nc,l6246h               ;619c    d2 46 62    . F b          (flow from: 619a)
    ld hl,(09853h)             ;619f    2a 53 98    * S .          (flow from: 619c)
    ld de,(09855h)             ;61a2    ed 5b 55 98     . [ U .    (flow from: 619f)
    or a                       ;61a6    b7      .                  (flow from: 61a2)
    sbc hl,de                  ;61a7    ed 52   . R                (flow from: 61a6)
    ex de,hl                   ;61a9    eb      .                  (flow from: 61a7)
    ld bc,(09845h)             ;61aa    ed 4b 45 98     . K E .    (flow from: 61a9)
    dec hl                     ;61ae    2b      +                  (flow from: 61aa)
    or a                       ;61af    b7      .                  (flow from: 61ae)
    sbc hl,bc                  ;61b0    ed 42   . B                (flow from: 61af)
    jr nc,l61c2h               ;61b2    30 0e   0 .                (flow from: 61b0)
    ld hl,(0983dh)             ;61b4    2a 3d 98    * = . 
    or a                       ;61b7    b7      . 
    sbc hl,bc                  ;61b8    ed 42   . B 
    jr c,l61c2h                ;61ba    38 06   8 . 
    ld h,b                     ;61bc    60      ` 
    ld l,c                     ;61bd    69      i 
    add hl,de                  ;61be    19      . 
    ld (09845h),hl             ;61bf    22 45 98    " E . 
l61c2h:
    ld bc,(09855h)             ;61c2    ed 4b 55 98     . K U .    (flow from: 61b2)
    ld hl,(0983dh)             ;61c6    2a 3d 98    * = .          (flow from: 61c2)
    or a                       ;61c9    b7      .                  (flow from: 61c6)
    sbc hl,bc                  ;61ca    ed 42   . B                (flow from: 61c9)
    jr z,l621ch                ;61cc    28 4e   ( N                (flow from: 61ca)
    ld b,l                     ;61ce    45      E                  (flow from: 61cc)
    ld (09859h),de             ;61cf    ed 53 59 98     . S Y .    (flow from: 61ce)
    ld hl,(09855h)             ;61d3    2a 55 98    * U .          (flow from: 61cf)
l61d6h:
    ld a,(hl)                  ;61d6    7e      ~                  (flow from: 61d3 621a)
    cp 001h                    ;61d7    fe 01   . .                (flow from: 61d6)
    jr nz,l6215h               ;61d9    20 3a     :                (flow from: 61d7)
    push hl                    ;61db    e5      . 
    call sub_9623h             ;61dc    cd 23 96    . # . 
    ex de,hl                   ;61df    eb      . 
    ld hl,(09853h)             ;61e0    2a 53 98    * S . 
    dec hl                     ;61e3    2b      + 
    or a                       ;61e4    b7      . 
    sbc hl,de                  ;61e5    ed 52   . R 
    jr nc,l6214h               ;61e7    30 2b   0 + 
    ld hl,(09843h)             ;61e9    2a 43 98    * C . 
    or a                       ;61ec    b7      . 
    sbc hl,de                  ;61ed    ed 52   . R 
    jr c,l6214h                ;61ef    38 23   8 # 
    ld a,(de)                  ;61f1    1a      . 
    cp 000h                    ;61f2    fe 00   . . 
    jr nz,l620ah               ;61f4    20 14     . 
    pop hl                     ;61f6    e1      . 
    push hl                    ;61f7    e5      . 
    ld (hl),000h               ;61f8    36 00   6 . 
    push de                    ;61fa    d5      . 
    ld de,(09859h)             ;61fb    ed 5b 59 98     . [ Y . 
    add hl,de                  ;61ff    19      . 
    pop de                     ;6200    d1      . 
    ex de,hl                   ;6201    eb      . 
    ld (hl),001h               ;6202    36 01   6 . 
    inc hl                     ;6204    23      # 
    ld (hl),e                  ;6205    73      s 
    inc hl                     ;6206    23      # 
    ld (hl),d                  ;6207    72      r 
    jr l6214h                  ;6208    18 0a   . . 
l620ah:
    pop hl                     ;620a    e1      . 
    push hl                    ;620b    e5      . 
    ex de,hl                   ;620c    eb      . 
    push bc                    ;620d    c5      . 
    ld bc,00003h               ;620e    01 03 00    . . . 
    ldir                       ;6211    ed b0   . . 
    pop bc                     ;6213    c1      . 
l6214h:
    pop hl                     ;6214    e1      . 
l6215h:
    inc hl                     ;6215    23      #                  (flow from: 61d9)
    inc hl                     ;6216    23      #                  (flow from: 6215)
    inc hl                     ;6217    23      #                  (flow from: 6216)
    dec b                      ;6218    05      .                  (flow from: 6217)
    dec b                      ;6219    05      .                  (flow from: 6218)
    djnz l61d6h                ;621a    10 ba   . .                (flow from: 6219)
l621ch:
    ld de,(0983dh)             ;621c    ed 5b 3d 98     . [ = .    (flow from: 621a)
    ld hl,(09843h)             ;6220    2a 43 98    * C .          (flow from: 621c)
    ld bc,0000ch               ;6223    01 0c 00    . . .          (flow from: 6220)
    ldir                       ;6226    ed b0   . .                (flow from: 6223 6226)
    ld de,(09855h)             ;6228    ed 5b 55 98     . [ U .    (flow from: 6226)
    ld hl,(0984bh)             ;622c    2a 4b 98    * K .          (flow from: 6228)
    or a                       ;622f    b7      .                  (flow from: 622c)
    sbc hl,de                  ;6230    ed 52   . R                (flow from: 622f)
    ld b,h                     ;6232    44      D                  (flow from: 6230)
    ld c,l                     ;6233    4d      M                  (flow from: 6232)
    ex de,hl                   ;6234    eb      .                  (flow from: 6233)
    ld de,(09853h)             ;6235    ed 5b 53 98     . [ S .    (flow from: 6234)
    ldir                       ;6239    ed b0   . .                (flow from: 6235 6239)
    ld (0984bh),de             ;623b    ed 53 4b 98     . S K .    (flow from: 6239)
    ld hl,0fff4h               ;623f    21 f4 ff    ! . .          (flow from: 623b)
    add hl,de                  ;6242    19      .                  (flow from: 623f)
    ld (0983dh),hl             ;6243    22 3d 98    " = .          (flow from: 6242)
l6246h:
    ld hl,(0983dh)             ;6246    2a 3d 98    * = .          (flow from: 6186 619c 6243)
    ld (09843h),hl             ;6249    22 43 98    " C .          (flow from: 6246)
    jp l605ch                  ;624c    c3 5c 60    . \ `          (flow from: 6249)
l624fh:
    ld ix,(09847h)             ;624f    dd 2a 47 98     . * G .    (flow from: 60bd 610f)
    call sub_63a4h             ;6253    cd a4 63    . . c          (flow from: 624f)
    jp l60e3h                  ;6256    c3 e3 60    . . `          (flow from: 63ec)
sub_6259h:
    call sub_7296h             ;6259    cd 96 72    . . r 
    out (0f9h),a               ;625c    d3 f9   . . 
    di                         ;625e    f3      . 
    call p,0ede5h              ;625f    f4 e5 ed    . . . 
    and b                      ;6262    a0      . 
    pop bc                     ;6263    c1      . 
    jp po,0f2efh               ;6264    e2 ef f2    . . . 
    call p,0c300h              ;6267    f4 00 c3    . . . 
    inc bc                     ;626a    03      . 
    ld h,b                     ;626b    60      ` 
l626ch:
    ld hl,nospace_string_start ;626c    21 e9 62    ! . b 
    jr l6274h                  ;626f    18 03   . . 
l6271h:
    ld hl,dictfull_string_start;6271    21 f8 62    ! . b 
l6274h:
    call sub_72a1h             ;6274    cd a1 72    . . r 
    call sub_739bh             ;6277    cd 9b 73    . . s 
    ld sp,(09803h)             ;627a    ed 7b 03 98     . { . . 
    jp l6025h                  ;627e    c3 25 60    . % ` 
l6281h:
    ld hl,0000bh               ;6281    21 0b 00    ! . . 
    jr l62a7h                  ;6284    18 21   . ! 
l6286h:
    ld h,000h                  ;6286    26 00   & . 
    ld l,(iy+000h)             ;6288    fd 6e 00    . n . 
    inc l                      ;628b    2c      , 
    inc l                      ;628c    2c      , 
    inc l                      ;628d    2c      , 
    jr l62a7h                  ;628e    18 17   . . 
l6290h:
    ld hl,00003h               ;6290    21 03 00    ! . . 
    jr l62a7h                  ;6293    18 12   . . 
l6295h:
    ld hl,00005h               ;6295    21 05 00    ! . . 
    jr l62a7h                  ;6298    18 0d   . . 
l629ah:
    ld hl,00001h               ;629a    21 01 00    ! . . 
    jr l62a7h                  ;629d    18 08   . . 
l629fh:
    ld hl,00000h               ;629f    21 00 00    ! . . 
    jr l62a7h                  ;62a2    18 03   . . 
l62a4h:
    ld hl,00002h               ;62a4    21 02 00    ! . . 
l62a7h:
    ld sp,(09803h)             ;62a7    ed 7b 03 98     . { . . 
    push hl                    ;62ab    e5      . 
    call sub_739bh             ;62ac    cd 9b 73    . . s 
    ld hl,(09b1ah)             ;62af    2a 1a 9b    * . . 
    ld a,(hl)                  ;62b2    7e      ~ 
    cp 003h                    ;62b3    fe 03   . . 
    jr z,l62c7h                ;62b5    28 10   ( . 
    ld hl,dictfull_string_end  ;62b7    21 09 63    ! . c 
    call sub_72a1h             ;62ba    cd a1 72    . . r 
    pop hl                     ;62bd    e1      . 
    call sub_6b26h             ;62be    cd 26 6b    . & k 
    call sub_72f8h             ;62c1    cd f8 72    . . r 
    jp l6025h                  ;62c4    c3 25 60    . % ` 
l62c7h:
    ld hl,l8aefh               ;62c7    21 ef 8a    ! . . 
    ld (09841h),hl             ;62ca    22 41 98    " A . 
    call sub_6312h             ;62cd    cd 12 63    . . c 
    ld hl,(09855h)             ;62d0    2a 55 98    * U . 
    pop de                     ;62d3    d1      . 
    ld (hl),004h               ;62d4    36 04   6 . 
    inc hl                     ;62d6    23      # 
    ld (hl),e                  ;62d7    73      s 
    inc hl                     ;62d8    23      # 
    ld (hl),d                  ;62d9    72      r 
    ld hl,(09845h)             ;62da    2a 45 98    * E . 
    ld a,(hl)                  ;62dd    7e      ~ 
    cp 003h                    ;62de    fe 03   . . 
    jp nz,l6106h               ;62e0    c2 06 61    . . a 
    call sub_9623h             ;62e3    cd 23 96    . # . 
    jp l6106h                  ;62e6    c3 06 61    . . a 

; BLOCK 'nospace_string' (start 0x62e9 end 0x62f7)
nospace_string_start:
    defb 04eh                  ;62e9    4e      N 
    defb 06fh                  ;62ea    6f      o 
    defb 020h                  ;62eb    20        
    defb 053h                  ;62ec    53      S 
    defb 070h                  ;62ed    70      p 
    defb 061h                  ;62ee    61      a 
    defb 063h                  ;62ef    63      c 
    defb 065h                  ;62f0    65      e 
    defb 020h                  ;62f1    20        
    defb 06ch                  ;62f2    6c      l 
    defb 065h                  ;62f3    65      e 
    defb 066h                  ;62f4    66      f 
    defb 074h                  ;62f5    74      t 
    defb 00dh                  ;62f6    0d      . 
nospace_string_end:
    nop                        ;62f7    00      . 

; BLOCK 'dictfull_string' (start 0x62f8 end 0x6309)
dictfull_string_start:
    defb 044h                  ;62f8    44      D 
    defb 069h                  ;62f9    69      i 
    defb 063h                  ;62fa    63      c 
    defb 074h                  ;62fb    74      t 
    defb 069h                  ;62fc    69      i 
    defb 06fh                  ;62fd    6f      o 
    defb 06eh                  ;62fe    6e      n 
    defb 061h                  ;62ff    61      a 
    defb 072h                  ;6300    72      r 
    defb 079h                  ;6301    79      y 
    defb 020h                  ;6302    20        
    defb 066h                  ;6303    66      f 
    defb 075h                  ;6304    75      u 
    defb 06ch                  ;6305    6c      l 
    defb 06ch                  ;6306    6c      l 
    defb 00dh                  ;6307    0d      . 
    defb 000h                  ;6308    00      . 
dictfull_string_end:
    ld b,l                     ;6309    45      E 
    ld (hl),d                  ;630a    72      r 
    ld (hl),d                  ;630b    72      r 
    ld l,a                     ;630c    6f      o 
    ld (hl),d                  ;630d    72      r 
    ld a,(02020h)              ;630e    3a 20 20    :     
    nop                        ;6311    00      . 
sub_6312h:
    ld hl,(0983dh)             ;6312    2a 3d 98    * = .          (flow from: 603d 60e3)
    ld (09857h),hl             ;6315    22 57 98    " W .          (flow from: 6312)
    ld hl,(09841h)             ;6318    2a 41 98    * A .          (flow from: 6315)
    ld a,(hl)                  ;631b    7e      ~                  (flow from: 6318)
    cp 003h                    ;631c    fe 03   . .                (flow from: 631b)
    ret nz                     ;631e    c0      .                  (flow from: 631c)
    call sub_9623h             ;631f    cd 23 96    . # .          (flow from: 631e)
    ld a,(hl)                  ;6322    7e      ~                  (flow from: 9628)
    cp 003h                    ;6323    fe 03   . .                (flow from: 6322)
    ret nz                     ;6325    c0      .                  (flow from: 6323)
    push hl                    ;6326    e5      .                  (flow from: 6325)
    call sub_9623h             ;6327    cd 23 96    . # .          (flow from: 6326)
    push hl                    ;632a    e5      .                  (flow from: 9628)
    ld a,(hl)                  ;632b    7e      ~                  (flow from: 632a)
    cp 004h                    ;632c    fe 04   . .                (flow from: 632b)
    call nz,sub_6259h          ;632e    c4 59 62    . Y b          (flow from: 632c)
    call sub_9623h             ;6331    cd 23 96    . # .          (flow from: 632e)
    push hl                    ;6334    e5      .                  (flow from: 9628)
    push hl                    ;6335    e5      .                  (flow from: 6334)
    add hl,hl                  ;6336    29      )                  (flow from: 6335)
    pop de                     ;6337    d1      .                  (flow from: 6336)
    add hl,de                  ;6338    19      .                  (flow from: 6337)
    ld de,00012h               ;6339    11 12 00    . . .          (flow from: 6338)
    add hl,de                  ;633c    19      .                  (flow from: 6339)
    ld de,(0984bh)             ;633d    ed 5b 4b 98     . [ K .    (flow from: 633c)
    add hl,de                  ;6341    19      .                  (flow from: 633d)
    ld de,(0983bh)             ;6342    ed 5b 3b 98     . [    ; . (flow from: 6341)
    call sub_65f1h             ;6346    cd f1 65    . . e          (flow from: 6342)
    jr c,l6358h                ;6349    38 0d   8 .                (flow from: 65f6)
    call sub_6713h             ;634b    cd 13 67    . . g 
    ld de,(0983bh)             ;634e    ed 5b 3b 98     . [    ; . 
    or a                       ;6352    b7      . 
    sbc hl,de                  ;6353    ed 52   . R 
    jp nc,l626ch               ;6355    d2 6c 62    . l b 
l6358h:
    pop bc                     ;6358    c1      .                  (flow from: 6349)
    ld b,c                     ;6359    41      A                  (flow from: 6358)
    inc b                      ;635a    04      .                  (flow from: 6359)
    dec b                      ;635b    05      .                  (flow from: 635a)
    ld hl,(0984bh)             ;635c    2a 4b 98    * K .          (flow from: 635b)
    ld (09855h),hl             ;635f    22 55 98    " U .          (flow from: 635c)
    jr z,l636bh                ;6362    28 07   ( .                (flow from: 635f)
l6364h:
    ld (hl),000h               ;6364    36 00   6 .                (flow from: 6362 6369)
    inc hl                     ;6366    23      #                  (flow from: 6364)
    inc hl                     ;6367    23      #                  (flow from: 6366)
    inc hl                     ;6368    23      #                  (flow from: 6367)
    djnz l6364h                ;6369    10 f9   . .                (flow from: 6368)
l636bh:
    ld (0983dh),hl             ;636b    22 3d 98    " = .          (flow from: 6362 6369)
    pop hl                     ;636e    e1      .                  (flow from: 636b)
    inc hl                     ;636f    23      #                  (flow from: 636e)
    inc hl                     ;6370    23      #                  (flow from: 636f)
    inc hl                     ;6371    23      #                  (flow from: 6370)
    call sub_9623h             ;6372    cd 23 96    . # .          (flow from: 6371)
    ld (09851h),hl             ;6375    22 51 98    " Q .          (flow from: 9628)
    inc hl                     ;6378    23      #                  (flow from: 6375)
    inc hl                     ;6379    23      #                  (flow from: 6378)
    inc hl                     ;637a    23      #                  (flow from: 6379)
    ld (0984dh),hl             ;637b    22 4d 98    " M .          (flow from: 637a)
    pop hl                     ;637e    e1      .                  (flow from: 637b)
    inc hl                     ;637f    23      #                  (flow from: 637e)
    inc hl                     ;6380    23      #                  (flow from: 637f)
    inc hl                     ;6381    23      #                  (flow from: 6380)
    ld (09841h),hl             ;6382    22 41 98    " A .          (flow from: 6381)
    ld hl,09841h               ;6385    21 41 98    ! A .          (flow from: 6382)
    ld de,(0983dh)             ;6388    ed 5b 3d 98     . [ = .    (flow from: 6385)
    ld bc,0000ch               ;638c    01 0c 00    . . .          (flow from: 6388)
    ldir                       ;638f    ed b0   . .                (flow from: 638c 638f)
    ld (0984bh),de             ;6391    ed 53 4b 98     . S K .    (flow from: 638f)
    ld hl,(09841h)             ;6395    2a 41 98    * A .          (flow from: 6391)
    ld a,(hl)                  ;6398    7e      ~                  (flow from: 6395)
    cp 010h                    ;6399    fe 10   . .                (flow from: 6398)
    ret z                      ;639b    c8      .                  (flow from: 6399)
    ld hl,(0983dh)             ;639c    2a 3d 98    * = .          (flow from: 639b)
    ld (09847h),hl             ;639f    22 47 98    " G .          (flow from: 639c)
    cp a                       ;63a2    bf      .                  (flow from: 639f)
    ret                        ;63a3    c9      .                  (flow from: 63a2)
sub_63a4h:
    ld e,(ix+008h)             ;63a4    dd 5e 08    . ^ .          (flow from: 6253)
    ld d,(ix+009h)             ;63a7    dd 56 09    . V .          (flow from: 63a4)
    ld hl,(09849h)             ;63aa    2a 49 98    * I .          (flow from: 63a7)
l63adh:
    push hl                    ;63ad    e5      .                  (flow from: 63aa 63d5)
    or a                       ;63ae    b7      .                  (flow from: 63ad)
    sbc hl,de                  ;63af    ed 52   . R                (flow from: 63ae)
    pop hl                     ;63b1    e1      .                  (flow from: 63af)
    jr z,l63d7h                ;63b2    28 23   ( #                (flow from: 63b1)
    ld a,(hl)                  ;63b4    7e      ~                  (flow from: 63b2)
    push hl                    ;63b5    e5      .                  (flow from: 63b4)
    push af                    ;63b6    f5      .                  (flow from: 63b5)
    call sub_9623h             ;63b7    cd 23 96    . # .          (flow from: 63b6)
    pop af                     ;63ba    f1      .                  (flow from: 9628)
    cp 010h                    ;63bb    fe 10   . .                (flow from: 63ba)
    jr z,l63c8h                ;63bd    28 09   ( .                (flow from: 63bb)
    cp 005h                    ;63bf    fe 05   . .                (flow from: 63bd)
    jr nz,l63c6h               ;63c1    20 03     .                (flow from: 63bf)
    inc hl                     ;63c3    23      # 
    inc hl                     ;63c4    23      # 
    inc hl                     ;63c5    23      # 
l63c6h:
    ld (hl),000h               ;63c6    36 00   6 .                (flow from: 63c1)
l63c8h:
    pop hl                     ;63c8    e1      .                  (flow from: 63c6)
    inc hl                     ;63c9    23      #                  (flow from: 63c8)
    inc hl                     ;63ca    23      #                  (flow from: 63c9)
    inc hl                     ;63cb    23      #                  (flow from: 63ca)
    ld a,(hl)                  ;63cc    7e      ~                  (flow from: 63cb)
    cp 003h                    ;63cd    fe 03   . .                (flow from: 63cc)
    call nz,sub_6259h          ;63cf    c4 59 62    . Y b          (flow from: 63cd)
    call sub_9623h             ;63d2    cd 23 96    . # .          (flow from: 63cf)
    jr l63adh                  ;63d5    18 d6   . .                (flow from: 9628)
l63d7h:
    push ix                    ;63d7    dd e5   . .                (flow from: 63b2)
    pop hl                     ;63d9    e1      .                  (flow from: 63d7)
    ld de,09841h               ;63da    11 41 98    . A .          (flow from: 63d9)
    ld bc,0000ch               ;63dd    01 0c 00    . . .          (flow from: 63da)
    ldir                       ;63e0    ed b0   . .                (flow from: 63dd 63e0)
    ld hl,(0984bh)             ;63e2    2a 4b 98    * K .          (flow from: 63e0)
    ld bc,0fff4h               ;63e5    01 f4 ff    . . .          (flow from: 63e2)
    add hl,bc                  ;63e8    09      .                  (flow from: 63e5)
    ld (0983dh),hl             ;63e9    22 3d 98    " = .          (flow from: 63e8)
    ret                        ;63ec    c9      .                  (flow from: 63e9)
sub_63edh:
    ld a,(hl)                  ;63ed    7e      ~                  (flow from: 610c 64a8 64b5)
    cp 00ch                    ;63ee    fe 0c   . .                (flow from: 63ed)
    jr nz,l63ffh               ;63f0    20 0d     .                (flow from: 63ee)
    set 0,b                    ;63f2    cb c0   . .                (flow from: 63f0)
    call sub_9623h             ;63f4    cd 23 96    . # .          (flow from: 63f2)
    push de                    ;63f7    d5      .                  (flow from: 9628)
    ld de,(09855h)             ;63f8    ed 5b 55 98     . [ U .    (flow from: 63f7)
    add hl,de                  ;63fc    19      .                  (flow from: 63f8)
    pop de                     ;63fd    d1      .                  (flow from: 63fc)
l63feh:
    ld a,(hl)                  ;63fe    7e      ~                  (flow from: 63fd)
l63ffh:
    cp 001h                    ;63ff    fe 01   . .                (flow from: 63f0 63fe)
    jr nz,l640ah               ;6401    20 07     .                (flow from: 63ff)
    set 0,b                    ;6403    cb c0   . . 
    call sub_9623h             ;6405    cd 23 96    . # . 
    jr l63feh                  ;6408    18 f4   . . 
l640ah:
    cp 005h                    ;640a    fe 05   . .                (flow from: 6401)
    jr nz,l6418h               ;640c    20 0a     .                (flow from: 640a)
    set 0,b                    ;640e    cb c0   . . 
    call sub_9623h             ;6410    cd 23 96    . # . 
    inc hl                     ;6413    23      # 
    inc hl                     ;6414    23      # 
    inc hl                     ;6415    23      # 
    jr l63feh                  ;6416    18 e6   . . 
l6418h:
    ld a,(de)                  ;6418    1a      .                  (flow from: 640c)
    cp 00ch                    ;6419    fe 0c   . .                (flow from: 6418)
    jr nz,l642ch               ;641b    20 0f     .                (flow from: 6419)
    set 1,b                    ;641d    cb c8   . .                (flow from: 641b)
    ex de,hl                   ;641f    eb      .                  (flow from: 641d)
    call sub_9623h             ;6420    cd 23 96    . # .          (flow from: 641f)
    push de                    ;6423    d5      .                  (flow from: 9628)
    ld de,(09853h)             ;6424    ed 5b 53 98     . [ S .    (flow from: 6423)
    add hl,de                  ;6428    19      .                  (flow from: 6424)
    pop de                     ;6429    d1      .                  (flow from: 6428)
    ex de,hl                   ;642a    eb      .                  (flow from: 6429)
l642bh:
    ld a,(de)                  ;642b    1a      .                  (flow from: 642a)
l642ch:
    cp 001h                    ;642c    fe 01   . .                (flow from: 641b 642b)
    jr nz,l6437h               ;642e    20 07     .                (flow from: 642c)
    set 1,b                    ;6430    cb c8   . . 
    call sub_65ebh             ;6432    cd eb 65    . . e 
    jr l642bh                  ;6435    18 f4   . . 
l6437h:
    cp 005h                    ;6437    fe 05   . .                (flow from: 642e)
    jr nz,l6445h               ;6439    20 0a     .                (flow from: 6437)
    set 1,b                    ;643b    cb c8   . . 
    call sub_65ebh             ;643d    cd eb 65    . . e 
    inc de                     ;6440    13      . 
    inc de                     ;6441    13      . 
    inc de                     ;6442    13      . 
    jr l642bh                  ;6443    18 e6   . . 
l6445h:
    cp 000h                    ;6445    fe 00   . .                (flow from: 6439)
    jr nz,l6467h               ;6447    20 1e     .                (flow from: 6445)
    cp (hl)                    ;6449    be      .                  (flow from: 6447)
    jr nz,l6450h               ;644a    20 04     .                (flow from: 6449)
    call sub_65f1h             ;644c    cd f1 65    . . e          (flow from: 644a)
    ret z                      ;644f    c8      .                  (flow from: 65f6)
l6450h:
    bit 0,b                    ;6450    cb 40   . @                (flow from: 644f)
    ld bc,(09855h)             ;6452    ed 4b 55 98     . K U .    (flow from: 6450)
    jr z,l64b8h                ;6456    28 60   ( `                (flow from: 6452)
    push de                    ;6458    d5      .                  (flow from: 6456)
    push hl                    ;6459    e5      .                  (flow from: 6458)
    call sub_6530h             ;645a    cd 30 65    . 0 e          (flow from: 6459)
    pop hl                     ;645d    e1      .                  (flow from: 656c)
    pop de                     ;645e    d1      .                  (flow from: 645d)
    ld a,(de)                  ;645f    1a      .                  (flow from: 645e)
    cp 000h                    ;6460    fe 00   . .                (flow from: 645f)
    jr nz,l64bdh               ;6462    20 59     Y                (flow from: 6460)
    ex de,hl                   ;6464    eb      .                  (flow from: 6462)
    jr l64bdh                  ;6465    18 56   . V                (flow from: 6464)
l6467h:
    ld a,(hl)                  ;6467    7e      ~                  (flow from: 6447)
    cp 000h                    ;6468    fe 00   . .                (flow from: 6467)
    jr nz,l647ch               ;646a    20 10     .                (flow from: 6468)
    ex de,hl                   ;646c    eb      .                  (flow from: 646a)
    bit 1,b                    ;646d    cb 48   . H                (flow from: 646c)
    ld bc,(09853h)             ;646f    ed 4b 53 98     . K S .    (flow from: 646d)
    jr z,l64b8h                ;6473    28 43   ( C                (flow from: 646f)
    push de                    ;6475    d5      .                  (flow from: 6473)
    call sub_6530h             ;6476    cd 30 65    . 0 e          (flow from: 6475)
    pop de                     ;6479    d1      .                  (flow from: 6574)
    jr l64bdh                  ;647a    18 41   . A                (flow from: 6479)
l647ch:
    ld a,(de)                  ;647c    1a      .                  (flow from: 646a)
    cp (hl)                    ;647d    be      .                  (flow from: 647c)
    ret nz                     ;647e    c0      .                  (flow from: 647d)
    cp 010h                    ;647f    fe 10   . .                (flow from: 647e)
    ret z                      ;6481    c8      .                  (flow from: 647f)
    cp 00ah                    ;6482    fe 0a   . .                (flow from: 6481)
    jr nz,l6497h               ;6484    20 11     .                (flow from: 6482)
    call sub_9623h             ;6486    cd 23 96    . # . 
    ex de,hl                   ;6489    eb      . 
    call sub_9623h             ;648a    cd 23 96    . # . 
    ld b,006h                  ;648d    06 06   . . 
l648fh:
    ld a,(de)                  ;648f    1a      . 
    cp (hl)                    ;6490    be      . 
    ret nz                     ;6491    c0      . 
    inc hl                     ;6492    23      # 
    inc de                     ;6493    13      . 
    djnz l648fh                ;6494    10 f9   . . 
    ret                        ;6496    c9      . 
l6497h:
    cp 003h                    ;6497    fe 03   . .                (flow from: 6484)
    call sub_9623h             ;6499    cd 23 96    . # .          (flow from: 6497)
    call sub_65ebh             ;649c    cd eb 65    . . e          (flow from: 9628)
    jr z,l64a5h                ;649f    28 04   ( .                (flow from: 65f0)
    or a                       ;64a1    b7      .                  (flow from: 649f)
    sbc hl,de                  ;64a2    ed 52   . R                (flow from: 64a1)
    ret                        ;64a4    c9      .                  (flow from: 64a2)
l64a5h:
    push de                    ;64a5    d5      .                  (flow from: 649f)
    push hl                    ;64a6    e5      .                  (flow from: 64a5)
    push bc                    ;64a7    c5      .                  (flow from: 64a6)
    call sub_63edh             ;64a8    cd ed 63    . . c          (flow from: 64a7)
    pop bc                     ;64ab    c1      .                  (flow from: 647e 64a4 6504)
    pop hl                     ;64ac    e1      .                  (flow from: 64ab)
    pop de                     ;64ad    d1      .                  (flow from: 64ac)
    ret nz                     ;64ae    c0      .                  (flow from: 64ad)
    inc de                     ;64af    13      .                  (flow from: 64ae)
    inc de                     ;64b0    13      .                  (flow from: 64af)
    inc de                     ;64b1    13      .                  (flow from: 64b0)
    inc hl                     ;64b2    23      #                  (flow from: 64b1)
    inc hl                     ;64b3    23      #                  (flow from: 64b2)
    inc hl                     ;64b4    23      #                  (flow from: 64b3)
    jp sub_63edh               ;64b5    c3 ed 63    . . c          (flow from: 64b4)
l64b8h:
    push de                    ;64b8    d5      .                  (flow from: 6473)
    call sub_6505h             ;64b9    cd 05 65    . . e          (flow from: 64b8)
    pop de                     ;64bc    d1      .                  (flow from: 6574)
l64bdh:
    push de                    ;64bd    d5      .                  (flow from: 6465 647a 64bc 6670)
    push ix                    ;64be    dd e5   . .                (flow from: 64bd)
    ld ix,(09847h)             ;64c0    dd 2a 47 98     . * G .    (flow from: 64be)
    ld l,(ix+00ah)             ;64c4    dd 6e 0a    . n .          (flow from: 64c0)
    ld h,(ix+00bh)             ;64c7    dd 66 0b    . f .          (flow from: 64c4)
    pop ix                     ;64ca    dd e1   . .                (flow from: 64c7)
    or a                       ;64cc    b7      .                  (flow from: 64ca)
    sbc hl,de                  ;64cd    ed 52   . R                (flow from: 64cc)
    jr c,l64d5h                ;64cf    38 04   8 .                (flow from: 64cd)
    ld a,00ch                  ;64d1    3e 0c   > .                (flow from: 64cf)
    jr l64eah                  ;64d3    18 15   . .                (flow from: 64d1)
l64d5h:
    ld hl,(0983bh)             ;64d5    2a 3b 98    *          ; . (flow from: 64cf)
    scf                        ;64d8    37      7                  (flow from: 64d5)
    sbc hl,de                  ;64d9    ed 52   . R                (flow from: 64d8)
    jr c,l64dfh                ;64db    38 02   8 .                (flow from: 64d9)
    jr l6502h                  ;64dd    18 23   . #                (flow from: 64db)
l64dfh:
    bit 0,e                    ;64df    cb 43   . C 
    ld a,001h                  ;64e1    3e 01   > . 
    jr z,l64eah                ;64e3    28 05   ( . 
    ld a,005h                  ;64e5    3e 05   > . 
    dec de                     ;64e7    1b      . 
    dec de                     ;64e8    1b      . 
    dec de                     ;64e9    1b      . 
l64eah:
    call sub_6593h             ;64ea    cd 93 65    . . e          (flow from: 64d3)
    push hl                    ;64ed    e5      .                  (flow from: 65ea)
    ld (hl),a                  ;64ee    77      w                  (flow from: 64ed)
    inc hl                     ;64ef    23      #                  (flow from: 64ee)
    ld (hl),e                  ;64f0    73      s                  (flow from: 64ef)
    inc hl                     ;64f1    23      #                  (flow from: 64f0)
    ld (hl),d                  ;64f2    72      r                  (flow from: 64f1)
    inc hl                     ;64f3    23      #                  (flow from: 64f2)
    ld de,(09849h)             ;64f4    ed 5b 49 98     . [ I .    (flow from: 64f3)
    ld (hl),003h               ;64f8    36 03   6 .                (flow from: 64f4)
    inc hl                     ;64fa    23      #                  (flow from: 64f8)
    ld (hl),e                  ;64fb    73      s                  (flow from: 64fa)
    inc hl                     ;64fc    23      #                  (flow from: 64fb)
    ld (hl),d                  ;64fd    72      r                  (flow from: 64fc)
    pop hl                     ;64fe    e1      .                  (flow from: 64fd)
    ld (09849h),hl             ;64ff    22 49 98    " I .          (flow from: 64fe)
l6502h:
    pop de                     ;6502    d1      .                  (flow from: 64dd 64ff)
    cp a                       ;6503    bf      .                  (flow from: 6502)
    ret                        ;6504    c9      .                  (flow from: 6503)
sub_6505h:
    ld a,(hl)                  ;6505    7e      ~                  (flow from: 64b9 651b 6526)
    cp 003h                    ;6506    fe 03   . .                (flow from: 6505)
    jr nz,l6528h               ;6508    20 1e     .                (flow from: 6506)
    push hl                    ;650a    e5      .                  (flow from: 6508)
    call sub_6593h             ;650b    cd 93 65    . . e          (flow from: 650a)
    ex de,hl                   ;650e    eb      .                  (flow from: 65ea)
    ld (hl),003h               ;650f    36 03   6 .                (flow from: 650e)
    inc hl                     ;6511    23      #                  (flow from: 650f)
    ld (hl),e                  ;6512    73      s                  (flow from: 6511)
    inc hl                     ;6513    23      #                  (flow from: 6512)
    ld (hl),d                  ;6514    72      r                  (flow from: 6513)
    pop hl                     ;6515    e1      .                  (flow from: 6514)
    call sub_9623h             ;6516    cd 23 96    . # .          (flow from: 6515)
    push de                    ;6519    d5      .                  (flow from: 9628)
    push hl                    ;651a    e5      .                  (flow from: 6519)
    call sub_6505h             ;651b    cd 05 65    . . e          (flow from: 651a)
    pop hl                     ;651e    e1      .                  (flow from: 6574)
    pop de                     ;651f    d1      .                  (flow from: 651e)
    inc hl                     ;6520    23      #                  (flow from: 651f)
    inc hl                     ;6521    23      #                  (flow from: 6520)
    inc hl                     ;6522    23      #                  (flow from: 6521)
    inc de                     ;6523    13      .                  (flow from: 6522)
    inc de                     ;6524    13      .                  (flow from: 6523)
    inc de                     ;6525    13      .                  (flow from: 6524)
    jr sub_6505h               ;6526    18 dd   . .                (flow from: 6525)
l6528h:
    cp 00ch                    ;6528    fe 0c   . .                (flow from: 6508 6531)
    jr nz,l6533h               ;652a    20 07     .                (flow from: 6528)
    call sub_9623h             ;652c    cd 23 96    . # .          (flow from: 652a)
    add hl,bc                  ;652f    09      .                  (flow from: 9628)
sub_6530h:
    ld a,(hl)                  ;6530    7e      ~                  (flow from: 645a 6476 652f)
    jr l6528h                  ;6531    18 f5   . .                (flow from: 6530)
l6533h:
    cp 001h                    ;6533    fe 01   . .                (flow from: 652a)
    jr nz,l653ch               ;6535    20 05     .                (flow from: 6533)
    call sub_9623h             ;6537    cd 23 96    . # . 
    jr sub_6530h               ;653a    18 f4   . . 
l653ch:
    cp 005h                    ;653c    fe 05   . .                (flow from: 6535)
    jr nz,l6548h               ;653e    20 08     .                (flow from: 653c)
    call sub_9623h             ;6540    cd 23 96    . # . 
    inc hl                     ;6543    23      # 
    inc hl                     ;6544    23      # 
    inc hl                     ;6545    23      # 
    jr sub_6530h               ;6546    18 e8   . . 
l6548h:
    cp 000h                    ;6548    fe 00   . .                (flow from: 653e)
    jr nz,l656dh               ;654a    20 21     !                (flow from: 6548)
    ld (de),a                  ;654c    12      .                  (flow from: 654a)
    call sub_65f1h             ;654d    cd f1 65    . . e          (flow from: 654c)
    jr nc,l6553h               ;6550    30 01   0 .                (flow from: 65f6)
    ex de,hl                   ;6552    eb      . 
l6553h:
    call sub_68d5h             ;6553    cd d5 68    . . h          (flow from: 6550)
    ld a,001h                  ;6556    3e 01   > .                (flow from: 68e8)
    jr nc,l655dh               ;6558    30 03   0 .                (flow from: 6556)
    ex de,hl                   ;655a    eb      .                  (flow from: 6558)
    jr l6566h                  ;655b    18 09   . .                (flow from: 655a)
l655dh:
    bit 0,l                    ;655d    cb 45   . E 
    jr z,l6566h                ;655f    28 05   ( . 
    dec hl                     ;6561    2b      + 
    dec hl                     ;6562    2b      + 
    dec hl                     ;6563    2b      + 
    ld a,005h                  ;6564    3e 05   > . 
l6566h:
    ex de,hl                   ;6566    eb      .                  (flow from: 655b)
    ld (hl),a                  ;6567    77      w                  (flow from: 6566)
    inc hl                     ;6568    23      #                  (flow from: 6567)
    ld (hl),e                  ;6569    73      s                  (flow from: 6568)
    inc hl                     ;656a    23      #                  (flow from: 6569)
    ld (hl),d                  ;656b    72      r                  (flow from: 656a)
    ret                        ;656c    c9      .                  (flow from: 656b)
l656dh:
    push bc                    ;656d    c5      .                  (flow from: 654a)
    ld bc,00003h               ;656e    01 03 00    . . .          (flow from: 656d)
    ldir                       ;6571    ed b0   . .                (flow from: 656e 6571)
    pop bc                     ;6573    c1      .                  (flow from: 6571)
    ret                        ;6574    c9      .                  (flow from: 6573)
sub_6575h:
    ld a,(hl)                  ;6575    7e      ~                  (flow from: 6079 60a3 60c9 60fd 6119 613f 6181 6622 668b 6a0e 6a25 6a3b 7d43 7dee 7e3f)
    cp 00ch                    ;6576    fe 0c   . .                (flow from: 6575)
    jr nz,l657fh               ;6578    20 05     .                (flow from: 6576)
    call sub_9623h             ;657a    cd 23 96    . # .          (flow from: 6578)
    add hl,de                  ;657d    19      .                  (flow from: 9628)
l657eh:
    ld a,(hl)                  ;657e    7e      ~                  (flow from: 657d 6586 6591)
l657fh:
    cp 001h                    ;657f    fe 01   . .                (flow from: 6578 657e)
    jr nz,l6588h               ;6581    20 05     .                (flow from: 657f)
    call sub_9623h             ;6583    cd 23 96    . # .          (flow from: 6581)
    jr l657eh                  ;6586    18 f6   . .                (flow from: 9628)
l6588h:
    cp 005h                    ;6588    fe 05   . .                (flow from: 6581)
    ret nz                     ;658a    c0      .                  (flow from: 6588)
    call sub_9623h             ;658b    cd 23 96    . # .          (flow from: 658a)
    inc hl                     ;658e    23      #                  (flow from: 9628)
    inc hl                     ;658f    23      #                  (flow from: 658e)
    inc hl                     ;6590    23      #                  (flow from: 658f)
    jr l657eh                  ;6591    18 eb   . .                (flow from: 6590)
sub_6593h:
    push de                    ;6593    d5      .                  (flow from: 64ea 650b 6caa 777a 778f 7a20 7dd4 7e49)
    push af                    ;6594    f5      .                  (flow from: 6593)
    ld de,(0985bh)             ;6595    ed 5b 5b 98     . [ [ .    (flow from: 6594)
    ld hl,0ffffh               ;6599    21 ff ff    ! . .          (flow from: 6595)
    or a                       ;659c    b7      .                  (flow from: 6599)
    sbc hl,de                  ;659d    ed 52   . R                (flow from: 659c)
    jr nz,l65bdh               ;659f    20 1c     .                (flow from: 659d)
    ld hl,(0985dh)             ;65a1    2a 5d 98    * ] .          (flow from: 659f)
    ld de,(0983bh)             ;65a4    ed 5b 3b 98     . [    ; . (flow from: 65a1)
    or a                       ;65a8    b7      .                  (flow from: 65a4)
    sbc hl,de                  ;65a9    ed 52   . R                (flow from: 65a8)
    ex de,hl                   ;65ab    eb      .                  (flow from: 65a9)
    jr c,l65cbh                ;65ac    38 1d   8 .                (flow from: 65ab)
    call sub_6713h             ;65ae    cd 13 67    . . g          (flow from: 65ac)
    ld de,(0985bh)             ;65b1    ed 5b 5b 98     . [ [ .    (flow from: 688b)
    ld hl,0ffffh               ;65b5    21 ff ff    ! . .          (flow from: 65b1)
    or a                       ;65b8    b7      .                  (flow from: 65b5)
    sbc hl,de                  ;65b9    ed 52   . R                (flow from: 65b8)
    jr z,l65c8h                ;65bb    28 0b   ( .                (flow from: 65b9)
l65bdh:
    ex de,hl                   ;65bd    eb      .                  (flow from: 659f 65bb)
    push hl                    ;65be    e5      .                  (flow from: 65bd)
    call sub_9623h             ;65bf    cd 23 96    . # .          (flow from: 65be)
    ld (0985bh),hl             ;65c2    22 5b 98    " [ .          (flow from: 9628)
    pop hl                     ;65c5    e1      .                  (flow from: 65c2)
    jr l65deh                  ;65c6    18 16   . .                (flow from: 65c5)
l65c8h:
    ld hl,(0983bh)             ;65c8    2a 3b 98    *          ; . 
l65cbh:
    ld de,0fffah               ;65cb    11 fa ff    . . .          (flow from: 65ac)
    add hl,de                  ;65ce    19      .                  (flow from: 65cb)
    ld de,(0984bh)             ;65cf    ed 5b 4b 98     . [ K .    (flow from: 65ce)
    push hl                    ;65d3    e5      .                  (flow from: 65cf)
    or a                       ;65d4    b7      .                  (flow from: 65d3)
    sbc hl,de                  ;65d5    ed 52   . R                (flow from: 65d4)
    pop hl                     ;65d7    e1      .                  (flow from: 65d5)
    jp c,l626ch                ;65d8    da 6c 62    . l b          (flow from: 65d7)
    ld (0983bh),hl             ;65db    22 3b 98    "          ; . (flow from: 65d8)
l65deh:
    ld (hl),010h               ;65de    36 10   6 .                (flow from: 65c6 65db)
    inc hl                     ;65e0    23      #                  (flow from: 65de)
    inc hl                     ;65e1    23      #                  (flow from: 65e0)
    inc hl                     ;65e2    23      #                  (flow from: 65e1)
    ld (hl),010h               ;65e3    36 10   6 .                (flow from: 65e2)
    dec hl                     ;65e5    2b      +                  (flow from: 65e3)
    dec hl                     ;65e6    2b      +                  (flow from: 65e5)
    dec hl                     ;65e7    2b      +                  (flow from: 65e6)
    pop af                     ;65e8    f1      .                  (flow from: 65e7)
    pop de                     ;65e9    d1      .                  (flow from: 65e8)
    ret                        ;65ea    c9      .                  (flow from: 65e9)
sub_65ebh:
    ex de,hl                   ;65eb    eb      .                  (flow from: 649c)
    call sub_9623h             ;65ec    cd 23 96    . # .          (flow from: 65eb)
    ex de,hl                   ;65ef    eb      .                  (flow from: 9628)
    ret                        ;65f0    c9      .                  (flow from: 65ef)
sub_65f1h:
    push hl                    ;65f1    e5      .                  (flow from: 6157 6346 644c 654d 679a 67dc 6b2f 7687 7e7d)
    or a                       ;65f2    b7      .                  (flow from: 65f1)
    sbc hl,de                  ;65f3    ed 52   . R                (flow from: 65f2)
    pop hl                     ;65f5    e1      .                  (flow from: 65f3)
    ret                        ;65f6    c9      .                  (flow from: 65f5)
l65f7h:
    ld de,00006h               ;65f7    11 06 00    . . .          (flow from: 69a2 6c4f 6f70 75e5 76c4 7736 948a 9546)
    ld b,008h                  ;65fa    06 08   . .                (flow from: 65f7)
    ld hl,09807h               ;65fc    21 07 98    ! . .          (flow from: 65fa)
l65ffh:
    ld (hl),0ffh               ;65ff    36 ff   6 .                (flow from: 65fc 6602)
    add hl,de                  ;6601    19      .                  (flow from: 65ff)
    djnz l65ffh                ;6602    10 fb   . .                (flow from: 6601)
    push ix                    ;6604    dd e5   . .                (flow from: 6602)
    ld ix,(09843h)             ;6606    dd 2a 43 98     . * C .    (flow from: 6604)
    exx                        ;660a    d9      .                  (flow from: 6606)
    ld e,(ix+00ah)             ;660b    dd 5e 0a    . ^ .          (flow from: 660a)
    ld d,(ix+00bh)             ;660e    dd 56 0b    . V .          (flow from: 660b)
    ld (09853h),de             ;6611    ed 53 53 98     . S S .    (flow from: 660e)
    ld ix,09807h               ;6615    dd 21 07 98     . ! . .    (flow from: 6611)
    ld (09861h),ix             ;6619    dd 22 61 98     . " a .    (flow from: 6615)
    pop ix                     ;661d    dd e1   . .                (flow from: 6619)
l661fh:
    ld hl,(0984fh)             ;661f    2a 4f 98    * O .          (flow from: 661d 66cb)
    call sub_6575h             ;6622    cd 75 65    . u e          (flow from: 661f)
    cp 010h                    ;6625    fe 10   . .                (flow from: 658a)
    jr nz,l667ah               ;6627    20 51     Q                (flow from: 6625)
    ld a,(ix+000h)             ;6629    dd 7e 00    . ~ .          (flow from: 6627)
    cp 0ffh                    ;662c    fe ff   . .                (flow from: 6629)
    jp z,l6701h                ;662e    ca 01 67    . . g          (flow from: 662c)
    ld e,a                     ;6631    5f      _                  (flow from: 662e)
    ld d,000h                  ;6632    16 00   . .                (flow from: 6631)
    ld hl,l663dh               ;6634    21 3d 66    ! = f          (flow from: 6632)
    push hl                    ;6637    e5      .                  (flow from: 6634)
    push ix                    ;6638    dd e5   . .                (flow from: 6637)
    pop hl                     ;663a    e1      .                  (flow from: 6638)
    add hl,de                  ;663b    19      .                  (flow from: 663a)
    jp (hl)                    ;663c    e9      .                  (flow from: 663b)
l663dh:
    ret nz                     ;663d    c0      .                  (flow from: 69fe 6c79 6c94 6ceb 6fa7 75f3 7609 76dd 77b3 9407 957d)
    ld de,00006h               ;663e    11 06 00    . . .          (flow from: 663d)
    exx                        ;6641    d9      .                  (flow from: 663e)
    ld b,008h                  ;6642    06 08   . .                (flow from: 6641)
    ld ix,09807h               ;6644    dd 21 07 98     . ! . .    (flow from: 6642)
l6648h:
    ld a,(ix+000h)             ;6648    dd 7e 00    . ~ .          (flow from: 6644 6677)
    cp 0ffh                    ;664b    fe ff   . .                (flow from: 6648)
    jr z,l6673h                ;664d    28 24   ( $                (flow from: 664b)
    ld e,(ix+001h)             ;664f    dd 5e 01    . ^ .          (flow from: 664d)
    ld d,(ix+002h)             ;6652    dd 56 02    . V .          (flow from: 664f)
    ld l,(ix+003h)             ;6655    dd 6e 03    . n .          (flow from: 6652)
    ld h,(ix+004h)             ;6658    dd 66 04    . f .          (flow from: 6655)
    cp 000h                    ;665b    fe 00   . .                (flow from: 6658)
    jr z,l6673h                ;665d    28 14   ( .                (flow from: 665b)
    ld a,(hl)                  ;665f    7e      ~                  (flow from: 665d)
    cp 000h                    ;6660    fe 00   . .                (flow from: 665f)
    jp nz,l6290h               ;6662    c2 90 62    . . b          (flow from: 6660)
    ld a,(ix+000h)             ;6665    dd 7e 00    . ~ .          (flow from: 6662)
    ld (hl),a                  ;6668    77      w                  (flow from: 6665)
    inc hl                     ;6669    23      #                  (flow from: 6668)
    ld (hl),e                  ;666a    73      s                  (flow from: 6669)
    inc hl                     ;666b    23      #                  (flow from: 666a)
    ld (hl),d                  ;666c    72      r                  (flow from: 666b)
    dec hl                     ;666d    2b      +                  (flow from: 666c)
    dec hl                     ;666e    2b      +                  (flow from: 666d)
    ex de,hl                   ;666f    eb      .                  (flow from: 666e)
    call l64bdh                ;6670    cd bd 64    . . d          (flow from: 666f)
l6673h:
    exx                        ;6673    d9      .                  (flow from: 6504 664d)
    add ix,de                  ;6674    dd 19   . .                (flow from: 6673)
    exx                        ;6676    d9      .                  (flow from: 6674)
    djnz l6648h                ;6677    10 cf   . .                (flow from: 6676)
    ret                        ;6679    c9      .                  (flow from: 6677)
l667ah:
    cp 003h                    ;667a    fe 03   . .                (flow from: 6627)
    jp nz,l6290h               ;667c    c2 90 62    . . b          (flow from: 667a)
    call sub_9623h             ;667f    cd 23 96    . # .          (flow from: 667c)
    inc hl                     ;6682    23      #                  (flow from: 9628)
    inc hl                     ;6683    23      #                  (flow from: 6682)
    inc hl                     ;6684    23      #                  (flow from: 6683)
    ld (0984fh),hl             ;6685    22 4f 98    " O .          (flow from: 6684)
    dec hl                     ;6688    2b      +                  (flow from: 6685)
    dec hl                     ;6689    2b      +                  (flow from: 6688)
    dec hl                     ;668a    2b      +                  (flow from: 6689)
    call sub_6575h             ;668b    cd 75 65    . u e          (flow from: 668a)
    ld b,a                     ;668e    47      G                  (flow from: 658a)
    cp 000h                    ;668f    fe 00   . .                (flow from: 668e)
    jr nz,l66ceh               ;6691    20 3b                  ;   (flow from: 668f)
    ld a,(ix+004h)             ;6693    dd 7e 04    . ~ .          (flow from: 6691)
    cp 0ffh                    ;6696    fe ff   . .                (flow from: 6693)
    jp z,l6290h                ;6698    ca 90 62    . . b          (flow from: 6696)
    push ix                    ;669b    dd e5   . .                (flow from: 6698)
    ld ix,(09861h)             ;669d    dd 2a 61 98     . * a .    (flow from: 669b)
    ld (ix+000h),000h          ;66a1    dd 36 00 00     . 6 . .    (flow from: 669d)
    ld (ix+001h),l             ;66a5    dd 75 01    . u .          (flow from: 66a1)
    ld (ix+002h),h             ;66a8    dd 74 02    . t .          (flow from: 66a5)
    pop ix                     ;66ab    dd e1   . .                (flow from: 66a8)
l66adh:
    push ix                    ;66ad    dd e5   . .                (flow from: 66ab 66ef 66ff)
    ld ix,(09861h)             ;66af    dd 2a 61 98     . * a .    (flow from: 66ad)
    ld (ix+003h),l             ;66b3    dd 75 03    . u .          (flow from: 66af)
    ld (ix+004h),h             ;66b6    dd 74 04    . t .          (flow from: 66b3)
    ld (ix+005h),b             ;66b9    dd 70 05    . p .          (flow from: 66b6)
    ld c,a                     ;66bc    4f      O                  (flow from: 66b9)
    ld b,000h                  ;66bd    06 00   . .                (flow from: 66bc)
    exx                        ;66bf    d9      .                  (flow from: 66bd)
    add ix,de                  ;66c0    dd 19   . .                (flow from: 66bf)
    ld (09861h),ix             ;66c2    dd 22 61 98     . " a .    (flow from: 66c0)
    pop ix                     ;66c6    dd e1   . .                (flow from: 66c2)
    exx                        ;66c8    d9      .                  (flow from: 66c6)
    add ix,bc                  ;66c9    dd 09   . .                (flow from: 66c8)
    jp l661fh                  ;66cb    c3 1f 66    . . f          (flow from: 66c9)
l66ceh:
    cp 00ah                    ;66ce    fe 0a   . .                (flow from: 6691)
    jr z,l66d6h                ;66d0    28 04   ( .                (flow from: 66ce)
    cp 004h                    ;66d2    fe 04   . .                (flow from: 66d0)
    jr nz,l66dfh               ;66d4    20 09     .                (flow from: 66d2)
l66d6h:
    ld a,(ix+001h)             ;66d6    dd 7e 01    . ~ . 
    cp 0ffh                    ;66d9    fe ff   . . 
    jr z,l6701h                ;66db    28 24   ( $ 
    jr l66eah                  ;66dd    18 0b   . . 
l66dfh:
    cp 008h                    ;66df    fe 08   . .                (flow from: 66d4)
    jr nz,l66f1h               ;66e1    20 0e     .                (flow from: 66df)
    ld a,(ix+002h)             ;66e3    dd 7e 02    . ~ .          (flow from: 66e1)
    cp 0ffh                    ;66e6    fe ff   . .                (flow from: 66e3)
    jr z,l6701h                ;66e8    28 17   ( .                (flow from: 66e6)
l66eah:
    push af                    ;66ea    f5      .                  (flow from: 66e8)
    call sub_9623h             ;66eb    cd 23 96    . # .          (flow from: 66ea)
    pop af                     ;66ee    f1      .                  (flow from: 9628)
    jr l66adh                  ;66ef    18 bc   . .                (flow from: 66ee)
l66f1h:
    cp 010h                    ;66f1    fe 10   . .                (flow from: 66e1)
    jr z,l66fah                ;66f3    28 05   ( .                (flow from: 66f1)
    cp 003h                    ;66f5    fe 03   . .                (flow from: 66f3)
    call nz,sub_6259h          ;66f7    c4 59 62    . Y b          (flow from: 66f5)
l66fah:
    ld a,(ix+003h)             ;66fa    dd 7e 03    . ~ .          (flow from: 66f7)
    cp 0ffh                    ;66fd    fe ff   . .                (flow from: 66fa)
    jr nz,l66adh               ;66ff    20 ac     .                (flow from: 66fd)
l6701h:
    push ix                    ;6701    dd e5   . . 
    pop hl                     ;6703    e1      . 
    ld b,004h                  ;6704    06 04   . . 
    ld a,0ffh                  ;6706    3e ff   > . 
l6708h:
    cp (hl)                    ;6708    be      . 
    ret nz                     ;6709    c0      . 
    inc hl                     ;670a    23      # 
    djnz l6708h                ;670b    10 fb   . . 
    cp (hl)                    ;670d    be      . 
    jp nz,l6290h               ;670e    c2 90 62    . . b 
    or a                       ;6711    b7      . 
    ret                        ;6712    c9      . 
sub_6713h:
    push af                    ;6713    f5      .                  (flow from: 65ae 93e6)
    push hl                    ;6714    e5      .                  (flow from: 6713)
    push de                    ;6715    d5      .                  (flow from: 6714)
    push bc                    ;6716    c5      .                  (flow from: 6715)
    push ix                    ;6717    dd e5   . .                (flow from: 6716)
    ld ix,(0983dh)             ;6719    dd 2a 3d 98     . * = .    (flow from: 6717)
l671dh:
    ld e,(ix+00ah)             ;671d    dd 5e 0a    . ^ .          (flow from: 6719 6750)
    ld d,(ix+00bh)             ;6720    dd 56 0b    . V .          (flow from: 671d)
    push ix                    ;6723    dd e5   . .                (flow from: 6720)
    pop hl                     ;6725    e1      .                  (flow from: 6723)
    or a                       ;6726    b7      .                  (flow from: 6725)
    sbc hl,de                  ;6727    ed 52   . R                (flow from: 6726)
    jr z,l6739h                ;6729    28 0e   ( .                (flow from: 6727)
    ld b,l                     ;672b    45      E                  (flow from: 6729)
    ex de,hl                   ;672c    eb      .                  (flow from: 672b)
l672dh:
    push bc                    ;672d    c5      .                  (flow from: 672c 6737)
    call sub_688ch             ;672e    cd 8c 68    . . h          (flow from: 672d)
    pop bc                     ;6731    c1      .                  (flow from: 68cf)
    inc hl                     ;6732    23      #                  (flow from: 6731)
    inc hl                     ;6733    23      #                  (flow from: 6732)
    inc hl                     ;6734    23      #                  (flow from: 6733)
    dec b                      ;6735    05      .                  (flow from: 6734)
    dec b                      ;6736    05      .                  (flow from: 6735)
    djnz l672dh                ;6737    10 f4   . .                (flow from: 6736)
l6739h:
    push ix                    ;6739    dd e5   . .                (flow from: 6737)
    pop de                     ;673b    d1      .                  (flow from: 6739)
    ld hl,(0983fh)             ;673c    2a 3f 98    * ? .          (flow from: 673b)
    or a                       ;673f    b7      .                  (flow from: 673c)
    sbc hl,de                  ;6740    ed 52   . R                (flow from: 673f)
    jr z,l6752h                ;6742    28 0e   ( .                (flow from: 6740)
    ld e,(ix+00ah)             ;6744    dd 5e 0a    . ^ .          (flow from: 6742)
    ld d,(ix+00bh)             ;6747    dd 56 0b    . V .          (flow from: 6744)
    ld ix,0fff4h               ;674a    dd 21 f4 ff     . ! . .    (flow from: 6747)
    add ix,de                  ;674e    dd 19   . .                (flow from: 674a)
    jr l671dh                  ;6750    18 cb   . .                (flow from: 674e)
l6752h:
    ld hl,(09845h)             ;6752    2a 45 98    * E .          (flow from: 6742)
    call sub_688ch             ;6755    cd 8c 68    . . h          (flow from: 6752)
    ld hl,(0984dh)             ;6758    2a 4d 98    * M .          (flow from: 68cf)
    call sub_688ch             ;675b    cd 8c 68    . . h          (flow from: 6758)
    ld hl,09b19h               ;675e    21 19 9b    ! . .          (flow from: 68cf)
    call sub_688ch             ;6761    cd 8c 68    . . h          (flow from: 675e)
    ld hl,l6962h               ;6764    21 62 69    ! b i          (flow from: 68cf)
    ld (09801h),hl             ;6767    22 01 98    " . .          (flow from: 6764)
    ld hl,09a93h               ;676a    21 93 9a    ! . .          (flow from: 6767)
    call sub_694ah             ;676d    cd 4a 69    . J i          (flow from: 676a)
    ld hl,09a96h               ;6770    21 96 9a    ! . .          (flow from: 694f)
    call sub_694ah             ;6773    cd 4a 69    . J i          (flow from: 6770)
    ld hl,(09a8eh)             ;6776    2a 8e 9a    * . .          (flow from: 694f)
    call l6962h                ;6779    cd 62 69    . b i          (flow from: 6776)
    ld b,008h                  ;677c    06 08   . .                (flow from: 68cf 6971)
    ld de,00006h               ;677e    11 06 00    . . .          (flow from: 677c)
    ld hl,09807h               ;6781    21 07 98    ! . .          (flow from: 677e)
l6784h:
    ld a,(hl)                  ;6784    7e      ~                  (flow from: 6781 678f)
    cp 0ffh                    ;6785    fe ff   . .                (flow from: 6784)
    jr z,l678eh                ;6787    28 05   ( .                (flow from: 6785)
    push bc                    ;6789    c5      .                  (flow from: 6787)
    call sub_688ch             ;678a    cd 8c 68    . . h          (flow from: 6789)
    pop bc                     ;678d    c1      .                  (flow from: 68cf)
l678eh:
    add hl,de                  ;678e    19      .                  (flow from: 6787 678d)
    djnz l6784h                ;678f    10 f3   . .                (flow from: 678e)
    ld hl,(09849h)             ;6791    2a 49 98    * I .          (flow from: 678f)
    ld bc,09849h               ;6794    01 49 98    . I .          (flow from: 6791)
    ld de,l849dh               ;6797    11 9d 84    . . .          (flow from: 6794)
l679ah:
    call sub_65f1h             ;679a    cd f1 65    . . e          (flow from: 6797 67d3)
    jr z,l67d5h                ;679d    28 36   ( 6                (flow from: 65f6)
    ld a,(hl)                  ;679f    7e      ~                  (flow from: 679d)
    cp 010h                    ;67a0    fe 10   . .                (flow from: 679f)
    jr z,l67bah                ;67a2    28 16   ( .                (flow from: 67a0)
    cp 00ch                    ;67a4    fe 0c   . .                (flow from: 67a2)
    jr z,l67c8h                ;67a6    28 20   (                  (flow from: 67a4)
    cp 001h                    ;67a8    fe 01   . . 
    jr z,l67b1h                ;67aa    28 05   ( . 
    cp 005h                    ;67ac    fe 05   . . 
    call nz,sub_6259h          ;67ae    c4 59 62    . Y b 
l67b1h:
    push hl                    ;67b1    e5      . 
    call sub_9623h             ;67b2    cd 23 96    . # . 
    bit 7,(hl)                 ;67b5    cb 7e   . ~ 
    pop hl                     ;67b7    e1      . 
    jr nz,l67c8h               ;67b8    20 0e     . 
l67bah:
    inc hl                     ;67ba    23      # 
    inc hl                     ;67bb    23      # 
    inc hl                     ;67bc    23      # 
    call sub_9623h             ;67bd    cd 23 96    . # . 
    ld a,l                     ;67c0    7d      } 
    ld (bc),a                  ;67c1    02      . 
    inc bc                     ;67c2    03      . 
    ld a,h                     ;67c3    7c      | 
    ld (bc),a                  ;67c4    02      . 
    dec bc                     ;67c5    0b      . 
    jr l679ah                  ;67c6    18 d2   . . 
l67c8h:
    set 7,(hl)                 ;67c8    cb fe   . .                (flow from: 67a6)
    inc hl                     ;67ca    23      #                  (flow from: 67c8)
    inc hl                     ;67cb    23      #                  (flow from: 67ca)
    inc hl                     ;67cc    23      #                  (flow from: 67cb)
    ld b,h                     ;67cd    44      D                  (flow from: 67cc)
    ld c,l                     ;67ce    4d      M                  (flow from: 67cd)
    inc bc                     ;67cf    03      .                  (flow from: 67ce)
    call sub_9623h             ;67d0    cd 23 96    . # .          (flow from: 67cf)
    jr l679ah                  ;67d3    18 c5   . .                (flow from: 9628)
l67d5h:
    ld de,(0983fh)             ;67d5    ed 5b 3f 98     . [ ? .    (flow from: 679d)
    ld hl,(0983dh)             ;67d9    2a 3d 98    * = .          (flow from: 67d5)
l67dch:
    call sub_65f1h             ;67dc    cd f1 65    . . e          (flow from: 67d9 6810)
    jr z,l6812h                ;67df    28 31   ( 1                (flow from: 65f6)
    push hl                    ;67e1    e5      .                  (flow from: 67df)
    pop ix                     ;67e2    dd e1   . .                (flow from: 67e1)
    ld l,(ix+008h)             ;67e4    dd 6e 08    . n .          (flow from: 67e2)
    ld h,(ix+009h)             ;67e7    dd 66 09    . f .          (flow from: 67e4)
    ld bc,l849dh               ;67ea    01 9d 84    . . .          (flow from: 67e7)
l67edh:
    push hl                    ;67ed    e5      .                  (flow from: 67ea)
    or a                       ;67ee    b7      .                  (flow from: 67ed)
    sbc hl,bc                  ;67ef    ed 42   . B                (flow from: 67ee)
    pop hl                     ;67f1    e1      .                  (flow from: 67ef)
    jr z,l6800h                ;67f2    28 0c   ( .                (flow from: 67f1)
    bit 7,(hl)                 ;67f4    cb 7e   . ~                (flow from: 67f2)
    jr nz,l6800h               ;67f6    20 08     .                (flow from: 67f4)
    inc hl                     ;67f8    23      # 
    inc hl                     ;67f9    23      # 
    inc hl                     ;67fa    23      # 
    call sub_9623h             ;67fb    cd 23 96    . # . 
    jr l67edh                  ;67fe    18 ed   . . 
l6800h:
    ld (ix+008h),l             ;6800    dd 75 08    . u .          (flow from: 67f6)
    ld (ix+009h),h             ;6803    dd 74 09    . t .          (flow from: 6800)
    ld c,(ix+00ah)             ;6806    dd 4e 0a    . N .          (flow from: 6803)
    ld b,(ix+00bh)             ;6809    dd 46 0b    . F .          (flow from: 6806)
    ld hl,0fff4h               ;680c    21 f4 ff    ! . .          (flow from: 6809)
    add hl,bc                  ;680f    09      .                  (flow from: 680c)
    jr l67dch                  ;6810    18 ca   . .                (flow from: 680f)
l6812h:
    call sub_68e9h             ;6812    cd e9 68    . . h          (flow from: 67df)
    ld hl,(0983bh)             ;6815    2a 3b 98    *          ; . (flow from: 6949)
    ld de,00006h               ;6818    11 06 00    . . .          (flow from: 6815)
l681bh:
    bit 7,(hl)                 ;681b    cb 7e   . ~                (flow from: 6818 6820)
    jr nz,l6822h               ;681d    20 03     .                (flow from: 681b)
    add hl,de                  ;681f    19      .                  (flow from: 681d)
    jr l681bh                  ;6820    18 f9   . .                (flow from: 681f)
l6822h:
    ld (0983bh),hl             ;6822    22 3b 98    "          ; . (flow from: 681d)
    ex de,hl                   ;6825    eb      .                  (flow from: 6822)
    ld hl,(09839h)             ;6826    2a 39 98    * 9 .          (flow from: 6825)
    ld bc,0985bh               ;6829    01 5b 98    . [ .          (flow from: 6826)
    exx                        ;682c    d9      .                  (flow from: 6829)
    push de                    ;682d    d5      .                  (flow from: 682c)
    push hl                    ;682e    e5      .                  (flow from: 682d)
    ld de,00006h               ;682f    11 06 00    . . .          (flow from: 682e)
    ld hl,00000h               ;6832    21 00 00    ! . .          (flow from: 682f)
    exx                        ;6835    d9      .                  (flow from: 6832)
l6836h:
    dec hl                     ;6836    2b      +                  (flow from: 6835 6847 6854)
    dec hl                     ;6837    2b      +                  (flow from: 6836)
    dec hl                     ;6838    2b      +                  (flow from: 6837)
    dec hl                     ;6839    2b      +                  (flow from: 6838)
    dec hl                     ;683a    2b      +                  (flow from: 6839)
    dec hl                     ;683b    2b      +                  (flow from: 683a)
    push hl                    ;683c    e5      .                  (flow from: 683b)
    or a                       ;683d    b7      .                  (flow from: 683c 684sh)
    sbc hl,de                  ;683e    ed 52   . R                (flow from: 683d)
    pop hl                     ;6840    e1      .                  (flow from: 683e)
    jr c,l6856h                ;6841    38 13   8 .                (flow from: 6840)
    bit 7,(hl)                 ;6843    cb 7e   . ~                (flow from: 6841)
    res 7,(hl)                 ;6845    cb be   . .                (flow from: 6843)
    jr nz,l6836h               ;6847    20 ed     .                (flow from: 6845)
    ld a,l                     ;6849    7d      }                  (flow from: 6847)
    ld (bc),a                  ;684a    02      .                  (flow from: 6849)
    ld a,h                     ;684b    7c      |                  (flow from: 684a)
    inc bc                     ;684c    03      .                  (flow from: 684b)
    ld (bc),a                  ;684d    02      .                  (flow from: 684c)
    ld b,h                     ;684e    44      D                  (flow from: 684d)
    ld c,l                     ;684f    4d      M                  (flow from: 684e)
    inc bc                     ;6850    03      .                  (flow from: 684f)
    exx                        ;6851    d9      .                  (flow from: 6850)
    add hl,de                  ;6852    19      .                  (flow from: 6851)
    exx                        ;6853    d9      .                  (flow from: 6852)
    jr l6836h                  ;6854    18 e0   . .                (flow from: 6853)
l6856h:
    ld a,0ffh                  ;6856    3e ff   > .                (flow from: 6841)
    ld (bc),a                  ;6858    02      .                  (flow from: 6856)
    inc bc                     ;6859    03      .                  (flow from: 6858)
    ld (bc),a                  ;685a    02      .                  (flow from: 6859)
    exx                        ;685b    d9      .                  (flow from: 685a)
    push hl                    ;685c    e5      .                  (flow from: 685b)
    ld hl,(0983bh)             ;685d    2a 3b 98    *          ; . (flow from: 685c)
    ld de,(0984bh)             ;6860    ed 5b 4b 98     . [ K .    (flow from: 685d)
    or a                       ;6864    b7      .                  (flow from: 6860)
    sbc hl,de                  ;6865    ed 52   . R                (flow from: 6864)
    pop de                     ;6867    d1      .                  (flow from: 6865)
    add hl,de                  ;6868    19      .                  (flow from: 6867)
    ld (0985fh),hl             ;6869    22 5f 98    " _ .          (flow from: 6868)
    ld d,h                     ;686c    54      T                  (flow from: 6869)
    ld e,l                     ;686d    5d      ]                  (flow from: 686c)
    srl h                      ;686e    cb 3c   . <                (flow from: 686d)
    rr l                       ;6870    cb 1d   . .                (flow from: 686e)
    srl h                      ;6872    cb 3c   . <                (flow from: 6870)
    rr l                       ;6874    cb 1d   . .                (flow from: 6872)
    ex de,hl                   ;6876    eb      .                  (flow from: 6874)
    or a                       ;6877    b7      .                  (flow from: 6876)
    sbc hl,de                  ;6878    ed 52   . R                (flow from: 6877)
    ld de,(0984bh)             ;687a    ed 5b 4b 98     . [ K .    (flow from: 6878)
    add hl,de                  ;687e    19      .                  (flow from: 687a)
    ld (0985dh),hl             ;687f    22 5d 98    " ] .          (flow from: 687e)
    pop hl                     ;6882    e1      .                  (flow from: 687f)
    pop de                     ;6883    d1      .                  (flow from: 6882)
    exx                        ;6884    d9      .                  (flow from: 6883)
    pop ix                     ;6885    dd e1   . .                (flow from: 6884)
    pop bc                     ;6887    c1      .                  (flow from: 6885)
    pop de                     ;6888    d1      .                  (flow from: 6887)
    pop hl                     ;6889    e1      .                  (flow from: 6888)
    pop af                     ;688a    f1      .                  (flow from: 6889)
    ret                        ;688b    c9      .                  (flow from: 688a)
sub_688ch:
    ld b,001h                  ;688c    06 01   . .                (flow from: 672e 6755 675b 6761 678a 696c 6976 6989)
    push hl                    ;688e    e5      .                  (flow from: 688c)
l688fh:
    ld a,(hl)                  ;688f    7e      ~                  (flow from: 688e 68a9 68d3)
    res 7,a                    ;6890    cb bf   . .                (flow from: 688f)
    bit 0,a                    ;6892    cb 47   . G                (flow from: 6890)
    jr z,l68abh                ;6894    28 15   ( .                (flow from: 6892)
    call sub_9623h             ;6896    cd 23 96    . # .          (flow from: 6894)
    bit 7,(hl)                 ;6899    cb 7e   . ~                (flow from: 9628)
    jr nz,l68cdh               ;689b    20 30     0                (flow from: 6899)
    call sub_68d5h             ;689d    cd d5 68    . . h          (flow from: 689b)
    jr c,l68cdh                ;68a0    38 2b   8 +                (flow from: 68e8)
    set 7,(hl)                 ;68a2    cb fe   . .                (flow from: 68a0)
    push hl                    ;68a4    e5      .                  (flow from: 68a2)
    inc b                      ;68a5    04      .                  (flow from: 68a4)
    call z,sub_6259h           ;68a6    cc 59 62    . Y b          (flow from: 68a5)
    jr l688fh                  ;68a9    18 e4   . .                (flow from: 68a6)
l68abh:
    cp 008h                    ;68ab    fe 08   . .                (flow from: 6894)
    jr nz,l68bbh               ;68ad    20 0c     .                (flow from: 68ab)
    call sub_9623h             ;68af    cd 23 96    . # .          (flow from: 68ad)
    call sub_7653h             ;68b2    cd 53 76    . S v          (flow from: 9628)
    jr nz,l68cdh               ;68b5    20 16     .                (flow from: 7662)
    set 7,(hl)                 ;68b7    cb fe   . .                (flow from: 68b5)
    jr l68cdh                  ;68b9    18 12   . .                (flow from: 68b7)
l68bbh:
    cp 00ah                    ;68bb    fe 0a   . .                (flow from: 68ad)
    jr nz,l68cdh               ;68bd    20 0e     .                (flow from: 68bb)
    call sub_9623h             ;68bf    cd 23 96    . # . 
    bit 7,(hl)                 ;68c2    cb 7e   . ~ 
    jr nz,l68cdh               ;68c4    20 07     . 
    call sub_68d5h             ;68c6    cd d5 68    . . h 
    jr c,l68cdh                ;68c9    38 02   8 . 
    set 7,(hl)                 ;68cb    cb fe   . . 
l68cdh:
    dec b                      ;68cd    05      .                  (flow from: 689b 68a0 68b5 68b9 68bd)
    pop hl                     ;68ce    e1      .                  (flow from: 68cd)
    ret z                      ;68cf    c8      .                  (flow from: 68ce)
    inc hl                     ;68d0    23      #                  (flow from: 68cf)
    inc hl                     ;68d1    23      #                  (flow from: 68d0)
    inc hl                     ;68d2    23      #                  (flow from: 68d1)
    jr l688fh                  ;68d3    18 ba   . .                (flow from: 68d2)
sub_68d5h:
    push de                    ;68d5    d5      .                  (flow from: 6553 689d)
    ex de,hl                   ;68d6    eb      .                  (flow from: 68d5)
    ld hl,(0984bh)             ;68d7    2a 4b 98    * K .          (flow from: 68cf 68d6)
    scf                        ;68da    37      7                  (flow from: 68d7)
    sbc hl,de                  ;68db    ed 52   . R                (flow from: 68da)
    ccf                        ;68dd    3f      ?                  (flow from: 68db)
    jr c,l68e6h                ;68de    38 06   8 .                (flow from: 68dd)
    ld hl,(09839h)             ;68e0    2a 39 98    * 9 .          (flow from: 68de)
    or a                       ;68e3    b7      .                  (flow from: 68e0)
    sbc hl,de                  ;68e4    ed 52   . R                (flow from: 68e3)
l68e6h:
    ex de,hl                   ;68e6    eb      .                  (flow from: 68de 68e4)
    pop de                     ;68e7    d1      .                  (flow from: 68e6)
    ret                        ;68e8    c9      .                  (flow from: 68e7)
sub_68e9h:
    ld hl,09a93h               ;68e9    21 93 9a    ! . .          (flow from: 6812)
    call sub_68f2h             ;68ec    cd f2 68    . . h          (flow from: 68e9)
    ld hl,09a96h               ;68ef    21 96 9a    ! . .          (flow from: 6949)
sub_68f2h:
    ld a,(hl)                  ;68f2    7e      ~                  (flow from: 68ec 68ef 693a 6942)
    cp 003h                    ;68f3    fe 03   . .                (flow from: 68f2)
    jr nz,l6944h               ;68f5    20 4d     M                (flow from: 68f3)
    push hl                    ;68f7    e5      .                  (flow from: 68f5)
    call sub_9623h             ;68f8    cd 23 96    . # .          (flow from: 68f7)
    push hl                    ;68fb    e5      .                  (flow from: 9628)
    ld a,(hl)                  ;68fc    7e      ~                  (flow from: 68fb)
    res 7,a                    ;68fd    cb bf   . .                (flow from: 68fc)
    cp 010h                    ;68ff    fe 10   . .                (flow from: 68fd)
    jr z,l693dh                ;6901    28 3a   ( :                (flow from: 68ff)
    cp 008h                    ;6903    fe 08   . .                (flow from: 6901)
    call nz,sub_6259h          ;6905    c4 59 62    . Y b          (flow from: 6903)
    call sub_9623h             ;6908    cd 23 96    . # .          (flow from: 6905)
    ld a,(hl)                  ;690b    7e      ~                  (flow from: 9628)
    bit 7,a                    ;690c    cb 7f   .                 (flow from: 690b)
    res 7,a                    ;690e    cb bf   . .                (flow from: 690c)
    ld (hl),a                  ;6910    77      w                  (flow from: 690e)
    jr nz,l692ah               ;6911    20 17     .                (flow from: 6910)
    cp 010h                    ;6913    fe 10   . .                (flow from: 6911)
    jr nz,l692ah               ;6915    20 13     .                (flow from: 6913)
    call sub_7b31h             ;6917    cd 31 7b    . 1 { 
    pop hl                     ;691a    e1      . 
    res 7,(hl)                 ;691b    cb be   . . 
    inc hl                     ;691d    23      # 
    inc hl                     ;691e    23      # 
    inc hl                     ;691f    23      # 
    pop de                     ;6920    d1      . 
    push de                    ;6921    d5      . 
    ld bc,00003h               ;6922    01 03 00    . . . 
    ldir                       ;6925    ed b0   . . 
    pop hl                     ;6927    e1      . 
    jr sub_68f2h               ;6928    18 c8   . . 
l692ah:
    cp 007h                    ;692a    fe 07   . .                (flow from: 6911 6915)
    jr nz,l693dh               ;692c    20 0f     .                (flow from: 692a)
    call sub_9623h             ;692e    cd 23 96    . # .          (flow from: 692c)
    inc hl                     ;6931    23      #                  (flow from: 9628)
    inc hl                     ;6932    23      #                  (flow from: 6931)
    inc hl                     ;6933    23      #                  (flow from: 6932)
    call sub_9623h             ;6934    cd 23 96    . # .          (flow from: 6933)
    inc hl                     ;6937    23      #                  (flow from: 9628)
    inc hl                     ;6938    23      #                  (flow from: 6937)
    inc hl                     ;6939    23      #                  (flow from: 6938)
    call sub_68f2h             ;693a    cd f2 68    . . h          (flow from: 6939)
l693dh:
    pop hl                     ;693d    e1      .                  (flow from: 692c 6949)
    pop af                     ;693e    f1      .                  (flow from: 693d)
    inc hl                     ;693f    23      #                  (flow from: 693e)
    inc hl                     ;6940    23      #                  (flow from: 693f)
    inc hl                     ;6941    23      #                  (flow from: 6940)
    jr sub_68f2h               ;6942    18 ae   . .                (flow from: 6941)
l6944h:
    cp 010h                    ;6944    fe 10   . .                (flow from: 68f5)
    call nz,sub_6259h          ;6946    c4 59 62    . Y b          (flow from: 6944)
    ret                        ;6949    c9      .                  (flow from: 6946)
sub_694ah:
    ld a,(hl)                  ;694a    7e      ~                  (flow from: 676d 6773 6960 6990 77af)
    res 7,a                    ;694b    cb bf   . .                (flow from: 694a)
    cp 010h                    ;694d    fe 10   . .                (flow from: 694b)
    ret z                      ;694f    c8      .                  (flow from: 694d)
    cp 003h                    ;6950    fe 03   . .                (flow from: 694f)
    call nz,sub_6259h          ;6952    c4 59 62    . Y b          (flow from: 6950)
    call sub_9623h             ;6955    cd 23 96    . # .          (flow from: 6952)
    push hl                    ;6958    e5      .                  (flow from: 9628)
    call 09800h                ;6959    cd 00 98    . . .          (flow from: 6958)
    pop hl                     ;695c    e1      .                  (flow from: 68cf 694f 6971 77f4)
    inc hl                     ;695d    23      #                  (flow from: 695c)
    inc hl                     ;695e    23      #                  (flow from: 695d)
    inc hl                     ;695f    23      #                  (flow from: 695e)
    jr sub_694ah               ;6960    18 e8   . .                (flow from: 695f)
l6962h:
    set 7,(hl)                 ;6962    cb fe   . .                (flow from: 6779 9800)
    call sub_9623h             ;6964    cd 23 96    . # .          (flow from: 6962)
    ld a,(hl)                  ;6967    7e      ~                  (flow from: 9628)
    res 7,a                    ;6968    cb bf   . .                (flow from: 6967)
    cp 003h                    ;696a    fe 03   . .                (flow from: 6968)
    jp z,sub_688ch             ;696c    ca 8c 68    . . h          (flow from: 696a)
    cp 007h                    ;696f    fe 07   . .                (flow from: 696c)
    ret nz                     ;6971    c0      .                  (flow from: 696f)
    call sub_9623h             ;6972    cd 23 96    . # .          (flow from: 6971)
    push hl                    ;6975    e5      .                  (flow from: 9628)
    call sub_688ch             ;6976    cd 8c 68    . . h          (flow from: 6975)
    pop hl                     ;6979    e1      .                  (flow from: 68cf)
    set 7,(hl)                 ;697a    cb fe   . .                (flow from: 6979)
    inc hl                     ;697c    23      #                  (flow from: 697a)
    inc hl                     ;697d    23      #                  (flow from: 697c)
    inc hl                     ;697e    23      #                  (flow from: 697d)
    ld a,(hl)                  ;697f    7e      ~                  (flow from: 697e)
    cp 003h                    ;6980    fe 03   . .                (flow from: 697f)
    ret nz                     ;6982    c0      .                  (flow from: 6980)
    call sub_9623h             ;6983    cd 23 96    . # .          (flow from: 6982)
    set 7,(hl)                 ;6986    cb fe   . .                (flow from: 9628)
    push hl                    ;6988    e5      .                  (flow from: 6986)
    call sub_688ch             ;6989    cd 8c 68    . . h          (flow from: 6988)
    pop hl                     ;698c    e1      .                  (flow from: 68cf)
    inc hl                     ;698d    23      #                  (flow from: 698c)
    inc hl                     ;698e    23      #                  (flow from: 698d)
    inc hl                     ;698f    23      #                  (flow from: 698e)
    jp sub_694ah               ;6990    c3 4a 69    . J i          (flow from: 698f)
    ex af,af'                  ;6993    08      . 
    sbc a,c                    ;6994    99      . 
    ld l,c                     ;6995    69      i 
    inc bc                     ;6996    03      . 
    cp a                       ;6997    bf      . 
    ld l,c                     ;6998    69      i 
    inc b                      ;6999    04      . 
    sbc a,(hl)                 ;699a    9e      . 
    ld l,c                     ;699b    69      i 
    ld d,a                     ;699c    57      W 
    rst 38h                    ;699d    ff      . 
    ld ix,l69a5h               ;699e    dd 21 a5 69     . ! . i    (flow from: 60bb)
    jp l65f7h                  ;69a2    c3 f7 65    . . e          (flow from: 699e)
l69a5h:
    rst 38h                    ;69a5    ff      . 
    rst 38h                    ;69a6    ff      . 
    dec b                      ;69a7    05      . 
    rst 38h                    ;69a8    ff      . 
    rst 38h                    ;69a9    ff      . 
    rst 38h                    ;69aa    ff      . 
    rst 38h                    ;69ab    ff      . 
    rst 38h                    ;69ac    ff      . 
    dec b                      ;69ad    05      . 
    rst 38h                    ;69ae    ff      . 
    dec b                      ;69af    05      . 
    rst 38h                    ;69b0    ff      . 
    rst 38h                    ;69b1    ff      . 
    rst 38h                    ;69b2    ff      . 
    rst 38h                    ;69b3    ff      . 
    ld hl,(0980ah)             ;69b4    2a 0a 98    * . .          (flow from: 663c)
    ld a,000h                  ;69b7    3e 00   > .                (flow from: 69b4)
    call sub_718fh             ;69b9    cd 8f 71    . . q          (flow from: 69b7)
    ret nz                     ;69bc    c0      .                  (flow from: 71a1)
    jr l69edh                  ;69bd    18 2e   . .                (flow from: 69bc)
    ex af,af'                  ;69bf    08      . 
    push bc                    ;69c0    c5      . 
    ld l,c                     ;69c1    69      i 
    inc bc                     ;69c2    03      . 
    dec a                      ;69c3    3d      = 
    ld l,h                     ;69c4    6c      l 
    inc b                      ;69c5    04      . 
    adc a,069h                 ;69c6    ce 69   . i 

; BLOCK 'WRITE_string' (start 0x69c8 end 0x69cd)
WRITE_string_start:
    defb 057h                  ;69c8    57      W 
    defb 052h                  ;69c9    52      R 
    defb 049h                  ;69ca    49      I 
    defb 054h                  ;69cb    54      T 
    defb 045h                  ;69cc    45      E 
WRITE_string_end:
    rst 38h                    ;69cd    ff      . 
    ld ix,l69d5h               ;69ce    dd 21 d5 69     . ! . i 
    jp l65f7h                  ;69d2    c3 f7 65    . . e 
l69d5h:
    rst 38h                    ;69d5    ff      . 
    rst 38h                    ;69d6    ff      . 
    dec b                      ;69d7    05      . 
    rst 38h                    ;69d8    ff      . 
    rst 38h                    ;69d9    ff      . 
    rst 38h                    ;69da    ff      . 
    rst 38h                    ;69db    ff      . 
    rst 38h                    ;69dc    ff      . 
    dec b                      ;69dd    05      . 
    rst 38h                    ;69de    ff      . 
    dec b                      ;69df    05      . 
    rst 38h                    ;69e0    ff      . 
    rst 38h                    ;69e1    ff      . 
    rst 38h                    ;69e2    ff      . 
    rst 38h                    ;69e3    ff      . 
    ld hl,(0980ah)             ;69e4    2a 0a 98    * . . 
    ld a,001h                  ;69e7    3e 01   > . 
    call sub_718fh             ;69e9    cd 8f 71    . . q 
    ret nz                     ;69ec    c0      . 
l69edh:
    ld hl,0ffffh               ;69ed    21 ff ff    ! . .          (flow from: 69bd)
    ld (0986fh),hl             ;69f0    22 6f 98    " o .          (flow from: 69ed)
    ld hl,(09810h)             ;69f3    2a 10 98    * . .          (flow from: 69f0)
    call sub_6a04h             ;69f6    cd 04 6a    . . j          (flow from: 69f3)
    ret nz                     ;69f9    c0      .                  (flow from: 6a35)
    ld a,(0986eh)              ;69fa    3a 6e 98    : n .          (flow from: 69f9)
    or a                       ;69fd    b7      .                  (flow from: 69fa)
    ret z                      ;69fe    c8      .                  (flow from: 69fd)
    call sub_7081h             ;69ff    cd 81 70    . . p 
    cp a                       ;6a02    bf      . 
    ret                        ;6a03    c9      . 
sub_6a04h:
    ld ix,(09843h)             ;6a04    dd 2a 43 98     . * C .    (flow from: 69f6)
    ld e,(ix+00ah)             ;6a08    dd 5e 0a    . ^ .          (flow from: 6a04)
    ld d,(ix+00bh)             ;6a0b    dd 56 0b    . V .          (flow from: 6a08)
    call sub_6575h             ;6a0e    cd 75 65    . u e          (flow from: 6a0b)
    ld b,000h                  ;6a11    06 00   . .                (flow from: 658a)
    cp 010h                    ;6a13    fe 10   . .                (flow from: 6a11)
    ret z                      ;6a15    c8      .                  (flow from: 6a13)
    cp 003h                    ;6a16    fe 03   . .                (flow from: 6a15)
    jr nz,l6a3bh               ;6a18    20 21     !                (flow from: 6a16)
l6a1ah:
    call sub_9623h             ;6a1a    cd 23 96    . # .          (flow from: 6a18)
    push hl                    ;6a1d    e5      .                  (flow from: 9628)
    call l6a3bh                ;6a1e    cd 3b 6a    .          ; j (flow from: 6a1d)
    pop hl                     ;6a21    e1      .                  (flow from: 6be3)
    inc hl                     ;6a22    23      #                  (flow from: 6a21)
    inc hl                     ;6a23    23      #                  (flow from: 6a22)
    inc hl                     ;6a24    23      #                  (flow from: 6a23)
    call sub_6575h             ;6a25    cd 75 65    . u e          (flow from: 6a24)
    cp 003h                    ;6a28    fe 03   . .                (flow from: 658a)
    jr nz,l6a33h               ;6a2a    20 07     .                (flow from: 6a28)
    ld a,020h                  ;6a2c    3e 20   >   
    call 0986bh                ;6a2e    cd 6b 98    . k . 
    jr l6a1ah                  ;6a31    18 e7   . . 
l6a33h:
    cp 010h                    ;6a33    fe 10   . .                (flow from: 6a2a)
    ret z                      ;6a35    c8      .                  (flow from: 6a33)
    ld a,07ch                  ;6a36    3e 7c   > | 
    call 0986bh                ;6a38    cd 6b 98    . k . 
l6a3bh:
    call sub_6575h             ;6a3b    cd 75 65    . u e          (flow from: 6a1e)
    cp 003h                    ;6a3e    fe 03   . .                (flow from: 658a)
    jr nz,l6a53h               ;6a40    20 11     .                (flow from: 6a3e)
    ld a,028h                  ;6a42    3e 28   > ( 
    call 0986bh                ;6a44    cd 6b 98    . k . 
    inc b                      ;6a47    04      . 
    call l6a1ah                ;6a48    cd 1a 6a    . . j 
    dec b                      ;6a4b    05      . 
    ld a,029h                  ;6a4c    3e 29   > ) 
    call 0986bh                ;6a4e    cd 6b 98    . k . 
    cp a                       ;6a51    bf      . 
    ret                        ;6a52    c9      . 
l6a53h:
    cp 004h                    ;6a53    fe 04   . .                (flow from: 6a40)
    jr nz,l6a5dh               ;6a55    20 06     .                (flow from: 6a53)
    call sub_9623h             ;6a57    cd 23 96    . # . 
    jp l6b0eh                  ;6a5a    c3 0e 6b    . . k 
l6a5dh:
    cp 00ah                    ;6a5d    fe 0a   . .                (flow from: 6a55)
    jr nz,l6a67h               ;6a5f    20 06     .                (flow from: 6a5d)
    call sub_9623h             ;6a61    cd 23 96    . # . 
    jp l6b56h                  ;6a64    c3 56 6b    . V k 
l6a67h:
    cp 010h                    ;6a67    fe 10   . .                (flow from: 6a5f)
    jr nz,l6a77h               ;6a69    20 0c     .                (flow from: 6a67)
    ld a,028h                  ;6a6b    3e 28   > ( 
    call 0986bh                ;6a6d    cd 6b 98    . k . 
    ld a,029h                  ;6a70    3e 29   > ) 
    call 0986bh                ;6a72    cd 6b 98    . k . 
    cp a                       ;6a75    bf      . 
    ret                        ;6a76    c9      . 
l6a77h:
    cp 008h                    ;6a77    fe 08   . .                (flow from: 6a69)
    jr nz,l6a84h               ;6a79    20 09     .                (flow from: 6a77)
    call sub_9623h             ;6a7b    cd 23 96    . # .          (flow from: 6a79)
    inc hl                     ;6a7e    23      #                  (flow from: 9628)
    inc hl                     ;6a7f    23      #                  (flow from: 6a7e)
    inc hl                     ;6a80    23      #                  (flow from: 6a7f)
    jp l6babh                  ;6a81    c3 ab 6b    . . k          (flow from: 6a80)
l6a84h:
    cp 000h                    ;6a84    fe 00   . . 
    call nz,sub_6259h          ;6a86    c4 59 62    . Y b 
    push de                    ;6a89    d5      . 
    push bc                    ;6a8a    c5      . 
    push ix                    ;6a8b    dd e5   . . 
    ex de,hl                   ;6a8d    eb      . 
    ld ix,098efh               ;6a8e    dd 21 ef 98     . ! . . 
    ld c,001h                  ;6a92    0e 01   . . 
l6a94h:
    ld a,(ix-07fh)             ;6a94    dd 7e 81    . ~ . 
    cp 0ffh                    ;6a97    fe ff   . . 
    jr z,l6aabh                ;6a99    28 10   ( . 
    ld l,(ix-080h)             ;6a9b    dd 6e 80    . n . 
    ld h,a                     ;6a9e    67      g 
    or a                       ;6a9f    b7      . 
    sbc hl,de                  ;6aa0    ed 52   . R 
    jr z,l6abah                ;6aa2    28 16   ( . 
    inc c                      ;6aa4    0c      . 
    inc ix                     ;6aa5    dd 23   . # 
    inc ix                     ;6aa7    dd 23   . # 
    jr l6a94h                  ;6aa9    18 e9   . . 
l6aabh:
    ld a,c                     ;6aab    79      y 
    cp 040h                    ;6aac    fe 40   . @ 
    jr z,l6acch                ;6aae    28 1c   ( . 
    ld (ix-080h),e             ;6ab0    dd 73 80    . s . 
    ld (ix-07fh),d             ;6ab3    dd 72 81    . r . 
    ld (ix-07dh),0ffh          ;6ab6    dd 36 83 ff     . 6 . . 
l6abah:
    ld h,000h                  ;6aba    26 00   & . 
    ld l,c                     ;6abc    69      i 
    call sub_6adah             ;6abd    cd da 6a    . . j 
    ld (ix+000h),e             ;6ac0    dd 73 00    . s . 
    ld (ix+001h),d             ;6ac3    dd 72 01    . r . 
l6ac6h:
    pop ix                     ;6ac6    dd e1   . . 
    pop bc                     ;6ac8    c1      . 
    pop de                     ;6ac9    d1      . 
    cp a                       ;6aca    bf      . 
    ret                        ;6acb    c9      . 
l6acch:
    ld a,(l718eh)              ;6acc    3a 8e 71    : . q 
    call 0986bh                ;6acf    cd 6b 98    . k . 
    call 0986bh                ;6ad2    cd 6b 98    . k . 
    call 0986bh                ;6ad5    cd 6b 98    . k . 
    jr l6ac6h                  ;6ad8    18 ec   . . 
sub_6adah:
    push hl                    ;6ada    e5      . 
    push bc                    ;6adb    c5      . 
    ld a,(l710dh)              ;6adc    3a 0d 71    : . q 
    ld b,a                     ;6adf    47      G 
    ld a,l                     ;6ae0    7d      } 
    ld c,000h                  ;6ae1    0e 00   . . 
l6ae3h:
    cp b                       ;6ae3    b8      . 
    jr z,l6aech                ;6ae4    28 06   ( . 
    jr c,l6aech                ;6ae6    38 04   8 . 
    inc c                      ;6ae8    0c      . 
    sub b                      ;6ae9    90      . 
    jr l6ae3h                  ;6aea    18 f7   . . 
l6aech:
    ld b,a                     ;6aec    47      G 
    ld e,c                     ;6aed    59      Y 
    ld hl,l710dh+1             ;6aee    21 0e 71    ! . q 
    ld a,000h                  ;6af1    3e 00   > . 
l6af3h:
    bit 6,(hl)                 ;6af3    cb 76   . v 
    jr nz,l6afbh               ;6af5    20 04     . 
l6af7h:
    inc hl                     ;6af7    23      # 
    inc a                      ;6af8    3c      < 
    jr l6af3h                  ;6af9    18 f8   . . 
l6afbh:
    djnz l6af7h                ;6afb    10 fa   . . 
    call 0986bh                ;6afd    cd 6b 98    . k . 
    ld d,a                     ;6b00    57      W 
    ld a,c                     ;6b01    79      y 
    or a                       ;6b02    b7      . 
    jr z,l6b0bh                ;6b03    28 06   ( . 
    ld l,c                     ;6b05    69      i 
    ld h,000h                  ;6b06    26 00   & . 
    call sub_6b26h             ;6b08    cd 26 6b    . & k 
l6b0bh:
    pop bc                     ;6b0b    c1      . 
    pop hl                     ;6b0c    e1      . 
    ret                        ;6b0d    c9      . 
l6b0eh:
    push hl                    ;6b0e    e5      . 
    push af                    ;6b0f    f5      . 
    bit 7,h                    ;6b10    cb 7c   . | 
    jr z,l6b20h                ;6b12    28 0c   ( . 
    ld a,02dh                  ;6b14    3e 2d   > - 
    call 0986bh                ;6b16    cd 6b 98    . k . 
    ld a,h                     ;6b19    7c      | 
    cpl                        ;6b1a    2f      / 
    ld h,a                     ;6b1b    67      g 
    ld a,l                     ;6b1c    7d      } 
    cpl                        ;6b1d    2f      / 
    ld l,a                     ;6b1e    6f      o 
    inc hl                     ;6b1f    23      # 
l6b20h:
    call sub_6b26h             ;6b20    cd 26 6b    . & k 
    pop af                     ;6b23    f1      . 
    pop hl                     ;6b24    e1      . 
    ret                        ;6b25    c9      . 
sub_6b26h:
    push hl                    ;6b26    e5      .                  (flow from: 969e)
    push af                    ;6b27    f5      .                  (flow from: 6b26)
    push de                    ;6b28    d5      .                  (flow from: 6b27)
    push bc                    ;6b29    c5      .                  (flow from: 6b28)
    ld de,0000ah               ;6b2a    11 0a 00    . . .          (flow from: 6b29)
    ld b,000h                  ;6b2d    06 00   . .                (flow from: 6b2a)
l6b2fh:
    call sub_65f1h             ;6b2f    cd f1 65    . . e          (flow from: 6b2d 6b46)
    jr c,l6b48h                ;6b32    38 14   8 .                (flow from: 65f6)
    xor a                      ;6b34    af      .                  (flow from: 6b32)
    push bc                    ;6b35    c5      .                  (flow from: 6b34)
    ld b,010h                  ;6b36    06 10   . .                (flow from: 6b35)
l6b38h:
    add hl,hl                  ;6b38    29      )                  (flow from: 6b36 6b41)
    rla                        ;6b39    17      .                  (flow from: 6b38)
    sub e                      ;6b3a    93      .                  (flow from: 6b39)
    jr c,l6b40h                ;6b3b    38 03   8 .                (flow from: 6b3a)
    inc hl                     ;6b3d    23      #                  (flow from: 6b3b)
    jr l6b41h                  ;6b3e    18 01   . .                (flow from: 6b3d)
l6b40h:
    add a,e                    ;6b40    83      .                  (flow from: 6b3b)
l6b41h:
    djnz l6b38h                ;6b41    10 f5   . .                (flow from: 6b3e 6b40)
    pop bc                     ;6b43    c1      .                  (flow from: 6b41)
    push af                    ;6b44    f5      .                  (flow from: 6b43)
    inc b                      ;6b45    04      .                  (flow from: 6b44)
    jr l6b2fh                  ;6b46    18 e7   . .                (flow from: 6b45)
l6b48h:
    ld a,l                     ;6b48    7d      }                  (flow from: 6b32)
    push af                    ;6b49    f5      .                  (flow from: 6b48)
    inc b                      ;6b4a    04      .                  (flow from: 6b49)
l6b4bh:
    pop af                     ;6b4b    f1      .                  (flow from: 6b4a 6b4f)
    call sub_6ba6h             ;6b4c    cd a6 6b    . . k          (flow from: 6b4b)
    djnz l6b4bh                ;6b4f    10 fa   . .                (flow from: 734b)
    pop bc                     ;6b51    c1      .                  (flow from: 6b4f)
    pop de                     ;6b52    d1      .                  (flow from: 6b51)
    pop af                     ;6b53    f1      .                  (flow from: 6b52)
    pop hl                     ;6b54    e1      .                  (flow from: 6b53)
    ret                        ;6b55    c9      .                  (flow from: 6b54)
l6b56h:
    push hl                    ;6b56    e5      . 
    push de                    ;6b57    d5      . 
    push bc                    ;6b58    c5      . 
    ld de,09b1fh               ;6b59    11 1f 9b    . . . 
    call sub_8e3dh             ;6b5c    cd 3d 8e    . = . 
    ex de,hl                   ;6b5f    eb      . 
    bit 3,(hl)                 ;6b60    cb 5e   . ^ 
    jr z,l6b69h                ;6b62    28 05   ( . 
    ld a,02dh                  ;6b64    3e 2d   > - 
    call 0986bh                ;6b66    cd 6b 98    . k . 
l6b69h:
    inc hl                     ;6b69    23      # 
    ld a,(hl)                  ;6b6a    7e      ~ 
    sub 081h                   ;6b6b    d6 81   . . 
    ld e,a                     ;6b6d    5f      _ 
    ld b,007h                  ;6b6e    06 07   . . 
    ld hl,09b29h               ;6b70    21 29 9b    ! ) . 
    xor a                      ;6b73    af      . 
l6b74h:
    cp (hl)                    ;6b74    be      . 
    dec hl                     ;6b75    2b      + 
    jr nz,l6b7bh               ;6b76    20 03     . 
    djnz l6b74h                ;6b78    10 fa   . . 
    inc b                      ;6b7a    04      . 
l6b7bh:
    ld hl,09b21h               ;6b7b    21 21 9b    ! ! . 
    call sub_6ba4h             ;6b7e    cd a4 6b    . . k 
    ld a,02eh                  ;6b81    3e 2e   > . 
    call 0986bh                ;6b83    cd 6b 98    . k . 
l6b86h:
    call sub_6ba4h             ;6b86    cd a4 6b    . . k 
    djnz l6b86h                ;6b89    10 fb   . . 
    ld a,e                     ;6b8b    7b      { 
    or a                       ;6b8c    b7      . 
    jr z,l6ba0h                ;6b8d    28 11   ( . 
    ld a,045h                  ;6b8f    3e 45   > E 
    call 0986bh                ;6b91    cd 6b 98    . k . 
    ld l,e                     ;6b94    6b      k 
    bit 7,e                    ;6b95    cb 7b   . { 
    ld h,000h                  ;6b97    26 00   & . 
    jr z,l6b9dh                ;6b99    28 02   ( . 
    ld h,0ffh                  ;6b9b    26 ff   & . 
l6b9dh:
    call l6b0eh                ;6b9d    cd 0e 6b    . . k 
l6ba0h:
    pop bc                     ;6ba0    c1      . 
    pop de                     ;6ba1    d1      . 
    pop hl                     ;6ba2    e1      . 
    ret                        ;6ba3    c9      . 
sub_6ba4h:
    inc hl                     ;6ba4    23      # 
    ld a,(hl)                  ;6ba5    7e      ~ 
sub_6ba6h:
    or 030h                    ;6ba6    f6 30   . 0                (flow from: 6b4c)
    jp 0986bh                  ;6ba8    c3 6b 98    . k .          (flow from: 6ba6)
l6babh:
    ld a,(0986eh)              ;6bab    3a 6e 98    : n .          (flow from: 6a81)
    or a                       ;6bae    b7      .                  (flow from: 6bab)
    call nz,sub_6beah          ;6baf    c4 ea 6b    . . k          (flow from: 6bae)
    jr z,l6be0h                ;6bb2    28 2c   ( ,                (flow from: 6baf)
    ld a,022h                  ;6bb4    3e 22   > " 
    call 0986bh                ;6bb6    cd 6b 98    . k . 
l6bb9h:
    ld a,(hl)                  ;6bb9    7e      ~ 
    cp 0ffh                    ;6bba    fe ff   . . 
    jr z,l6bdbh                ;6bbc    28 1d   ( . 
    cp 020h                    ;6bbe    fe 20   .   
    jr c,l6bcch                ;6bc0    38 0a   8 . 
    cp 040h                    ;6bc2    fe 40   . @ 
    jr z,l6bceh                ;6bc4    28 08   ( . 
    cp 022h                    ;6bc6    fe 22   . " 
    jr z,l6bceh                ;6bc8    28 04   ( . 
    jr l6bd5h                  ;6bca    18 09   . . 
l6bcch:
    add a,040h                 ;6bcc    c6 40   . @ 
l6bceh:
    push af                    ;6bce    f5      . 
    ld a,040h                  ;6bcf    3e 40   > @ 
    call 0986bh                ;6bd1    cd 6b 98    . k . 
    pop af                     ;6bd4    f1      . 
l6bd5h:
    call 0986bh                ;6bd5    cd 6b 98    . k . 
    inc hl                     ;6bd8    23      # 
    jr l6bb9h                  ;6bd9    18 de   . . 
l6bdbh:
    ld a,022h                  ;6bdb    3e 22   > " 
    jp 0986bh                  ;6bdd    c3 6b 98    . k . 
l6be0h:
    ld a,(hl)                  ;6be0    7e      ~                  (flow from: 6bb2 6be8)
    cp 0ffh                    ;6be1    fe ff   . .                (flow from: 6be0)
    ret z                      ;6be3    c8      .                  (flow from: 6be1)
    call 0986bh                ;6be4    cd 6b 98    . k .          (flow from: 6be3)
    inc hl                     ;6be7    23      #                  (flow from: 734b)
    jr l6be0h                  ;6be8    18 f6   . .                (flow from: 6be7)
sub_6beah:
    push hl                    ;6bea    e5      . 
    push bc                    ;6beb    c5      . 
    ld a,(hl)                  ;6bec    7e      ~ 
    call sub_6d05h             ;6bed    cd 05 6d    . . m 
    ld b,c                     ;6bf0    41      A 
    bit 6,c                    ;6bf1    cb 71   . q 
    jr z,l6bffh                ;6bf3    28 0a   ( . 
    inc hl                     ;6bf5    23      # 
    ld a,(hl)                  ;6bf6    7e      ~ 
    cp 0ffh                    ;6bf7    fe ff   . . 
    jr z,l6c2fh                ;6bf9    28 34   ( 4 
    ld b,001h                  ;6bfb    06 01   . . 
    jr l6c28h                  ;6bfd    18 29   . ) 
l6bffh:
    bit 7,c                    ;6bff    cb 79   . y 
    jr z,l6c14h                ;6c01    28 11   ( . 
    inc hl                     ;6c03    23      # 
    ld a,(hl)                  ;6c04    7e      ~ 
    call sub_6d05h             ;6c05    cd 05 6d    . . m 
    bit 0,c                    ;6c08    cb 41   . A 
    jr nz,l6c20h               ;6c0a    20 14     . 
    bit 3,c                    ;6c0c    cb 59   . Y 
    jr nz,l6c22h               ;6c0e    20 12     . 
    or a                       ;6c10    b7      . 
    pop bc                     ;6c11    c1      . 
    pop hl                     ;6c12    e1      . 
    ret                        ;6c13    c9      . 
l6c14h:
    bit 0,c                    ;6c14    cb 41   . A 
    jr nz,l6c20h               ;6c16    20 08     . 
    bit 3,c                    ;6c18    cb 59   . Y 
    jr nz,l6c22h               ;6c1a    20 06     . 
    or a                       ;6c1c    b7      . 
    pop bc                     ;6c1d    c1      . 
    pop hl                     ;6c1e    e1      . 
    ret                        ;6c1f    c9      . 
l6c20h:
    set 1,b                    ;6c20    cb c8   . . 
l6c22h:
    inc hl                     ;6c22    23      # 
    ld a,(hl)                  ;6c23    7e      ~ 
    cp 0ffh                    ;6c24    fe ff   . . 
    jr z,l6c31h                ;6c26    28 09   ( . 
l6c28h:
    call sub_6d05h             ;6c28    cd 05 6d    . . m 
    ld a,c                     ;6c2b    79      y 
    and b                      ;6c2c    a0      . 
    jr nz,l6c22h               ;6c2d    20 f3     . 
l6c2fh:
    or 001h                    ;6c2f    f6 01   . . 
l6c31h:
    pop bc                     ;6c31    c1      . 
    pop hl                     ;6c32    e1      . 
    ret                        ;6c33    c9      . 
sub_6c34h:
    cp 061h                    ;6c34    fe 61   . a 
    ret c                      ;6c36    d8      . 
    cp 07bh                    ;6c37    fe 7b   . { 
    ret nc                     ;6c39    d0      . 
    sub 020h                   ;6c3a    d6 20   .   
    ret                        ;6c3c    c9      . 
    ex af,af'                  ;6c3d    08      . 
    ld b,e                     ;6c3e    43      C 
    ld l,h                     ;6c3f    6c      l 
    inc bc                     ;6c40    03      . 
    inc b                      ;6c41    04      . 
    ld l,a                     ;6c42    6f      o 
    inc b                      ;6c43    04      . 
    ld c,e                     ;6c44    4b      K 
    ld l,h                     ;6c45    6c      l 

; BLOCK 'READ_string' (start 0x6c46 end 0x6c4a)
READ_string_start:
    defb 052h                  ;6c46    52      R 
    defb 045h                  ;6c47    45      E 
    defb 041h                  ;6c48    41      A 
    defb 044h                  ;6c49    44      D 
READ_string_end:
    rst 38h                    ;6c4a    ff      . 
    ld ix,l6c52h               ;6c4b    dd 21 52 6c     . ! R l    (flow from: 60bb)
    jp l65f7h                  ;6c4f    c3 f7 65    . . e          (flow from: 6c4b)
l6c52h:
    rst 38h                    ;6c52    ff      . 
    rst 38h                    ;6c53    ff      . 
    dec b                      ;6c54    05      . 
    rst 38h                    ;6c55    ff      . 
    rst 38h                    ;6c56    ff      . 
    rst 38h                    ;6c57    ff      . 
    rst 38h                    ;6c58    ff      . 
    rst 38h                    ;6c59    ff      . 
    rst 38h                    ;6c5a    ff      . 
    dec b                      ;6c5b    05      . 
    dec b                      ;6c5c    05      . 
    rst 38h                    ;6c5d    ff      . 
    rst 38h                    ;6c5e    ff      . 
    rst 38h                    ;6c5f    ff      . 
    rst 38h                    ;6c60    ff      . 
    ld hl,(0980ah)             ;6c61    2a 0a 98    * . .          (flow from: 663c)
    call sub_71d4h             ;6c64    cd d4 71    . . q          (flow from: 6c61)
    ret nz                     ;6c67    c0      .                  (flow from: 71ef 7224)
    ld a,0ffh                  ;6c68    3e ff   > .                (flow from: 6c67)
    ld (09870h),a              ;6c6a    32 70 98    2 p .          (flow from: 6c68)
l6c6dh:
    ld de,0980dh               ;6c6d    11 0d 98    . . .          (flow from: 6c6a)
    ld (09863h),sp             ;6c70    ed 73 63 98     . s c .    (flow from: 6c6d)
    ld b,000h                  ;6c74    06 00   . .                (flow from: 6c70)
sub_6c76h:
    call sub_6d84h             ;6c76    cd 84 6d    . . m          (flow from: 6c74 6c99)
    ret nz                     ;6c79    c0      .                  (flow from: 6d87 6d94 6dcf)
sub_6c7ah:
    cp 028h                    ;6c7a    fe 28   . (                (flow from: 6c79 6cb9)
    jr nz,l6cc3h               ;6c7c    20 45     E                (flow from: 6c7a)
    inc b                      ;6c7e    04      .                  (flow from: 6c7c)
l6c7fh:
    call sub_6d84h             ;6c7f    cd 84 6d    . . m          (flow from: 6c7e 6cc1)
    ret nz                     ;6c82    c0      .                  (flow from: 6d94 6dcf 6dd9 6e0f 6ed6)
    cp 029h                    ;6c83    fe 29   . )                (flow from: 6c82)
    jr nz,l6c95h               ;6c85    20 0e     .                (flow from: 6c83)
    dec b                      ;6c87    05      .                  (flow from: 6c85)
    ld a,010h                  ;6c88    3e 10   > .                (flow from: 6c87)
    ld (de),a                  ;6c8a    12      .                  (flow from: 6c88)
    ld a,0ffh                  ;6c8b    3e ff   > .                (flow from: 6c8a)
    inc de                     ;6c8d    13      .                  (flow from: 6c8b)
    ld (de),a                  ;6c8e    12      .                  (flow from: 6c8d)
    inc de                     ;6c8f    13      .                  (flow from: 6c8e)
    ld (de),a                  ;6c90    12      .                  (flow from: 6c8f)
    dec de                     ;6c91    1b      .                  (flow from: 6c90)
    dec de                     ;6c92    1b      .                  (flow from: 6c91)
    cp a                       ;6c93    bf      .                  (flow from: 6c92)
    ret                        ;6c94    c9      .                  (flow from: 6c93)
l6c95h:
    cp 07ch                    ;6c95    fe 7c   . |                (flow from: 6c85)
    jr nz,l6ca9h               ;6c97    20 10     .                (flow from: 6c95)
    call sub_6c76h             ;6c99    cd 76 6c    . v l          (flow from: 6c97)
    ret nz                     ;6c9c    c0      .                  (flow from: 6ceb)
    call sub_6d84h             ;6c9d    cd 84 6d    . . m          (flow from: 6c9c)
    ret nz                     ;6ca0    c0      .                  (flow from: 6d94)
    cp 029h                    ;6ca1    fe 29   . )                (flow from: 6ca0)
    jp nz,l6cech               ;6ca3    c2 ec 6c    . . l          (flow from: 6ca1)
    dec b                      ;6ca6    05      .                  (flow from: 6ca3)
    cp a                       ;6ca7    bf      .                  (flow from: 6ca6)
    ret                        ;6ca8    c9      .                  (flow from: 6ca7)
l6ca9h:
    push hl                    ;6ca9    e5      .                  (flow from: 6c97)
    call sub_6593h             ;6caa    cd 93 65    . . e          (flow from: 6ca9)
    push af                    ;6cad    f5      .                  (flow from: 65ea)
    ld a,003h                  ;6cae    3e 03   > .                (flow from: 6cad)
    ld (de),a                  ;6cb0    12      .                  (flow from: 6cae)
    pop af                     ;6cb1    f1      .                  (flow from: 6cb0)
    ex de,hl                   ;6cb2    eb      .                  (flow from: 6cb1)
    inc hl                     ;6cb3    23      #                  (flow from: 6cb2)
    ld (hl),e                  ;6cb4    73      s                  (flow from: 6cb3)
    inc hl                     ;6cb5    23      #                  (flow from: 6cb4)
    ld (hl),d                  ;6cb6    72      r                  (flow from: 6cb5)
    pop hl                     ;6cb7    e1      .                  (flow from: 6cb6)
    push de                    ;6cb8    d5      .                  (flow from: 6cb7)
    call sub_6c7ah             ;6cb9    cd 7a 6c    . z l          (flow from: 6cb8)
    pop de                     ;6cbc    d1      .                  (flow from: 6c94 6ca8 6ceb)
    ret nz                     ;6cbd    c0      .                  (flow from: 6cbc)
    inc de                     ;6cbe    13      .                  (flow from: 6cbd)
    inc de                     ;6cbf    13      .                  (flow from: 6cbe)
    inc de                     ;6cc0    13      .                  (flow from: 6cbf)
    jr l6c7fh                  ;6cc1    18 bc   . .                (flow from: 6cc0)
l6cc3h:
    cp 029h                    ;6cc3    fe 29   . )                (flow from: 6c7c)
    jp z,l6cech                ;6cc5    ca ec 6c    . . l          (flow from: 6cc3)
    cp 003h                    ;6cc8    fe 03   . .                (flow from: 6cc5)
    jr nz,l6cd9h               ;6cca    20 0d     .                (flow from: 6cc8)
    call sub_6d19h             ;6ccc    cd 19 6d    . . m          (flow from: 6cca)
    jr nz,l6ce1h               ;6ccf    20 10     .                (flow from: 6d25 6d76 6d83)
    ld (ix-080h),e             ;6cd1    dd 73 80    . s .          (flow from: 6ccf)
    ld (ix-07fh),d             ;6cd4    dd 72 81    . r .          (flow from: 6cd1)
    jr l6ce4h                  ;6cd7    18 0b   . .                (flow from: 6cd4)
l6cd9h:
    cp 004h                    ;6cd9    fe 04   . .                (flow from: 6cca)
    jr z,l6ce4h                ;6cdb    28 07   ( .                (flow from: 6cd9)
    cp 00ah                    ;6cdd    fe 0a   . .                (flow from: 6cdb)
    jr z,l6ce4h                ;6cdf    28 03   ( .                (flow from: 6cdd)
l6ce1h:
    call sub_79e6h             ;6ce1    cd e6 79    . . y          (flow from: 6ccf 6cdf)
l6ce4h:
    ld (de),a                  ;6ce4    12      .                  (flow from: 6cd7 6cdb 7a80)
    inc de                     ;6ce5    13      .                  (flow from: 6ce4)
    ex de,hl                   ;6ce6    eb      .                  (flow from: 6ce5)
    ld (hl),e                  ;6ce7    73      s                  (flow from: 6ce6)
    inc hl                     ;6ce8    23      #                  (flow from: 6ce7)
    ld (hl),d                  ;6ce9    72      r                  (flow from: 6ce8)
    cp a                       ;6cea    bf      .                  (flow from: 6ce9)
    ret                        ;6ceb    c9      .                  (flow from: 6cea)
l6cech:
    ld sp,(09863h)             ;6cec    ed 7b 63 98     . { c . 
    call sub_7296h             ;6cf0    cd 96 72    . . r 
    out (0f9h),a               ;6cf3    d3 f9   . . 
    xor 0f4h                   ;6cf5    ee f4   . . 
    pop hl                     ;6cf7    e1      . 
    ret m                      ;6cf8    f8      . 
    and b                      ;6cf9    a0      . 
    push bc                    ;6cfa    c5      . 
    jp p,0eff2h                ;6cfb    f2 f2 ef    . . . 
    jp p,00600h                ;6cfe    f2 00 06    . . . 
    nop                        ;6d01    00      . 
    jp sub_6c76h               ;6d02    c3 76 6c    . v l 
sub_6d05h:
    ld c,010h                  ;6d05    0e 10   . .                (flow from: 6d1d 6d88 6da2 6e3c 6edf)
    bit 7,a                    ;6d07    cb 7f   .                 (flow from: 6d05)
    ret nz                     ;6d09    c0      .                  (flow from: 6d07)
    push hl                    ;6d0a    e5      .                  (flow from: 6d09)
    push de                    ;6d0b    d5      .                  (flow from: 6d0a)
    ld de,l710dh+1             ;6d0c    11 0e 71    . . q          (flow from: 6d0b)
    ld l,a                     ;6d0f    6f      o                  (flow from: 6d0c)
    res 7,l                    ;6d10    cb bd   . .                (flow from: 6d0f)
    ld h,000h                  ;6d12    26 00   & .                (flow from: 6d10)
    add hl,de                  ;6d14    19      .                  (flow from: 6d12)
    ld c,(hl)                  ;6d15    4e      N                  (flow from: 6d14)
    pop de                     ;6d16    d1      .                  (flow from: 6d15)
    pop hl                     ;6d17    e1      .                  (flow from: 6d16)
    ret                        ;6d18    c9      .                  (flow from: 6d17 95ef)
sub_6d19h:
    ld hl,09ca5h               ;6d19    21 a5 9c    ! . .          (flow from: 6ccc)
    ld a,(hl)                  ;6d1c    7e      ~                  (flow from: 6d19)
    call sub_6d05h             ;6d1d    cd 05 6d    . . m          (flow from: 6d1c)
    bit 6,c                    ;6d20    cb 71   . q                (flow from: 6d18)
    jr nz,l6d26h               ;6d22    20 02     .                (flow from: 6d20)
    or a                       ;6d24    b7      .                  (flow from: 6d22)
    ret                        ;6d25    c9      .                  (flow from: 6d24)
l6d26h:
    push bc                    ;6d26    c5      .                  (flow from: 6d22)
    ld c,000h                  ;6d27    0e 00   . .                (flow from: 6d26)
    ld b,a                     ;6d29    47      G                  (flow from: 6d27)
l6d2ah:
    inc hl                     ;6d2a    23      #                  (flow from: 6d29 6d46)
    ld a,(hl)                  ;6d2b    7e      ~                  (flow from: 6d2a)
    cp 0feh                    ;6d2c    fe fe   . .                (flow from: 6d2b)
    jr z,l6d48h                ;6d2e    28 18   ( .                (flow from: 6d2c)
    cp 030h                    ;6d30    fe 30   . 0                (flow from: 6d2e)
    jr c,l6d82h                ;6d32    38 4e   8 N                (flow from: 6d30)
    cp 03ah                    ;6d34    fe 3a   . :                (flow from: 6d32)
    jr c,l6d3bh                ;6d36    38 03   8 .                (flow from: 6d34)
    or a                       ;6d38    b7      .                  (flow from: 6d36)
    jr l6d82h                  ;6d39    18 47   . G                (flow from: 6d38)
l6d3bh:
    and 00fh                   ;6d3b    e6 0f   . .                (flow from: 6d36)
    sla c                      ;6d3d    cb 21   . !                (flow from: 6d3b)
    add a,c                    ;6d3f    81      .                  (flow from: 6d3d)
    sla c                      ;6d40    cb 21   . !                (flow from: 6d3f)
    sla c                      ;6d42    cb 21   . !                (flow from: 6d40)
    add a,c                    ;6d44    81      .                  (flow from: 6d42)
    ld c,a                     ;6d45    4f      O                  (flow from: 6d44)
    jr l6d2ah                  ;6d46    18 e2   . .                (flow from: 6d45)
l6d48h:
    xor a                      ;6d48    af      .                  (flow from: 6d2e)
    ld ix,098efh               ;6d49    dd 21 ef 98     . ! . .    (flow from: 6d48)
l6d4dh:
    ld a,(ix-07fh)             ;6d4d    dd 7e 81    . ~ .          (flow from: 6d49 6d63)
    cp 0ffh                    ;6d50    fe ff   . .                (flow from: 6d4d)
    jr z,l6d77h                ;6d52    28 23   ( #                (flow from: 6d50)
    ld l,(ix+000h)             ;6d54    dd 6e 00    . n .          (flow from: 6d52)
    ld h,(ix+001h)             ;6d57    dd 66 01    . f .          (flow from: 6d54)
    or a                       ;6d5a    b7      .                  (flow from: 6d57)
    sbc hl,bc                  ;6d5b    ed 42   . B                (flow from: 6d5a)
    jr z,l6d65h                ;6d5d    28 06   ( .                (flow from: 6d5b)
    inc ix                     ;6d5f    dd 23   . #                (flow from: 6d5d)
    inc ix                     ;6d61    dd 23   . #                (flow from: 6d5f)
    jr l6d4dh                  ;6d63    18 e8   . .                (flow from: 6d61)
l6d65h:
    ld l,(ix-080h)             ;6d65    dd 6e 80    . n .          (flow from: 6d5d)
    ld h,a                     ;6d68    67      g                  (flow from: 6d65)
    bit 0,l                    ;6d69    cb 45   . E                (flow from: 6d68)
    ld a,001h                  ;6d6b    3e 01   > .                (flow from: 6d69)
    jr z,l6d74h                ;6d6d    28 05   ( .                (flow from: 6d6b)
    dec hl                     ;6d6f    2b      +                  (flow from: 6d6d)
    dec hl                     ;6d70    2b      +                  (flow from: 6d6f)
    dec hl                     ;6d71    2b      +                  (flow from: 6d70)
    ld a,005h                  ;6d72    3e 05   > .                (flow from: 6d71)
l6d74h:
    pop bc                     ;6d74    c1      .                  (flow from: 6d6d 6d72)
    cp a                       ;6d75    bf      .                  (flow from: 6d74)
    ret                        ;6d76    c9      .                  (flow from: 6d75)
l6d77h:
    ld (ix+000h),c             ;6d77    dd 71 00    . q .          (flow from: 6d52)
    ld (ix+001h),b             ;6d7a    dd 70 01    . p .          (flow from: 6d77)
    ld (ix-07dh),a             ;6d7d    dd 77 83    . w .          (flow from: 6d7a)
    ld a,000h                  ;6d80    3e 00   > .                (flow from: 6d7d)
l6d82h:
    pop bc                     ;6d82    c1      .                  (flow from: 6d39 6d80)
    ret                        ;6d83    c9      .                  (flow from: 6d82)
sub_6d84h:
    call 09865h                ;6d84    cd 65 98    . e .          (flow from: 6c76 6c7f 6c9d 6d8d)
    ret nz                     ;6d87    c0      .                  (flow from: 7427 9619)
    call sub_6d05h             ;6d88    cd 05 6d    . . m          (flow from: 6d87)
    bit 5,c                    ;6d8b    cb 69   . i                (flow from: 6d18)
    jr nz,sub_6d84h            ;6d8d    20 f5     .                (flow from: 6d8b)
    bit 2,c                    ;6d8f    cb 51   . Q                (flow from: 6d8d)
    jr z,l6d95h                ;6d91    28 02   ( .                (flow from: 6d8f)
    cp a                       ;6d93    bf      .                  (flow from: 6d91)
    ret                        ;6d94    c9      .                  (flow from: 6d93)
l6d95h:
    bit 7,c                    ;6d95    cb 79   . y                (flow from: 6d91)
    jr z,l6db8h                ;6d97    28 1f   ( .                (flow from: 6d95)
    push af                    ;6d99    f5      .                  (flow from: 6d97)
    call 09865h                ;6d9a    cd 65 98    . e .          (flow from: 6d99)
    jr z,l6da1h                ;6d9d    28 02   ( .                (flow from: 9619)
    pop af                     ;6d9f    f1      . 
    ret                        ;6da0    c9      . 
l6da1h:
    push bc                    ;6da1    c5      .                  (flow from: 6d9d)
    call sub_6d05h             ;6da2    cd 05 6d    . . m          (flow from: 6da1)
    bit 1,c                    ;6da5    cb 49   . I                (flow from: 6d18)
    pop bc                     ;6da7    c1      .                  (flow from: 6da5)
    jr z,l6db4h                ;6da8    28 0a   ( .                (flow from: 6da7)
    inc sp                     ;6daa    33      3                  (flow from: 6da8)
    inc sp                     ;6dab    33      3                  (flow from: 6daa)
    call 09868h                ;6dac    cd 68 98    . h .          (flow from: 6dab)
    ld a,008h                  ;6daf    3e 08   > .                (flow from: 9622)
    jp l6e1fh                  ;6db1    c3 1f 6e    . . n          (flow from: 6daf)
l6db4h:
    call 09868h                ;6db4    cd 68 98    . h . 
    pop af                     ;6db7    f1      . 
l6db8h:
    bit 1,c                    ;6db8    cb 49   . I                (flow from: 6d97)
    jr z,l6dc4h                ;6dba    28 08   ( .                (flow from: 6db8)
    call 09868h                ;6dbc    cd 68 98    . h .          (flow from: 6dba)
    ld a,000h                  ;6dbf    3e 00   > .                (flow from: 9622)
    jp l6e1fh                  ;6dc1    c3 1f 6e    . . n          (flow from: 6dbf)
l6dc4h:
    bit 0,c                    ;6dc4    cb 41   . A                (flow from: 6dba)
    jr z,l6dd0h                ;6dc6    28 08   ( .                (flow from: 6dc4)
    set 1,c                    ;6dc8    cb c9   . .                (flow from: 6dc6)
    call sub_6ed7h             ;6dca    cd d7 6e    . . n          (flow from: 6dc8)
    ld a,003h                  ;6dcd    3e 03   > .                (flow from: 6f03)
    ret                        ;6dcf    c9      .                  (flow from: 6dcd)
l6dd0h:
    bit 3,c                    ;6dd0    cb 59   . Y                (flow from: 6dc6)
    jr z,l6ddah                ;6dd2    28 06   ( .                (flow from: 6dd0)
    call sub_6ed7h             ;6dd4    cd d7 6e    . . n          (flow from: 6dd2)
    ld a,002h                  ;6dd7    3e 02   > .                (flow from: 6f03)
    ret                        ;6dd9    c9      .                  (flow from: 6dd7)
l6ddah:
    cp 022h                    ;6dda    fe 22   . "                (flow from: 6dd2)
    jr nz,l6e10h               ;6ddc    20 32     2                (flow from: 6dda)
    ld hl,09ca5h               ;6dde    21 a5 9c    ! . .          (flow from: 6ddc)
    push de                    ;6de1    d5      .                  (flow from: 6dde)
    ld d,03ch                  ;6de2    16 3c   . <                (flow from: 6de1)
l6de4h:
    call 09865h                ;6de4    cd 65 98    . e .          (flow from: 6de2 6e07)
    jr nz,l6e0eh               ;6de7    20 25     %                (flow from: 9619)
    cp 022h                    ;6de9    fe 22   . "                (flow from: 6de7)
    jr z,l6e09h                ;6deb    28 1c   ( .                (flow from: 6de9)
    cp 040h                    ;6ded    fe 40   . @                (flow from: 6deb)
    jr nz,l6e00h               ;6def    20 0f     .                (flow from: 6ded)
    call 09865h                ;6df1    cd 65 98    . e .          (flow from: 6def)
    jr nz,l6e0eh               ;6df4    20 18     .                (flow from: 9619)
    cp 041h                    ;6df6    fe 41   . A                (flow from: 6df4)
    jr c,l6e00h                ;6df8    38 06   8 .                (flow from: 6df6)
    cp 060h                    ;6dfa    fe 60   . `                (flow from: 6df8)
    jr nc,l6e00h               ;6dfc    30 02   0 .                (flow from: 6dfa)
    sub 040h                   ;6dfe    d6 40   . @                (flow from: 6dfc)
l6e00h:
    inc d                      ;6e00    14      .                  (flow from: 6def 6dfe)
    dec d                      ;6e01    15      .                  (flow from: 6e00)
    jr z,l6de4h                ;6e02    28 e0   ( .                (flow from: 6e01)
    ld (hl),a                  ;6e04    77      w                  (flow from: 6e02)
    dec d                      ;6e05    15      .                  (flow from: 6e04)
    inc hl                     ;6e06    23      #                  (flow from: 6e05)
    jr l6de4h                  ;6e07    18 db   . .                (flow from: 6e06)
l6e09h:
    ld (hl),0feh               ;6e09    36 fe   6 .                (flow from: 6deb)
    ld a,005h                  ;6e0b    3e 05   > .                (flow from: 6e09)
    cp a                       ;6e0d    bf      .                  (flow from: 6e0b)
l6e0eh:
    pop de                     ;6e0e    d1      .                  (flow from: 6e0d)
    ret                        ;6e0f    c9      .                  (flow from: 6e0e)
l6e10h:
    bit 4,c                    ;6e10    cb 61   . a 
    jp z,sub_6d84h             ;6e12    ca 84 6d    . . m 
    ld h,0feh                  ;6e15    26 fe   & . 
    ld l,a                     ;6e17    6f      o 
    ld (09ca5h),hl             ;6e18    22 a5 9c    " . . 
    ld a,008h                  ;6e1b    3e 08   > . 
    cp a                       ;6e1d    bf      . 
    ret                        ;6e1e    c9      . 
l6e1fh:
    push de                    ;6e1f    d5      .                  (flow from: 6db1 6dc1)
    push bc                    ;6e20    c5      .                  (flow from: 6e1f)
    ld hl,09b31h               ;6e21    21 31 9b    ! 1 .          (flow from: 6e20)
    ld b,012h                  ;6e24    06 12   . .                (flow from: 6e21)
l6e26h:
    ld (hl),000h               ;6e26    36 00   6 .                (flow from: 6e24 6e29)
    dec hl                     ;6e28    2b      +                  (flow from: 6e26)
    djnz l6e26h                ;6e29    10 fb   . .                (flow from: 6e28)
    ld (hl),a                  ;6e2b    77      w                  (flow from: 6e29)
    inc hl                     ;6e2c    23      #                  (flow from: 6e2b)
    inc hl                     ;6e2d    23      #                  (flow from: 6e2c)
    ld b,009h                  ;6e2e    06 09   . .                (flow from: 6e2d)
    ld e,000h                  ;6e30    1e 00   . .                (flow from: 6e2e)
l6e32h:
    call 09865h                ;6e32    cd 65 98    . e .          (flow from: 6e30 6e3a)
    jp nz,l6ed4h               ;6e35    c2 d4 6e    . . n          (flow from: 9619)
    cp 030h                    ;6e38    fe 30   . 0                (flow from: 6e35)
    jr z,l6e32h                ;6e3a    28 f6   ( .                (flow from: 6e38)
l6e3ch:
    call sub_6d05h             ;6e3c    cd 05 6d    . . m          (flow from: 6e3a 6e54)
    bit 1,c                    ;6e3f    cb 49   . I                (flow from: 6d18)
    jr z,l6e56h                ;6e41    28 13   ( .                (flow from: 6e3f)
    inc e                      ;6e43    1c      .                  (flow from: 6e41)
    dec b                      ;6e44    05      .                  (flow from: 6e43)
    jr nz,l6e4ah               ;6e45    20 03     .                (flow from: 6e44)
    inc b                      ;6e47    04      . 
    jr l6e4eh                  ;6e48    18 04   . . 
l6e4ah:
    inc hl                     ;6e4a    23      #                  (flow from: 6e45)
    and 00fh                   ;6e4b    e6 0f   . .                (flow from: 6e4a)
    ld (hl),a                  ;6e4d    77      w                  (flow from: 6e4b)
l6e4eh:
    call 09865h                ;6e4e    cd 65 98    . e .          (flow from: 6e4d)
    jp nz,l6ed4h               ;6e51    c2 d4 6e    . . n          (flow from: 9619)
    jr l6e3ch                  ;6e54    18 e6   . .                (flow from: 6e51)
l6e56h:
    cp 02eh                    ;6e56    fe 2e   . .                (flow from: 6e41)
    jr nz,l6eb1h               ;6e58    20 57     W                (flow from: 6e56)
l6e5ah:
    call 09865h                ;6e5a    cd 65 98    . e . 
    jr nz,l6ed4h               ;6e5d    20 75     u 
    call sub_6d05h             ;6e5f    cd 05 6d    . . m 
    bit 1,c                    ;6e62    cb 49   . I 
    jr z,l6e72h                ;6e64    28 0c   ( . 
    dec b                      ;6e66    05      . 
    jr nz,l6e6ch               ;6e67    20 03     . 
    inc b                      ;6e69    04      . 
    jr l6e5ah                  ;6e6a    18 ee   . . 
l6e6ch:
    inc hl                     ;6e6c    23      # 
    and 00fh                   ;6e6d    e6 0f   . . 
    ld (hl),a                  ;6e6f    77      w 
    jr l6e5ah                  ;6e70    18 e8   . . 
l6e72h:
    cp 045h                    ;6e72    fe 45   . E 
    jr z,l6e7ah                ;6e74    28 04   ( . 
    cp 065h                    ;6e76    fe 65   . e 
    jr nz,l6eb1h               ;6e78    20 37     7 
l6e7ah:
    call 09865h                ;6e7a    cd 65 98    . e . 
    jr nz,l6ed4h               ;6e7d    20 55     U 
    cp 02dh                    ;6e7f    fe 2d   . - 
    ld d,000h                  ;6e81    16 00   . . 
    jr nz,l6e89h               ;6e83    20 04     . 
    ld d,001h                  ;6e85    16 01   . . 
    ld a,030h                  ;6e87    3e 30   > 0 
l6e89h:
    ld b,000h                  ;6e89    06 00   . . 
l6e8bh:
    call sub_6d05h             ;6e8b    cd 05 6d    . . m 
    bit 1,c                    ;6e8e    cb 49   . I 
    jr z,l6ea6h                ;6e90    28 14   ( . 
    and 00fh                   ;6e92    e6 0f   . . 
    ld c,a                     ;6e94    4f      O 
    sla b                      ;6e95    cb 20   .   
    ld a,b                     ;6e97    78      x 
    sla b                      ;6e98    cb 20   .   
    sla b                      ;6e9a    cb 20   .   
    add a,b                    ;6e9c    80      . 
    add a,c                    ;6e9d    81      . 
    ld b,a                     ;6e9e    47      G 
    call 09865h                ;6e9f    cd 65 98    . e . 
    jr nz,l6ed4h               ;6ea2    20 30     0 
    jr l6e8bh                  ;6ea4    18 e5   . . 
l6ea6h:
    push af                    ;6ea6    f5      . 
    ld a,d                     ;6ea7    7a      z 
    or a                       ;6ea8    b7      . 
    ld a,b                     ;6ea9    78      x 
    jr z,l6eaeh                ;6eaa    28 02   ( . 
    neg                        ;6eac    ed 44   . D 
l6eaeh:
    add a,e                    ;6eae    83      . 
    ld e,a                     ;6eaf    5f      _ 
    pop af                     ;6eb0    f1      . 
l6eb1h:
    call 09868h                ;6eb1    cd 68 98    . h .          (flow from: 6e58)
    ld a,e                     ;6eb4    7b      {                  (flow from: 9622)
    add a,080h                 ;6eb5    c6 80   . .                (flow from: 6eb4)
    ld (09b20h),a              ;6eb7    32 20 9b    2   .          (flow from: 6eb5)
    ld hl,09b1fh               ;6eba    21 1f 9b    ! . .          (flow from: 6eb7)
    call sub_8e7dh             ;6ebd    cd 7d 8e    . } .          (flow from: 6eba)
    call sub_90bch             ;6ec0    cd bc 90    . . .          (flow from: 8ec7)
    jr nz,l6ecah               ;6ec3    20 05     .                (flow from: 9116)
    ex de,hl                   ;6ec5    eb      .                  (flow from: 6ec3)
    ld a,004h                  ;6ec6    3e 04   > .                (flow from: 6ec5)
    jr l6ed4h                  ;6ec8    18 0a   . .                (flow from: 6ec6)
l6ecah:
    ex de,hl                   ;6eca    eb      . 
    call sub_6593h             ;6ecb    cd 93 65    . . e 
    call sub_8e63h             ;6ece    cd 63 8e    . c . 
    cp a                       ;6ed1    bf      . 
    ld a,00ah                  ;6ed2    3e 0a   > . 
l6ed4h:
    pop bc                     ;6ed4    c1      .                  (flow from: 6ec8)
    pop de                     ;6ed5    d1      .                  (flow from: 6ed4)
    ret                        ;6ed6    c9      .                  (flow from: 6ed5)
sub_6ed7h:
    ld hl,09ca5h               ;6ed7    21 a5 9c    ! . .          (flow from: 6dca 6dd4)
    push de                    ;6eda    d5      .                  (flow from: 6ed7)
    push bc                    ;6edb    c5      .                  (flow from: 6eda)
    ld d,03ch                  ;6edc    16 3c   . <                (flow from: 6edb)
    ld b,c                     ;6ede    41      A                  (flow from: 6edc)
l6edfh:
    call sub_6d05h             ;6edf    cd 05 6d    . . m          (flow from: 6ede 6ef8)
    push af                    ;6ee2    f5      .                  (flow from: 6d18)
    ld a,c                     ;6ee3    79      y                  (flow from: 6ee2)
    and b                      ;6ee4    a0      .                  (flow from: 6ee3)
    jr z,l6efah                ;6ee5    28 13   ( .                (flow from: 6ee4)
    pop af                     ;6ee7    f1      .                  (flow from: 6ee5)
    inc d                      ;6ee8    14      .                  (flow from: 6ee7)
    dec d                      ;6ee9    15      .                  (flow from: 6ee8)
    jr z,l6eefh                ;6eea    28 03   ( .                (flow from: 6ee9)
    ld (hl),a                  ;6eec    77      w                  (flow from: 6eea)
    inc hl                     ;6eed    23      #                  (flow from: 6eec)
    dec d                      ;6eee    15      .                  (flow from: 6eed)
l6eefh:
    push bc                    ;6eef    c5      .                  (flow from: 6eee)
    ld b,000h                  ;6ef0    06 00   . .                (flow from: 6eef)
    call 09865h                ;6ef2    cd 65 98    . e .          (flow from: 6ef0)
    pop bc                     ;6ef5    c1      .                  (flow from: 7427 9619)
    jr nz,l6f01h               ;6ef6    20 09     .                (flow from: 6ef5)
    jr l6edfh                  ;6ef8    18 e5   . .                (flow from: 6ef6)
l6efah:
    pop af                     ;6efa    f1      .                  (flow from: 6ee5)
    call 09868h                ;6efb    cd 68 98    . h .          (flow from: 6efa)
    ld (hl),0feh               ;6efe    36 fe   6 .                (flow from: 742e 9622)
    cp a                       ;6f00    bf      .                  (flow from: 6efe)
l6f01h:
    pop bc                     ;6f01    c1      .                  (flow from: 6f00)
    pop de                     ;6f02    d1      .                  (flow from: 6f01)
    ret                        ;6f03    c9      .                  (flow from: 6f02)
    ex af,af'                  ;6f04    08      . 
    ld a,(bc)                  ;6f05    0a      . 
    ld l,a                     ;6f06    6f      o 
    inc bc                     ;6f07    03      . 
    ld e,l                     ;6f08    5d      ] 
    ld l,a                     ;6f09    6f      o 
    inc b                      ;6f0a    04      . 
    inc de                     ;6f0b    13      . 
    ld l,a                     ;6f0c    6f      o 

; BLOCK 'INTOK_string' (start 0x6f0d end 0x6f12)
INTOK_string_start:
    defb 049h                  ;6f0d    49      I 
    defb 04eh                  ;6f0e    4e      N 
    defb 054h                  ;6f0f    54      T 
    defb 04fh                  ;6f10    4f      O 
    defb 04bh                  ;6f11    4b      K 
INTOK_string_end:
    rst 38h                    ;6f12    ff      . 
    ld ix,l6f1ah               ;6f13    dd 21 1a 6f     . ! . o 
    jp l65f7h                  ;6f17    c3 f7 65    . . e 
l6f1ah:
    rst 38h                    ;6f1a    ff      . 
    rst 38h                    ;6f1b    ff      . 
    dec b                      ;6f1c    05      . 
    rst 38h                    ;6f1d    ff      . 
    rst 38h                    ;6f1e    ff      . 
    rst 38h                    ;6f1f    ff      . 
    rst 38h                    ;6f20    ff      . 
    rst 38h                    ;6f21    ff      . 
    rst 38h                    ;6f22    ff      . 
    dec b                      ;6f23    05      . 
    dec b                      ;6f24    05      . 
    rst 38h                    ;6f25    ff      . 
    rst 38h                    ;6f26    ff      . 
    rst 38h                    ;6f27    ff      . 
    rst 38h                    ;6f28    ff      . 
    ld hl,(0980ah)             ;6f29    2a 0a 98    * . . 
    call sub_71d4h             ;6f2c    cd d4 71    . . q 
    ret nz                     ;6f2f    c0      . 
    call sub_6d84h             ;6f30    cd 84 6d    . . m 
    ret nz                     ;6f33    c0      . 
    cp 028h                    ;6f34    fe 28   . ( 
    jr z,l6f40h                ;6f36    28 08   ( . 
    cp 029h                    ;6f38    fe 29   . ) 
    jr z,l6f40h                ;6f3a    28 04   ( . 
    cp 07ch                    ;6f3c    fe 7c   . | 
    jr nz,l6f53h               ;6f3e    20 13     . 
l6f40h:
    ld l,a                     ;6f40    6f      o 
    ld h,0feh                  ;6f41    26 fe   & . 
    ld (09ca5h),hl             ;6f43    22 a5 9c    " . . 
    ld a,008h                  ;6f46    3e 08   > . 
l6f48h:
    call sub_79e6h             ;6f48    cd e6 79    . . y 
l6f4bh:
    ld (0980dh),a              ;6f4b    32 0d 98    2 . . 
    ld (0980eh),hl             ;6f4e    22 0e 98    " . . 
    cp a                       ;6f51    bf      . 
    ret                        ;6f52    c9      . 
l6f53h:
    cp 004h                    ;6f53    fe 04   . . 
    jr z,l6f4bh                ;6f55    28 f4   ( . 
    cp 00ah                    ;6f57    fe 0a   . . 
    jr z,l6f4bh                ;6f59    28 f0   ( . 
    jr l6f48h                  ;6f5b    18 eb   . . 
    ex af,af'                  ;6f5d    08      . 
    ld h,e                     ;6f5e    63      c 
    ld l,a                     ;6f5f    6f      o 
    inc bc                     ;6f60    03      . 
    dec h                      ;6f61    25      % 
    ld (hl),d                  ;6f62    72      r 
    inc b                      ;6f63    04      . 
    ld l,h                     ;6f64    6c      l 
    ld l,a                     ;6f65    6f      o 

; BLOCK 'LISTP_string' (start 0x6f66 end 0x6f6b)
LISTP_string_start:
    defb 04ch                  ;6f66    4c      L 
    defb 049h                  ;6f67    49      I 
    defb 053h                  ;6f68    53      S 
    defb 054h                  ;6f69    54      T 
    defb 050h                  ;6f6a    50      P 
LISTP_string_end:
    rst 38h                    ;6f6b    ff      . 
    ld ix,l6f73h               ;6f6c    dd 21 73 6f     . ! s o    (flow from: 60bb)
    jp l65f7h                  ;6f70    c3 f7 65    . . e          (flow from: 6f6c)
l6f73h:
    rst 38h                    ;6f73    ff      . 
    rst 38h                    ;6f74    ff      . 
    dec b                      ;6f75    05      . 
    rst 38h                    ;6f76    ff      . 
    rst 38h                    ;6f77    ff      . 
    rrca                       ;6f78    0f      . 
    rst 38h                    ;6f79    ff      . 
    ld a,(bc)                  ;6f7a    0a      . 
    dec b                      ;6f7b    05      . 
    rst 38h                    ;6f7c    ff      . 
    ld b,(hl)                  ;6f7d    46      F 
    rst 38h                    ;6f7e    ff      . 
    rst 38h                    ;6f7f    ff      . 
    rst 38h                    ;6f80    ff      . 
    rst 38h                    ;6f81    ff      . 
    ld c,a                     ;6f82    4f      O 
    rst 38h                    ;6f83    ff      . 
    rst 38h                    ;6f84    ff      . 
    rst 38h                    ;6f85    ff      . 
    rst 38h                    ;6f86    ff      . 
    ld hl,(0980ah)             ;6f87    2a 0a 98    * . .          (flow from: 663c)
    ld a,001h                  ;6f8a    3e 01   > .                (flow from: 6f87)
    call sub_718fh             ;6f8c    cd 8f 71    . . q          (flow from: 6f8a)
    ret nz                     ;6f8f    c0      .                  (flow from: 71a1)
    ld hl,(09a8eh)             ;6f90    2a 8e 9a    * . .          (flow from: 6f8f)
    call sub_9623h             ;6f93    cd 23 96    . # .          (flow from: 6f90)
    push hl                    ;6f96    e5      .                  (flow from: 9628)
    call sub_6fa4h             ;6f97    cd a4 6f    . . o          (flow from: 6f96)
    pop hl                     ;6f9a    e1      .                  (flow from: 6fa7)
    inc hl                     ;6f9b    23      #                  (flow from: 6f9a)
    inc hl                     ;6f9c    23      #                  (flow from: 6f9b)
    inc hl                     ;6f9d    23      #                  (flow from: 6f9c)
    call sub_9623h             ;6f9e    cd 23 96    . # .          (flow from: 6f9d)
    inc hl                     ;6fa1    23      #                  (flow from: 9628)
    inc hl                     ;6fa2    23      #                  (flow from: 6fa1)
    inc hl                     ;6fa3    23      #                  (flow from: 6fa2)
sub_6fa4h:
    ld a,(hl)                  ;6fa4    7e      ~                  (flow from: 6f97 6fa3 6fc1)
    cp 010h                    ;6fa5    fe 10   . .                (flow from: 6fa4)
    ret z                      ;6fa7    c8      .                  (flow from: 6fa5)
    cp 003h                    ;6fa8    fe 03   . .                (flow from: 6fa7)
    ret nz                     ;6faa    c0      .                  (flow from: 6fa8)
    call sub_9623h             ;6fab    cd 23 96    . # .          (flow from: 6faa)
    ld a,(hl)                  ;6fae    7e      ~                  (flow from: 9628)
    cp 008h                    ;6faf    fe 08   . .                (flow from: 6fae)
    jr nz,l6fbeh               ;6fb1    20 0b     .                (flow from: 6faf)
    push hl                    ;6fb3    e5      .                  (flow from: 6fb1)
    call sub_9623h             ;6fb4    cd 23 96    . # .          (flow from: 6fb3)
    ld (09810h),hl             ;6fb7    22 10 98    " . .          (flow from: 9628)
    call sub_702fh             ;6fba    cd 2f 70    . / p          (flow from: 6fb7)
    pop hl                     ;6fbd    e1      .                  (flow from: 7032 7035)
l6fbeh:
    inc hl                     ;6fbe    23      #                  (flow from: 6fbd)
    inc hl                     ;6fbf    23      #                  (flow from: 6fbe)
    inc hl                     ;6fc0    23      #                  (flow from: 6fbf)
    jr sub_6fa4h               ;6fc1    18 e1   . .                (flow from: 6fc0)
    ld hl,(0980ah)             ;6fc3    2a 0a 98    * . . 
    ld a,001h                  ;6fc6    3e 01   > . 
    call sub_718fh             ;6fc8    cd 8f 71    . . q 
    ret nz                     ;6fcb    c0      . 
    ld hl,(09810h)             ;6fcc    2a 10 98    * . . 
    jr sub_6fa4h               ;6fcf    18 d3   . . 
    ld hl,(0980ah)             ;6fd1    2a 0a 98    * . . 
    ld a,001h                  ;6fd4    3e 01   > . 
    call sub_718fh             ;6fd6    cd 8f 71    . . q 
    ret nz                     ;6fd9    c0      . 
    ld hl,(09810h)             ;6fda    2a 10 98    * . . 
l6fddh:
    ld a,(hl)                  ;6fdd    7e      ~ 
    cp 007h                    ;6fde    fe 07   . . 
    jr nz,sub_702fh            ;6fe0    20 4d     M 
    push hl                    ;6fe2    e5      . 
    call sub_70c4h             ;6fe3    cd c4 70    . . p 
    pop hl                     ;6fe6    e1      . 
    call sub_9623h             ;6fe7    cd 23 96    . # . 
    push hl                    ;6fea    e5      . 
    call sub_7086h             ;6feb    cd 86 70    . . p 
    pop hl                     ;6fee    e1      . 
    push hl                    ;6fef    e5      . 
    inc hl                     ;6ff0    23      # 
    inc hl                     ;6ff1    23      # 
    inc hl                     ;6ff2    23      # 
    call sub_9623h             ;6ff3    cd 23 96    . # . 
    push hl                    ;6ff6    e5      . 
    call sub_7086h             ;6ff7    cd 86 70    . . p 
    call sub_7081h             ;6ffa    cd 81 70    . . p 
    ld hl,l7019h               ;6ffd    21 19 70    ! . p 
    ld (09801h),hl             ;7000    22 01 98    " . . 
    pop hl                     ;7003    e1      . 
    inc hl                     ;7004    23      # 
    inc hl                     ;7005    23      # 
    inc hl                     ;7006    23      # 
    call sub_694ah             ;7007    cd 4a 69    . J i 
    pop hl                     ;700a    e1      . 
    call sub_694ah             ;700b    cd 4a 69    . J i 
    ld hl,0780dh               ;700e    21 0d 78    ! . x 
    call sub_70c4h             ;7011    cd c4 70    . . p 
    call sub_7081h             ;7014    cd 81 70    . . p 
    cp a                       ;7017    bf      . 
    ret                        ;7018    c9      . 
l7019h:
    call sub_9623h             ;7019    cd 23 96    . # . 
    ld (09810h),hl             ;701c    22 10 98    " . . 
    ld a,(hl)                  ;701f    7e      ~ 
    cp 003h                    ;7020    fe 03   . . 
    jr nz,l7029h               ;7022    20 05     . 
    call sub_702fh             ;7024    cd 2f 70    . / p 
    jr l702eh                  ;7027    18 05   . . 
l7029h:
    cp 007h                    ;7029    fe 07   . . 
    jp z,l6fddh                ;702b    ca dd 6f    . . o 
l702eh:
    ret                        ;702e    c9      . 
sub_702fh:
    ld a,(hl)                  ;702f    7e      ~                  (flow from: 6fba)
    cp 010h                    ;7030    fe 10   . .                (flow from: 702f)
    ret z                      ;7032    c8      .                  (flow from: 7030)
    cp 003h                    ;7033    fe 03   . .                (flow from: 7032)
    ret nz                     ;7035    c0      .                  (flow from: 7033)
    call sub_9623h             ;7036    cd 23 96    . # . 
    push hl                    ;7039    e5      . 
    call sub_9623h             ;703a    cd 23 96    . # . 
    inc hl                     ;703d    23      # 
    inc hl                     ;703e    23      # 
    inc hl                     ;703f    23      # 
    call sub_9623h             ;7040    cd 23 96    . # . 
    call sub_704ch             ;7043    cd 4c 70    . L p 
    pop hl                     ;7046    e1      . 
    inc hl                     ;7047    23      # 
    inc hl                     ;7048    23      # 
    inc hl                     ;7049    23      # 
    jr sub_702fh               ;704a    18 e3   . . 
sub_704ch:
    ld a,028h                  ;704c    3e 28   > ( 
    call 0986bh                ;704e    cd 6b 98    . k . 
    call 0986bh                ;7051    cd 6b 98    . k . 
    push hl                    ;7054    e5      . 
    ld hl,(09810h)             ;7055    2a 10 98    * . . 
    call sub_70c4h             ;7058    cd c4 70    . . p 
    pop hl                     ;705b    e1      . 
    push hl                    ;705c    e5      . 
    call sub_709bh             ;705d    cd 9b 70    . . p 
    pop hl                     ;7060    e1      . 
l7061h:
    inc hl                     ;7061    23      # 
    inc hl                     ;7062    23      # 
    inc hl                     ;7063    23      # 
    ld a,(hl)                  ;7064    7e      ~ 
    cp 003h                    ;7065    fe 03   . . 
    jr nz,l707eh               ;7067    20 15     . 
    call sub_9623h             ;7069    cd 23 96    . # . 
    call sub_7081h             ;706c    cd 81 70    . . p 
    ld a,020h                  ;706f    3e 20   >   
    call 0986bh                ;7071    cd 6b 98    . k . 
    call 0986bh                ;7074    cd 6b 98    . k . 
    push hl                    ;7077    e5      . 
    call sub_7086h             ;7078    cd 86 70    . . p 
    pop hl                     ;707b    e1      . 
    jr l7061h                  ;707c    18 e3   . . 
l707eh:
    call sub_70aah             ;707e    cd aa 70    . . p 
sub_7081h:
    ld a,00dh                  ;7081    3e 0d   > . 
    jp 0986bh                  ;7083    c3 6b 98    . k . 
sub_7086h:
    ld a,(hl)                  ;7086    7e      ~ 
    cp 003h                    ;7087    fe 03   . . 
    jr nz,l70bdh               ;7089    20 32     2 
    call sub_9623h             ;708b    cd 23 96    . # . 
    ld a,028h                  ;708e    3e 28   > ( 
    call 0986bh                ;7090    cd 6b 98    . k . 
l7093h:
    push hl                    ;7093    e5      . 
    call sub_7086h             ;7094    cd 86 70    . . p 
    pop hl                     ;7097    e1      . 
    inc hl                     ;7098    23      # 
    inc hl                     ;7099    23      # 
    inc hl                     ;709a    23      # 
sub_709bh:
    ld a,(hl)                  ;709b    7e      ~ 
    cp 003h                    ;709c    fe 03   . . 
    jr nz,sub_70aah            ;709e    20 0a     . 
    ld a,020h                  ;70a0    3e 20   >   
    call 0986bh                ;70a2    cd 6b 98    . k . 
    call sub_9623h             ;70a5    cd 23 96    . # . 
    jr l7093h                  ;70a8    18 e9   . . 
sub_70aah:
    cp 010h                    ;70aa    fe 10   . . 
    jr nz,l70b3h               ;70ac    20 05     . 
l70aeh:
    ld a,029h                  ;70ae    3e 29   > ) 
    jp 0986bh                  ;70b0    c3 6b 98    . k . 
l70b3h:
    ld a,07ch                  ;70b3    3e 7c   > | 
    call 0986bh                ;70b5    cd 6b 98    . k . 
    call sub_7086h             ;70b8    cd 86 70    . . p 
    jr l70aeh                  ;70bb    18 f1   . . 
l70bdh:
    cp 008h                    ;70bd    fe 08   . . 
    jr nz,l70cah               ;70bf    20 09     . 
    call sub_9623h             ;70c1    cd 23 96    . # . 
sub_70c4h:
    inc hl                     ;70c4    23      # 
    inc hl                     ;70c5    23      # 
    inc hl                     ;70c6    23      # 
    jp l6babh                  ;70c7    c3 ab 6b    . . k 
l70cah:
    cp 00ch                    ;70ca    fe 0c   . . 
    jr nz,l70eah               ;70cc    20 1c     . 
    inc hl                     ;70ce    23      # 
    ld a,(hl)                  ;70cf    7e      ~ 
    ld c,a                     ;70d0    4f      O 
    sla c                      ;70d1    cb 21   . ! 
    add a,c                    ;70d3    81      . 
    sla c                      ;70d4    cb 21   . ! 
    sla c                      ;70d6    cb 21   . ! 
    add a,c                    ;70d8    81      . 
    sla c                      ;70d9    cb 21   . ! 
    sla c                      ;70db    cb 21   . ! 
    add a,c                    ;70dd    81      . 
    sla c                      ;70de    cb 21   . ! 
    sla c                      ;70e0    cb 21   . ! 
    add a,c                    ;70e2    81      . 
    ld l,a                     ;70e3    6f      o 
    inc l                      ;70e4    2c      , 
    ld h,000h                  ;70e5    26 00   & . 
    jp sub_6adah               ;70e7    c3 da 6a    . . j 
l70eah:
    cp 004h                    ;70ea    fe 04   . . 
    jr nz,l70f4h               ;70ec    20 06     . 
    call sub_9623h             ;70ee    cd 23 96    . # . 
    jp l6b0eh                  ;70f1    c3 0e 6b    . . k 
l70f4h:
    cp 00ah                    ;70f4    fe 0a   . . 
    jr nz,l70feh               ;70f6    20 06     . 
    call sub_9623h             ;70f8    cd 23 96    . # . 
    jp l6b56h                  ;70fb    c3 56 6b    . V k 
l70feh:
    cp 010h                    ;70fe    fe 10   . . 
    call nz,sub_6259h          ;7100    c4 59 62    . Y b 
    ld a,028h                  ;7103    3e 28   > ( 
    call 0986bh                ;7105    cd 6b 98    . k . 
    ld a,029h                  ;7108    3e 29   > ) 
    jp 0986bh                  ;710a    c3 6b 98    . k . 
l710dh:
    ld b,000h                  ;710d    06 00   . . 
    jr nz,$+34                 ;710f    20 20       
    jr nz,l7133h               ;7111    20 20       
    jr nz,l7135h               ;7113    20 20       
    jr nz,l7137h               ;7115    20 20       
    jr nz,l7139h               ;7117    20 20       
    jr nz,l713bh               ;7119    20 20       
    jr nz,l713dh               ;711b    20 20       
    jr nz,l713fh               ;711d    20 20       
    jr nz,l7141h               ;711f    20 20       
    jr nz,l7143h               ;7121    20 20       
    jr nz,l7145h               ;7123    20 20       
    jr nz,l7147h               ;7125    20 20       
    jr nz,l7149h               ;7127    20 20       
    jr nz,$+34                 ;7129    20 20       
    jr nz,$+34                 ;712b    20 20       
    jr nz,l714fh               ;712d    20 20       
    ex af,af'                  ;712f    08      . 
    djnz l713ah                ;7130    10 08   . . 
    ex af,af'                  ;7132    08      . 
l7133h:
    ex af,af'                  ;7133    08      . 
    ex af,af'                  ;7134    08      . 
l7135h:
    ex af,af'                  ;7135    08      . 
    inc b                      ;7136    04      . 
l7137h:
    inc b                      ;7137    04      . 
    ex af,af'                  ;7138    08      . 
l7139h:
    ex af,af'                  ;7139    08      . 
l713ah:
    ex af,af'                  ;713a    08      . 
l713bh:
    adc a,c                    ;713b    89      . 
    ex af,af'                  ;713c    08      . 
l713dh:
    ex af,af'                  ;713d    08      . 
    ld (bc),a                  ;713e    02      . 
l713fh:
    ld (bc),a                  ;713f    02      . 
    ld (bc),a                  ;7140    02      . 
l7141h:
    ld (bc),a                  ;7141    02      . 
    ld (bc),a                  ;7142    02      . 
l7143h:
    ld (bc),a                  ;7143    02      . 
    ld (bc),a                  ;7144    02      . 
l7145h:
    ld (bc),a                  ;7145    02      . 
    ld (bc),a                  ;7146    02      . 
l7147h:
    ld (bc),a                  ;7147    02      . 
    ex af,af'                  ;7148    08      . 
l7149h:
    ex af,af'                  ;7149    08      . 
    djnz $+10                  ;714a    10 08   . . 
    djnz $+10                  ;714c    10 08   . . 
    ex af,af'                  ;714e    08      . 
l714fh:
    ld bc,00101h               ;714f    01 01 01    . . . 
    ld bc,00101h               ;7152    01 01 01    . . . 
    ld bc,00101h               ;7155    01 01 01    . . . 
    ld bc,00101h               ;7158    01 01 01    . . . 
    ld bc,00101h               ;715b    01 01 01    . . . 
    ld bc,00101h               ;715e    01 01 01    . . . 
    ld bc,00101h               ;7161    01 01 01    . . . 
    ld bc,04101h               ;7164    01 01 41    . . A 
    ld b,c                     ;7167    41      A 
    ld b,c                     ;7168    41      A 
    djnz $+10                  ;7169    10 08   . . 
    djnz l7175h                ;716b    10 08   . . 
    add hl,bc                  ;716d    09      . 
    ex af,af'                  ;716e    08      . 
    ld bc,00101h               ;716f    01 01 01    . . . 
    ld bc,00101h               ;7172    01 01 01    . . . 
l7175h:
    ld bc,00101h               ;7175    01 01 01    . . . 
    ld bc,00101h               ;7178    01 01 01    . . . 
    ld bc,00101h               ;717b    01 01 01    . . . 
    ld bc,00101h               ;717e    01 01 01    . . . 
    ld bc,00101h               ;7181    01 01 01    . . . 
    ld bc,04101h               ;7184    01 01 41    . . A 
    ld b,c                     ;7187    41      A 
    ld b,c                     ;7188    41      A 
    djnz sub_718fh             ;7189    10 04   . . 
    djnz $+10                  ;718b    10 08   . . 
    nop                        ;718d    00      . 
l718eh:
    ccf                        ;718e    3f      ? 
sub_718fh:
    ld (0986eh),a              ;718f    32 6e 98    2 n .          (flow from: 69b9 6f8c)
    ex de,hl                   ;7192    eb      .                  (flow from: 718f)
    ld hl,l72abh               ;7193    21 ab 72    ! . r          (flow from: 7192)
    or a                       ;7196    b7      .                  (flow from: 7193)
    sbc hl,de                  ;7197    ed 52   . R                (flow from: 7196)
    jr nz,l71a2h               ;7199    20 07     .                (flow from: 7197)
    ld hl,l72fah               ;719b    21 fa 72    ! . r          (flow from: 7199)
l719eh:
    ld (0986ch),hl             ;719e    22 6c 98    " l .          (flow from: 719b)
    ret                        ;71a1    c9      .                  (flow from: 719e)
l71a2h:
    ld hl,l734ch               ;71a2    21 4c 73    ! L s 
    or a                       ;71a5    b7      . 
    sbc hl,de                  ;71a6    ed 52   . R 
    jr nz,l71afh               ;71a8    20 05     . 
    ld hl,l7354h               ;71aa    21 54 73    ! T s 
    jr l719eh                  ;71ad    18 ef   . . 
l71afh:
    ld hl,l7363h               ;71af    21 63 73    ! c s 
    or a                       ;71b2    b7      . 
    sbc hl,de                  ;71b3    ed 52   . R 
    jr nz,l71bch               ;71b5    20 05     . 
    ld hl,0736bh               ;71b7    21 6b 73    ! k s 
    jr l719eh                  ;71ba    18 e2   . . 
l71bch:
    ex de,hl                   ;71bc    eb      . 
    ld a,(hl)                  ;71bd    7e      ~ 
    cp 006h                    ;71be    fe 06   . . 
    jp nz,l6295h               ;71c0    c2 95 62    . . b 
    call sub_9623h             ;71c3    cd 23 96    . # . 
    ld (09b6dh),hl             ;71c6    22 6d 9b    " m . 
    ld a,(hl)                  ;71c9    7e      ~ 
    cp 002h                    ;71ca    fe 02   . . 
    jp nz,l6295h               ;71cc    c2 95 62    . . b 
    ld hl,l9602h               ;71cf    21 02 96    ! . . 
    jr l719eh                  ;71d2    18 ca   . . 
sub_71d4h:
    ex de,hl                   ;71d4    eb      .                  (flow from: 6c64)
    ld hl,l72abh               ;71d5    21 ab 72    ! . r          (flow from: 71d4)
    or a                       ;71d8    b7      .                  (flow from: 71d5)
    sbc hl,de                  ;71d9    ed 52   . R                (flow from: 71d8)
    jr nz,l71f0h               ;71db    20 13     .                (flow from: 71d9)
    ld hl,l73a8h               ;71dd    21 a8 73    ! . s          (flow from: 71db)
    ld (09866h),hl             ;71e0    22 66 98    " f .          (flow from: 71dd)
    ld hl,l7428h               ;71e3    21 28 74    ! ( t          (flow from: 71e0)
    ld (09869h),hl             ;71e6    22 69 98    " i .          (flow from: 71e3)
    ld hl,l72fah               ;71e9    21 fa 72    ! . r          (flow from: 71e6)
    ld (0986ch),hl             ;71ec    22 6c 98    " l .          (flow from: 71e9)
    ret                        ;71ef    c9      .                  (flow from: 71ec)
l71f0h:
    ld hl,l737ah               ;71f0    21 7a 73    ! z s          (flow from: 71db)
    or a                       ;71f3    b7      .                  (flow from: 71f0)
    sbc hl,de                  ;71f4    ed 52   . R                (flow from: 71f3)
    jr nz,l7205h               ;71f6    20 0d     .                (flow from: 71f4)
    ld hl,l7382h               ;71f8    21 82 73    ! . s 
    ld (09866h),hl             ;71fb    22 66 98    " f . 
    ld hl,l7397h               ;71fe    21 97 73    ! . s 
    ld (09869h),hl             ;7201    22 69 98    " i . 
    ret                        ;7204    c9      . 
l7205h:
    ex de,hl                   ;7205    eb      .                  (flow from: 71f6)
    ld a,(hl)                  ;7206    7e      ~                  (flow from: 7205)
    cp 006h                    ;7207    fe 06   . .                (flow from: 7206)
    jp nz,l6295h               ;7209    c2 95 62    . . b          (flow from: 7207)
    call sub_9623h             ;720c    cd 23 96    . # .          (flow from: 7209)
    ld (09b6dh),hl             ;720f    22 6d 9b    " m .          (flow from: 9628)
    ld a,(hl)                  ;7212    7e      ~                  (flow from: 720f)
    cp 001h                    ;7213    fe 01   . .                (flow from: 7212)
    jp nz,l6295h               ;7215    c2 95 62    . . b          (flow from: 7213)
    ld hl,l960eh               ;7218    21 0e 96    ! . .          (flow from: 7215)
    ld (09866h),hl             ;721b    22 66 98    " f .          (flow from: 7218)
    ld hl,l961ah               ;721e    21 1a 96    ! . .          (flow from: 721b)
    ld (09869h),hl             ;7221    22 69 98    " i .          (flow from: 721e)
    ret                        ;7224    c9      .                  (flow from: 7221)
    ex af,af'                  ;7225    08      . 
    xor e                      ;7226    ab      . 
    ld (hl),d                  ;7227    72      r 
    inc bc                     ;7228    03      . 
    dec hl                     ;7229    2b      + 
    ld (hl),d                  ;722a    72      r 
    ex af,af'                  ;722b    08      . 
    ld c,h                     ;722c    4c      L 
    ld (hl),e                  ;722d    73      s 
    inc bc                     ;722e    03      . 
    ld sp,00872h               ;722f    31 72 08    1 r . 
    ld h,e                     ;7232    63      c 
    ld (hl),e                  ;7233    73      s 
    inc bc                     ;7234    03      . 
    scf                        ;7235    37      7 
    ld (hl),d                  ;7236    72      r 
    ex af,af'                  ;7237    08      . 
    ld a,d                     ;7238    7a      z 
    ld (hl),e                  ;7239    73      s 
    inc bc                     ;723a    03      . 
    dec a                      ;723b    3d      = 
    ld (hl),d                  ;723c    72      r 
    ex af,af'                  ;723d    08      . 
    ld b,e                     ;723e    43      C 
    ld (hl),d                  ;723f    72      r 
    inc bc                     ;7240    03      . 
    ld a,h                     ;7241    7c      | 
    ld (hl),l                  ;7242    75      u 
    inc b                      ;7243    04      . 
    ld c,h                     ;7244    4c      L 
    ld (hl),d                  ;7245    72      r 

; BLOCK 'RFILL_string' (start 0x7246 end 0x724b)
RFILL_string_start:
    defb 052h                  ;7246    52      R 
    defb 046h                  ;7247    46      F 
    defb 049h                  ;7248    49      I 
    defb 04ch                  ;7249    4c      L 
    defb 04ch                  ;724a    4c      L 
RFILL_string_end:
    rst 38h                    ;724b    ff      . 
    ld hl,l755ch               ;724c    21 5c 75    ! \ u 
    ld (0986ch),hl             ;724f    22 6c 98    " l . 
    ld a,001h                  ;7252    3e 01   > . 
    ld (0986eh),a              ;7254    32 6e 98    2 n . 
    ld a,000h                  ;7257    3e 00   > . 
    ld (09972h),a              ;7259    32 72 99    2 r . 
    ld (09971h),a              ;725c    32 71 99    2 q . 
    ld a,04ch                  ;725f    3e 4c   > L 
    ld (09970h),a              ;7261    32 70 99    2 p . 
    ld ix,l726bh               ;7264    dd 21 6b 72     . ! k r 
    jp l65f7h                  ;7268    c3 f7 65    . . e 
l726bh:
    rst 38h                    ;726b    ff      . 
    rst 38h                    ;726c    ff      . 
    rst 38h                    ;726d    ff      . 
    dec b                      ;726e    05      . 
    rst 38h                    ;726f    ff      . 
    rst 38h                    ;7270    ff      . 
    rst 38h                    ;7271    ff      . 
    rst 38h                    ;7272    ff      . 
    rst 38h                    ;7273    ff      . 
    dec b                      ;7274    05      . 
    dec b                      ;7275    05      . 
    rst 38h                    ;7276    ff      . 
    rst 38h                    ;7277    ff      . 
    rst 38h                    ;7278    ff      . 
    rst 38h                    ;7279    ff      . 
    ld hl,0ffffh               ;727a    21 ff ff    ! . . 
    ld (0986fh),hl             ;727d    22 6f 98    " o . 
    ld hl,(0980ah)             ;7280    2a 0a 98    * . . 
    call sub_6a04h             ;7283    cd 04 6a    . . j 
    ret nz                     ;7286    c0      . 
    ld hl,l73a8h               ;7287    21 a8 73    ! . s 
    ld (09866h),hl             ;728a    22 66 98    " f . 
    ld hl,l7428h               ;728d    21 28 74    ! ( t 
    ld (09869h),hl             ;7290    22 69 98    " i . 
    jp l6c6dh                  ;7293    c3 6d 6c    . m l 
sub_7296h:
    ex (sp),hl                 ;7296    e3      .                  (flow from: 9629 96a1)
    push af                    ;7297    f5      .                  (flow from: 7296)
    call sub_72a1h             ;7298    cd a1 72    . . r          (flow from: 7297)
    call sub_72f8h             ;729b    cd f8 72    . . r          (flow from: 72a4)
    pop af                     ;729e    f1      .                  (flow from: 734b)
    ex (sp),hl                 ;729f    e3      .                  (flow from: 729e)
    ret                        ;72a0    c9      .                  (flow from: 729f)
sub_72a1h:
    ld a,(hl)                  ;72a1    7e      ~                  (flow from: 7298 72a9 7465)
    and 07fh                   ;72a2    e6 7f   .                 (flow from: 72a1)
    ret z                      ;72a4    c8      .                  (flow from: 72a2)
    call l72fah                ;72a5    cd fa 72    . . r          (flow from: 72a4)
    inc hl                     ;72a8    23      #                  (flow from: 734b)
    jr sub_72a1h               ;72a9    18 f6   . .                (flow from: 72a8)
l72abh:
    ld b,0ffh                  ;72ab    06 ff   . . 
    rst 38h                    ;72ad    ff      . 

; BLOCK 'CON__string' (start 0x72ae end 0x72b2)
CON__string_start:
    defb 043h                  ;72ae    43      C 
    defb 04fh                  ;72af    4f      O 
    defb 04eh                  ;72b0    4e      N 
    defb 03ah                  ;72b1    3a      : 
CON__string_end:
    rst 38h                    ;72b2    ff      . 
sub_72b3h:
    ld c,006h                  ;72b3    0e 06   . .                (flow from: 72ee 7313 9177)
    ld e,0ffh                  ;72b5    1e ff   . .                (flow from: 72b3)
    call sub_9176h             ;72b7    cd 76 91    . v .          (flow from: 72b5)
    or a                       ;72ba    b7      .                  (flow from: 72f1 92c9)
    ret nz                     ;72bb    c0      .                  (flow from: 72ba)
    bit 3,(iy+002h)            ;72bc    fd cb 02 5e     . . . ^    (flow from: 72bb)
    ret z                      ;72c0    c8      .                  (flow from: 72bc)
sub_72c1h:
    push bc                    ;72c1    c5      .                  (flow from: 7468 7551)
    push de                    ;72c2    d5      .                  (flow from: 72c1)
    push hl                    ;72c3    e5      .                  (flow from: 72c2)
    call ROM_OUT_CURS_WITHOUT_CHECK ;72c4    cd e8 18    . . .     (flow from: 72c3)
    ld e,008h                  ;72c7    1e 08   . .                (flow from: 190e)
    ld c,006h                  ;72c9    0e 06   . .                (flow from: 72c7)
    call sub_9176h             ;72cb    cd 76 91    . v .          (flow from: 72c9)
    pop hl                     ;72ce    e1      .                  (flow from: 92c9)
    pop de                     ;72cf    d1      .                  (flow from: 72ce)
    pop bc                     ;72d0    c1      .                  (flow from: 72cf)
    xor a                      ;72d1    af      .                  (flow from: 72d0)
    ret                        ;72d2    c9      .                  (flow from: 72d1)
sub_72d3h:
    push bc                    ;72d3    c5      .                  (flow from: 746b)
    push de                    ;72d4    d5      .                  (flow from: 72d3)
    push hl                    ;72d5    e5      .                  (flow from: 72d4)
    ld a,(09a73h)              ;72d6    3a 73 9a    : s .          (flow from: 72d5)
    or a                       ;72d9    b7      .                  (flow from: 72d6)
    jr z,l72eeh                ;72da    28 12   ( .                (flow from: 72d9)
    ld c,a                     ;72dc    4f      O 
    dec a                      ;72dd    3d      = 
    ld (09a73h),a              ;72de    32 73 9a    2 s . 
    ld de,09a74h               ;72e1    11 74 9a    . t . 
    ld a,(de)                  ;72e4    1a      . 
    ld hl,09a75h               ;72e5    21 75 9a    ! u . 
    ld b,000h                  ;72e8    06 00   . . 
    ldir                       ;72ea    ed b0   . . 
    jr l72f4h                  ;72ec    18 06   . . 
l72eeh:
    call sub_72b3h             ;72ee    cd b3 72    . . r          (flow from: 72da 72f2)
    or a                       ;72f1    b7      .                  (flow from: 72bb 72c0)
    jr z,l72eeh                ;72f2    28 fa   ( .                (flow from: 72f1 917b)
l72f4h:
    pop hl                     ;72f4    e1      .                  (flow from: 72f2)
    pop de                     ;72f5    d1      .                  (flow from: 72f4)
    pop bc                     ;72f6    c1      .                  (flow from: 72f5)
    ret                        ;72f7    c9      .                  (flow from: 72f6)
sub_72f8h:
    ld a,00dh                  ;72f8    3e 0d   > .                (flow from: 729b 73ff)
l72fah:
    push de                    ;72fa    d5      .                  (flow from: 72a5 72f8 74bc 74ef 7531 7538 9579 986b)
    push bc                    ;72fb    c5      .                  (flow from: 72fa)
    push af                    ;72fc    f5      .                  (flow from: 72fb)
    ld c,006h                  ;72fd    0e 06   . .                (flow from: 72fc)
    ld e,a                     ;72ff    5f      _                  (flow from: 72fd)
    call sub_9176h             ;7300    cd 76 91    . v .          (flow from: 72ff)
    ld a,(0996fh)              ;7303    3a 6f 99    : o .          (flow from: 92c9)
    or a                       ;7306    b7      .                  (flow from: 7303)
    jr z,l7313h                ;7307    28 0a   ( .                (flow from: 7306)
    ld c,005h                  ;7309    0e 05   . . 
    call sub_9176h             ;730b    cd 76 91    . v . 
    jr l7313h                  ;730e    18 03   . . 
sub_7310h:
    push de                    ;7310    d5      .                  (flow from: 606a 9612)
    push bc                    ;7311    c5      .                  (flow from: 7310)
    push af                    ;7312    f5      .                  (flow from: 7311)
l7313h:
    call sub_72b3h             ;7313    cd b3 72    . . r          (flow from: 7307 7312)
    or a                       ;7316    b7      .                  (flow from: 72c0)
    jr z,l7348h                ;7317    28 2f   ( /                (flow from: 7316)
    cp 018h                    ;7319    fe 18   . . 
    jp z,l6281h                ;731b    ca 81 62    . . b 
    cp 0e2h                    ;731e    fe e2   . . 
    jr z,l7340h                ;7320    28 1e   ( . 
    ld b,a                     ;7322    47      G 
    ld a,(09a73h)              ;7323    3a 73 9a    : s . 
    cp 010h                    ;7326    fe 10   . . 
    jr z,l733bh                ;7328    28 11   ( . 
    push hl                    ;732a    e5      . 
    ld l,a                     ;732b    6f      o 
    inc a                      ;732c    3c      < 
    ld (09a73h),a              ;732d    32 73 9a    2 s . 
    ld a,b                     ;7330    78      x 
    ld h,000h                  ;7331    26 00   & . 
    ld de,09a74h               ;7333    11 74 9a    . t . 
    add hl,de                  ;7336    19      . 
    ld (hl),a                  ;7337    77      w 
    pop hl                     ;7338    e1      . 
    jr l7348h                  ;7339    18 0d   . . 
l733bh:
    call sub_7557h             ;733b    cd 57 75    . W u 
    jr l7348h                  ;733e    18 08   . . 
l7340h:
    call sub_72d3h             ;7340    cd d3 72    . . r 
    cp 018h                    ;7343    fe 18   . . 
    jp z,l6281h                ;7345    ca 81 62    . . b 
l7348h:
    pop af                     ;7348    f1      .                  (flow from: 7317)
    pop bc                     ;7349    c1      .                  (flow from: 7348)
    pop de                     ;734a    d1      .                  (flow from: 7349)
    ret                        ;734b    c9      .                  (flow from: 734a)
l734ch:
    ld b,0ffh                  ;734c    06 ff   . . 
    rst 38h                    ;734e    ff      . 

; BLOCK 'LST__string' (start 0x734f end 0x7353)
LST__string_start:
    defb 04ch                  ;734f    4c      L 
    defb 053h                  ;7350    53      S 
    defb 054h                  ;7351    54      T 
    defb 03ah                  ;7352    3a      : 
LST__string_end:
    rst 38h                    ;7353    ff      . 
l7354h:
    call sub_7310h             ;7354    cd 10 73    . . s 
    push bc                    ;7357    c5      . 
    push de                    ;7358    d5      . 
    ld e,a                     ;7359    5f      _ 
    ld c,005h                  ;735a    0e 05   . . 
    call sub_9176h             ;735c    cd 76 91    . v . 
    pop de                     ;735f    d1      . 
    pop bc                     ;7360    c1      . 
    cp a                       ;7361    bf      . 
    ret                        ;7362    c9      . 
l7363h:
    ld b,0ffh                  ;7363    06 ff   . . 
    rst 38h                    ;7365    ff      . 
    ld d,b                     ;7366    50      P 
    ld d,l                     ;7367    55      U 
    ld c,(hl)                  ;7368    4e      N 
    ld a,(0cdffh)              ;7369    3a ff cd    : . . 
    djnz l73e1h                ;736c    10 73   . s 
    push bc                    ;736e    c5      . 
    push de                    ;736f    d5      . 
    ld e,a                     ;7370    5f      _ 
    ld c,004h                  ;7371    0e 04   . . 
    call sub_9176h             ;7373    cd 76 91    . v . 
    pop de                     ;7376    d1      . 
    pop bc                     ;7377    c1      . 
    cp a                       ;7378    bf      . 
    ret                        ;7379    c9      . 
l737ah:
    ld b,0ffh                  ;737a    06 ff   . . 
    rst 38h                    ;737c    ff      . 

; BLOCK 'RDR__string' (start 0x737d end 0x7381)
RDR__string_start:
    defb 052h                  ;737d    52      R 
    defb 044h                  ;737e    44      D 
    defb 052h                  ;737f    52      R 
    defb 03ah                  ;7380    3a      : 
RDR__string_end:
    rst 38h                    ;7381    ff      . 
l7382h:
    push hl                    ;7382    e5      . 
    ld hl,09a84h               ;7383    21 84 9a    ! . . 
    ld a,(hl)                  ;7386    7e      ~ 
    or a                       ;7387    b7      . 
    jr z,l738fh                ;7388    28 05   ( . 
    ld (hl),000h               ;738a    36 00   6 . 
    cp a                       ;738c    bf      . 
    pop hl                     ;738d    e1      . 
    ret                        ;738e    c9      . 
l738fh:
    ld c,003h                  ;738f    0e 03   . . 
    call sub_9176h             ;7391    cd 76 91    . v . 
    pop hl                     ;7394    e1      . 
    cp a                       ;7395    bf      . 
    ret                        ;7396    c9      . 
l7397h:
    ld (09a84h),a              ;7397    32 84 9a    2 . . 
    ret                        ;739a    c9      . 
sub_739bh:
    xor a                      ;739b    af      . 
    ld (09972h),a              ;739c    32 72 99    2 r . 
    ld (09971h),a              ;739f    32 71 99    2 q . 
    ld a,05ah                  ;73a2    3e 5a   > Z 
    ld (09970h),a              ;73a4    32 70 99    2 p . 
    ret                        ;73a7    c9      . 
l73a8h:
    push bc                    ;73a8    c5      .                  (flow from: 9865)
    push hl                    ;73a9    e5      .                  (flow from: 73a8)
    push de                    ;73aa    d5      .                  (flow from: 73a9)
    ld c,b                     ;73ab    48      H                  (flow from: 73aa)
l73ach:
    ld a,(09972h)              ;73ac    3a 72 99    : r .          (flow from: 73ab 7415)
    ld b,a                     ;73af    47      G                  (flow from: 73ac)
    ld a,(09971h)              ;73b0    3a 71 99    : q .          (flow from: 73af)
    cp b                       ;73b3    b8      .                  (flow from: 73b0)
    jr nz,l7417h               ;73b4    20 61     a                (flow from: 73b3)
    ld a,(09970h)              ;73b6    3a 70 99    : p .          (flow from: 73b4)
    push af                    ;73b9    f5      .                  (flow from: 73b6)
    cp 05ah                    ;73ba    fe 5a   . Z                (flow from: 73b9)
    jr nz,l73c8h               ;73bc    20 0a     .                (flow from: 73ba)
    inc c                      ;73be    0c      .                  (flow from: 73bc)
    dec c                      ;73bf    0d      .                  (flow from: 73be)
    jr z,l73c8h                ;73c0    28 06   ( .                (flow from: 73bf)
    ld l,c                     ;73c2    69      i 
    ld h,000h                  ;73c3    26 00   & . 
    call l6b0eh                ;73c5    cd 0e 6b    . . k 
l73c8h:
    pop hl                     ;73c8    e1      .                  (flow from: 73c0)
    push bc                    ;73c9    c5      .                  (flow from: 73c8)
    ld de,09973h               ;73ca    11 73 99    . s .          (flow from: 73c9)
    ld a,(09972h)              ;73cd    3a 72 99    : r .          (flow from: 73ca)
    ld c,a                     ;73d0    4f      O                  (flow from: 73cd)
    ld b,000h                  ;73d1    06 00   . .                (flow from: 73d0)
    ld a,h                     ;73d3    7c      |                  (flow from: 73d1)
l73d4h:
    ld hl,l73f4h               ;73d4    21 f4 73    ! . s          (flow from: 73d3)
    push hl                    ;73d7    e5      .                  (flow from: 73d4)
    ld hl,l742fh               ;73d8    21 2f 74    ! / t          (flow from: 73d7)
l73dbh:
    cp (hl)                    ;73db    be      .                  (flow from: 73d8)
    jr nz,l73e4h               ;73dc    20 06     .                (flow from: 73db)
    inc hl                     ;73de    23      #                  (flow from: 73dc)
    ld a,(hl)                  ;73df    7e      ~                  (flow from: 73de)
    inc hl                     ;73e0    23      #                  (flow from: 73df)
l73e1h:
    ld h,(hl)                  ;73e1    66      f                  (flow from: 73e0)
    ld l,a                     ;73e2    6f      o                  (flow from: 73e1)
    jp (hl)                    ;73e3    e9      .                  (flow from: 73e2)
l73e4h:
    push af                    ;73e4    f5      . 
    ld a,(hl)                  ;73e5    7e      ~ 
    or a                       ;73e6    b7      . 
    jr z,l73efh                ;73e7    28 06   ( . 
    pop af                     ;73e9    f1      . 
    inc hl                     ;73ea    23      # 
    inc hl                     ;73eb    23      # 
    inc hl                     ;73ec    23      # 
    jr l73dbh                  ;73ed    18 ec   . . 
l73efh:
    pop af                     ;73ef    f1      . 
    pop hl                     ;73f0    e1      . 
    call sub_7557h             ;73f1    cd 57 75    . W u 
l73f4h:
    call sub_72d3h             ;73f4    cd d3 72    . . r 
    call sub_6c34h             ;73f7    cd 34 6c    . 4 l 
    jr l73d4h                  ;73fa    18 d8   . . 
l73fch:
    call sub_7523h             ;73fc    cd 23 75    . # u          (flow from: 7470)
    call sub_72f8h             ;73ff    cd f8 72    . . r          (flow from: 734b)
    ld a,00dh                  ;7402    3e 0d   > .                (flow from: 734b)
    ld (de),a                  ;7404    12      .                  (flow from: 7402)
    ld a,c                     ;7405    79      y                  (flow from: 7404)
    inc a                      ;7406    3c      <                  (flow from: 7405)
    ld (09972h),a              ;7407    32 72 99    2 r .          (flow from: 7406)
    xor a                      ;740a    af      .                  (flow from: 7407)
    ld (09971h),a              ;740b    32 71 99    2 q .          (flow from: 740a)
    ld a,05ah                  ;740e    3e 5a   > Z                (flow from: 740b)
    ld (09970h),a              ;7410    32 70 99    2 p .          (flow from: 740e)
    pop hl                     ;7413    e1      .                  (flow from: 7410)
    pop bc                     ;7414    c1      .                  (flow from: 7413)
    jr l73ach                  ;7415    18 95   . .                (flow from: 7414)
l7417h:
    ld c,a                     ;7417    4f      O                  (flow from: 73b4)
    inc a                      ;7418    3c      <                  (flow from: 7417)
    ld (09971h),a              ;7419    32 71 99    2 q .          (flow from: 7418)
    ld b,000h                  ;741c    06 00   . .                (flow from: 7419)
    ld hl,09973h               ;741e    21 73 99    ! s .          (flow from: 741c)
    add hl,bc                  ;7421    09      .                  (flow from: 741e)
    ld a,(hl)                  ;7422    7e      ~                  (flow from: 7421)
    pop de                     ;7423    d1      .                  (flow from: 7422)
    pop hl                     ;7424    e1      .                  (flow from: 7423)
    pop bc                     ;7425    c1      .                  (flow from: 7424)
    cp a                       ;7426    bf      .                  (flow from: 7425)
    ret                        ;7427    c9      .                  (flow from: 7426)
l7428h:
    push hl                    ;7428    e5      .                  (flow from: 9868)
    ld hl,09971h               ;7429    21 71 99    ! q .          (flow from: 7428)
    dec (hl)                   ;742c    35      5                  (flow from: 7429)
    pop hl                     ;742d    e1      .                  (flow from: 742c)
    ret                        ;742e    c9      .                  (flow from: 742d)
l742fh:
    ld e,d                     ;742f    5a      Z 
    ld a,(bc)                  ;7430    0a      . 
    ld (hl),l                  ;7431    75      u 
    ld c,h                     ;7432    4c      L 
    ld c,075h                  ;7433    0e 75   . u 
    nop                        ;7435    00      . 
sub_7436h:
    ld a,b                     ;7436    78      x 
    cp c                       ;7437    b9      . 
    jp z,sub_7557h             ;7438    ca 57 75    . W u 
    inc b                      ;743b    04      . 
    ld a,(de)                  ;743c    1a      . 
    inc de                     ;743d    13      . 
    call l72fah                ;743e    cd fa 72    . . r 
    call sub_72c1h             ;7441    cd c1 72    . . r 
    ret                        ;7444    c9      . 
sub_7445h:
    ld a,b                     ;7445    78      x 
    or a                       ;7446    b7      . 
    jp z,sub_7557h             ;7447    ca 57 75    . W u 
    dec b                      ;744a    05      . 
    dec de                     ;744b    1b      . 
    ld a,(de)                  ;744c    1a      . 
    call l72fah                ;744d    cd fa 72    . . r 
    call sub_74edh             ;7450    cd ed 74    . . t 
    call sub_74edh             ;7453    cd ed 74    . . t 
    call sub_72c1h             ;7456    cd c1 72    . . r 
    ret                        ;7459    c9      . 
sub_745ah:
    ld a,(0996fh)              ;745a    3a 6f 99    : o . 
    cpl                        ;745d    2f      / 
    ld (0996fh),a              ;745e    32 6f 99    2 o . 
    ret                        ;7461    c9      . 
l7462h:
    ld hl,l74bah               ;7462    21 ba 74    ! . t          (flow from: 750b)
    call sub_72a1h             ;7465    cd a1 72    . . r          (flow from: 7462)
    call sub_72c1h             ;7468    cd c1 72    . . r          (flow from: 72a4)
l746bh:
    call sub_72d3h             ;746b    cd d3 72    . . r          (flow from: 72d2 747a 74b2)
    cp 00dh                    ;746e    fe 0d   . .                (flow from: 72f7)
    jp z,l73fch                ;7470    ca fc 73    . . s          (flow from: 746e)
    cp 00ch                    ;7473    fe 0c   . .                (flow from: 7470)
    jr nz,l747ch               ;7475    20 05     .                (flow from: 7473)
    call sub_74e1h             ;7477    cd e1 74    . . t          (flow from: 7475)
    jr l746bh                  ;747a    18 ef   . .                (flow from: 7509)
l747ch:
    cp 008h                    ;747c    fe 08   . .                (flow from: 7475)
    jr nz,l7485h               ;747e    20 05     .                (flow from: 747c)
    call sub_7445h             ;7480    cd 45 74    . E t 
    jr l746bh                  ;7483    18 e6   . . 
l7485h:
    cp 0cch                    ;7485    fe cc   . .                (flow from: 747e)
    jr nz,l748eh               ;7487    20 05     .                (flow from: 7485)
    call sub_745ah             ;7489    cd 5a 74    . Z t 
    jr l746bh                  ;748c    18 dd   . . 
l748eh:
    cp 009h                    ;748e    fe 09   . .                (flow from: 7487)
    jr nz,l7497h               ;7490    20 05     .                (flow from: 748e)
    call sub_7436h             ;7492    cd 36 74    . 6 t 
    jr l746bh                  ;7495    18 d4   . . 
l7497h:
    cp 018h                    ;7497    fe 18   . .                (flow from: 7490)
    jp z,l6281h                ;7499    ca 81 62    . . b          (flow from: 7497)
    cp 020h                    ;749c    fe 20   .                  (flow from: 7499)
    jr nc,l74ach               ;749e    30 0c   0 .                (flow from: 749c)
    add a,040h                 ;74a0    c6 40   . @ 
    inc c                      ;74a2    0c      . 
    jr z,l74b4h                ;74a3    28 0f   ( . 
    push af                    ;74a5    f5      . 
    ld a,040h                  ;74a6    3e 40   > @ 
    call sub_74bch             ;74a8    cd bc 74    . . t 
    pop af                     ;74ab    f1      . 
l74ach:
    inc c                      ;74ac    0c      .                  (flow from: 749e)
    jr z,l74b4h                ;74ad    28 05   ( .                (flow from: 74ac)
    call sub_74bch             ;74af    cd bc 74    . . t          (flow from: 74ad)
    jr l746bh                  ;74b2    18 b7   . .                (flow from: 74e0)
l74b4h:
    dec c                      ;74b4    0d      . 
    call sub_7557h             ;74b5    cd 57 75    . W u 
    jr l746bh                  ;74b8    18 b1   . . 
l74bah:
    ld l,000h                  ;74ba    2e 00   . . 
sub_74bch:
    call l72fah                ;74bc    cd fa 72    . . r          (flow from: 74af)
    push de                    ;74bf    d5      .                  (flow from: 734b)
    push bc                    ;74c0    c5      .                  (flow from: 74bf)
    push af                    ;74c1    f5      .                  (flow from: 74c0)
    ld a,c                     ;74c2    79      y                  (flow from: 74c1)
    sub b                      ;74c3    90      .                  (flow from: 74c2)
    push af                    ;74c4    f5      .                  (flow from: 74c3)
    add a,e                    ;74c5    83      .                  (flow from: 74c4)
    ld l,a                     ;74c6    6f      o                  (flow from: 74c5)
    jr nc,l74cah               ;74c7    30 01   0 .                (flow from: 74c6)
    inc d                      ;74c9    14      . 
l74cah:
    ld h,d                     ;74ca    62      b                  (flow from: 74c7)
    ld e,l                     ;74cb    5d      ]                  (flow from: 74ca)
    dec hl                     ;74cc    2b      +                  (flow from: 74cb)
    pop af                     ;74cd    f1      .                  (flow from: 74cc)
    ld c,a                     ;74ce    4f      O                  (flow from: 74cd)
    ld b,000h                  ;74cf    06 00   . .                (flow from: 74ce)
    jr z,l74d5h                ;74d1    28 02   ( .                (flow from: 74cf)
    lddr                       ;74d3    ed b8   . .                (flow from: 74d1)
l74d5h:
    pop af                     ;74d5    f1      .                  (flow from: 74d3)
    pop bc                     ;74d6    c1      .                  (flow from: 74d5)
    pop de                     ;74d7    d1      .                  (flow from: 74d6)
    ld (de),a                  ;74d8    12      .                  (flow from: 74d7)
    inc de                     ;74d9    13      .                  (flow from: 74d8)
    inc b                      ;74da    04      .                  (flow from: 74d9)
    ld a,b                     ;74db    78      x                  (flow from: 74da)
    cp c                       ;74dc    b9      .                  (flow from: 74db)
    call sub_7534h             ;74dd    cd 34 75    . 4 u          (flow from: 74dc)
    ret                        ;74e0    c9      .                  (flow from: 7556)
sub_74e1h:
    ld a,b                     ;74e1    78      x                  (flow from: 7477)
    or a                       ;74e2    b7      .                  (flow from: 74e1)
    jp z,sub_7557h             ;74e3    ca 57 75    . W u          (flow from: 74e2)
    dec de                     ;74e6    1b      .                  (flow from: 74e3)
    dec b                      ;74e7    05      .                  (flow from: 74e6)
    call sub_74edh             ;74e8    cd ed 74    . . t          (flow from: 74e7)
    jr l74f3h                  ;74eb    18 06   . .                (flow from: 74f2)
sub_74edh:
    ld a,008h                  ;74ed    3e 08   > .                (flow from: 74e8 7545 754c)
    call l72fah                ;74ef    cd fa 72    . . r          (flow from: 74ed)
    ret                        ;74f2    c9      .                  (flow from: 734b)
l74f3h:
    ld a,c                     ;74f3    79      y                  (flow from: 74eb)
    sub b                      ;74f4    90      .                  (flow from: 74f3)
    jr z,l7505h                ;74f5    28 0e   ( .                (flow from: 74f4)
    push hl                    ;74f7    e5      .                  (flow from: 74f5)
    push de                    ;74f8    d5      .                  (flow from: 74f7)
    push bc                    ;74f9    c5      .                  (flow from: 74f8)
    ld c,a                     ;74fa    4f      O                  (flow from: 74f9)
    ld b,000h                  ;74fb    06 00   . .                (flow from: 74fa)
    ld h,d                     ;74fd    62      b                  (flow from: 74fb)
    ld l,e                     ;74fe    6b      k                  (flow from: 74fd)
    inc hl                     ;74ff    23      #                  (flow from: 74fe)
    ldir                       ;7500    ed b0   . .                (flow from: 74ff)
    pop bc                     ;7502    c1      .                  (flow from: 7500)
    pop de                     ;7503    d1      .                  (flow from: 7502)
    pop hl                     ;7504    e1      .                  (flow from: 7503)
l7505h:
    dec c                      ;7505    0d      .                  (flow from: 7504)
    call sub_7534h             ;7506    cd 34 75    . 4 u          (flow from: 7505)
    ret                        ;7509    c9      .                  (flow from: 7556)
    ld c,b                     ;750a    48      H                  (flow from: 73e3)
    jp l7462h                  ;750b    c3 62 74    . b t          (flow from: 750a)
    ld a,b                     ;750e    78      x 
    or b                       ;750f    b0      . 
    call nz,sub_72f8h          ;7510    c4 f8 72    . . r 
    ld b,000h                  ;7513    06 00   . . 
    ld de,09973h               ;7515    11 73 99    . s . 
    call sub_7534h             ;7518    cd 34 75    . 4 u 
    ld b,000h                  ;751b    06 00   . . 
    ld de,09973h               ;751d    11 73 99    . s . 
    jp l746bh                  ;7520    c3 6b 74    . k t 
sub_7523h:
    ld a,b                     ;7523    78      x                  (flow from: 73fc 753b)
    cp c                       ;7524    b9      .                  (flow from: 7523)
    jr z,l752fh                ;7525    28 08   ( .                (flow from: 7524)
    ld a,(de)                  ;7527    1a      . 
    call l72fah                ;7528    cd fa 72    . . r 
    inc b                      ;752b    04      . 
    inc de                     ;752c    13      . 
    jr sub_7523h               ;752d    18 f4   . . 
l752fh:
    ld a,020h                  ;752f    3e 20   >                  (flow from: 7525)
    jp l72fah                  ;7531    c3 fa 72    . . r          (flow from: 752f)
sub_7534h:
    push de                    ;7534    d5      .                  (flow from: 74dd 7506)
    push bc                    ;7535    c5      .                  (flow from: 7534)
    ld a,020h                  ;7536    3e 20   >                  (flow from: 7535)
    call l72fah                ;7538    cd fa 72    . . r          (flow from: 7536)
    call sub_7523h             ;753b    cd 23 75    . # u          (flow from: 734b)
    pop bc                     ;753e    c1      .                  (flow from: 734b)
    ld a,c                     ;753f    79      y                  (flow from: 753e)
    sub b                      ;7540    90      .                  (flow from: 753f)
    inc a                      ;7541    3c      <                  (flow from: 7540)
    inc a                      ;7542    3c      <                  (flow from: 7541)
    push bc                    ;7543    c5      .                  (flow from: 7542)
    ld b,a                     ;7544    47      G                  (flow from: 7543)
    call sub_74edh             ;7545    cd ed 74    . . t          (flow from: 7544)
l7548h:
    dec b                      ;7548    05      .                  (flow from: 74f2 754f)
    jr z,l7551h                ;7549    28 06   ( .                (flow from: 7548)
    dec de                     ;754b    1b      .                  (flow from: 7549)
    call sub_74edh             ;754c    cd ed 74    . . t          (flow from: 754b)
    jr l7548h                  ;754f    18 f7   . .                (flow from: 74f2)
l7551h:
    call sub_72c1h             ;7551    cd c1 72    . . r          (flow from: 7549)
    pop bc                     ;7554    c1      .                  (flow from: 72d2)
    pop de                     ;7555    d1      .                  (flow from: 7554)
    ret                        ;7556    c9      .                  (flow from: 7555)
sub_7557h:
    ld a,0ceh                  ;7557    3e ce   > . 
    jp l72fah                  ;7559    c3 fa 72    . . r 
l755ch:
    push hl                    ;755c    e5      . 
    push de                    ;755d    d5      . 
    push bc                    ;755e    c5      . 
    push af                    ;755f    f5      . 
    ld a,(09972h)              ;7560    3a 72 99    : r . 
    inc a                      ;7563    3c      < 
    jr z,l7577h                ;7564    28 11   ( . 
    ld (09972h),a              ;7566    32 72 99    2 r . 
    ld (09971h),a              ;7569    32 71 99    2 q . 
    ld c,a                     ;756c    4f      O 
    ld b,000h                  ;756d    06 00   . . 
    ld hl,09972h               ;756f    21 72 99    ! r . 
    add hl,bc                  ;7572    09      . 
    pop af                     ;7573    f1      . 
    ld (hl),a                  ;7574    77      w 
    jr l7578h                  ;7575    18 01   . . 
l7577h:
    pop af                     ;7577    f1      . 
l7578h:
    pop bc                     ;7578    c1      . 
    pop de                     ;7579    d1      . 
    pop hl                     ;757a    e1      . 
    ret                        ;757b    c9      . 
    ex af,af'                  ;757c    08      . 
    add a,d                    ;757d    82      . 
    ld (hl),l                  ;757e    75      u 
    inc bc                     ;757f    03      . 
    ld a,b                     ;7580    78      x 
    sub h                      ;7581    94      . 
    inc b                      ;7582    04      . 
    inc bc                     ;7583    03      . 
    ld h,b                     ;7584    60      ` 

; BLOCK 'NEW_string' (start 0x7585 end 0x7588)
NEW_string_start:
    defb 04eh                  ;7585    4e      N 
    defb 045h                  ;7586    45      E 
    defb 057h                  ;7587    57      W 
NEW_string_end:
    rst 38h                    ;7588    ff      . 
    ex af,af'                  ;7589    08      . 
    adc a,a                    ;758a    8f      . 
    ld (hl),l                  ;758b    75      u 
    inc bc                     ;758c    03      . 
    and d                      ;758d    a2      . 
    ld (hl),l                  ;758e    75      u 
    inc b                      ;758f    04      . 
    sub (hl)                   ;7590    96      . 
    ld (hl),l                  ;7591    75      u 

; BLOCK 'NUM_string' (start 0x7592 end 0x7595)
NUM_string_start:
    defb 04eh                  ;7592    4e      N 
    defb 055h                  ;7593    55      U 
    defb 04dh                  ;7594    4d      M 
NUM_string_end:
    rst 38h                    ;7595    ff      . 
    ld ix,l759dh               ;7596    dd 21 9d 75     . ! . u 
    jp l65f7h                  ;759a    c3 f7 65    . . e 
l759dh:
    rst 38h                    ;759d    ff      . 
    ld d,b                     ;759e    50      P 
    ld d,a                     ;759f    57      W 
    ld d,a                     ;75a0    57      W 
    ld d,a                     ;75a1    57      W 
    ex af,af'                  ;75a2    08      . 
    xor b                      ;75a3    a8      . 
    ld (hl),l                  ;75a4    75      u 
    inc bc                     ;75a5    03      . 
    cp e                       ;75a6    bb      . 
    ld (hl),l                  ;75a7    75      u 
    inc b                      ;75a8    04      . 
    xor a                      ;75a9    af      . 
    ld (hl),l                  ;75aa    75      u 

; BLOCK 'VAR_string' (start 0x75ab end 0x75ae)
VAR_string_start:
    defb 056h                  ;75ab    56      V 
    defb 041h                  ;75ac    41      A 
    defb 052h                  ;75ad    52      R 
VAR_string_end:
    rst 38h                    ;75ae    ff      . 
    ld ix,l75b6h               ;75af    dd 21 b6 75     . ! . u 
    jp l65f7h                  ;75b3    c3 f7 65    . . e 
l75b6h:
    rst 38h                    ;75b6    ff      . 
    ld a,03eh                  ;75b7    3e 3e   > > 
    ld a,037h                  ;75b9    3e 37   > 7 
    ex af,af'                  ;75bb    08      . 
    pop bc                     ;75bc    c1      . 
    ld (hl),l                  ;75bd    75      u 
    inc bc                     ;75be    03      . 
    call nc,00475h             ;75bf    d4 75 04    . u . 
    ret z                      ;75c2    c8      . 
    ld (hl),l                  ;75c3    75      u 

; BLOCK 'LST_string' (start 0x75c4 end 0x75c7)
LST_string_start:
    defb 04ch                  ;75c4    4c      L 
    defb 053h                  ;75c5    53      S 
    defb 054h                  ;75c6    54      T 
LST_string_end:
    rst 38h                    ;75c7    ff      . 
    ld ix,l75cfh               ;75c8    dd 21 cf 75     . ! . u 
    jp l65f7h                  ;75cc    c3 f7 65    . . e 
l75cfh:
    rst 38h                    ;75cf    ff      . 
    dec h                      ;75d0    25      % 
    dec h                      ;75d1    25      % 
    ld e,025h                  ;75d2    1e 25   . % 
    ex af,af'                  ;75d4    08      . 
    jp c,00375h                ;75d5    da 75 03    . u . 
    ld sp,hl                   ;75d8    f9      . 
    ld (hl),l                  ;75d9    75      u 
    inc b                      ;75da    04      . 
    pop hl                     ;75db    e1      . 
    ld (hl),l                  ;75dc    75      u 

; BLOCK 'CON_string' (start 0x75dd end 0x75e0)
CON_string_start:
    defb 043h                  ;75dd    43      C 
    defb 04fh                  ;75de    4f      O 
    defb 04eh                  ;75df    4e      N 
CON_string_end:
    rst 38h                    ;75e0    ff      . 
    ld ix,l75e8h               ;75e1    dd 21 e8 75     . ! . u    (flow from: 60bb)
    jp l65f7h                  ;75e5    c3 f7 65    . . e          (flow from: 75e1)
l75e8h:
    rst 38h                    ;75e8    ff      . 
    inc c                      ;75e9    0c      . 
    dec b                      ;75ea    05      . 
    inc c                      ;75eb    0c      . 
    inc c                      ;75ec    0c      . 
    dec b                      ;75ed    05      . 
    rst 38h                    ;75ee    ff      . 
    rst 38h                    ;75ef    ff      . 
    rst 38h                    ;75f0    ff      . 
    rst 38h                    ;75f1    ff      . 
    cp a                       ;75f2    bf      .                  (flow from: 663c)
    ret                        ;75f3    c9      .                  (flow from: 75f2)
    inc de                     ;75f4    13      . 
    rst 38h                    ;75f5    ff      . 
    rst 38h                    ;75f6    ff      . 
    rst 38h                    ;75f7    ff      . 
    rst 38h                    ;75f8    ff      . 
    ex af,af'                  ;75f9    08      . 
    rst 38h                    ;75fa    ff      . 
    ld (hl),l                  ;75fb    75      u 
    inc bc                     ;75fc    03      . 
    ld a,(bc)                  ;75fd    0a      . 
    halt                       ;75fe    76      v 
    inc b                      ;75ff    04      . 
    rlca                       ;7600    07      . 
    halt                       ;7601    76      v 

; BLOCK 'FAIL_string' (start 0x7602 end 0x7606)
FAIL_string_start:
    defb 046h                  ;7602    46      F 
    defb 041h                  ;7603    41      A 
    defb 049h                  ;7604    49      I 
    defb 04ch                  ;7605    4c      L 
FAIL_string_end:
    rst 38h                    ;7606    ff      . 
    or 001h                    ;7607    f6 01   . .                (flow from: 663c)
    ret                        ;7609    c9      .                  (flow from: 7607)
    ex af,af'                  ;760a    08      . 
    djnz $+120                 ;760b    10 76   . v 
    inc bc                     ;760d    03      . 
    ld h,e                     ;760e    63      c 
    halt                       ;760f    76      v 
    inc b                      ;7610    04      . 
    rla                        ;7611    17      . 
    halt                       ;7612    76      v 

; BLOCK 'SYS_string' (start 0x7613 end 0x7616)
SYS_string_start:
    defb 053h                  ;7613    53      S 
    defb 059h                  ;7614    59      Y 
    defb 053h                  ;7615    53      S 
SYS_string_end:
    rst 38h                    ;7616    ff      . 
    ld ix,l761eh               ;7617    dd 21 1e 76     . ! . v 
    jp l65f7h                  ;761b    c3 f7 65    . . e 
l761eh:
    rst 38h                    ;761e    ff      . 
    rst 38h                    ;761f    ff      . 
    dec b                      ;7620    05      . 
    ld a,(bc)                  ;7621    0a      . 
    rst 38h                    ;7622    ff      . 
    ld a,(bc)                  ;7623    0a      . 
    rst 38h                    ;7624    ff      . 
    rst 38h                    ;7625    ff      . 
    rst 38h                    ;7626    ff      . 
    rst 38h                    ;7627    ff      . 
    dec c                      ;7628    0d      . 
    rst 38h                    ;7629    ff      . 
    rst 38h                    ;762a    ff      . 
    rst 38h                    ;762b    ff      . 
    rst 38h                    ;762c    ff      . 
    ld hl,(0980ah)             ;762d    2a 0a 98    * . . 
l7630h:
    call sub_7653h             ;7630    cd 53 76    . S v 
    or a                       ;7633    b7      . 
    ret                        ;7634    c9      . 
    call sub_763bh             ;7635    cd 3b 76    .          ; v 
    ret nz                     ;7638    c0      . 
    jr l7630h                  ;7639    18 f5   . . 
sub_763bh:
    ld hl,(0980ah)             ;763b    2a 0a 98    * . . 
    ld a,(hl)                  ;763e    7e      ~ 
    cp 003h                    ;763f    fe 03   . . 
    ret nz                     ;7641    c0      . 
    call sub_9623h             ;7642    cd 23 96    . # . 
    ld de,(09853h)             ;7645    ed 5b 53 98     . [ S . 
    call sub_6575h             ;7649    cd 75 65    . u e 
    cp 008h                    ;764c    fe 08   . . 
    ret nz                     ;764e    c0      . 
    call sub_9623h             ;764f    cd 23 96    . # . 
    ret                        ;7652    c9      . 
sub_7653h:
    push hl                    ;7653    e5      .                  (flow from: 68b2 7756 7d7f 94a4 955a)
    push de                    ;7654    d5      .                  (flow from: 7653)
    ex de,hl                   ;7655    eb      .                  (flow from: 7654)
    ld hl,09da5h               ;7656    21 a5 9d    ! . .          (flow from: 7655)
    xor a                      ;7659    af      .                  (flow from: 7656)
    scf                        ;765a    37      7                  (flow from: 7659)
    sbc hl,de                  ;765b    ed 52   . R                (flow from: 765a)
    rla                        ;765d    17      .                  (flow from: 765b)
    cp 001h                    ;765e    fe 01   . .                (flow from: 765d)
    pop de                     ;7660    d1      .                  (flow from: 765e)
    pop hl                     ;7661    e1      .                  (flow from: 7660)
    ret                        ;7662    c9      .                  (flow from: 7661)
    ex af,af'                  ;7663    08      . 
    ld l,c                     ;7664    69      i 
    halt                       ;7665    76      v 
    inc bc                     ;7666    03      . 
    and h                      ;7667    a4      . 
    halt                       ;7668    76      v 
    inc b                      ;7669    04      . 
    ld l,(hl)                  ;766a    6e      n 
    halt                       ;766b    76      v 
    cpl                        ;766c    2f      / 
    rst 38h                    ;766d    ff      . 
    ld ix,(09843h)             ;766e    dd 2a 43 98     . * C .    (flow from: 60bb)
    ld l,(ix+006h)             ;7672    dd 6e 06    . n .          (flow from: 766e)
    ld h,(ix+007h)             ;7675    dd 66 07    . f .          (flow from: 7672)
    ld (09847h),hl             ;7678    22 47 98    " G .          (flow from: 7675)
    push hl                    ;767b    e5      .                  (flow from: 7678)
    pop ix                     ;767c    dd e1   . .                (flow from: 767b)
    ld e,(ix+008h)             ;767e    dd 5e 08    . ^ .          (flow from: 767c)
    ld d,(ix+009h)             ;7681    dd 56 09    . V .          (flow from: 767e)
    ld hl,(09849h)             ;7684    2a 49 98    * I .          (flow from: 7681)
l7687h:
    call sub_65f1h             ;7687    cd f1 65    . . e          (flow from: 7684 76a2)
    ret z                      ;768a    c8      .                  (flow from: 65f6)
    ld a,(hl)                  ;768b    7e      ~                  (flow from: 768a)
    cp 00ch                    ;768c    fe 0c   . .                (flow from: 768b)
    jr nz,l769ch               ;768e    20 0c     .                (flow from: 768c)
    push hl                    ;7690    e5      .                  (flow from: 768e)
    call sub_9623h             ;7691    cd 23 96    . # .          (flow from: 7690)
    or a                       ;7694    b7      .                  (flow from: 9628)
    sbc hl,de                  ;7695    ed 52   . R                (flow from: 7694)
    pop hl                     ;7697    e1      .                  (flow from: 7695)
    jr c,l769ch                ;7698    38 02   8 .                (flow from: 7697)
    ld (hl),010h               ;769a    36 10   6 .                (flow from: 7698)
l769ch:
    inc hl                     ;769c    23      #                  (flow from: 768e 7698 769a)
    inc hl                     ;769d    23      #                  (flow from: 769c)
    inc hl                     ;769e    23      #                  (flow from: 769d)
    call sub_9623h             ;769f    cd 23 96    . # .          (flow from: 769e)
    jr l7687h                  ;76a2    18 e3   . .                (flow from: 9628)
    ex af,af'                  ;76a4    08      . 
    xor d                      ;76a5    aa      . 
    halt                       ;76a6    76      v 
    inc bc                     ;76a7    03      . 
    or d                       ;76a8    b2      . 
    halt                       ;76a9    76      v 
    inc b                      ;76aa    04      . 
    or b                       ;76ab    b0      . 
    halt                       ;76ac    76      v 
    cpl                        ;76ad    2f      / 
    ld hl,(0bfffh)             ;76ae    2a ff bf    * . . 
    ret                        ;76b1    c9      . 
    ex af,af'                  ;76b2    08      . 
    cp b                       ;76b3    b8      . 
    halt                       ;76b4    76      v 
    inc bc                     ;76b5    03      . 
    sbc a,076h                 ;76b6    de 76   . v 
    inc b                      ;76b8    04      . 
    ret nz                     ;76b9    c0      . 
    halt                       ;76ba    76      v 

; BLOCK 'CMOD_string' (start 0x76bb end 0x76bf)
CMOD_string_start:
    defb 043h                  ;76bb    43      C 
    defb 04dh                  ;76bc    4d      M 
    defb 04fh                  ;76bd    4f      O 
    defb 044h                  ;76be    44      D 
CMOD_string_end:
    rst 38h                    ;76bf    ff      . 
    ld ix,l76c7h               ;76c0    dd 21 c7 76     . ! . v    (flow from: 60bb)
    jp l65f7h                  ;76c4    c3 f7 65    . . e          (flow from: 76c0)
l76c7h:
    rst 38h                    ;76c7    ff      . 
    rst 38h                    ;76c8    ff      . 
    rst 38h                    ;76c9    ff      . 
    rst 38h                    ;76ca    ff      . 
    dec b                      ;76cb    05      . 
    dec b                      ;76cc    05      . 
    rst 38h                    ;76cd    ff      . 
    rst 38h                    ;76ce    ff      . 
    rst 38h                    ;76cf    ff      . 
    rst 38h                    ;76d0    ff      . 
    ld hl,(09a8eh)             ;76d1    2a 8e 9a    * . .          (flow from: 663c)
    ld (09808h),hl             ;76d4    22 08 98    " . .          (flow from: 76d1)
    ld a,008h                  ;76d7    3e 08   > .                (flow from: 76d4)
    ld (09807h),a              ;76d9    32 07 98    2 . .          (flow from: 76d7)
    cp a                       ;76dc    bf      .                  (flow from: 76d9)
    ret                        ;76dd    c9      .                  (flow from: 76dc)
    ex af,af'                  ;76de    08      . 
    call po,00376h             ;76df    e4 76 03    . v . 
    inc hl                     ;76e2    23      # 
    ld (hl),a                  ;76e3    77      w 
    inc b                      ;76e4    04      . 
    defb 0edh                  ;next byte illegal after ed                                     ;76e5    ed      . 
    halt                       ;76e6    76      v 

; BLOCK 'OPMOD_string' (start 0x76e7 end 0x76ec)
OPMOD_string_start:
    defb 04fh                  ;76e7    4f      O 
    defb 050h                  ;76e8    50      P 
    defb 04dh                  ;76e9    4d      M 
    defb 04fh                  ;76ea    4f      O 
    defb 044h                  ;76eb    44      D 
OPMOD_string_end:
    rst 38h                    ;76ec    ff      . 
    ld ix,l76f4h               ;76ed    dd 21 f4 76     . ! . v 
    jp l65f7h                  ;76f1    c3 f7 65    . . e 
l76f4h:
    rst 38h                    ;76f4    ff      . 
    rst 38h                    ;76f5    ff      . 
    dec b                      ;76f6    05      . 
    rst 38h                    ;76f7    ff      . 
    rst 38h                    ;76f8    ff      . 
    dec b                      ;76f9    05      . 
    rst 38h                    ;76fa    ff      . 
    rst 38h                    ;76fb    ff      . 
    rst 38h                    ;76fc    ff      . 
    rst 38h                    ;76fd    ff      . 
    ld hl,(0980ah)             ;76fe    2a 0a 98    * . . 
    ld a,(hl)                  ;7701    7e      ~ 
    cp 007h                    ;7702    fe 07   . . 
    ret nz                     ;7704    c0      . 
    call sub_7713h             ;7705    cd 13 77    . . w 
    ld (09a8eh),hl             ;7708    22 8e 9a    " . . 
    call sub_9623h             ;770b    cd 23 96    . # . 
    ld (09a91h),hl             ;770e    22 91 9a    " . . 
    cp a                       ;7711    bf      . 
    ret                        ;7712    c9      . 
sub_7713h:
    push hl                    ;7713    e5      .                  (flow from: 7773)
    ld de,(09a8eh)             ;7714    ed 5b 8e 9a     . [ . .    (flow from: 7713)
    ld hl,l8b10h               ;7718    21 10 8b    ! . .          (flow from: 7714)
    or a                       ;771b    b7      .                  (flow from: 7718)
    sbc hl,de                  ;771c    ed 52   . R                (flow from: 771b)
    jp nz,l78ceh               ;771e    c2 ce 78    . . x          (flow from: 771c)
    pop hl                     ;7721    e1      .                  (flow from: 771e)
    ret                        ;7722    c9      .                  (flow from: 7721)
    ex af,af'                  ;7723    08      . 
    add hl,hl                  ;7724    29      ) 
    ld (hl),a                  ;7725    77      w 
    inc bc                     ;7726    03      . 
    rlca                       ;7727    07      . 
    ld a,b                     ;7728    78      x 
    inc b                      ;7729    04      . 
    defb 032h,077h             ;772a    32 77   2 w 

; BLOCK 'CRMOD_string' (start 0x772c end 0x7731)
CRMOD_string_start:
    defb 043h                  ;772c    43      C 
    defb 052h                  ;772d    52      R 
    defb 04dh                  ;772e    4d      M 
    defb 04fh                  ;772f    4f      O 
    defb 044h                  ;7730    44      D 
CRMOD_string_end:
    rst 38h                    ;7731    ff      . 
    ld ix,l7739h               ;7732    dd 21 39 77     . ! 9 w    (flow from: 60bb)
    jp l65f7h                  ;7736    c3 f7 65    . . e          (flow from: 7732)
l7739h:
    rst 38h                    ;7739    ff      . 
    rst 38h                    ;773a    ff      . 
    dec b                      ;773b    05      . 
    rst 38h                    ;773c    ff      . 
    rst 38h                    ;773d    ff      . 
    rst 38h                    ;773e    ff      . 
    rst 38h                    ;773f    ff      . 
    rst 38h                    ;7740    ff      . 
    dec b                      ;7741    05      . 
    rst 38h                    ;7742    ff      . 
    rst 38h                    ;7743    ff      . 
    rst 38h                    ;7744    ff      . 
    rst 38h                    ;7745    ff      . 
    dec b                      ;7746    05      . 
    rst 38h                    ;7747    ff      . 
    dec b                      ;7748    05      . 
    rst 38h                    ;7749    ff      . 
    rst 38h                    ;774a    ff      . 
    rst 38h                    ;774b    ff      . 
    rst 38h                    ;774c    ff      . 
    ld hl,(0980ah)             ;774d    2a 0a 98    * . .          (flow from: 663c)
    ld a,(hl)                  ;7750    7e      ~                  (flow from: 774d)
    cp 010h                    ;7751    fe 10   . .                (flow from: 7750)
    jp nz,l78ceh               ;7753    c2 ce 78    . . x          (flow from: 7751)
    call sub_7653h             ;7756    cd 53 76    . S v          (flow from: 7753)
    jp nz,l78ceh               ;7759    c2 ce 78    . . x          (flow from: 7662)
    push hl                    ;775c    e5      .                  (flow from: 7759)
    ld hl,(09a8eh)             ;775d    2a 8e 9a    * . .          (flow from: 775c)
    call sub_9623h             ;7760    cd 23 96    . # .          (flow from: 775d)
    inc hl                     ;7763    23      #                  (flow from: 9628)
    inc hl                     ;7764    23      #                  (flow from: 7763)
    inc hl                     ;7765    23      #                  (flow from: 7764)
    call sub_9623h             ;7766    cd 23 96    . # .          (flow from: 7765)
    ld (09a89h),hl             ;7769    22 89 9a    " . .          (flow from: 9628)
    inc hl                     ;776c    23      #                  (flow from: 7769)
    inc hl                     ;776d    23      #                  (flow from: 776c)
    inc hl                     ;776e    23      #                  (flow from: 776d)
    ld (09a8bh),hl             ;776f    22 8b 9a    " . .          (flow from: 776e)
    pop hl                     ;7772    e1      .                  (flow from: 776f)
    call sub_7713h             ;7773    cd 13 77    . . w          (flow from: 7772)
    ld (09a8eh),hl             ;7776    22 8e 9a    " . .          (flow from: 7722)
    ex de,hl                   ;7779    eb      .                  (flow from: 7776)
    call sub_6593h             ;777a    cd 93 65    . . e          (flow from: 7779)
    ld (09a91h),hl             ;777d    22 91 9a    " . .          (flow from: 65ea)
    ex de,hl                   ;7780    eb      .                  (flow from: 777d)
    ld (hl),003h               ;7781    36 03   6 .                (flow from: 7780)
    inc hl                     ;7783    23      #                  (flow from: 7781)
    ld (hl),e                  ;7784    73      s                  (flow from: 7783)
    inc hl                     ;7785    23      #                  (flow from: 7784)
    ld (hl),d                  ;7786    72      r                  (flow from: 7785)
    ld hl,(09810h)             ;7787    2a 10 98    * . .          (flow from: 7786)
    ld bc,00003h               ;778a    01 03 00    . . .          (flow from: 7787)
    ldir                       ;778d    ed b0   . .                (flow from: 778a 778d)
    call sub_6593h             ;778f    cd 93 65    . . e          (flow from: 778d)
    ex de,hl                   ;7792    eb      .                  (flow from: 65ea)
    ld (hl),003h               ;7793    36 03   6 .                (flow from: 7792)
    inc hl                     ;7795    23      #                  (flow from: 7793)
    ld (hl),e                  ;7796    73      s                  (flow from: 7795)
    inc hl                     ;7797    23      #                  (flow from: 7796)
    ld (hl),d                  ;7798    72      r                  (flow from: 7797)
    ld hl,(09a8eh)             ;7799    2a 8e 9a    * . .          (flow from: 7798)
    ld (hl),007h               ;779c    36 07   6 .                (flow from: 7799)
    ld hl,(09816h)             ;779e    2a 16 98    * . .          (flow from: 779c)
    ld bc,00003h               ;77a1    01 03 00    . . .          (flow from: 779e)
    ldir                       ;77a4    ed b0   . .                (flow from: 77a1 77a4)
    ld hl,l77b4h               ;77a6    21 b4 77    ! . w          (flow from: 77a4)
    ld (09801h),hl             ;77a9    22 01 98    " . .          (flow from: 77a6)
    ld hl,(09810h)             ;77ac    2a 10 98    * . .          (flow from: 77a9)
    call sub_694ah             ;77af    cd 4a 69    . J i          (flow from: 77ac)
    cp a                       ;77b2    bf      .                  (flow from: 694f)
    ret                        ;77b3    c9      .                  (flow from: 77b2)
l77b4h:
    call sub_9623h             ;77b4    cd 23 96    . # .          (flow from: 9800)
    ld a,(hl)                  ;77b7    7e      ~                  (flow from: 9628)
    cp 010h                    ;77b8    fe 10   . .                (flow from: 77b7)
    jr nz,l77fch               ;77ba    20 40     @                (flow from: 77b8)
    ex de,hl                   ;77bc    eb      .                  (flow from: 77ba)
    ld hl,(09a8bh)             ;77bd    2a 8b 9a    * . .          (flow from: 77bc)
l77c0h:
    ld a,(hl)                  ;77c0    7e      ~                  (flow from: 77bd 77fa)
    cp 010h                    ;77c1    fe 10   . .                (flow from: 77c0)
    jp z,l77fch                ;77c3    ca fc 77    . . w          (flow from: 77c1)
    push hl                    ;77c6    e5      .                  (flow from: 77c3)
    call sub_9623h             ;77c7    cd 23 96    . # .          (flow from: 77c6)
    push hl                    ;77ca    e5      .                  (flow from: 9628)
    call sub_9623h             ;77cb    cd 23 96    . # .          (flow from: 77ca)
    or a                       ;77ce    b7      .                  (flow from: 9628)
    sbc hl,de                  ;77cf    ed 52   . R                (flow from: 77ce)
    jr nz,l77f5h               ;77d1    20 22     "                (flow from: 77cf)
    pop hl                     ;77d3    e1      .                  (flow from: 77d1)
    pop de                     ;77d4    d1      .                  (flow from: 77d3)
    push hl                    ;77d5    e5      .                  (flow from: 77d4)
    inc hl                     ;77d6    23      #                  (flow from: 77d5)
    inc hl                     ;77d7    23      #                  (flow from: 77d6)
    inc hl                     ;77d8    23      #                  (flow from: 77d7)
    ld bc,00003h               ;77d9    01 03 00    . . .          (flow from: 77d8)
    ldir                       ;77dc    ed b0   . .                (flow from: 77d9 77dc)
    dec hl                     ;77de    2b      +                  (flow from: 77dc)
    dec hl                     ;77df    2b      +                  (flow from: 77de)
    dec hl                     ;77e0    2b      +                  (flow from: 77df)
    ex de,hl                   ;77e1    eb      .                  (flow from: 77e0)
    ld hl,(09a89h)             ;77e2    2a 89 9a    * . .          (flow from: 77e1)
    ld bc,00003h               ;77e5    01 03 00    . . .          (flow from: 77e2)
    ldir                       ;77e8    ed b0   . .                (flow from: 77e5 77e8)
    pop de                     ;77ea    d1      .                  (flow from: 77e8)
    ld hl,(09a89h)             ;77eb    2a 89 9a    * . .          (flow from: 77ea)
    ld (hl),003h               ;77ee    36 03   6 .                (flow from: 77eb)
    inc hl                     ;77f0    23      #                  (flow from: 77ee)
    ld (hl),e                  ;77f1    73      s                  (flow from: 77f0)
    inc hl                     ;77f2    23      #                  (flow from: 77f1)
    ld (hl),d                  ;77f3    72      r                  (flow from: 77f2)
    ret                        ;77f4    c9      .                  (flow from: 77f3)
l77f5h:
    pop hl                     ;77f5    e1      .                  (flow from: 77d1 9627)
    pop af                     ;77f6    f1      .                  (flow from: 77f5)
    inc hl                     ;77f7    23      #                  (flow from: 77f6)
    inc hl                     ;77f8    23      #                  (flow from: 77f7)
    inc hl                     ;77f9    23      #                  (flow from: 77f8)
    jr l77c0h                  ;77fa    18 c4   . .                (flow from: 77f9)
l77fch:
    ld hl,(09a8eh)             ;77fc    2a 8e 9a    * . . 
    ld (hl),010h               ;77ff    36 10   6 . 
    call sub_7816h             ;7801    cd 16 78    . . x 
    jp l78ceh                  ;7804    c3 ce 78    . . x 
    ex af,af'                  ;7807    08      . 
    dec c                      ;7808    0d      . 
    ld a,b                     ;7809    78      x 
    inc bc                     ;780a    03      . 
    call nc,00478h             ;780b    d4 78 04    . x . 
    ld d,078h                  ;780e    16 78   . x 

; BLOCK 'CLMOD_string' (start 0x7810 end 0x7815)
CLMOD_string_start:
    defb 043h                  ;7810    43      C 
    defb 04ch                  ;7811    4c      L 
    defb 04dh                  ;7812    4d      M 
    defb 04fh                  ;7813    4f      O 
    defb 044h                  ;7814    44      D 
CLMOD_string_end:
    rst 38h                    ;7815    ff      . 
sub_7816h:
    ld hl,l8b10h               ;7816    21 10 8b    ! . .          (flow from: 60bb)
    ld (09a8eh),hl             ;7819    22 8e 9a    " . .          (flow from: 7816)
    call sub_9623h             ;781c    cd 23 96    . # .          (flow from: 7819)
    ld (09a91h),hl             ;781f    22 91 9a    " . .          (flow from: 9628)
    cp a                       ;7822    bf      .                  (flow from: 781f)
    ret                        ;7823    c9      .                  (flow from: 7822)
l7824h:
    ld de,(0980ah)             ;7824    ed 5b 0a 98     . [ . . 
    ld a,(de)                  ;7828    1a      . 
    cp 007h                    ;7829    fe 07   . . 
    ret nz                     ;782b    c0      . 
    ld hl,(09a8eh)             ;782c    2a 8e 9a    * . . 
    or a                       ;782f    b7      . 
    sbc hl,de                  ;7830    ed 52   . R 
    jr nz,l7837h               ;7832    20 03     . 
l7834h:
    or 001h                    ;7834    f6 01   . . 
    ret                        ;7836    c9      . 
l7837h:
    ld hl,l8b10h               ;7837    21 10 8b    ! . . 
    or a                       ;783a    b7      . 
    sbc hl,de                  ;783b    ed 52   . R 
    jr z,l7834h                ;783d    28 f5   ( . 
    ld a,010h                  ;783f    3e 10   > . 
    ld (de),a                  ;7841    12      . 
    ld hl,l8b10h               ;7842    21 10 8b    ! . . 
    call sub_9623h             ;7845    cd 23 96    . # . 
    inc hl                     ;7848    23      # 
    inc hl                     ;7849    23      # 
    inc hl                     ;784a    23      # 
    call sub_9623h             ;784b    cd 23 96    . # . 
    ld (09a89h),hl             ;784e    22 89 9a    " . . 
    inc hl                     ;7851    23      # 
    inc hl                     ;7852    23      # 
    inc hl                     ;7853    23      # 
    ld (09a8bh),hl             ;7854    22 8b 9a    " . . 
    ld hl,l7883h               ;7857    21 83 78    ! . x 
    ld (09801h),hl             ;785a    22 01 98    " . . 
    ex de,hl                   ;785d    eb      . 
    call sub_9623h             ;785e    cd 23 96    . # . 
    push hl                    ;7861    e5      . 
    call sub_694ah             ;7862    cd 4a 69    . J i 
    pop hl                     ;7865    e1      . 
    inc hl                     ;7866    23      # 
    inc hl                     ;7867    23      # 
    inc hl                     ;7868    23      # 
    call sub_9623h             ;7869    cd 23 96    . # . 
    inc hl                     ;786c    23      # 
    inc hl                     ;786d    23      # 
    inc hl                     ;786e    23      # 
l786fh:
    ld a,(hl)                  ;786f    7e      ~ 
    cp 010h                    ;7870    fe 10   . . 
    ret z                      ;7872    c8      . 
    call sub_9623h             ;7873    cd 23 96    . # . 
    push hl                    ;7876    e5      . 
    call sub_9623h             ;7877    cd 23 96    . # . 
    call sub_7b31h             ;787a    cd 31 7b    . 1 { 
    pop hl                     ;787d    e1      . 
    inc hl                     ;787e    23      # 
    inc hl                     ;787f    23      # 
    inc hl                     ;7880    23      # 
    jr l786fh                  ;7881    18 ec   . . 
l7883h:
    push hl                    ;7883    e5      . 
    push de                    ;7884    d5      . 
    push bc                    ;7885    c5      . 
    inc hl                     ;7886    23      # 
    ld c,(hl)                  ;7887    4e      N 
    inc hl                     ;7888    23      # 
    ld b,(hl)                  ;7889    46      F 
    ld h,b                     ;788a    60      ` 
    ld l,c                     ;788b    69      i 
    call sub_7f9fh             ;788c    cd 9f 7f    . .  
    ld hl,(09a89h)             ;788f    2a 89 9a    * . . 
l7892h:
    ld a,(hl)                  ;7892    7e      ~ 
    cp 003h                    ;7893    fe 03   . . 
    jr nz,l78c5h               ;7895    20 2e     . 
    inc hl                     ;7897    23      # 
    ld e,(hl)                  ;7898    5e      ^ 
    inc hl                     ;7899    23      # 
    ld d,(hl)                  ;789a    56      V 
    ex de,hl                   ;789b    eb      . 
    push hl                    ;789c    e5      . 
    call sub_9623h             ;789d    cd 23 96    . # . 
    or a                       ;78a0    b7      . 
    sbc hl,bc                  ;78a1    ed 42   . B 
    pop hl                     ;78a3    e1      . 
    jr nz,l78c9h               ;78a4    20 23     # 
    dec de                     ;78a6    1b      . 
    dec de                     ;78a7    1b      . 
    inc hl                     ;78a8    23      # 
    inc hl                     ;78a9    23      # 
    inc hl                     ;78aa    23      # 
    ld bc,00003h               ;78ab    01 03 00    . . . 
    ldir                       ;78ae    ed b0   . . 
    ex de,hl                   ;78b0    eb      . 
    ld hl,(09a8bh)             ;78b1    2a 8b 9a    * . . 
    inc hl                     ;78b4    23      # 
    inc hl                     ;78b5    23      # 
    dec de                     ;78b6    1b      . 
    ld bc,00003h               ;78b7    01 03 00    . . . 
    lddr                       ;78ba    ed b8   . . 
    dec de                     ;78bc    1b      . 
    dec de                     ;78bd    1b      . 
    inc hl                     ;78be    23      # 
    ld (hl),003h               ;78bf    36 03   6 . 
    inc hl                     ;78c1    23      # 
    ld (hl),e                  ;78c2    73      s 
    inc hl                     ;78c3    23      # 
    ld (hl),d                  ;78c4    72      r 
l78c5h:
    pop bc                     ;78c5    c1      . 
    pop de                     ;78c6    d1      . 
    pop hl                     ;78c7    e1      . 
    ret                        ;78c8    c9      . 
l78c9h:
    inc hl                     ;78c9    23      # 
    inc hl                     ;78ca    23      # 
    inc hl                     ;78cb    23      # 
    jr l7892h                  ;78cc    18 c4   . . 
l78ceh:
    ld hl,0000ch               ;78ce    21 0c 00    ! . . 
    jp l62a7h                  ;78d1    c3 a7 62    . . b 
    ex af,af'                  ;78d4    08      . 
    jp c,00378h                ;78d5    da 78 03    . x . 
    dec bc                     ;78d8    0b      . 
    ld a,c                     ;78d9    79      y 
    inc b                      ;78da    04      . 
    ex (sp),hl                 ;78db    e3      . 
    ld a,b                     ;78dc    78      x 

; BLOCK 'SPACE_string' (start 0x78dd end 0x78e2)
SPACE_string_start:
    defb 053h                  ;78dd    53      S 
    defb 050h                  ;78de    50      P 
    defb 041h                  ;78df    41      A 
    defb 043h                  ;78e0    43      C 
    defb 045h                  ;78e1    45      E 
SPACE_string_end:
    rst 38h                    ;78e2    ff      . 
    ld ix,l78eah               ;78e3    dd 21 ea 78     . ! . x 
    jp l65f7h                  ;78e7    c3 f7 65    . . e 
l78eah:
    rst 38h                    ;78ea    ff      . 
    rst 38h                    ;78eb    ff      . 
    rst 38h                    ;78ec    ff      . 
    rst 38h                    ;78ed    ff      . 
    dec b                      ;78ee    05      . 
    dec b                      ;78ef    05      . 
    rst 38h                    ;78f0    ff      . 
    rst 38h                    ;78f1    ff      . 
    rst 38h                    ;78f2    ff      . 
    rst 38h                    ;78f3    ff      . 
    call sub_6713h             ;78f4    cd 13 67    . . g 
    ld a,(09860h)              ;78f7    3a 60 98    : ` . 
    rrca                       ;78fa    0f      . 
    rrca                       ;78fb    0f      . 
    and 03fh                   ;78fc    e6 3f   . ? 
    ld l,a                     ;78fe    6f      o 
    ld h,000h                  ;78ff    26 00   & . 
    ld a,004h                  ;7901    3e 04   > . 
    ld (09808h),hl             ;7903    22 08 98    " . . 
    ld (09807h),a              ;7906    32 07 98    2 . . 
    cp a                       ;7909    bf      . 
    ret                        ;790a    c9      . 
    ex af,af'                  ;790b    08      . 
    ld de,00379h               ;790c    11 79 03    . y . 
    ld a,c                     ;790f    79      y 
    ld a,e                     ;7910    7b      { 
    inc b                      ;7911    04      . 
    ld d,079h                  ;7912    16 79   . y 
    adc a,0ffh                 ;7914    ce ff   . . 
    ld de,(09853h)             ;7916    ed 5b 53 98     . [ S . 
    ld hl,(0984fh)             ;791a    2a 4f 98    * O . 
    call sub_6575h             ;791d    cd 75 65    . u e 
    cp 003h                    ;7920    fe 03   . . 
    ret nz                     ;7922    c0      . 
    call sub_9623h             ;7923    cd 23 96    . # . 
    push hl                    ;7926    e5      . 
    call sub_6575h             ;7927    cd 75 65    . u e 
    ld (0984fh),hl             ;792a    22 4f 98    " O . 
    pop hl                     ;792d    e1      . 
    inc hl                     ;792e    23      # 
    inc hl                     ;792f    23      # 
    inc hl                     ;7930    23      # 
    call sub_6575h             ;7931    cd 75 65    . u e 
    cp 003h                    ;7934    fe 03   . . 
    ret nz                     ;7936    c0      . 
    call sub_9623h             ;7937    cd 23 96    . # . 
    ld bc,09807h               ;793a    01 07 98    . . . 
    ld a,0ffh                  ;793d    3e ff   > . 
    ld (09870h),a              ;793f    32 70 98    2 p . 
    call sub_7953h             ;7942    cd 53 79    . S y 
    ld hl,09807h               ;7945    21 07 98    ! . . 
    ld de,(0984fh)             ;7948    ed 5b 4f 98     . [ O . 
    ld bc,00003h               ;794c    01 03 00    . . . 
    ldir                       ;794f    ed b0   . . 
    cp a                       ;7951    bf      . 
    ret                        ;7952    c9      . 
sub_7953h:
    push hl                    ;7953    e5      . 
    push bc                    ;7954    c5      . 
l7955h:
    call sub_6575h             ;7955    cd 75 65    . u e 
    push de                    ;7958    d5      . 
    ld de,(0984fh)             ;7959    ed 5b 4f 98     . [ O . 
    or a                       ;795d    b7      . 
    push hl                    ;795e    e5      . 
    sbc hl,de                  ;795f    ed 52   . R 
    pop hl                     ;7961    e1      . 
    pop de                     ;7962    d1      . 
    jr z,l79dah                ;7963    28 75   ( u 
    cp 003h                    ;7965    fe 03   . . 
    jr nz,l7987h               ;7967    20 1e     . 
    push hl                    ;7969    e5      . 
    call sub_6593h             ;796a    cd 93 65    . . e 
    ld a,003h                  ;796d    3e 03   > . 
    ld (bc),a                  ;796f    02      . 
    inc bc                     ;7970    03      . 
    ld a,l                     ;7971    7d      } 
    ld (bc),a                  ;7972    02      . 
    inc bc                     ;7973    03      . 
    ld a,h                     ;7974    7c      | 
    ld (bc),a                  ;7975    02      . 
    ld b,h                     ;7976    44      D 
    ld c,l                     ;7977    4d      M 
    pop hl                     ;7978    e1      . 
    call sub_9623h             ;7979    cd 23 96    . # . 
    call sub_7953h             ;797c    cd 53 79    . S y 
    inc hl                     ;797f    23      # 
    inc hl                     ;7980    23      # 
    inc hl                     ;7981    23      # 
    inc bc                     ;7982    03      . 
    inc bc                     ;7983    03      . 
    inc bc                     ;7984    03      . 
    jr l7955h                  ;7985    18 ce   . . 
l7987h:
    cp 000h                    ;7987    fe 00   . . 
    jr nz,l79dah               ;7989    20 4f     O 
    ld ix,0986fh               ;798b    dd 21 6f 98     . ! o . 
l798fh:
    ld a,(ix+001h)             ;798f    dd 7e 01    . ~ . 
    cp 0ffh                    ;7992    fe ff   . . 
    jr z,l79abh                ;7994    28 15   ( . 
    push de                    ;7996    d5      . 
    ld d,a                     ;7997    57      W 
    ld e,(ix+000h)             ;7998    dd 5e 00    . ^ . 
    call sub_65f1h             ;799b    cd f1 65    . . e 
    pop de                     ;799e    d1      . 
    jr z,l79c0h                ;799f    28 1f   ( . 
    inc ix                     ;79a1    dd 23   . # 
    inc ix                     ;79a3    dd 23   . # 
    inc ix                     ;79a5    dd 23   . # 
    inc ix                     ;79a7    dd 23   . # 
    jr l798fh                  ;79a9    18 e4   . . 
l79abh:
    ld (ix+000h),l             ;79ab    dd 75 00    . u . 
    ld (ix+001h),h             ;79ae    dd 74 01    . t . 
    ld (ix+002h),c             ;79b1    dd 71 02    . q . 
    ld (ix+003h),b             ;79b4    dd 70 03    . p . 
    ld (ix+005h),0ffh          ;79b7    dd 36 05 ff     . 6 . . 
    ld a,000h                  ;79bb    3e 00   > . 
    ld (bc),a                  ;79bd    02      . 
    jr l79e3h                  ;79be    18 23   . # 
l79c0h:
    ld l,(ix+002h)             ;79c0    dd 6e 02    . n . 
    bit 0,l                    ;79c3    cb 45   . E 
    ld h,(ix+003h)             ;79c5    dd 66 03    . f . 
    ld a,001h                  ;79c8    3e 01   > . 
    jr z,l79d1h                ;79ca    28 05   ( . 
    ld a,005h                  ;79cc    3e 05   > . 
    dec hl                     ;79ce    2b      + 
    dec hl                     ;79cf    2b      + 
    dec hl                     ;79d0    2b      + 
l79d1h:
    ld (bc),a                  ;79d1    02      . 
    inc bc                     ;79d2    03      . 
    ld a,l                     ;79d3    7d      } 
    ld (bc),a                  ;79d4    02      . 
    inc bc                     ;79d5    03      . 
    ld a,h                     ;79d6    7c      | 
    ld (bc),a                  ;79d7    02      . 
    jr l79e3h                  ;79d8    18 09   . . 
l79dah:
    push de                    ;79da    d5      . 
    ld d,b                     ;79db    50      P 
    ld e,c                     ;79dc    59      Y 
    ld bc,00003h               ;79dd    01 03 00    . . . 
    ldir                       ;79e0    ed b0   . . 
    pop de                     ;79e2    d1      . 
l79e3h:
    pop bc                     ;79e3    c1      . 
    pop hl                     ;79e4    e1      . 
    ret                        ;79e5    c9      . 
sub_79e6h:
    push de                    ;79e6    d5      .                  (flow from: 6ce1 9742)
    push bc                    ;79e7    c5      .                  (flow from: 79e6)
    xor a                      ;79e8    af      .                  (flow from: 79e7)
    ld (09ce4h),a              ;79e9    32 e4 9c    2 . .          (flow from: 79e8)
    ld de,09ca5h               ;79ec    11 a5 9c    . . .          (flow from: 79e9)
    ld hl,l6000h               ;79ef    21 00 60    ! . `          (flow from: 79ec)
    call sub_7a81h             ;79f2    cd 81 7a    . . z          (flow from: 79ef)
    jp z,l7a7ch                ;79f5    ca 7c 7a    . | z          (flow from: 7a84 7aac)
    ld hl,(09a8eh)             ;79f8    2a 8e 9a    * . .          (flow from: 79f5)
    call sub_9623h             ;79fb    cd 23 96    . # .          (flow from: 79f8)
    push hl                    ;79fe    e5      .                  (flow from: 9628)
    call sub_7a81h             ;79ff    cd 81 7a    . . z          (flow from: 79fe)
    jr z,l7a1ch                ;7a02    28 18   ( .                (flow from: 7a84 7aac)
    pop hl                     ;7a04    e1      .                  (flow from: 7a02)
    inc hl                     ;7a05    23      #                  (flow from: 7a04)
    inc hl                     ;7a06    23      #                  (flow from: 7a05)
    inc hl                     ;7a07    23      #                  (flow from: 7a06)
    call sub_9623h             ;7a08    cd 23 96    . # .          (flow from: 7a07)
    push hl                    ;7a0b    e5      .                  (flow from: 9628)
    call sub_7a81h             ;7a0c    cd 81 7a    . . z          (flow from: 7a0b)
    jr z,l7a1ch                ;7a0f    28 0b   ( .                (flow from: 7a84 7aac)
    pop hl                     ;7a11    e1      .                  (flow from: 7a0f)
    inc hl                     ;7a12    23      #                  (flow from: 7a11)
    inc hl                     ;7a13    23      #                  (flow from: 7a12)
    inc hl                     ;7a14    23      #                  (flow from: 7a13)
    ld (09a8bh),hl             ;7a15    22 8b 9a    " . .          (flow from: 7a14)
    push hl                    ;7a18    e5      .                  (flow from: 7a15)
    call sub_7a81h             ;7a19    cd 81 7a    . . z          (flow from: 7a18)
l7a1ch:
    inc sp                     ;7a1c    33      3                  (flow from: 7a02 7a0f 7a84 7aac)
    inc sp                     ;7a1d    33      3                  (flow from: 7a1c)
    jr z,l7a7ch                ;7a1e    28 5c   ( \                (flow from: 7a1d)
    call sub_6593h             ;7a20    cd 93 65    . . e          (flow from: 7a1e)
    push hl                    ;7a23    e5      .                  (flow from: 65ea)
    inc hl                     ;7a24    23      #                  (flow from: 7a23)
    inc hl                     ;7a25    23      #                  (flow from: 7a24)
    inc hl                     ;7a26    23      #                  (flow from: 7a25)
    ld de,(09a8bh)             ;7a27    ed 5b 8b 9a     . [ . .    (flow from: 7a26)
    ex de,hl                   ;7a2b    eb      .                  (flow from: 7a27)
    ld bc,00003h               ;7a2c    01 03 00    . . .          (flow from: 7a2b)
    ldir                       ;7a2f    ed b0   . .                (flow from: 7a2c 7a2f)
    pop de                     ;7a31    d1      .                  (flow from: 7a2f)
    ld hl,(09a8bh)             ;7a32    2a 8b 9a    * . .          (flow from: 7a31)
    ld (hl),003h               ;7a35    36 03   6 .                (flow from: 7a32)
    inc hl                     ;7a37    23      #                  (flow from: 7a35)
    ld (hl),e                  ;7a38    73      s                  (flow from: 7a37)
    inc hl                     ;7a39    23      #                  (flow from: 7a38)
    ld (hl),d                  ;7a3a    72      r                  (flow from: 7a39)
    ld hl,09ca5h               ;7a3b    21 a5 9c    ! . .          (flow from: 7a3a)
    call sub_7ab5h             ;7a3e    cd b5 7a    . . z          (flow from: 7a3b)
    call sub_7ad1h             ;7a41    cd d1 7a    . . z          (flow from: 7ac6)
    jr z,l7a5dh                ;7a44    28 17   ( .                (flow from: 7b30)
    call sub_6713h             ;7a46    cd 13 67    . . g 
    call sub_7ad1h             ;7a49    cd d1 7a    . . z 
    jr z,l7a5dh                ;7a4c    28 0f   ( . 
    ld hl,(09a8bh)             ;7a4e    2a 8b 9a    * . . 
    inc de                     ;7a51    13      . 
    inc de                     ;7a52    13      . 
    inc de                     ;7a53    13      . 
    ex de,hl                   ;7a54    eb      . 
    ld bc,00003h               ;7a55    01 03 00    . . . 
    ldir                       ;7a58    ed b0   . . 
    jp l6271h                  ;7a5a    c3 71 62    . q b 
l7a5dh:
    ex de,hl                   ;7a5d    eb      .                  (flow from: 7a44)
    ld (hl),008h               ;7a5e    36 08   6 .                (flow from: 7a5d)
    inc hl                     ;7a60    23      #                  (flow from: 7a5e)
    ld (hl),e                  ;7a61    73      s                  (flow from: 7a60)
    inc hl                     ;7a62    23      #                  (flow from: 7a61)
    ld (hl),d                  ;7a63    72      r                  (flow from: 7a62)
    ex de,hl                   ;7a64    eb      .                  (flow from: 7a63)
    push hl                    ;7a65    e5      .                  (flow from: 7a64)
    ld (hl),010h               ;7a66    36 10   6 .                (flow from: 7a65)
    inc hl                     ;7a68    23      #                  (flow from: 7a66)
    inc hl                     ;7a69    23      #                  (flow from: 7a68)
    inc hl                     ;7a6a    23      #                  (flow from: 7a69)
    ld de,09ca5h               ;7a6b    11 a5 9c    . . .          (flow from: 7a6a)
l7a6eh:
    ld a,(de)                  ;7a6e    1a      .                  (flow from: 7a6b 7a76)
    ld (hl),a                  ;7a6f    77      w                  (flow from: 7a6e)
    cp 0feh                    ;7a70    fe fe   . .                (flow from: 7a6f)
    jr z,l7a78h                ;7a72    28 04   ( .                (flow from: 7a70)
    inc hl                     ;7a74    23      #                  (flow from: 7a72)
    inc de                     ;7a75    13      .                  (flow from: 7a74)
    jr l7a6eh                  ;7a76    18 f6   . .                (flow from: 7a75)
l7a78h:
    ld (hl),0ffh               ;7a78    36 ff   6 .                (flow from: 7a72)
    pop hl                     ;7a7a    e1      .                  (flow from: 7a78)
    cp a                       ;7a7b    bf      .                  (flow from: 7a7a)
l7a7ch:
    ld a,008h                  ;7a7c    3e 08   > .                (flow from: 79f5 7a1e 7a7b)
    pop bc                     ;7a7e    c1      .                  (flow from: 7a7c)
    pop de                     ;7a7f    d1      .                  (flow from: 7a7e)
    ret                        ;7a80    c9      .                  (flow from: 7a7f)
sub_7a81h:
    ld a,(hl)                  ;7a81    7e      ~                  (flow from: 79f2 79ff 7a0c 7a19 7ab3)
    cp 003h                    ;7a82    fe 03   . .                (flow from: 7a81 7a89d)
    ret nz                     ;7a84    c0      .                  (flow from: 7a82)
    call sub_9623h             ;7a85    cd 23 96    . # .          (flow from: 7a84)
    ld a,(hl)                  ;7a88    7e      ~                  (flow from: 9628)
    cp 008h                    ;7a89    fe 08   . .                (flow from: 7a88)
    call nz,sub_6259h          ;7a8b    c4 59 62    . Y b          (flow from: 7a89 7a92)
    push hl                    ;7a8e    e5      .                  (flow from: 7a8b)
    call sub_9623h             ;7a8f    cd 23 96    . # .          (flow from: 7a8e)
    push hl                    ;7a92    e5      .                  (flow from: 9628)
    push de                    ;7a93    d5      .                  (flow from: 7a92)
    inc hl                     ;7a94    23      #                  (flow from: 7a93)
    inc hl                     ;7a95    23      #                  (flow from: 7a94)
    inc hl                     ;7a96    23      #                  (flow from: 7a95)
l7a97h:
    ld a,(de)                  ;7a97    1a      .                  (flow from: 7a96 7a9d)
    cp (hl)                    ;7a98    be      .                  (flow from: 7a97 96247)
    jr nz,l7a9fh               ;7a99    20 04     .                (flow from: 7a98)
    inc hl                     ;7a9b    23      #                  (flow from: 7a99)
    inc de                     ;7a9c    13      .                  (flow from: 7a9b)
    jr l7a97h                  ;7a9d    18 f8   . .                (flow from: 7a9c)
l7a9fh:
    cp 0feh                    ;7a9f    fe fe   . .                (flow from: 7a99)
    jr nz,l7aadh               ;7aa1    20 0a     .                (flow from: 7a9f)
    ld a,(hl)                  ;7aa3    7e      ~                  (flow from: 7aa1)
    cp 0ffh                    ;7aa4    fe ff   . .                (flow from: 7aa3)
    jr nz,l7aadh               ;7aa6    20 05     .                (flow from: 7aa4)
    pop de                     ;7aa8    d1      .                  (flow from: 7aa6)
    pop hl                     ;7aa9    e1      .                  (flow from: 7aa8)
    pop af                     ;7aaa    f1      .                  (flow from: 7aa9)
    cp a                       ;7aab    bf      .                  (flow from: 7aaa)
    ret                        ;7aac    c9      .                  (flow from: 7aab)
l7aadh:
    pop de                     ;7aad    d1      .                  (flow from: 7aa1 7aa6)
    pop hl                     ;7aae    e1      .                  (flow from: 7aad 96)
    pop hl                     ;7aaf    e1      .                  (flow from: 7aae)
    inc hl                     ;7ab0    23      #                  (flow from: 7aaf)
    inc hl                     ;7ab1    23      #                  (flow from: 7ab0)
    inc hl                     ;7ab2    23      #                  (flow from: 7ab1)
    jr sub_7a81h               ;7ab3    18 cc   . .                (flow from: 7a9 7ab2)
sub_7ab5h:
    ld b,080h                  ;7ab5    06 80   . .                (flow from: 7a3e)
    push hl                    ;7ab7    e5      .                  (flow from: 7ab5)
    push de                    ;7ab8    d5      .                  (flow from: 7ab7)
    ld d,005h                  ;7ab9    16 05   . .                (flow from: 7ab8)
l7abbh:
    ld a,(hl)                  ;7abb    7e      ~                  (flow from: 7ab9 7ac9 7acf)
    cp 0feh                    ;7abc    fe fe   . .                (flow from: 7abb)
    jr z,l7ac4h                ;7abe    28 04   ( .                (flow from: 7abc)
    cp 0ffh                    ;7ac0    fe ff   . .                (flow from: 7abe)
    jr nz,l7ac7h               ;7ac2    20 03     .                (flow from: 7ac0)
l7ac4h:
    pop de                     ;7ac4    d1      .                  (flow from: 7abe)
    pop hl                     ;7ac5    e1      .                  (flow from: 7ac4)
    ret                        ;7ac6    c9      .                  (flow from: 7ac5)
l7ac7h:
    inc hl                     ;7ac7    23      #                  (flow from: 7ac2)
    dec d                      ;7ac8    15      .                  (flow from: 7ac7)
    jr nz,l7abbh               ;7ac9    20 f0     .                (flow from: 7ac8)
    ld d,008h                  ;7acb    16 08   . .                (flow from: 7ac9)
    sra b                      ;7acd    cb 28   . (                (flow from: 7acb)
    jr l7abbh                  ;7acf    18 ea   . .                (flow from: 7acd)
sub_7ad1h:
    push bc                    ;7ad1    c5      .                  (flow from: 7a41)
    push de                    ;7ad2    d5      .                  (flow from: 7ad1)
    ld hl,09a99h               ;7ad3    21 99 9a    ! . .          (flow from: 7ad2)
    ld c,000h                  ;7ad6    0e 00   . .                (flow from: 7ad3)
l7ad8h:
    ld a,(hl)                  ;7ad8    7e      ~                  (flow from: 7ad6 7ade)
    or a                       ;7ad9    b7      .                  (flow from: 7ad8)
    jr nz,l7ae5h               ;7ada    20 09     .                (flow from: 7ad9)
    inc hl                     ;7adc    23      #                  (flow from: 7ada)
l7addh:
    inc c                      ;7add    0c      .                  (flow from: 7adc)
    jr nz,l7ad8h               ;7ade    20 f8     .                (flow from: 7add)
    or 001h                    ;7ae0    f6 01   . . 
    pop de                     ;7ae2    d1      . 
    pop bc                     ;7ae3    c1      . 
    ret                        ;7ae4    c9      . 
l7ae5h:
    ld d,008h                  ;7ae5    16 08   . .                (flow from: 7ada)
    inc hl                     ;7ae7    23      #                  (flow from: 7ae5)
    ld e,(hl)                  ;7ae8    5e      ^                  (flow from: 7ae7)
l7ae9h:
    push af                    ;7ae9    f5      .                  (flow from: 7ae8 7af6)
    xor b                      ;7aea    a8      .                  (flow from: 7ae9)
    and b                      ;7aeb    a0      .                  (flow from: 7aea)
    jr z,l7af8h                ;7aec    28 0a   ( .                (flow from: 7aeb)
    pop af                     ;7aee    f1      .                  (flow from: 7aec)
    dec d                      ;7aef    15      .                  (flow from: 7aee)
    jr z,l7addh                ;7af0    28 eb   ( .                (flow from: 7aef)
    rl e                       ;7af2    cb 13   . .                (flow from: 7af0)
    rl a                       ;7af4    cb 17   . .                (flow from: 7af2)
    jr l7ae9h                  ;7af6    18 f1   . .                (flow from: 7af4)
l7af8h:
    pop af                     ;7af8    f1      .                  (flow from: 7aec)
    push af                    ;7af9    f5      .                  (flow from: 7af8)
    xor b                      ;7afa    a8      .                  (flow from: 7af9)
    ld b,a                     ;7afb    47      G                  (flow from: 7afa)
    pop af                     ;7afc    f1      .                  (flow from: 7afb)
    ld a,d                     ;7afd    7a      z                  (flow from: 7afc)
l7afeh:
    rl e                       ;7afe    cb 13   . .                (flow from: 7afd 7b03)
    rl b                       ;7b00    cb 10   . .                (flow from: 7afe)
    dec a                      ;7b02    3d      =                  (flow from: 7b00)
    jr nz,l7afeh               ;7b03    20 f9     .                (flow from: 7b02)
    rl e                       ;7b05    cb 13   . .                (flow from: 7b03)
    ld (hl),b                  ;7b07    70      p                  (flow from: 7b05)
    dec hl                     ;7b08    2b      +                  (flow from: 7b07)
    ld (hl),e                  ;7b09    73      s                  (flow from: 7b08)
    ld a,008h                  ;7b0a    3e 08   > .                (flow from: 7b09)
    sub d                      ;7b0c    92      .                  (flow from: 7b0a)
    ld b,000h                  ;7b0d    06 00   . .                (flow from: 7b0c)
    sla c                      ;7b0f    cb 21   . !                (flow from: 7b0d)
    rl b                       ;7b11    cb 10   . .                (flow from: 7b0f)
    sla c                      ;7b13    cb 21   . !                (flow from: 7b11)
    rl b                       ;7b15    cb 10   . .                (flow from: 7b13)
    sla c                      ;7b17    cb 21   . !                (flow from: 7b15)
    rl b                       ;7b19    cb 10   . .                (flow from: 7b17)
    or c                       ;7b1b    b1      .                  (flow from: 7b19)
    ld c,a                     ;7b1c    4f      O                  (flow from: 7b1b)
    sla c                      ;7b1d    cb 21   . !                (flow from: 7b1c)
    rl b                       ;7b1f    cb 10   . .                (flow from: 7b1d)
    sla c                      ;7b21    cb 21   . !                (flow from: 7b1f)
    rl b                       ;7b23    cb 10   . .                (flow from: 7b21)
    sla c                      ;7b25    cb 21   . !                (flow from: 7b23)
    rl b                       ;7b27    cb 10   . .                (flow from: 7b25)
    ld hl,(09805h)             ;7b29    2a 05 98    * . .          (flow from: 7b27)
    add hl,bc                  ;7b2c    09      .                  (flow from: 7b29)
    cp a                       ;7b2d    bf      .                  (flow from: 7b2c)
    pop de                     ;7b2e    d1      .                  (flow from: 7b2d)
    pop bc                     ;7b2f    c1      .                  (flow from: 7b2e)
    ret                        ;7b30    c9      .                  (flow from: 7b2f)
sub_7b31h:
    push de                    ;7b31    d5      . 
    push bc                    ;7b32    c5      . 
    push hl                    ;7b33    e5      . 
    push hl                    ;7b34    e5      . 
    ld de,(09805h)             ;7b35    ed 5b 05 98     . [ . . 
    or a                       ;7b39    b7      . 
    sbc hl,de                  ;7b3a    ed 52   . R 
    ld b,000h                  ;7b3c    06 00   . . 
    ld d,b                     ;7b3e    50      P 
    sla l                      ;7b3f    cb 25   . % 
    rl h                       ;7b41    cb 14   . . 
    sla l                      ;7b43    cb 25   . % 
    rl h                       ;7b45    cb 14   . . 
    ld c,h                     ;7b47    4c      L 
    sla l                      ;7b48    cb 25   . % 
    rl d                       ;7b4a    cb 12   . . 
    sla l                      ;7b4c    cb 25   . % 
    rl d                       ;7b4e    cb 12   . . 
    sla l                      ;7b50    cb 25   . % 
    rl d                       ;7b52    cb 12   . . 
    ld hl,09a99h               ;7b54    21 99 9a    ! . . 
    add hl,bc                  ;7b57    09      . 
    ex (sp),hl                 ;7b58    e3      . 
    inc hl                     ;7b59    23      # 
    inc hl                     ;7b5a    23      # 
    inc hl                     ;7b5b    23      # 
    call sub_7ab5h             ;7b5c    cd b5 7a    . . z 
    or a                       ;7b5f    b7      . 
    ld c,000h                  ;7b60    0e 00   . . 
    inc d                      ;7b62    14      . 
    dec d                      ;7b63    15      . 
    jr z,l7b6dh                ;7b64    28 07   ( . 
l7b66h:
    rr b                       ;7b66    cb 18   . . 
    rr c                       ;7b68    cb 19   . . 
    dec d                      ;7b6a    15      . 
    jr nz,l7b66h               ;7b6b    20 f9     . 
l7b6dh:
    pop hl                     ;7b6d    e1      . 
    ld a,(hl)                  ;7b6e    7e      ~ 
    or b                       ;7b6f    b0      . 
    ld (hl),a                  ;7b70    77      w 
    inc hl                     ;7b71    23      # 
    ld a,(hl)                  ;7b72    7e      ~ 
    or c                       ;7b73    b1      . 
    ld (hl),a                  ;7b74    77      w 
    pop hl                     ;7b75    e1      . 
    pop bc                     ;7b76    c1      . 
    pop de                     ;7b77    d1      . 
    ret                        ;7b78    c9      . 
    ex af,af'                  ;7b79    08      . 
    ld a,a                     ;7b7a    7f       
    ld a,e                     ;7b7b    7b      { 
    inc bc                     ;7b7c    03      . 
    ex de,hl                   ;7b7d    eb      . 
    ld a,e                     ;7b7e    7b      { 
    inc b                      ;7b7f    04      . 
    adc a,c                    ;7b80    89      . 
    ld a,e                     ;7b81    7b      { 

; BLOCK 'CHAROF_string' (start 0x7b82 end 0x7b88)
CHAROF_string_start:
    defb 043h                  ;7b82    43      C 
    defb 048h                  ;7b83    48      H 
    defb 041h                  ;7b84    41      A 
    defb 052h                  ;7b85    52      R 
    defb 04fh                  ;7b86    4f      O 
    defb 046h                  ;7b87    46      F 
CHAROF_string_end:
    rst 38h                    ;7b88    ff      . 
    ld ix,l7b90h               ;7b89    dd 21 90 7b     . ! . { 
    jp l65f7h                  ;7b8d    c3 f7 65    . . e 
l7b90h:
    rst 38h                    ;7b90    ff      . 
    rst 38h                    ;7b91    ff      . 
    dec b                      ;7b92    05      . 
    rst 38h                    ;7b93    ff      . 
    inc d                      ;7b94    14      . 
    rst 38h                    ;7b95    ff      . 
    dec b                      ;7b96    05      . 
    rst 38h                    ;7b97    ff      . 
    rst 38h                    ;7b98    ff      . 
    ld a,(bc)                  ;7b99    0a      . 
    inc d                      ;7b9a    14      . 
    rst 38h                    ;7b9b    ff      . 
    rst 38h                    ;7b9c    ff      . 
    rst 38h                    ;7b9d    ff      . 
    rst 38h                    ;7b9e    ff      . 
    jr nz,$+1                  ;7b9f    20 ff     . 
    rst 38h                    ;7ba1    ff      . 
    rst 38h                    ;7ba2    ff      . 
    rst 38h                    ;7ba3    ff      . 
    rst 38h                    ;7ba4    ff      . 
    dec b                      ;7ba5    05      . 
    rst 38h                    ;7ba6    ff      . 
    rst 38h                    ;7ba7    ff      . 
    rst 38h                    ;7ba8    ff      . 
    add hl,hl                  ;7ba9    29      ) 
    rst 38h                    ;7baa    ff      . 
    rst 38h                    ;7bab    ff      . 
    rst 38h                    ;7bac    ff      . 
    rst 38h                    ;7bad    ff      . 
    ld a,(09812h)              ;7bae    3a 12 98    : . . 
    cp 004h                    ;7bb1    fe 04   . . 
    ret nz                     ;7bb3    c0      . 
    ld hl,(0980ah)             ;7bb4    2a 0a 98    * . . 
    inc hl                     ;7bb7    23      # 
    inc hl                     ;7bb8    23      # 
    inc hl                     ;7bb9    23      # 
    ld a,(09810h)              ;7bba    3a 10 98    : . . 
    cp (hl)                    ;7bbd    be      . 
    ret                        ;7bbe    c9      . 
    ld hl,(0980ah)             ;7bbf    2a 0a 98    * . . 
    inc hl                     ;7bc2    23      # 
    inc hl                     ;7bc3    23      # 
    inc hl                     ;7bc4    23      # 
    ld l,(hl)                  ;7bc5    6e      n 
    ld h,000h                  ;7bc6    26 00   & . 
    ld a,004h                  ;7bc8    3e 04   > . 
    ld (0980eh),hl             ;7bca    22 0e 98    " . . 
    ld (0980dh),a              ;7bcd    32 0d 98    2 . . 
    cp a                       ;7bd0    bf      . 
    ret                        ;7bd1    c9      . 
    ld a,(09812h)              ;7bd2    3a 12 98    : . . 
    cp 004h                    ;7bd5    fe 04   . . 
    ret nz                     ;7bd7    c0      . 
    ld hl,(09810h)             ;7bd8    2a 10 98    * . . 
l7bdbh:
    ld h,0feh                  ;7bdb    26 fe   & . 
    ld (09ca5h),hl             ;7bdd    22 a5 9c    " . . 
    call sub_79e6h             ;7be0    cd e6 79    . . y 
    ld (09807h),a              ;7be3    32 07 98    2 . . 
    ld (09808h),hl             ;7be6    22 08 98    " . . 
    cp a                       ;7be9    bf      . 
    ret                        ;7bea    c9      . 
    ex af,af'                  ;7beb    08      . 
    pop af                     ;7bec    f1      . 
    ld a,e                     ;7bed    7b      { 
    inc bc                     ;7bee    03      . 
    inc hl                     ;7bef    23      # 
    ld a,l                     ;7bf0    7d      } 
    inc b                      ;7bf1    04      . 
    defb 0fdh,07bh             ;7bf2    fd 7b   . { 

; BLOCK 'STRINGOF_string' (start 0x7bf4 end 0x7bfc)
STRINGOF_string_start:
    defb 053h                  ;7bf4    53      S 
    defb 054h                  ;7bf5    54      T 
    defb 052h                  ;7bf6    52      R 
    defb 049h                  ;7bf7    49      I 
    defb 04eh                  ;7bf8    4e      N 
    defb 047h                  ;7bf9    47      G 
    defb 04fh                  ;7bfa    4f      O 
    defb 046h                  ;7bfb    46      F 
STRINGOF_string_end:
    rst 38h                    ;7bfc    ff      . 
    ld ix,l7c04h               ;7bfd    dd 21 04 7c     . ! . | 
    jp l65f7h                  ;7c01    c3 f7 65    . . e 
l7c04h:
    rst 38h                    ;7c04    ff      . 
    rst 38h                    ;7c05    ff      . 
    rst 38h                    ;7c06    ff      . 
    rrca                       ;7c07    0f      . 
    dec b                      ;7c08    05      . 
    rst 38h                    ;7c09    ff      . 
    rst 38h                    ;7c0a    ff      . 
    dec b                      ;7c0b    05      . 
    rst 38h                    ;7c0c    ff      . 
    rst 38h                    ;7c0d    ff      . 
    inc d                      ;7c0e    14      . 
    rst 38h                    ;7c0f    ff      . 
    rst 38h                    ;7c10    ff      . 
    rst 38h                    ;7c11    ff      . 
    rst 38h                    ;7c12    ff      . 
    rst 38h                    ;7c13    ff      . 
    rst 38h                    ;7c14    ff      . 
    ld a,(bc)                  ;7c15    0a      . 
    rst 38h                    ;7c16    ff      . 
    dec b                      ;7c17    05      . 
    daa                        ;7c18    27      ' 
    rst 38h                    ;7c19    ff      . 
    rst 38h                    ;7c1a    ff      . 
    rst 38h                    ;7c1b    ff      . 
    rst 38h                    ;7c1c    ff      . 
    ld (de),a                  ;7c1d    12      . 
    rst 38h                    ;7c1e    ff      . 
    rst 38h                    ;7c1f    ff      . 
    rst 38h                    ;7c20    ff      . 
    rst 38h                    ;7c21    ff      . 
    ld hl,09807h               ;7c22    21 07 98    ! . . 
    ld bc,(09810h)             ;7c25    ed 4b 10 98     . K . . 
    inc bc                     ;7c29    03      . 
    inc bc                     ;7c2a    03      . 
    inc bc                     ;7c2b    03      . 
    jp l7cd9h                  ;7c2c    c3 d9 7c    . . | 
    ld hl,(0980ah)             ;7c2f    2a 0a 98    * . . 
    ld bc,(09810h)             ;7c32    ed 4b 10 98     . K . . 
    inc bc                     ;7c36    03      . 
    inc bc                     ;7c37    03      . 
    inc bc                     ;7c38    03      . 
    ld de,(09853h)             ;7c39    ed 5b 53 98     . [ S . 
    jr l7cb3h                  ;7c3d    18 74   . t 
    ld hl,(0980ah)             ;7c3f    2a 0a 98    * . . 
    ld de,(09853h)             ;7c42    ed 5b 53 98     . [ S . 
    ld ix,09ca5h               ;7c46    dd 21 a5 9c     . ! . . 
    ld b,03ch                  ;7c4a    06 3c   . < 
l7c4ch:
    call sub_6575h             ;7c4c    cd 75 65    . u e 
    cp 003h                    ;7c4f    fe 03   . . 
    jr nz,l7c81h               ;7c51    20 2e     . 
    call sub_9623h             ;7c53    cd 23 96    . # . 
    push hl                    ;7c56    e5      . 
    call sub_6575h             ;7c57    cd 75 65    . u e 
    cp 008h                    ;7c5a    fe 08   . . 
    jr z,l7c65h                ;7c5c    28 07   ( . 
    cp 000h                    ;7c5e    fe 00   . . 
    jp z,l6290h                ;7c60    ca 90 62    . . b 
    pop hl                     ;7c63    e1      . 
    ret                        ;7c64    c9      . 
l7c65h:
    call sub_9623h             ;7c65    cd 23 96    . # . 
    inc hl                     ;7c68    23      # 
    inc hl                     ;7c69    23      # 
    inc hl                     ;7c6a    23      # 
    inc b                      ;7c6b    04      . 
    dec b                      ;7c6c    05      . 
    jr z,l7c76h                ;7c6d    28 07   ( . 
    dec b                      ;7c6f    05      . 
    ld a,(hl)                  ;7c70    7e      ~ 
    ld (ix+000h),a             ;7c71    dd 77 00    . w . 
    inc ix                     ;7c74    dd 23   . # 
l7c76h:
    inc hl                     ;7c76    23      # 
    ld a,(hl)                  ;7c77    7e      ~ 
    pop hl                     ;7c78    e1      . 
    cp 0ffh                    ;7c79    fe ff   . . 
    ret nz                     ;7c7b    c0      . 
    inc hl                     ;7c7c    23      # 
    inc hl                     ;7c7d    23      # 
    inc hl                     ;7c7e    23      # 
    jr l7c4ch                  ;7c7f    18 cb   . . 
l7c81h:
    cp 010h                    ;7c81    fe 10   . . 
    ret nz                     ;7c83    c0      . 
    ld a,0feh                  ;7c84    3e fe   > . 
    ld (ix+000h),a             ;7c86    dd 77 00    . w . 
    call sub_79e6h             ;7c89    cd e6 79    . . y 
    ld (0980eh),hl             ;7c8c    22 0e 98    " . . 
    ld (0980dh),a              ;7c8f    32 0d 98    2 . . 
    cp a                       ;7c92    bf      . 
    ret                        ;7c93    c9      . 
l7c94h:
    push hl                    ;7c94    e5      . 
    call sub_6575h             ;7c95    cd 75 65    . u e 
    cp 008h                    ;7c98    fe 08   . . 
    jr nz,l7cf7h               ;7c9a    20 5b     [ 
    call sub_9623h             ;7c9c    cd 23 96    . # . 
    inc hl                     ;7c9f    23      # 
    inc hl                     ;7ca0    23      # 
    inc hl                     ;7ca1    23      # 
    inc hl                     ;7ca2    23      # 
    ld a,(hl)                  ;7ca3    7e      ~ 
    cp 0ffh                    ;7ca4    fe ff   . . 
    jr z,l7caah                ;7ca6    28 02   ( . 
l7ca8h:
    pop hl                     ;7ca8    e1      . 
    ret                        ;7ca9    c9      . 
l7caah:
    dec hl                     ;7caa    2b      + 
    ld a,(bc)                  ;7cab    0a      . 
    cp (hl)                    ;7cac    be      . 
l7cadh:
    pop hl                     ;7cad    e1      . 
    ret nz                     ;7cae    c0      . 
    inc bc                     ;7caf    03      . 
    inc hl                     ;7cb0    23      # 
    inc hl                     ;7cb1    23      # 
    inc hl                     ;7cb2    23      # 
l7cb3h:
    call sub_6575h             ;7cb3    cd 75 65    . u e 
    cp 010h                    ;7cb6    fe 10   . . 
    jr nz,l7cbeh               ;7cb8    20 04     . 
    ld a,(bc)                  ;7cba    0a      . 
    cp 0ffh                    ;7cbb    fe ff   . . 
    ret                        ;7cbd    c9      . 
l7cbeh:
    cp 003h                    ;7cbe    fe 03   . . 
    jr nz,l7ccfh               ;7cc0    20 0d     . 
    ld a,(bc)                  ;7cc2    0a      . 
    cp 0ffh                    ;7cc3    fe ff   . . 
    jr nz,l7ccah               ;7cc5    20 03     . 
    or 001h                    ;7cc7    f6 01   . . 
    ret                        ;7cc9    c9      . 
l7ccah:
    call sub_9623h             ;7cca    cd 23 96    . # . 
    jr l7c94h                  ;7ccd    18 c5   . . 
l7ccfh:
    cp 000h                    ;7ccf    fe 00   . . 
    ret nz                     ;7cd1    c0      . 
    ex de,hl                   ;7cd2    eb      . 
    push bc                    ;7cd3    c5      . 
    call l64bdh                ;7cd4    cd bd 64    . . d 
    pop bc                     ;7cd7    c1      . 
    ex de,hl                   ;7cd8    eb      . 
l7cd9h:
    ld a,(bc)                  ;7cd9    0a      . 
    cp 0ffh                    ;7cda    fe ff   . . 
    jr nz,l7ce1h               ;7cdc    20 03     . 
    ld (hl),010h               ;7cde    36 10   6 . 
    ret                        ;7ce0    c9      . 
l7ce1h:
    push hl                    ;7ce1    e5      . 
    call sub_6593h             ;7ce2    cd 93 65    . . e 
    ex de,hl                   ;7ce5    eb      . 
    pop hl                     ;7ce6    e1      . 
    ld (hl),003h               ;7ce7    36 03   6 . 
    inc hl                     ;7ce9    23      # 
    ld (hl),e                  ;7cea    73      s 
    inc hl                     ;7ceb    23      # 
    ld (hl),d                  ;7cec    72      r 
    ex de,hl                   ;7ced    eb      . 
    call sub_7d0ah             ;7cee    cd 0a 7d    . . } 
    inc bc                     ;7cf1    03      . 
    inc hl                     ;7cf2    23      # 
    inc hl                     ;7cf3    23      # 
    inc hl                     ;7cf4    23      # 
    jr l7cd9h                  ;7cf5    18 e2   . . 
l7cf7h:
    cp 000h                    ;7cf7    fe 00   . . 
    jr nz,l7ca8h               ;7cf9    20 ad     . 
    call sub_7d0ah             ;7cfb    cd 0a 7d    . . } 
    push hl                    ;7cfe    e5      . 
    push de                    ;7cff    d5      . 
    push bc                    ;7d00    c5      . 
    ex de,hl                   ;7d01    eb      . 
    call l64bdh                ;7d02    cd bd 64    . . d 
    pop bc                     ;7d05    c1      . 
    pop de                     ;7d06    d1      . 
    pop hl                     ;7d07    e1      . 
    jr l7cadh                  ;7d08    18 a3   . . 
sub_7d0ah:
    push bc                    ;7d0a    c5      . 
    push de                    ;7d0b    d5      . 
    push hl                    ;7d0c    e5      . 
    ld a,(bc)                  ;7d0d    0a      . 
    ld l,a                     ;7d0e    6f      o 
    ld h,0feh                  ;7d0f    26 fe   & . 
    ld (09ca5h),hl             ;7d11    22 a5 9c    " . . 
    call sub_79e6h             ;7d14    cd e6 79    . . y 
    ex de,hl                   ;7d17    eb      . 
    pop hl                     ;7d18    e1      . 
    push hl                    ;7d19    e5      . 
    ld (hl),a                  ;7d1a    77      w 
    inc hl                     ;7d1b    23      # 
    ld (hl),e                  ;7d1c    73      s 
    inc hl                     ;7d1d    23      # 
    ld (hl),d                  ;7d1e    72      r 
    pop hl                     ;7d1f    e1      . 
    pop de                     ;7d20    d1      . 
    pop bc                     ;7d21    c1      . 
    ret                        ;7d22    c9      . 
    ex af,af'                  ;7d23    08      . 
    add hl,hl                  ;7d24    29      ) 
    ld a,l                     ;7d25    7d      } 
    inc bc                     ;7d26    03      . 
    ld l,b                     ;7d27    68      h 
    ld a,a                     ;7d28    7f       
    inc b                      ;7d29    04      . 
    defb 032h,07dh             ;7d2a    32 7d   2 } 

; BLOCK 'ADDCL_string' (start 0x7d2c end 0x7d31)
ADDCL_string_start:
    defb 041h                  ;7d2c    41      A 
    defb 044h                  ;7d2d    44      D 
    defb 044h                  ;7d2e    44      D 

; BLOCK 'CL_string' (start 0x7d2f end 0x7d31)
CL_string_start:
    defb 043h                  ;7d2f    43      C 
    defb 04ch                  ;7d30    4c      L 
ADDCL_string_end:
CL_string_end:
    rst 38h                    ;7d31    ff      . 
    ld hl,(0984fh)             ;7d32    2a 4f 98    * O .          (flow from: 60bb)
    ld ix,(09843h)             ;7d35    dd 2a 43 98     . * C .    (flow from: 7d32)
    ld e,(ix+00ah)             ;7d39    dd 5e 0a    . ^ .          (flow from: 7d35)
    ld d,(ix+00bh)             ;7d3c    dd 56 0b    . V .          (flow from: 7d39)
    ld (09853h),de             ;7d3f    ed 53 53 98     . S S .    (flow from: 7d3c)
    call sub_6575h             ;7d43    cd 75 65    . u e          (flow from: 7d3f)
    cp 003h                    ;7d46    fe 03   . .                (flow from: 658a)
    ret nz                     ;7d48    c0      .                  (flow from: 7d46)
    ld de,09807h               ;7d49    11 07 98    . . .          (flow from: 7d48)
    call sub_9623h             ;7d4c    cd 23 96    . # .          (flow from: 7d49)
    ld (0984fh),hl             ;7d4f    22 4f 98    " O .          (flow from: 9628)
    ld c,000h                  ;7d52    0e 00   . .                (flow from: 7d4f)
    ld a,0ffh                  ;7d54    3e ff   > .                (flow from: 7d52)
    ld (09870h),a              ;7d56    32 70 98    2 p .          (flow from: 7d54)
    call sub_7e38h             ;7d59    cd 38 7e    . 8 ~          (flow from: 7d56)
    ld hl,09807h               ;7d5c    21 07 98    ! . .          (flow from: 7ea7)
    call sub_9623h             ;7d5f    cd 23 96    . # .          (flow from: 7d5c)
    ld (09a85h),hl             ;7d62    22 85 9a    " . .          (flow from: 9628)
    ld a,(hl)                  ;7d65    7e      ~                  (flow from: 7d62)
    cp 003h                    ;7d66    fe 03   . .                (flow from: 7d65)
    ret nz                     ;7d68    c0      .                  (flow from: 7d66)
    call sub_9623h             ;7d69    cd 23 96    . # .          (flow from: 7d68)
    ld a,(hl)                  ;7d6c    7e      ~                  (flow from: 9628)
    cp 008h                    ;7d6d    fe 08   . .                (flow from: 7d6c)
    ret nz                     ;7d6f    c0      .                  (flow from: 7d6d)
    ld a,003h                  ;7d70    3e 03   > .                (flow from: 7d6f)
    ld (0980dh),a              ;7d72    32 0d 98    2 . .          (flow from: 7d70)
    ld (0980eh),hl             ;7d75    22 0e 98    " . .          (flow from: 7d72)
    push hl                    ;7d78    e5      .                  (flow from: 7d75)
    call sub_9623h             ;7d79    cd 23 96    . # .          (flow from: 7d78)
    ld (09a87h),hl             ;7d7c    22 87 9a    " . .          (flow from: 9628)
    call sub_7653h             ;7d7f    cd 53 76    . S v          (flow from: 7d7c)
    jp nz,l7e1ah               ;7d82    c2 1a 7e    . . ~          (flow from: 7662)
    ex de,hl                   ;7d85    eb      .                  (flow from: 7d82)
    ld hl,(09a8eh)             ;7d86    2a 8e 9a    * . .          (flow from: 7d85)
    call sub_9623h             ;7d89    cd 23 96    . # .          (flow from: 7d86)
    inc hl                     ;7d8c    23      #                  (flow from: 9628)
    inc hl                     ;7d8d    23      #                  (flow from: 7d8c)
    inc hl                     ;7d8e    23      #                  (flow from: 7d8d)
    call sub_9623h             ;7d8f    cd 23 96    . # .          (flow from: 7d8e)
l7d92h:
    ld a,(hl)                  ;7d92    7e      ~                  (flow from: 7dac 9628)
    cp 010h                    ;7d93    fe 10   . .                (flow from: 7d92)
    jr z,l7daeh                ;7d95    28 17   ( .                (flow from: 7d93)
    cp 003h                    ;7d97    fe 03   . .                (flow from: 7d95)
    call nz,sub_6259h          ;7d99    c4 59 62    . Y b          (flow from: 7d97)
    call sub_9623h             ;7d9c    cd 23 96    . # .          (flow from: 7d99)
    push hl                    ;7d9f    e5      .                  (flow from: 9628)
    call sub_9623h             ;7da0    cd 23 96    . # .          (flow from: 7d9f)
    or a                       ;7da3    b7      .                  (flow from: 9628)
    sbc hl,de                  ;7da4    ed 52   . R                (flow from: 7da3)
    jr z,l7e1ah                ;7da6    28 72   ( r                (flow from: 7da4)
    pop hl                     ;7da8    e1      .                  (flow from: 7da6)
    inc hl                     ;7da9    23      #                  (flow from: 7da8)
    inc hl                     ;7daa    23      #                  (flow from: 7da9)
    inc hl                     ;7dab    23      #                  (flow from: 7daa)
    jr l7d92h                  ;7dac    18 e4   . .                (flow from: 7dab)
l7daeh:
    pop hl                     ;7dae    e1      .                  (flow from: 7d95)
    inc hl                     ;7daf    23      #                  (flow from: 7dae)
    inc hl                     ;7db0    23      #                  (flow from: 7daf)
    inc hl                     ;7db1    23      #                  (flow from: 7db0)
    push hl                    ;7db2    e5      .                  (flow from: 7db1)
    push bc                    ;7db3    c5      .                  (flow from: 7db2)
    ld bc,00003h               ;7db4    01 03 00    . . .          (flow from: 7db3)
    ld de,(09a85h)             ;7db7    ed 5b 85 9a     . [ . .    (flow from: 7db4)
    ldir                       ;7dbb    ed b0   . .                (flow from: 7db7 7dbb)
    pop bc                     ;7dbd    c1      .                  (flow from: 7dbb)
    dec de                     ;7dbe    1b      .                  (flow from: 7dbd)
    dec de                     ;7dbf    1b      .                  (flow from: 7dbe)
    dec de                     ;7dc0    1b      .                  (flow from: 7dbf)
    pop hl                     ;7dc1    e1      .                  (flow from: 7dc0)
    ld (hl),003h               ;7dc2    36 03   6 .                (flow from: 7dc1)
    inc hl                     ;7dc4    23      #                  (flow from: 7dc2)
    ld (hl),e                  ;7dc5    73      s                  (flow from: 7dc4)
    inc hl                     ;7dc6    23      #                  (flow from: 7dc5)
    ld (hl),d                  ;7dc7    72      r                  (flow from: 7dc6)
    ld hl,(0980eh)             ;7dc8    2a 0e 98    * . .          (flow from: 7dc7)
    ld d,000h                  ;7dcb    16 00   . .                (flow from: 7dc8)
    ld e,c                     ;7dcd    59      Y                  (flow from: 7dcb)
    ld (hl),004h               ;7dce    36 04   6 .                (flow from: 7dcd)
    inc hl                     ;7dd0    23      #                  (flow from: 7dce)
    ld (hl),e                  ;7dd1    73      s                  (flow from: 7dd0)
    inc hl                     ;7dd2    23      #                  (flow from: 7dd1)
    ld (hl),d                  ;7dd3    72      r                  (flow from: 7dd2)
    call sub_6593h             ;7dd4    cd 93 65    . . e          (flow from: 7dd3)
    ld de,(0980eh)             ;7dd7    ed 5b 0e 98     . [ . .    (flow from: 65ea)
    ld (09a85h),hl             ;7ddb    22 85 9a    " . .          (flow from: 7dd7)
    ld (hl),003h               ;7dde    36 03   6 .                (flow from: 7ddb)
    inc hl                     ;7de0    23      #                  (flow from: 7dde)
    ld (hl),e                  ;7de1    73      s                  (flow from: 7de0)
    inc hl                     ;7de2    23      #                  (flow from: 7de1)
    ld (hl),d                  ;7de3    72      r                  (flow from: 7de2)
    ld hl,(0984fh)             ;7de4    2a 4f 98    * O .          (flow from: 7de3)
    inc hl                     ;7de7    23      #                  (flow from: 7de4)
    inc hl                     ;7de8    23      #                  (flow from: 7de7)
    inc hl                     ;7de9    23      #                  (flow from: 7de8)
    ld de,(09853h)             ;7dea    ed 5b 53 98     . [ S .    (flow from: 7de9)
    call sub_6575h             ;7dee    cd 75 65    . u e          (flow from: 7dea)
    cp 010h                    ;7df1    fe 10   . .                (flow from: 658a)
    jr nz,l7dfah               ;7df3    20 05     .                (flow from: 7df1)
    ld bc,l7fffh               ;7df5    01 ff 7f    . .          (flow from: 7df3)
    jr l7e0bh                  ;7df8    18 11   . .                (flow from: 7df5)
l7dfah:
    cp 003h                    ;7dfa    fe 03   . . 
    ret nz                     ;7dfc    c0      . 
    call sub_9623h             ;7dfd    cd 23 96    . # . 
    call sub_6575h             ;7e00    cd 75 65    . u e 
    cp 004h                    ;7e03    fe 04   . . 
    ret nz                     ;7e05    c0      . 
    call sub_9623h             ;7e06    cd 23 96    . # . 
    ld c,l                     ;7e09    4d      M 
    ld b,h                     ;7e0a    44      D 
l7e0bh:
    ld hl,(09a87h)             ;7e0b    2a 87 9a    * . .          (flow from: 7df8)
    call sub_7f55h             ;7e0e    cd 55 7f    . U           (flow from: 7e0b)
    ld a,(hl)                  ;7e11    7e      ~                  (flow from: 7f5e)
    cp 003h                    ;7e12    fe 03   . .                (flow from: 7e11)
    jr z,l7e20h                ;7e14    28 0a   ( .                (flow from: 7e12)
    cp 010h                    ;7e16    fe 10   . .                (flow from: 7e14)
    jr z,l7e20h                ;7e18    28 06   ( .                (flow from: 7e16)
l7e1ah:
    ld hl,00004h               ;7e1a    21 04 00    ! . . 
    jp l62a7h                  ;7e1d    c3 a7 62    . . b 
l7e20h:
    ld de,(09a85h)             ;7e20    ed 5b 85 9a     . [ . .    (flow from: 7e18)
    push de                    ;7e24    d5      .                  (flow from: 7e20)
    push hl                    ;7e25    e5      .                  (flow from: 7e24)
    inc de                     ;7e26    13      .                  (flow from: 7e25)
    inc de                     ;7e27    13      .                  (flow from: 7e26)
    inc de                     ;7e28    13      .                  (flow from: 7e27)
    ld bc,00003h               ;7e29    01 03 00    . . .          (flow from: 7e28)
    ldir                       ;7e2c    ed b0   . .                (flow from: 7e29 7e2c)
    pop hl                     ;7e2e    e1      .                  (flow from: 7e2c)
    pop de                     ;7e2f    d1      .                  (flow from: 7e2e)
    ld (hl),003h               ;7e30    36 03   6 .                (flow from: 7e2f)
    inc hl                     ;7e32    23      #                  (flow from: 7e30)
    ld (hl),e                  ;7e33    73      s                  (flow from: 7e32)
    inc hl                     ;7e34    23      #                  (flow from: 7e33)
    ld (hl),d                  ;7e35    72      r                  (flow from: 7e34)
    cp a                       ;7e36    bf      .                  (flow from: 7e35)
    ret                        ;7e37    c9      .                  (flow from: 7e36)
sub_7e38h:
    push hl                    ;7e38    e5      .                  (flow from: 7d59 7e58)
    push de                    ;7e39    d5      .                  (flow from: 7e38)
l7e3ah:
    push de                    ;7e3a    d5      .                  (flow from: 7e39 7e61)
    ld de,(09853h)             ;7e3b    ed 5b 53 98     . [ S .    (flow from: 7e3a)
    call sub_6575h             ;7e3f    cd 75 65    . u e          (flow from: 7e3b)
    pop de                     ;7e42    d1      .                  (flow from: 658a)
    cp 003h                    ;7e43    fe 03   . .                (flow from: 7e42)
    jr nz,l7e63h               ;7e45    20 1c     .                (flow from: 7e43)
    push hl                    ;7e47    e5      .                  (flow from: 7e45)
    push de                    ;7e48    d5      .                  (flow from: 7e47)
    call sub_6593h             ;7e49    cd 93 65    . . e          (flow from: 7e48)
    pop de                     ;7e4c    d1      .                  (flow from: 65ea)
    ex de,hl                   ;7e4d    eb      .                  (flow from: 7e4c)
    ld (hl),003h               ;7e4e    36 03   6 .                (flow from: 7e4d)
    inc hl                     ;7e50    23      #                  (flow from: 7e4e)
    ld (hl),e                  ;7e51    73      s                  (flow from: 7e50)
    inc hl                     ;7e52    23      #                  (flow from: 7e51)
    ld (hl),d                  ;7e53    72      r                  (flow from: 7e52)
    pop hl                     ;7e54    e1      .                  (flow from: 7e53)
    call sub_9623h             ;7e55    cd 23 96    . # .          (flow from: 7e54)
    call sub_7e38h             ;7e58    cd 38 7e    . 8 ~          (flow from: 9628)
    inc hl                     ;7e5b    23      #                  (flow from: 7ea7)
    inc hl                     ;7e5c    23      #                  (flow from: 7e5b)
    inc hl                     ;7e5d    23      #                  (flow from: 7e5c)
    inc de                     ;7e5e    13      .                  (flow from: 7e5d)
    inc de                     ;7e5f    13      .                  (flow from: 7e5e)
    inc de                     ;7e60    13      .                  (flow from: 7e5f)
    jr l7e3ah                  ;7e61    18 d7   . .                (flow from: 7e60)
l7e63h:
    cp 000h                    ;7e63    fe 00   . .                (flow from: 7e45)
    jr nz,l7e9eh               ;7e65    20 37     7                (flow from: 7e63)
    ld a,00ch                  ;7e67    3e 0c   > .                (flow from: 7e65)
    ld (de),a                  ;7e69    12      .                  (flow from: 7e67)
    inc de                     ;7e6a    13      .                  (flow from: 7e69)
    ld b,000h                  ;7e6b    06 00   . .                (flow from: 7e6a)
    ld ix,0986fh               ;7e6d    dd 21 6f 98     . ! o .    (flow from: 7e6b)
l7e71h:
    ld a,(ix+001h)             ;7e71    dd 7e 01    . ~ .          (flow from: 7e6d 7e8a)
    cp 0ffh                    ;7e74    fe ff   . .                (flow from: 7e71)
    jr z,l7e8ch                ;7e76    28 14   ( .                (flow from: 7e74)
    push de                    ;7e78    d5      .                  (flow from: 7e76)
    ld d,a                     ;7e79    57      W                  (flow from: 7e78)
    ld e,(ix+000h)             ;7e7a    dd 5e 00    . ^ .          (flow from: 7e79)
    call sub_65f1h             ;7e7d    cd f1 65    . . e          (flow from: 7e7a)
    pop de                     ;7e80    d1      .                  (flow from: 65f6)
    jr z,l7e97h                ;7e81    28 14   ( .                (flow from: 7e80)
    inc b                      ;7e83    04      .                  (flow from: 7e81)
    inc b                      ;7e84    04      .                  (flow from: 7e83)
    inc b                      ;7e85    04      .                  (flow from: 7e84)
    inc ix                     ;7e86    dd 23   . #                (flow from: 7e85)
    inc ix                     ;7e88    dd 23   . #                (flow from: 7e86)
    jr l7e71h                  ;7e8a    18 e5   . .                (flow from: 7e88)
l7e8ch:
    ld (ix+000h),l             ;7e8c    dd 75 00    . u .          (flow from: 7e76)
    ld (ix+001h),h             ;7e8f    dd 74 01    . t .          (flow from: 7e8c)
    ld (ix+003h),0ffh          ;7e92    dd 36 03 ff     . 6 . .    (flow from: 7e8f)
    inc c                      ;7e96    0c      .                  (flow from: 7e92)
l7e97h:
    ex de,hl                   ;7e97    eb      .                  (flow from: 7e81 7e96)
    ld (hl),b                  ;7e98    70      p                  (flow from: 7e97)
    inc hl                     ;7e99    23      #                  (flow from: 7e98)
    ld (hl),000h               ;7e9a    36 00   6 .                (flow from: 7e99)
    jr l7ea5h                  ;7e9c    18 07   . .                (flow from: 7e9a)
l7e9eh:
    push bc                    ;7e9e    c5      .                  (flow from: 7e65)
    ld bc,00003h               ;7e9f    01 03 00    . . .          (flow from: 7e9e)
    ldir                       ;7ea2    ed b0   . .                (flow from: 7e9f 7ea2)
    pop bc                     ;7ea4    c1      .                  (flow from: 7ea2)
l7ea5h:
    pop de                     ;7ea5    d1      .                  (flow from: 7e9c 7ea4)
    pop hl                     ;7ea6    e1      .                  (flow from: 7ea5)
    ret                        ;7ea7    c9      .                  (flow from: 7ea6)
    inc b                      ;7ea8    04      . 
    xor l                      ;7ea9    ad      . 
    ld a,(hl)                  ;7eaa    7e      ~ 
    ld hl,(0ddffh)             ;7eab    2a ff dd    * . . 
    ld hl,l7eb4h               ;7eae    21 b4 7e    ! . ~ 
    jp l65f7h                  ;7eb1    c3 f7 65    . . e 
l7eb4h:
    rst 38h                    ;7eb4    ff      . 
    rst 38h                    ;7eb5    ff      . 
    dec b                      ;7eb6    05      . 
    rst 38h                    ;7eb7    ff      . 
    rst 38h                    ;7eb8    ff      . 
    rst 38h                    ;7eb9    ff      . 
    dec b                      ;7eba    05      . 
    rst 38h                    ;7ebb    ff      . 
    rst 38h                    ;7ebc    ff      . 
    rst 38h                    ;7ebd    ff      . 
    dec b                      ;7ebe    05      . 
    rst 38h                    ;7ebf    ff      . 
    rst 38h                    ;7ec0    ff      . 
    rst 38h                    ;7ec1    ff      . 
    rst 38h                    ;7ec2    ff      . 
    ld hl,(0980ah)             ;7ec3    2a 0a 98    * . . 
    call sub_7653h             ;7ec6    cd 53 76    . S v 
    ret nz                     ;7ec9    c0      . 
    ld a,(09812h)              ;7eca    3a 12 98    : . . 
    cp 004h                    ;7ecd    fe 04   . . 
    ret nz                     ;7ecf    c0      . 
    ld bc,(09810h)             ;7ed0    ed 4b 10 98     . K . . 
    dec bc                     ;7ed4    0b      . 
    call sub_7f55h             ;7ed5    cd 55 7f    . U  
    ld a,(hl)                  ;7ed8    7e      ~ 
    cp 003h                    ;7ed9    fe 03   . . 
    ret nz                     ;7edb    c0      . 
    push hl                    ;7edc    e5      . 
    call sub_9623h             ;7edd    cd 23 96    . # . 
    inc hl                     ;7ee0    23      # 
    inc hl                     ;7ee1    23      # 
    inc hl                     ;7ee2    23      # 
    pop de                     ;7ee3    d1      . 
    ld bc,00003h               ;7ee4    01 03 00    . . . 
    ldir                       ;7ee7    ed b0   . . 
    cp a                       ;7ee9    bf      . 
    ret                        ;7eea    c9      . 
    inc b                      ;7eeb    04      . 
    ret p                      ;7eec    f0      . 
    ld a,(hl)                  ;7eed    7e      ~ 
    ld hl,(0ddffh)             ;7eee    2a ff dd    * . . 
    ld hl,l7ef7h               ;7ef1    21 f7 7e    ! . ~ 
    jp l65f7h                  ;7ef4    c3 f7 65    . . e 
l7ef7h:
    rst 38h                    ;7ef7    ff      . 
    rst 38h                    ;7ef8    ff      . 
    dec b                      ;7ef9    05      . 
    rst 38h                    ;7efa    ff      . 
    rst 38h                    ;7efb    ff      . 
    rst 38h                    ;7efc    ff      . 
    rst 38h                    ;7efd    ff      . 
    rst 38h                    ;7efe    ff      . 
    rst 38h                    ;7eff    ff      . 
    dec b                      ;7f00    05      . 
    rst 38h                    ;7f01    ff      . 
    rst 38h                    ;7f02    ff      . 
    rst 38h                    ;7f03    ff      . 
    rst 38h                    ;7f04    ff      . 
    dec b                      ;7f05    05      . 
    rst 38h                    ;7f06    ff      . 
    dec b                      ;7f07    05      . 
    rst 38h                    ;7f08    ff      . 
    rst 38h                    ;7f09    ff      . 
    rst 38h                    ;7f0a    ff      . 
    dec b                      ;7f0b    05      . 
    rst 38h                    ;7f0c    ff      . 
    rst 38h                    ;7f0d    ff      . 
    rst 38h                    ;7f0e    ff      . 
    rst 38h                    ;7f0f    ff      . 
    ld hl,(0980ah)             ;7f10    2a 0a 98    * . . 
    ld a,(0981eh)              ;7f13    3a 1e 98    : . . 
    cp 004h                    ;7f16    fe 04   . . 
    ret nz                     ;7f18    c0      . 
    ld bc,(0981ch)             ;7f19    ed 4b 1c 98     . K . . 
    dec bc                     ;7f1d    0b      . 
    call sub_7f55h             ;7f1e    cd 55 7f    . U  
    ld a,(hl)                  ;7f21    7e      ~ 
    cp 003h                    ;7f22    fe 03   . . 
    ret nz                     ;7f24    c0      . 
    ld (09841h),hl             ;7f25    22 41 98    " A . 
    ld hl,(09847h)             ;7f28    2a 47 98    * G . 
    push hl                    ;7f2b    e5      . 
    call sub_6312h             ;7f2c    cd 12 63    . . c 
    pop hl                     ;7f2f    e1      . 
    ld (09847h),hl             ;7f30    22 47 98    " G . 
    ld bc,(09855h)             ;7f33    ed 4b 55 98     . K U . 
    ld de,0980dh               ;7f37    11 0d 98    . . . 
    ld hl,(09851h)             ;7f3a    2a 51 98    * Q . 
    call sub_6505h             ;7f3d    cd 05 65    . . e 
    ld de,09813h               ;7f40    11 13 98    . . . 
    ld hl,(0984dh)             ;7f43    2a 4d 98    * M . 
    call sub_6505h             ;7f46    cd 05 65    . . e 
    ld (0984bh),bc             ;7f49    ed 43 4b 98     . C K . 
    ld hl,(09857h)             ;7f4d    2a 57 98    * W . 
    ld (0983dh),hl             ;7f50    22 3d 98    " = . 
    cp a                       ;7f53    bf      . 
    ret                        ;7f54    c9      . 
sub_7f55h:
    ld a,c                     ;7f55    79      y                  (flow from: 7e0e 7f66)
    cp b                       ;7f56    b8      .                  (flow from: 7f55)
    jr nz,l7f5bh               ;7f57    20 02     .                (flow from: 7f56)
    or a                       ;7f59    b7      . 
    ret z                      ;7f5a    c8      . 
l7f5bh:
    ld a,(hl)                  ;7f5b    7e      ~                  (flow from: 7f57)
    cp 003h                    ;7f5c    fe 03   . .                (flow from: 7f5b)
    ret nz                     ;7f5e    c0      .                  (flow from: 7f5c)
    call sub_9623h             ;7f5f    cd 23 96    . # .          (flow from: 7f5e)
    inc hl                     ;7f62    23      #                  (flow from: 9628)
    inc hl                     ;7f63    23      #                  (flow from: 7f62)
    inc hl                     ;7f64    23      #                  (flow from: 7f63)
    dec bc                     ;7f65    0b      .                  (flow from: 7f64)
    jr sub_7f55h               ;7f66    18 ed   . .                (flow from: 7f65)
    ex af,af'                  ;7f68    08      . 
    ld l,(hl)                  ;7f69    6e      n 
    ld a,a                     ;7f6a    7f       
    inc bc                     ;7f6b    03      . 
    rst 18h                    ;7f6c    df      . 
    ld a,a                     ;7f6d    7f       
    inc b                      ;7f6e    04      . 
    halt                       ;7f6f    76      v 
    ld a,a                     ;7f70    7f       

; BLOCK 'KILL_string' (start 0x7f71 end 0x7f75)
KILL_string_start:
    defb 04bh                  ;7f71    4b      K 
    defb 049h                  ;7f72    49      I 
    defb 04ch                  ;7f73    4c      L 
    defb 04ch                  ;7f74    4c      L 
KILL_string_end:
    rst 38h                    ;7f75    ff      . 
    ld ix,l7f7dh               ;7f76    dd 21 7d 7f     . ! }  
    jp l65f7h                  ;7f7a    c3 f7 65    . . e 
l7f7dh:
    rst 38h                    ;7f7d    ff      . 
    rst 38h                    ;7f7e    ff      . 
    dec b                      ;7f7f    05      . 
    ld a,(bc)                  ;7f80    0a      . 
    rst 38h                    ;7f81    ff      . 
    ld a,(bc)                  ;7f82    0a      . 
    rst 38h                    ;7f83    ff      . 
    rst 38h                    ;7f84    ff      . 
    rst 38h                    ;7f85    ff      . 
    rst 38h                    ;7f86    ff      . 
    scf                        ;7f87    37      7 
    rst 38h                    ;7f88    ff      . 
    rst 38h                    ;7f89    ff      . 
    rst 38h                    ;7f8a    ff      . 
    rst 38h                    ;7f8b    ff      . 
    ld de,(0980ah)             ;7f8c    ed 5b 0a 98     . [ . . 
    ld hl,087b6h               ;7f90    21 b6 87    ! . . 
    or a                       ;7f93    b7      . 
    sbc hl,de                  ;7f94    ed 52   . R 
    jr z,l7fadh                ;7f96    28 15   ( . 
    ex de,hl                   ;7f98    eb      . 
    ld a,(hl)                  ;7f99    7e      ~ 
    cp 007h                    ;7f9a    fe 07   . . 
    jp z,l7824h                ;7f9c    ca 24 78    . $ x 
sub_7f9fh:
    ld a,(hl)                  ;7f9f    7e      ~ 
    cp 010h                    ;7fa0    fe 10   . . 
    ret z                      ;7fa2    c8      . 
    cp 003h                    ;7fa3    fe 03   . . 
    ret nz                     ;7fa5    c0      . 
    call sub_7653h             ;7fa6    cd 53 76    . S v 
    ret nz                     ;7fa9    c0      . 
    ld (hl),010h               ;7faa    36 10   6 . 
    ret                        ;7fac    c9      . 
l7fadh:
    ld hl,(09a8eh)             ;7fad    2a 8e 9a    * . . 
    call sub_9623h             ;7fb0    cd 23 96    . # . 
    inc hl                     ;7fb3    23      # 
    inc hl                     ;7fb4    23      # 
    inc hl                     ;7fb5    23      # 
    call sub_9623h             ;7fb6    cd 23 96    . # . 
    inc hl                     ;7fb9    23      # 
    inc hl                     ;7fba    23      # 
    inc hl                     ;7fbb    23      # 
    jr l7fc1h                  ;7fbc    18 03   . . 
    ld hl,(0980ah)             ;7fbe    2a 0a 98    * . . 
l7fc1h:
    ld a,(hl)                  ;7fc1    7e      ~ 
    cp 010h                    ;7fc2    fe 10   . . 
    ret z                      ;7fc4    c8      . 
    cp 003h                    ;7fc5    fe 03   . . 
    jp nz,l6290h               ;7fc7    c2 90 62    . . b 
    call sub_9623h             ;7fca    cd 23 96    . # . 
    push hl                    ;7fcd    e5      . 
    ld a,(hl)                  ;7fce    7e      ~ 
    cp 008h                    ;7fcf    fe 08   . . 
    jr nz,l7fd9h               ;7fd1    20 06     . 
    call sub_9623h             ;7fd3    cd 23 96    . # . 
    call sub_7f9fh             ;7fd6    cd 9f 7f    . .  
l7fd9h:
    pop hl                     ;7fd9    e1      . 
    inc hl                     ;7fda    23      # 
    inc hl                     ;7fdb    23      # 
    inc hl                     ;7fdc    23      # 
    jr l7fc1h                  ;7fdd    18 e2   . . 
    ex af,af'                  ;7fdf    08      . 
    push hl                    ;7fe0    e5      . 
    ld a,a                     ;7fe1    7f       
    inc bc                     ;7fe2    03      . 
    push af                    ;7fe3    f5      . 
    ld a,a                     ;7fe4    7f       
    inc b                      ;7fe5    04      . 
    xor 07fh                   ;7fe6    ee 7f   .  

; BLOCK 'ABORT_string' (start 0x7fe8 end 0x7fed)
ABORT_string_start:
    defb 041h                  ;7fe8    41      A 
    defb 042h                  ;7fe9    42      B 
    defb 04fh                  ;7fea    4f      O 
    defb 052h                  ;7feb    52      R 
    defb 054h                  ;7fec    54      T 
ABORT_string_end:
    rst 38h                    ;7fed    ff      . 
    ld sp,(09803h)             ;7fee    ed 7b 03 98     . { . . 
    jp l6025h                  ;7ff2    c3 25 60    . % ` 
    ex af,af'                  ;7ff5    08      . 
    ei                         ;7ff6    fb      . 
    ld a,a                     ;7ff7    7f       
    inc bc                     ;7ff8    03      . 
    cp c                       ;7ff9    b9      . 
    add a,b                    ;7ffa    80      . 
    inc b                      ;7ffb    04      . 
    ld (bc),a                  ;7ffc    02      . 
    add a,b                    ;7ffd    80      . 

; BLOCK 'LNE_string' (start 0x7ffe end 0x8001)
LNE_string_start:
    defb 04ch                  ;7ffe    4c      L 
l7fffh:
    defb 04eh                  ;7fff    4e      N 
    defb 045h                  ;8000    45      E 
LNE_string_end:
    rst 38h                    ;8001    ff      . 
    call 01cadh                ;8002    cd ad 1c    . . . 
    ld ix,l800ch               ;8005    dd 21 0c 80     . ! . . 
    jp l65f7h                  ;8009    c3 f7 65    . . e 
l800ch:
    rst 38h                    ;800c    ff      . 
    dec b                      ;800d    05      . 
    rst 38h                    ;800e    ff      . 
    rst 38h                    ;800f    ff      . 
    rst 38h                    ;8010    ff      . 
    rst 38h                    ;8011    ff      . 
    dec b                      ;8012    05      . 
    rst 38h                    ;8013    ff      . 
    rst 38h                    ;8014    ff      . 
    rst 38h                    ;8015    ff      . 
    rst 38h                    ;8016    ff      . 
    dec b                      ;8017    05      . 
    rst 38h                    ;8018    ff      . 
    rst 38h                    ;8019    ff      . 
    rst 38h                    ;801a    ff      . 
    rst 38h                    ;801b    ff      . 
    dec b                      ;801c    05      . 
    rst 38h                    ;801d    ff      . 
    rst 38h                    ;801e    ff      . 
    rst 38h                    ;801f    ff      . 
    dec e                      ;8020    1d      . 
    dec b                      ;8021    05      . 
    rst 38h                    ;8022    ff      . 
    rst 38h                    ;8023    ff      . 
    rst 38h                    ;8024    ff      . 
    ld (de),a                  ;8025    12      . 
    dec b                      ;8026    05      . 
    rst 38h                    ;8027    ff      . 
    rst 38h                    ;8028    ff      . 
    rst 38h                    ;8029    ff      . 
    dec b                      ;802a    05      . 
    rst 38h                    ;802b    ff      . 
    rst 38h                    ;802c    ff      . 
    rst 38h                    ;802d    ff      . 
    rst 38h                    ;802e    ff      . 
    ld a,(09828h)              ;802f    3a 28 98    : ( . 
    cp 0ffh                    ;8032    fe ff   . . 
    call 00d5eh                ;8034    cd 5e 0d    . ^ . 
    ld a,(09822h)              ;8037    3a 22 98    : " . 
    ld (05c8fh),a              ;803a    32 8f 5c    2 . \ 
    call sub_808fh             ;803d    cd 8f 80    . . . 
    ld hl,(0980ah)             ;8040    2a 0a 98    * . . 
    ld de,00080h               ;8043    11 80 00    . . . 
    call sub_8088h             ;8046    cd 88 80    . . . 
    ld c,l                     ;8049    4d      M 
    ld hl,(09810h)             ;804a    2a 10 98    * . . 
    ld de,00058h               ;804d    11 58 00    . X . 
    call sub_8088h             ;8050    cd 88 80    . . . 
    ld b,l                     ;8053    45      E 
    ld (05c7dh),bc             ;8054    ed 43 7d 5c     . C } \ 
    push bc                    ;8058    c5      . 
    ld hl,(09816h)             ;8059    2a 16 98    * . . 
    ld de,00080h               ;805c    11 80 00    . . . 
    ld b,c                     ;805f    41      A 
    call sub_807bh             ;8060    cd 7b 80    . { . 
    pop bc                     ;8063    c1      . 
    ld c,a                     ;8064    4f      O 
    push bc                    ;8065    c5      . 
    ld c,d                     ;8066    4a      J 
    ld hl,(0981ch)             ;8067    2a 1c 98    * . . 
    ld de,00058h               ;806a    11 58 00    . X . 
    call sub_807bh             ;806d    cd 7b 80    . { . 
    ld e,c                     ;8070    59      Y 
    pop bc                     ;8071    c1      . 
    ld b,a                     ;8072    47      G 
    call 024bah                ;8073    cd ba 24    . . $ 
    call sub_80ach             ;8076    cd ac 80    . . . 
    cp a                       ;8079    bf      . 
    ret                        ;807a    c9      . 
sub_807bh:
    call sub_8088h             ;807b    cd 88 80    . . . 
    ld a,l                     ;807e    7d      } 
    sub b                      ;807f    90      . 
    ld d,001h                  ;8080    16 01   . . 
    ret nc                     ;8082    d0      . 
    neg                        ;8083    ed 44   . D 
    ld d,0ffh                  ;8085    16 ff   . . 
    ret                        ;8087    c9      . 
sub_8088h:
    xor a                      ;8088    af      . 
    add hl,de                  ;8089    19      . 
    ld a,h                     ;808a    7c      | 
    and a                      ;808b    a7      . 
    ret z                      ;808c    c8      . 
    rst 8                      ;808d    cf      . 
    ld a,(bc)                  ;808e    0a      . 
sub_808fh:
    ld ix,09813h               ;808f    dd 21 13 98     . ! . . 
    call sub_8e01h             ;8093    cd 01 8e    . . . 
    ld ix,09819h               ;8096    dd 21 19 98     . ! . . 
    call sub_8e01h             ;809a    cd 01 8e    . . . 
sub_809dh:
    ld ix,09807h               ;809d    dd 21 07 98     . ! . . 
    call sub_8e01h             ;80a1    cd 01 8e    . . . 
    ld ix,0980dh               ;80a4    dd 21 0d 98     . ! . . 
    call sub_8e01h             ;80a8    cd 01 8e    . . . 
    ret                        ;80ab    c9      . 
sub_80ach:
    ld hl,(05c8dh)             ;80ac    2a 8d 5c    * . \ 
    ld (05c8fh),hl             ;80af    22 8f 5c    " . \ 
    ld hl,05c91h               ;80b2    21 91 5c    ! . \ 
    call 00d63h                ;80b5    cd 63 0d    . c . 
    ret                        ;80b8    c9      . 
    ex af,af'                  ;80b9    08      . 
    cp a                       ;80ba    bf      . 
    add a,b                    ;80bb    80      . 
    inc bc                     ;80bc    03      . 
    ld h,h                     ;80bd    64      d 
    add a,c                    ;80be    81      . 
    inc b                      ;80bf    04      . 
    add a,080h                 ;80c0    c6 80   . . 

; BLOCK 'PNT_string' (start 0x80c2 end 0x80c5)
PNT_string_start:
    defb 050h                  ;80c2    50      P 
    defb 04eh                  ;80c3    4e      N 
    defb 054h                  ;80c4    54      T 
PNT_string_end:
    rst 38h                    ;80c5    ff      . 
    call 01cadh                ;80c6    cd ad 1c    . . . 
    ld ix,l80d0h               ;80c9    dd 21 d0 80     . ! . . 
    jp l65f7h                  ;80cd    c3 f7 65    . . e 
l80d0h:
    rst 38h                    ;80d0    ff      . 
    dec b                      ;80d1    05      . 
    rst 38h                    ;80d2    ff      . 
    rst 38h                    ;80d3    ff      . 
    rst 38h                    ;80d4    ff      . 
    rst 38h                    ;80d5    ff      . 
    dec b                      ;80d6    05      . 
    rst 38h                    ;80d7    ff      . 
    rst 38h                    ;80d8    ff      . 
    rst 38h                    ;80d9    ff      . 
    jr z,$+7                   ;80da    28 05   ( . 
    rst 38h                    ;80dc    ff      . 
    rst 38h                    ;80dd    ff      . 
    djnz $+31                  ;80de    10 1d   . . 
    ld b,0ffh                  ;80e0    06 ff   . . 
    rst 38h                    ;80e2    ff      . 
    rst 38h                    ;80e3    ff      . 
    rst 38h                    ;80e4    ff      . 
    rrca                       ;80e5    0f      . 
    rst 38h                    ;80e6    ff      . 
    rst 38h                    ;80e7    ff      . 
    rst 38h                    ;80e8    ff      . 
    rst 38h                    ;80e9    ff      . 
    ld b,l                     ;80ea    45      E 
    rst 38h                    ;80eb    ff      . 
    rst 38h                    ;80ec    ff      . 
    rst 38h                    ;80ed    ff      . 
    dec b                      ;80ee    05      . 
    inc e                      ;80ef    1c      . 
    rst 38h                    ;80f0    ff      . 
    rst 38h                    ;80f1    ff      . 
    rst 38h                    ;80f2    ff      . 
    rst 38h                    ;80f3    ff      . 
    ld a,(0981ch)              ;80f4    3a 1c 98    : . . 
    cp 0ffh                    ;80f7    fe ff   . . 
    call 00d5eh                ;80f9    cd 5e 0d    . ^ . 
    ld a,(09816h)              ;80fc    3a 16 98    : . . 
    ld (05c8fh),a              ;80ff    32 8f 5c    2 . \ 
    call sub_814ch             ;8102    cd 4c 81    . L . 
    call 022e5h                ;8105    cd e5 22    . . " 
    jp l8147h                  ;8108    c3 47 81    . G . 
    call sub_814ch             ;810b    cd 4c 81    . L . 
    ld a,c                     ;810e    79      y 
    and 0f8h                   ;810f    e6 f8   . . 
    rrca                       ;8111    0f      . 
    rrca                       ;8112    0f      . 
    ld c,a                     ;8113    4f      O 
    ld a,b                     ;8114    78      x 
    rlca                       ;8115    07      . 
    rlca                       ;8116    07      . 
    ld b,a                     ;8117    47      G 
    and 0e0h                   ;8118    e6 e0   . . 
    xor c                      ;811a    a9      . 
    ld l,a                     ;811b    6f      o 
    ld a,b                     ;811c    78      x 
    and 003h                   ;811d    e6 03   . . 
    xor 058h                   ;811f    ee 58   . X 
    ld h,a                     ;8121    67      g 
    ld a,(hl)                  ;8122    7e      ~ 
    ld b,000h                  ;8123    06 00   . . 
    ld c,a                     ;8125    4f      O 
    ld (0981ah),bc             ;8126    ed 43 1a 98     . C . . 
    ld a,004h                  ;812a    3e 04   > . 
    ld (09819h),a              ;812c    32 19 98    2 . . 
    call sub_814ch             ;812f    cd 4c 81    . L . 
    call 022aah                ;8132    cd aa 22    . . " 
    ld b,a                     ;8135    47      G 
    inc b                      ;8136    04      . 
    ld a,(hl)                  ;8137    7e      ~ 
l8138h:
    rlca                       ;8138    07      . 
    djnz l8138h                ;8139    10 fd   . . 
    and 001h                   ;813b    e6 01   . . 
    ld c,a                     ;813d    4f      O 
    ld (09814h),bc             ;813e    ed 43 14 98     . C . . 
    ld a,004h                  ;8142    3e 04   > . 
    ld (09813h),a              ;8144    32 13 98    2 . . 
l8147h:
    call sub_80ach             ;8147    cd ac 80    . . . 
    cp a                       ;814a    bf      . 
    ret                        ;814b    c9      . 
sub_814ch:
    call sub_809dh             ;814c    cd 9d 80    . . . 
    ld hl,(0980ah)             ;814f    2a 0a 98    * . . 
    ld de,00080h               ;8152    11 80 00    . . . 
    call sub_8088h             ;8155    cd 88 80    . . . 
    ld c,l                     ;8158    4d      M 
    ld hl,(09810h)             ;8159    2a 10 98    * . . 
    ld de,00058h               ;815c    11 58 00    . X . 
    call sub_8088h             ;815f    cd 88 80    . . . 
    ld b,l                     ;8162    45      E 
    ret                        ;8163    c9      . 
    ex af,af'                  ;8164    08      . 
    ld l,d                     ;8165    6a      j 
    add a,c                    ;8166    81      . 
    inc bc                     ;8167    03      . 
    rst 28h                    ;8168    ef      . 
    add a,c                    ;8169    81      . 
    inc b                      ;816a    04      . 
    ld (hl),c                  ;816b    71      q 
    add a,c                    ;816c    81      . 

; BLOCK 'RND_string' (start 0x816d end 0x8170)
RND_string_start:
    defb 052h                  ;816d    52      R 
    defb 04eh                  ;816e    4e      N 
    defb 044h                  ;816f    44      D 
RND_string_end:
    rst 38h                    ;8170    ff      . 
    ld ix,l8178h               ;8171    dd 21 78 81     . ! x . 
    jp l65f7h                  ;8175    c3 f7 65    . . e 
l8178h:
    inc d                      ;8178    14      . 
    rrca                       ;8179    0f      . 
    rst 38h                    ;817a    ff      . 
    rst 38h                    ;817b    ff      . 
    dec b                      ;817c    05      . 
    rst 38h                    ;817d    ff      . 
    dec b                      ;817e    05      . 
    rst 38h                    ;817f    ff      . 
    rst 38h                    ;8180    ff      . 
    rst 38h                    ;8181    ff      . 
    dec e                      ;8182    1d      . 
    rst 38h                    ;8183    ff      . 
    rst 38h                    ;8184    ff      . 
    rst 38h                    ;8185    ff      . 
    rst 38h                    ;8186    ff      . 
    ld a,(bc)                  ;8187    0a      . 
    rst 38h                    ;8188    ff      . 
    rst 38h                    ;8189    ff      . 
    rst 38h                    ;818a    ff      . 
    rst 38h                    ;818b    ff      . 
    ld hl,(05c78h)             ;818c    2a 78 5c    * x \ 
    jr l819ah                  ;818f    18 09   . . 
    ld a,(0980ch)              ;8191    3a 0c 98    : . . 
    cp 004h                    ;8194    fe 04   . . 
    ret nz                     ;8196    c0      . 
    ld hl,(0980ah)             ;8197    2a 0a 98    * . . 
l819ah:
    ld (05c76h),hl             ;819a    22 76 5c    " v \ 
    cp a                       ;819d    bf      . 
    ret                        ;819e    c9      . 
    ld a,(09812h)              ;819f    3a 12 98    : . . 
    cp 004h                    ;81a2    fe 04   . . 
    ret nz                     ;81a4    c0      . 
    ld hl,(09810h)             ;81a5    2a 10 98    * . . 
    call sub_81b6h             ;81a8    cd b6 81    . . . 
    ld a,004h                  ;81ab    3e 04   > . 
    ld (09808h),bc             ;81ad    ed 43 08 98     . C . . 
    ld (09807h),a              ;81b1    32 07 98    2 . . 
    cp a                       ;81b4    bf      . 
    ret                        ;81b5    c9      . 
sub_81b6h:
    push hl                    ;81b6    e5      . 
    ld hl,(05c76h)             ;81b7    2a 76 5c    * v \ 
    ld de,0004dh               ;81ba    11 4d 00    . M . 
    ld a,h                     ;81bd    7c      | 
    or l                       ;81be    b5      . 
    jr z,l81cch                ;81bf    28 0b   ( . 
    call sub_81d9h             ;81c1    cd d9 81    . . . 
    and a                      ;81c4    a7      . 
    sbc hl,bc                  ;81c5    ed 42   . B 
    jr nc,l81ceh               ;81c7    30 05   0 . 
    inc hl                     ;81c9    23      # 
    jr l81ceh                  ;81ca    18 02   . . 
l81cch:
    sbc hl,de                  ;81cc    ed 52   . R 
l81ceh:
    ld (05c76h),hl             ;81ce    22 76 5c    " v \ 
    pop de                     ;81d1    d1      . 
    call sub_81d9h             ;81d2    cd d9 81    . . . 
    ld h,b                     ;81d5    60      ` 
    ld l,c                     ;81d6    69      i 
    inc hl                     ;81d7    23      # 
    ret                        ;81d8    c9      . 
sub_81d9h:
    ld b,h                     ;81d9    44      D 
    ld c,l                     ;81da    4d      M 
    ld a,010h                  ;81db    3e 10   > . 
    ld hl,00000h               ;81dd    21 00 00    ! . . 
l81e0h:
    add hl,hl                  ;81e0    29      ) 
    rl c                       ;81e1    cb 11   . . 
    rl b                       ;81e3    cb 10   . . 
    jr nc,l81ebh               ;81e5    30 04   0 . 
    add hl,de                  ;81e7    19      . 
    jr nc,l81ebh               ;81e8    30 01   0 . 
    inc bc                     ;81ea    03      . 
l81ebh:
    dec a                      ;81eb    3d      = 
    jr nz,l81e0h               ;81ec    20 f2     . 
    ret                        ;81ee    c9      . 
    ex af,af'                  ;81ef    08      . 
    push af                    ;81f0    f5      . 
    add a,c                    ;81f1    81      . 
    inc bc                     ;81f2    03      . 
    jr z,$-124                 ;81f3    28 82   ( . 
    inc b                      ;81f5    04      . 
    ei                         ;81f6    fb      . 
    add a,c                    ;81f7    81      . 

; BLOCK 'BP_string' (start 0x81f8 end 0x81fa)
BP_string_start:
    defb 042h                  ;81f8    42      B 
    defb 050h                  ;81f9    50      P 
BP_string_end:
    rst 38h                    ;81fa    ff      . 
    ld ix,l8202h               ;81fb    dd 21 02 82     . ! . . 
    jp l65f7h                  ;81ff    c3 f7 65    . . e 
l8202h:
    rst 38h                    ;8202    ff      . 
    dec b                      ;8203    05      . 
    rst 38h                    ;8204    ff      . 
    rst 38h                    ;8205    ff      . 
    rst 38h                    ;8206    ff      . 
    rst 38h                    ;8207    ff      . 
    dec b                      ;8208    05      . 
    rst 38h                    ;8209    ff      . 
    rst 38h                    ;820a    ff      . 
    rst 38h                    ;820b    ff      . 
    dec b                      ;820c    05      . 
    rst 38h                    ;820d    ff      . 
    rst 38h                    ;820e    ff      . 
    rst 38h                    ;820f    ff      . 
    rst 38h                    ;8210    ff      . 
    call sub_809dh             ;8211    cd 9d 80    . . . 
    ld hl,(09810h)             ;8214    2a 10 98    * . . 
    ld a,h                     ;8217    7c      | 
    or l                       ;8218    b5      . 
    jr z,l8226h                ;8219    28 0b   ( . 
    ld de,(0980ah)             ;821b    ed 5b 0a 98     . [ . . 
    ld a,d                     ;821f    7a      z 
    or e                       ;8220    b3      . 
    jr z,l8226h                ;8221    28 03   ( . 
    call 003b5h                ;8223    cd b5 03    . . . 
l8226h:
    cp a                       ;8226    bf      . 
    ret                        ;8227    c9      . 
    ex af,af'                  ;8228    08      . 
    ld l,082h                  ;8229    2e 82   . . 
    inc bc                     ;822b    03      . 
    ld l,a                     ;822c    6f      o 
    add a,d                    ;822d    82      . 
    inc b                      ;822e    04      . 
    dec (hl)                   ;822f    35      5 
    add a,d                    ;8230    82      . 

; BLOCK 'CLS_string' (start 0x8231 end 0x8234)
CLS_string_start:
    defb 043h                  ;8231    43      C 
    defb 04ch                  ;8232    4c      L 
    defb 053h                  ;8233    53      S 
CLS_string_end:
    rst 38h                    ;8234    ff      . 
    ld ix,l823ch               ;8235    dd 21 3c 82     . ! < . 
    jp l65f7h                  ;8239    c3 f7 65    . . e 
l823ch:
    ld a,(bc)                  ;823c    0a      . 
    dec b                      ;823d    05      . 
    rst 38h                    ;823e    ff      . 
    rst 38h                    ;823f    ff      . 
    rst 38h                    ;8240    ff      . 
    ld a,(bc)                  ;8241    0a      . 
    rst 38h                    ;8242    ff      . 
    rst 38h                    ;8243    ff      . 
    rst 38h                    ;8244    ff      . 
    rst 38h                    ;8245    ff      . 
    ld a,(05c8fh)              ;8246    3a 8f 5c    : . \ 
    jr l825ah                  ;8249    18 0f   . . 
    ld a,(0980ch)              ;824b    3a 0c 98    : . . 
    cp 004h                    ;824e    fe 04   . . 
    ret nz                     ;8250    c0      . 
    ld a,(0980ah)              ;8251    3a 0a 98    : . . 
    sla a                      ;8254    cb 27   . ' 
    sla a                      ;8256    cb 27   . ' 
    sla a                      ;8258    cb 27   . ' 
l825ah:
    ld (05c8dh),a              ;825a    32 8d 5c    2 . \ 
    push af                    ;825d    f5      . 
    ld a,(iy+002h)             ;825e    fd 7e 02    . ~ . 
    push af                    ;8261    f5      . 
    call 00dafh                ;8262    cd af 0d    . . . 
    pop af                     ;8265    f1      . 
    ld (iy+002h),a             ;8266    fd 77 02    . w . 
    pop af                     ;8269    f1      . 
    ld (05c8fh),a              ;826a    32 8f 5c    2 . \ 
    cp a                       ;826d    bf      . 
    ret                        ;826e    c9      . 
    ex af,af'                  ;826f    08      . 
    ld (hl),l                  ;8270    75      u 
    add a,d                    ;8271    82      . 
    inc bc                     ;8272    03      . 
    add a,082h                 ;8273    c6 82   . . 
    inc b                      ;8275    04      . 
    ld a,h                     ;8276    7c      | 
    add a,d                    ;8277    82      . 

; BLOCK 'PIO_string' (start 0x8278 end 0x827b)
PIO_string_start:
    defb 050h                  ;8278    50      P 
    defb 049h                  ;8279    49      I 
    defb 04fh                  ;827a    4f      O 
PIO_string_end:
    rst 38h                    ;827b    ff      . 
    ld ix,l8283h               ;827c    dd 21 83 82     . ! . . 
    jp l65f7h                  ;8280    c3 f7 65    . . e 
l8283h:
    rst 38h                    ;8283    ff      . 
    dec b                      ;8284    05      . 
    rst 38h                    ;8285    ff      . 
    rst 38h                    ;8286    ff      . 
    rst 38h                    ;8287    ff      . 
    rst 38h                    ;8288    ff      . 
    dec b                      ;8289    05      . 
    rst 38h                    ;828a    ff      . 
    rst 38h                    ;828b    ff      . 
    ld a,(bc)                  ;828c    0a      . 
    ld a,(bc)                  ;828d    0a      . 
    rst 38h                    ;828e    ff      . 
    rst 38h                    ;828f    ff      . 
    rst 38h                    ;8290    ff      . 
    rst 38h                    ;8291    ff      . 
    ld d,0ffh                  ;8292    16 ff   . . 
    rst 38h                    ;8294    ff      . 
    rst 38h                    ;8295    ff      . 
    rst 38h                    ;8296    ff      . 
    call sub_82bch             ;8297    cd bc 82    . . . 
    ret nz                     ;829a    c0      . 
    ld a,(09812h)              ;829b    3a 12 98    : . . 
    cp 004h                    ;829e    fe 04   . . 
    ret nz                     ;82a0    c0      . 
    ld a,(09810h)              ;82a1    3a 10 98    : . . 
    out (c),a                  ;82a4    ed 79   . y 
    cp a                       ;82a6    bf      . 
    ret                        ;82a7    c9      . 
    call sub_82bch             ;82a8    cd bc 82    . . . 
    ret nz                     ;82ab    c0      . 
    in a,(c)                   ;82ac    ed 78   . x 
    ld c,a                     ;82ae    4f      O 
    ld b,000h                  ;82af    06 00   . . 
    ld (0980eh),bc             ;82b1    ed 43 0e 98     . C . . 
    ld a,004h                  ;82b5    3e 04   > . 
    ld (0980dh),a              ;82b7    32 0d 98    2 . . 
    cp a                       ;82ba    bf      . 
    ret                        ;82bb    c9      . 
sub_82bch:
    ld a,(0980ch)              ;82bc    3a 0c 98    : . . 
    cp 004h                    ;82bf    fe 04   . . 
    ld bc,(0980ah)             ;82c1    ed 4b 0a 98     . K . . 
    ret                        ;82c5    c9      . 
    ex af,af'                  ;82c6    08      . 
    call z,00382h              ;82c7    cc 82 03    . . . 
    pop de                     ;82ca    d1      . 
    add a,d                    ;82cb    82      . 
    inc b                      ;82cc    04      . 
    adc a,b                    ;82cd    88      . 
    call m,0ffa8h              ;82ce    fc a8 ff    . . . 
    ex af,af'                  ;82d1    08      . 
    rst 10h                    ;82d2    d7      . 
    add a,d                    ;82d3    82      . 
    inc bc                     ;82d4    03      . 
    dec d                      ;82d5    15      . 
    add a,e                    ;82d6    83      . 
    inc b                      ;82d7    04      . 
    pop hl                     ;82d8    e1      . 
    add a,d                    ;82d9    82      . 

; BLOCK 'BORDER_string' (start 0x82da end 0x82e0)
BORDER_string_start:
    defb 042h                  ;82da    42      B 
    defb 04fh                  ;82db    4f      O 
    defb 052h                  ;82dc    52      R 
    defb 044h                  ;82dd    44      D 
    defb 045h                  ;82de    45      E 
    defb 052h                  ;82df    52      R 
BORDER_string_end:
    rst 38h                    ;82e0    ff      . 
    ld ix,l82e8h               ;82e1    dd 21 e8 82     . ! . . 
    jp l65f7h                  ;82e5    c3 f7 65    . . e 
l82e8h:
    rst 38h                    ;82e8    ff      . 
    dec b                      ;82e9    05      . 
    rst 38h                    ;82ea    ff      . 
    rst 38h                    ;82eb    ff      . 
    rst 38h                    ;82ec    ff      . 
    dec b                      ;82ed    05      . 
    rst 38h                    ;82ee    ff      . 
    rst 38h                    ;82ef    ff      . 
    rst 38h                    ;82f0    ff      . 
    rst 38h                    ;82f1    ff      . 
    ld a,(0980ch)              ;82f2    3a 0c 98    : . . 
    cp 004h                    ;82f5    fe 04   . . 
    ret nz                     ;82f7    c0      . 
    ld a,(0980ah)              ;82f8    3a 0a 98    : . . 
    and 007h                   ;82fb    e6 07   . . 
    out (0feh),a               ;82fd    d3 fe   . . 
    rlca                       ;82ff    07      . 
    rlca                       ;8300    07      . 
    rlca                       ;8301    07      . 
    ld (05c48h),a              ;8302    32 48 5c    2 H \ 
    bit 1,(iy+002h)            ;8305    fd cb 02 4e     . . . N 
    jr nz,l8313h               ;8309    20 08     . 
    ld a,(05c6bh)              ;830b    3a 6b 5c    : k \ 
    dec a                      ;830e    3d      = 
    ld b,a                     ;830f    47      G 
    call 00e44h                ;8310    cd 44 0e    . D . 
l8313h:
    cp a                       ;8313    bf      . 
    ret                        ;8314    c9      . 
    ex af,af'                  ;8315    08      . 
    dec de                     ;8316    1b      . 
    add a,e                    ;8317    83      . 
    inc bc                     ;8318    03      . 
    ld (00483h),a              ;8319    32 83 04    2 . . 
    dec h                      ;831c    25      % 
    add a,e                    ;831d    83      . 

; BLOCK 'HYBRID_string' (start 0x831e end 0x8324)
HYBRID_string_start:
    defb 048h                  ;831e    48      H 
    defb 059h                  ;831f    59      Y 
    defb 042h                  ;8320    42      B 
    defb 052h                  ;8321    52      R 
    defb 049h                  ;8322    49      I 
    defb 044h                  ;8323    44      D 
HYBRID_string_end:
    rst 38h                    ;8324    ff      . 
    call 00dafh                ;8325    cd af 0d    . . . 
    ld a,003h                  ;8328    3e 03   > . 
    ld (09b6ch),a              ;832a    32 6c 9b    2 l . 
    set 0,(iy+002h)            ;832d    fd cb 02 c6     . . . . 
    ret                        ;8331    c9      . 
    ex af,af'                  ;8332    08      . 
    jr c,$-123                 ;8333    38 83   8 . 
    inc bc                     ;8335    03      . 
    ld d,e                     ;8336    53      S 
    add a,e                    ;8337    83      . 
    inc b                      ;8338    04      . 
    ld b,d                     ;8339    42      B 
    add a,e                    ;833a    83      . 

; BLOCK 'NORMAL_string' (start 0x833b end 0x8341)
NORMAL_string_start:
    defb 04eh                  ;833b    4e      N 
    defb 04fh                  ;833c    4f      O 
    defb 052h                  ;833d    52      R 
    defb 04dh                  ;833e    4d      M 
    defb 041h                  ;833f    41      A 
    defb 04ch                  ;8340    4c      L 
NORMAL_string_end:
    rst 38h                    ;8341    ff      . 
    res 0,(iy+002h)            ;8342    fd cb 02 86     . . . . 
    call 00dafh                ;8346    cd af 0d    . . . 
    ld a,002h                  ;8349    3e 02   > . 
    ld (09b6ch),a              ;834b    32 6c 9b    2 l . 
    ld (05c6bh),a              ;834e    32 6b 5c    2 k \ 
    cp a                       ;8351    bf      . 
    ret                        ;8352    c9      . 
    ex af,af'                  ;8353    08      . 
    ld e,c                     ;8354    59      Y 
    add a,e                    ;8355    83      . 
    inc bc                     ;8356    03      . 
    dec d                      ;8357    15      . 
    adc a,e                    ;8358    8b      . 
    inc b                      ;8359    04      . 
    ld h,d                     ;835a    62      b 
    add a,e                    ;835b    83      . 

; BLOCK 'INKEY_string' (start 0x835c end 0x8361)
INKEY_string_start:
    defb 049h                  ;835c    49      I 
    defb 04eh                  ;835d    4e      N 
    defb 04bh                  ;835e    4b      K 
    defb 045h                  ;835f    45      E 
    defb 059h                  ;8360    59      Y 
INKEY_string_end:
    rst 38h                    ;8361    ff      . 
    ld ix,l8369h               ;8362    dd 21 69 83     . ! i . 
    jp l65f7h                  ;8366    c3 f7 65    . . e 
l8369h:
    rst 38h                    ;8369    ff      . 
    rst 38h                    ;836a    ff      . 
    rst 38h                    ;836b    ff      . 
    rst 38h                    ;836c    ff      . 
    dec b                      ;836d    05      . 
    dec b                      ;836e    05      . 
    rst 38h                    ;836f    ff      . 
    rst 38h                    ;8370    ff      . 
    rst 38h                    ;8371    ff      . 
    rst 38h                    ;8372    ff      . 
    call 0028eh                ;8373    cd 8e 02    . . . 
    ld c,000h                  ;8376    0e 00   . . 
    jr nz,l837eh               ;8378    20 04     . 
    ld a,e                     ;837a    7b      { 
    inc a                      ;837b    3c      < 
    jr nz,l8382h               ;837c    20 04     . 
l837eh:
    ld a,0feh                  ;837e    3e fe   > . 
    jr l8394h                  ;8380    18 12   . . 
l8382h:
    call 0031eh                ;8382    cd 1e 03    . . . 
    jr c,l838fh                ;8385    38 08   8 . 
    cp 027h                    ;8387    fe 27   . ' 
    jr nz,l8394h               ;8389    20 09     . 
    ld a,019h                  ;838b    3e 19   > . 
    jr l8394h                  ;838d    18 05   . . 
l838fh:
    dec d                      ;838f    15      . 
    ld e,a                     ;8390    5f      _ 
    call 00333h                ;8391    cd 33 03    . 3 . 
l8394h:
    ld l,a                     ;8394    6f      o 
    xor a                      ;8395    af      . 
    ld (05c41h),a              ;8396    32 41 5c    2 A \ 
    res 3,(iy+030h)            ;8399    fd cb 30 9e     . . 0 . 
    jp l7bdbh                  ;839d    c3 db 7b    . . { 
l83a0h:
    ex af,af'                  ;83a0    08      . 
    djnz $-115                 ;83a1    10 8b   . . 
    inc bc                     ;83a3    03      . 
    dec sp                     ;83a4    3b                     ; 
    adc a,c                    ;83a5    89      . 
    djnz $+1                   ;83a6    10 ff   . . 
    rst 38h                    ;83a8    ff      . 
    djnz $+1                   ;83a9    10 ff   . . 
    rst 38h                    ;83ab    ff      . 
    ex af,af'                  ;83ac    08      . 
    or d                       ;83ad    b2      . 
    add a,e                    ;83ae    83      . 
    inc bc                     ;83af    03      . 
    rst 28h                    ;83b0    ef      . 
    add a,e                    ;83b1    83      . 
    inc bc                     ;83b2    03      . 
    cp c                       ;83b3    b9      . 
    add a,e                    ;83b4    83      . 

; BLOCK 'NOT_string' (start 0x83b5 end 0x83b8)
NOT_string_start:
    defb 04eh                  ;83b5    4e      N 
    defb 04fh                  ;83b6    4f      O 
    defb 054h                  ;83b7    54      T 
NOT_string_end:
    rst 38h                    ;83b8    ff      . 
    inc bc                     ;83b9    03      . 
    cp a                       ;83ba    bf      . 
    add a,e                    ;83bb    83      . 
    inc bc                     ;83bc    03      . 
    defb 0ddh,083h,004h        ;illegal sequence               ;83bd    dd 83 04    . . . 
    ld bc,00300h               ;83c0    01 00 03    . . . 
    push bc                    ;83c3    c5      . 
    add a,e                    ;83c4    83      . 
    inc c                      ;83c5    0c      . 
    nop                        ;83c6    00      . 
    nop                        ;83c7    00      . 
    inc bc                     ;83c8    03      . 
    res 0,e                    ;83c9    cb 83   . . 
    inc c                      ;83cb    0c      . 
    nop                        ;83cc    00      . 
    nop                        ;83cd    00      . 
    inc bc                     ;83ce    03      . 
    pop de                     ;83cf    d1      . 
    add a,e                    ;83d0    83      . 
    ex af,af'                  ;83d1    08      . 
    ld l,c                     ;83d2    69      i 
    halt                       ;83d3    76      v 
    inc bc                     ;83d4    03      . 
    rst 10h                    ;83d5    d7      . 
    add a,e                    ;83d6    83      . 
    ex af,af'                  ;83d7    08      . 
    rst 38h                    ;83d8    ff      . 
    ld (hl),l                  ;83d9    75      u 
    djnz $+1                   ;83da    10 ff   . . 
    rst 38h                    ;83dc    ff      . 
    inc bc                     ;83dd    03      . 
    ex (sp),hl                 ;83de    e3      . 
    add a,e                    ;83df    83      . 
    djnz $+1                   ;83e0    10 ff   . . 
    rst 38h                    ;83e2    ff      . 
    inc b                      ;83e3    04      . 
    ld bc,00300h               ;83e4    01 00 03    . . . 
    jp (hl)                    ;83e7    e9      . 
    add a,e                    ;83e8    83      . 
    inc c                      ;83e9    0c      . 
    nop                        ;83ea    00      . 
    nop                        ;83eb    00      . 
    djnz $+1                   ;83ec    10 ff   . . 
    rst 38h                    ;83ee    ff      . 
    ex af,af'                  ;83ef    08      . 
    push af                    ;83f0    f5      . 
    add a,e                    ;83f1    83      . 
    inc bc                     ;83f2    03      . 
    inc de                     ;83f3    13      . 
    add a,h                    ;83f4    84      . 
    inc bc                     ;83f5    03      . 
    ei                         ;83f6    fb      . 
    add a,e                    ;83f7    83      . 

; BLOCK 'EQ_string' (start 0x83f8 end 0x83fa)
EQ_string_start:
    defb 045h                  ;83f8    45      E 
    defb 051h                  ;83f9    51      Q 
EQ_string_end:
    rst 38h                    ;83fa    ff      . 
    inc bc                     ;83fb    03      . 
    ld bc,01084h               ;83fc    01 84 10    . . . 
    rst 38h                    ;83ff    ff      . 
    rst 38h                    ;8400    ff      . 
    inc b                      ;8401    04      . 
    ld bc,00300h               ;8402    01 00 03    . . . 
    rlca                       ;8405    07      . 
    add a,h                    ;8406    84      . 
    inc bc                     ;8407    03      . 
    dec c                      ;8408    0d      . 
    add a,h                    ;8409    84      . 
    djnz $+1                   ;840a    10 ff   . . 
    rst 38h                    ;840c    ff      . 
    inc c                      ;840d    0c      . 
    nop                        ;840e    00      . 
    nop                        ;840f    00      . 
    inc bc                     ;8410    03      . 
    jp (hl)                    ;8411    e9      . 
    add a,e                    ;8412    83      . 
    ex af,af'                  ;8413    08      . 
    add hl,de                  ;8414    19      . 
    add a,h                    ;8415    84      . 
    inc bc                     ;8416    03      . 
    ld h,c                     ;8417    61      a 
    add a,h                    ;8418    84      . 
    inc bc                     ;8419    03      . 
    rra                        ;841a    1f      . 
    add a,h                    ;841b    84      . 

; BLOCK 'IF_string' (start 0x841c end 0x841e)
IF_string_start:
    defb 049h                  ;841c    49      I 
    defb 046h                  ;841d    46      F 
IF_string_end:
    rst 38h                    ;841e    ff      . 
    inc bc                     ;841f    03      . 
    dec h                      ;8420    25      % 
    add a,h                    ;8421    84      . 
    inc bc                     ;8422    03      . 
    ld c,a                     ;8423    4f      O 
    add a,h                    ;8424    84      . 
    inc b                      ;8425    04      . 
    inc bc                     ;8426    03      . 
    nop                        ;8427    00      . 
    inc bc                     ;8428    03      . 
    dec hl                     ;8429    2b      + 
    add a,h                    ;842a    84      . 
    inc bc                     ;842b    03      . 
    ld sp,00384h               ;842c    31 84 03    1 . . 
    ld b,e                     ;842f    43      C 
    add a,h                    ;8430    84      . 
    inc c                      ;8431    0c      . 
    nop                        ;8432    00      . 
    nop                        ;8433    00      . 
    inc bc                     ;8434    03      . 
    scf                        ;8435    37      7 
    add a,h                    ;8436    84      . 
    inc c                      ;8437    0c      . 
    inc bc                     ;8438    03      . 
    nop                        ;8439    00      . 
    inc bc                     ;843a    03      . 
    dec a                      ;843b    3d      = 
    add a,h                    ;843c    84      . 
    inc c                      ;843d    0c      . 
    ld b,000h                  ;843e    06 00   . . 
    djnz $+1                   ;8440    10 ff   . . 
    rst 38h                    ;8442    ff      . 
    inc c                      ;8443    0c      . 
    nop                        ;8444    00      . 
    nop                        ;8445    00      . 
    inc bc                     ;8446    03      . 
    ld c,c                     ;8447    49      I 
    add a,h                    ;8448    84      . 
    ex af,af'                  ;8449    08      . 
    ld l,c                     ;844a    69      i 
    halt                       ;844b    76      v 
    inc c                      ;844c    0c      . 
    inc bc                     ;844d    03      . 
    nop                        ;844e    00      . 
    inc bc                     ;844f    03      . 
    ld d,l                     ;8450    55      U 
    add a,h                    ;8451    84      . 
    djnz $+1                   ;8452    10 ff   . . 
    rst 38h                    ;8454    ff      . 
    inc b                      ;8455    04      . 
    inc bc                     ;8456    03      . 
    nop                        ;8457    00      . 
    inc bc                     ;8458    03      . 
    ld e,e                     ;8459    5b      [ 
    add a,h                    ;845a    84      . 
    inc bc                     ;845b    03      . 
    ld sp,00c84h               ;845c    31 84 0c    1 . . 
    ld b,000h                  ;845f    06 00   . . 
    ex af,af'                  ;8461    08      . 
    ld h,a                     ;8462    67      g 
    add a,h                    ;8463    84      . 
    inc bc                     ;8464    03      . 
    and e                      ;8465    a3      . 
    add a,h                    ;8466    84      . 
    inc bc                     ;8467    03      . 
    ld l,l                     ;8468    6d      m 
    add a,h                    ;8469    84      . 

; BLOCK 'OR_string' (start 0x846a end 0x846c)
OR_string_start:
    defb 04fh                  ;846a    4f      O 
    defb 052h                  ;846b    52      R 
OR_string_end:
    rst 38h                    ;846c    ff      . 
    inc bc                     ;846d    03      . 
    ld (hl),e                  ;846e    73      s 
    add a,h                    ;846f    84      . 
    inc bc                     ;8470    03      . 
    adc a,e                    ;8471    8b      . 
    add a,h                    ;8472    84      . 
    inc b                      ;8473    04      . 
    ld (bc),a                  ;8474    02      . 
    nop                        ;8475    00      . 
    inc bc                     ;8476    03      . 
    ld a,c                     ;8477    79      y 
    add a,h                    ;8478    84      . 
    inc bc                     ;8479    03      . 
    ld a,a                     ;847a    7f       
    add a,h                    ;847b    84      . 
    inc c                      ;847c    0c      . 
    nop                        ;847d    00      . 
    nop                        ;847e    00      . 
    inc c                      ;847f    0c      . 
    nop                        ;8480    00      . 
    nop                        ;8481    00      . 
    inc bc                     ;8482    03      . 
    add a,l                    ;8483    85      . 
    add a,h                    ;8484    84      . 
    inc c                      ;8485    0c      . 
    inc bc                     ;8486    03      . 
    nop                        ;8487    00      . 
    djnz $+1                   ;8488    10 ff   . . 
    rst 38h                    ;848a    ff      . 
    inc bc                     ;848b    03      . 
    sub c                      ;848c    91      . 
    add a,h                    ;848d    84      . 
    djnz $+1                   ;848e    10 ff   . . 
    rst 38h                    ;8490    ff      . 
    inc b                      ;8491    04      . 
    ld (bc),a                  ;8492    02      . 
    nop                        ;8493    00      . 
    inc bc                     ;8494    03      . 
    sub a                      ;8495    97      . 
    add a,h                    ;8496    84      . 
    inc bc                     ;8497    03      . 
    ld a,a                     ;8498    7f       
    add a,h                    ;8499    84      . 
    inc c                      ;849a    0c      . 
    inc bc                     ;849b    03      . 
    nop                        ;849c    00      . 
l849dh:
    djnz $+1                   ;849d    10 ff   . . 
    rst 38h                    ;849f    ff      . 
    djnz $+1                   ;84a0    10 ff   . . 
    rst 38h                    ;84a2    ff      . 
    ex af,af'                  ;84a3    08      . 
    xor c                      ;84a4    a9      . 
    add a,h                    ;84a5    84      . 
    inc bc                     ;84a6    03      . 
    xor e                      ;84a7    ab      . 
    add a,l                    ;84a8    85      . 
    inc bc                     ;84a9    03      . 
    xor a                      ;84aa    af      . 
    add a,h                    ;84ab    84      . 
    ld b,e                     ;84ac    43      C 
    ld c,h                     ;84ad    4c      L 
    rst 38h                    ;84ae    ff      . 
    inc bc                     ;84af    03      . 
    or l                       ;84b0    b5      . 
    add a,h                    ;84b1    84      . 
    inc bc                     ;84b2    03      . 
    rst 18h                    ;84b3    df      . 
    add a,h                    ;84b4    84      . 
    inc b                      ;84b5    04      . 
    ld (bc),a                  ;84b6    02      . 
    nop                        ;84b7    00      . 
    inc bc                     ;84b8    03      . 
    cp e                       ;84b9    bb      . 
    add a,h                    ;84ba    84      . 
    inc bc                     ;84bb    03      . 
    xor a                      ;84bc    af      . 
    adc a,b                    ;84bd    88      . 
    inc bc                     ;84be    03      . 
    pop bc                     ;84bf    c1      . 
    add a,h                    ;84c0    84      . 
    ex af,af'                  ;84c1    08      . 
    ld l,c                     ;84c2    69      i 
    halt                       ;84c3    76      v 
    inc bc                     ;84c4    03      . 
    rst 0                      ;84c5    c7      . 
    add a,h                    ;84c6    84      . 
    inc bc                     ;84c7    03      . 
    call 01084h                ;84c8    cd 84 10    . . . 
    rst 38h                    ;84cb    ff      . 
    rst 38h                    ;84cc    ff      . 
    ex af,af'                  ;84cd    08      . 
    xor c                      ;84ce    a9      . 
    add a,h                    ;84cf    84      . 
    inc bc                     ;84d0    03      . 
    out (084h),a               ;84d1    d3 84   . . 
    inc c                      ;84d3    0c      . 
    nop                        ;84d4    00      . 
    nop                        ;84d5    00      . 
    inc bc                     ;84d6    03      . 
    exx                        ;84d7    d9      . 
    add a,h                    ;84d8    84      . 
    inc b                      ;84d9    04      . 
    ld bc,00300h               ;84da    01 00 03    . . . 
    add a,l                    ;84dd    85      . 
    add a,h                    ;84de    84      . 
    inc bc                     ;84df    03      . 
    push hl                    ;84e0    e5      . 
    add a,h                    ;84e1    84      . 
    djnz $+1                   ;84e2    10 ff   . . 
    rst 38h                    ;84e4    ff      . 
    inc b                      ;84e5    04      . 
    ex af,af'                  ;84e6    08      . 
    nop                        ;84e7    00      . 
    inc bc                     ;84e8    03      . 
    ex de,hl                   ;84e9    eb      . 
    add a,h                    ;84ea    84      . 
    inc bc                     ;84eb    03      . 
    pop af                     ;84ec    f1      . 
    add a,h                    ;84ed    84      . 
    inc bc                     ;84ee    03      . 
    ld hl,00385h               ;84ef    21 85 03    ! . . 
    rst 30h                    ;84f2    f7      . 
    add a,h                    ;84f3    84      . 
    inc bc                     ;84f4    03      . 
    inc bc                     ;84f5    03      . 
    add a,l                    ;84f6    85      . 
    inc bc                     ;84f7    03      . 
    defb 0fdh,084h,00ch        ;illegal sequence               ;84f8    fd 84 0c    . . . 
    ld b,000h                  ;84fb    06 00   . . 
    inc c                      ;84fd    0c      . 
    nop                        ;84fe    00      . 
    nop                        ;84ff    00      . 
    inc c                      ;8500    0c      . 
    inc bc                     ;8501    03      . 
    nop                        ;8502    00      . 
    inc c                      ;8503    0c      . 
    add hl,bc                  ;8504    09      . 
    nop                        ;8505    00      . 
    inc bc                     ;8506    03      . 
    add hl,bc                  ;8507    09      . 
    add a,l                    ;8508    85      . 
    inc c                      ;8509    0c      . 
    inc c                      ;850a    0c      . 
    nop                        ;850b    00      . 
    djnz $+1                   ;850c    10 ff   . . 
    rst 38h                    ;850e    ff      . 
    inc bc                     ;850f    03      . 
    dec d                      ;8510    15      . 
    add a,l                    ;8511    85      . 
    djnz $+1                   ;8512    10 ff   . . 
    rst 38h                    ;8514    ff      . 
    ex af,af'                  ;8515    08      . 
    ld h,a                     ;8516    67      g 
    add a,h                    ;8517    84      . 
    inc bc                     ;8518    03      . 
    dec de                     ;8519    1b      . 
    add a,l                    ;851a    85      . 
    inc bc                     ;851b    03      . 
    ld b,l                     ;851c    45      E 
    add a,l                    ;851d    85      . 
    inc bc                     ;851e    03      . 
    ld l,a                     ;851f    6f      o 
    add a,l                    ;8520    85      . 
    inc bc                     ;8521    03      . 
    daa                        ;8522    27      ' 
    add a,l                    ;8523    85      . 
    inc bc                     ;8524    03      . 
    rrca                       ;8525    0f      . 
    add a,l                    ;8526    85      . 
    ex af,af'                  ;8527    08      . 
    ex de,hl                   ;8528    eb      . 
    ld a,(hl)                  ;8529    7e      ~ 
    inc bc                     ;852a    03      . 
    dec l                      ;852b    2d      - 
    add a,l                    ;852c    85      . 
    inc c                      ;852d    0c      . 
    nop                        ;852e    00      . 
    nop                        ;852f    00      . 
    inc bc                     ;8530    03      . 
    inc sp                     ;8531    33      3 
    add a,l                    ;8532    85      . 
    inc c                      ;8533    0c      . 
    rrca                       ;8534    0f      . 
    nop                        ;8535    00      . 
    inc bc                     ;8536    03      . 
l8537h:
    add hl,sp                  ;8537    39      9 
    add a,l                    ;8538    85      . 
    inc c                      ;8539    0c      . 
    ld (de),a                  ;853a    12      . 
    nop                        ;853b    00      . 
    inc bc                     ;853c    03      . 
    ccf                        ;853d    3f      ? 
    add a,l                    ;853e    85      . 
    inc c                      ;853f    0c      . 
    add hl,bc                  ;8540    09      . 
    nop                        ;8541    00      . 
    djnz $+1                   ;8542    10 ff   . . 
    rst 38h                    ;8544    ff      . 
    inc bc                     ;8545    03      . 
    ld c,e                     ;8546    4b      K 
    add a,l                    ;8547    85      . 
    djnz $+1                   ;8548    10 ff   . . 
    rst 38h                    ;854a    ff      . 
    ex af,af'                  ;854b    08      . 
    push af                    ;854c    f5      . 
    add a,e                    ;854d    83      . 
    inc bc                     ;854e    03      . 
    ld d,c                     ;854f    51      Q 
    add a,l                    ;8550    85      . 
    inc bc                     ;8551    03      . 
    ld d,a                     ;8552    57      W 
    add a,l                    ;8553    85      . 
    inc bc                     ;8554    03      . 
    ld l,c                     ;8555    69      i 
    add a,l                    ;8556    85      . 
    inc c                      ;8557    0c      . 
    inc bc                     ;8558    03      . 
    nop                        ;8559    00      . 
    inc bc                     ;855a    03      . 
    ld e,l                     ;855b    5d      ] 
    add a,l                    ;855c    85      . 
    inc c                      ;855d    0c      . 
    ld b,000h                  ;855e    06 00   . . 
    inc bc                     ;8560    03      . 
    ld h,e                     ;8561    63      c 
    add a,l                    ;8562    85      . 
    inc c                      ;8563    0c      . 
    inc c                      ;8564    0c      . 
    nop                        ;8565    00      . 
    djnz $+1                   ;8566    10 ff   . . 
    rst 38h                    ;8568    ff      . 
    inc bc                     ;8569    03      . 
    inc sp                     ;856a    33      3 
    add a,l                    ;856b    85      . 
    djnz $+1                   ;856c    10 ff   . . 
    rst 38h                    ;856e    ff      . 
    inc bc                     ;856f    03      . 
    ld (hl),l                  ;8570    75      u 
    add a,l                    ;8571    85      . 
    djnz $+1                   ;8572    10 ff   . . 
    rst 38h                    ;8574    ff      . 
    inc bc                     ;8575    03      . 
    ld a,e                     ;8576    7b      { 
    add a,l                    ;8577    85      . 
    inc bc                     ;8578    03      . 
    sub e                      ;8579    93      . 
    add a,l                    ;857a    85      . 
    ex af,af'                  ;857b    08      . 
    dec de                     ;857c    1b      . 
    adc a,e                    ;857d    8b      . 
    inc bc                     ;857e    03      . 
    add a,c                    ;857f    81      . 
    add a,l                    ;8580    85      . 
    inc c                      ;8581    0c      . 
    add hl,bc                  ;8582    09      . 
    nop                        ;8583    00      . 
    inc bc                     ;8584    03      . 
    add a,a                    ;8585    87      . 
    add a,l                    ;8586    85      . 
    inc b                      ;8587    04      . 
    ld bc,00300h               ;8588    01 00 03    . . . 
    adc a,l                    ;858b    8d      . 
    add a,l                    ;858c    85      . 
    inc c                      ;858d    0c      . 
    dec d                      ;858e    15      . 
    nop                        ;858f    00      . 
    djnz $+1                   ;8590    10 ff   . . 
    rst 38h                    ;8592    ff      . 
    inc bc                     ;8593    03      . 
    sbc a,c                    ;8594    99      . 
    add a,l                    ;8595    85      . 
    djnz $+1                   ;8596    10 ff   . . 
    rst 38h                    ;8598    ff      . 
    ex af,af'                  ;8599    08      . 
    xor c                      ;859a    a9      . 
    add a,h                    ;859b    84      . 
    inc bc                     ;859c    03      . 
    sbc a,a                    ;859d    9f      . 
    add a,l                    ;859e    85      . 
    inc bc                     ;859f    03      . 
    rst 30h                    ;85a0    f7      . 
    add a,h                    ;85a1    84      . 
    inc bc                     ;85a2    03      . 
    and l                      ;85a3    a5      . 
    add a,l                    ;85a4    85      . 
    inc c                      ;85a5    0c      . 
    dec d                      ;85a6    15      . 
    nop                        ;85a7    00      . 
    inc bc                     ;85a8    03      . 
    add hl,bc                  ;85a9    09      . 
    add a,l                    ;85aa    85      . 
    ex af,af'                  ;85ab    08      . 
    or c                       ;85ac    b1      . 
    add a,l                    ;85ad    85      . 
    inc bc                     ;85ae    03      . 
    jr nz,l8537h               ;85af    20 86     . 
    inc bc                     ;85b1    03      . 
    cp d                       ;85b2    ba      . 
    add a,l                    ;85b3    85      . 

; BLOCK 'DELCL_string' (start 0x85b4 end 0x85b9)
DELCL_string_start:
    defb 044h                  ;85b4    44      D 
    defb 045h                  ;85b5    45      E 
    defb 04ch                  ;85b6    4c      L 
    defb 043h                  ;85b7    43      C 
    defb 04ch                  ;85b8    4c      L 
DELCL_string_end:
    rst 38h                    ;85b9    ff      . 
    inc bc                     ;85ba    03      . 
    ret nz                     ;85bb    c0      . 
    add a,l                    ;85bc    85      . 
    inc bc                     ;85bd    03      . 
    ld (bc),a                  ;85be    02      . 
    add a,(hl)                 ;85bf    86      . 
    inc b                      ;85c0    04      . 
    inc b                      ;85c1    04      . 
    nop                        ;85c2    00      . 
    inc bc                     ;85c3    03      . 
    add a,085h                 ;85c4    c6 85   . . 
    inc bc                     ;85c6    03      . 
    call z,00385h              ;85c7    cc 85 03    . . . 
    jp nc,00385h               ;85ca    d2 85 03    . . . 
    rst 30h                    ;85cd    f7      . 
    add a,h                    ;85ce    84      . 
    djnz $+1                   ;85cf    10 ff   . . 
    rst 38h                    ;85d1    ff      . 
    inc bc                     ;85d2    03      . 
    ret c                      ;85d3    d8      . 
    add a,l                    ;85d4    85      . 
    inc bc                     ;85d5    03      . 
    jp pe,00885h               ;85d6    ea 85 08    . . . 
    xor c                      ;85d9    a9      . 
    add a,h                    ;85da    84      . 
    inc bc                     ;85db    03      . 
    sbc a,085h                 ;85dc    de 85   . . 
    inc bc                     ;85de    03      . 
    rst 30h                    ;85df    f7      . 
    add a,h                    ;85e0    84      . 
    inc bc                     ;85e1    03      . 
    call po,00485h             ;85e2    e4 85 04    . . . 
    ld bc,00300h               ;85e5    01 00 03    . . . 
    ccf                        ;85e8    3f      ? 
    add a,l                    ;85e9    85      . 
    ex af,af'                  ;85ea    08      . 
    ld l,c                     ;85eb    69      i 
    halt                       ;85ec    76      v 
    inc bc                     ;85ed    03      . 
    ret p                      ;85ee    f0      . 
    add a,l                    ;85ef    85      . 
    inc bc                     ;85f0    03      . 
    or 085h                    ;85f1    f6 85   . . 
    djnz $+1                   ;85f3    10 ff   . . 
    rst 38h                    ;85f5    ff      . 
    ex af,af'                  ;85f6    08      . 
    xor b                      ;85f7    a8      . 
    ld a,(hl)                  ;85f8    7e      ~ 
    inc bc                     ;85f9    03      . 
    call m,00c85h              ;85fa    fc 85 0c    . . . 
    nop                        ;85fd    00      . 
    nop                        ;85fe    00      . 
    inc bc                     ;85ff    03      . 
    ccf                        ;8600    3f      ? 
    add a,l                    ;8601    85      . 
    inc bc                     ;8602    03      . 
    ex af,af'                  ;8603    08      . 
    add a,(hl)                 ;8604    86      . 
    djnz $+1                   ;8605    10 ff   . . 
    rst 38h                    ;8607    ff      . 
    inc b                      ;8608    04      . 
    ld (bc),a                  ;8609    02      . 
    nop                        ;860a    00      . 
    inc bc                     ;860b    03      . 
    ld c,086h                  ;860c    0e 86   . . 
    inc bc                     ;860e    03      . 
    ld a,a                     ;860f    7f       
    add a,h                    ;8610    84      . 
    inc bc                     ;8611    03      . 
    inc d                      ;8612    14      . 
    add a,(hl)                 ;8613    86      . 
    inc bc                     ;8614    03      . 
    ld a,(de)                  ;8615    1a      . 
    add a,(hl)                 ;8616    86      . 
    djnz $+1                   ;8617    10 ff   . . 
    rst 38h                    ;8619    ff      . 
    ex af,af'                  ;861a    08      . 
    xor b                      ;861b    a8      . 
    ld a,(hl)                  ;861c    7e      ~ 
    inc bc                     ;861d    03      . 
    ld a,a                     ;861e    7f       
    add a,h                    ;861f    84      . 
    ex af,af'                  ;8620    08      . 
    ld h,086h                  ;8621    26 86   & . 
    inc bc                     ;8623    03      . 
    ld e,(hl)                  ;8624    5e      ^ 
    add a,a                    ;8625    87      . 
    inc bc                     ;8626    03      . 
    ld l,086h                  ;8627    2e 86   . . 

; BLOCK 'LOAD_string' (start 0x8629 end 0x862d)
LOAD_string_start:
    defb 04ch                  ;8629    4c      L 
    defb 04fh                  ;862a    4f      O 
    defb 041h                  ;862b    41      A 
    defb 044h                  ;862c    44      D 
LOAD_string_end:
    rst 38h                    ;862d    ff      . 
    inc bc                     ;862e    03      . 
    inc (hl)                   ;862f    34      4 
    add a,(hl)                 ;8630    86      . 
    inc bc                     ;8631    03      . 
    ld c,h                     ;8632    4c      L 
    add a,(hl)                 ;8633    86      . 
    inc b                      ;8634    04      . 
    ld bc,00300h               ;8635    01 00 03    . . . 
    ld a,(00386h)              ;8638    3a 86 03    : . . 
    xor a                      ;863b    af      . 
    adc a,b                    ;863c    88      . 
    inc bc                     ;863d    03      . 
    ld b,b                     ;863e    40      @ 
    add a,(hl)                 ;863f    86      . 
    inc bc                     ;8640    03      . 
    ld b,(hl)                  ;8641    46      F 
    add a,(hl)                 ;8642    86      . 
    inc bc                     ;8643    03      . 
    adc a,l                    ;8644    8d      . 
    add a,(hl)                 ;8645    86      . 
    ex af,af'                  ;8646    08      . 
    ld a,(hl)                  ;8647    7e      ~ 
    sub h                      ;8648    94      . 
    inc bc                     ;8649    03      . 
    xor a                      ;864a    af      . 
    adc a,b                    ;864b    88      . 
    inc bc                     ;864c    03      . 
    ld d,d                     ;864d    52      R 
    add a,(hl)                 ;864e    86      . 
    djnz $+1                   ;864f    10 ff   . . 
    rst 38h                    ;8651    ff      . 
    inc b                      ;8652    04      . 
    ld bc,00300h               ;8653    01 00 03    . . . 
    ld e,b                     ;8656    58      X 
    add a,(hl)                 ;8657    86      . 
    inc bc                     ;8658    03      . 
    xor a                      ;8659    af      . 
    adc a,b                    ;865a    88      . 
    inc bc                     ;865b    03      . 
    sub (hl)                   ;865c    96      . 
    add a,a                    ;865d    87      . 
    inc bc                     ;865e    03      . 
    ld h,e                     ;865f    63      c 
    add a,(hl)                 ;8660    86      . 
    ld hl,(003ffh)             ;8661    2a ff 03    * . . 
    ld l,c                     ;8664    69      i 
    add a,(hl)                 ;8665    86      . 
    djnz $+1                   ;8666    10 ff   . . 
    rst 38h                    ;8668    ff      . 
    inc b                      ;8669    04      . 
    ld (bc),a                  ;866a    02      . 
    nop                        ;866b    00      . 
    inc bc                     ;866c    03      . 
    ld l,a                     ;866d    6f      o 
    add a,(hl)                 ;866e    86      . 
    inc bc                     ;866f    03      . 
    xor a                      ;8670    af      . 
    adc a,b                    ;8671    88      . 
    inc bc                     ;8672    03      . 
    ld (hl),l                  ;8673    75      u 
    add a,(hl)                 ;8674    86      . 
    inc bc                     ;8675    03      . 
    ld a,e                     ;8676    7b      { 
    add a,(hl)                 ;8677    86      . 
    inc bc                     ;8678    03      . 
    add a,c                    ;8679    81      . 
    add a,(hl)                 ;867a    86      . 
    ex af,af'                  ;867b    08      . 
    ld b,e                     ;867c    43      C 
    ld l,h                     ;867d    6c      l 
    inc bc                     ;867e    03      . 
    ld a,a                     ;867f    7f       
    add a,h                    ;8680    84      . 
    inc bc                     ;8681    03      . 
    add a,a                    ;8682    87      . 
    add a,(hl)                 ;8683    86      . 
    inc bc                     ;8684    03      . 
    adc a,l                    ;8685    8d      . 
    add a,(hl)                 ;8686    86      . 
    ex af,af'                  ;8687    08      . 
    sbc a,c                    ;8688    99      . 
    add a,(hl)                 ;8689    86      . 
    inc bc                     ;868a    03      . 
    ld a,a                     ;868b    7f       
    add a,h                    ;868c    84      . 
    inc bc                     ;868d    03      . 
    sub e                      ;868e    93      . 
    add a,(hl)                 ;868f    86      . 
    djnz $+1                   ;8690    10 ff   . . 
    rst 38h                    ;8692    ff      . 
    ex af,af'                  ;8693    08      . 
    ld e,(hl)                  ;8694    5e      ^ 
    add a,(hl)                 ;8695    86      . 
    inc bc                     ;8696    03      . 
l8697h:
    xor a                      ;8697    af      . 
    adc a,b                    ;8698    88      . 
    inc bc                     ;8699    03      . 
    sbc a,(hl)                 ;869a    9e      . 
    add a,(hl)                 ;869b    86      . 
    ld hl,(003ffh)             ;869c    2a ff 03    * . . 
    and h                      ;869f    a4      . 
    add a,(hl)                 ;86a0    86      . 
    inc bc                     ;86a1    03      . 
    jp nz,00486h               ;86a2    c2 86 04    . . . 
    ld bc,00300h               ;86a5    01 00 03    . . . 
    xor d                      ;86a8    aa      . 
    add a,(hl)                 ;86a9    86      . 
    inc bc                     ;86aa    03      . 
    or b                       ;86ab    b0      . 
l86ach:
    add a,(hl)                 ;86ac    86      . 
    inc bc                     ;86ad    03      . 
    cp h                       ;86ae    bc      . 
    add a,(hl)                 ;86af    86      . 
    inc c                      ;86b0    0c      . 
    nop                        ;86b1    00      . 
    nop                        ;86b2    00      . 
    inc bc                     ;86b3    03      . 
    or (hl)                    ;86b4    b6      . 
    add a,(hl)                 ;86b5    86      . 
    ex af,af'                  ;86b6    08      . 
    dec c                      ;86b7    0d      . 
    ld a,b                     ;86b8    78      x 
    djnz $+1                   ;86b9    10 ff   . . 
    rst 38h                    ;86bb    ff      . 
    ex af,af'                  ;86bc    08      . 
    ld l,c                     ;86bd    69      i 
    halt                       ;86be    76      v 
    inc bc                     ;86bf    03      . 
    or (hl)                    ;86c0    b6      . 
    add a,(hl)                 ;86c1    86      . 
    inc bc                     ;86c2    03      . 
    ret z                      ;86c3    c8      . 
    add a,(hl)                 ;86c4    86      . 
    inc bc                     ;86c5    03      . 
    call pe,00486h             ;86c6    ec 86 04    . . . 
    ld (bc),a                  ;86c9    02      . 
    nop                        ;86ca    00      . 
    inc bc                     ;86cb    03      . 
    adc a,086h                 ;86cc    ce 86   . . 
    inc bc                     ;86ce    03      . 
    call nc,00386h             ;86cf    d4 86 03    . . . 
    ret po                     ;86d2    e0      . 
    add a,(hl)                 ;86d3    86      . 
    ex af,af'                  ;86d4    08      . 
    nop                        ;86d5    00      . 
    nop                        ;86d6    00      . 
    inc bc                     ;86d7    03      . 
    jp c,00886h                ;86d8    da 86 08    . . . 
    rla                        ;86db    17      . 
    adc a,b                    ;86dc    88      . 
    djnz $+1                   ;86dd    10 ff   . . 
    rst 38h                    ;86df    ff      . 
    ex af,af'                  ;86e0    08      . 
    ld l,c                     ;86e1    69      i 
    halt                       ;86e2    76      v 
    inc bc                     ;86e3    03      . 
    and 086h                   ;86e4    e6 86   . . 
    inc bc                     ;86e6    03      . 
    ld a,e                     ;86e7    7b      { 
    add a,(hl)                 ;86e8    86      . 
    inc bc                     ;86e9    03      . 
    ld h,c                     ;86ea    61      a 
    adc a,d                    ;86eb    8a      . 
    inc bc                     ;86ec    03      . 
    jp p,00386h                ;86ed    f2 86 03    . . . 
    ld b,(hl)                  ;86f0    46      F 
    add a,a                    ;86f1    87      . 
    inc b                      ;86f2    04      . 
    inc b                      ;86f3    04      . 
    nop                        ;86f4    00      . 
    inc bc                     ;86f5    03      . 
    ret m                      ;86f6    f8      . 
    add a,(hl)                 ;86f7    86      . 
    inc bc                     ;86f8    03      . 
    ld a,a                     ;86f9    7f       
    add a,h                    ;86fa    84      . 
    inc bc                     ;86fb    03      . 
    cp 086h                    ;86fc    fe 86   . . 
    inc bc                     ;86fe    03      . 
    inc b                      ;86ff    04      . 
    add a,a                    ;8700    87      . 
    inc bc                     ;8701    03      . 
    ld a,(bc)                  ;8702    0a      . 
    add a,a                    ;8703    87      . 
    ex af,af'                  ;8704    08      . 
    jp c,00375h                ;8705    da 75 03    . u . 
    add a,l                    ;8708    85      . 
    add a,h                    ;8709    84      . 
    ex af,af'                  ;870a    08      . 
    ld l,c                     ;870b    69      i 
    halt                       ;870c    76      v 
    inc bc                     ;870d    03      . 
    djnz l8697h                ;870e    10 87   . . 
    inc bc                     ;8710    03      . 
    ld d,087h                  ;8711    16 87   . . 
    inc bc                     ;8713    03      . 
    ld (00887h),hl             ;8714    22 87 08    " . . 
    ld b,e                     ;8717    43      C 
    ld l,h                     ;8718    6c      l 
    inc bc                     ;8719    03      . 
    inc e                      ;871a    1c      . 
    add a,a                    ;871b    87      . 
    inc c                      ;871c    0c      . 
    nop                        ;871d    00      . 
    nop                        ;871e    00      . 
    inc bc                     ;871f    03      . 
    dec a                      ;8720    3d      = 
    add a,h                    ;8721    84      . 
    inc bc                     ;8722    03      . 
    jr z,l86ach                ;8723    28 87   ( . 
    inc bc                     ;8725    03      . 
    ld l,087h                  ;8726    2e 87   . . 
    ex af,af'                  ;8728    08      . 
    ld b,e                     ;8729    43      C 
    ld l,h                     ;872a    6c      l 
    inc bc                     ;872b    03      . 
    call m,00385h              ;872c    fc 85 03    . . . 
    inc (hl)                   ;872f    34      4 
    add a,a                    ;8730    87      . 
    djnz $+1                   ;8731    10 ff   . . 
    rst 38h                    ;8733    ff      . 
    ex af,af'                  ;8734    08      . 
    add hl,hl                  ;8735    29      ) 
    ld (hl),a                  ;8736    77      w 
    inc bc                     ;8737    03      . 
    ld a,(00c87h)              ;8738    3a 87 0c    : . . 
    inc bc                     ;873b    03      . 
    nop                        ;873c    00      . 
    inc bc                     ;873d    03      . 
    ld b,b                     ;873e    40      @ 
    add a,a                    ;873f    87      . 
    inc c                      ;8740    0c      . 
    ld b,000h                  ;8741    06 00   . . 
    inc bc                     ;8743    03      . 
    ccf                        ;8744    3f      ? 
    add a,l                    ;8745    85      . 
    inc bc                     ;8746    03      . 
    ld c,h                     ;8747    4c      L 
    add a,a                    ;8748    87      . 
    djnz $+1                   ;8749    10 ff   . . 
    rst 38h                    ;874b    ff      . 
    inc b                      ;874c    04      . 
    inc bc                     ;874d    03      . 
    nop                        ;874e    00      . 
    inc bc                     ;874f    03      . 
    ld d,d                     ;8750    52      R 
    add a,a                    ;8751    87      . 
    inc bc                     ;8752    03      . 
    ld e,b                     ;8753    58      X 
    add a,a                    ;8754    87      . 
    inc bc                     ;8755    03      . 
    ex de,hl                   ;8756    eb      . 
    adc a,b                    ;8757    88      . 
    inc c                      ;8758    0c      . 
    ld b,000h                  ;8759    06 00   . . 
    inc bc                     ;875b    03      . 
    push hl                    ;875c    e5      . 
    adc a,b                    ;875d    88      . 
    ex af,af'                  ;875e    08      . 
    ld h,h                     ;875f    64      d 
    add a,a                    ;8760    87      . 
    inc bc                     ;8761    03      . 
    and d                      ;8762    a2      . 
    add a,a                    ;8763    87      . 
    inc bc                     ;8764    03      . 
    ld l,h                     ;8765    6c      l 
    add a,a                    ;8766    87      . 

; BLOCK 'SAVE_string' (start 0x8767 end 0x876b)
SAVE_string_start:
    defb 053h                  ;8767    53      S 
    defb 041h                  ;8768    41      A 
    defb 056h                  ;8769    56      V 
    defb 045h                  ;876a    45      E 
SAVE_string_end:
    rst 38h                    ;876b    ff      . 
    inc bc                     ;876c    03      . 
    ld (hl),d                  ;876d    72      r 
    add a,a                    ;876e    87      . 
    djnz $+1                   ;876f    10 ff   . . 
    rst 38h                    ;8771    ff      . 
    inc b                      ;8772    04      . 
    ld (bc),a                  ;8773    02      . 
    nop                        ;8774    00      . 
    inc bc                     ;8775    03      . 
    ld a,b                     ;8776    78      x 
    add a,a                    ;8777    87      . 
    inc bc                     ;8778    03      . 
    defb 0fdh,084h,003h        ;illegal sequence               ;8779    fd 84 03    . . . 
    ld a,(hl)                  ;877c    7e      ~ 
    add a,a                    ;877d    87      . 
    inc bc                     ;877e    03      . 
    add a,h                    ;877f    84      . 
    add a,a                    ;8780    87      . 
    inc bc                     ;8781    03      . 
    adc a,d                    ;8782    8a      . 
    add a,a                    ;8783    87      . 
    ex af,af'                  ;8784    08      . 
    adc a,094h                 ;8785    ce 94   . . 
    inc bc                     ;8787    03      . 
    xor a                      ;8788    af      . 
    adc a,b                    ;8789    88      . 
    inc bc                     ;878a    03      . 
    sub b                      ;878b    90      . 
    add a,a                    ;878c    87      . 
    inc bc                     ;878d    03      . 
    sub (hl)                   ;878e    96      . 
    add a,a                    ;878f    87      . 
    ex af,af'                  ;8790    08      . 
    ld h,e                     ;8791    63      c 
    ld l,a                     ;8792    6f      o 
    inc bc                     ;8793    03      . 
    defb 0fdh,084h,003h        ;illegal sequence               ;8794    fd 84 03    . . . 
    sbc a,h                    ;8797    9c      . 
    add a,a                    ;8798    87      . 
    djnz $+1                   ;8799    10 ff   . . 
    rst 38h                    ;879b    ff      . 
    ex af,af'                  ;879c    08      . 
    add hl,sp                  ;879d    39      9 
    sub l                      ;879e    95      . 
    inc bc                     ;879f    03      . 
    xor a                      ;87a0    af      . 
    adc a,b                    ;87a1    88      . 
    ex af,af'                  ;87a2    08      . 
    xor b                      ;87a3    a8      . 
    add a,a                    ;87a4    87      . 
    inc bc                     ;87a5    03      . 
    or b                       ;87a6    b0      . 
    add a,a                    ;87a7    87      . 
    inc bc                     ;87a8    03      . 
    cp l                       ;87a9    bd      . 
    add a,a                    ;87aa    87      . 

; BLOCK 'LIST_string' (start 0x87ab end 0x87af)
LIST_string_start:
    defb 04ch                  ;87ab    4c      L 
    defb 049h                  ;87ac    49      I 
    defb 053h                  ;87ad    53      S 
    defb 054h                  ;87ae    54      T 
LIST_string_end:
    rst 38h                    ;87af    ff      . 
l87b0h:
    ex af,af'                  ;87b0    08      . 
    or (hl)                    ;87b1    b6      . 
    add a,a                    ;87b2    87      . 
    inc bc                     ;87b3    03      . 
    ld de,01088h               ;87b4    11 88 10    . . . 
    rst 38h                    ;87b7    ff      . 
    rst 38h                    ;87b8    ff      . 

; BLOCK 'ALL_string' (start 0x87b9 end 0x87bc)
ALL_string_start:
    defb 041h                  ;87b9    41      A 
    defb 04ch                  ;87ba    4c      L 
    defb 04ch                  ;87bb    4c      L 
ALL_string_end:
    rst 38h                    ;87bc    ff      . 
    inc bc                     ;87bd    03      . 
    jp 00387h                  ;87be    c3 87 03    . . . 
    defb 0edh                  ;next byte illegal after ed                                     ;87c1    ed      . 
    add a,a                    ;87c2    87      . 
    inc b                      ;87c3    04      . 
    nop                        ;87c4    00      . 
    nop                        ;87c5    00      . 
    inc bc                     ;87c6    03      . 
    ret                        ;87c7    c9      . 
    add a,a                    ;87c8    87      . 
    inc bc                     ;87c9    03      . 
    rst 8                      ;87ca    cf      . 
    add a,a                    ;87cb    87      . 
    inc bc                     ;87cc    03      . 
    push de                    ;87cd    d5      . 
    add a,a                    ;87ce    87      . 
    ex af,af'                  ;87cf    08      . 
    or (hl)                    ;87d0    b6      . 
    add a,a                    ;87d1    87      . 
    djnz $+1                   ;87d2    10 ff   . . 
    rst 38h                    ;87d4    ff      . 
    ex af,af'                  ;87d5    08      . 
    ld l,c                     ;87d6    69      i 
    halt                       ;87d7    76      v 
    inc bc                     ;87d8    03      . 
    in a,(087h)                ;87d9    db 87   . . 
    inc bc                     ;87db    03      . 
    pop hl                     ;87dc    e1      . 
    add a,a                    ;87dd    87      . 
    djnz $+1                   ;87de    10 ff   . . 
    rst 38h                    ;87e0    ff      . 
    ex af,af'                  ;87e1    08      . 
    ld h,e                     ;87e2    63      c 
    ld l,a                     ;87e3    6f      o 
    inc bc                     ;87e4    03      . 
    rst 20h                    ;87e5    e7      . 
    add a,a                    ;87e6    87      . 
    ex af,af'                  ;87e7    08      . 
    xor e                      ;87e8    ab      . 
    ld (hl),d                  ;87e9    72      r 
    djnz $+1                   ;87ea    10 ff   . . 
    rst 38h                    ;87ec    ff      . 
    inc bc                     ;87ed    03      . 
    di                         ;87ee    f3      . 
    add a,a                    ;87ef    87      . 
    djnz $+1                   ;87f0    10 ff   . . 
    rst 38h                    ;87f2    ff      . 
    inc b                      ;87f3    04      . 
    ld bc,00300h               ;87f4    01 00 03    . . . 
    ld sp,hl                   ;87f7    f9      . 
    add a,a                    ;87f8    87      . 
    inc bc                     ;87f9    03      . 
    xor a                      ;87fa    af      . 
    adc a,b                    ;87fb    88      . 
    inc bc                     ;87fc    03      . 
    rst 38h                    ;87fd    ff      . 
    add a,a                    ;87fe    87      . 
    inc bc                     ;87ff    03      . 
    dec b                      ;8800    05      . 
    adc a,b                    ;8801    88      . 
    djnz $+1                   ;8802    10 ff   . . 
    rst 38h                    ;8804    ff      . 
    ex af,af'                  ;8805    08      . 
    ld h,e                     ;8806    63      c 
    ld l,a                     ;8807    6f      o 
    inc bc                     ;8808    03      . 
    dec bc                     ;8809    0b      . 
    adc a,b                    ;880a    88      . 
    ex af,af'                  ;880b    08      . 
    xor e                      ;880c    ab      . 
    ld (hl),d                  ;880d    72      r 
    inc bc                     ;880e    03      . 
    xor a                      ;880f    af      . 
    adc a,b                    ;8810    88      . 
    ex af,af'                  ;8811    08      . 
    rla                        ;8812    17      . 
    adc a,b                    ;8813    88      . 
    inc bc                     ;8814    03      . 
    ld l,088h                  ;8815    2e 88   . . 
    inc bc                     ;8817    03      . 
    inc e                      ;8818    1c      . 
    adc a,b                    ;8819    88      . 
    ccf                        ;881a    3f      ? 
    rst 38h                    ;881b    ff      . 
    inc bc                     ;881c    03      . 
    ld (01088h),hl             ;881d    22 88 10    " . . 
    rst 38h                    ;8820    ff      . 
    rst 38h                    ;8821    ff      . 
    inc b                      ;8822    04      . 
    ld bc,00300h               ;8823    01 00 03    . . . 
    jr z,l87b0h                ;8826    28 88   ( . 
    inc bc                     ;8828    03      . 
    xor a                      ;8829    af      . 
    adc a,b                    ;882a    88      . 
    inc c                      ;882b    0c      . 
    nop                        ;882c    00      . 
    nop                        ;882d    00      . 
    ex af,af'                  ;882e    08      . 
    inc (hl)                   ;882f    34      4 
    adc a,b                    ;8830    88      . 
    inc bc                     ;8831    03      . 
    sub c                      ;8832    91      . 
    adc a,b                    ;8833    88      . 
l8834h:
    inc bc                     ;8834    03      . 
    dec a                      ;8835    3d      = 
    adc a,b                    ;8836    88      . 

; BLOCK '_SUP__string' (start 0x8837 end 0x883c)
_SUP__string_start:
    defb 03ch                  ;8837    3c      < 
    defb 053h                  ;8838    53      S 
    defb 055h                  ;8839    55      U 
    defb 050h                  ;883a    50      P 
    defb 03eh                  ;883b    3e      > 
_SUP__string_end:
    rst 38h                    ;883c    ff      . 
    inc bc                     ;883d    03      . 
    ld b,e                     ;883e    43      C 
    adc a,b                    ;883f    88      . 
    djnz $+1                   ;8840    10 ff   . . 
    rst 38h                    ;8842    ff      . 
    inc b                      ;8843    04      . 
    ld (bc),a                  ;8844    02      . 
    nop                        ;8845    00      . 
    inc bc                     ;8846    03      . 
    ld c,c                     ;8847    49      I 
    adc a,b                    ;8848    88      . 
    djnz $+1                   ;8849    10 ff   . . 
    rst 38h                    ;884b    ff      . 
l884ch:
    inc bc                     ;884c    03      . 
    ld c,a                     ;884d    4f      O 
    adc a,b                    ;884e    88      . 
    inc bc                     ;884f    03      . 
    ld d,l                     ;8850    55      U 
    adc a,b                    ;8851    88      . 
    inc bc                     ;8852    03      . 
    ld e,e                     ;8853    5b      [ 
    adc a,b                    ;8854    88      . 
    ex af,af'                  ;8855    08      . 
    cp b                       ;8856    b8      . 
    halt                       ;8857    76      v 
    inc bc                     ;8858    03      . 
    add a,l                    ;8859    85      . 
    add a,h                    ;885a    84      . 
    inc bc                     ;885b    03      . 
    ld h,c                     ;885c    61      a 
    adc a,b                    ;885d    88      . 
    inc bc                     ;885e    03      . 
    ld h,a                     ;885f    67      g 
    adc a,b                    ;8860    88      . 
    ex af,af'                  ;8861    08      . 
    halt                       ;8862    76      v 
    adc a,c                    ;8863    89      . 
    inc bc                     ;8864    03      . 
    add a,l                    ;8865    85      . 
    add a,h                    ;8866    84      . 
    inc bc                     ;8867    03      . 
    ld l,l                     ;8868    6d      m 
    adc a,b                    ;8869    88      . 
    inc bc                     ;886a    03      . 
    ld (hl),e                  ;886b    73      s 
    adc a,b                    ;886c    88      . 
    ex af,af'                  ;886d    08      . 
    ld b,a                     ;886e    47      G 
    adc a,c                    ;886f    89      . 
    inc bc                     ;8870    03      . 
    xor a                      ;8871    af      . 
    adc a,b                    ;8872    88      . 
    inc bc                     ;8873    03      . 
    ld a,c                     ;8874    79      y 
    adc a,b                    ;8875    88      . 
    inc bc                     ;8876    03      . 
    ld a,a                     ;8877    7f       
    adc a,b                    ;8878    88      . 
    ex af,af'                  ;8879    08      . 
    sub a                      ;887a    97      . 
    adc a,b                    ;887b    88      . 
    inc bc                     ;887c    03      . 
    xor a                      ;887d    af      . 
    adc a,b                    ;887e    88      . 
    ex af,af'                  ;887f    08      . 
    ld l,c                     ;8880    69      i 
    halt                       ;8881    76      v 
    inc bc                     ;8882    03      . 
    add a,l                    ;8883    85      . 
    adc a,b                    ;8884    88      . 
    inc bc                     ;8885    03      . 
    adc a,e                    ;8886    8b      . 
    adc a,b                    ;8887    88      . 
    djnz $+1                   ;8888    10 ff   . . 
    rst 38h                    ;888a    ff      . 
    ex af,af'                  ;888b    08      . 
    inc (hl)                   ;888c    34      4 
    adc a,b                    ;888d    88      . 
    djnz $+1                   ;888e    10 ff   . . 
    rst 38h                    ;8890    ff      . 
    ex af,af'                  ;8891    08      . 
    sub a                      ;8892    97      . 
    adc a,b                    ;8893    88      . 
    inc bc                     ;8894    03      . 
    dec de                     ;8895    1b      . 
    adc a,c                    ;8896    89      . 
    inc bc                     ;8897    03      . 
    sbc a,l                    ;8898    9d      . 
    adc a,b                    ;8899    88      . 
    inc a                      ;889a    3c      < 
    ld a,0ffh                  ;889b    3e ff   > . 
    inc bc                     ;889d    03      . 
    and e                      ;889e    a3      . 
    adc a,b                    ;889f    88      . 
    inc bc                     ;88a0    03      . 
    out (088h),a               ;88a1    d3 88   . . 
    inc b                      ;88a3    04      . 
    ld (bc),a                  ;88a4    02      . 
    nop                        ;88a5    00      . 
    inc bc                     ;88a6    03      . 
    xor c                      ;88a7    a9      . 
    adc a,b                    ;88a8    88      . 
    inc bc                     ;88a9    03      . 
    xor a                      ;88aa    af      . 
    adc a,b                    ;88ab    88      . 
    inc bc                     ;88ac    03      . 
    or l                       ;88ad    b5      . 
    adc a,b                    ;88ae    88      . 
    inc c                      ;88af    0c      . 
    nop                        ;88b0    00      . 
    nop                        ;88b1    00      . 
    djnz $+1                   ;88b2    10 ff   . . 
    rst 38h                    ;88b4    ff      . 
    inc bc                     ;88b5    03      . 
    cp e                       ;88b6    bb      . 
    adc a,b                    ;88b7    88      . 
    inc bc                     ;88b8    03      . 
    pop bc                     ;88b9    c1      . 
    adc a,b                    ;88ba    88      . 
    ex af,af'                  ;88bb    08      . 
    jp c,00375h                ;88bc    da 75 03    . u . 
    xor a                      ;88bf    af      . 
    adc a,b                    ;88c0    88      . 
    inc bc                     ;88c1    03      . 
    rst 0                      ;88c2    c7      . 
    adc a,b                    ;88c3    88      . 
    inc bc                     ;88c4    03      . 
    call 00888h                ;88c5    cd 88 08    . . . 
    ld b,a                     ;88c8    47      G 
    adc a,c                    ;88c9    89      . 
    inc bc                     ;88ca    03      . 
    add a,l                    ;88cb    85      . 
    add a,h                    ;88cc    84      . 
    inc bc                     ;88cd    03      . 
    ld a,a                     ;88ce    7f       
    add a,h                    ;88cf    84      . 
    djnz $+1                   ;88d0    10 ff   . . 
    rst 38h                    ;88d2    ff      . 
    inc bc                     ;88d3    03      . 
    exx                        ;88d4    d9      . 
    adc a,b                    ;88d5    88      . 
    inc bc                     ;88d6    03      . 
    rst 30h                    ;88d7    f7      . 
    adc a,b                    ;88d8    88      . 
    inc b                      ;88d9    04      . 
    ld (bc),a                  ;88da    02      . 
    nop                        ;88db    00      . 
    inc bc                     ;88dc    03      . 
    rst 18h                    ;88dd    df      . 
    adc a,b                    ;88de    88      . 
    inc bc                     ;88df    03      . 
    push hl                    ;88e0    e5      . 
    adc a,b                    ;88e1    88      . 
    inc bc                     ;88e2    03      . 
    ex de,hl                   ;88e3    eb      . 
    adc a,b                    ;88e4    88      . 
    inc bc                     ;88e5    03      . 
    defb 0fdh,084h,010h        ;illegal sequence               ;88e6    fd 84 10    . . . 
    rst 38h                    ;88e9    ff      . 
    rst 38h                    ;88ea    ff      . 
    inc bc                     ;88eb    03      . 
    pop af                     ;88ec    f1      . 
    adc a,b                    ;88ed    88      . 
    djnz $+1                   ;88ee    10 ff   . . 
    rst 38h                    ;88f0    ff      . 
    ex af,af'                  ;88f1    08      . 
    add hl,hl                  ;88f2    29      ) 
    ld a,l                     ;88f3    7d      } 
    inc bc                     ;88f4    03      . 
    push hl                    ;88f5    e5      . 
    adc a,b                    ;88f6    88      . 
    inc bc                     ;88f7    03      . 
    defb 0fdh,088h,010h        ;illegal sequence               ;88f8    fd 88 10    . . . 
    rst 38h                    ;88fb    ff      . 
    rst 38h                    ;88fc    ff      . 
    inc b                      ;88fd    04      . 
    ld bc,00300h               ;88fe    01 00 03    . . . 
    inc bc                     ;8901    03      . 
    adc a,c                    ;8902    89      . 
    inc bc                     ;8903    03      . 
    xor a                      ;8904    af      . 
    adc a,b                    ;8905    88      . 
    inc bc                     ;8906    03      . 
    add hl,bc                  ;8907    09      . 
    adc a,c                    ;8908    89      . 
    inc bc                     ;8909    03      . 
    rrca                       ;890a    0f      . 
    adc a,c                    ;890b    89      . 
    djnz $+1                   ;890c    10 ff   . . 
    rst 38h                    ;890e    ff      . 
    ex af,af'                  ;890f    08      . 
    sbc a,a                    ;8910    9f      . 
    adc a,c                    ;8911    89      . 
    inc bc                     ;8912    03      . 
    dec d                      ;8913    15      . 
    adc a,c                    ;8914    89      . 
    ex af,af'                  ;8915    08      . 
    rla                        ;8916    17      . 
    adc a,b                    ;8917    88      . 
    djnz $+1                   ;8918    10 ff   . . 
    rst 38h                    ;891a    ff      . 
    ex af,af'                  ;891b    08      . 
    ld hl,00389h               ;891c    21 89 03    ! . . 
    ld b,c                     ;891f    41      A 
    adc a,c                    ;8920    89      . 
    inc bc                     ;8921    03      . 
    add hl,hl                  ;8922    29      ) 
    adc a,c                    ;8923    89      . 

; BLOCK 'DICT_string' (start 0x8924 end 0x8928)
DICT_string_start:
    defb 044h                  ;8924    44      D 
    defb 049h                  ;8925    49      I 
    defb 043h                  ;8926    43      C 
    defb 054h                  ;8927    54      T 
DICT_string_end:
    rst 38h                    ;8928    ff      . 
    inc bc                     ;8929    03      . 
    cpl                        ;892a    2f      / 
    adc a,c                    ;892b    89      . 
    djnz $+1                   ;892c    10 ff   . . 
    rst 38h                    ;892e    ff      . 
    inc b                      ;892f    04      . 
    nop                        ;8930    00      . 
    nop                        ;8931    00      . 
    inc bc                     ;8932    03      . 
    dec (hl)                   ;8933    35      5 
    adc a,c                    ;8934    89      . 
    inc bc                     ;8935    03      . 
    adc a,l                    ;8936    8d      . 
    sbc a,d                    ;8937    9a      . 
    djnz $+1                   ;8938    10 ff   . . 
    rst 38h                    ;893a    ff      . 
    djnz $+1                   ;893b    10 ff   . . 
    rst 38h                    ;893d    ff      . 
    inc bc                     ;893e    03      . 
    sub e                      ;893f    93      . 
    sbc a,d                    ;8940    9a      . 
    ex af,af'                  ;8941    08      . 
    ld b,a                     ;8942    47      G 
    adc a,c                    ;8943    89      . 
    inc bc                     ;8944    03      . 
    ld (hl),b                  ;8945    70      p 
    adc a,c                    ;8946    89      . 
    inc bc                     ;8947    03      . 
    ld c,h                     ;8948    4c      L 
    adc a,c                    ;8949    89      . 
    ld d,d                     ;894a    52      R 
    rst 38h                    ;894b    ff      . 
    inc bc                     ;894c    03      . 
    ld d,d                     ;894d    52      R 
    adc a,c                    ;894e    89      . 
    djnz $+1                   ;894f    10 ff   . . 
    rst 38h                    ;8951    ff      . 
    inc b                      ;8952    04      . 
    ld bc,00300h               ;8953    01 00 03    . . . 
    ld e,b                     ;8956    58      X 
    adc a,c                    ;8957    89      . 
    inc bc                     ;8958    03      . 
    xor a                      ;8959    af      . 
    adc a,b                    ;895a    88      . 
    inc bc                     ;895b    03      . 
    ld e,(hl)                  ;895c    5e      ^ 
    adc a,c                    ;895d    89      . 
    inc bc                     ;895e    03      . 
    ld h,h                     ;895f    64      d 
    adc a,c                    ;8960    89      . 
    djnz $+1                   ;8961    10 ff   . . 
    rst 38h                    ;8963    ff      . 
    ex af,af'                  ;8964    08      . 
    ld b,e                     ;8965    43      C 
    ld l,h                     ;8966    6c      l 
    inc bc                     ;8967    03      . 
    ld l,d                     ;8968    6a      j 
    adc a,c                    ;8969    89      . 
    ex af,af'                  ;896a    08      . 
    xor e                      ;896b    ab      . 
    ld (hl),d                  ;896c    72      r 
    inc bc                     ;896d    03      . 
    xor a                      ;896e    af      . 
    adc a,b                    ;896f    88      . 
    ex af,af'                  ;8970    08      . 
    halt                       ;8971    76      v 
    adc a,c                    ;8972    89      . 
    inc bc                     ;8973    03      . 
    sbc a,c                    ;8974    99      . 
    adc a,c                    ;8975    89      . 
    inc bc                     ;8976    03      . 
    ld a,e                     ;8977    7b      { 
    adc a,c                    ;8978    89      . 
    ld d,b                     ;8979    50      P 
    rst 38h                    ;897a    ff      . 
    inc bc                     ;897b    03      . 
    add a,c                    ;897c    81      . 
    adc a,c                    ;897d    89      . 
    djnz $+1                   ;897e    10 ff   . . 
    rst 38h                    ;8980    ff      . 
    inc b                      ;8981    04      . 
    ld bc,00300h               ;8982    01 00 03    . . . 
    add a,a                    ;8985    87      . 
    adc a,c                    ;8986    89      . 
    inc c                      ;8987    0c      . 
    nop                        ;8988    00      . 
    nop                        ;8989    00      . 
    inc bc                     ;898a    03      . 
    adc a,l                    ;898b    8d      . 
    adc a,c                    ;898c    89      . 
    inc bc                     ;898d    03      . 
    sub e                      ;898e    93      . 
    adc a,c                    ;898f    89      . 
    djnz $+1                   ;8990    10 ff   . . 
    rst 38h                    ;8992    ff      . 
    ex af,af'                  ;8993    08      . 
    sbc a,c                    ;8994    99      . 
    ld l,c                     ;8995    69      i 
    inc bc                     ;8996    03      . 
    jp 00889h                  ;8997    c3 89 08    . . . 
    sbc a,a                    ;899a    9f      . 
    adc a,c                    ;899b    89      . 
    inc bc                     ;899c    03      . 
    ret                        ;899d    c9      . 
    adc a,c                    ;899e    89      . 
    inc bc                     ;899f    03      . 
    and l                      ;89a0    a5      . 
    adc a,c                    ;89a1    89      . 
    ld d,b                     ;89a2    50      P 
    ld d,b                     ;89a3    50      P 
    rst 38h                    ;89a4    ff      . 
    inc bc                     ;89a5    03      . 
    xor e                      ;89a6    ab      . 
    adc a,c                    ;89a7    89      . 
    djnz $+1                   ;89a8    10 ff   . . 
    rst 38h                    ;89aa    ff      . 
    inc b                      ;89ab    04      . 
    ld bc,00300h               ;89ac    01 00 03    . . . 
    or c                       ;89af    b1      . 
    adc a,c                    ;89b0    89      . 
    inc c                      ;89b1    0c      . 
    nop                        ;89b2    00      . 
    nop                        ;89b3    00      . 
    inc bc                     ;89b4    03      . 
    or a                       ;89b5    b7      . 
    adc a,c                    ;89b6    89      . 
    inc bc                     ;89b7    03      . 
    cp l                       ;89b8    bd      . 
    adc a,c                    ;89b9    89      . 
    djnz $+1                   ;89ba    10 ff   . . 
    rst 38h                    ;89bc    ff      . 
    ex af,af'                  ;89bd    08      . 
    push bc                    ;89be    c5      . 
    ld l,c                     ;89bf    69      i 
    inc bc                     ;89c0    03      . 
    jp 00889h                  ;89c1    c3 89 08    . . . 
    xor e                      ;89c4    ab      . 
    ld (hl),d                  ;89c5    72      r 
    inc bc                     ;89c6    03      . 
    xor a                      ;89c7    af      . 
    adc a,b                    ;89c8    88      . 
    ex af,af'                  ;89c9    08      . 
    rst 8                      ;89ca    cf      . 
    adc a,c                    ;89cb    89      . 
    inc bc                     ;89cc    03      . 
    inc b                      ;89cd    04      . 
    adc a,d                    ;89ce    8a      . 
    inc bc                     ;89cf    03      . 
    call nc,02189h             ;89d0    d4 89 21    . . ! 
    rst 38h                    ;89d3    ff      . 
    inc bc                     ;89d4    03      . 
    jp c,01089h                ;89d5    da 89 10    . . . 
    rst 38h                    ;89d8    ff      . 
    rst 38h                    ;89d9    ff      . 
    inc b                      ;89da    04      . 
    ld bc,00300h               ;89db    01 00 03    . . . 
    ret po                     ;89de    e0      . 
    adc a,c                    ;89df    89      . 
    inc c                      ;89e0    0c      . 
    nop                        ;89e1    00      . 
    nop                        ;89e2    00      . 
    inc bc                     ;89e3    03      . 
    and 089h                   ;89e4    e6 89   . . 
    inc c                      ;89e6    0c      . 
    nop                        ;89e7    00      . 
    nop                        ;89e8    00      . 
    inc bc                     ;89e9    03      . 
    call pe,00889h             ;89ea    ec 89 08    . . . 
    ld l,c                     ;89ed    69      i 
    halt                       ;89ee    76      v 
    djnz $+1                   ;89ef    10 ff   . . 
    rst 38h                    ;89f1    ff      . 
    inc c                      ;89f2    0c      . 
    add hl,bc                  ;89f3    09      . 
    nop                        ;89f4    00      . 
    inc bc                     ;89f5    03      . 
    ret m                      ;89f6    f8      . 
    adc a,c                    ;89f7    89      . 
    inc c                      ;89f8    0c      . 
    inc c                      ;89f9    0c      . 
    nop                        ;89fa    00      . 
    inc bc                     ;89fb    03      . 
    cp 089h                    ;89fc    fe 89   . . 
    inc c                      ;89fe    0c      . 
    rrca                       ;89ff    0f      . 
    nop                        ;8a00    00      . 
    inc c                      ;8a01    0c      . 
    ld (de),a                  ;8a02    12      . 
    nop                        ;8a03    00      . 
    ex af,af'                  ;8a04    08      . 
    ld a,(bc)                  ;8a05    0a      . 
    adc a,d                    ;8a06    8a      . 
    inc bc                     ;8a07    03      . 
    sbc a,l                    ;8a08    9d      . 
    adc a,d                    ;8a09    8a      . 
    inc bc                     ;8a0a    03      . 
    inc de                     ;8a0b    13      . 
    adc a,d                    ;8a0c    8a      . 

; BLOCK 'ISALL_string' (start 0x8a0d end 0x8a12)
ISALL_string_start:
    defb 049h                  ;8a0d    49      I 
    defb 053h                  ;8a0e    53      S 
    defb 041h                  ;8a0f    41      A 
    defb 04ch                  ;8a10    4c      L 
    defb 04ch                  ;8a11    4c      L 
ISALL_string_end:
    rst 38h                    ;8a12    ff      . 
    inc bc                     ;8a13    03      . 
    add hl,de                  ;8a14    19      . 
    adc a,d                    ;8a15    8a      . 
    djnz $+1                   ;8a16    10 ff   . . 
    rst 38h                    ;8a18    ff      . 
    inc b                      ;8a19    04      . 
    inc b                      ;8a1a    04      . 
    nop                        ;8a1b    00      . 
    inc bc                     ;8a1c    03      . 
    rra                        ;8a1d    1f      . 
    adc a,d                    ;8a1e    8a      . 
    inc bc                     ;8a1f    03      . 
    dec h                      ;8a20    25      % 
    adc a,d                    ;8a21    8a      . 
    inc bc                     ;8a22    03      . 
    ld sp,00c8ah               ;8a23    31 8a 0c    1 . . 
    ld b,000h                  ;8a26    06 00   . . 
    inc bc                     ;8a28    03      . 
    dec hl                     ;8a29    2b      + 
    adc a,d                    ;8a2a    8a      . 
    inc c                      ;8a2b    0c      . 
    nop                        ;8a2c    00      . 
    nop                        ;8a2d    00      . 
    inc c                      ;8a2e    0c      . 
    inc bc                     ;8a2f    03      . 
    nop                        ;8a30    00      . 
    inc bc                     ;8a31    03      . 
    scf                        ;8a32    37      7 
    adc a,d                    ;8a33    8a      . 
    djnz $+1                   ;8a34    10 ff   . . 
    rst 38h                    ;8a36    ff      . 
    ex af,af'                  ;8a37    08      . 
    ld h,a                     ;8a38    67      g 
    add a,h                    ;8a39    84      . 
    inc bc                     ;8a3a    03      . 
    dec a                      ;8a3b    3d      = 
    adc a,d                    ;8a3c    8a      . 
    inc bc                     ;8a3d    03      . 
    ld c,c                     ;8a3e    49      I 
    adc a,d                    ;8a3f    8a      . 
    inc bc                     ;8a40    03      . 
    ld b,e                     ;8a41    43      C 
    adc a,d                    ;8a42    8a      . 
    inc bc                     ;8a43    03      . 
    add a,l                    ;8a44    85      . 
    adc a,d                    ;8a45    8a      . 
    djnz $+1                   ;8a46    10 ff   . . 
    rst 38h                    ;8a48    ff      . 
    inc bc                     ;8a49    03      . 
    ld c,a                     ;8a4a    4f      O 
    adc a,d                    ;8a4b    8a      . 
    inc bc                     ;8a4c    03      . 
    ld e,e                     ;8a4d    5b      [ 
    adc a,d                    ;8a4e    8a      . 
    ex af,af'                  ;8a4f    08      . 
    ld de,00379h               ;8a50    11 79 03    . y . 
    ld d,l                     ;8a53    55      U 
    adc a,d                    ;8a54    8a      . 
    inc c                      ;8a55    0c      . 
    add hl,bc                  ;8a56    09      . 
    nop                        ;8a57    00      . 
    inc bc                     ;8a58    03      . 
    sbc a,l                    ;8a59    9d      . 
    add a,h                    ;8a5a    84      . 
    inc bc                     ;8a5b    03      . 
    ld h,c                     ;8a5c    61      a 
    adc a,d                    ;8a5d    8a      . 
    inc bc                     ;8a5e    03      . 
    ld h,a                     ;8a5f    67      g 
    adc a,d                    ;8a60    8a      . 
    ex af,af'                  ;8a61    08      . 
    rla                        ;8a62    17      . 
    adc a,b                    ;8a63    88      . 
    inc bc                     ;8a64    03      . 
    add a,l                    ;8a65    85      . 
    add a,h                    ;8a66    84      . 
    inc bc                     ;8a67    03      . 
    ld l,l                     ;8a68    6d      m 
    adc a,d                    ;8a69    8a      . 
    inc bc                     ;8a6a    03      . 
    rst 10h                    ;8a6b    d7      . 
    add a,e                    ;8a6c    83      . 
    ex af,af'                  ;8a6d    08      . 
    ld de,00379h               ;8a6e    11 79 03    . y . 
    ld (hl),e                  ;8a71    73      s 
    adc a,d                    ;8a72    8a      . 
    inc c                      ;8a73    0c      . 
    add hl,bc                  ;8a74    09      . 
    nop                        ;8a75    00      . 
    inc bc                     ;8a76    03      . 
    ld a,c                     ;8a77    79      y 
    adc a,d                    ;8a78    8a      . 
    inc bc                     ;8a79    03      . 
    ld a,a                     ;8a7a    7f       
    adc a,d                    ;8a7b    8a      . 
    djnz $+1                   ;8a7c    10 ff   . . 
    rst 38h                    ;8a7e    ff      . 
    inc c                      ;8a7f    0c      . 
    nop                        ;8a80    00      . 
    nop                        ;8a81    00      . 
    inc c                      ;8a82    0c      . 
    add hl,bc                  ;8a83    09      . 
    nop                        ;8a84    00      . 
    inc bc                     ;8a85    03      . 
    adc a,e                    ;8a86    8b      . 
    adc a,d                    ;8a87    8a      . 
    djnz $+1                   ;8a88    10 ff   . . 
    rst 38h                    ;8a8a    ff      . 
    ex af,af'                  ;8a8b    08      . 
    push af                    ;8a8c    f5      . 
    add a,e                    ;8a8d    83      . 
    inc bc                     ;8a8e    03      . 
    sub c                      ;8a8f    91      . 
    adc a,d                    ;8a90    8a      . 
    inc c                      ;8a91    0c      . 
    ld b,000h                  ;8a92    06 00   . . 
    inc bc                     ;8a94    03      . 
    sub a                      ;8a95    97      . 
    adc a,d                    ;8a96    8a      . 
    inc c                      ;8a97    0c      . 
    add hl,bc                  ;8a98    09      . 
    nop                        ;8a99    00      . 
    djnz $+1                   ;8a9a    10 ff   . . 
    rst 38h                    ;8a9c    ff      . 
    ex af,af'                  ;8a9d    08      . 
    and e                      ;8a9e    a3      . 
    adc a,d                    ;8a9f    8a      . 
    djnz $+1                   ;8aa0    10 ff   . . 
    rst 38h                    ;8aa2    ff      . 
    inc bc                     ;8aa3    03      . 
    xor l                      ;8aa4    ad      . 
    adc a,d                    ;8aa5    8a      . 

; BLOCK 'FORALL_string' (start 0x8aa6 end 0x8aac)
FORALL_string_start:
    defb 046h                  ;8aa6    46      F 
    defb 04fh                  ;8aa7    4f      O 
    defb 052h                  ;8aa8    52      R 
    defb 041h                  ;8aa9    41      A 
    defb 04ch                  ;8aaa    4c      L 
    defb 04ch                  ;8aab    4c      L 
FORALL_string_end:
    rst 38h                    ;8aac    ff      . 
    inc bc                     ;8aad    03      . 
    or e                       ;8aae    b3      . 
    adc a,d                    ;8aaf    8a      . 
    djnz $+1                   ;8ab0    10 ff   . . 
    rst 38h                    ;8ab2    ff      . 
    inc b                      ;8ab3    04      . 
    ld (bc),a                  ;8ab4    02      . 
    nop                        ;8ab5    00      . 
    inc bc                     ;8ab6    03      . 
    cp c                       ;8ab7    b9      . 
    adc a,d                    ;8ab8    8a      . 
    inc bc                     ;8ab9    03      . 
    ld a,a                     ;8aba    7f       
    add a,h                    ;8abb    84      . 
    inc bc                     ;8abc    03      . 
    cp a                       ;8abd    bf      . 
    adc a,d                    ;8abe    8a      . 
    inc bc                     ;8abf    03      . 
    push bc                    ;8ac0    c5      . 
    adc a,d                    ;8ac1    8a      . 
    djnz $+1                   ;8ac2    10 ff   . . 
    rst 38h                    ;8ac4    ff      . 
    ex af,af'                  ;8ac5    08      . 
    or d                       ;8ac6    b2      . 
    add a,e                    ;8ac7    83      . 
    inc bc                     ;8ac8    03      . 
    res 1,d                    ;8ac9    cb 8a   . . 
    ex af,af'                  ;8acb    08      . 
    rla                        ;8acc    17      . 
    adc a,b                    ;8acd    88      . 
    inc bc                     ;8ace    03      . 
    pop de                     ;8acf    d1      . 
    adc a,d                    ;8ad0    8a      . 
    inc bc                     ;8ad1    03      . 
    rst 10h                    ;8ad2    d7      . 
    adc a,d                    ;8ad3    8a      . 
    djnz $+1                   ;8ad4    10 ff   . . 
    rst 38h                    ;8ad6    ff      . 
    inc bc                     ;8ad7    03      . 
    defb 0ddh,08ah,003h        ;illegal sequence               ;8ad8    dd 8a 03    . . . 
    ex (sp),hl                 ;8adb    e3      . 
    adc a,d                    ;8adc    8a      . 
    ex af,af'                  ;8add    08      . 
    rla                        ;8ade    17      . 
    adc a,b                    ;8adf    88      . 
    inc bc                     ;8ae0    03      . 
    xor a                      ;8ae1    af      . 
    adc a,b                    ;8ae2    88      . 
    inc bc                     ;8ae3    03      . 
    jp (hl)                    ;8ae4    e9      . 
    adc a,d                    ;8ae5    8a      . 
    djnz $+1                   ;8ae6    10 ff   . . 
    rst 38h                    ;8ae8    ff      . 
    ex af,af'                  ;8ae9    08      . 
    or d                       ;8aea    b2      . 
    add a,e                    ;8aeb    83      . 
    inc bc                     ;8aec    03      . 
    ld h,c                     ;8aed    61      a 
    adc a,d                    ;8aee    8a      . 
l8aefh:
    inc bc                     ;8aef    03      . 
    jp p,0038ah                ;8af0    f2 8a 03    . . . 
    ret m                      ;8af3    f8      . 
    adc a,d                    ;8af4    8a      . 
    djnz $+1                   ;8af5    10 ff   . . 
    rst 38h                    ;8af7    ff      . 
    inc b                      ;8af8    04      . 
    ld (bc),a                  ;8af9    02      . 
    nop                        ;8afa    00      . 
    inc bc                     ;8afb    03      . 
    cp 08ah                    ;8afc    fe 8a   . . 
    inc c                      ;8afe    0c      . 
    inc bc                     ;8aff    03      . 
    nop                        ;8b00    00      . 
    inc bc                     ;8b01    03      . 
    inc b                      ;8b02    04      . 
    adc a,e                    ;8b03    8b      . 
    inc bc                     ;8b04    03      . 
    add hl,de                  ;8b05    19      . 
    sbc a,e                    ;8b06    9b      . 
    djnz $+1                   ;8b07    10 ff   . . 
    rst 38h                    ;8b09    ff      . 
l8b0ah:
    ex af,af'                  ;8b0a    08      . 
    nop                        ;8b0b    00      . 
    nop                        ;8b0c    00      . 
    inc bc                     ;8b0d    03      . 
    ld a,a                     ;8b0e    7f       
    add a,h                    ;8b0f    84      . 
l8b10h:
    rlca                       ;8b10    07      . 
    dec sp                     ;8b11    3b                     ; 
    adc a,c                    ;8b12    89      . 
    ld h,0ffh                  ;8b13    26 ff   & . 
    ex af,af'                  ;8b15    08      . 
    dec de                     ;8b16    1b      . 
    adc a,e                    ;8b17    8b      . 
    inc bc                     ;8b18    03      . 
    ret nc                     ;8b19    d0      . 
    adc a,e                    ;8b1a    8b      . 
    inc b                      ;8b1b    04      . 
    defb 022h,08bh             ;8b1c    22 8b   " . 

; BLOCK 'SUM_string' (start 0x8b1e end 0x8b21)
SUM_string_start:
    defb 053h                  ;8b1e    53      S 
    defb 055h                  ;8b1f    55      U 
    defb 04dh                  ;8b20    4d      M 
SUM_string_end:
    rst 38h                    ;8b21    ff      . 
    ld ix,l8b29h               ;8b22    dd 21 29 8b     . ! ) . 
    jp l65f7h                  ;8b26    c3 f7 65    . . e 
l8b29h:
    rst 38h                    ;8b29    ff      . 
    dec b                      ;8b2a    05      . 
    rst 38h                    ;8b2b    ff      . 
    rst 38h                    ;8b2c    ff      . 
    inc hl                     ;8b2d    23      # 
    rst 38h                    ;8b2e    ff      . 
    dec b                      ;8b2f    05      . 
    rst 38h                    ;8b30    ff      . 
    rst 38h                    ;8b31    ff      . 
    inc d                      ;8b32    14      . 
    rst 38h                    ;8b33    ff      . 
    dec b                      ;8b34    05      . 
    rst 38h                    ;8b35    ff      . 
    rst 38h                    ;8b36    ff      . 
    ld a,(bc)                  ;8b37    0a      . 
    inc hl                     ;8b38    23      # 
    rst 38h                    ;8b39    ff      . 
    rst 38h                    ;8b3a    ff      . 
    rst 38h                    ;8b3b    ff      . 
    rst 38h                    ;8b3c    ff      . 
    ld b,d                     ;8b3d    42      B 
    rst 38h                    ;8b3e    ff      . 
    rst 38h                    ;8b3f    ff      . 
    rst 38h                    ;8b40    ff      . 
    rst 38h                    ;8b41    ff      . 
    rst 38h                    ;8b42    ff      . 
    dec b                      ;8b43    05      . 
    rst 38h                    ;8b44    ff      . 
    rst 38h                    ;8b45    ff      . 
    rst 38h                    ;8b46    ff      . 
    ld l,l                     ;8b47    6d      m 
    rst 38h                    ;8b48    ff      . 
    rst 38h                    ;8b49    ff      . 
    rst 38h                    ;8b4a    ff      . 
    rst 38h                    ;8b4b    ff      . 
    rst 38h                    ;8b4c    ff      . 
    dec b                      ;8b4d    05      . 
    rst 38h                    ;8b4e    ff      . 
    rst 38h                    ;8b4f    ff      . 
    rst 38h                    ;8b50    ff      . 
    rst 38h                    ;8b51    ff      . 
    dec b                      ;8b52    05      . 
    rst 38h                    ;8b53    ff      . 
    rst 38h                    ;8b54    ff      . 
    rst 38h                    ;8b55    ff      . 
    ld b,d                     ;8b56    42      B 
    rst 38h                    ;8b57    ff      . 
    rst 38h                    ;8b58    ff      . 
    rst 38h                    ;8b59    ff      . 
    rst 38h                    ;8b5a    ff      . 
    call sub_8c7bh             ;8b5b    cd 7b 8c    . { . 
    ld hl,09b47h               ;8b5e    21 47 9b    ! G . 
    ld de,09b52h               ;8b61    11 52 9b    . R . 
    ld bc,09b1fh               ;8b64    01 1f 9b    . . . 
    call sub_8ec8h             ;8b67    cd c8 8e    . . . 
    ld hl,09b1fh               ;8b6a    21 1f 9b    ! . . 
    call sub_8f75h             ;8b6d    cd 75 8f    . u . 
    ld de,09b5dh               ;8b70    11 5d 9b    . ] . 
    ld bc,09b33h               ;8b73    01 33 9b    . 3 . 
    call sub_8ec8h             ;8b76    cd c8 8e    . . . 
    ld hl,09b33h               ;8b79    21 33 9b    ! 3 . 
    jp l8f7ah                  ;8b7c    c3 7a 8f    . z . 
    call sub_8c7bh             ;8b7f    cd 7b 8c    . { . 
    ld hl,09b47h               ;8b82    21 47 9b    ! G . 
    ld de,09b52h               ;8b85    11 52 9b    . R . 
    ld bc,09b1fh               ;8b88    01 1f 9b    . . . 
    call sub_8ec8h             ;8b8b    cd c8 8e    . . . 
    call sub_8cb2h             ;8b8e    cd b2 8c    . . . 
    ld (09813h),a              ;8b91    32 13 98    2 . . 
    ld (09814h),hl             ;8b94    22 14 98    " . . 
    ret                        ;8b97    c9      . 
    call sub_8c7bh             ;8b98    cd 7b 8c    . { . 
    ld hl,09b52h               ;8b9b    21 52 9b    ! R . 
    call sub_8f75h             ;8b9e    cd 75 8f    . u . 
    ld de,09b5dh               ;8ba1    11 5d 9b    . ] . 
    ld bc,09b1fh               ;8ba4    01 1f 9b    . . . 
    call sub_8ec8h             ;8ba7    cd c8 8e    . . . 
    call sub_8cb2h             ;8baa    cd b2 8c    . . . 
    ld (09807h),a              ;8bad    32 07 98    2 . . 
    ld (09808h),hl             ;8bb0    22 08 98    " . . 
    ret                        ;8bb3    c9      . 
    call sub_8c7bh             ;8bb4    cd 7b 8c    . { . 
    ld hl,09b47h               ;8bb7    21 47 9b    ! G . 
    call sub_8f75h             ;8bba    cd 75 8f    . u . 
    ld de,09b5dh               ;8bbd    11 5d 9b    . ] . 
    ld bc,09b1fh               ;8bc0    01 1f 9b    . . . 
    call sub_8ec8h             ;8bc3    cd c8 8e    . . . 
    call sub_8cb2h             ;8bc6    cd b2 8c    . . . 
    ld (0980dh),a              ;8bc9    32 0d 98    2 . . 
    ld (0980eh),hl             ;8bcc    22 0e 98    " . . 
    ret                        ;8bcf    c9      . 
    ex af,af'                  ;8bd0    08      . 
    sub 08bh                   ;8bd1    d6 8b   . . 
    inc bc                     ;8bd3    03      . 
    ret z                      ;8bd4    c8      . 
    adc a,h                    ;8bd5    8c      . 
    inc b                      ;8bd6    04      . 
    rst 18h                    ;8bd7    df      . 
    adc a,e                    ;8bd8    8b      . 
    ld d,h                     ;8bd9    54      T 
    ld c,c                     ;8bda    49      I 
    ld c,l                     ;8bdb    4d      M 
    ld b,l                     ;8bdc    45      E 
    ld d,e                     ;8bdd    53      S 
    rst 38h                    ;8bde    ff      . 
    ld ix,l8be6h               ;8bdf    dd 21 e6 8b     . ! . . 
    jp l65f7h                  ;8be3    c3 f7 65    . . e 
l8be6h:
    rst 38h                    ;8be6    ff      . 
    dec b                      ;8be7    05      . 
    rst 38h                    ;8be8    ff      . 
    rst 38h                    ;8be9    ff      . 
    inc hl                     ;8bea    23      # 
    rst 38h                    ;8beb    ff      . 
    dec b                      ;8bec    05      . 
    rst 38h                    ;8bed    ff      . 
    rst 38h                    ;8bee    ff      . 
    inc d                      ;8bef    14      . 
    rst 38h                    ;8bf0    ff      . 
    dec b                      ;8bf1    05      . 
    rst 38h                    ;8bf2    ff      . 
    rst 38h                    ;8bf3    ff      . 
    ld a,(bc)                  ;8bf4    0a      . 
    inc hl                     ;8bf5    23      # 
    rst 38h                    ;8bf6    ff      . 
    rst 38h                    ;8bf7    ff      . 
    rst 38h                    ;8bf8    ff      . 
    rst 38h                    ;8bf9    ff      . 
    ld (hl),0ffh               ;8bfa    36 ff   6 . 
    rst 38h                    ;8bfc    ff      . 
    rst 38h                    ;8bfd    ff      . 
    rst 38h                    ;8bfe    ff      . 
    rst 38h                    ;8bff    ff      . 
    dec b                      ;8c00    05      . 
    rst 38h                    ;8c01    ff      . 
    rst 38h                    ;8c02    ff      . 
    rst 38h                    ;8c03    ff      . 
    ld e,(hl)                  ;8c04    5e      ^ 
    rst 38h                    ;8c05    ff      . 
    rst 38h                    ;8c06    ff      . 
    rst 38h                    ;8c07    ff      . 
    rst 38h                    ;8c08    ff      . 
    rst 38h                    ;8c09    ff      . 
    dec b                      ;8c0a    05      . 
    rst 38h                    ;8c0b    ff      . 
    rst 38h                    ;8c0c    ff      . 
    rst 38h                    ;8c0d    ff      . 
    rst 38h                    ;8c0e    ff      . 
    dec b                      ;8c0f    05      . 
    rst 38h                    ;8c10    ff      . 
    rst 38h                    ;8c11    ff      . 
    rst 38h                    ;8c12    ff      . 
    ld (hl),0ffh               ;8c13    36 ff   6 . 
    rst 38h                    ;8c15    ff      . 
    rst 38h                    ;8c16    ff      . 
    rst 38h                    ;8c17    ff      . 
    call sub_8c7bh             ;8c18    cd 7b 8c    . { . 
    ld hl,09b47h               ;8c1b    21 47 9b    ! G . 
    ld de,09b52h               ;8c1e    11 52 9b    . R . 
    ld bc,09b1fh               ;8c21    01 1f 9b    . . . 
    call sub_8f8ch             ;8c24    cd 8c 8f    . . . 
    ld hl,09b1fh               ;8c27    21 1f 9b    ! . . 
    ld de,09b5dh               ;8c2a    11 5d 9b    . ] . 
    jp l90abh                  ;8c2d    c3 ab 90    . . . 
    call sub_8c7bh             ;8c30    cd 7b 8c    . { . 
    ld hl,09b47h               ;8c33    21 47 9b    ! G . 
    ld de,09b52h               ;8c36    11 52 9b    . R . 
    ld bc,09b1fh               ;8c39    01 1f 9b    . . . 
    call sub_8f8ch             ;8c3c    cd 8c 8f    . . . 
    call sub_8cb2h             ;8c3f    cd b2 8c    . . . 
    ld (09813h),a              ;8c42    32 13 98    2 . . 
    ld (09814h),hl             ;8c45    22 14 98    " . . 
    ret                        ;8c48    c9      . 
    call sub_8c7bh             ;8c49    cd 7b 8c    . { . 
    ld hl,09b52h               ;8c4c    21 52 9b    ! R . 
    ld de,09b5dh               ;8c4f    11 5d 9b    . ] . 
    ld bc,09b1fh               ;8c52    01 1f 9b    . . . 
    call sub_9017h             ;8c55    cd 17 90    . . . 
    call sub_8cb2h             ;8c58    cd b2 8c    . . . 
    ld (09807h),a              ;8c5b    32 07 98    2 . . 
    ld (09808h),hl             ;8c5e    22 08 98    " . . 
    ret                        ;8c61    c9      . 
    call sub_8c7bh             ;8c62    cd 7b 8c    . { . 
    ld hl,09b47h               ;8c65    21 47 9b    ! G . 
    ld de,09b5dh               ;8c68    11 5d 9b    . ] . 
    ld bc,09b1fh               ;8c6b    01 1f 9b    . . . 
    call sub_9017h             ;8c6e    cd 17 90    . . . 
    call sub_8cb2h             ;8c71    cd b2 8c    . . . 
    ld (0980dh),a              ;8c74    32 0d 98    2 . . 
    ld (0980eh),hl             ;8c77    22 0e 98    " . . 
    ret                        ;8c7a    c9      . 
sub_8c7bh:
    ld b,003h                  ;8c7b    06 03   . . 
    ld ix,09807h               ;8c7d    dd 21 07 98     . ! . . 
    ld de,09b47h               ;8c81    11 47 9b    . G . 
l8c84h:
    ld a,(ix+005h)             ;8c84    dd 7e 05    . ~ . 
    cp 004h                    ;8c87    fe 04   . . 
    jr nz,l8ca3h               ;8c89    20 18     . 
    ld l,(ix+003h)             ;8c8b    dd 6e 03    . n . 
    ld h,(ix+004h)             ;8c8e    dd 66 04    . f . 
    call sub_911eh             ;8c91    cd 1e 91    . . . 
l8c94h:
    push de                    ;8c94    d5      . 
    ld de,00006h               ;8c95    11 06 00    . . . 
    add ix,de                  ;8c98    dd 19   . . 
    pop de                     ;8c9a    d1      . 
    ld hl,0000bh               ;8c9b    21 0b 00    ! . . 
    add hl,de                  ;8c9e    19      . 
    ex de,hl                   ;8c9f    eb      . 
    djnz l8c84h                ;8ca0    10 e2   . . 
    ret                        ;8ca2    c9      . 
l8ca3h:
    cp 00ah                    ;8ca3    fe 0a   . . 
    jr nz,l8c94h               ;8ca5    20 ed     . 
    ld l,(ix+003h)             ;8ca7    dd 6e 03    . n . 
    ld h,(ix+004h)             ;8caa    dd 66 04    . f . 
    call sub_8e3dh             ;8cad    cd 3d 8e    . = . 
    jr l8c94h                  ;8cb0    18 e2   . . 
sub_8cb2h:
    ld h,b                     ;8cb2    60      ` 
    ld l,c                     ;8cb3    69      i 
    call sub_90bch             ;8cb4    cd bc 90    . . . 
    jr nz,l8cbdh               ;8cb7    20 04     . 
    ex de,hl                   ;8cb9    eb      . 
    ld a,004h                  ;8cba    3e 04   > . 
    ret                        ;8cbc    c9      . 
l8cbdh:
    ex de,hl                   ;8cbd    eb      . 
    call sub_6593h             ;8cbe    cd 93 65    . . e 
    call sub_8e63h             ;8cc1    cd 63 8e    . c . 
    ld a,00ah                  ;8cc4    3e 0a   > . 
    cp a                       ;8cc6    bf      . 
    ret                        ;8cc7    c9      . 
    ex af,af'                  ;8cc8    08      . 
    adc a,08ch                 ;8cc9    ce 8c   . . 
    inc bc                     ;8ccb    03      . 
    ld c,h                     ;8ccc    4c      L 
    adc a,l                    ;8ccd    8d      . 
    inc b                      ;8cce    04      . 
    sub 08ch                   ;8ccf    d6 8c   . . 

; BLOCK 'LESS_string' (start 0x8cd1 end 0x8cd5)
LESS_string_start:
    defb 04ch                  ;8cd1    4c      L 
    defb 045h                  ;8cd2    45      E 
    defb 053h                  ;8cd3    53      S 
    defb 053h                  ;8cd4    53      S 
LESS_string_end:
    rst 38h                    ;8cd5    ff      . 
    ld ix,l8cddh               ;8cd6    dd 21 dd 8c     . ! . . 
    jp l65f7h                  ;8cda    c3 f7 65    . . e 
l8cddh:
    rst 38h                    ;8cdd    ff      . 
    dec b                      ;8cde    05      . 
    rrca                       ;8cdf    0f      . 
    rst 38h                    ;8ce0    ff      . 
    rst 38h                    ;8ce1    ff      . 
    rst 38h                    ;8ce2    ff      . 
    dec b                      ;8ce3    05      . 
    rst 38h                    ;8ce4    ff      . 
    rst 38h                    ;8ce5    ff      . 
    rst 38h                    ;8ce6    ff      . 
    rrca                       ;8ce7    0f      . 
    rst 38h                    ;8ce8    ff      . 
    rst 38h                    ;8ce9    ff      . 
    rst 38h                    ;8cea    ff      . 
    rst 38h                    ;8ceb    ff      . 
    rst 38h                    ;8cec    ff      . 
    rst 38h                    ;8ced    ff      . 
    dec b                      ;8cee    05      . 
    rst 38h                    ;8cef    ff      . 
    rst 38h                    ;8cf0    ff      . 
    dec sp                     ;8cf1    3b                     ; 
    rst 38h                    ;8cf2    ff      . 
    rst 38h                    ;8cf3    ff      . 
    rst 38h                    ;8cf4    ff      . 
    rst 38h                    ;8cf5    ff      . 
    call sub_8c7bh             ;8cf6    cd 7b 8c    . { . 
    ld hl,09b47h               ;8cf9    21 47 9b    ! G . 
    call l8f7ah                ;8cfc    cd 7a 8f    . z . 
    jr nz,l8d05h               ;8cff    20 04     . 
    xor a                      ;8d01    af      . 
    ld (09b48h),a              ;8d02    32 48 9b    2 H . 
l8d05h:
    ex de,hl                   ;8d05    eb      . 
    ld hl,09b52h               ;8d06    21 52 9b    ! R . 
    call l8f7ah                ;8d09    cd 7a 8f    . z . 
    jr nz,l8d12h               ;8d0c    20 04     . 
    xor a                      ;8d0e    af      . 
    ld (09b53h),a              ;8d0f    32 53 9b    2 S . 
l8d12h:
    ld b,00ah                  ;8d12    06 0a   . . 
    ld a,(de)                  ;8d14    1a      . 
    cp (hl)                    ;8d15    be      . 
    ret m                      ;8d16    f8      . 
    jr z,l8d1bh                ;8d17    28 02   ( . 
l8d19h:
    cp a                       ;8d19    bf      . 
    ret                        ;8d1a    c9      . 
l8d1bh:
    cp 008h                    ;8d1b    fe 08   . . 
    jr z,l8d20h                ;8d1d    28 01   ( . 
    ex de,hl                   ;8d1f    eb      . 
l8d20h:
    inc de                     ;8d20    13      . 
    inc hl                     ;8d21    23      # 
    ld a,(de)                  ;8d22    1a      . 
    cp (hl)                    ;8d23    be      . 
    ret c                      ;8d24    d8      . 
    jr nz,l8d19h               ;8d25    20 f2     . 
    djnz l8d20h                ;8d27    10 f7   . . 
    or 001h                    ;8d29    f6 01   . . 
    ret                        ;8d2b    c9      . 
    ld hl,(0980ah)             ;8d2c    2a 0a 98    * . . 
    ld de,(09810h)             ;8d2f    ed 5b 10 98     . [ . . 
    inc hl                     ;8d33    23      # 
    inc hl                     ;8d34    23      # 
    inc hl                     ;8d35    23      # 
    inc de                     ;8d36    13      . 
    inc de                     ;8d37    13      . 
    inc de                     ;8d38    13      . 
l8d39h:
    ld a,(de)                  ;8d39    1a      . 
    cp (hl)                    ;8d3a    be      . 
    jr nz,l8d45h               ;8d3b    20 08     . 
    cp 0ffh                    ;8d3d    fe ff   . . 
    jr z,l8d49h                ;8d3f    28 08   ( . 
    inc hl                     ;8d41    23      # 
    inc de                     ;8d42    13      . 
    jr l8d39h                  ;8d43    18 f4   . . 
l8d45h:
    sub (hl)                   ;8d45    96      . 
    bit 7,a                    ;8d46    cb 7f   .  
    ret                        ;8d48    c9      . 
l8d49h:
    or 001h                    ;8d49    f6 01   . . 
    ret                        ;8d4b    c9      . 
    ex af,af'                  ;8d4c    08      . 
    ld d,d                     ;8d4d    52      R 
    adc a,l                    ;8d4e    8d      . 
    inc bc                     ;8d4f    03      . 
    sbc a,l                    ;8d50    9d      . 
    adc a,l                    ;8d51    8d      . 
    inc b                      ;8d52    04      . 
    ld e,d                     ;8d53    5a      Z 
    adc a,l                    ;8d54    8d      . 

; BLOCK 'SIGN_string' (start 0x8d55 end 0x8d59)
SIGN_string_start:
    defb 053h                  ;8d55    53      S 
    defb 049h                  ;8d56    49      I 
    defb 047h                  ;8d57    47      G 
    defb 04eh                  ;8d58    4e      N 
SIGN_string_end:
    rst 38h                    ;8d59    ff      . 
    ld ix,l8d61h               ;8d5a    dd 21 61 8d     . ! a . 
    jp l65f7h                  ;8d5e    c3 f7 65    . . e 
l8d61h:
    rst 38h                    ;8d61    ff      . 
    dec b                      ;8d62    05      . 
    rst 38h                    ;8d63    ff      . 
    rst 38h                    ;8d64    ff      . 
    rst 38h                    ;8d65    ff      . 
    rst 38h                    ;8d66    ff      . 
    rst 38h                    ;8d67    ff      . 
    rst 38h                    ;8d68    ff      . 
    rst 38h                    ;8d69    ff      . 
    dec b                      ;8d6a    05      . 
    dec b                      ;8d6b    05      . 
    rst 38h                    ;8d6c    ff      . 
    rst 38h                    ;8d6d    ff      . 
    rst 38h                    ;8d6e    ff      . 
    rst 38h                    ;8d6f    ff      . 
    ld a,(0980ch)              ;8d70    3a 0c 98    : . . 
    ld hl,(0980ah)             ;8d73    2a 0a 98    * . . 
    cp 004h                    ;8d76    fe 04   . . 
    jr nz,l8d87h               ;8d78    20 0d     . 
    ld a,l                     ;8d7a    7d      } 
    or a                       ;8d7b    b7      . 
    jr nz,l8d81h               ;8d7c    20 03     . 
    or h                       ;8d7e    b4      . 
    jr z,l8d93h                ;8d7f    28 12   ( . 
l8d81h:
    bit 7,h                    ;8d81    cb 7c   . | 
    jr nz,l8d8bh               ;8d83    20 06     . 
    jr l8d90h                  ;8d85    18 09   . . 
l8d87h:
    bit 3,(hl)                 ;8d87    cb 5e   . ^ 
    jr z,l8d90h                ;8d89    28 05   ( . 
l8d8bh:
    ld hl,0ffffh               ;8d8b    21 ff ff    ! . . 
    jr l8d93h                  ;8d8e    18 03   . . 
l8d90h:
    ld hl,00001h               ;8d90    21 01 00    ! . . 
l8d93h:
    ld a,004h                  ;8d93    3e 04   > . 
    ld (0980dh),a              ;8d95    32 0d 98    2 . . 
    ld (0980eh),hl             ;8d98    22 0e 98    " . . 
    cp a                       ;8d9b    bf      . 
    ret                        ;8d9c    c9      . 
    ex af,af'                  ;8d9d    08      . 
    and e                      ;8d9e    a3      . 
    adc a,l                    ;8d9f    8d      . 
    inc bc                     ;8da0    03      . 
    sub e                      ;8da1    93      . 
    ld l,c                     ;8da2    69      i 
    inc b                      ;8da3    04      . 
    xor d                      ;8da4    aa      . 
    adc a,l                    ;8da5    8d      . 

; BLOCK 'INT_string' (start 0x8da6 end 0x8da9)
INT_string_start:
    defb 049h                  ;8da6    49      I 
    defb 04eh                  ;8da7    4e      N 
    defb 054h                  ;8da8    54      T 
INT_string_end:
    rst 38h                    ;8da9    ff      . 
    ld ix,l8db1h               ;8daa    dd 21 b1 8d     . ! . . 
    jp l65f7h                  ;8dae    c3 f7 65    . . e 
l8db1h:
    rst 38h                    ;8db1    ff      . 
    dec b                      ;8db2    05      . 
    add hl,de                  ;8db3    19      . 
    add hl,de                  ;8db4    19      . 
    rrca                       ;8db5    0f      . 
    rra                        ;8db6    1f      . 
    rst 38h                    ;8db7    ff      . 
    rst 38h                    ;8db8    ff      . 
    rst 38h                    ;8db9    ff      . 
    dec b                      ;8dba    05      . 
    ld sp,0ffffh               ;8dbb    31 ff ff    1 . . 
    rst 38h                    ;8dbe    ff      . 
    rst 38h                    ;8dbf    ff      . 
    rrca                       ;8dc0    0f      . 
    dec b                      ;8dc1    05      . 
    dec b                      ;8dc2    05      . 
    dec b                      ;8dc3    05      . 
    dec b                      ;8dc4    05      . 
    dec c                      ;8dc5    0d      . 
    rst 38h                    ;8dc6    ff      . 
    rst 38h                    ;8dc7    ff      . 
    rst 38h                    ;8dc8    ff      . 
    rst 38h                    ;8dc9    ff      . 
    dec b                      ;8dca    05      . 
    rst 38h                    ;8dcb    ff      . 
    rst 38h                    ;8dcc    ff      . 
    rst 38h                    ;8dcd    ff      . 
    rst 38h                    ;8dce    ff      . 
    or 001h                    ;8dcf    f6 01   . . 
    ret                        ;8dd1    c9      . 
    jp l6290h                  ;8dd2    c3 90 62    . . b 
    ld ix,09807h               ;8dd5    dd 21 07 98     . ! . . 
sub_8dd9h:
    ld a,(ix+005h)             ;8dd9    dd 7e 05    . ~ . 
    cp 004h                    ;8ddc    fe 04   . . 
    ret z                      ;8dde    c8      . 
    ld l,(ix+003h)             ;8ddf    dd 6e 03    . n . 
    ld h,(ix+004h)             ;8de2    dd 66 04    . f . 
    inc hl                     ;8de5    23      # 
    ld a,(hl)                  ;8de6    7e      ~ 
    cp 088h                    ;8de7    fe 88   . . 
    ret c                      ;8de9    d8      . 
    cp a                       ;8dea    bf      . 
    ret                        ;8deb    c9      . 
    ld ix,09807h               ;8dec    dd 21 07 98     . ! . . 
    call sub_8e01h             ;8df0    cd 01 8e    . . . 
    ld a,(0980ch)              ;8df3    3a 0c 98    : . . 
    ld hl,(0980ah)             ;8df6    2a 0a 98    * . . 
    ld (0980dh),a              ;8df9    32 0d 98    2 . . 
    ld (0980eh),hl             ;8dfc    22 0e 98    " . . 
    cp a                       ;8dff    bf      . 
    ret                        ;8e00    c9      . 
sub_8e01h:
    call sub_8dd9h             ;8e01    cd d9 8d    . . . 
    ret z                      ;8e04    c8      . 
    ld l,(ix+003h)             ;8e05    dd 6e 03    . n . 
    ld h,(ix+004h)             ;8e08    dd 66 04    . f . 
    ld de,09b47h               ;8e0b    11 47 9b    . G . 
    call sub_8e3dh             ;8e0e    cd 3d 8e    . = . 
    ld a,(09b48h)              ;8e11    3a 48 9b    : H . 
    sub 080h                   ;8e14    d6 80   . . 
    jp p,l8e20h                ;8e16    f2 20 8e    .   . 
    ld a,004h                  ;8e19    3e 04   > . 
    ld hl,00000h               ;8e1b    21 00 00    ! . . 
    jr l8e33h                  ;8e1e    18 13   . . 
l8e20h:
    ld b,a                     ;8e20    47      G 
    ld a,008h                  ;8e21    3e 08   > . 
    sub b                      ;8e23    90      . 
    ld b,a                     ;8e24    47      G 
    ld hl,09b51h               ;8e25    21 51 9b    ! Q . 
l8e28h:
    ld (hl),000h               ;8e28    36 00   6 . 
    dec hl                     ;8e2a    2b      + 
    djnz l8e28h                ;8e2b    10 fb   . . 
    ld bc,09b47h               ;8e2d    01 47 9b    . G . 
    call sub_8cb2h             ;8e30    cd b2 8c    . . . 
l8e33h:
    ld (ix+003h),l             ;8e33    dd 75 03    . u . 
    ld (ix+004h),h             ;8e36    dd 74 04    . t . 
    ld (ix+005h),a             ;8e39    dd 77 05    . w . 
    ret                        ;8e3c    c9      . 
sub_8e3dh:
    push hl                    ;8e3d    e5      . 
    push de                    ;8e3e    d5      . 
    push bc                    ;8e3f    c5      . 
    push af                    ;8e40    f5      . 
    ld a,(hl)                  ;8e41    7e      ~ 
    ld (de),a                  ;8e42    12      . 
    inc hl                     ;8e43    23      # 
    inc de                     ;8e44    13      . 
    ld a,(hl)                  ;8e45    7e      ~ 
    ld (de),a                  ;8e46    12      . 
    inc de                     ;8e47    13      . 
    ld a,000h                  ;8e48    3e 00   > . 
    ld (de),a                  ;8e4a    12      . 
    ld b,004h                  ;8e4b    06 04   . . 
l8e4dh:
    inc de                     ;8e4d    13      . 
    inc hl                     ;8e4e    23      # 
    ld a,(hl)                  ;8e4f    7e      ~ 
    rra                        ;8e50    1f      . 
    rra                        ;8e51    1f      . 
    rra                        ;8e52    1f      . 
    rra                        ;8e53    1f      . 
    and 00fh                   ;8e54    e6 0f   . . 
    ld (de),a                  ;8e56    12      . 
    inc de                     ;8e57    13      . 
    ld a,(hl)                  ;8e58    7e      ~ 
    and 00fh                   ;8e59    e6 0f   . . 
    ld (de),a                  ;8e5b    12      . 
    djnz l8e4dh                ;8e5c    10 ef   . . 
    pop af                     ;8e5e    f1      . 
    pop bc                     ;8e5f    c1      . 
    pop de                     ;8e60    d1      . 
    pop hl                     ;8e61    e1      . 
    ret                        ;8e62    c9      . 
sub_8e63h:
    push hl                    ;8e63    e5      . 
    push de                    ;8e64    d5      . 
    push bc                    ;8e65    c5      . 
    ex de,hl                   ;8e66    eb      . 
    ldi                        ;8e67    ed a0   . . 
    ldi                        ;8e69    ed a0   . . 
    ld b,004h                  ;8e6b    06 04   . . 
l8e6dh:
    inc hl                     ;8e6d    23      # 
    ld a,(hl)                  ;8e6e    7e      ~ 
    rlca                       ;8e6f    07      . 
    rlca                       ;8e70    07      . 
    rlca                       ;8e71    07      . 
    rlca                       ;8e72    07      . 
    inc hl                     ;8e73    23      # 
    or (hl)                    ;8e74    b6      . 
    ld (de),a                  ;8e75    12      . 
    inc de                     ;8e76    13      . 
    djnz l8e6dh                ;8e77    10 f4   . . 
    pop bc                     ;8e79    c1      . 
    pop de                     ;8e7a    d1      . 
    pop hl                     ;8e7b    e1      . 
    ret                        ;8e7c    c9      . 
sub_8e7dh:
    push bc                    ;8e7d    c5      .                  (flow from: 6ebd)
    push de                    ;8e7e    d5      .                  (flow from: 8e7d)
    push hl                    ;8e7f    e5      .                  (flow from: 8e7e)
    ld b,009h                  ;8e80    06 09   . .                (flow from: 8e7f)
    inc hl                     ;8e82    23      #                  (flow from: 8e80)
    ld c,(hl)                  ;8e83    4e      N                  (flow from: 8e82)
    inc hl                     ;8e84    23      #                  (flow from: 8e83)
    ld a,(hl)                  ;8e85    7e      ~                  (flow from: 8e84)
    or a                       ;8e86    b7      .                  (flow from: 8e85)
    jr z,l8e9ch                ;8e87    28 13   ( .                (flow from: 8e86)
    inc c                      ;8e89    0c      . 
    jp z,l629fh                ;8e8a    ca 9f 62    . . b 
    push hl                    ;8e8d    e5      . 
    push bc                    ;8e8e    c5      . 
    ld bc,00010h               ;8e8f    01 10 00    . . . 
    add hl,bc                  ;8e92    09      . 
    ld d,h                     ;8e93    54      T 
    ld e,l                     ;8e94    5d      ] 
    dec hl                     ;8e95    2b      + 
    lddr                       ;8e96    ed b8   . . 
    pop bc                     ;8e98    c1      . 
    pop hl                     ;8e99    e1      . 
    xor a                      ;8e9a    af      . 
    ld (hl),a                  ;8e9b    77      w 
l8e9ch:
    inc hl                     ;8e9c    23      #                  (flow from: 8e87 8ea4)
    cp (hl)                    ;8e9d    be      .                  (flow from: 8e9c)
    jr nz,l8eb8h               ;8e9e    20 18     .                (flow from: 8e9d)
    dec b                      ;8ea0    05      .                  (flow from: 8e9e)
    jr z,l8ea9h                ;8ea1    28 06   ( .                (flow from: 8ea0)
    dec c                      ;8ea3    0d      .                  (flow from: 8ea1)
    jr nz,l8e9ch               ;8ea4    20 f6     .                (flow from: 8ea3)
    jp l629ah                  ;8ea6    c3 9a 62    . . b 
l8ea9h:
    pop hl                     ;8ea9    e1      .                  (flow from: 8ea1)
    push hl                    ;8eaa    e5      .                  (flow from: 8ea9)
    ld b,009h                  ;8eab    06 09   . .                (flow from: 8eaa)
    xor a                      ;8ead    af      .                  (flow from: 8eab)
    ld (hl),a                  ;8eae    77      w                  (flow from: 8ead)
    inc hl                     ;8eaf    23      #                  (flow from: 8eae)
    ld (hl),080h               ;8eb0    36 80   6 .                (flow from: 8eaf)
l8eb2h:
    inc hl                     ;8eb2    23      #                  (flow from: 8eb0 8eb4)
    ld (hl),a                  ;8eb3    77      w                  (flow from: 8eb2)
    djnz l8eb2h                ;8eb4    10 fc   . .                (flow from: 8eb3)
    jr l8ec4h                  ;8eb6    18 0c   . .                (flow from: 8eb4)
l8eb8h:
    pop de                     ;8eb8    d1      .                  (flow from: 8e9e)
    push de                    ;8eb9    d5      .                  (flow from: 8eb8)
    inc de                     ;8eba    13      .                  (flow from: 8eb9)
    ld a,c                     ;8ebb    79      y                  (flow from: 8eba)
    ld (de),a                  ;8ebc    12      .                  (flow from: 8ebb)
    inc de                     ;8ebd    13      .                  (flow from: 8ebc)
    inc de                     ;8ebe    13      .                  (flow from: 8ebd)
    ld bc,00008h               ;8ebf    01 08 00    . . .          (flow from: 8ebe)
    ldir                       ;8ec2    ed b0   . .                (flow from: 8ebf 8ec2)
l8ec4h:
    pop hl                     ;8ec4    e1      .                  (flow from: 8eb6 8ec2)
    pop de                     ;8ec5    d1      .                  (flow from: 8ec4)
    pop bc                     ;8ec6    c1      .                  (flow from: 8ec5)
    ret                        ;8ec7    c9      .                  (flow from: 8ec6)
sub_8ec8h:
    push hl                    ;8ec8    e5      . 
    push de                    ;8ec9    d5      . 
    push bc                    ;8eca    c5      . 
    bit 3,(hl)                 ;8ecb    cb 5e   . ^ 
    call nz,sub_8f5bh          ;8ecd    c4 5b 8f    . [ . 
    inc hl                     ;8ed0    23      # 
    ex de,hl                   ;8ed1    eb      . 
    bit 3,(hl)                 ;8ed2    cb 5e   . ^ 
    call nz,sub_8f5bh          ;8ed4    c4 5b 8f    . [ . 
    inc hl                     ;8ed7    23      # 
    ex de,hl                   ;8ed8    eb      . 
    push hl                    ;8ed9    e5      . 
    push bc                    ;8eda    c5      . 
    ld h,b                     ;8edb    60      ` 
    ld l,c                     ;8edc    69      i 
    ld b,013h                  ;8edd    06 13   . . 
    xor a                      ;8edf    af      . 
l8ee0h:
    ld (hl),a                  ;8ee0    77      w 
    inc hl                     ;8ee1    23      # 
    djnz l8ee0h                ;8ee2    10 fc   . . 
    pop bc                     ;8ee4    c1      . 
    pop hl                     ;8ee5    e1      . 
    inc bc                     ;8ee6    03      . 
    ld a,(de)                  ;8ee7    1a      . 
    cp (hl)                    ;8ee8    be      . 
    jr c,l8eech                ;8ee9    38 01   8 . 
    ex de,hl                   ;8eeb    eb      . 
l8eech:
    call l8f7ah                ;8eec    cd 7a 8f    . z . 
    jr z,l8ef2h                ;8eef    28 01   ( . 
    ex de,hl                   ;8ef1    eb      . 
l8ef2h:
    push bc                    ;8ef2    c5      . 
    push de                    ;8ef3    d5      . 
    push hl                    ;8ef4    e5      . 
    ex de,hl                   ;8ef5    eb      . 
    ld d,b                     ;8ef6    50      P 
    ld e,c                     ;8ef7    59      Y 
    ld bc,0000ah               ;8ef8    01 0a 00    . . . 
    ldir                       ;8efb    ed b0   . . 
    pop hl                     ;8efd    e1      . 
    pop de                     ;8efe    d1      . 
    pop bc                     ;8eff    c1      . 
    ld a,(de)                  ;8f00    1a      . 
    sub (hl)                   ;8f01    96      . 
    cp 00bh                    ;8f02    fe 0b   . . 
    jr nc,l8f42h               ;8f04    30 3c   0 < 
    ld de,00009h               ;8f06    11 09 00    . . . 
    add hl,de                  ;8f09    19      . 
    ex de,hl                   ;8f0a    eb      . 
    push af                    ;8f0b    f5      . 
    add a,009h                 ;8f0c    c6 09   . . 
    ld l,a                     ;8f0e    6f      o 
    add hl,bc                  ;8f0f    09      . 
    or a                       ;8f10    b7      . 
    ld b,009h                  ;8f11    06 09   . . 
l8f13h:
    ld a,(de)                  ;8f13    1a      . 
    adc a,(hl)                 ;8f14    8e      . 
    daa                        ;8f15    27      ' 
    ld c,a                     ;8f16    4f      O 
    and 00fh                   ;8f17    e6 0f   . . 
    ld (hl),a                  ;8f19    77      w 
    ld a,c                     ;8f1a    79      y 
    cp 00ah                    ;8f1b    fe 0a   . . 
    ccf                        ;8f1d    3f      ? 
    dec hl                     ;8f1e    2b      + 
    dec de                     ;8f1f    1b      . 
    djnz l8f13h                ;8f20    10 f1   . . 
    pop af                     ;8f22    f1      . 
    ld b,a                     ;8f23    47      G 
    inc de                     ;8f24    13      . 
    ld a,(de)                  ;8f25    1a      . 
    cp 005h                    ;8f26    fe 05   . . 
    jr nc,l8f2eh               ;8f28    30 04   0 . 
    ld d,000h                  ;8f2a    16 00   . . 
    jr l8f30h                  ;8f2c    18 02   . . 
l8f2eh:
    ld d,009h                  ;8f2e    16 09   . . 
l8f30h:
    xor a                      ;8f30    af      . 
    cp b                       ;8f31    b8      . 
    jr z,l8f42h                ;8f32    28 0e   ( . 
l8f34h:
    ld a,c                     ;8f34    79      y 
    cp 00ah                    ;8f35    fe 0a   . . 
    ccf                        ;8f37    3f      ? 
    ld a,(hl)                  ;8f38    7e      ~ 
    adc a,d                    ;8f39    8a      . 
    daa                        ;8f3a    27      ' 
    ld c,a                     ;8f3b    4f      O 
    and 00fh                   ;8f3c    e6 0f   . . 
    ld (hl),a                  ;8f3e    77      w 
    dec hl                     ;8f3f    2b      + 
    djnz l8f34h                ;8f40    10 f2   . . 
l8f42h:
    pop hl                     ;8f42    e1      . 
    push hl                    ;8f43    e5      . 
    inc hl                     ;8f44    23      # 
    inc hl                     ;8f45    23      # 
    ld a,(hl)                  ;8f46    7e      ~ 
    cp 005h                    ;8f47    fe 05   . . 
    jr c,l8f52h                ;8f49    38 07   8 . 
    dec hl                     ;8f4b    2b      + 
    dec hl                     ;8f4c    2b      + 
    call sub_8f5bh             ;8f4d    cd 5b 8f    . [ . 
    ld (hl),008h               ;8f50    36 08   6 . 
l8f52h:
    pop hl                     ;8f52    e1      . 
    push hl                    ;8f53    e5      . 
    call sub_8e7dh             ;8f54    cd 7d 8e    . } . 
    pop bc                     ;8f57    c1      . 
    pop de                     ;8f58    d1      . 
    pop hl                     ;8f59    e1      . 
    ret                        ;8f5a    c9      . 
sub_8f5bh:
    push hl                    ;8f5b    e5      . 
    push bc                    ;8f5c    c5      . 
    ld bc,0000ah               ;8f5d    01 0a 00    . . . 
    add hl,bc                  ;8f60    09      . 
    ld b,009h                  ;8f61    06 09   . . 
    or a                       ;8f63    b7      . 
l8f64h:
    ld a,010h                  ;8f64    3e 10   > . 
    sbc a,(hl)                 ;8f66    9e      . 
    daa                        ;8f67    27      ' 
    push af                    ;8f68    f5      . 
    and 00fh                   ;8f69    e6 0f   . . 
    ld (hl),a                  ;8f6b    77      w 
    pop af                     ;8f6c    f1      . 
    cp 00ah                    ;8f6d    fe 0a   . . 
    dec hl                     ;8f6f    2b      + 
    djnz l8f64h                ;8f70    10 f2   . . 
    pop bc                     ;8f72    c1      . 
    pop hl                     ;8f73    e1      . 
    ret                        ;8f74    c9      . 
sub_8f75h:
    ld a,(hl)                  ;8f75    7e      ~ 
    xor 008h                   ;8f76    ee 08   . . 
    ld (hl),a                  ;8f78    77      w 
    ret                        ;8f79    c9      . 
l8f7ah:
    bit 3,(hl)                 ;8f7a    cb 5e   . ^ 
    ret nz                     ;8f7c    c0      . 
    push hl                    ;8f7d    e5      . 
    push bc                    ;8f7e    c5      . 
    ld b,009h                  ;8f7f    06 09   . . 
    inc hl                     ;8f81    23      # 
l8f82h:
    inc hl                     ;8f82    23      # 
    ld a,(hl)                  ;8f83    7e      ~ 
    or a                       ;8f84    b7      . 
    jr nz,l8f89h               ;8f85    20 02     . 
    djnz l8f82h                ;8f87    10 f9   . . 
l8f89h:
    pop bc                     ;8f89    c1      . 
    pop hl                     ;8f8a    e1      . 
    ret                        ;8f8b    c9      . 
sub_8f8ch:
    push hl                    ;8f8c    e5      . 
    push de                    ;8f8d    d5      . 
    push bc                    ;8f8e    c5      . 
    push ix                    ;8f8f    dd e5   . . 
    ld a,(de)                  ;8f91    1a      . 
    xor (hl)                   ;8f92    ae      . 
    ld (bc),a                  ;8f93    02      . 
    inc hl                     ;8f94    23      # 
    inc de                     ;8f95    13      . 
    inc bc                     ;8f96    03      . 
    push bc                    ;8f97    c5      . 
    ld c,080h                  ;8f98    0e 80   . . 
    ld a,(de)                  ;8f9a    1a      . 
    sub c                      ;8f9b    91      . 
    ld b,a                     ;8f9c    47      G 
    ld a,(hl)                  ;8f9d    7e      ~ 
    sub c                      ;8f9e    91      . 
    add a,b                    ;8f9f    80      . 
    jp pe,l629fh               ;8fa0    ea 9f 62    . . b 
    add a,c                    ;8fa3    81      . 
    pop bc                     ;8fa4    c1      . 
    ld (bc),a                  ;8fa5    02      . 
    push hl                    ;8fa6    e5      . 
    ld h,b                     ;8fa7    60      ` 
    ld l,c                     ;8fa8    69      i 
    ld b,011h                  ;8fa9    06 11   . . 
l8fabh:
    inc hl                     ;8fab    23      # 
    ld (hl),000h               ;8fac    36 00   6 . 
    djnz l8fabh                ;8fae    10 fb   . . 
    push hl                    ;8fb0    e5      . 
    pop ix                     ;8fb1    dd e1   . . 
    pop hl                     ;8fb3    e1      . 
    ld bc,00009h               ;8fb4    01 09 00    . . . 
    add hl,bc                  ;8fb7    09      . 
    ex de,hl                   ;8fb8    eb      . 
    add hl,bc                  ;8fb9    09      . 
    ld b,008h                  ;8fba    06 08   . . 
l8fbch:
    push bc                    ;8fbc    c5      . 
    push ix                    ;8fbd    dd e5   . . 
    push hl                    ;8fbf    e5      . 
    ld bc,00900h               ;8fc0    01 00 09    . . . 
l8fc3h:
    push de                    ;8fc3    d5      . 
    push bc                    ;8fc4    c5      . 
    ld a,(de)                  ;8fc5    1a      . 
    ld e,a                     ;8fc6    5f      _ 
    ld d,(hl)                  ;8fc7    56      V 
    ld b,004h                  ;8fc8    06 04   . . 
    xor a                      ;8fca    af      . 
l8fcbh:
    rr d                       ;8fcb    cb 1a   . . 
    jr nc,l8fd0h               ;8fcd    30 01   0 . 
    add a,e                    ;8fcf    83      . 
l8fd0h:
    rlc e                      ;8fd0    cb 03   . . 
    djnz l8fcbh                ;8fd2    10 f7   . . 
    ld e,000h                  ;8fd4    1e 00   . . 
    ld b,00ah                  ;8fd6    06 0a   . . 
l8fd8h:
    sub b                      ;8fd8    90      . 
    jr c,l8fdeh                ;8fd9    38 03   8 . 
    inc e                      ;8fdb    1c      . 
    jr l8fd8h                  ;8fdc    18 fa   . . 
l8fdeh:
    add a,b                    ;8fde    80      . 
    rlc e                      ;8fdf    cb 03   . . 
    rlc e                      ;8fe1    cb 03   . . 
    rlc e                      ;8fe3    cb 03   . . 
    rlc e                      ;8fe5    cb 03   . . 
    or e                       ;8fe7    b3      . 
    add a,(ix+000h)            ;8fe8    dd 86 00    . . . 
    daa                        ;8feb    27      ' 
    pop bc                     ;8fec    c1      . 
    add a,c                    ;8fed    81      . 
    daa                        ;8fee    27      ' 
    push af                    ;8fef    f5      . 
    and 00fh                   ;8ff0    e6 0f   . . 
    ld (ix+000h),a             ;8ff2    dd 77 00    . w . 
    pop af                     ;8ff5    f1      . 
    rrca                       ;8ff6    0f      . 
    rrca                       ;8ff7    0f      . 
    rrca                       ;8ff8    0f      . 
    rrca                       ;8ff9    0f      . 
    and 00fh                   ;8ffa    e6 0f   . . 
    ld c,a                     ;8ffc    4f      O 
    pop de                     ;8ffd    d1      . 
    dec hl                     ;8ffe    2b      + 
    dec ix                     ;8fff    dd 2b   . + 
    djnz l8fc3h                ;9001    10 c0   . . 
    pop hl                     ;9003    e1      . 
    pop ix                     ;9004    dd e1   . . 
    pop bc                     ;9006    c1      . 
    dec de                     ;9007    1b      . 
    dec ix                     ;9008    dd 2b   . + 
    djnz l8fbch                ;900a    10 b0   . . 
    pop ix                     ;900c    dd e1   . . 
    pop hl                     ;900e    e1      . 
    push hl                    ;900f    e5      . 
    call sub_8e7dh             ;9010    cd 7d 8e    . } . 
    pop bc                     ;9013    c1      . 
    pop de                     ;9014    d1      . 
    pop hl                     ;9015    e1      . 
    ret                        ;9016    c9      . 
sub_9017h:
    call l8f7ah                ;9017    cd 7a 8f    . z . 
    jp z,l629fh                ;901a    ca 9f 62    . . b 
    push hl                    ;901d    e5      . 
    push de                    ;901e    d5      . 
    push bc                    ;901f    c5      . 
    push ix                    ;9020    dd e5   . . 
    ld a,(de)                  ;9022    1a      . 
    xor (hl)                   ;9023    ae      . 
    ld (bc),a                  ;9024    02      . 
    inc hl                     ;9025    23      # 
    inc de                     ;9026    13      . 
    inc bc                     ;9027    03      . 
    inc bc                     ;9028    03      . 
    push bc                    ;9029    c5      . 
    pop ix                     ;902a    dd e1   . . 
    ld c,080h                  ;902c    0e 80   . . 
    ld a,(hl)                  ;902e    7e      ~ 
    sub c                      ;902f    91      . 
    ld b,a                     ;9030    47      G 
    ld a,(de)                  ;9031    1a      . 
    sub c                      ;9032    91      . 
    sub b                      ;9033    90      . 
    jp pe,l629fh               ;9034    ea 9f 62    . . b 
    add a,c                    ;9037    81      . 
    ld (ix-001h),a             ;9038    dd 77 ff    . w . 
    inc hl                     ;903b    23      # 
    inc de                     ;903c    13      . 
    ex de,hl                   ;903d    eb      . 
    push de                    ;903e    d5      . 
    ld de,09b33h               ;903f    11 33 9b    . 3 . 
    ld bc,00009h               ;9042    01 09 00    . . . 
    ldir                       ;9045    ed b0   . . 
    ld b,009h                  ;9047    06 09   . . 
    xor a                      ;9049    af      . 
l904ah:
    ld (de),a                  ;904a    12      . 
    inc de                     ;904b    13      . 
    djnz l904ah                ;904c    10 fc   . . 
    pop de                     ;904e    d1      . 
    ex de,hl                   ;904f    eb      . 
    ld de,09b3bh               ;9050    11 3b 9b    .          ; . 
    ld bc,00008h               ;9053    01 08 00    . . . 
    add hl,bc                  ;9056    09      . 
    ld b,009h                  ;9057    06 09   . . 
l9059h:
    ld c,000h                  ;9059    0e 00   . . 
    push bc                    ;905b    c5      . 
l905ch:
    push hl                    ;905c    e5      . 
    push de                    ;905d    d5      . 
    ld b,009h                  ;905e    06 09   . . 
    or a                       ;9060    b7      . 
l9061h:
    ld a,(de)                  ;9061    1a      . 
    sbc a,(hl)                 ;9062    9e      . 
    daa                        ;9063    27      ' 
    push af                    ;9064    f5      . 
    and 00fh                   ;9065    e6 0f   . . 
    ld (de),a                  ;9067    12      . 
    pop af                     ;9068    f1      . 
    cp 00ah                    ;9069    fe 0a   . . 
    ccf                        ;906b    3f      ? 
    dec hl                     ;906c    2b      + 
    dec de                     ;906d    1b      . 
    djnz l9061h                ;906e    10 f1   . . 
    pop de                     ;9070    d1      . 
    pop hl                     ;9071    e1      . 
    jr c,l9077h                ;9072    38 03   8 . 
    inc c                      ;9074    0c      . 
    jr l905ch                  ;9075    18 e5   . . 
l9077h:
    push hl                    ;9077    e5      . 
    push de                    ;9078    d5      . 
    ld b,009h                  ;9079    06 09   . . 
    or a                       ;907b    b7      . 
l907ch:
    ld a,(de)                  ;907c    1a      . 
    adc a,(hl)                 ;907d    8e      . 
    daa                        ;907e    27      ' 
    push af                    ;907f    f5      . 
    and 00fh                   ;9080    e6 0f   . . 
    ld (de),a                  ;9082    12      . 
    pop af                     ;9083    f1      . 
    cp 00ah                    ;9084    fe 0a   . . 
    ccf                        ;9086    3f      ? 
    dec hl                     ;9087    2b      + 
    dec de                     ;9088    1b      . 
    djnz l907ch                ;9089    10 f1   . . 
    pop de                     ;908b    d1      . 
    pop hl                     ;908c    e1      . 
    ld (ix+000h),c             ;908d    dd 71 00    . q . 
    pop bc                     ;9090    c1      . 
    inc ix                     ;9091    dd 23   . # 
    inc de                     ;9093    13      . 
    djnz l9059h                ;9094    10 c3   . . 
    pop ix                     ;9096    dd e1   . . 
    pop hl                     ;9098    e1      . 
    push hl                    ;9099    e5      . 
    call sub_8e7dh             ;909a    cd 7d 8e    . } . 
    pop bc                     ;909d    c1      . 
    pop de                     ;909e    d1      . 
    pop hl                     ;909f    e1      . 
    ret                        ;90a0    c9      . 
    jr nc,l90a7h               ;90a1    30 04   0 . 
    ret p                      ;90a3    f0      . 
    jp l629fh                  ;90a4    c3 9f 62    . . b 
l90a7h:
    ret m                      ;90a7    f8      . 
    jp l629fh                  ;90a8    c3 9f 62    . . b 
l90abh:
    push hl                    ;90ab    e5      . 
    push de                    ;90ac    d5      . 
    push bc                    ;90ad    c5      . 
    ld b,00bh                  ;90ae    06 0b   . . 
l90b0h:
    ld a,(de)                  ;90b0    1a      . 
    cp (hl)                    ;90b1    be      . 
    jr nz,l90b8h               ;90b2    20 04     . 
    inc hl                     ;90b4    23      # 
    inc de                     ;90b5    13      . 
    djnz l90b0h                ;90b6    10 f8   . . 
l90b8h:
    pop bc                     ;90b8    c1      . 
    pop de                     ;90b9    d1      . 
    pop hl                     ;90ba    e1      . 
    ret                        ;90bb    c9      . 
sub_90bch:
    push hl                    ;90bc    e5      .                  (flow from: 6ec0)
    push bc                    ;90bd    c5      .                  (flow from: 90bc)
    inc hl                     ;90be    23      #                  (flow from: 90bd)
    push hl                    ;90bf    e5      .                  (flow from: 90be)
    ld a,(hl)                  ;90c0    7e      ~                  (flow from: 90bf)
    sub 080h                   ;90c1    d6 80   . .                (flow from: 90c0)
    jr c,l9117h                ;90c3    38 52   8 R                (flow from: 90c1)
    cp 008h                    ;90c5    fe 08   . .                (flow from: 90c3)
    jr nc,l9117h               ;90c7    30 4e   0 N                (flow from: 90c5)
    ld c,a                     ;90c9    4f      O                  (flow from: 90c7)
    ld b,000h                  ;90ca    06 00   . .                (flow from: 90c9)
    adc hl,bc                  ;90cc    ed 4a   . J                (flow from: 90ca)
    ld a,008h                  ;90ce    3e 08   > .                (flow from: 90cc)
    sub c                      ;90d0    91      .                  (flow from: 90ce)
    ld b,a                     ;90d1    47      G                  (flow from: 90d0)
    xor a                      ;90d2    af      .                  (flow from: 90d1)
l90d3h:
    inc hl                     ;90d3    23      #                  (flow from: 90d2 90d7)
    cp (hl)                    ;90d4    be      .                  (flow from: 90d3)
    jr nz,l9117h               ;90d5    20 40     @                (flow from: 90d4)
    djnz l90d3h                ;90d7    10 fa   . .                (flow from: 90d5)
    pop de                     ;90d9    d1      .                  (flow from: 90d7)
    ld b,c                     ;90da    41      A                  (flow from: 90d9)
    ld hl,00000h               ;90db    21 00 00    ! . .          (flow from: 90da)
    inc b                      ;90de    04      .                  (flow from: 90db)
    dec b                      ;90df    05      .                  (flow from: 90de)
    jr z,l9107h                ;90e0    28 25   ( %                (flow from: 90df)
    inc de                     ;90e2    13      .                  (flow from: 90e0)
l90e3h:
    inc de                     ;90e3    13      .                  (flow from: 90e2 9105)
    push bc                    ;90e4    c5      .                  (flow from: 90e3)
    adc hl,hl                  ;90e5    ed 6a   . j                (flow from: 90e4)
    jp pe,l9117h               ;90e7    ea 17 91    . . .          (flow from: 90e5)
    ld b,h                     ;90ea    44      D                  (flow from: 90e7)
    ld c,l                     ;90eb    4d      M                  (flow from: 90ea)
    adc hl,hl                  ;90ec    ed 6a   . j                (flow from: 90eb)
    jp pe,l9117h               ;90ee    ea 17 91    . . .          (flow from: 90ec)
    adc hl,hl                  ;90f1    ed 6a   . j                (flow from: 90ee)
    jp pe,l9117h               ;90f3    ea 17 91    . . .          (flow from: 90f1)
    adc hl,bc                  ;90f6    ed 4a   . J                (flow from: 90f3)
    jp pe,l9117h               ;90f8    ea 17 91    . . .          (flow from: 90f6)
    ld a,(de)                  ;90fb    1a      .                  (flow from: 90f8)
    ld c,a                     ;90fc    4f      O                  (flow from: 90fb)
    ld b,000h                  ;90fd    06 00   . .                (flow from: 90fc)
    adc hl,bc                  ;90ff    ed 4a   . J                (flow from: 90fd)
    jp pe,l9117h               ;9101    ea 17 91    . . .          (flow from: 90ff)
    pop bc                     ;9104    c1      .                  (flow from: 9101)
    djnz l90e3h                ;9105    10 dc   . .                (flow from: 9104)
l9107h:
    ex de,hl                   ;9107    eb      .                  (flow from: 90e0 9105)
    pop bc                     ;9108    c1      .                  (flow from: 9107)
    pop hl                     ;9109    e1      .                  (flow from: 9108)
    bit 3,(hl)                 ;910a    cb 5e   . ^                (flow from: 9109)
    jr z,l9116h                ;910c    28 08   ( .                (flow from: 910a)
    ld a,e                     ;910e    7b      {                  (flow from: 910c)
    cpl                        ;910f    2f      /                  (flow from: 910e)
    ld e,a                     ;9110    5f      _                  (flow from: 910f)
    ld a,d                     ;9111    7a      z                  (flow from: 9110)
    cpl                        ;9112    2f      /                  (flow from: 9111)
    ld d,a                     ;9113    57      W                  (flow from: 9112)
    inc de                     ;9114    13      .                  (flow from: 9113)
    cp a                       ;9115    bf      .                  (flow from: 9114)
l9116h:
    ret                        ;9116    c9      .                  (flow from: 910c 9115)
l9117h:
    inc sp                     ;9117    33      3 
    inc sp                     ;9118    33      3 
    pop bc                     ;9119    c1      . 
    pop hl                     ;911a    e1      . 
    or 001h                    ;911b    f6 01   . . 
    ret                        ;911d    c9      . 
sub_911eh:
    push hl                    ;911e    e5      . 
    push bc                    ;911f    c5      . 
    push de                    ;9120    d5      . 
    push ix                    ;9121    dd e5   . . 
    ld a,000h                  ;9123    3e 00   > . 
    bit 7,h                    ;9125    cb 7c   . | 
    jr z,l9132h                ;9127    28 09   ( . 
    ld a,h                     ;9129    7c      | 
    cpl                        ;912a    2f      / 
    ld h,a                     ;912b    67      g 
    ld a,l                     ;912c    7d      } 
    cpl                        ;912d    2f      / 
    ld l,a                     ;912e    6f      o 
    inc hl                     ;912f    23      # 
    ld a,008h                  ;9130    3e 08   > . 
l9132h:
    ld (de),a                  ;9132    12      . 
    inc de                     ;9133    13      . 
    push de                    ;9134    d5      . 
    ld b,00ah                  ;9135    06 0a   . . 
    xor a                      ;9137    af      . 
l9138h:
    ld (de),a                  ;9138    12      . 
    inc de                     ;9139    13      . 
    djnz l9138h                ;913a    10 fc   . . 
    ld bc,00080h               ;913c    01 80 00    . . . 
    pop ix                     ;913f    dd e1   . . 
    ld de,0000ah               ;9141    11 0a 00    . . . 
l9144h:
    push hl                    ;9144    e5      . 
    or a                       ;9145    b7      . 
    sbc hl,de                  ;9146    ed 52   . R 
    pop hl                     ;9148    e1      . 
    jr c,l9160h                ;9149    38 15   8 . 
    xor a                      ;914b    af      . 
    push bc                    ;914c    c5      . 
    ld b,010h                  ;914d    06 10   . . 
l914fh:
    add hl,hl                  ;914f    29      ) 
    rla                        ;9150    17      . 
    sub e                      ;9151    93      . 
    jr c,l9157h                ;9152    38 03   8 . 
    inc hl                     ;9154    23      # 
    jr l9158h                  ;9155    18 01   . . 
l9157h:
    add a,e                    ;9157    83      . 
l9158h:
    djnz l914fh                ;9158    10 f5   . . 
    pop bc                     ;915a    c1      . 
    push af                    ;915b    f5      . 
    inc b                      ;915c    04      . 
    inc c                      ;915d    0c      . 
    jr l9144h                  ;915e    18 e4   . . 
l9160h:
    ld a,l                     ;9160    7d      } 
    push af                    ;9161    f5      . 
    inc b                      ;9162    04      . 
    inc c                      ;9163    0c      . 
l9164h:
    pop af                     ;9164    f1      . 
    ld (ix+002h),a             ;9165    dd 77 02    . w . 
    inc ix                     ;9168    dd 23   . # 
    djnz l9164h                ;916a    10 f8   . . 
    pop ix                     ;916c    dd e1   . . 
    pop de                     ;916e    d1      . 
    inc de                     ;916f    13      . 
    ld a,c                     ;9170    79      y 
    ld (de),a                  ;9171    12      . 
    dec de                     ;9172    1b      . 
    pop bc                     ;9173    c1      . 
    pop hl                     ;9174    e1      . 
    ret                        ;9175    c9      . 
sub_9176h:
    push de                    ;9176    d5      .                  (flow from: 15fa 72b7 72cb 7300 9317 93e1 95d5 95e2)
    push hl                    ;9177    e5      .                  (flow from: 9176)
    push ix                    ;9178    dd e5   . .                (flow from: 9177)
    ld a,c                     ;917a    79      y                  (flow from: 178 9178)
    cp 005h                    ;917b    fe 05   . .                (flow from: 917a)
    jr z,l91e9h                ;917d    28 6a   ( j                (flow from: 917b)
    cp 006h                    ;917f    fe 06   . .                (flow from: 917d 9186)
    jr nz,l91efh               ;9181    20 6c     l                (flow from: 917f)
    ld a,e                     ;9183    7b      {                  (flow from: 9181)
    cp 0ffh                    ;9184    fe ff   . .                (flow from: 9183)
    jr z,l91adh                ;9186    28 25   ( %                (flow from: 9184)
l9188h:
    cp 0ceh                    ;9188    fe ce   . .                (flow from: 9186)
    jr z,l919fh                ;918a    28 13   ( .                (flow from: 9188)
    cp 0cfh                    ;918c    fe cf   . .                (flow from: 918a)
    jr nz,l9195h               ;918e    20 05     .                (flow from: 0ae6 918c)
    ld e,000h                  ;9190    1e 00   . . 
    jp l929ch                  ;9192    c3 9c 92    . . . 
l9195h:
    cp 0a5h                    ;9195    fe a5   . .                (flow from: 918e)
    jp c,l929ch                ;9197    da 9c 92    . . .          (flow from: 9195)
    ld e,03fh                  ;919a    1e 3f   . ? 
    jp l929ch                  ;919c    c3 9c 92    . . . 
l919fh:
    ld d,000h                  ;919f    16 00   . . 
    ld e,(iy-002h)             ;91a1    fd 5e fe    . ^ . 
    ld hl,000c8h               ;91a4    21 c8 00    ! . . 
    call 003b5h                ;91a7    cd b5 03    . . . 
    jp l92c5h                  ;91aa    c3 c5 92    . . . 
l91adh:
    call sub_91d0h             ;91ad    cd d0 91    . . .          (flow from: 9186 91b0)
    jp nc,l92c5h               ;91b0    d2 c5 92    . . .          (flow from: 91d5 91dc)
    res 3,(iy+002h)            ;91b3    fd cb 02 9e     . . . .    (flow from: 91b0)
    ld hl,(05c4fh)             ;91b7    2a 4f 5c    * O \          (flow from: 15e3 91b3)
    ld (05c51h),hl             ;91ba    22 51 5c    " Q \          (flow from: 91b7)
    call ROM_INPUT_AD          ;91bd    cd e6 15    . . .          (flow from: 91ba)
    jr nc,l91cch               ;91c0    30 0a   0 .                (flow from: 1600 92t)
    res 0,(iy+007h)            ;91c2    fd cb 07 86     . . . .    (flow from: 91c0)
    ld (09b69h),a              ;91c6    32 69 9b    2 i .          (flow from: 91c2)
    jp l92c5h                  ;91c9    c3 c5 92    . . .          (flow from: 91c6)
l91cch:
    xor a                      ;91cc    af      .                  (flow from: 9184 91c0 92c8)
    jp l92c5h                  ;91cd    c3 c5 92    . . .          (flow from: 91cc)
sub_91d0h:
    ld a,07fh                  ;91d0    3e 7f   >                 (flow from: 91ad)
    in a,(0feh)                ;91d2    db fe   . .                (flow from: 91b3 91d0)
    rra                        ;91d4    1f      .                  (flow from: 91d2)
    ret c                      ;91d5    d8      .                  (flow from: 91b7 91d4)
    ld a,07fh                  ;91d6    3e 7f   >                 (flow from: 91d5)
    in a,(0feh)                ;91d8    db fe   . .                (flow from: 91d6)
    rra                        ;91da    1f      .                  (flow from: 91d8)
    rra                        ;91db    1f      .                  (flow from: 91da)
    ret c                      ;91dc    d8      .                  (flow from: 91db)
    ld hl,09b69h               ;91dd    21 69 9b    ! i . 
    ld a,(hl)                  ;91e0    7e      ~ 
    ld (hl),018h               ;91e1    36 18   6 . 
    sub (hl)                   ;91e3    96      . 
    scf                        ;91e4    37      7 
    ccf                        ;91e5    3f      ? 
    ret z                      ;91e6    c8      . 
    ld a,(hl)                  ;91e7    7e      ~ 
    ret                        ;91e8    c9      . 
l91e9h:
    set 1,(iy+001h)            ;91e9    fd cb 01 ce     . . . . 
    jr l9188h                  ;91ed    18 99   . . 
l91efh:
    cp 01ah                    ;91ef    fe 1a   . .                (flow from: 9181)
    jr nz,l91fah               ;91f1    20 07     .                (flow from: 91ef)
    ld (09b6ah),de             ;91f3    ed 53 6a 9b     . S j .    (flow from: 91f1)
    jp l92c4h                  ;91f7    c3 c4 92    . . .          (flow from: 91f3)
l91fah:
    cp 014h                    ;91fa    fe 14   . .                (flow from: 91f1)
    jr nz,l9251h               ;91fc    20 53     S                (flow from: 91fa)
    push de                    ;91fe    d5      .                  (flow from: 91fc)
    pop ix                     ;91ff    dd e1   . .                (flow from: 91fe)
    call sub_931dh             ;9201    cd 1d 93    . . .          (flow from: 91ff)
l9204h:
    ld ix,(09b6ah)             ;9204    dd 2a 6a 9b     . * j .    (flow from: 933d)
    push de                    ;9208    d5      .                  (flow from: 9204)
    ld de,0010ah               ;9209    11 0a 01    . . .          (flow from: 9208)
    ld a,0fbh                  ;920c    3e fb   > .                (flow from: 9209)
    scf                        ;920e    37      7                  (flow from: 920c)
    call sub_92cah             ;920f    cd ca 92    . . .          (flow from: 920e)
    pop de                     ;9212    d1      .                  (flow from: 0555)
    jr nc,BLOCK_OK___string_end;9213    30 1f   0 .                (flow from: 9212)
    ld hl,(09b6ah)             ;9215    2a 6a 9b    * j .          (flow from: 9213)
    inc h                      ;9218    24      $                  (flow from: 9215)
    call sub_9372h             ;9219    cd 72 93    . r .          (flow from: 9218)
    jr nz,READ_ERROR_string_end;921c    20 26     &                (flow from: 9386)
    ld ix,BLOCK_OK___string_start;921e  dd 21 2a 92     . ! * .    (flow from: 921c)
    call sub_933eh             ;9222    cd 3e 93    . > .          (flow from: 921e)
    call sub_9365h             ;9225    cd 65 93    . e .          (flow from: 9357)
    jr l924fh                  ;9228    18 25   . %                (flow from: 9371)

; BLOCK 'BLOCK_OK___string' (start 0x922a end 0x9234)
BLOCK_OK___string_start:
    defb 042h                  ;922a    42      B 
    defb 04ch                  ;922b    4c      L 
    defb 04fh                  ;922c    4f      O 
    defb 043h                  ;922d    43      C 
    defb 04bh                  ;922e    4b      K 
    defb 020h                  ;922f    20        
    defb 04fh                  ;9230    4f      O 
    defb 04bh                  ;9231    4b      K 
    defb 020h                  ;9232    20        
    defb 020h                  ;9233    20        
BLOCK_OK___string_end:
    ld ix,READ_ERROR_string_start;9234  dd 21 3a 92     . ! : . 
    jr l9247h                  ;9238    18 0d   . . 

; BLOCK 'READ_ERROR_string' (start 0x923a end 0x9244)
READ_ERROR_string_start:
    defb 052h                  ;923a    52      R 
    defb 045h                  ;923b    45      E 
    defb 041h                  ;923c    41      A 
    defb 044h                  ;923d    44      D 
    defb 020h                  ;923e    20        
    defb 045h                  ;923f    45      E 
    defb 052h                  ;9240    52      R 
    defb 052h                  ;9241    52      R 
    defb 04fh                  ;9242    4f      O 
    defb 052h                  ;9243    52      R 
READ_ERROR_string_end:
    push hl                    ;9244    e5      . 
    pop ix                     ;9245    dd e1   . . 
l9247h:
    call sub_933eh             ;9247    cd 3e 93    . > . 
    call sub_9368h             ;924a    cd 68 93    . h . 
    jr l9204h                  ;924d    18 b5   . . 
l924fh:
    jr l92c4h                  ;924f    18 73   . s                (flow from: 9228)
l9251h:
    cp 015h                    ;9251    fe 15   . .                (flow from: 91fc)
    jr nz,l9275h               ;9253    20 20                      (flow from: 9251)
    ld b,064h                  ;9255    06 64   . d 
l9257h:
    halt                       ;9257    76      v 
    djnz l9257h                ;9258    10 fd   . . 
    ld ix,(09b6ah)             ;925a    dd 2a 6a 9b     . * j . 
    defb 0ddh,024h,0cdh        ;illegal sequence               ;925e    dd 24 cd    . $ . 
    dec e                      ;9261    1d      . 
    sub e                      ;9262    93      . 
    call sub_9368h             ;9263    cd 68 93    . h . 
    ld ix,(09b6ah)             ;9266    dd 2a 6a 9b     . * j . 
    ld de,0010ah               ;926a    11 0a 01    . . . 
    ld a,0fbh                  ;926d    3e fb   > . 
    scf                        ;926f    37      7 
    call 004c2h                ;9270    cd c2 04    . . . 
    jr l92c4h                  ;9273    18 4f   . O 
l9275h:
    cp 00fh                    ;9275    fe 0f   . .                (flow from: 9253)
    jr nz,l9286h               ;9277    20 0d     .                (flow from: 9275)
    push de                    ;9279    d5      .                  (flow from: 9277)
    pop ix                     ;927a    dd e1   . .                (flow from: 9279)
    ld a,030h                  ;927c    3e 30   > 0                (flow from: 927a)
    ld (ix+008h),a             ;927e    dd 77 08    . w .          (flow from: 927c)
    ld (ix+009h),a             ;9281    dd 77 09    . w .          (flow from: 927e)
    jr l92c4h                  ;9284    18 3e   . >                (flow from: 9281)
l9286h:
    cp 016h                    ;9286    fe 16   . . 
    jr nz,l92c4h               ;9288    20 3a     : 
    ex de,hl                   ;928a    eb      . 
    ld de,(09b6ah)             ;928b    ed 5b 6a 9b     . [ j . 
    inc d                      ;928f    14      . 
    ld bc,00008h               ;9290    01 08 00    . . . 
    ldir                       ;9293    ed b0   . . 
    ld a,030h                  ;9295    3e 30   > 0 
    ld (de),a                  ;9297    12      . 
    inc de                     ;9298    13      . 
    ld (de),a                  ;9299    12      . 
    jr l92c4h                  ;929a    18 28   . ( 
l929ch:
    ld hl,(05c4fh)             ;929c    2a 4f 5c    * O \          (flow from: 9197)
    ld (05c51h),hl             ;929f    22 51 5c    " Q \          (flow from: 929c)
    ld a,0ffh                  ;92a2    3e ff   > .                (flow from: 929f)
    ld (05c8ch),a              ;92a4    32 8c 5c    2 . \          (flow from: 92a2)
    ld a,e                     ;92a7    7b      {                  (flow from: 92a4)
    call ROM_PRINT_A_2         ;92a8    cd f2 15    . . .          (flow from: 92a7)
    res 1,(iy+001h)            ;92ab    fd cb 01 8e     . . . .    (flow from: 1600)
    bit 0,(iy+002h)            ;92af    fd cb 02 46     . . . F    (flow from: 92ab)
    jr z,l92c4h                ;92b3    28 0f   ( .                (flow from: 92af)
    ld hl,05c6bh               ;92b5    21 6b 5c    ! k \ 
    ld a,(hl)                  ;92b8    7e      ~ 
    cp 004h                    ;92b9    fe 04   . . 
    jr c,l92c4h                ;92bb    38 07   8 . 
    ld (hl),003h               ;92bd    36 03   6 . 
    ld a,016h                  ;92bf    3e 16   > . 
    ld (05c8bh),a              ;92c1    32 8b 5c    2 . \ 
l92c4h:
    xor a                      ;92c4    af      .                  (flow from: 91f7 924f 9284 92b3)
l92c5h:
    pop ix                     ;92c5    dd e1   . .                (flow from: 72bb 91c9 91cd 92c4)
    pop hl                     ;92c7    e1      .                  (flow from: 92c5)
    pop de                     ;92c8    d1      .                  (flow from: 92c7)
    ret                        ;92c9    c9      .                  (flow from: 72c0 92c8)
sub_92cah:
    inc d                      ;92ca    14      .                  (flow from: 920f)
    ex af,af'                  ;92cb    08      .                  (flow from: 92ca)
    dec d                      ;92cc    15      .                  (flow from: 92cb)
    di                         ;92cd    f3      .                  (flow from: 92cc)
    ld a,00fh                  ;92ce    3e 0f   > .                (flow from: 92cd)
    out (0feh),a               ;92d0    d3 fe   . .                (flow from: 92ce)
    ld hl,0053fh               ;92d2    21 3f 05    ! ? .          (flow from: 92d0)
    push hl                    ;92d5    e5      .                  (flow from: 92d2)
    in a,(0feh)                ;92d6    db fe   . .                (flow from: 92d5)
    rra                        ;92d8    1f      .                  (flow from: 92d6)
    and 020h                   ;92d9    e6 20   .                  (flow from: 92d8)
    or 002h                    ;92db    f6 02   . .                (flow from: 92d9)
    ld c,a                     ;92dd    4f      O                  (flow from: 92db)
    cp a                       ;92de    bf      .                  (flow from: 92dd)
l92dfh:
    ret nz                     ;92df    c0      .                  (flow from: 92de 92e3)
l92e0h:
    call ROM_LD_EDGE_1         ;92e0    cd e7 05    . . .          (flow from: 92df)
    jr nc,l92dfh               ;92e3    30 fa   0 .                (flow from: 05ee 0604)
    ld hl,00180h               ;92e5    21 80 01    ! . .          (flow from: 92e3)
l92e8h:
    djnz l92e8h                ;92e8    10 fe   . .                (flow from: 92e5 92e8 92ed)
    dec hl                     ;92ea    2b      +                  (flow from: 92e8)
    ld a,h                     ;92eb    7c      |                  (flow from: 92ea)
    or l                       ;92ec    b5      .                  (flow from: 92eb)
    jr nz,l92e8h               ;92ed    20 f9     .                (flow from: 92ec)
    call ROM_LD_EDGE_2         ;92ef    cd e3 05    . . .          (flow from: 92ed)
    jr nc,l92dfh               ;92f2    30 eb   0 .                (flow from: 0604)
l92f4h:
    ld b,09ch                  ;92f4    06 9c   . .                (flow from: 92f2 9301)
    call ROM_LD_EDGE_2         ;92f6    cd e3 05    . . .          (flow from: 92f4)
    jr nc,l92dfh               ;92f9    30 e4   0 .                (flow from: 0604)
    ld a,0c6h                  ;92fb    3e c6   > .                (flow from: 92f9)
    cp b                       ;92fd    b8      .                  (flow from: 92fb)
    jr nc,l92e0h               ;92fe    30 e0   0 .                (flow from: 92fd)
    inc h                      ;9300    24      $                  (flow from: 92fe)
    jr nz,l92f4h               ;9301    20 f1     .                (flow from: 9300)
l9303h:
    ld b,0c9h                  ;9303    06 c9   . .                (flow from: 9301 930d)
    call ROM_LD_EDGE_1         ;9305    cd e7 05    . . .          (flow from: 9303)
    jr nc,l92dfh               ;9308    30 d5   0 .                (flow from: 0604)
    ld a,b                     ;930a    78      x                  (flow from: 9308)
    cp 0d4h                    ;930b    fe d4   . .                (flow from: 930a)
    jr nc,l9303h               ;930d    30 f4   0 .                (flow from: 930b)
    jp 0059bh                  ;930f    c3 9b 05    . . .          (flow from: 930d)
sub_9312h:
    push af                    ;9312    f5      .                  (flow from: 9345 9350 935c 936c)
    push de                    ;9313    d5      .                  (flow from: 9312)
    ld c,006h                  ;9314    0e 06   . .                (flow from: 9313)
    ld e,a                     ;9316    5f      _                  (flow from: 9314)
    call sub_9176h             ;9317    cd 76 91    . v .          (flow from: 9316)
    pop de                     ;931a    d1      .                  (flow from: 92c9)
    pop af                     ;931b    f1      .                  (flow from: 931a)
    ret                        ;931c    c9      .                  (flow from: 931b)
sub_931dh:
    inc (ix+009h)              ;931d    dd 34 09    . 4 .          (flow from: 9201)
    ld a,039h                  ;9320    3e 39   > 9                (flow from: 931d)
    cp (ix+009h)               ;9322    dd be 09    . . .          (flow from: 9320)
    jr nc,l9337h               ;9325    30 10   0 .                (flow from: 9322)
    ld (ix+009h),030h          ;9327    dd 36 09 30     . 6 . 0    (flow from: 9325)
    inc (ix+008h)              ;932b    dd 34 08    . 4 .          (flow from: 9327)
    cp (ix+008h)               ;932e    dd be 08    . . .          (flow from: 932b)
    jr nc,l9337h               ;9331    30 04   0 .                (flow from: 932e)
    ld (ix+008h),030h          ;9333    dd 36 08 30     . 6 . 0 
l9337h:
    call sub_933eh             ;9337    cd 3e 93    . > .          (flow from: 9325 9331)
    call sub_9358h             ;933a    cd 58 93    . X .          (flow from: 9357)
    ret                        ;933d    c9      .                  (flow from: 9364)
sub_933eh:
    push ix                    ;933e    dd e5   . .                (flow from: 9222 9337)
    ld b,00ah                  ;9340    06 0a   . .                (flow from: 933e)
l9342h:
    ld a,(ix+000h)             ;9342    dd 7e 00    . ~ .          (flow from: 9340 934a)
    call sub_9312h             ;9345    cd 12 93    . . .          (flow from: 9342)
    inc ix                     ;9348    dd 23   . #                (flow from: 931c)
    djnz l9342h                ;934a    10 f6   . .                (flow from: 9348)
    ld a,020h                  ;934c    3e 20   >                  (flow from: 934a)
    ld b,004h                  ;934e    06 04   . .                (flow from: 934c)
l9350h:
    call sub_9312h             ;9350    cd 12 93    . . .          (flow from: 934e 9353)
    djnz l9350h                ;9353    10 fb   . .                (flow from: 931c)
    pop ix                     ;9355    dd e1   . .                (flow from: 9353)
    ret                        ;9357    c9      .                  (flow from: 9355)
sub_9358h:
    ld b,00eh                  ;9358    06 0e   . .                (flow from: 933a)
    ld a,020h                  ;935a    3e 20   >                  (flow from: 9358)
l935ch:
    call sub_9312h             ;935c    cd 12 93    . . .          (flow from: 935a 935f)
    djnz l935ch                ;935f    10 fb   . .                (flow from: 931c)
    call sub_9368h             ;9361    cd 68 93    . h .          (flow from: 935f)
    ret                        ;9364    c9      .                  (flow from: 9371)
sub_9365h:
    call sub_9368h             ;9365    cd 68 93    . h .          (flow from: 9225)
sub_9368h:
    ld b,00eh                  ;9368    06 0e   . .                (flow from: 9361 9365 9371)
    ld a,008h                  ;936a    3e 08   > .                (flow from: 9368)
l936ch:
    call sub_9312h             ;936c    cd 12 93    . . .          (flow from: 936a 936f)
    djnz l936ch                ;936f    10 fb   . .                (flow from: 931c)
    ret                        ;9371    c9      .                  (flow from: 936f)
sub_9372h:
    push de                    ;9372    d5      .                  (flow from: 9219)
    push hl                    ;9373    e5      .                  (flow from: 9372)
    ld a,(de)                  ;9374    1a      .                  (flow from: 9373)
    cp 020h                    ;9375    fe 20   .                  (flow from: 9374)
    jr z,l9387h                ;9377    28 0e   ( .                (flow from: 9375)
    ld b,00ah                  ;9379    06 0a   . .                (flow from: 9377)
l937bh:
    ld a,(de)                  ;937b    1a      .                  (flow from: 9379 9381)
    cp (hl)                    ;937c    be      .                  (flow from: 937b)
    jr nz,l9384h               ;937d    20 05     .                (flow from: 937c)
    inc hl                     ;937f    23      #                  (flow from: 937d)
    inc de                     ;9380    13      .                  (flow from: 937f)
    djnz l937bh                ;9381    10 f8   . .                (flow from: 9380)
l9383h:
    cp a                       ;9383    bf      .                  (flow from: 9381)
l9384h:
    pop hl                     ;9384    e1      .                  (flow from: 9383)
    pop de                     ;9385    d1      .                  (flow from: 9384)
    ret                        ;9386    c9      .                  (flow from: 9385)
l9387h:
    ld bc,00008h               ;9387    01 08 00    . . . 
    ldir                       ;938a    ed b0   . . 
    jr l9383h                  ;938c    18 f5   . . 
sub_938eh:
    push af                    ;938e    f5      .                  (flow from: 93d4)
    push bc                    ;938f    c5      .                  (flow from: 938e)
    push hl                    ;9390    e5      .                  (flow from: 938f)
    push hl                    ;9391    e5      .                  (flow from: 9390)
    ld hl,09b96h               ;9392    21 96 9b    ! . .          (flow from: 9391)
    ld de,00134h               ;9395    11 34 01    . 4 .          (flow from: 9392)
    ld b,001h                  ;9398    06 01   . .                (flow from: 9395)
l939ah:
    ld a,(hl)                  ;939a    7e      ~                  (flow from: 9398)
    or a                       ;939b    b7      .                  (flow from: 939a)
    jr z,l93a7h                ;939c    28 09   ( .                (flow from: 939b)
    add hl,de                  ;939e    19      . 
    djnz l939ah                ;939f    10 f9   . . 
    ld hl,00006h               ;93a1    21 06 00    ! . . 
    jp l62a7h                  ;93a4    c3 a7 62    . . b 
l93a7h:
    ex de,hl                   ;93a7    eb      .                  (flow from: 939c)
    pop hl                     ;93a8    e1      .                  (flow from: 93a7)
    push de                    ;93a9    d5      .                  (flow from: 93a8)
    ld (hl),006h               ;93aa    36 06   6 .                (flow from: 93a9)
    inc hl                     ;93ac    23      #                  (flow from: 93aa)
    ld (hl),e                  ;93ad    73      s                  (flow from: 93ac)
    inc hl                     ;93ae    23      #                  (flow from: 93ad)
    ld (hl),d                  ;93af    72      r                  (flow from: 93ae)
    inc hl                     ;93b0    23      #                  (flow from: 93af)
    push hl                    ;93b1    e5      .                  (flow from: 93b0)
    ld hl,0ffdch               ;93b2    21 dc ff    ! . .          (flow from: 93b1)
    add hl,de                  ;93b5    19      .                  (flow from: 93b2)
    ex de,hl                   ;93b6    eb      .                  (flow from: 93b5)
    pop hl                     ;93b7    e1      .                  (flow from: 93b6)
    call sub_93c0h             ;93b8    cd c0 93    . . .          (flow from: 93b7)
    pop de                     ;93bb    d1      .                  (flow from: 93d3)
    pop hl                     ;93bc    e1      .                  (flow from: 93bb)
    pop bc                     ;93bd    c1      .                  (flow from: 93bc)
    pop af                     ;93be    f1      .                  (flow from: 93bd)
    ret                        ;93bf    c9      .                  (flow from: 93be)
sub_93c0h:
    push de                    ;93c0    d5      .                  (flow from: 93b8)
    push hl                    ;93c1    e5      .                  (flow from: 93c0)
    ld b,008h                  ;93c2    06 08   . .                (flow from: 93c1)
l93c4h:
    ld a,(hl)                  ;93c4    7e      ~                  (flow from: 93c2 93cf)
    cp 0ffh                    ;93c5    fe ff   . .                (flow from: 93c4)
    jr nz,l93cch               ;93c7    20 03     .                (flow from: 93c5)
    dec hl                     ;93c9    2b      +                  (flow from: 93c7)
    ld a,020h                  ;93ca    3e 20   >                  (flow from: 93c9)
l93cch:
    ld (de),a                  ;93cc    12      .                  (flow from: 93c7 93ca)
    inc de                     ;93cd    13      .                  (flow from: 93cc)
    inc hl                     ;93ce    23      #                  (flow from: 93cd)
    djnz l93c4h                ;93cf    10 f3   . .                (flow from: 93ce)
    pop hl                     ;93d1    e1      .                  (flow from: 93cf)
    pop de                     ;93d2    d1      .                  (flow from: 93d1)
    ret                        ;93d3    c9      .                  (flow from: 93d2)
l93d4h:
    call sub_938eh             ;93d4    cd 8e 93    . . .          (flow from: 94aa)
l93d7h:
    push hl                    ;93d7    e5      .                  (flow from: 93bf)
    push de                    ;93d8    d5      .                  (flow from: 93d7)
    push bc                    ;93d9    c5      .                  (flow from: 93d8)
    ld hl,0ffdch               ;93da    21 dc ff    ! . .          (flow from: 93d9)
    add hl,de                  ;93dd    19      .                  (flow from: 93da)
    ex de,hl                   ;93de    eb      .                  (flow from: 93dd)
    ld c,00fh                  ;93df    0e 0f   . .                (flow from: 93de)
    call sub_9176h             ;93e1    cd 76 91    . v .          (flow from: 93df)
    pop bc                     ;93e4    c1      .                  (flow from: 92c9)
    pop de                     ;93e5    d1      .                  (flow from: 93e4)
    call sub_6713h             ;93e6    cd 13 67    . . g          (flow from: 93e5)
    push ix                    ;93e9    dd e5   . .                (flow from: 688b)
    push de                    ;93eb    d5      .                  (flow from: 93e9)
    pop ix                     ;93ec    dd e1   . .                (flow from: 93eb)
    ld (ix+002h),0ffh          ;93ee    dd 36 02 ff     . 6 . .    (flow from: 93ec)
    ld (ix+000h),001h          ;93f2    dd 36 00 01     . 6 . .    (flow from: 93ee)
    ld (ix-004h),000h          ;93f6    dd 36 fc 00     . 6 . .    (flow from: 93f2)
    pop ix                     ;93fa    dd e1   . .                (flow from: 93f6)
    ex de,hl                   ;93fc    eb      .                  (flow from: 93fa)
    call sub_95bfh             ;93fd    cd bf 95    . . .          (flow from: 93fc)
    pop hl                     ;9400    e1      .                  (flow from: 9601)
    ret nz                     ;9401    c0      .                  (flow from: 9400)
    inc de                     ;9402    13      .                  (flow from: 9401)
    inc de                     ;9403    13      .                  (flow from: 9402)
    ex de,hl                   ;9404    eb      .                  (flow from: 9403)
    dec (hl)                   ;9405    35      5                  (flow from: 9404)
    cp a                       ;9406    bf      .                  (flow from: 9405)
    ret                        ;9407    c9      .                  (flow from: 9406)
sub_9408h:
    call sub_938eh             ;9408    cd 8e 93    . . . 
sub_940bh:
    push af                    ;940b    f5      . 
    push hl                    ;940c    e5      . 
    push ix                    ;940d    dd e5   . . 
    push de                    ;940f    d5      . 
    pop ix                     ;9410    dd e1   . . 
    push de                    ;9412    d5      . 
    inc de                     ;9413    13      . 
    inc de                     ;9414    13      . 
    inc de                     ;9415    13      . 
    ld c,01ah                  ;9416    0e 1a   . . 
    call sub_9176h             ;9418    cd 76 91    . v . 
    ld hl,0ffd9h               ;941b    21 d9 ff    ! . . 
    add hl,de                  ;941e    19      . 
    ex de,hl                   ;941f    eb      . 
    ld c,016h                  ;9420    0e 16   . . 
    call sub_9176h             ;9422    cd 76 91    . v . 
    pop de                     ;9425    d1      . 
    ld (ix-004h),000h          ;9426    dd 36 fc 00     . 6 . . 
    ld (ix+002h),000h          ;942a    dd 36 02 00     . 6 . . 
    ld (ix+000h),002h          ;942e    dd 36 00 02     . 6 . . 
    pop ix                     ;9432    dd e1   . . 
    pop hl                     ;9434    e1      . 
    pop af                     ;9435    f1      . 
    ret                        ;9436    c9      . 
l9437h:
    push hl                    ;9437    e5      . 
    push de                    ;9438    d5      . 
    push bc                    ;9439    c5      . 
    push af                    ;943a    f5      . 
    push ix                    ;943b    dd e5   . . 
    ld a,(hl)                  ;943d    7e      ~ 
    cp 006h                    ;943e    fe 06   . . 
    jp nz,l6295h               ;9440    c2 95 62    . . b 
    push hl                    ;9443    e5      . 
    call sub_9623h             ;9444    cd 23 96    . # . 
    push hl                    ;9447    e5      . 
    pop ix                     ;9448    dd e1   . . 
    ld a,(hl)                  ;944a    7e      ~ 
    ld (hl),000h               ;944b    36 00   6 . 
    cp 002h                    ;944d    fe 02   . . 
    pop hl                     ;944f    e1      . 
    ld (hl),010h               ;9450    36 10   6 . 
    inc hl                     ;9452    23      # 
    ld (hl),e                  ;9453    73      s 
    inc hl                     ;9454    23      # 
    ld (hl),d                  ;9455    72      r 
    pop ix                     ;9456    dd e1   . . 
    pop af                     ;9458    f1      . 
    pop bc                     ;9459    c1      . 
    pop de                     ;945a    d1      . 
    pop hl                     ;945b    e1      . 
    ret                        ;945c    c9      . 
sub_945dh:
    push hl                    ;945d    e5      . 
    call sub_9623h             ;945e    cd 23 96    . # . 
    ld a,01ah                  ;9461    3e 1a   > . 
    call sub_957eh             ;9463    cd 7e 95    . ~ . 
    push ix                    ;9466    dd e5   . . 
    push hl                    ;9468    e5      . 
    pop ix                     ;9469    dd e1   . . 
    ld a,(ix+002h)             ;946b    dd 7e 02    . ~ . 
    or a                       ;946e    b7      . 
    pop ix                     ;946f    dd e1   . . 
    call nz,sub_959dh          ;9471    c4 9d 95    . . . 
    pop hl                     ;9474    e1      . 
    jp l9437h                  ;9475    c3 37 94    . 7 . 
    ex af,af'                  ;9478    08      . 
    ld a,(hl)                  ;9479    7e      ~ 
    sub h                      ;947a    94      . 
    inc bc                     ;947b    03      . 
    ret z                      ;947c    c8      . 
    sub h                      ;947d    94      . 
    inc b                      ;947e    04      . 
    add a,(hl)                 ;947f    86      . 
    sub h                      ;9480    94      . 

; BLOCK 'OPEN_string' (start 0x9481 end 0x9485)
OPEN_string_start:
    defb 04fh                  ;9481    4f      O 
    defb 050h                  ;9482    50      P 
    defb 045h                  ;9483    45      E 
    defb 04eh                  ;9484    4e      N 
OPEN_string_end:
    rst 38h                    ;9485    ff      . 
    ld ix,l948dh               ;9486    dd 21 8d 94     . ! . .    (flow from: 60bb)
    jp l65f7h                  ;948a    c3 f7 65    . . e          (flow from: 9486)
l948dh:
    rst 38h                    ;948d    ff      . 
    rst 38h                    ;948e    ff      . 
    dec b                      ;948f    05      . 
    rst 38h                    ;9490    ff      . 
    rst 38h                    ;9491    ff      . 
    dec b                      ;9492    05      . 
    rst 38h                    ;9493    ff      . 
    rst 38h                    ;9494    ff      . 
    rst 38h                    ;9495    ff      . 
    rst 38h                    ;9496    ff      . 
    ld hl,(0980ah)             ;9497    2a 0a 98    * . .          (flow from: 663c)
    ld a,(hl)                  ;949a    7e      ~                  (flow from: 9497)
    cp 006h                    ;949b    fe 06   . .                (flow from: 949a)
    jr z,l94adh                ;949d    28 0e   ( .                (flow from: 949b)
    cp 010h                    ;949f    fe 10   . .                (flow from: 949d)
    jp nz,l6290h               ;94a1    c2 90 62    . . b          (flow from: 949f)
    call sub_7653h             ;94a4    cd 53 76    . S v          (flow from: 94a1)
    jp nz,l6290h               ;94a7    c2 90 62    . . b          (flow from: 7662)
    jp l93d4h                  ;94aa    c3 d4 93    . . .          (flow from: 94a7)
l94adh:
    call sub_7653h             ;94ad    cd 53 76    . S v 
    jr z,l94b4h                ;94b0    28 02   ( . 
    cp a                       ;94b2    bf      . 
    ret                        ;94b3    c9      . 
l94b4h:
    push hl                    ;94b4    e5      . 
    call sub_9623h             ;94b5    cd 23 96    . # . 
    ex de,hl                   ;94b8    eb      . 
    pop hl                     ;94b9    e1      . 
    ld a,(de)                  ;94ba    1a      . 
    cp 002h                    ;94bb    fe 02   . . 
    jr nz,l94c5h               ;94bd    20 06     . 
    call sub_945dh             ;94bf    cd 5d 94    . ] . 
    call sub_938eh             ;94c2    cd 8e 93    . . . 
l94c5h:
    jp l93d7h                  ;94c5    c3 d7 93    . . . 
    ex af,af'                  ;94c8    08      . 
    adc a,094h                 ;94c9    ce 94   . . 
    inc bc                     ;94cb    03      . 
    inc sp                     ;94cc    33      3 
    sub l                      ;94cd    95      . 
    inc b                      ;94ce    04      . 
    ret c                      ;94cf    d8      . 
    sub h                      ;94d0    94      . 

; BLOCK 'CREATE_string' (start 0x94d1 end 0x94d7)
CREATE_string_start:
    defb 043h                  ;94d1    43      C 
    defb 052h                  ;94d2    52      R 
    defb 045h                  ;94d3    45      E 
    defb 041h                  ;94d4    41      A 
    defb 054h                  ;94d5    54      T 
    defb 045h                  ;94d6    45      E 
CREATE_string_end:
    rst 38h                    ;94d7    ff      . 
    ld ix,l94dfh               ;94d8    dd 21 df 94     . ! . . 
    jp l65f7h                  ;94dc    c3 f7 65    . . e 
l94dfh:
    rst 38h                    ;94df    ff      . 
    rst 38h                    ;94e0    ff      . 
    dec b                      ;94e1    05      . 
    rst 38h                    ;94e2    ff      . 
    rst 38h                    ;94e3    ff      . 
    dec b                      ;94e4    05      . 
    rst 38h                    ;94e5    ff      . 
    rst 38h                    ;94e6    ff      . 
    rst 38h                    ;94e7    ff      . 
    rst 38h                    ;94e8    ff      . 
    ld hl,(0980ah)             ;94e9    2a 0a 98    * . . 
    ld a,(hl)                  ;94ec    7e      ~ 
    cp 006h                    ;94ed    fe 06   . . 
    jr z,l9501h                ;94ef    28 10   ( . 
    cp 010h                    ;94f1    fe 10   . . 
    jp nz,l6290h               ;94f3    c2 90 62    . . b 
    call sub_7653h             ;94f6    cd 53 76    . S v 
    jp nz,l6290h               ;94f9    c2 90 62    . . b 
    call sub_9408h             ;94fc    cd 08 94    . . . 
    cp a                       ;94ff    bf      . 
    ret                        ;9500    c9      . 
l9501h:
    call sub_7653h             ;9501    cd 53 76    . S v 
    jr z,l9508h                ;9504    28 02   ( . 
    cp a                       ;9506    bf      . 
    ret                        ;9507    c9      . 
l9508h:
    push hl                    ;9508    e5      . 
    call sub_9623h             ;9509    cd 23 96    . # . 
    ex de,hl                   ;950c    eb      . 
    ld a,(de)                  ;950d    1a      . 
    cp 002h                    ;950e    fe 02   . . 
    jr nz,l952dh               ;9510    20 1b     . 
    push ix                    ;9512    dd e5   . . 
    push de                    ;9514    d5      . 
    pop ix                     ;9515    dd e1   . . 
    ld hl,0ffdch               ;9517    21 dc ff    ! . . 
    add hl,de                  ;951a    19      . 
    ld c,016h                  ;951b    0e 16   . . 
    call sub_9176h             ;951d    cd 76 91    . v . 
    ld (ix-004h),000h          ;9520    dd 36 fc 00     . 6 . . 
    ld (ix+002h),000h          ;9524    dd 36 02 00     . 6 . . 
    pop ix                     ;9528    dd e1   . . 
    pop hl                     ;952a    e1      . 
    cp a                       ;952b    bf      . 
    ret                        ;952c    c9      . 
l952dh:
    pop hl                     ;952d    e1      . 
    call sub_940bh             ;952e    cd 0b 94    . . . 
    cp a                       ;9531    bf      . 
    ret                        ;9532    c9      . 
    ex af,af'                  ;9533    08      . 
    add hl,sp                  ;9534    39      9 
    sub l                      ;9535    95      . 
    inc bc                     ;9536    03      . 
    xor h                      ;9537    ac      . 
    add a,e                    ;9538    83      . 
    inc b                      ;9539    04      . 
    ld b,d                     ;953a    42      B 
    sub l                      ;953b    95      . 

; BLOCK 'CLOSE_string' (start 0x953c end 0x9541)
CLOSE_string_start:
    defb 043h                  ;953c    43      C 
    defb 04ch                  ;953d    4c      L 
    defb 04fh                  ;953e    4f      O 
    defb 053h                  ;953f    53      S 
    defb 045h                  ;9540    45      E 
CLOSE_string_end:
    rst 38h                    ;9541    ff      . 
    ld ix,l9549h               ;9542    dd 21 49 95     . ! I .    (flow from: 60bb)
    jp l65f7h                  ;9546    c3 f7 65    . . e          (flow from: 9542)
l9549h:
    rst 38h                    ;9549    ff      . 
    rst 38h                    ;954a    ff      . 
    dec b                      ;954b    05      . 
    rst 38h                    ;954c    ff      . 
    rst 38h                    ;954d    ff      . 
    dec b                      ;954e    05      . 
    rst 38h                    ;954f    ff      . 
    rst 38h                    ;9550    ff      . 
    rst 38h                    ;9551    ff      . 
    rst 38h                    ;9552    ff      . 
    ld hl,(0980ah)             ;9553    2a 0a 98    * . .          (flow from: 663c)
    ld a,(hl)                  ;9556    7e      ~                  (flow from: 9553)
    cp 006h                    ;9557    fe 06   . .                (flow from: 9556)
    ret nz                     ;9559    c0      .                  (flow from: 9557)
    call sub_7653h             ;955a    cd 53 76    . S v          (flow from: 9559)
    jr z,l9561h                ;955d    28 02   ( .                (flow from: 7662)
    cp a                       ;955f    bf      . 
    ret                        ;9560    c9      . 
l9561h:
    call sub_9623h             ;9561    cd 23 96    . # .          (flow from: 955d)
    ex de,hl                   ;9564    eb      .                  (flow from: 9628)
    ld a,(de)                  ;9565    1a      .                  (flow from: 9564)
    ld hl,(0980ah)             ;9566    2a 0a 98    * . .          (flow from: 9565)
    cp 002h                    ;9569    fe 02   . .                (flow from: 9566)
    push hl                    ;956b    e5      .                  (flow from: 9569)
    push de                    ;956c    d5      .                  (flow from: 956b)
    call z,sub_945dh           ;956d    cc 5d 94    . ] .          (flow from: 956c)
    pop de                     ;9570    d1      .                  (flow from: 956d)
    pop hl                     ;9571    e1      .                  (flow from: 9570)
    ld a,000h                  ;9572    3e 00   > .                (flow from: 9571)
    ld (de),a                  ;9574    12      .                  (flow from: 9572)
    ld (hl),010h               ;9575    36 10   6 .                (flow from: 9574)
    ld a,00dh                  ;9577    3e 0d   > .                (flow from: 9575)
    call l72fah                ;9579    cd fa 72    . . r          (flow from: 9577)
    cp a                       ;957c    bf      .                  (flow from: 734b)
    ret                        ;957d    c9      .                  (flow from: 957c)
sub_957eh:
    push af                    ;957e    f5      . 
    ld a,(hl)                  ;957f    7e      ~ 
    cp 002h                    ;9580    fe 02   . . 
    jp nz,l6295h               ;9582    c2 95 62    . . b 
    pop af                     ;9585    f1      . 
    push af                    ;9586    f5      . 
    push hl                    ;9587    e5      . 
    push de                    ;9588    d5      . 
    inc hl                     ;9589    23      # 
    inc hl                     ;958a    23      # 
    ld e,(hl)                  ;958b    5e      ^ 
    inc (hl)                   ;958c    34      4 
    ld d,000h                  ;958d    16 00   . . 
    inc hl                     ;958f    23      # 
    add hl,de                  ;9590    19      . 
    ld (hl),a                  ;9591    77      w 
    ld a,e                     ;9592    7b      { 
    cp 0feh                    ;9593    fe fe   . . 
    pop de                     ;9595    d1      . 
    pop hl                     ;9596    e1      . 
    call z,sub_959dh           ;9597    cc 9d 95    . . . 
    pop af                     ;959a    f1      . 
    cp a                       ;959b    bf      . 
    ret                        ;959c    c9      . 
sub_959dh:
    push af                    ;959d    f5      . 
    push bc                    ;959e    c5      . 
    push hl                    ;959f    e5      . 
    push de                    ;95a0    d5      . 
    ld d,h                     ;95a1    54      T 
    ld e,l                     ;95a2    5d      ] 
    push hl                    ;95a3    e5      . 
    inc hl                     ;95a4    23      # 
    inc hl                     ;95a5    23      # 
    ld (hl),000h               ;95a6    36 00   6 . 
    inc hl                     ;95a8    23      # 
    ex de,hl                   ;95a9    eb      . 
    ld c,01ah                  ;95aa    0e 1a   . . 
    call sub_9176h             ;95ac    cd 76 91    . v . 
    pop hl                     ;95af    e1      . 
    ld de,0ffdch               ;95b0    11 dc ff    . . . 
    add hl,de                  ;95b3    19      . 
    ex de,hl                   ;95b4    eb      . 
    ld c,015h                  ;95b5    0e 15   . . 
    call sub_9176h             ;95b7    cd 76 91    . v . 
    pop de                     ;95ba    d1      . 
    pop hl                     ;95bb    e1      . 
    pop bc                     ;95bc    c1      . 
    pop af                     ;95bd    f1      . 
    ret                        ;95be    c9      . 
sub_95bfh:
    push de                    ;95bf    d5      .                  (flow from: 93fd 9615)
    push bc                    ;95c0    c5      .                  (flow from: 95bf)
    push hl                    ;95c1    e5      .                  (flow from: 95c0)
l95c2h:
    push hl                    ;95c2    e5      .                  (flow from: 95c1 95e9)
    ld a,(hl)                  ;95c3    7e      ~                  (flow from: 95c2)
    cp 001h                    ;95c4    fe 01   . .                (flow from: 95c3)
    jr nz,l95fdh               ;95c6    20 35     5                (flow from: 95c4)
    inc hl                     ;95c8    23      #                  (flow from: 95c6)
    inc hl                     ;95c9    23      #                  (flow from: 95c8)
    ld a,(hl)                  ;95ca    7e      ~                  (flow from: 95c9)
    cp 0ffh                    ;95cb    fe ff   . .                (flow from: 95ca)
    jr nz,l95ebh               ;95cd    20 1c     .                (flow from: 95cb)
    ld (hl),000h               ;95cf    36 00   6 .                (flow from: 95cd)
    ld c,01ah                  ;95d1    0e 1a   . .                (flow from: 95cf)
    ex de,hl                   ;95d3    eb      .                  (flow from: 95d1)
    inc de                     ;95d4    13      .                  (flow from: 95d3)
    call sub_9176h             ;95d5    cd 76 91    . v .          (flow from: 95d4)
    dec de                     ;95d8    1b      .                  (flow from: 92c9)
    dec de                     ;95d9    1b      .                  (flow from: 95d8)
    dec de                     ;95da    1b      .                  (flow from: 95d9)
    ld hl,0ffdch               ;95db    21 dc ff    ! . .          (flow from: 95da)
    add hl,de                  ;95de    19      .                  (flow from: 95db)
    ex de,hl                   ;95df    eb      .                  (flow from: 95de)
    ld c,014h                  ;95e0    0e 14   . .                (flow from: 95df)
    call sub_9176h             ;95e2    cd 76 91    . v .          (flow from: 95e0)
    or a                       ;95e5    b7      .                  (flow from: 92c9)
    jr nz,l95fdh               ;95e6    20 15     .                (flow from: 95e5)
    pop hl                     ;95e8    e1      .                  (flow from: 95e6)
    jr l95c2h                  ;95e9    18 d7   . .                (flow from: 95e8)
l95ebh:
    ld e,a                     ;95eb    5f      _                  (flow from: 95cd)
    inc (hl)                   ;95ec    34      4                  (flow from: 95eb)
    ld d,000h                  ;95ed    16 00   . .                (flow from: 95ec)
    inc hl                     ;95ef    23      #                  (flow from: 95ed)
    add hl,de                  ;95f0    19      .                  (flow from: 95ef)
    ld a,(hl)                  ;95f1    7e      ~                  (flow from: 95f0)
    cp 01ah                    ;95f2    fe 1a   . .                (flow from: 95f1)
    jr z,l95f9h                ;95f4    28 03   ( .                (flow from: 95f2)
    cp a                       ;95f6    bf      .                  (flow from: 95f4)
    jr l95fdh                  ;95f7    18 04   . .                (flow from: 95f6)
l95f9h:
    call l961ah                ;95f9    cd 1a 96    . . .          (flow from: 95f4)
    or a                       ;95fc    b7      .                  (flow from: 9622)
l95fdh:
    pop hl                     ;95fd    e1      .                  (flow from: 95f7 95fc)
    pop hl                     ;95fe    e1      .                  (flow from: 95fd)
    pop bc                     ;95ff    c1      .                  (flow from: 95fe)
    pop de                     ;9600    d1      .                  (flow from: 95ff)
    ret                        ;9601    c9      .                  (flow from: 9600)
l9602h:
    push hl                    ;9602    e5      . 
    ld hl,(09b6dh)             ;9603    2a 6d 9b    * m . 
    call sub_957eh             ;9606    cd 7e 95    . ~ . 
    call sub_7310h             ;9609    cd 10 73    . . s 
    pop hl                     ;960c    e1      . 
    ret                        ;960d    c9      . 
l960eh:
    push hl                    ;960e    e5      .                  (flow from: 9865)
    ld hl,(09b6dh)             ;960f    2a 6d 9b    * m .          (flow from: 960e)
    call sub_7310h             ;9612    cd 10 73    . . s          (flow from: 960f)
    call sub_95bfh             ;9615    cd bf 95    . . .          (flow from: 734b)
    pop hl                     ;9618    e1      .                  (flow from: 9601)
    ret                        ;9619    c9      .                  (flow from: 9618)
l961ah:
    push hl                    ;961a    e5      .                  (flow from: 95f9 9868)
    ld hl,(09b6dh)             ;961b    2a 6d 9b    * m .          (flow from: 961a)
    inc hl                     ;961e    23      #                  (flow from: 961b)
    inc hl                     ;961f    23      #                  (flow from: 961e)
    dec (hl)                   ;9620    35      5                  (flow from: 961f)
    pop hl                     ;9621    e1      .                  (flow from: 9620)
    ret                        ;9622    c9      .                  (flow from: 9621)
sub_9623h:
    inc hl                     ;9623    23      #                  (flow from: 6076 6085 6097 60ab 60b8 60c3 60fa 6100 612a 6177 631f 6327 6331 6372 63b7 63d2 63f4 6420 6499 6516 652c 657a 6583 658b 65bf 65ec 667f 66eb 67d0 6896 68af 68f8 6908 692e 6934 6955 6964 6972 6983 6a1a 6a7b 6f93 6f9e 6fab 6fb4 720c 7691 769f 7760 7766 77b4 77c7 77cb 781c 79fb 7a08 7a85 7a8f 7d4c 7d5f 7d69 7d79 7d89 7d8f 7d9c 7da0 7e55 7f5f 9561)
    ld a,(hl)                  ;9624    7e      ~                  (flow from: 9623)
    inc hl                     ;9625    23      #                  (flow from: 7a98 9624)
    ld h,(hl)                  ;9626    66      f                  (flow from: 9625)
    ld l,a                     ;9627    6f      o                  (flow from: 9626)
    ret                        ;9628    c9      .                  (flow from: 9627)
sub_9629h:
    call sub_7296h             ;9629    cd 96 72    . . r          (flow from: 6019)

; BLOCK 'INTRO_string' (start 0x962c end 0x9663)
INTRO_string_start:
    defb 0a0h                  ;962c    a0      . 
    defb 0a0h                  ;962d    a0      . 
    defb 0a0h                  ;962e    a0      . 
    defb 0d3h                  ;962f    d3      . 
    defb 0d0h                  ;9630    d0      . 
    defb 0c5h                  ;9631    c5      . 
    defb 0c3h                  ;9632    c3      . 
    defb 0d4h                  ;9633    d4      . 
    defb 0d2h                  ;9634    d2      . 
    defb 0d5h                  ;9635    d5      . 
    defb 0cdh                  ;9636    cd      . 
    defb 0a0h                  ;9637    a0      . 
    defb 0edh                  ;9638    ed      . 
    defb 0e9h                  ;9639    e9      . 
    defb 0e3h                  ;963a    e3      . 
    defb 0f2h                  ;963b    f2      . 
    defb 0efh                  ;963c    ef      . 
    defb 0adh                  ;963d    ad      . 
    defb 0d0h                  ;963e    d0      . 
    defb 0d2h                  ;963f    d2      . 
    defb 0cfh                  ;9640    cf      . 
    defb 0cch                  ;9641    cc      . 
    defb 0cfh                  ;9642    cf      . 
    defb 0c7h                  ;9643    c7      . 
    defb 0a0h                  ;9644    a0      . 
    defb 0d4h                  ;9645    d4      . 
    defb 0b1h                  ;9646    b1      . 
    defb 0aeh                  ;9647    ae      . 
    defb 0b0h                  ;9648    b0      . 
    defb 00dh                  ;9649    0d      . 
    defb 0a0h                  ;964a    a0      . 
    defb 0a0h                  ;964b    a0      . 
    defb 0a0h                  ;964c    a0      . 
    defb 0a0h                  ;964d    a0      . 
    defb 0a0h                  ;964e    a0      . 
    defb 0a8h                  ;964f    a8      . 
    defb 0e3h                  ;9650    e3      . 
    defb 0a9h                  ;9651    a9      . 
    defb 0a0h                  ;9652    a0      . 
    defb 0b1h                  ;9653    b1      . 
    defb 0b9h                  ;9654    b9      . 
    defb 0b8h                  ;9655    b8      . 
    defb 0b3h                  ;9656    b3      . 
    defb 0a0h                  ;9657    a0      . 
    defb 0a0h                  ;9658    a0      . 
    defb 0cch                  ;9659    cc      . 
    defb 0a0h                  ;965a    a0      . 
    defb 0d0h                  ;965b    d0      . 
    defb 0a0h                  ;965c    a0      . 
    defb 0c1h                  ;965d    c1      . 
    defb 0a0h                  ;965e    a0      . 
    defb 0a0h                  ;965f    a0      . 
    defb 0cch                  ;9660    cc      . 
    defb 0f4h                  ;9661    f4      . 
    defb 0e4h                  ;9662    e4      . 
INTRO_string_end:
    xor (hl)                   ;9663    ae      . 
    nop                        ;9664    00      .                  (flow from: 72a0)
    ld hl,09da5h               ;9665    21 a5 9d    ! . .          (flow from: 9664)
    ld (09805h),hl             ;9668    22 05 98    " . .          (flow from: 9665)
    ld hl,0ffffh               ;966b    21 ff ff    ! . .          (flow from: 9668)
    ld (0985bh),hl             ;966e    22 5b 98    " [ .          (flow from: 966b)
    ld a,0c3h                  ;9671    3e c3   > .                (flow from: 966e)
    ld (09865h),a              ;9673    32 65 98    2 e .          (flow from: 9671)
    ld (09868h),a              ;9676    32 68 98    2 h .          (flow from: 9673)
    ld (0986bh),a              ;9679    32 6b 98    2 k .          (flow from: 9676)
    ld (09800h),a              ;967c    32 00 98    2 . .          (flow from: 9679)
    ld hl,l72fah               ;967f    21 fa 72    ! . r          (flow from: 967c)
    ld (0986ch),hl             ;9682    22 6c 98    " l .          (flow from: 967f)
    ld hl,(09803h)             ;9685    2a 03 98    * . .          (flow from: 9682)
    ld bc,0fc01h               ;9688    01 01 fc    . . .          (flow from: 9685)
    add hl,bc                  ;968b    09      .                  (flow from: 9688)
    res 0,l                    ;968c    cb 85   . .                (flow from: 968b)
    ld (09839h),hl             ;968e    22 39 98    " 9 .          (flow from: 968c)
    ld (0983bh),hl             ;9691    22 3b 98    "          ; . (flow from: 968e)
    ld (hl),080h               ;9694    36 80   6 .                (flow from: 9691)
    ld de,(09805h)             ;9696    ed 5b 05 98     . [ . .    (flow from: 9694)
    or a                       ;969a    b7      .                  (flow from: 9696)
    sbc hl,de                  ;969b    ed 52   . R                (flow from: 969a)
    push hl                    ;969d    e5      .                  (flow from: 969b)
    call sub_6b26h             ;969e    cd 26 6b    . & k          (flow from: 969d)
    call sub_7296h             ;96a1    cd 96 72    . . r          (flow from: 6b55)

; BLOCK 'BYTESFREE_string' (start 0x96a4 end 0x96b0)
BYTESFREE_string_start:
    defb 0a0h                  ;96a4    a0      . 
    defb 0c2h                  ;96a5    c2      . 
    defb 0f9h                  ;96a6    f9      . 
    defb 0f4h                  ;96a7    f4      . 
    defb 0e5h                  ;96a8    e5      . 
    defb 0f3h                  ;96a9    f3      . 
    defb 0a0h                  ;96aa    a0      . 
    defb 0c6h                  ;96ab    c6      . 
    defb 0f2h                  ;96ac    f2      . 
    defb 0e5h                  ;96ad    e5      . 
    defb 0e5h                  ;96ae    e5      . 
    defb 0a0h                  ;96af    a0      . 
BYTESFREE_string_end:
    nop                        ;96b0    00      .                  (flow from: 72a0)
    pop hl                     ;96b1    e1      .                  (flow from: 96b0)
    srl h                      ;96b2    cb 3c   . <                (flow from: 96b1)
    rr l                       ;96b4    cb 1d   . .                (flow from: 96b2)
    push hl                    ;96b6    e5      .                  (flow from: 96b4)
    srl h                      ;96b7    cb 3c   . <                (flow from: 96b6)
    rr l                       ;96b9    cb 1d   . .                (flow from: 96b7)
    srl h                      ;96bb    cb 3c   . <                (flow from: 96b9)
    rr l                       ;96bd    cb 1d   . .                (flow from: 96bb)
    push hl                    ;96bf    e5      .                  (flow from: 96bd)
    srl h                      ;96c0    cb 3c   . <                (flow from: 96bf)
    rr l                       ;96c2    cb 1d   . .                (flow from: 96c0)
    pop bc                     ;96c4    c1      .                  (flow from: 96c2)
    add hl,bc                  ;96c5    09      .                  (flow from: 96c4)
    ld a,l                     ;96c6    7d      }                  (flow from: 96c5)
    and 0c0h                   ;96c7    e6 c0   . .                (flow from: 96c6)
    ld l,a                     ;96c9    6f      o                  (flow from: 96c7)
    push hl                    ;96ca    e5      .                  (flow from: 96c9)
    add hl,de                  ;96cb    19      .                  (flow from: 96ca)
    ld (09837h),hl             ;96cc    22 37 98    " 7 .          (flow from: 96cb)
    ld (0984bh),hl             ;96cf    22 4b 98    " K .          (flow from: 96cc)
    pop hl                     ;96d2    e1      .                  (flow from: 96cf)
    sla l                      ;96d3    cb 25   . %                (flow from: 96d2)
    rl h                       ;96d5    cb 14   . .                (flow from: 96d3)
    sla l                      ;96d7    cb 25   . %                (flow from: 96d5)
    rl h                       ;96d9    cb 14   . .                (flow from: 96d7)
    ld b,h                     ;96db    44      D                  (flow from: 96d9)
    ld hl,09a99h               ;96dc    21 99 9a    ! . .          (flow from: 96db)
l96dfh:
    ld (hl),0ffh               ;96df    36 ff   6 .                (flow from: 96dc 96e2)
    inc hl                     ;96e1    23      #                  (flow from: 96df)
    djnz l96dfh                ;96e2    10 fb   . .                (flow from: 96e1)
    pop de                     ;96e4    d1      .                  (flow from: 96e2)
    ld hl,(09839h)             ;96e5    2a 39 98    * 9 .          (flow from: 96e4)
    or a                       ;96e8    b7      .                  (flow from: 96e5)
    sbc hl,de                  ;96e9    ed 52   . R                (flow from: 96e8)
    ld (0985dh),hl             ;96eb    22 5d 98    " ] .          (flow from: 96e9)
    ld a,05ah                  ;96ee    3e 5a   > Z                (flow from: 96eb)
    ld (09970h),a              ;96f0    32 70 99    2 p .          (flow from: 96ee)
    xor a                      ;96f3    af      .                  (flow from: 96f0)
    ld (0996fh),a              ;96f4    32 6f 99    2 o .          (flow from: 96f3)
    ld (09a73h),a              ;96f7    32 73 9a    2 s .          (flow from: 96f4)
    ld (09a84h),a              ;96fa    32 84 9a    2 . .          (flow from: 96f7)
    ld de,09971h               ;96fd    11 71 99    . q .          (flow from: 96fa)
    ld (de),a                  ;9700    12      .                  (flow from: 96fd)
    inc de                     ;9701    13      .                  (flow from: 9700)
    inc a                      ;9702    3c      <                  (flow from: 9701)
    ld (de),a                  ;9703    12      .                  (flow from: 9702)
    inc de                     ;9704    13      .                  (flow from: 9703)
    ld a,00dh                  ;9705    3e 0d   > .                (flow from: 9704)
    ld (de),a                  ;9707    12      .                  (flow from: 9705)
    ld b,001h                  ;9708    06 01   . .                (flow from: 9707)
    ld hl,09b96h               ;970a    21 96 9b    ! . .          (flow from: 9708)
    ld de,00134h               ;970d    11 34 01    . 4 .          (flow from: 970a)
    ld a,000h                  ;9710    3e 00   > .                (flow from: 970d)
l9712h:
    ld (hl),a                  ;9712    77      w                  (flow from: 9710)
    add hl,de                  ;9713    19      .                  (flow from: 9712)
    djnz l9712h                ;9714    10 fc   . .                (flow from: 9713)
    ld hl,sub_9623h            ;9716    21 23 96    ! # .          (flow from: 9714)
    ld (00031h),hl             ;9719    22 31 00    " 1 .          (flow from: 9716)
    ld a,0c3h                  ;971c    3e c3   > .                (flow from: 9719)
    ld (00030h),a              ;971e    32 30 00    2 0 .          (flow from: 971c)
    ld hl,l83a0h               ;9721    21 a0 83    ! . .          (flow from: 971e)
    ld de,09a8dh               ;9724    11 8d 9a    . . .          (flow from: 9721)
    ld bc,0000ch               ;9727    01 0c 00    . . .          (flow from: 9724)
    ldir                       ;972a    ed b0   . .                (flow from: 9727 972a)
    ld hl,l8b0ah               ;972c    21 0a 8b    ! . .          (flow from: 972a)
    ld de,09b19h               ;972f    11 19 9b    . . .          (flow from: 972c)
    ld bc,00006h               ;9732    01 06 00    . . .          (flow from: 972f)
    ldir                       ;9735    ed b0   . .                (flow from: 9732 9735)
    ld hl,_ERROR__string_start ;9737    21 49 97    ! I .          (flow from: 9735)
    ld de,09ca5h               ;973a    11 a5 9c    . . .          (flow from: 9737)
    ld bc,00008h               ;973d    01 08 00    . . .          (flow from: 973a)
    ldir                       ;9740    ed b0   . .                (flow from: 973d 9740)
    call sub_79e6h             ;9742    cd e6 79    . . y          (flow from: 9740)
    ld (09b1ah),hl             ;9745    22 1a 9b    " . .          (flow from: 7a80)
    ret                        ;9748    c9      .                  (flow from: 9745)

; BLOCK '_ERROR__string' (start 0x9749 end 0x9750)
_ERROR__string_start:
    defb 03fh                  ;9749    3f      ? 
    defb 045h                  ;974a    45      E 
    defb 052h                  ;974b    52      R 
    defb 052h                  ;974c    52      R 
    defb 04fh                  ;974d    4f      O 
    defb 052h                  ;974e    52      R 
    defb 03fh                  ;974f    3f      ? 
_ERROR__string_end:
    cp 0f4h                    ;9750    fe f4   . . 
    or l                       ;9752    b5      . 
    xor (hl)                   ;9753    ae      . 
    or e                       ;9754    b3      . 
    or a                       ;9755    b7      . 
    and b                      ;9756    a0      . 
    or d                       ;9757    b2      . 
    cp b                       ;9758    b8      . 
    and b                      ;9759    a0      . 
    pop bc                     ;975a    c1      . 
    push af                    ;975b    f5      . 
    rst 20h                    ;975c    e7      . 
    and b                      ;975d    a0      . 
    cp b                       ;975e    b8      . 
    or e                       ;975f    b3      . 
    xor a                      ;9760    af      . 
    ld (05c41h),a              ;9761    32 41 5c    2 A \ 
    ld a,030h                  ;9764    3e 30   > 0 
    ld (05c8dh),a              ;9766    32 8d 5c    2 . \ 
    ld (05c8fh),a              ;9769    32 8f 5c    2 . \ 
    jp l6003h                  ;976c    c3 03 60    . . ` 
    call nz,0c2d2h             ;976f    c4 d2 c2    . . . 
    nop                        ;9772    00      . 
    nop                        ;9773    00      . 
    nop                        ;9774    00      . 
    nop                        ;9775    00      . 
    nop                        ;9776    00      . 
    nop                        ;9777    00      . 


l9800h:
;   indirect jump. e.g.: JP l6962h
l9865h:
;   indirect jump. e.g.: JP l73a8h
l9868h:
;   indirect jump. e.g.: JP l7428h
l986Bh:
;   indirect jump. e.g.: JP l72fah 
