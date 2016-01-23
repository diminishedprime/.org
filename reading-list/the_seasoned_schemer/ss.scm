(define atom?
  (lambda (x)
    (and (not (pair? x))
         (not (null? x)))))
(define add1
  (lambda (x)
    (+ x 1)))
(define sub1
  (lambda (x)
    (- x 1)))
(define one?
  (lambda (n)
    (= n 1)))
(define zero?
  (lambda (n)
    (= n 0)))

(define Y
  (lambda (le)
    ((lambda (f) (f f))
     (lambda (f)
       (le (lambda (x) ((f f) x)))))))


(define member?
  (lambda (a lat)
    (letrec
        ((yes? (lambda (l)
                 (cond
                  ((null? l) #f)
                  ((eq? (car l) a) #t)
                  (else (yes? (cdr l)))))))
      (yes? lat))))
;; I believe both of these are defined from the little schemer.

(define eqan?
  (lambda (a1 a2)
    (cond
     ((and (number? a1)(number? a2)) (equal? a1 a2))
     ((or (number? a1)(number? a2)) #f)
     (else (eq? a1 a2)))))

(define eqlist?
  (lambda (list1 list2)
    (cond
     ((and (null? list1)(null? list2)) #t)
     ((or (null? list1)(null? list2)) #f)
     ((and (atom? (car list1))(atom? (car list2)))
      (and (eqan? (car list1)(car list2))(eqlist? (cdr list1)(cdr list2))))
     ((or (atom? (car list1))(atom? (car list2))) #f)
     (else
      (and (eqlist? (car list1)(car list2))
           (eqlist? (cdr list1)(cdr list2)))))))

(define call/cc call-with-current-continuation)

(define same?
  (lambda (a b)
    (cond
     ((list? a)
      (and (list? b)
           (eqlist? a b)))
     ((atom? a)
      (and (atom? b)
           (eqan? a b))))))

(define test
  (lambda (a)
    (if a
        "The test was successful"
        (test-failed))))

(define (test-failed)
  (error "The test failed"))
