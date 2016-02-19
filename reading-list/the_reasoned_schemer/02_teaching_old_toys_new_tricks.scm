(load "mk.scm")
(load "mkextraforms.scm")

(let ((x (lambda (a) a))
      (y 'c))
  (x y)) ;; => c

(run* (r)
      (fresh (y x)
             (== `(,x ,y) r))) ;; => ((_.0 _.1))

(run* (r)
      (fresh (v w)
             (== (let ((x v)
                       (y w))
                   `(,x ,y))
                 r))) ;; => ((_.0 _.1))

(car `(grape raisin pear)) ;; => grape

(car `(a c o r n)) ;; => a
;; Haven't defined caro yet... That's why it doesn't work.
(define caro
  (lambda (p a)
    (fresh (d)
           (== (cons a d) p)))) ;; => #<unspecified>
(run* (r)
      (fresh ())
      (caro `(a c o r n) r)) ;; => (a)


(run* (q)
      (caro `(a c o r n) 'a)
      (== #t q)) ;; => (#t)

(run* (r)
      (fresh (x y)
             (caro `(,r ,y) x)
             (== 'pear x))) ;; => (pear)

(cons
 (car `(grape raison pear))
 (car `((a) (b) (c)))) ;; => (grape a)

(run* (r)
      (fresh (x y)
             (caro `(grape raisin pear) x)
             (caro `((a) (b) (c)) y)
             (== (cons x y) r))) ;; => ((grape a))

(cdr `(grape raisin pear)) ;; => (raisin pear)

(car (cdr `(a c o r n))) ;; => c

(define cdro
  (lambda (p d)
    (fresh (a)
           (== (cons a d) p)))) ;; => #<unspecified>

(run* (r)
      (fresh (v)
             (cdro `(a c o r n) v)
             (caro v r))) ;; => (c)

(cons
 (cdr `(grape raisin pear))
 (car `((a) (b) (c)))) ;; => ((raisin pear) a)

(run* (r)
      (fresh (x y)
             (cdro `(grape raisin pear) x)
             (caro `((a) (b) (c)) y)
             (== (cons x y) r))) ;; => (((raisin pear) a))

(run* (q)
      (cdro `(a c o r n) `(c o r n))
      (== #t q)) ;; => (#t)

(run* (x)
      (cdro `(c o r n) `(,x r n))) ;; => (o)

(run* (l)
      (fresh (x)
             (cdro l `(c o r n))
             (caro l x)
             (== 'a x))) ;; => ((a c o r n))

(define conso
  (lambda (a d p)
    (== (cons a d) p))) ;; => #<unspecified>

(run* (l)
      (conso `(a b c) `(d e) l)) ;; => (((a b c) d e))

(run* (r)
      (fresh (x y z)
             (== `(e a d ,x) r)
             (conso y `(a ,z c) r))) ;; => ((e a d c))

(run* (x)
      (conso x `(a ,x c) `(d a ,x c))) ;; => (d)

(run* (l)
      (fresh (x)
             (== `(d a ,x c) l)
             (conso x `(a ,x c) l))) ;; => ((d a d c))

(run* (l)
      (fresh (d x y w s)
             (conso w `(a n s) s)
             (cdro l s)
             (caro l x)
             (== 'b x)
             (cdro l d)
             (caro d y)
             (== 'e y))) ;; => ((b e a n s))

(null? `(grape raisin pear)) ;; => #f

(null? `()) ;; => #t

(define nullo
  (lambda (x)
    (== `() x))) ;; => #<unspecified>

(run* (q)
      (nullo `(grape raisin pear))
      (== #t q)) ;; => ()

(run* (q)
      (nullo `())
      (== #t q)) ;; => (#t)

(run* (x)
      (nullo x)) ;; => (())

(eq? 'pear 'plum) ;; => #f

(eq? 'plum 'plum) ;; => #t

(define eqo
  (lambda (x y)
    (== x y))) ;; => #<unspecified>

(run* (q)
      (eqo 'pear 'plum)
      (== #t q)) ;; => ()

(run* (q)
      (eqo 'plum 'plum)
      (== #t q)) ;; => (#t)

`(split . pea) ;; => (split . pea)

(pair? `((split) . pea)) ;; => #t

(pair? `()) ;; => #f

(pair? `(pear)) ;; => #t

(cdr `(pear)) ;; => ()

(cons `(split) 'pea) ;; => ((split) . pea)

(run* (r)
      (fresh (x y)
             (== (cons x (cons y 'salad)) r))) ;; => ((_.0 _.1 . salad))

(define pairo
  (lambda (p)
    (fresh (a d)
           (conso a d p)))) ;; => #<unspecified>

(run* (q)
      (pairo (cons q q))
      (== #t q)) ;; => (#t)

(run* (q)
      (pairo `())
      (== #t q)) ;; => ()

(run* (q)
      (pairo 'pair)
      (== #t q)) ;; => ()

(run* (x)
      (pairo x)) ;; => ((_.0 . _.1))

(run* (r)
      (pairo (cons r 'pear))) ;; => (_.0)
