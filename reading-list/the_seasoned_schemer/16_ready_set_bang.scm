(load "ss.scm")

(define sweet-tooth
  (lambda (food)
    (cons food
          (cons 'cake '()))))

(define last 'angelfood)

(sweet-tooth 'chocolate)
(sweet-tooth 'fruit)

(define sweet-toothL
  (lambda (food)
    (set! last food)
    (cons food
          (cons 'cake '()))))

(sweet-toothL 'chocolate)
last

(sweet-toothL 'fruit)
last

(sweet-toothL 'cheese)
last

(define ingredients '())

(define sweet-toothR
  (lambda (food)
    (set! ingredients
      (cons food ingredients))
    (cons food
          (cons 'cake '()))))

(sweet-toothR 'chocolate)
ingredients

(sweet-toothR 'fruit)
ingredients

(sweet-toothR 'cheese)
ingredients

(sweet-toothR 'carrot)
ingredients

(define deep
  (lambda (m)
    (cond
     ((zero? m) 'pizza)
     (else (cons (deep (sub1 m))
                 '())))))
;; I defined test in the ss.scm file to help actually make sure everything is working.
(test (and (same? '(((pizza)))
                  (deep 3))
           (same? '(((((((pizza)))))))
                  (deep 7))
           (same? 'pizza
                  (deep 0))))

(define Ns '())
(define deepR
  (lambda (n)
    (set! Ns (cons n Ns))
    (deep n)))

(define Rs '())
(define Ns '())
(define deepR
  (lambda (n)
    (set! Rs (cons (deep n) Rs))
    (set! Ns (cons n Ns))
    (deep n)))

;; We broke a commandment. Oops, let's fix that now.
(define deepR
  (lambda (n)
    (let ((result (deep n)))
      (set! Rs (cons result Rs))
      (set! Ns (cons n Ns))
      result)))

(test (and (same? '(((pizza)))
                  (deepR 3))))
Ns
Rs

(test (and (same? '(((((pizza)))))
                  (deepR 5))))

Ns
Rs

;; Yay, we're sneakily being taught about memoization.

(test (and (same? '(((pizza)))
                  (deepR 3))))
Ns
Rs

(define find
  (lambda (n Ns Rs)
    (letrec
        ((A (lambda (ns rs)
              (cond
               ((= (car ns) n) (car rs))
               (else (A (cdr ns) (cdr rs)))))))
      (A Ns Rs))))

(test (and (same? '(((pizza)))
                  (find 3 Ns Rs))
           (same? '(((((pizza)))))
                  (find 5 Ns Rs))))

(define deepM
  (lambda (n)
    (if (member? n Ns)
        (find n Ns Rs)
        (deepR n))))
Ns
Rs

(set! Ns (cdr Ns))
(set! Rs (cdr Rs))

Ns
Rs

(define deepM
  (lambda (n)
    (if (member? n Ns)
        (find n Ns Rs)
        (let ((result (deep n)))
          (set! Rs (cons result Rs))
          (set! Ns (cons n Ns))
          result))))

(test (and (same? '((((((pizza))))))
                  (deepM 6))))

;; This is pretty good, but in order to determine deep 6 we also
;; determine the value of deep 5. We can fix this by changing the
;; recursion

)

(define deep
  (lambda (m)
    (cond
     ((zero? m) 'pizza)
     (else (cons (deepM (sub1 m))
                 '())))))

(test (and (same? '(((((((((pizza)))))))))
                  (deepM 9))
           (same? '(9 8 7 6 5 3)
                  Ns)))

;; Where did the 7 and 8 come from? They came when deep asks for deepM
;; 8 during the recursion

(define deepM
  (let ((Rs '())
        (Ns '()))
    (lambda (n)
      (if (member? n Ns)
          (find n Ns Rs)
          (let ((result (deep n)))
            (set! Rs (cons result Rs))
            (set! Ns (cons n Ns))
            result)))))

(test (and (same? '((((((((((((((((pizza))))))))))))))))
                  (deepM 16))))

(define find
  (lambda (n Ns Rs)
    (letrec
        ((A (lambda (ns rs)
              (cond
               ((null? ns) #f)
               ((= (car ns) n) (car rs))
               (else (A (cdr ns) (cdr rs)))))))
      (A Ns Rs))))

(test (and (same? #f
                  (find 3 '() '()))))

(define deepM
  (let ((Rs '())
        (Ns '()))
    (lambda (n)
      (if (atom? (find n Ns Rs))
          (let ((result (deep n)))
            (set! Rs (cons result Rs))
            (set! Ns (cons n Ns))
            result)
          (find n Ns Rs)))))

;; Let's try again with the 15th commandment.

(define deepM
  (let ((Rs '())
        (Ns '()))
    (lambda (n)
      (let ((exists (find n Rs Rs)))
        (if (atom? exists)
            (let ((result (deep n)))
              (set! Rs (cons result Rs))
              (set! Ns (cons n Ns))
              result)
            exists)))))

(test (and (same? '((((((((((((((((pizza))))))))))))))))
                  (deepM 16))))

(define length
  (lambda (l)
    (cond
     ((null? l) 0)
     (else (add1 (length (cdr l)))))))

(define length
  (lambda (l)
    0))
(set! length
  (lambda (l)
    (cond
     ((null? l) 0)
     (else (add1 (length (cdr l)))))))

(define length
  (let ((h (lambda (l) 0)))
    (set! h
      (lambda (l)
        (cond
         ((null? l) 0)
         (else (add1 (h (cdr l)))))))
    h))

(define L
  (lambda (length)
    (lambda (l)
      (cond
       ((null? l) 0)
       (else (add1 (length (cdr l))))))))

(define length
  (let ((h (lambda (l) 0)))
    (set! h
      (L (lambda (arg) (h arg))))
    h))

(test (same? 3
             (length '(1 2 3))))

(define Y!
  (lambda (L)
    (let ((h (lambda (l) '())))
      (set! h
        (L (lambda (arg) (h arg))))
      h)))

;; Peter J. Landin. I think this is a fancy Y-combinator.
(define Y-bang!
  (lambda (f)
    (letrec
        ((h (f (lambda (arg) (h arg)))))
      h)))

;; You can think of a letrec as an abbreviation for an expression
;; consisting of (let ...) and (set! ...). So this (Y-bang!) is just
;; another way of writing Y!

(define length (Y! L))

(test (same? 3
             (length '(1 2 3))))

;; Woo-hoo. It is a fancy Y-combinator. This one is called "the
;; applicative-order, imperative Y combinator." This one is p-cool
;; because it produces recursive definitions without requiring that
;; the functions be named by (define ...)

(define depth*
  (Y! (lambda (depth*)
        (lambda (s)
          (cond
           ((null? s) 1)
           ((atom? (car s))
            (depth* (cdr s)))
           (else
            (max
             (add1 (depth* (car s)))
             (depth* (cdr s)))))))))

(test (and (same? 3
                  (depth* '(((4)))))
           (same? 3
                  (depth* '((a) ((4)))))))

;; Just to see if I really get this, I'm going to try to do the equivalent of calling depth* without defining anything at all

(test (same? 3
             (((lambda (L)
                 (let ((h (lambda (l) '())))
                   (set! h
                     (L (lambda (arg) (h arg))))
                   h)) (lambda (depth*)
                         (lambda (s)
                           (cond
                            ((null? s) 1)
                            ((atom? (car s))
                             (depth* (cdr s)))
                            (else
                             (max
                              (add1 (depth* (car s)))
                              (depth* (cdr s))))))))
              '((a) ((4))))))

;; What's the difference between using Y! and Y
(define biz
  (let ((x 0))
    (lambda (f)
      (set! x (add1 x))
      (lambda (a)
        (if (= a x)
            0
            (f a))))))

(test (same? 0
             ((Y biz) 5)))

;; ((Y! biz) 5)
;; This on the other hand, recurs forever.
