(load "ls.scm") ;; => #<unspecified>

;; Entries are a pair of lists whose first list is a set. Both lists must be of
;; equal length.

;; Ex.

'((appetizer entee beverage)
  (pate      boeuf vin)) ;; => ((appetizer entee beverage) (pate boeuf vin))

'((appetizer entree beverage)
  (beer      beer   beer)) ;; => ((appetizer entree beverage) (beer beer beer))

'((beverage  dessert)
  ((food is) (number one with us))) ;; => ((beverage dessert) ((food is) (number one with us)))

(define new-entry build) ;; => #<unspecified>

(define lookup-in-entry-help
  (lambda (name names values entry-f)
    (cond
     ((null? names) (entry-f name))
     ((eq? (first names) name) (first values))
     (else (lookup-in-entry-help name
                                 (cdr names)
                                 (cdr values)
                                 entry-f))))) ;; => #<unspecified>

(define lookup-in-entry
  (lambda (name entry entry-f)
    (lookup-in-entry-help name
                          (first entry)
                          (second entry)
                          entry-f))) ;; => #<unspecified>

(lookup-in-entry 'entree
                 '((appetizer entree beverage)
                   (food      tastes good)) (lambda (x) x)) ;; => tastes

(lookup-in-entry 'not-entree
                 '((appetizer entree beverage)
                   (food      tastes good)) (lambda (x) (cons x '(was-not-found)))) ;; => (not-entree was-not-found)


;; A table is a list of entries. A simple example is the empty table represented
;; by '(). Another example is as follows.

'(((appetizer entree beverage)
   (pate      boeuf  vin))

  ((beverage  dessert)
   ((food is) (number one with us)))) ;; => (((appetizer entree beverage) (pate boeuf vin)) ((beverage dessert) ((food is) (number one with us))))

(define extend-table cons) ;; => #<unspecified>

(define lookup-in-table
  (lambda (name table table-f)
    (cond
     ((null? table) (table-f name))
     (else (lookup-in-entry name
                            (first table)
                            (lambda (name)
                              (lookup-in-table name
                                               (rest table)
                                               table-f))))))) ;; => #<unspecified>

(lookup-in-table 'entree
                 '(
                   ((entree    dessert)
                    (spaghetti spumoni))

                   ((appetizer entree beverage)
                    (food      tastes good)))
                 (lambda (name) (cons name '(was-not-found)))) ;; => spaghetti

(lookup-in-table 'appetizer
                 '(
                   ((entree    dessert)
                    (spaghetti spumoni))

                   ((appetizer entree beverage)
                    (food      tastes good)))
                 (lambda (name) (cons name '(was-not-found)))) ;; => food

(lookup-in-table 'not-appetizer
                 '(
                   ((entree    dessert)
                    (spaghetti spumoni))

                   ((appetizer entree beverage)
                    (food      tastes good)))
                 (lambda (name) (cons name '(was-not-found)))) ;; => (not-appetizer was-not-found)

(define *const
  (lambda (e table)
    (cond
     ((number? e) e)
     ((eq? e #t) #t)
     ((eq? e #f) #f)
     (else
      (build 'primitive e))))) ;; => #<unspecified>

(define text-of second) ;; => #<unspecified>

(define initial-table
  (lambda (name)
    (car '()))) ;; => #<unspecified>

(define *identifier
  (lambda (e table)
    (lookup-in-table e table initial-table))) ;; => #<unspecified>

(define atom-to-action
  (lambda (e)
    (cond
     ((number? e) *const)
     ((eq? e #t) *const)
     ((eq? e #f) *const)
     ((eq? e 'cons) *const)
     ((eq? e 'car) *const)
     ((eq? e 'cdr) *const)
     ((eq? e 'null?) *const)
     ((eq? e 'eq?) *const)
     ((eq? e 'atom?) *const)
     ((eq? e 'zero?) *const)
     ((eq? e 'add1) *const)
     ((eq? e 'sub1) *const)
     ((eq? e 'number?) *const)
     (else *identifier)))) ;; => #<unspecified>

(define list-to-action
  (lambda (e)
    (cond
     ((atom? (car e))
      (cond
       ((eq? (car e) 'quote) *quote)
       ((eq? (car e) 'lambda) *lambda)
       ((eq? (car e) 'cond) *cond)
       (else *application)))
     (else *application)))) ;; => #<unspecified>



(define *quote
  (lambda (e table)
    (text-of e))) ;; => #<unspecified>

(define *lambda
  (lambda (e table)
    (build 'non-primitive
           (cons table (cdr e))))) ;; => #<unspecified>

(define else?
  (lambda (x)
    (cond
     ((atom? x) (eq? x 'else))
     (else #f)))) ;; => #<unspecified>

(define question-of first) ;; => #<unspecified>
(define answer-of second) ;; => #<unspecified>

(define evcon
  (lambda (lines table)
    (cond
     ((else? (question-of (car lines))) (meaning (answer-of (car lines)) table))
     ((meaning (question-of (car lines)) table) (meaning (answer-of (car lines)) table))
     (else (evcon (cdr lines) table))))) ;; => #<unspecified>

(define cond-lines-of cdr) ;; => #<unspecified>

(define *cond
  (lambda (e table)
    (evcon (cond-lines-of e) table))) ;; => #<unspecified>

(define evlis
  (lambda (args table)
    (cond
     ((null? args) '())
     (else (cons (meaning (car args) table)
                 (evlis (cdr args) table)))))) ;; => #<unspecified>

(define function-of car) ;; => #<unspecified>
(define arguments-of cdr) ;; => #<unspecified>

(define primitive?
  (lambda (l)
    (eq? (first l) 'primitive))) ;; => #<unspecified>

(define non-primitive?
  (lambda (l)
    (eq? (first l) 'non-primitive))) ;; => #<unspecified>

(define :atom?
  (lambda (x)
    (cond
     ((atom? x) #t)
     ((null? x) #f)
     ((eq? (car x) 'primitive) #t)
     ((eq? (car x) 'non-primitive) #t)
     (else #f)))) ;; => #<unspecified>

(define apply-primitive
  (lambda (name vals)
    (cond
     ((eq? name 'cons) (cons (first vals) (second vals)))
     ((eq? name 'car) (car (first vals)))
     ((eq? name 'cdr) (cdr (first vals)))
     ((eq? name 'null?) (null? (first vals)))
     ((eq? name 'eq?) (eq? (first vals) (second vals)))
     ((eq? name 'atom?) (:atom? (first vals)))
     ((eq? name 'zero?) (zero? (first vals)))
     ((eq? name 'add1) (add1 (first vals)))
     ((eq? name 'sub1) (sub1 (first vals)))
     ((eq? name 'number?) (number? (first vals)))))) ;; => #<unspecified>

(define table-of first) ;; => #<unspecified>
(define formals-of second) ;; => #<unspecified>
(define body-of third) ;; => #<unspecified>

(define apply-closure
  (lambda (closure vals)
    (meaning (body-of closure)
             (extend-table (new-entry (formals-of closure)
                                      vals)
                           (table-of closure))))) ;; => #<unspecified>

(define apply
  (lambda (fun vals)
    (cond
     ((primitive? fun) (apply-primitive (second fun)
                                        vals))
     ((non-primitive? fun) (apply-closure (second fun)
                                          vals))))) ;; => #<unspecified>

(define *application
  (lambda (e table)
    (apply
     (meaning (function-of e) table)
     (evlis (arguments-of e) table)))) ;; => #<unspecified>

(define list-to-action
  (lambda (e)
    (cond
     ((atom? (car e)) (cond
                       ((eq? (car e) 'quote) *quote)
                       ((eq? (car e) 'lambda) *lambda)
                       ((eq? (car e) 'cond) *cond)
                       (else *application)))
     (else *application)))) ;; => #<unspecified>

(define expression-to-action
  (lambda (e)
    (cond
     ((atom? e) (atom-to-action e))
     (else (list-to-action e))))) ;; => #<unspecified>

(define meaning
  (lambda (e table)
    ((expression-to-action e) e table))) ;; => #<unspecified>

(define value
  (lambda (e)
    (meaning e '())))

(meaning '(lambda (x) (cons x y)) '(((y   z)
                                     ((8) 9)))) ;; => (non-primitive ((((y z) ((8) 9))) (x) (cons x y)))

(value '(cons 'a (cons 'b (cons 'c '())))) ;; => (a b c)
(value '(car (quote (a b c)))) ;; => a
(value '(quote (car (quote (a b c))))) ;; => (car (quote (a b c)))
(value '(add1 6)) ;; => 7
(value 6) ;; => 6
(value '(quote nothing)) ;; => nothing
(value '((lambda (nothing)
           (cons nothing (quote ())))
         (quote
          (from nothing comes something)))) ;; => ((from nothing comes something))
(value '((lambda (nothing)
           (cond
            (nothing (quote something))
            (else (quote nothing))))
         #t)) ;; => something


;; Using the Y-Combinator with value. =)
(value '(((lambda (le)
            ((lambda (f) (f f))
             (lambda (f)
               (le (lambda (x) ((f f) x))))))
          (lambda (length)
            (lambda (l)
              (cond
               ((null? l) 0)
               (else (add1 (length (cdr l)))))))
          ) '(a b c))) ;; => 3

;; Y-combinator for adding. Note that it takes x and y since addition needs two
;; arguments
(value '(((lambda (le)
            ((lambda (f) (f f))
             (lambda (f)
               (le (lambda (x y) ((f f) x y))))))
          (lambda (add)
            (lambda (n m)
              (cond
               ((zero? m) n)
               (else (add1 (add n (sub1 m))))))))
         2 3)) ;; => 5

(value '(
         ;; Fib via Y with 1 arg
         ((lambda (le)
            ((lambda (f) (f f))
             (lambda (f)
               (le (lambda (x) ((f f) x))))))
          (lambda (fib)
            (lambda (n)
              (cond
               ((zero? n) 0)
               ((zero? (sub1 n)) 1)
               (else
                ;; sum via Y with 2 args
                (((lambda (le)
                    ((lambda (f) (f f))
                     (lambda (f)
                       (le (lambda (x y) ((f f) x y))))))
                  (lambda (add)
                    (lambda (n m)
                      (cond
                       ((zero? m) n)
                       (else (add1 (add n (sub1 m))))))))
                 (fib (sub1 n))
                 (fib (sub1 (sub1 n)))))))))
         10)) ;; => 55
