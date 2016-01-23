(define atom?
  (lambda (x)
    (and (not (pair? x)) (not (null? x)))))
(define add1
  (lambda (x)
    (+ 1 x)))
