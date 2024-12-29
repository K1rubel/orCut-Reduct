;; helpers for Holman's boolean expression reduction functions

(= (isLiteral $atom)
    ; identifies literals like A B (NOT A)
    (if (== (get-metatype $atom) Symbol)
        True
        (let $head (car-atom $atom)
            (== $head NOT)
        )))


(= (getLiterals $exp)
     (case $exp
       (
         (() $exp)
         ((NOT $x) $exp)
         ($else (if (== (get-metatype $exp) Expression) (collapse (filterLiterals (superpose $exp))) $exp)))))

(= (filterLiterals $exp)
        (if (== (get-metatype $exp) Symbol)
            (if (or (== $exp AND) (== $exp OR)) (empty) $exp)
            (if (== (car-atom $exp) NOT)
                $exp
                (empty))))

;returns the length of an expression
(= (size-atom $expr)
    (if (== $expr ())
        0
        (+ 1 (size-atom (cdr-atom $expr)))
    )
)


(= (getChildren $exp)
     (case $exp
       (
         (() $exp)
         ((NOT $x) ())
         ($else (if (== (get-metatype $exp) Expression) (collapse (filterChildren (superpose $exp))) ())))))


(= (filterChildren $exp)
        (if (== (get-metatype $exp) Symbol)
            (empty)
            (if (== (car-atom $exp) NOT)
                (empty)
                $exp)))