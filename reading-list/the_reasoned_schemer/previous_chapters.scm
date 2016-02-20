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
