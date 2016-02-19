(load "mk.scm")
(load "mkextraforms.scm")
(load "previous_chapters.scm")

(define my-list?
  (lambda (l)
    (cond
     ((null? l) #t)
     ((pair? l) (my-list? (cdr l)))
     (else #f)))) ;; => #<unspecified>

(my-list? `()) ;; => #t

(my-list? 's) ;; => #f

(my-list? `(d a t e . s)) ;; => #f

(define listo
  (lambda (l)
    (conde
     ((nullo l) S)
     ((pairo l) (fresh (d)
                       (cdro l d)
                       (listo d)))
     (else U)))) ;; => #<unspecified>

(run* (x)
      (listo `(a b ,x d))) ;; => (_.0)

(run 1 (x)
     (listo `(a b c . ,x))) ;; => (())

(run 5 (x)
     (listo `(a b c . ,x)))
#|
(()
 (_.0)
 (_.0 _.1)
 (_.0 _.1 _.2)
 (_.0 _.1 _.2 _.3))
|#

(define lol?
  (lambda (l)
    (cond
     ((null? l) #t)
     ((my-list? (car l)) (lol? (cdr l)))
     (else #f)))) ;; => #<unspecified>

(define lolo
  (lambda (l)
    (conde
     ((nullo l) S)
     ((fresh (a)
             (caro l a)
             (listo a)) (fresh (d)
                               (cdro l d)
                               (lolo d)))
     (else U)))) ;; => #<unspecified>

(run 1 (l)
     (lolo l)) ;; => (())

(run* (q)
      (fresh (x y)
             (lolo `((a b) (,x c) (d ,y)))
             (== #t q))) ;; => (#t)

(run 1 (q)
     (fresh (x)
            (lolo `((a b) . ,x))
            (== #t q))) ;; => (#t)

(run 1 (x)
     (lolo `((a b) (c d) . ,x))) ;; => (())

(run 5 (x)
     (lolo `((a b) (c d) . ,x)))
#|
(
 ()
 (())
 (() ())
 (() () ())
 (() () () ())
 )
|#

(define twinso
  (lambda (s)
    (fresh (x y)
           (conso x y s)
           (conso x `() y)))) ;; => #<unspecified>

(run* (q)
      (twinso `(tofu tofu))
      (== #t q)) ;; => (#t)

(run* (z)
      (twinso `(,z tofu))) ;; => (tofu)

(define twinso
  (lambda (s)
    (fresh (x)
           (== `(,x ,x) s)))) ;; => #<unspecified>

(run* (q)
      (twinso `(tofu tofu))
      (== #t q)) ;; => (#t)

(run* (z)
      (twinso `(,z tofu))) ;; => (tofu)

(define loto
  (lambda (l)
    (conde
     ((nullo l) S)
     ((fresh (a)
             (caro l a)
             (twinso a)) (fresh (d)
                                (cdro l d)
                                (loto d)))
     (else U)))) ;; => #<unspecified>

(run 1 (z)
     (loto `((g g) . ,z))) ;; => (())

(run 5 (z)
     (loto `((g g) . ,z))) ;; =>
#|
(
 ()
 ((_.0 _.0))
 ((_.0 _.0) (_.1 _.1))
 ((_.0 _.0) (_.1 _.1) (_.2 _.2))
 ((_.0 _.0) (_.1 _.1) (_.2 _.2) (_.3 _.3))
 )
|#

(run 5 (r)
     (fresh (w x y z)
            (loto `((g g) (e ,w) (,x ,y) . ,z))
            (== `(,w (,x ,y) ,z) r))) ;; =>
#|
(
 (e (_.0 _.0) ())
 (e (_.0 _.0) ((_.1 _.1)))
 (e (_.0 _.0) ((_.1 _.1) (_.2 _.2)))
 (e (_.0 _.0) ((_.1 _.1) (_.2 _.2) (_.3 _.3)))
 (e (_.0 _.0) ((_.1 _.1) (_.2 _.2) (_.3 _.3) (_.4 _.4)))
 )
|#

(run 3 (out)
     (fresh (w x y z)
            (== `((g g) (e ,w) (,x ,y) . ,z) out)
            (loto out))) ;; =>
#|
(
 ((g g) (e e) (_.0 _.0))
 ((g g) (e e) (_.0 _.0) (_.1 _.1))
 ((g g) (e e) (_.0 _.0) (_.1 _.1) (_.2 _.2))
 )
|#

(define listofo
  (lambda (predo l)
    (conde
     ((nullo l) S)
     ((fresh (a)
             (caro l a)
             (predo a)) (fresh (d)
                               (cdro l d)
                               (listofo predo d)))
     (else U)))) ;; => #<unspecified>

(run 3 (out)
     (fresh (w x y z)
            (== `((g g) (e ,w) (,x ,y) . ,z) out)
            (listofo twinso out))) ;; =>
#|
(
 ((g g) (e e) (_.0 _.0))
 ((g g) (e e) (_.0 _.0) (_.1 _.1))
 ((g g) (e e) (_.0 _.0) (_.1 _.1) (_.2 _.2))
 )

|#

(define loto
  (lambda (l)
    (listofo twino l))) ;; => #<unspecified>

(define eq-car?
  (lambda (l x)
    (eq? (car l) x))) ;; => #<unspecified>

(define member?
  (lambda (x l)
    (cond
     ((null? l) #f)
     ((eq-car? l x) #t)
     (else (member? x (cdr l)))))) ;; => #<unspecified>

(member? 'olive '(virgin olive oil)) ;; => #t

(define eq-caro
  (lambda (l x)
    (caro l x))) ;; => #<unspecified>

(define membero
  (lambda (x l)
    (conde
     ((nullo l) U)
     ((eq-caro l x) S)
     (else (fresh (d)
                  (cdro l d)
                  (membero x d)))))) ;; => #<unspecified>

(run* (q)
      (membero 'olive `(virgin olive oil))
      (== #t q)) ;; => (#t)

(run 1 (y)
     (membero y `(hummus with pita))) ;; => (hummus)

(run 1 (y)
     (membero y `(with pita))) ;; => (with)

(run 1 (y)
     (membero y `(pita))) ;; => (pita)

(run 1 (y)
     (membero y `())) ;; => ()

(run* (y)
      (membero y `(hummus with pita))) ;; => (hummus with pita)

(define my-identity
  (lambda (l)
    (run* (y)
          (membero y l)))) ;; => #<unspecified>

(run* (x)
      (membero 'e `(pasta ,x fagioli))) ;; => (e)

(run 1 (x)
     (membero 'e `(pasta e ,x fagioli))) ;; => (_.0)

(run 1 (x)
     (membero 'e `(pasta ,x e fagioli))) ;; => (e)

(run* (r)
      (fresh (x y)
             (membero 'e `(pasta ,x fagioli ,y))
             (== `(,x ,y) r))) ;; => ((e _.0) (_.0 e))

(run 1 (l)
     (membero 'tofu l)) ;; => ((tofu . _.0))

(run 5 (l)
     (membero 'tofu l)) ;; =>
#|
(
 (tofu . _.0)
 (_.0 tofu . _.1)
 (_.0 _.1 tofu . _.2)
 (_.0 _.1 _.2 tofu . _.3)
 (_.0 _.1 _.2 _.3 tofu . _.4)
 )
|#

(define pmembero
  (lambda (x l)
    (conde
     ((nullo l) U)
     ((eq-caro l x) (cdro l `()))
     (else (fresh (d)
                  (cdro l d)
                  (pmembero x d)))))) ;; => #<unspecified>

(run 5 (l)
     (pmembero 'tofu l)) ;; =>
#|
(
 (tofu)
 (_.0 tofu)
 (_.0 _.1 tofu)
 (_.0 _.1 _.2 tofu)
 (_.0 _.1 _.2 _.3 tofu)
 )
|#

(run* (q)
      (pmembero 'tofu `(a b tofu d tofu))
      (== #t q)) ;; => (#t)

(define pmembero
  (lambda (x l)
    (conde
     ((nullo l) U)
     ((eq-caro l x) (cdro l `()))
     ((eq-caro l x) S)
     (else (fresh (d)
                  (cdro l d)
                  (pmembero x d)))))) ;; => #<unspecified>

(run* (q)
      (pmembero 'tofu `(a b todu d tofu))
      (== #t q)) ;; => (#t #t)

(define pmembero
  (lambda (x l)
    (conde
     ((nullo l) U)
     ((eq-caro l x) (cdro l `()))
     ((eq-caro l x) (fresh (a d)
                           (cdro l `(,a . ,d))))
     (else (fresh (d)
                  (cdro l d)
                  (pmembero x d)))))) ;; => #<unspecified>

(run* (q)
      (pmembero 'tofu `(a b todu d tofu))
      (== #t q)) ;; => (#t)

(run 12 (l)
     (pmembero 'tofu l)) ;; =>
#|
(
 (tofu)
 (tofu _.0 . _.1)
 (_.0 tofu)
 (_.0 tofu _.1 . _.2)
 (_.0 _.1 tofu)
 (_.0 _.1 tofu _.2 . _.3)
 (_.0 _.1 _.2 tofu)
 (_.0 _.1 _.2 tofu _.3 . _.4)
 (_.0 _.1 _.2 _.3 tofu)
 (_.0 _.1 _.2 _.3 tofu _.4 . _.5)
 (_.0 _.1 _.2 _.3 _.4 tofu)
 (_.0 _.1 _.2 _.3 _.4 tofu _.5 . _.6)
 )
|#

(define pmembero
  (lambda (x l)
    (conde
     ((eq-caro l x) (fresh (a d)
                           (cdro l `(,a . ,d))))
     ((eq-caro l x) (cdro l `()))
     (else (fresh (d)
                  (cdro l d)
                  (pmembero x d)))))) ;; => #<unspecified>

(run 12 (l)
     (pmembero 'tofu l)) ;; =>
#|
(
 (tofu _.0 . _.1)
 (tofu)
 (_.0 tofu _.1 . _.2)
 (_.0 tofu)
 (_.0 _.1 tofu _.2 . _.3)
 (_.0 _.1 tofu)
 (_.0 _.1 _.2 tofu _.3 . _.4)
 (_.0 _.1 _.2 tofu)
 (_.0 _.1 _.2 _.3 tofu _.4 . _.5)
 (_.0 _.1 _.2 _.3 tofu)
 (_.0 _.1 _.2 _.3 _.4 tofu _.5 . _.6)
 (_.0 _.1 _.2 _.3 _.4 tofu)
 )
|#


(define first-value
  (lambda (l)
    (run 1 (y)
         (membero y l)))) ;; => #<unspecified>

(first-value `(pasta e fagioli)) ;; => (pasta)

(define memberrevo
  (lambda (x l)
    (conde
     ((nullo l) U)
     (S (fresh (d)
               (cdro l d)
               (memberrevo x d)))
     (else (eq-caro l x))))) ;; => #<unspecified>

(run* (x)
      (memberrevo x `(pasta e fagioli))) ;; => (fagioli e pasta)

(define reverse-list
  (lambda (l)
    (run* (y)
          (memberorevo y l)))) ;; => #<unspecified>
