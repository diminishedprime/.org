(load "ls.scm") ;; => #<unspecified>

(quote a) ;; => a
(quote o+) ;; => o+
(quote o*) ;; => o*
(eq? (quote a) 'a) ;; => #t
(eq? 'a 'a) ;; => #t

(define numbered?
  (lambda (aexp)
    (cond
     ((atom? aexp) (number? aexp))
     (else (and (numbered? (car aexp))
                (numbered? (car (cdr (cdr aexp))))))))) ;; => #<unspecified>

(numbered? 1) ;; => #t
(numbered? '(3 + (4 o^ 5))) ;; => #t
(numbered? '(2 o* sausage)) ;; => #f

(define value
  (lambda (nexp)
    (cond
     ((atom? nexp) nexp)
     ((eq? (car (cdr nexp)) 'o+) (o+ (value (car nexp))
                                     (value (car (cdr (cdr nexp))))))
     ((eq? (car (cdr nexp)) 'o*) (o* (value (car nexp))
                                     (value (car (cdr (cdr nexp))))))
     ((eq? (car (cdr nexp)) 'o^) (o^ (value (car nexp))
                                     (value (car (cdr (cdr nexp))))))))) ;; => #<unspecified>

(value 13) ;; => 13
(value '(1 o+ 3)) ;; => 4
(value '(1 o+ (3 o^ 4))) ;; => 82
(value 'cookie) ;; => cookie

(define value
  (lambda (nexp)
    (cond
     ((atom? nexp) nexp)
     ((eq? (car nexp) 'o+) (o+ (value (car (cdr nexp)))
                              (value (car (cdr (cdr nexp))))))
     ((eq? (car nexp) 'o*) (o* (value (car (cdr nexp)))
                              (value (car (cdr (cdr nexp))))))
     ((eq? (car nexp) 'o^) (o^ (value (car (cdr nexp)))
                               (value (car (cdr (cdr nexp))))))))) ;; => #<unspecified>

(value 13) ;; => 13
(value '(o+ 1 3)) ;; => 4
(value '(o+ 1 (o^ 3 4))) ;; => 82
(value 'cookie) ;; => cookie

(define 1st-sub-exp
  (lambda (aexp)
    (car (cdr aexp)))) ;; => #<unspecified>

(define 2nd-sub-exp
  (lambda (aexp)
    (car (cdr (cdr aexp))))) ;; => #<unspecified>

(define operator
  (lambda (aexp)
    (car aexp))) ;; => #<unspecified>

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

(value 13) ;; => 13
(value '(o+ 1 3)) ;; => 4
(value '(o+ 1 (o^ 3 4))) ;; => 82
(value 'cookie) ;; => cookie

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Eighth Commandment ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Use help functions to abstract from representations.

(define sero?
  (lambda (n)
    (null? n))) ;; => #<unspecified>

(define edd1
  (lambda (n)
    (cons '() n))) ;; => #<unspecified>

(define zub1
  (lambda (n)
    (cdr n))) ;; => #<unspecified>

(define o+
  (lambda (n m)
    (cond
     ((sero? m) n)
     (else (edd1 (o+ n (zub1 m))))))) ;; => #<unspecified>

(o+ '(()) '(() () ())) ;; => (() () () ())
