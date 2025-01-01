
;; Name:                        orCut (The Cut-Unnecessary-OR Transformation)
;; Goal:                        To remove an unnecessary OR node and its child.
;; Point of application :       Any OR node.
;; Preconditions :              The POA has only one child.
;; Action :                     Add the constraints in the POA’s child’s guard set to the guard set of the
;;                              POA’s parent. Add the POA’s grandchildren to the POA’s parent’s list of
;;                              children. Remove the POA from the POA’s parent’s list of children. Release the
;;                              POA and the POA’s child.                    
;; Parameters:                  1. $expr, the main expression, possibly containing an OR node with one child
;;                              2. $poa,  the point of application, an OR node with only one child               
;; Examples:                    (orCut (OR (NOT C)) (OR (NOT C))) -> (NOT C)
;;   taken from Holman's book   ! (orCut (AND A (OR (AND B (OR (NOT D))) (AND (NOT C)))) (OR (NOT D))) -> (AND A (OR (AND B (NOT D)) (AND (NOT C))))                           

! (register-module! ./helpers)
! (import! &self helpers:expression-helpers)

(= (orCut $expr $poa)
    (if (== $expr $poa)
        (let* (
            ($child (cdr-atom $poa))
            ($temp (car-atom $child))
            ($gChild (cdr-atom $temp))
            )
            (superpose $gChild)
            
        )
        (collapse (let $el (superpose $expr)
            (if (isLiteral $el)
                $el
                (orCut $el $poa)
            )))))


! (assertEqual 
    (orCut (OR (AND B)) (OR (AND B))) 
        B)

! (assertEqual 
    (orCut (OR (AND (NOT B))) (OR (AND (NOT B)))) 
       (NOT B))

 ! (assertEqual 
     (orCut (AND A (OR (AND B (OR (AND (NOT D) C))) (AND (NOT C)))) (OR (AND (NOT D) C)))
         (AND A (OR (AND B (NOT D) C) (AND (NOT C)))))

! (assertEqual 
    (orCut (AND A (OR (AND (NOT B))) (OR (AND B (OR (NOT D))) (AND (NOT C)))) (OR (AND (NOT B))))
        (AND A (NOT B) (OR (AND B (OR (NOT D))) (AND (NOT C)))))

;; (AND A B (OR (AND B (OR (NOT D))) (AND (NOT C))))