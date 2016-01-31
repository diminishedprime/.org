(load "/Users/mjhamrick/.org/reading-list/the_reasoned_schemer/mk.scm")
(load "/Users/mjhamrick/.org/reading-list/the_reasoned_schemer/mkextraforms.scm")
(load "/Users/mjhamrick/.org/reading-list/the_reasoned_schemer/previous_chapters.scm")

(define list?
  (lambda (l)
    (cond
     ((null? l) #t)
     ((pair? l) (list? (cdr l)))
     (else #f))))

(list? `())

(list? 's)

(list? `(d a t e . s))

(define listo
  (lambda (l)
    (conde
     ((nullo l) S)
     ((pairo l) (fresh (d)
                       (cdro l d)
                       (listo d)))
     (else U))))

(run* (x)
      (listo `(a b ,x d)))

(run 1 (x)
     (listo `(a b c . ,x)))

(run 5 (x)
     (listo `(a b c . ,x)))

(define lol?
  (lambda (l)
    (cond
     ((null? l) #t)
     ((list? (car l)) (lol? (cdr l)))
     (else #f))))

(define lolo
  (lambda (l)
    (conde
     ((nullo l) S)
     ((fresh (a)
             (caro l a)
             (listo a)) (fresh (d)
                               (cdro l d)
                               (lolo d)))
     (else U))))

(run 1 (l)
     (lolo l))

(run* (q)
      (fresh (x y)
             (lolo `((a b) (,x c) (d ,y)))
             (== #t q)))

(run 1 (q)
     (fresh (x)
            (lolo `((a b) . ,x))
            (== #t q)))

(run 1 (x)
     (lolo `((a b) (c d) . ,x)))

(run 5 (x)
     (lolo `((a b) (c d) . ,x)))

(define twinso
  (lambda (s)
    (fresh (x y)
           (conso x y s)
           (conso x `() y))))

(run* (q)
      (twinso `(tofu tofu))
      (== #t q))

(run* (z)
      (twinso `(,z tofu)))

(define twinso
  (lambda (s)
    (fresh (x)
           (== `(,x ,x) s))))

(run* (q)
      (twinso `(tofu tofu))
      (== #t q))

(run* (z)
      (twinso `(,z tofu)))

(define loto
  (lambda (l)
    (conde
     ((nullo l) S)
     ((fresh (a)
             (caro l a)
             (twinso a)) (fresh (d)
                                (cdro l d)
                                (loto d)))
     (else U))))

(run 1 (z)
     (loto `((g g) . ,z)))

(run 5 (z)
     (loto `((g g) . ,z)))

(run 5 (r)
     (fresh (w x y z)
            (loto `((g g) (e ,w) (,x ,y) . ,z))
            (== `(,w (,x ,y) ,z) r)))

(run 3 (out)
     (fresh (w x y z)
            (== `((g g) (e ,w) (,x ,y) . ,z) out)
            (loto out)))

(define listofo
  (lambda (predo l)
    (conde
     ((nullo l) S)
     ((fresh (a)
             (caro l a)
             (predo a)) (fresh (d)
                               (cdro l d)
                               (listofo predo d)))
     (else U))))

(run 3 (out)
     (fresh (w x y z)
            (== `((g g) (e ,w) (,x ,y) . ,z) out)
            (listofo twinso out)))

(define loto
  (lambda (l)
    (listofo twino l)))

(define eq-car?
  (lambda (l x)
    (eq? (car l) x)))

(define member?
  (lambda (x l)
    (cond
     ((null? l) #f)
     ((eq-car? l x) #t)
     (else (member? x (cdr l))))))

(member? 'olive '(virgin olive oil))

(define eq-caro
  (lambda (l x)
    (caro l x)))

(define membero
  (lambda (x l)
    (conde
     ((nullo l) U)
     ((eq-caro l x) S)
     (else (fresh (d)
                  (cdro l d)
                  (membero x d))))))

(run* (q)
      (membero 'olive `(virgin olive oil))
      (== #t q))

(run 1 (y)
     (membero y `(hummus with pita)))

(run 1 (y)
     (membero y `(with pita)))

(run 1 (y)
     (membero y `(pita)))

(run 1 (y)
     (membero y `()))

(run* (y)
      (membero y `(hummus with pita)))

(define identity
  (lambda (l)
    (run* (y)
          (membero y l))))

(run* (x)
      (membero 'e `(pasta ,x fagioli)))

(run 1 (x)
     (membero 'e `(pasta e ,x fagioli)))

(run 1 (x)
     (membero 'e `(pasta ,x e fagioli)))

(run* (r)
      (fresh (x y)
             (membero 'e `(pasta ,x fagioli ,y))
             (== `(,x ,y) r)))

(run 1 (l)
     (membero 'tofu l))

(run 5 (l)
     (membero 'tofu l))

(define pmembero
  (lambda (x l)
    (conde
     ((nullo l) U)
     ((eq-caro l x) (cdro l `()))
     (else (fresh (d)
                  (cdro l d)
                  (pmembero x d))))))

(run 5 (l)
     (pmembero 'tofu l))

(run* (q)
      (pmembero 'tofu `(a b tofu d tofu))
      (== #t q))

(define pmembero
  (lambda (x l)
    (conde
     ((nullo l) U)
     ((eq-caro l x) (cdro l `()))
     ((eq-caro l x) S)
     (else (fresh (d)
                  (cdro l d)
                  (pmembero x d))))))

(run* (q)
      (pmembero 'tofu `(a b todu d tofu))
      (== #t q))

(define pmembero
  (lambda (x l)
    (conde
     ((nullo l) U)
     ((eq-caro l x) (cdro l `()))
     ((eq-caro l x) (fresh (a d)
                           (cdro l `(,a . ,d))))
     (else (fresh (d)
                  (cdro l d)
                  (pmembero x d))))))

(run* (q)
      (pmembero 'tofu `(a b todu d tofu))
      (== #t q))

(run 12 (l)
     (pmembero 'tofu l))

(define pmembero
  (lambda (x l)
    (conde
     ((eq-caro l x) (fresh (a d)
                           (cdro l `(,a . ,d))))
     ((eq-caro l x) (cdro l `()))
     (else (fresh (d)
                  (cdro l d)
                  (pmembero x d))))))

(run 12 (l)
     (pmembero 'tofu l))


(define first-value
  (lambda (l)
    (run 1 (y)
         (membero y l))))

(first-value `(pasta e fagioli))

(define memberrevo
  (lambda (x l)
    (conde
     ((nullo l) U)
     (S (fresh (d)
               (cdro l d)
               (memberrevo x d)))
     (else (eq-caro l x)))))

(run* (x)
      (memberrevo x `(pasta e fagioli)))

(define reverse-list
  (lambda (l)
    (run* (y)
          (memberorevo y l))))
