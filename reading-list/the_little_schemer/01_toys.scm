(load "ls.scm") ;; => #<unspecified>

(atom? 'atom) ;; => #t
(atom? 'turkey) ;; => #t
(atom? 1492) ;; => #t
(atom? 'u) ;; => #t
(atom? '*abc$) ;; => #t

(list? '(atom)) ;; => #t
(list? '(atom turkey or)) ;; => #t
;; (list? '(atom turkey) 'or) => not a list. doesn't even compile
(list? '((atom turkey) or)) ;; => #t

(define sexp?
  (lambda (x)
    (or (atom? x)
        (list? x)))) ;; => #<unspecified>

(sexp? 'xyz) ;; => #t
(sexp? '(x y z)) ;; => #t
(sexp? '((x y) z)) ;; => #t

(list? '(how are you doing so far)) ;; => #t
(define num-sexps?
  (lambda (sexp)
    (letrec
        ((num-sexps? (lambda (sexp acc)
                       (cond
                        ((null? sexp) acc)
                        ((atom? sexp) (add1 acc))
                        (else (num-sexps? (cdr sexp) (add1 acc)))))))
      (num-sexps? sexp 0)))) ;; => #<unspecified>
(num-sexps? '(how are you doing so far)) ;; => 6
(list? '(((how) are) ((you) (doing so)) far)) ;; => #t
(num-sexps? '(((how) are) ((you) (doing so)) far)) ;; => 3

(list? '()) ;; => #t
(atom? '()) ;; => #f
(list? '(() () () ())) ;; => #t

(car '(a b c)) ;; => a
(car '((a b c) x y z)) ;; => (a b c)
;; (car 'hotdog) => doesn't have a car. You can't ask for the car of an atom.
;; (car '()) => doesn't have a car. You can't ask for the car of the empty list.

;; The Law of Car
;; The primitive car is defined only for non-empty lists.

(car '(((hotdogs)) (and) (pickle) relish)) ;; => ((hotdogs))
(car '(((hotdogs)) (and) (pickle) relish)) ;; => ((hotdogs))
(car (car '(((hotdogs)) (and)))) ;; => (hotdogs)

(cdr '(a b c)) ;; => (b c)
(cdr '((a b c) x y z)) ;; => (x y z)
(cdr '(hamburger)) ;; => ()
(cdr '((x) t r)) ;; => (t r)
;; (cdr 'hotdogs) => doesn't have a cdr. You can't ask for the cdr of an atom.
;; (cdr '()) => doesn't have a cdr. You can't ask for the cdr of the empty list.

;; The Law of Cdr

;; The primitive cdr is defined only for non-lists. The cdr of any
;; non-empty list is always another list.

(car (cdr '((b) (x y) ((c))))) ;; => (x y)
(cdr (cdr '((b) (x y) ((c))))) ;; => (((c)))
;; (cdr (car '(a (b (c)) d))) => doesn't have an answer. You can't take the cdr of an atom.
(cons 'peanut '(butter and jelly)) ;; => (peanut butter and jelly)
(cons '(banana and) '(peanut butter and jelly)) ;; => ((banana and) peanut butter and jelly)
(cons '((help) this) '(is very ((hard) to learn))) ;; => (((help) this) is very ((hard) to learn))

;; The Law of Cons

;; The primitive cons takes two arguments. The second argument to cons must be a
;; list. The result is a list

(cons 'a (car '((b) c d))) ;; => (a b)
(cons 'a (cdr '((b) c d))) ;; => (a c d)
(null? '()) ;; => #t
(null?  (quote ())) ;; => #t
(null? '(a b c)) ;; => #f
(null? 'spaghetti) ;; => #f but really this question doesn't make any sense.

;; The Law of Null?

;; The primitive null? is defined only for lists.

(atom? 'Harry) ;; => #t
(atom? '(Harry had a heaf of apples)) ;; => #f
(atom? (car '(Harry had a heap of apples))) ;; => #t
(atom? (cdr '(Harry))) ;; => #f
(atom? (car (cdr '(swing low sweet cheery oat)))) ;; => #t
(atom? (car (cdr '(swing (low sweet) cheery oat))));; => #f
(eq? 'Harry 'Harry) ;; => #t
(eq? 'margarine 'butter) ;; => #f
(eq? '() '(strawberry)) ;; => #f
(eq? 6 7) ;; => #f

;; The Law of Eq?

;; The primitive eq? takes two arguments. Each must be a non-numeric atom.

(eq? (car '(Mary had a little lamb chop)) 'Mary) ;; => #t
(eq? (cdr '(soured milk)) 'milk) ;; => #f
(eq? (car '(beans beans we need jelly beans))
     (car (cdr '(beans beans we need jelly beans)))) ;; => #t

;; This space is reserved for JELLY STAINS!!!
