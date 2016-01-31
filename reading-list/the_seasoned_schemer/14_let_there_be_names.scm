(load "ss.scm")

(define leftmost
  (lambda (l)
    (cond
     ((atom? (car l)) (car l))
     (else (leftmost (car l))))))

(leftmost '(((a) b) (c d)))
(leftmost '(((a ()) () (e))))
;; This blows up our normal definition
;; (leftmost '(((() a))))

(define leftmost
  (lambda (l)
    (cond
     ((null? l) '())
     ((atom? (car l)) (car l))
     (else (cond
            ((atom? (leftmost (car l)))
             (leftmost (car l)))
            (else (leftmost (cdr l))))))))

(leftmost '(((() a))))

;; This is good, but it calculates the leftmost of the car of l too
;; much... LET TO THE RESCUE

(define leftmost
  (lambda (l)
    (cond
     ((null? l) '())
     ((atom? (car l)) (car l))
     (else (let ((a (leftmost (car l))))
             (cond
              ((atom? a) a)
              (else (leftmost (cdr l)))))))))

(leftmost '(((() a))))
;; Still a happy camper...

;; Just for my own amusement, I'm going to try to do let via the good
;; ole fashioned lambda.

(define leftmost
  (lambda (l)
    (cond
     ((null? l) '())
     ((atom? (car l)) (car l))
     (else ((lambda (a)
              (cond
               ((atom? a) a)
               (else (leftmost (cdr l)))))
            (leftmost (car l)))))))
;; I did it!
(leftmost '(((() a))))

(define rember1*
  (lambda (a l)
    (cond
     ((null? l) '())
     ((atom? (car l)) (cond
                       ((eq? (car l) a) (cdr l))
                       (else (cons (car l)
                                   (rember1* a (cdr l))))))
     (else (cond
            ((eqlist? (rember1* a (car l))
                      (car l))
             (cons (car l) (rember1* a (cdr l))))
            (else (cons (rember1* a (car l)) (cdr l))))))))

(rember1* 'salad '((Swedish rye) (French (mustard salad turkey)) salad))
(rember1* 'meat '((pasta meat) pasta (noodles meat sauce) meat tomatoes))

;; Fixing rember1* using the Twelth Commandment

(define rember1*
  (lambda (a l)
    (letrec
        ((R (lambda (l)
              (cond
               ((null? l) '())
               ((atom? (car l)) (cond
                                 ((eq? (car l) a) (cdr l))
                                 (else (cons (car l) (R (cdr l))))))
               (else (cond
                      ((eqlist? (R (car l))
                                (car l))
                       (cons (car l) (R (cdr l))))
                      (else (cons (R (car l)) (cdr l)))))))))
      (R l))))

(rember1* 'salad '((Swedish rye) (French (mustard salad turkey)) salad))
(rember1* 'meat '((pasta meat) pasta (noodles meat sauce) meat tomatoes))

;; That's a little better, but we still have some things that are
;; repeating.

(define rember1*
  (lambda (a l)
    (letrec
        ((R (lambda (l)
              (cond
               ((null? l) '())
               ((atom? (car l)) (cond
                                 ((eq? (car l) a) (cdr l))
                                 (else (cons (car l) (R (cdr l))))))
               (else (let ((av (R (car l))))
                       (cond
                        ((eqlist? av (car l))
                         (cons (car l) av))
                        (else (cons (R (car l)) (cdr l))))))))))
      (R l))))

(rember1* 'salad '((Swedish rye) (French (mustard salad turkey)) salad))
(rember1* 'meat '((pasta meat) pasta (noodles meat sauce) meat tomatoes))

(define depth*
  (lambda (l)
    (cond
     ((null? l) 1)
     ((atom? (car l))
      (depth* (cdr l)))
     (else (cond
            ((> (depth* (cdr l))
                (add1 (depth* (car l))))
             (depth* (cdr l)))
            (else (add1 (depth* (car l)))))))))

(depth* '((pickled) peppers (peppers pickled)))
(depth* '(margarine ((bitter butter) (makes) (batter (bitter))) butter))
(depth* '(c (b (a b) a) a))

;; Let's get rid of the repeats

(define depth*
  (lambda (l)
    (cond
     ((null? l) 1)
     ((atom? (car l))
      (depth* (cdr l)))
     (else (let ((a (add1 (depth* (car l))))
                 (d (depth* (cdr l))))
             (cond
              ((> d a) d)
              (else a)))))))

(depth* '((pickled) peppers (peppers pickled)))
(depth* '(margarine ((bitter butter) (makes) (batter (bitter))) butter))
(depth* '(c (b (a b) a) a))

;; Yay, that was much cleaner than before. :) We can still do better,
;; though.

(define depth*
  (lambda (l)
    (cond
     ((null? l) 1)
     (else (let ((d (depth* (cdr l))))
             (cond
              ((atom? (car l)) d)
              (else (let ((a (add1 (depth* (car l)))))
                      (cond
                       ((> d a) d)
                       (else a))))))))))

(depth* '((pickled) peppers (peppers pickled)))
(depth* '(margarine ((bitter butter) (makes) (batter (bitter))) butter))
(depth* '(c (b (a b) a) a))

;; This version saves us one more extra calculation, sorta... It
;; actually only sometimes saves us a calculation, when the car of l
;; isn't an atom. Because of this, it is okay to leave it as it was
;; before. This is probably preferred, actually, since it is easier to
;; read.

(define depth*
  (lambda (l)
    (cond
     ((null? l) 1)
     (else (let ((d (depth* (cdr l))))
             (cond
              ((atom? (car l)) d)
              (else (let ((a (add1 (depth* (car l)))))
                      (if (> d a) d a)))))))))

(depth* '((pickled) peppers (peppers pickled)))
(depth* '(margarine ((bitter butter) (makes) (batter (bitter))) butter))
(depth* '(c (b (a b) a) a))

;; Even shorter. Ifs can be really great.

(define depth*
  (lambda (l)
    (cond
     ((null? l) 1)
     ((atom? (car l)) (depth* (cdr l)))
     (else (max (add1 (depth* (car l)))
                (depth* (cdr l)))))))

(depth* '((pickled) peppers (peppers pickled)))
(depth* '(margarine ((bitter butter) (makes) (batter (bitter))) butter))
(depth* '(c (b (a b) a) a))

;; Max is nice and already ruterns the greater of two values. :)

(define leftmost
  (lambda (l)
    (call/cc
     (lambda (skip)
       (lm l skip)))))
(define lm
  (lambda (l out)
    (cond
     ((null? l) '())
     ((atom? (car l)) (out (car l)))
     (else (begin
             (lm (car l) out)
             (lm (cdr l) out))))))

(leftmost '(((a)) b (c)))

;; But don't forget the 13th commandment

(define leftmost
  (letrec
      ((lm (lambda (l outu)
             (cond
              ((null? l) '())
              ((atom? (car l)) (out (car l)))
              (else (begin
                      (lm (car l) out)
                      (lm (cdr l) out)))))))
    (lambda (l)
      (call/cc
       (lambda (skip)
         (lm l skip))))))

(leftmost '(((a)) b (c)))

;; Whew. That was a close one. We could hide it a different way too,
;; though. And while we are at it, we could put the letrec inside of
;; the call/cc too. Oh, and now we see that we don't need out and skip
;; seperately. They both refer to the same function, so let's make
;; them the same, too.

(define leftmost
  (lambda (l)
    (call/cc
     (lambda (skip)
       (letrec
           ((lm (lambda (l)
                  (cond
                   ((null? l) '())
                   ((atom? (car l)) (skip (car l)))
                   (else (begin
                           (lm (car l))
                           (lm (cdr l))))))))
         (lm l))))))

(leftmost '(((a)) b (c)))

(define rember1*
  (lambda (a l)
    (letrec
        ((rm (lambda (a l oh)
               (cond
                ((null? l) (oh 'no))
                ((atom? (car l))
                 (if (eq? (car l) a)
                     (cdr l)
                     (cons (car l) (rm a (cdr l) oh))))
                (else
                 (let ((new-car
                        (call/cc
                         (lambda (oh)
                           (rm a (car l) oh)))))
                   (if (atom? new-car)
                       (cons (car l) (rm a (cdr l) oh))
                       (cons new-car (cdr l)))))))))
      (let ((new-l
             (call/cc
              (lambda (oh)
                (rm a l oh)))))
        (if (atom? new-l)
            l
            new-l)))))

(rember1* 'noodles
          '((food) more (food)))
(rember1* 'noodles
          '(noodles noodles ((noodles))))
