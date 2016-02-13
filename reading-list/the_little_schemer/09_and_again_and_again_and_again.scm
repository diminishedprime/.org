(load "ls.scm") ;; => #<unspecified>


;; sorn stands for symbol or number.
(define keep-looking
  (lambda (a sorn lat)
    (cond
     ((number? sorn) (keep-looking a (pick sorn lat) lat))
     (else (eq? sorn a))))) ;; => #<unspecified>

(define looking
  (lambda (a lat)
    (keep-looking a (pick 1 lat) lat))) ;; => #<unspecified>

(looking 'caviar
         '(6 2 4 caviar 5 7 3)) ;; => #t
(looking 'caviar
         '(6 2 grits caviar 5 7 3)) ;; => #f

;; Looking is called a partial function. The other ones so far have been called
;; total functions.

(define eternity
  (lambda (x)
    (eternity x))) ;; => #<unspecified>

;; Eternity is like the most partial function ever. It never finishes for any of
;; its inputs.

(define shift
  (lambda (pair)
    (build (first (first pair))
           (build (second (first pair))
                  (second pair)))))

(shift '((a b) c)) ;; => (a (b c))
(shift '((a b) (c d))) ;; => (a (b (c d)))

(define align
  (lambda (pora)
    (cond
     ((atom? pora) pora)
     ((a-pair? (first pora)) (align (shift pora)))
     (else (build (first pora)
                  (align (second pora))))))) ;; => #<unspecified>

(define length*
  (lambda (pora)
    (cond
     ((atom? pora) 1)
     (else (o+ (length* (first pora))
               (length* (second pora))))))) ;; => #<unspecified>

(define weight*
  (lambda (pora)
    (cond
     ((atom? pora) 1)
     (else (o+ (o* (weight* (first pora)) 2)
               (weight* (second pora))))))) ;; => #<unspecified>

(length* '((a b) c)) ;; => 3
(length* '(a (b c))) ;; => 3
(weight* '((a b) c)) ;; => 7
(weight* '(a (b c))) ;; => 5

;; Somehow we can conclude from this that align is not a partial function. It
;; seems to rest in the fact that our arguments to align get simpler as it
;; recurses.

(define shuffle
  (lambda (pora)
    (cond
     ((atom? pora) pora)
     ((a-pair? (first pora)) (shuffle (revpair pora)))
     (else (build (first pora)
                  (shuffle (second pora))))))) ;; => #<unspecified>

(shuffle '(a (b c))) ;; => (a (b c))
(shuffle '(a b)) ;; => (a b)

;; Shuffle is not total, we can see it's partial by trying to evaluate (shuffle
;; '((a b) (c d))) which will recurse forever.

(define C
  (lambda (n)
    (cond
     ((one? n) 1)
     ((even? n) (C (o/ n 2)))
     (else (C (add1 (o* 3 n)))))))

(C 3) ;; => 1
(C 100) ;; => 1

;; We don't know if this function is total or not, but it seems like it probably
;; is?

(define A
  (lambda (n m)
    (cond
     ((zero? n) (add1 m))
     ((zero? m) (A (sub1 n) 1))
     (else (A (sub1 n)
              (A n (sub1 m))))))) ;; => #<unspecified>

(A 1 0) ;; => 2
(A 1 1) ;; => 3
(A 2 2) ;; => 7


(define length
  (lambda (l)
    (cond
     ((null? l) 0)
     (else (add1 (length (cdr l))))))) ;; => #<unspecified>

(lambda (l)
  (cond
   ((null? l) 0)
   (else (add1 (eternity (cdr l)))))) ;; => #<procedure 10c7e8a00 at <current input>:136:16 (l)>

((lambda (l)
   (cond
    ((null? l) 0)
    (else (add1 (eternity (cdr l)))))) '()) ;; => 0

(lambda (l)
  (cond
   ((null? l) 0)
   (else (add1
          ((lambda (l)
             (cond
              ((null? l) 0)
              (else (add1 (eternity (cdr l))))))
           (cdr l)))))) ;; => #<procedure 10c9000a0 at <current input>:162:16 (l)>

((lambda (l)
   (cond
    ((null? l) 0)
    (else (add1
           ((lambda (l)
              (cond
               ((null? l) 0)
               (else (add1 (eternity (cdr l))))))
            (cdr l)))))) '(1)) ;; => 1


(lambda (l)
  (cond
   ((null? l) 0)
   (else (add1
          ((lambda (l)
             (cond
              ((null? l) 0)
              (else (add1
                     ((lambda (l)
                        (cond
                         ((null? l) 0)
                         (else (add1
                                (eternity (cdr l))))))
                      (cdr l))))))
           (cdr l)))))) ;; => #<procedure 10cba8b20 at <current input>:221:16 (l)>

((lambda (l)
   (cond
    ((null? l) 0)
    (else (add1
           ((lambda (l)
              (cond
               ((null? l) 0)
               (else (add1
                      ((lambda (l)
                         (cond
                          ((null? l) 0)
                          (else (add1
                                 (eternity (cdr l))))))
                       (cdr l))))))
            (cdr l)))))) '(1 2)) ;; => 2

;; A function that returns the length0 function
((lambda (length)
   (lambda (l)
     (cond
      ((null? l) 0)
      (else (add1 (length (cdr l)))))))
 eternity) ;; => #<procedure 10c847bc0 at <current input>:275:3 (l)>

;; Calling length0 function with a list length of 0
(((lambda (length)
    (lambda (l)
      (cond
       ((null? l) 0)
       (else (add1 (length (cdr l)))))))
  eternity) '()) ;; => 0


;; A function that returns the length1 function.
((lambda (f)
   (lambda (l)
     (cond
      ((null? l) 0)
      (else (add1 (f (cdr l)))))))
 ((lambda (g)
    (lambda (l)
      (cond
       ((null? l) 0)
       (else (add1 (g (cdr l)))))))
  eternity)) ;; => #<procedure 10c7ec180 at <current input>:298:3 (l)>

;; Calling length1 with a list length of 1.
(((lambda (f)
    (lambda (l)
      (cond
       ((null? l) 0)
       (else (add1 (f (cdr l)))))))
  ((lambda (g)
     (lambda (l)
       (cond
        ((null? l) 0)
        (else (add1 (g (cdr l)))))))
   eternity)) '(1)) ;; => 1

;; A function that returns the length2 function
((lambda (f)
   (lambda (l)
     (cond
      ((null? l) 0)
      (else (add1 (f (cdr l)))))))
 ((lambda (g)
    (lambda (l)
      (cond
       ((null? l) 0)
       (else (add1 (g (cdr l)))))))
  ((lambda (g)
     (lambda (l)
       (cond
        ((null? l) 0)
        (else (add1 (g (cdr l)))))))
   eternity))) ;; => #<procedure 10c841840 at <current input>:325:3 (l)>

;; Calling length2 with a list length of 2
(((lambda (f)
    (lambda (l)
      (cond
       ((null? l) 0)
       (else (add1 (f (cdr l)))))))
  ((lambda (g)
     (lambda (l)
       (cond
        ((null? l) 0)
        (else (add1 (g (cdr l)))))))
   ((lambda (g)
      (lambda (l)
        (cond
         ((null? l) 0)
         (else (add1 (g (cdr l)))))))
    eternity))) '(1 2)) ;; => 2

;; A function that returns the length0 function
((lambda (mk-length)
   (mk-length eternity))
 (lambda (length)
   (lambda (l)
     (cond
      ((null? l) 0)
      (else (add1 (length (cdr l)))))))) ;; => #<procedure 10c550860 at <current input>:367:3 (l)>

;; Calling length0 with a list length of 0
(((lambda (mk-length)
    (mk-length eternity))
  (lambda (length)
    (lambda (l)
      (cond
       ((null? l) 0)
       (else (add1 (length (cdr l)))))))) '()) ;; => 0

;; A function that returns the length1 function
((lambda (mk-length)
   (mk-length
    (mk-length eternity)))
 (lambda (length)
   (lambda (l)
     (cond
      ((null? l) 0)
      (else (add1 (length (cdr l)))))))) ;; => #<procedure 10c9dc520 at <current input>:386:3 (l)>

;; Calling length1 with a list length of 1
(((lambda (mk-length)
    (mk-length
     (mk-length eternity)))
  (lambda (length)
    (lambda (l)
      (cond
       ((null? l) 0)
       (else (add1 (length (cdr l)))))))) '(1)) ;; => 1

;; Calling length2 with a list length of 2
(((lambda (mk-length)
    (mk-length
     (mk-length
      (mk-length eternity))))
  (lambda (length)
    (lambda (l)
      (cond
       ((null? l) 0)
       (else (add1 (length (cdr l)))))))) '(1 2)) ;; => 2

;; Calling length3 with a list length of 3
(((lambda (mk-length)
    (mk-length
     (mk-length
      (mk-length
       (mk-length eternity)))))
  (lambda (length)
    (lambda (l)
      (cond
       ((null? l) 0)
       (else (add1 (length (cdr l)))))))) '(1 2 3)) ;; => 3

;; A function that returns the length0 function
((lambda (mk-length)
   (mk-length mk-length))
 (lambda (length)
   (lambda (l)
     (cond
      ((null? l) 0)
      (else (add1
             (length (cdr l)))))))) ;; => #<procedure 10ca4d200 at <current input>:449:3 (l)>

(((lambda (mk-length)
    (mk-length mk-length))
  (lambda (length)
    (lambda (l)
      (cond
       ((null? l) 0)
       (else (add1
              (length (cdr l)))))))) '()) ;; => 0

(((lambda (mk-length)
    (mk-length mk-length))
  (lambda (mk-length)
    (lambda (l)
      (cond
       ((null? l) 0)
       (else (add1
              (mk-length (cdr l)))))))) '()) ;; => 0

;; A function that returns the length function
((lambda (mk-length)
   (mk-length mk-length))
 (lambda (mk-length)
   (lambda (l)
     (cond
      ((null? l) 0)
      (else (add1
             ((mk-length mk-length)
              (cdr l)))))))) ;; => #<procedure 11015c9c0 at <current input>:365:3 (l)>

;; This works because we pass it the function that can create the next recursion
;; right as it is needed

;; Calling length with a list of length 5
(((lambda (mk-length)
    (mk-length mk-length))
  (lambda (mk-length)
    (lambda (l)
      (cond
       ((null? l) 0)
       (else (add1
              ((mk-length mk-length)
               (cdr l)))))))) '(1 2 3 4 5)) ;; => 5



((lambda (mk-length)
   (mk-length mk-length))
 (lambda (mk-length)
   (lambda (l)
     (cond
      ((null? l) 0)
      (else (add1
             ((lambda (x)
                ((mk-length mk-length) x))
              (cdr l)))))))) ;; => #<procedure 10a5391c0 at <current input>:400:3 (l)>

(((lambda (mk-length)
    (mk-length mk-length))
  (lambda (mk-length)
    (lambda (l)
      (cond
       ((null? l) 0)
       (else (add1
              ((lambda (x)
                 ((mk-length mk-length) x))
               (cdr l)))))))) '(1 2 3)) ;; => 3

;; Returns the length function. Note that now the innermost lambda is what
;; length used to be.
((lambda (mk-length)
   (mk-length mk-length))
 (lambda (mk-length)
   ((lambda (length)
      (lambda (l)
        (cond
         ((null? l) 0)
         (else (add1 (length (cdr l)))))))
    (lambda (x)
      ((mk-length mk-length) x))))) ;; => #<procedure 10a1e28a0 at <current input>:440:6 (l)>

;; Calling the function with a list length of 9
(((lambda (mk-length)
    (mk-length mk-length))
  (lambda (mk-length)
    ((lambda (length)
       (lambda (l)
         (cond
          ((null? l) 0)
          (else (add1 (length (cdr l)))))))
     (lambda (x)
       ((mk-length mk-length) x))))) '(1 2 3 4 5 6 7 8 9)) ;; => 9

;; Extracting out the length function.
((lambda (le)
   ((lambda (mk-length)
      (mk-length mk-length))
    (lambda (mk-length)
      (le (lambda (x)
            ((mk-length mk-length) x))))))
 (lambda (length)
   (lambda (l)
     (cond
      ((null? l) 0)
      (else (add1 (length (cdr l)))))))) ;; => #<procedure 10a3cdb40 at <current input>:477:3 (l)>

;; Calling it with a list of length 5
(((lambda (le)
    ((lambda (mk-length)
       (mk-length mk-length))
     (lambda (mk-length)
       (le (lambda (x)
             ((mk-length mk-length) x))))))
  (lambda (length)
    (lambda (l)
      (cond
       ((null? l) 0)
       (else (add1 (length (cdr l)))))))) '(1 2 3 4 5)) ;; => 5

;; Through this process, we have derived the applicative-order Y combinator.

(lambda (le)
  ((lambda (f) (f f))
   (lambda (f)
     (le (lambda (x) ((f f) x)))))) ;; => #<procedure 10a3858e0 at <current input>:502:16 (le)>

(define Y
  (lambda (le)
    ((lambda (f) (f f))
     (lambda (f)
       (le (lambda (x) ((f f) x))))))) ;; => #<unspecified>

;; Y allows us to do recursion without define.
(Y (lambda (length)
     (lambda (l)
       (cond
        ((null? l) 0)
        (else (add1 (length (cdr l)))))))) ;; => #<procedure 10a64dbe0 at <current input>:521:5 (l)>

;; Using the Y combinator to do recursion without define.
((Y (lambda (length)
      (lambda (l)
        (cond
         ((null? l) 0)
         (else (add1 (length (cdr l)))))))) '(1 2 3)) ;; => 3
