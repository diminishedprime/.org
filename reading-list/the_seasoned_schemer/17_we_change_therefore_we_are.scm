(load "ss.scm")

(define deep
  (lambda (m)
    (if (zero? m)
        'pizza
        (cons (deep (sub1 m)) '()))))

(define deepM
  (let ((Rs '())
        (Ns '()))
    (letrec
        ((D (lambda (m)
              (if (zero? m)
                  'pizza
                  (cons (D (sub1 m)) '())))))
      (lambda (n)
        (let ((exists (find n Ns Rs)))
          (if (atom? exists)
              (let ((result (D n)))
                (set! Rs (cons result Rs))
                (set! Ns (cons n Ns))
                result)
              exists))))))

(test (same? '(((pizza)))
             (deepM 3)))

(define deepM
  (let ((Rs '())
        (Ns '()))
    (letrec
        ((D (lambda (m)
              (if (zero? m)
                  'pizza
                  (cons (deepM (sub1 m)) '())))))
      (lambda (n)
        (let ((exists (find n Ns Rs)))
          (if (atom? exists)
              (let ((result (D n)))
                (set! Rs (cons result Rs))
                (set! Ns (cons n Ns))
                result)
              exists))))))

(test (same? '(((pizza)))
             (deepM 3)))

(define deepM
  (let ((Rs '())
        (Ns '()))
    (let ((D (lambda (m)
               (if (zero? m)
                   'pizza
                   (cons (deepM (sub1 m)) '())))))
      (lambda (n)
        (let ((exists (find n Ns Rs)))
          (if (atom? exists)
              (let ((result (D n)))
                (set! Rs (cons result Rs))
                (set! Ns (cons n Ns))
                result)
              exists))))))

(test (same? '(((pizza)))
             (deepM 3)))

(define deepM
  (let ((Rs '())
        (Ns '())
        (D (lambda (m)
             (if (zero? m)
                 'pizza
                 (cons (deepM (sub1 m)) '())))))
    (lambda (n)
      (let ((exists (find n Ns Rs)))
        (if (atom? exists)
            (let ((result (D n)))
              (set! Rs (cons result Rs))
              (set! Ns (cons n Ns))
              result)
            exists)))))

(test (same? '(((pizza)))
             (deepM 3)))

(define deepM
  (let ((Rs '())
        (Ns '()))
    (lambda (n)
      (let ((exists (find n Ns Rs)))
        (if (atom? exists)
            (let ((result ((lambda (m)
                             (if (zero? m)
                                 'pizza
                                 (cons (deepM (sub1 m)) '())))
                           n)))
              (set! Rs (cons result Rs))
              (set! Ns (cons n Ns))
              result)
            exists)))))

(test (same? '(((pizza)))
             (deepM 3)))

(define deepM
  (let ((Rs '())
        (Ns '()))
    (lambda (n)
      (let ((exists (find n Ns Rs)))
        (if (atom? exists)
            (let ((result (let ((m n))
                            (if (zero? m)
                                'pizza
                                (cons (deepM (sub1 m)) '())))))
              (set! Rs (cons result Rs))
              (set! Ns (cons n Ns))
              result)
            exists)))))

(test (same? '(((pizza)))
             (deepM 3)))

(define deepM
  (let ((Rs '())
        (Ns '()))
    (lambda (n)
      (let ((exists (find n Ns Rs)))
        (if (atom? exists)
            (let ((result (if (zero? n)
                              'pizza
                              (cons (deepM (sub1 n)) '()))))
              (set! Rs (cons result Rs))
              (set! Ns (cons n Ns))
              result)
            exists)))))

(test (same? '(((pizza)))
             (deepM 3)))

(define consC
  (let ((N 0))
    (lambda (x y)
      (set! N (add1 N))
      (cons x y))))

(define deep
  (lambda (m)
    (if (zero? m)
        'pizza
        (consC (deep (sub1 m)) '()))))

(test (and (same? '(((((pizza)))))
                  (deep 5))))

(define counter)

(define consC
  (let ((N 0))
    (set! counter
      (lambda ()
        N))
    (lambda (x y)
      (set! N (add1 N))
      (cons x y))))

(test (and (same? '(((((pizza)))))
                  (deep 5))
           (same? 5
                  (counter))
           (same? '(((((((pizza)))))))
                  (deep 7))
           (same? 12
                  (counter))))

(define supercounter
  (lambda (f)
    (letrec
        ((S (lambda (n)
              (if (zero? n)
                  (f n)
                  (let ()
                    (f n)
                    (S (sub1 n)))))))
      (S 1000))))

(define supercounter
  (lambda (f)
    (letrec
        ((S (lambda (n)
              (if (zero? n)
                  (f n)
                  (let ()
                    (f n)
                    (S (sub1 n)))))))
      (S 1000)
      (counter))))

(test (and (same? 500512
                  (supercounter deep))))

(define counter)
(define set-counter)
(define consC
  (let ((N 0))
    (set! counter
      (lambda ()
        N))
    (set! set-counter
      (lambda (x)
        (set! N x)))
    (lambda (x y)
      (set! N (add1 N))
      (cons x y))))

(set-counter 0)

(test (and (same? 500500
                  (supercounter deep))))

(define deepM
  (let ((Rs '())
        (Ns '()))
    (lambda (n)
      (let ((exists (find n Ns Rs)))
        (if (atom? exists)
            (let ((result (if (zero? n)
                              'pizza
                              (consC (deepM (sub1 n)) '()))))
              (set! Rs (cons result Rs))
              (set! Ns (cons n Ns))
              result)
            exists)))))

(test (and
       (same? '(((((pizza)))))
              (deepM 5))
       (same? 500505
              (counter))))

(set-counter 0)

(define deepM
  (let ((Rs '())
        (Ns '()))
    (lambda (n)
      (let ((exists (find n Ns Rs)))
        (if (atom? exists)
            (let ((result (if (zero? n)
                              'pizza
                              (consC (deepM (sub1 n)) '()))))
              (set! Rs (cons result Rs))
              (set! Ns (cons n Ns))
              result)
            exists)))))

;; I noticed something pretty strange here, it appears that the act of
;; defining deepM has a side effect because of how the interning
;; works. Not sure exactly what's goin on, but I had to re-define
;; deepM to get this test underneath to work

(test (and
       (same? '(((((pizza)))))
              (deepM 5))
       (same? 5
              (counter))))

(test (and (same? '(((((((pizza)))))))
                  (deepM 7))
           (same? 7
                  (counter))))

(test (same? 1000
             (supercounter deepM)))

(define rember1*
  (lambda (a l)
    (letrec
        ((R (lambda (l oh)
              (cond
               ((null? l)
                (oh 'no))
               ((atom? (car l))
                (if (eq? (car l) a)
                    (cdr l)
                    (cons (car l) (R (cdr l) oh))))
               (else
                (let ((new-car (call/cc
                                (lambda (oh)
                                  (R (car l) oh)))))
                  (if (atom? new-car)
                      (cons (car l)
                            (R (cdr l) oh))
                      (cons new-car
                            (cdr l)))))))))
      (let ((new-l (call/cc
                    (lambda (oh)
                      (R l oh)))))
        (if (atom? new-l)
            l
            new-l)))))

(define rember1*C
  (lambda (a l)
    (letrec
        ((R (lambda (l oh)
              (cond
               ((null? l)
                (oh 'no))
               ((atom? (car l))
                (if (eq? (car l) a)
                    (cdr l)
                    (consC (car l) (R (cdr l) oh))))
               (else
                (let ((new-car (call/cc
                                (lambda (oh)
                                  (R (car l) oh)))))
                  (if (atom? new-car)
                      (consC (car l)
                             (R (cdr l) oh))
                      (consC new-car
                             (cdr l)))))))))
      (let ((new-l (call/cc
                    (lambda (oh)
                      (R l oh)))))
        (if (atom? new-l)
            l
            new-l)))))

(set-counter 0)

(test (and (same? '((food) more (food))
                  (rember1*C 'noodles '((food) more (food))))
           (same? 0
                  (counter))))

(define rember1*
  (lambda (a l)
    (letrec
        ((R (lambda (l)
              (cond
               ((null? l) '())
               ((atom? (car l))
                (if (eq? (car l) a)
                    (cdr l)
                    (cons (car l) (R (cdr l)))))
               (else
                (let ((av (R (car l))))
                  (if (eqlist? (car l) av)
                      (cons (car l) (R (cdr l)))
                      (cons av (cdr l)))))))))
      (R l))))

(define rember1*C2
  (lambda (a l)
    (letrec
        ((R (lambda (l)
              (cond
               ((null? l) '())
               ((atom? (car l))
                (if (eq? (car l) a)
                    (cdr l)
                    (consC (car l) (R (cdr l)))))
               (else
                (let ((av (R (car l))))
                  (if (eqlist? (car l) av)
                      (consC (car l) (R (cdr l)))
                      (consC av (cdr l)))))))))
      (R l))))

(set-counter 0)

(test (and (same? '((food) more (food))
                  (consC (consC 'food '())
                         (consC 'more
                                (consC (ConsC 'food '())
                                       '()))))
           (same? 5
                  (counter))))

(set-counter 0)
(let ((a 'noodles)
      (l '((food) more (food))))
  (test (and (same? l (rember1*C2 a l))
             (same? 5 (counter)))))
