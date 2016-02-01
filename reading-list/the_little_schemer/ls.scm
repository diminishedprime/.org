(define atom?
  (lambda (x)
    (and (not (pair? x)) (not (null? x)))))

(define add1
  (lambda (x)
    (+ x 1)))

(define sub1
  (lambda (x)
    (- x 1)))

(define o+
  (lambda (n m)
    (cond
     ((zero? m) n)
     (else (add1 (o+ n (sub1 m)))))))

(define o-
  (lambda (n m)
    (cond
     ((zero? m) n)
     (else (sub1 (o- n (sub1 m)))))))

(define o*
  (lambda (m n)
    (cond
     ((zero? m) 0)
     (else (o+ n (o* (sub1 m) n))))))

(define o>
  (lambda (n m)
    (cond
     ((zero? n) #f)
     ((zero? m) #t)
     (else (o> (sub1 n)
               (sub1 m))))))

(define o<
  (lambda (n m)
    (cond
     ((zero? m) #f)
     ((zero? n) #t)
     (else (o< (sub1 n)
               (sub1 m))))))

(define o=
  (lambda (n m)
    (cond
     ((zero? n) (zero? m))
     ((zero? n) #f)
     (else (o= (sub1 n)
               (sub1 m))))))

(define o^
  (lambda (n m)
    (cond
     ((zero? m) 1)
     (else (o* n
               (o^ n (sub1 m)))))))

(define o/
  (lambda (n m)
    (cond
     ((o< n m) 0)
     (else (add1 (o/ (o- n m) m))))))

(define equan?
  (lambda (a1 a2)
    (cond
     ((and (number? a1)
           (number? a2)) (o= a1 a2))
     ((or (number? a1)
          (number? a2)) #f)
     (else (eq? a1 a2)))))
