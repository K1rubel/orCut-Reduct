! (register-module! ./helpers)
! (import! &self helpers:expression-helpers)


;; Performs the orCut transformation
;; Finds an OR node with one child (literal or sub-expression) and replaces it with its child 

(= (orCut $expr)
    (if (== $expr ())
        $expr
        (let* (
            ($node (car-atom $expr))
            ($tail (cdr-atom $expr))
            )
            (if (and (== $node OR) (== (size-atom $tail) 1))
                (let* (
                    ($newTail (car-atom $tail))
                    ($gChild (cdr-atom $newTail))
                    )
                    (superpose $gChild)
                    )
                (orCutHelper $expr)
            ))))

(= (orCutHelper $expr)
    (collapse (let $el (superpose $expr)
        (if (isLiteral $el)
            $el
            (let $node (car-atom $el)
                (if (== $node AND)
                    (if (== (getChildren $el) ())
                        $el
                        (orCut $el)
                    )
                    (if (== (size-atom (cdr-atom $el)) 1)
                        (let* (
                            ($newTail (cdr-atom $el))
                            ($temp (car-atom $newTail))
                            ($gChild (cdr-atom $temp))
                            )
                            (superpose $gChild)
                        )
                        (orCut $el)
                    )))))))

;; Test

! (assertEqual 
    (orCut ()) 
        ())

;; POA (OR (AND B))
! (assertEqual 
    (orCut (OR (AND B))) 
         B)

;; POA (OR (AND (NOT B)))
! (assertEqual 
    (orCut (OR (AND (NOT B)))) 
        (NOT B))

;; POA (OR (AND (NOT D)))
! (assertEqual 
    (orCut (AND A (OR (AND B (OR (AND (NOT D)))) (AND (NOT C)))))
        (AND A (OR (AND B (NOT D)) (AND (NOT C)))))

;; POA  (OR (AND B)) , as well as  (OR (AND (NOT D)))
! (assertEqual 
    (orCut (AND A (OR (AND B)) (OR (AND B (OR (AND (NOT D)))) (AND (NOT C)))))
        (AND A B (OR (AND B (NOT D)) (AND (NOT C)))))

;; POA (OR (AND D))
! (assertEqual 
    (orCut (AND A (OR (NOT B) (AND B (AND C (OR (AND D))))) (OR (AND B) (AND (NOT C)))))
        (AND A (OR (NOT B) (AND B (AND C D))) (OR (AND B) (AND (NOT C)))))