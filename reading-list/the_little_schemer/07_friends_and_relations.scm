(load "ls.scm") ;; => #<unspecified>

(define set?
  (lambda (lat)
    (cond
     ((null? lat) #t)
     ((member? (car lat) (cdr lat)) #f)
     (else (set? (cdr lat)))))) ;; => #<unspecified>

(set? '(apple peaches apple plum)) ;; => #f
(set? '(apples peaches pears plums)) ;; => #t
(set? '()) ;; => #t
(set? '(apple 3 pear 4 9 apple 3 4)) ;; => #f

(define makeset
  (lambda (lat)
    (cond
     ((null? lat) '())
     ((member? (car lat) (cdr lat)) (makeset (cdr lat)))
     (else (cons (car lat) (makeset (cdr lat))))))) ;; => #<unspecified>

(makeset '(apple peach pear peach plum apple lemon peach)) ;; => (pear plum apple lemon peach)

(define makeset
  (lambda (lat)
    (cond
     ((null? lat) '())
     (else (cons (car lat)
                 (makeset (multirember (car lat)
                                       (cdr lat)))))))) ;; => #<unspecified>

(makeset '(apple peach pear peach plum apple lemon peach)) ;; => (apple peach pear plum lemon)
(makeset '(apple 3 pear 4 9 apple 3 4)) ;; => (apple 3 pear 4 9)

(define subset?
  (lambda (set1 set2)
    (cond
     ((null? set1) #t)
     ((member? (car set1) set2) (subset? (cdr set1) set2))
     (else #f)))) ;; => #<unspecified>

(subset? '(5 chicken wings)
         '(5 hamburgers
             2 pieces friend chicken and
             light duckling wings)) ;; => #t
(subset? '(4 pounds of horseradish)
         '(four pounds chicken and 5 ounces horseradish)) ;; => #f

(define subset?
  (lambda (set1 set2)
    (cond
     ((null? set1) #t)
     (else (and (member? (car set1) set2)
                (subset? (cdr set1) set2)))))) ;; => #<unspecified>

(subset? '(5 chicken wings)
         '(5 hamburgers
             2 pieces friend chicken and
             light duckling wings)) ;; => #t
(subset? '(4 pounds of horseradish)
         '(four pounds chicken and 5 ounces horseradish)) ;; => #f

(define eqset?
  (lambda (set1 set2)
    (and (subset? set1 set2)
         (subset? set2 set1)))) ;; => #<unspecified>

(eqset? '(6 large chickens with wings)
        '(6 chickens with large wings)) ;; => #t

(define intersect?
  (lambda (set1 set2)
    (cond
     ((null? set1) #f)
     (else (or (member? (car set1) set2)
               (intersect? (cdr set1) set2)))))) ;; => #<unspecified>

(intersect? '(stewed tomatoes and macaroni)
            '(macaroni and cheese)) ;; => #t

(define intersect
  (lambda (set1 set2)
    (cond
     ((null? set1) '())
     ((member? (car set1) set2) (cons (car set1)
                                      (intersect (cdr set1) set2)))
     (else (intersect (cdr set1) set2))))) ;; => #<unspecified>

(intersect '(stewed tomatoes and macaroni)
           '(macaroni and cheese)) ;; => (and macaroni)

(define union
  (lambda (set1 set2)
    (cond
     ((null? set1) '())
     ((member? (car set1) set2) (union (cdr set1) set2))
     (else (cons (car set1)
                 (union (cdr set1) set2)))))) ;; => #<unspecified>

(union '(stewed tomatoes and macaroni casserole)
       '(macaroni and cheese)) ;; => (stewed tomatoes casserole)


(define difference
  (lambda (set1 set2)
    (cond
     ((null? set1) '())
     ((member? (car set1) set2) (difference (cdr set1) set2))
     (else (cons (car set1)
                 (difference (cdr set1) set2)))))) ;; => #<unspecified>


(difference '(stewed tomatoes and macaroni casserole)
            '(macaroni and cheese)) ;; => (stewed tomatoes casserole)


(define intersectall
  (lambda (l-set)
    (cond
     ((null? (cdr l-set)) (car l-set))
     (else (intersect (car l-set)
                      (intersectall (cdr l-set))))))) ;; => #<unspecified>

(intersectall '((a b c) (c a d e) (e f g h a b))) ;; => (a)

(intersectall '((6 pears and)
                (3 peaches and 6 peppers)
                (8 pears and 6 plums)
                (and 6 prunes with some apples))) ;; => (6 and)

(define a-pair?
  (lambda (x)
    (cond
     ((atom? x) #f)
     ((null? x) #f)
     ((null? (cdr x)) #f)
     ((null? (cdr (cdr x))) #t)
     (else #f)))) ;; => #<unspecified>

(a-pair? '(pear pear)) ;; => #t
(a-pair? '((2) (pair))) ;; => #t
(a-pair? '(full (house))) ;; => #t


(define first
  (lambda (p)
    (car p))) ;; => #<unspecified>

(define second
  (lambda (p)
    (car (cdr p)))) ;; => #<unspecified>

(define build
  (lambda (s1 s2)
    (cons s1 (cons s2 '())))) ;; => #<unspecified>

(define third
  (lambda (p)
    (car (cdr (cdr p))))) ;; => #<unspecified>

(define fun?
  (lambda (rel)
    (set? (firsts rel)))) ;; => #<unspecified>

(define revrel
  (lambda (rel)
    (cond
     ((null? rel) '())
     (else (cons (build
                  (second (car rel))
                  (first (car rel)))
                 (revrel (cdr rel))))))) ;; => #<unspecified>

(revrel '((8 a) (pumpkin pie) (got sick))) ;; => ((a 8) (pie pumpkin) (sick got))

(define revpair
  (lambda (pair)
    (build (second pair)
           (first pair)))) ;; => #<unspecified>

(define revrel
  (lambda (rel)
    (cond
     ((null? rel) '())
     (else (cons (revpair (car rel))
                 (revrel (cdr rel))))))) ;; => #<unspecified>

(revrel '((8 a) (pumpkin pie) (got sick))) ;; => ((a 8) (pie pumpkin) (sick got))

(define seconds
  (lambda (l)
    (cond
     ((null? l) '())
     (else (cons (second (car l))
                 (seconds (cdr l))))))) ;; => #<unspecified>

(define fullfun?
  (lambda (fun)
    (set? (seconds fun)))) ;; => #<unspecified>

(fullfun? '((8 3) (4 2) (7 6) (6 2) (3 4))) ;; => #f
(fullfun? '((8 3) (4 8) (7 6) (6 2) (3 4))) ;; => #t
(fullfun? '((grape raisin)
            (plum prune)
            (stewed prune))) ;; => #f
(fullfun? '((grape raisin)
            (plum prune)
            (stewed grape))) ;; => #t

(define one-to-one?
  (lambda (fun)
    (fun? (revrel fun)))) ;; => #<unspecified>

(one-to-one? '((8 3) (4 2) (7 6) (6 2) (3 4))) ;; => #t
(one-to-one? '((8 3) (4 8) (7 6) (6 2) (3 4))) ;; => #t
(one-to-one? '((grape raisin)
            (plum prune)
            (stewed prune))) ;; => #t
(one-to-one? '((grape raisin)
            (plum prune)
            (stewed grape))) ;; => #t
