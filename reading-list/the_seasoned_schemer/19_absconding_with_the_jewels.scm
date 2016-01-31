(load "ss.scm")

(define deep
  (lambda (m)
    (cond
     ((zero? m) 'pizza)
     (else (cons (deep (sub1 m)) '())))))

(test (and
       (same? '((((((pizza))))))
              (deep 6))))

(define toppings)
(define deepB
  (lambda (m)
    (cond
     ((zero? m)
      (call/cc
       (lambda (jump)
         (set! toppings jump)
         'pizza)))
     (else (cons (deepB (sub1 m)) '())))))

(test (and
       (same? '((((((pizza))))))
              (deepB 6))))
(deepB 6)
(toppings 'cake)
(toppings 'pizza)

(cons (toppings 'cake) '())
;; This immedietly returns the six layer cake and ignores the cons.
;; Because it's a continuation--that's sorta the whole point.

(deepB 4)
(toppings 'cake)
toppings
;; toppings is a continuation here

(define deep&co
  (lambda (m k)
    (cond
     ((zero? m) (k 'pizza))
     (else
      (deep&co (sub1 m)
               (lambda (x)
                 (k (cons x '()))))))))
(deep&co 0 (lambda (x) x))
(deep&co 6 (lambda (x) x))
(deep&co 2 (lambda (x) x))

(define deep&coB
  (lambda (m k)
    (cond
     ((zero? m)
      (begin
        (set! toppings k)
        (k 'pizza)))
     (else
      (deep&coB (sub1 m) (lambda (x)
                           (k (cons x '()))))))))

(deep&coB 2 (lambda (x) x))
(deep&coB 4 (lambda (x) x))
toppings
;; this time toppings is a compound procedure instead of a continuation.
(cons (toppings 'cake)
      (toppings 'cake))
;; This version of toppings doesn't forget everything (because it
;; isn't a continuation, instead it is a already setup collector)
(cons (toppings 'cake)
      (cons (toppings 'mozzarella)
            (cons (toppings 'pizza) '())))

(define two-in-a-row-b?
  (lambda (a lat)
    (cond
     ((null? lat) #f)
     (else (or (eq? (car lat) a)
               (two-in-a-row-b? (car lat) (cdr lat)))))))
(define two-in-a-row?
  (lambda (lat)
    (cond
     ((null? lat) #f)
     (else (two-in-a-row-b? (car lat) (cdr lat))))))

(define two-in-a-row?
  (letrec
      ((W (lambda (a lat)
            (cond
             ((null? lat) #f)
             (else
              (let ((next (car lat)))
                (or (eq? next a)
                    (W next (cdr lat)))))))))
    (lambda (lat)
      (cond
       ((null? lat) #f)
       (else (W (car lat) (cdr lat)))))))


(test (and
       (same? #f (two-in-a-row? '(mozzarella cake mozzarella)))
       (same? #t (two-in-a-row? '(mozzarella mozzarella pizza)))))

(define leave)
(define walk
  (lambda (l)
    (cond
     ((null? l) '())
     ((atom? (car l)) (leave (car l)))
     (else (begin
             (walk (car l))
             (walk (cdr l)))))))

(define start-it
  (lambda (l)
    (call/cc
     (lambda (here)
       (set! leave here)
       (walk l)))))

(start-it '((potato) (chips (chips (with))) fish))

(define fill)
(define waddle
  (lambda (l)
    (cond
     ((null? l) '())
     ((atom? (car l))
      (begin
        (call/cc
         (lambda (rest)
           (set! fill rest)
           (leave (car l))))
        (waddle (cdr l))))
     (else
      (begin
        (waddle (car l))
        (waddle (cdr l)))))))

(define start-it2
  (lambda (l)
    (call/cc
     (lambda (here)
       (set! leave here)
       (waddle l)))))

(test (same? 'donuts (start-it2 '((donuts) (cherrios (cheerios (spaghettios))) donuts))))

(define get-next
  (lambda (x)
    (call/cc
     (lambda (here-again)
       (set! leave here-again)
       (fill 'go)))))
(get-next 'go)

(define rest2
  (lambda (x)
    (waddle '(((cherrios (spaghettios))) donuts))))
(get-next 'go)
(get-next 'go)
(get-next 'go)
;; If we call this a last time, a test fails for some reason...
;; (get-next 'go)

(define get-first
  (lambda (l)
    (call/cc
     (lambda (here)
       (set! leave here)
       (waddle l)
       (leave '())))))

(get-first '())
(get-first '(donut))
(get-next 'go)
(get-first '(fish (chips)))
(get-next 'go)
(get-next 'go)
(get-first '(fish (chips) chips))
(get-next 'go)
(get-next 'go)

(define two-in-a-row-b*?
  (lambda (a)
    (let ((n (get-next 'go)))
      (if (atom? n)
          (or (eq? n a)
              (two-in-a-row-b*? n))
          #f))))
(define two-in-a-row*?
  (lambda (l)
    (let ((first (get-first l)))
      (if (atom? first)
          (two-in-a-row-b*? first)
          #f))))

(define two-in-a-row*?
  (letrec
      ((T? (lambda (a)
             (let ((n (get-next 0)))
               (if (atom? n)
                   (or (eq? n a)
                       (T? n))
                   #f))))
       (get-next (lambda (x)
                   (call/cc
                    (lambda (here-again)
                      (set! leave here-again)
                      (fill 'go)))))
       (fill (lambda (x) x))
       (waddle (lambda (l)
                 (cond
                  ((null? l) '())
                  ((atom? (car l))
                   (begin
                     (call/cc
                      (lambda (rest)
                        (set! fill rest)
                        (leave (car l))))
                     (waddle (cdr l))))
                  (else (begin
                          (waddle (car l))
                          (waddle (cdr l)))))))
       (leave (lambda (x) x)))
    (lambda (l)
      (let ((first (call/cc
                    (lambda (here)
                      (set! leave here)
                      (waddle l)
                      (leave '())))))
        (if (atom? first)
            (T? first)
            #f)))))

(test (and
       (same? #f (two-in-a-row*? '((mozzarella) (cake) mozzarella)))
       (same? #t (two-in-a-row*? '((potato) (chips ((with) fish) fish))))
       (same? #f (two-in-a-row*? '((potato) (chips ((with) fish) (chips)))))
       (same? #t (two-in-a-row*? '(((food) () (((food)))))))))
