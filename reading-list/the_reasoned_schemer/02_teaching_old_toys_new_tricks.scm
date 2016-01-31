(load "/Users/mjhamrick/.org/reading-list/the_reasoned_schemer/mk.scm")
      (load "/Users/mjhamrick/.org/reading-list/the_reasoned_schemer/mkextraforms.scm")

      (let ((x (lambda (a) a))
            (y 'c))
        (x y))

      (run* (r)
            (fresh (y x)
                   (== `(,x ,y) r)))

      (run* (r)
            (fresh (v w)
                   (== (let ((x v)
                             (y w))
                         `(,x ,y))
                       r)))

      (car `(grape raisin pear))

      (car `(a c o r n))
      ;; Haven't defined caro yet... That's why it doesn't work.
      (define caro
        (lambda (p a)
          (fresh (d)
                 (== (cons a d) p))))
      (run* (r)
            (fresh ())
            (caro `(a c o r n) r))


      (run* (q)
            (caro `(a c o r n) 'a)
            (== #t q))

      (run* (r)
            (fresh (x y)
                   (caro `(,r ,y) x)
                   (== 'pear x)))

      (cons
       (car `(grape raison pear))
       (car `((a) (b) (c))))

      (run* (r)
            (fresh (x y)
                   (caro `(grape raisin pear) x)
                   (caro `((a) (b) (c)) y)
                   (== (cons x y) r)))

      (cdr `(grape raisin pear))

      (car (cdr `(a c o r n)))

      (define cdro
        (lambda (p d)
          (fresh (a)
                 (== (cons a d) p))))

      (run* (r)
            (fresh (v)
                   (cdro `(a c o r n) v)
                   (caro v r)))

      (cons
       (cdr `(grape raisin pear))
       (car `((a) (b) (c))))

      (run* (r)
            (fresh (x y)
                   (cdro `(grape raisin pear) x)
                   (caro `((a) (b) (c)) y)
                   (== (cons x y) r)))

      (run* (q)
            (cdro `(a c o r n) `(c o r n))
            (== #t q))

      (run* (x)
            (cdro `(c o r n) `(,x r n)))

      (run* (l)
            (fresh (x)
                   (cdro l `(c o r n))
                   (caro l x)
                   (== 'a x)))

      (define conso
        (lambda (a d p)
          (== (cons a d) p)))

      (run* (l)
            (conso `(a b c) `(d e) l))

      (run* (r)
            (fresh (x y z)
                   (== `(e a d ,x) r)
                   (conso y `(a ,z c) r)))

      (run* (x)
            (conso x `(a ,x c) `(d a ,x c)))

      (run* (l)
            (fresh (x)
                   (== `(d a ,x c) l)
                   (conso x `(a ,x c) l)))

      (run* (l)
            (fresh (d x y w s)
                   (conso w `(a n s) s)
                   (cdro l s)
                   (caro l x)
                   (== 'b x)
                   (cdro l d)
                   (caro d y)
                   (== 'e y)))

      (null? `(grape raisin pear))

      (null? `())

      (define nullo
        (lambda (x)
          (== `() x)))

      (run* (q)
            (nullo `(grape raisin pear))
            (== #t q))

      (run* (q)
            (nullo `())
            (== #t q))

      (run* (x)
            (nullo x))

      (eq? 'pear 'plum)

      (eq? 'plum 'plum)

      (define eqo
        (lambda (x y)
          (== x y)))

      (run* (q)
            (eqo 'pear 'plum)
            (== #t q))

      (run* (q)
            (eqo 'plum 'plum)
            (== #t q))

      `(split . pea)

      (pair? `((split) . pea))

      (pair? `())

      (pair? `(pear))

      (cdr `(pear))

      (cons `(split) 'pea)

      (run* (r)
            (fresh (x y)
                   (== (cons x (cons y 'salad)) r)))

      (define pairo
        (lambda (p)
          (fresh (a d)
                 (conso a d p))))

      (run* (q)
            (pairo (cons q q))
            (== #t q))

      (run* (q)
            (pairo `())
            (== #t q))

      (run* (q)
            (pairo 'pair)
            (== #t q))

      (run* (x)
            (pairo x))

      (run* (r)
            (pairo (cons r 'pear)))
