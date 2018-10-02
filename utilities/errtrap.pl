errtrap-mod("?ERROR?")(q e s f c is-told tell data-rel)
((respond q X)
  (ABORT))
((respond e X)
  /
  (RFILL (X) Y)
  Y)
((respond c X)
  /
  X)
((respond tell (X|Y))
  /
  (ADDCL ((X|Z) (is-told (X Z))))
  (X|Y))
((respond f X)
  /
  FAIL)
((respond s X)
  /)
((respond / X)
  /
  (R Y)
  (R Z)
  (Y Z)
  (P "error&")
  (R x)
  (respond x X))
((respond X (Y|Z))
  (PP to quit enter : q)
  (PP to fail call enter : f)
  (PP to succeed call enter : s)
  (PP to line edit call and resume enter : e)
  (P or enter / "<any command>" (eg / add "<clause>" ,/ LOAD file))
  (PP)
  (PP or enter : tell (see manual))
  (PP to resume enter : c)
  (P "error&")
  (R x)
  (respond x (Y|Z)))
((E-code 6 "CLOSE last used file first"))
((E-code 15 "Break ! during tape read or write"))
((P-code 0 "Arithmetic overflow"))
((P-code 1 "Arithmetic underflow"))
((P-code 2 "No clauses for relation"))
((P-code 3 "Too many variables or invalid form"))
((P-code 4 "Error in adding clause"))
((P-code 5 "File error"))
((P-code 11 "Break !"))
((P-code 12 "Illegal use of modules"))
((P-code 13 "Line or point off screen"))
((P-code 22 "Illegal colour"))
((P-code X " "))
((COPYWRITE LPA LTD 1983 (V 6 -15)))
(("?ERROR?" 2 (X|Y))
  (CL ((data-rel X)))
  /
  FAIL)
(("?ERROR?" X Y)
  (P-code X Z)
  /
  (P Error X Z)
  (PP)
  (PP trying Y)
  (P "error&(? for info)")
  (R x)
  (respond x Y))
CLMOD
