(define U fail)
(define S succeed)

(define caro
        (lambda (p a)
          (fresh (d)
                 (== (cons a d) p))))

(define cdro
  (lambda (p d)
    (fresh (a)
           (== (cons a d) p))))

(define conso
  (lambda (a d p)
    (== (cons a d) p)))

(define nullo
  (lambda (x)
    (== `() x)))

(define eqo
  (lambda (x y)
    (== x y)))

(define pairo
  (lambda (p)
    (fresh (a d)
           (conso a d p))))

(define eq-car?
  (lambda (l x)
    (eq? (car l) x)))

(define eq-caro
  (lambda (l x)
    (caro l x)))

(define teacupo
  (lambda (x)
    (conde
     ((== 'tea x) S)
     ((== 'cup x) S)
     (else U))))

(define bit-xoro
  (lambda (x y r)
    (conde
     ((== 0 x) (== 0 y) (== 0 r))
     ((== 1 x) (== 0 y) (== 1 r))
     ((== 0 x) (== 1 y) (== 1 r))
     ((== 1 x) (== 1 y) (== 0 r))
     (else U))))

(define bit-ando
  (lambda (x y r)
    (conde
     ((== 0 x) (== 0 y) (== 0 r))
     ((== 1 x) (== 0 y) (== 0 r))
     ((== 0 x) (== 1 y) (== 0 r))
     ((== 1 x) (== 1 y) (== 1 r))
     (else U))))

(define half-addero
  (lambda (x y r c)
    (all
     (bit-xoro x y r)
     (bit-ando x y c))))

(define full-addero
  (lambda (b x y r c)
    (fresh (w xy wz)
           (half-addero x y w xy)
           (half-addero w b r wz)
           (bit-xoro xy wz c))))

(define poso
  (lambda (n)
    (fresh (a d)
           (== `(,a . ,d) n))))

(define >1o
  (lambda (n)
    (fresh (a ad dd)
           (== `(,a ,ad . ,dd) n))))

(define gen-addero
  (lambda (d n m r)
    (fresh (a b c e x y z)
           (== `(,a . ,x) n)
           (== `(,b . ,y) m) (poso y)
           (== `(,c . ,z) r) (poso z)
           (alli
            (full-addero d a b c e)
            (addero e x y z)))))

(define addero
  (lambda (d n m r)
    (condi
     ((== 0 d) (== '() m) (== n r))
     ((== 0 d) (== '() n) (== m r) (poso m))
     ((== 1 d) (== '() m) (addero 0 n '(1) r))
     ((== 1 d) (== '() n) (poso m) (addero 0 '(1) m r))
     ((== '(1) n) (== '(1) m) (fresh (a c)
                                     (== `(,a ,c) r)
                                     (full-addero d 1 1 a c)))
     ((== '(1) n) (gen-addero d n m r))
     ((== '(1) m) (>1o n) (>1o r) (addero d '(1) n r))
     ((>1o n) (gen-addero d n m r))
     (else U))))

(define +o
  (lambda (n m k)
    (addero 0 n m k)))

(define -o
  (lambda (n m k)
    (+o m k n)))

(define appendo
  (lambda (l s out)
    (conde
     ((nullo l) (== s out))
     (else (fresh (a d res)
                  (caro l a)
                  (cdro l d)
                  (appendo d s res)
                  (conso a res out))))))
