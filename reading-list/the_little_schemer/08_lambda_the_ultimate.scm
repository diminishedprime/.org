(load "ls.scm") ;; => #<unspecified>

(define rember-f
  (lambda (test? a l)
    (cond
     ((null? l) '())
     ((test? (car l) a) (cdr l))
     (else (cons (car l)
                 (rember-f test? a (cdr l))))))) ;; => #<unspecified>

(rember-f o= '5 '(6 2 5 3)) ;; => (6 2 3)
(rember-f eq? 'jelly '(jelly beans are good)) ;; => (beans are good)
(rember-f oequal? '(pop corn) '(lemonade (pop corn) and cake)) ;; => (lemonade and cake)

(define eq?-c
  (lambda (a)
    (lambda (x)
      (eq? x a)))) ;; => #<unspecified>

(eq?-c 'salad) ;; => #<procedure 10971d880 at <current input>:594:4 (x)>

(define eq?-salad (eq?-c 'salad)) ;; => #<unspecified>

(eq?-salad 'salad) ;; => #t
(eq?-salad 'tuna) ;; => #f
((eq?-c 'salad) 'tuna) ;; => #f

(define rember-f
  (lambda (test?)
    (lambda (a l)
      (cond
       ((null? l) '())
       ((test? (car l) a) (cdr l))
       (else (cons (car l) ((rember-f test?) a (cdr l)))))))) ;; => #<unspecified>

((rember-f eq?) 'car '(this is a car)) ;; => (this is a)

(define rember-eq? (rember-f eq?)) ;; => #<unspecified>
(rember-eq? 'tuna '(tuna salad is good)) ;; => (salad is good)
((rember-f eq?) 'tuna '(tuna salad is good)) ;; => (salad is good)
((rember-f eq?) 'tuna '(shrimp salad and tuna salad)) ;; => (shrimp salad and salad)
((rember-f eq?) 'eq? '(equal? eq? eqan? eqlist? eqpair?)) ;; => (equal? eqan? eqlist? eqpair?)


(define insertL-f
  (lambda (test?)
    (lambda (new old l)
      (cond
       ((null? l) '())
       ((test? (car l) old) (cons new (cons old (cdr l))))
       (else (cons (car l)
                   ((insertL-f test?) new old (cdr l)))))))) ;; => #<unspecified>


(define insertR-f
  (lambda (test?)
    (lambda (new old l)
      (cond
       ((null? l) '())
       ((test? (car l) old) (cons old (cons new (cdr l))))
       (else (cons (car l)
                   ((insertR-f test?) new old (cdr l)))))))) ;; => #<unspecified>

(define insert-g
  (lambda (insert-fn)
    (lambda (new old l)
      (cond
       ((null? l) '())
       ((eq? (car l) old) (insert-fn new old (cdr l)))
       (else (cons (car l)
                   ((insert-g insert-fn) new old (cdr l)))))))) ;; => #<unspecified>

(define seqR
  (lambda (a b l)
    (cons b (cons a l)))) ;; => #<unspecified>

(seqR 'a 'b '(hello there)) ;; => (b a hello there)

(define seqL
  (lambda (a b l)
    (cons a (cons b l)))) ;; => #<unspecified>

(seqL 'a 'b '(hello there)) ;; => (a b hello there)

(define insertL (insert-g seqL)) ;; => #<unspecified>
(insertL 'a 'b '(a b c)) ;; => (a a b c)

(define insertR (insert-g seqR)) ;; => #<unspecified>
(insertR 'a 'b '(a b c)) ;; => (a b a c)

(define insertL
  (insert-g
   (lambda (new old l)
     (cons new (cons old l))))) ;; => #<unspecified>

(insertL 'a 'b '(a b c)) ;; => (a a b c)

(define seqS
  (lambda (new old l)
    (cons new l))) ;; => #<unspecified>

(define subst (insert-g seqS)) ;; => #<unspecified>

(subst 'a 'b '(a b c)) ;; => (a a c)

(define seqrem
  (lambda (new old l)
    l)) ;; => #<unspecified>

(define rember (insert-g seqrem)) ;; => #<unspecified>

(rember #f 'a '(a b c)) ;; => (b c)

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Ninth Commandment ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Abstract common patterns with a new function.

;; This is value from chapter 6.
(define value
  (lambda (aexp)
    (cond
     ((atom? aexp) aexp)
     ((eq? (operator aexp) 'o+) (o+ (value (1st-sub-exp aexp))
                                    (value (2nd-sub-exp aexp))))
     ((eq? (operator aexp) 'o*) (o* (value (1st-sub-exp aexp))
                                    (value (2nd-sub-exp aexp))))
     ((eq? (operator aexp) 'o^) (o^ (value (1st-sub-exp aexp))
                                    (value (2nd-sub-exp aexp))))))) ;; => #<unspecified>


(define atom-to-function
  (lambda (x)
    (cond
     ((eq? x (quote o+)) o+)
     ((eq? x (quote o*)) o*)
     ((eq? x (quote o^)) o^)))) ;; => #<unspecified>


(define value
  (lambda (aexp)
    (cond
     ((atom? aexp) aexp)
     (else  ((atom-to-function (operator aexp))
             (value (1st-sub-exp aexp))
             (value (2nd-sub-exp aexp))))))) ;; => #<unspecified>

(value '(o^ 2 3)) ;; => 8

;; Definition of multirember from ch. 3
(define multirember
  (lambda (a lat)
    (cond
     ((null? lat) '())
     ((eq? a (car lat)) (multirember a (cdr lat)))
     (else (cons (car lat) (multirember a (cdr lat))))))) ;; => #<unspecified>

(define multirember-f
  (lambda (test?)
    (lambda (a lat)
      (cond
       ((null? lat) '())
       ((test? a (car lat)) (multirember a (cdr lat)))
       (else (cons (car lat) (multirember a (cdr lat)))))))) ;; => #<unspecified>

((multirember-f eq?) 'tuna '(shrimp salad tuna salad and tuna)) ;; => (shrimp salad salad and)

(define multirember-eq? (multirember-f eq?)) ;; => #<unspecified>

(define eq?-tuna
  (eq?-c 'tuna)) ;; => #<unspecified>

(define multiremberT
  (lambda (test? lat)
    (cond
     ((null? lat) '())
     ((test? (car lat)) (multiremberT test? (cdr lat)))
     (else (cons (car lat) (multiremberT test? (cdr lat))))))) ;; => #<unspecified>

(multiremberT eq?-tuna '(shrimp salad tuna salad and tuna)) ;; => (shrimp salad salad and)
