(load "ss.scm")

(define counter) ;; Setting up counter.
(define set-counter) ;; Setting up set-counter

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

(define kons cons)
(define kdr cdr)
(define kar car)
(define konsC consC)
(define kounter counter)
(define set-kounter set-counter)
(define set-kdr set-cdr!)

(define lots
  (lambda (m)
    (cond
     ((zero? m) '())
     (else (kons 'egg
                 (lots (sub1 m)))))))

(test (and
       (same? '(egg egg egg)
              (lots 3))
       (same? '(egg egg egg egg egg)
              (lots 5))
       (same? '(egg egg egg egg
                    egg egg egg egg
                    egg egg egg egg)
              (lots 12))))

(define lenkth
  (lambda (l)
    (cond
     ((null? l) 0)
     (else (add1 (lenkth (kdr l)))))))

(test (and
       (same? 3
              (lenkth (lots 3)))
       (same? 5
              (lenkth (lots 5)))
       (same? 15
              (lenkth (lots 15)))))

(define add-at-end
  (lambda (l)
    (cond
     ((null? (kdr l))
      (konsC (kar l)
             (kons 'egg '())))
     (else (konsC (kar l) (add-at-end (kdr l)))))))

(test (and
       (same? '(egg egg egg egg)
              (add-at-end (lots 3)))
       (same? 3
              (kounter))))

(define add-at-end-too
  (lambda (l)
    (letrec
        ((A (lambda (ls)
              (cond
               ((null? (kdr ls))
                (set-kdr ls
                         (kons 'egg '())))
               (else (A (kdr ls)))))))
      (A l)
      l)))

(set-kounter 0)
(kounter)

(test (and
       (same? '(egg egg egg egg)
              (add-at-end-too (lots 3)))
       (same? 0
              (kounter))))
(define kons
  (lambda (kar kdr)
    (lambda (selector)
      (selector kar kdr))))
(define kar
  (lambda (c)
    (c (lambda (a d) a))))
(define kdr
  (lambda (c)
    (c (lambda (a d) d))))

(test (and
       (same? 'a
              (kar (kons 'a '())))
       (same? '()
              (kdr (kons 'a '())))))

(define bons
  (lambda (kar)
    (let ((kdr '()))
      (lambda (selector)
        (selector (lambda (x) (set! kdr x))
                  kar
                  kdr)))))

(define kar
  (lambda (c)
    (c (lambda (s a d) a))))

(define kdr
  (lambda (c)
    (c (lambda (s a d) d))))

(bons 'egg)

(define set-kdr
  (lambda (c x)
    ((c (lambda (s a d) s)) x)))

(define kons
  (lambda (a d)
    (let ((c (bons a)))
      (set-kdr c d)
      c)))

(kar (kons 'a '(1 2 3)))
(kdr (kons 'a '(1 2 3)))

;; Need to redefine a few things to make sure they are using the new kons and kdr etc...

(define lots
  (lambda (m)
    (cond
     ((zero? m) '())
     (else (kons 'egg
                 (lots (sub1 m)))))))

(define konsC
  (let ((N 0))
    (set! kounter
      (lambda ()
        N))
    (set! set-kounter
      (lambda (x)
        (set! N x)))
    (lambda (x y)
      (set! N (add1 N))
      (kons x y))))

(define add-at-end
  (lambda (l)
    (cond
     ((null? (kdr l))
      (konsC (kar l)
             (kons 'egg '())))
     (else (konsC (kar l) (add-at-end (kdr l)))))))

(define add-at-end-too
  (lambda (l)
    (letrec
        ((A (lambda (ls)
              (cond
               ((null? (kdr ls))
                (set-kdr ls
                         (kons 'egg '())))
               (else (A (kdr ls)))))))
      (A l)
      l)))

(define dozen (lots 12))
(define bakers-dozen (add-at-end dozen))
(define bakers-dozen-too (add-at-end-too dozen))
(define bakers-dozen-again (add-at-end dozen))

(define eklist?
  (lambda (ls1 ls2)
    (cond
     ((null? ls1) (null? ls2))
     ((null? ls2) #f)
     (else
      (and (eq? (kar ls1) (kar ls2))
           (eklist? (kdr ls1) (kdr ls2)))))))

;; Make sure you redefine all the previous functions to use the new
;; definitions of kar, kdr, kons, etc
(test (and (same? #t
                  (eklist? bakers-dozen bakers-dozen-too))))

(define same??
  (lambda (c1 c2)
    (let ((t1 (kdr c1))
          (t2 (kdr c2)))
      (set-kdr c1 1)
      (set-kdr c2 2)
      (let ((v (= (kdr c1) (kdr c2))))
        (set-kdr c1 t1)
        (set-kdr c2 t2)
        v))))

(define dozen (lots 12))
(define bakers-dozen (add-at-end dozen))
(define bakers-dozen-too (add-at-end-too dozen))
(define bakers-dozen-again (add-at-end dozen))

(test (and (same? #f (same?? dozen bakers-dozen))
           (same? #t (same?? dozen bakers-dozen-too))))

(define last-kons
  (lambda (ls)
    (cond
     ((null? (kdr ls)) ls)
     (else (last-kons (kdr ls))))))

;; It seems like I'm making a lazy scheme?
(define long (lots 12))

(test (and
       (same? 'egg
              (kar (last-kons long)))
       (same? '()
              (kdr (last-kons long)))
       (same? 12
              (lenkth long))))

(set-kdr (last-kons long) long)
;; doesn't work anymore?
;; (lenkth long)
;; This  has to do with the fact that the kdr is now recursive.

;;(set-kdr (last-kons long) (kdr (kdr long)))
;;(lenkth long)

(define finite-lenkth
  (lambda (p)
    (call/cc
     (lambda (infinite)
       (letrec
           ((C (lambda (p q)
                 (cond
                  ((same? p q) (infinite #f))
                  ((null? q) 0)
                  ((null? (kdr q)) 1)
                  (else
                   (+ (C (sl p) (qk q)) 2)))))
            (qk (lambda (x) (kdr (kdr x))))
            (sl (lambda (x) (kdr x))))
         (cond
          ((null? p) 0)
          (else
           (add1 (C p (kdr p))))))))))

(define not-so-long (lots 5))
(finite-lenkth long)

(define de-lazy
  (lambda (ls)
    (cond
     ((procedure? ls) (cons (kar ls) (de-lazy (kdr ls))))
     (else '()))))

(define mongo
  (kons 'pie
        (kons 'a
              (kons 'la
                    (kons 'mode '())))))
(de-lazy mongo)
(set-kdr (kdr (kdr (kdr mongo))) (kdr mongo))
