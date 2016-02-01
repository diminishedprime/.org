(load "ls.scm") ;; => #<unspecified>

(atom? 14) ;; => #t
(add1 67) ;; => 68
(add1 67) ;; => 68
(sub1 5) ;; => 4
(sub1 0) ;; => -1, though for this book, we pretend like negative numbers don't exist.
(zero? 0) ;; => #t
(zero? 1492) ;; => #f

(define o+
  (lambda (n m)
    (cond
     ((zero? m) n)
     (else (add1 (o+ n (sub1 m))))))) ;; => #<unspecified>

(o+ 46 12) ;; => 58

(define o-
  (lambda (n m)
    (cond
     ((zero? m) n)
     (else (sub1 (o- n (sub1 m))))))) ;; => #<unspecified>

(o- 14 3) ;; => 11
(o- 17 9) ;; => 8
(o- 18 25) ;; => -7, again, we pretend like negative numbers do not exist.

(define tup?
  (lambda (tup)
    (cond
     ((null? tup) #t)
     (else (and (number? (car tup))
                (tup? (cdr tup))))))) ;; => #<unspecified>

(tup? '(2 11 3 79 47 6)) ;; => #t
(tup? '(8 55 5 555)) ;; => #t
(tup? '(1 2 8 apple 4 3)) ;; => #f
(tup? '(3 (7 4) 13 9)) ;; => #f
(tup? '()) ;; => #t

(define addtup
  (lambda (tup)
    (cond
     ((null? tup) 0)
     (else (o+ (car tup)
               (addtup (cdr tup))))))) ;; => #<unspecified>

(addtup '(3 5 2 8)) ;; => 18
(addtup '(15 6 7 12 3)) ;; => 43

(define o*
  (lambda (m n)
    (cond
     ((zero? m) 0)
     (else (o+ n (o* (sub1 m) n)))))) ;; => #<unspecified>

(o* 5 3) ;; => 15
(o* 13 4) ;; => 52
(o* 12 3) ;; => 36

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Fifth Commandment ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; When building a value with o+, always use 0 for the value of the terminating
;; line, for adding 0 does not change the value of an addition.

;; When building a value with o*, always use 1 for the value of the terminating
;; line, for multiplying by 1 does not change the value of a multiplication.

;; When building a value with cons, always consider () for the value of the
;; terminating line.

(define tup+
  (lambda (tup1 tup2)
    (cond
     ((and (null? tup1)
           (null? tup2)) '())
     ((null? tup1) tup2)
     ((null? tup2) tup1)
     (else (cons (o+ (car tup1)
                     (car tup2))
                 (tup+ (cdr tup1)
                       (cdr tup2))))))) ;; => #<unspecified>

(tup+ '(3 6 9 11 4)
      '(8 5 2 0 7)) ;; => (11 11 11 11 11)
(tup+ '(2 3)
      '(4 6)) ;; => (6 9)
(tup+ '(3 7)
      '(4 6)) ;; => (7 13)
(tup+ '(3 7)
      '(4 6 8 1)) ;; => (7 13 8 1)

(define o>
  (lambda (n m)
    (cond
     ((zero? n) #f)
     ((zero? m) #t)
     (else (o> (sub1 n)
               (sub1 m)))))) ;; => #<unspecified>

(o> 12 133) ;; => #f
(o> 120 11) ;; => #t
(o> 0 0) ;; => #f

(define o<
  (lambda (n m)
    (cond
     ((zero? m) #f)
     ((zero? n) #t)
     (else (o< (sub1 n)
               (sub1 m)))))) ;; => #<unspecified>

(o< 12 133) ;; => #t
(o< 120 11) ;; => #f
(o< 0 0) ;; => #f

(define o=
  (lambda (n m)
    (cond
     ((zero? n) (zero? m))
     ((zero? n) #f)
     (else (o= (sub1 n)
               (sub1 m)))))) ;; => #<unspecified>

(o= 12 133) ;; => #f
(o= 120 11) ;; => #f
(o= 0 0) ;; => #t

(define o^
  (lambda (n m)
    (cond
     ((zero? m) 1)
     (else (o* n
               (o^ n (sub1 m))))))) ;; => #<unspecified>

(o^ 1 1) ;; => 1
(o^ 2 3) ;; => 8
(o^ 5 3) ;; => 125

(define o/
  (lambda (n m)
    (cond
     ((o< n m) 0)
     (else (add1 (o/ (o- n m) m)))))) ;; => #<unspecified>

(o/ 15 4) ;; => 3

(define olength
  (lambda (lat)
    (cond
     ((null? lat) 0)
     (else (add1 (olength (cdr lat))))))) ;; => #<unspecified>

(olength '(hotdogs with mustard sauerkraut and pickles)) ;; => 6
(olength '(ham and cheese on rye)) ;; => 5

(define pick
  (lambda (n lat)
    (cond
     ((zero? (sub1 n)) (car lat))
     (else (pick (sub1 n) (cdr lat)))))) ;; => #<unspecified>

(pick 4 '(lasagna spaghetti ravioli macaroni meatball)) ;; => macaroni

(define rempick
  (lambda (n lat)
    (cond
     ((zero? (sub1 n)) (cdr lat))
     (else (cons (car lat)
                 (rempick (sub1 n)
                          (cdr lat))))))) ;; => #<unspecified>

(rempick 3 '(hotdogs with hot mustard));; => (hotdogs with mustard)

(number? 'tomato) ;; => #f
(number? 76) ;; => #t

(define no-nums
  (lambda (lat)
    (cond
     ((null? lat) '())
     ((number? (car lat)) (no-nums (cdr lat)))
     (else (cons (car lat) (no-nums (cdr lat))))))) ;; => #<unspecified>

(no-nums '(5 pears 6 prunes 9 dates)) ;; => (pears prunes dates)

(define all-nums
  (lambda (lat)
    (cond
     ((null? lat) '())
     ((number? (car lat)) (cons (car lat)
                                (all-nums (cdr lat))))
     (else (all-nums (cdr lat)))))) ;; => #<unspecified>

(all-nums '(5 pears 6 prunes 9 dates)) ;; => (5 6 9)

(define equan?
  (lambda (a1 a2)
    (cond
     ((and (number? a1)
           (number? a2)) (o= a1 a2))
     ((or (number? a1)
          (number? a2)) #f)
     (else (eq? a1 a2))))) ;; => #<unspecified>

(equan? 3 3) ;; => #t
(equan? 3 'a) ;; => #f
(equan? 'a 'a) ;; => #t

(define occur
  (lambda (a lat)
    (cond
     ((null? lat) 0)
     ((equan? a (car lat)) (add1 (occur a (cdr lat))))
     (else (occur a (cdr lat)))))) ;; => #<unspecified>

(occur 'a '(a b c d a)) ;; => 2
(occur 2 '(1 2 3 4 2 4 2)) ;; => 3
(occur 2 '(a b 2 c d 2 e)) ;; => 2
(occur 'a '(a b 2 c d 2 e)) ;; => 1

(define one?
  (lambda (n)
    (o= n 1))) ;; => #<unspecified>

(define rempick
  (lambda (n lat)
    (cond
     ((one? n) (cdr lat))
     (else (cons (car lat)
                 (rempick (sub1 n)
                          (cdr lat)))))))

(rempick 3 '(hotdogs with hot mustard)) ;; => (hotdogs with mustard)
(rempick 3 '(lemon meringue salty pie)) ;; => (lemon meringue pie)

