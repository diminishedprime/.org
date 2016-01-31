;;; Code that accompanies ``The Reasoned Schemer''
;;; Daniel P. Friedman, William E. Byrd and Oleg Kiselyov
;;; MIT Press, Cambridge, MA, 2005
;;;
;;; The implementation of the logic system used in the book

;;; This file was generated by writeminikanren.pl
;;; Generated at 2005-08-12 11:27:16

(define-syntax lambdag@
  (syntax-rules ()
    ((_ (s) e) (lambda (s) e))))

(define-syntax lambdaf@
  (syntax-rules ()
    ((_ () e) (lambda () e))))

(define rhs cdr)
(define lhs car)
(define size-s length)
(define var vector)
(define var? vector?)
  
(define empty-s '())

(define walk
  (lambda (v s)
    (cond
      ((var? v)
       (cond
         ((assq v s) =>
          (lambda (a)
            (walk (rhs a) s)))
         (else v)))
      (else v))))

(define ext-s
  (lambda (x v s)
    (cons `(,x . ,v) s)))
 
(define unify
  (lambda (v w s)
    (let ((v (walk v s))
          (w (walk w s)))
      (cond
        ((eq? v w) s)
        ((var? v) (ext-s v w s))
        ((var? w) (ext-s w v s))
        ((and (pair? v) (pair? w))
         (cond
           ((unify (car v) (car w) s) =>
            (lambda (s)
              (unify (cdr v) (cdr w) s)))
           (else #f)))
        ((equal? v w) s)
        (else #f)))))

(define ext-s-check
  (lambda (x v s)
    (cond
      ((occurs-check x v s) #f)
      (else (ext-s x v s)))))

(define occurs-check
  (lambda (x v s)
    (let ((v (walk v s)))
      (cond
        ((var? v) (eq? v x))
        ((pair? v) 
         (or 
           (occurs-check x (car v) s)
           (occurs-check x (cdr v) s)))
        (else #f)))))

(define unify-check
  (lambda (v w s)
    (let ((v (walk v s))
          (w (walk w s)))
      (cond
        ((eq? v w) s)
        ((var? v) (ext-s-check v w s))
        ((var? w) (ext-s-check w v s))
        ((and (pair? v) (pair? w))
         (cond
           ((unify-check (car v) (car w) s) =>
            (lambda (s)
              (unify-check (cdr v) (cdr w) s)))
           (else #f)))
        ((equal? v w) s)
        (else #f)))))

(define walk*
  (lambda (v s)
    (let ((v (walk v s)))
      (cond
        ((var? v) v)
        ((pair? v)
         (cons
           (walk* (car v) s)
           (walk* (cdr v) s)))
        (else v)))))

(define reify-s
  (lambda (v s)
    (let ((v (walk v s)))
      (cond
        ((var? v) (ext-s v (reify-name (size-s s)) s))
        ((pair? v) (reify-s (cdr v) (reify-s (car v) s)))
        (else s)))))

(define reify-name
  (lambda (n)
    (string->symbol
      (string-append "_" "." (number->string n)))))

(define reify
  (lambda (v)
    (walk* v (reify-s v empty-s))))

(define-syntax run  
  (syntax-rules ()
    ((_ n^ (x) g ...)
     (let ((n n^) (x (var 'x)))
       (if (or (not n) (> n 0))
         (map-inf n
           (lambda (s)
             (reify (walk* x s)))
           ((all g ...) empty-s))
         '())))))

(define-syntax case-inf
  (syntax-rules ()
    ((_ e on-zero ((a^) on-one) ((a f) on-choice))
     (let ((a-inf e))
       (cond
         ((not a-inf) on-zero)
         ((not (and 
                 (pair? a-inf)
                 (procedure? (cdr a-inf))))
          (let ((a^ a-inf))
            on-one))
         (else (let ((a (car a-inf))
                     (f (cdr a-inf)))
                 on-choice)))))))

(define-syntax mzero
  (syntax-rules ()
    ((_) #f)))

(define-syntax unit
  (syntax-rules ()
    ((_ a) a)))

(define-syntax choice 
  (syntax-rules ()
    ((_ a f) (cons a f))))

(define map-inf
  (lambda (n p a-inf)
    (case-inf a-inf
      '()
      ((a) 
       (cons (p a) '()))
      ((a f) 
       (cons (p a)
         (cond
           ((not n) (map-inf n p (f)))
           ((> n 1) (map-inf (- n 1) p (f)))
           (else '())))))))

(define succeed (lambdag@ (s) (unit s)))
(define fail (lambdag@ (s) (mzero)))

(define == 
  (lambda (v w)
    (lambdag@ (s)
      (cond
        ((unify v w s) => succeed)
        (else (fail s))))))

(define ==-check
  (lambda (v w)
    (lambdag@ (s)
      (cond
        ((unify-check v w s) => succeed)
        (else (fail s))))))

(define-syntax fresh 
  (syntax-rules ()
    ((_ (x ...) g ...)
     (lambdag@ (s)
       (let ((x (var 'x)) ...)
         ((all g ...) s))))))

(define-syntax conde
  (syntax-rules ()
    ((_ c ...) (cond-aux ife c ...))))

(define-syntax all
  (syntax-rules ()
    ((_ g ...) (all-aux bind g ...))))

(define-syntax alli
  (syntax-rules ()
    ((_ g ...) (all-aux bindi g ...))))

(define-syntax condi
  (syntax-rules ()
    ((_ c ...) (cond-aux ifi c ...))))

(define-syntax conda
  (syntax-rules ()
    ((_ c ...) (cond-aux ifa c ...))))

(define-syntax condu
  (syntax-rules ()
    ((_ c ...) (cond-aux ifu c ...))))

(define mplus
  (lambda (a-inf f)
    (case-inf a-inf
      (f) 
      ((a) (choice a f))
      ((a f0) (choice a 
                (lambdaf@ () (mplus (f0) f)))))))

(define bind
  (lambda (a-inf g)
    (case-inf a-inf
      (mzero) 
      ((a) (g a))
      ((a f) (mplus (g a)
               (lambdaf@ () (bind (f) g)))))))

(define mplusi
  (lambda (a-inf f)
    (case-inf a-inf
      (f) 
      ((a) (choice a f))
      ((a f0) (choice a 
                (lambdaf@ () (mplusi (f) f0)))))))

(define bindi
  (lambda (a-inf g)
    (case-inf a-inf
      (mzero)
      ((a) (g a))
      ((a f) (mplusi (g a)                                                  
               (lambdaf@ () (bindi (f) g)))))))

(define-syntax all-aux
  (syntax-rules ()
    ((_ bnd) succeed)
    ((_ bnd g) g)
    ((_ bnd g0 g ...)
     (let ((g^ g0))
       (lambdag@ (s)
         (bnd (g^ s) 
           (lambdag@ (s) ((all-aux bnd g ...) s))))))))

(define-syntax cond-aux
  (syntax-rules (else)
    ((_ ifer) fail)
    ((_ ifer (else g ...)) (all g ...))
    ((_ ifer (g ...)) (all g ...))
    ((_ ifer (g0 g ...) c ...)
     (ifer g0
       (all g ...)
       (cond-aux ifer c ...)))))

(define-syntax ife
  (syntax-rules ()
    ((_ g0 g1 g2)
     (lambdag@ (s)
       (mplus ((all g0 g1) s) (lambdaf@ () (g2 s)))))))

(define-syntax ifi
  (syntax-rules ()
    ((_ g0 g1 g2)
     (lambdag@ (s)
       (mplusi ((all g0 g1) s) (lambdaf@ () (g2 s)))))))

(define-syntax ifa
  (syntax-rules ()
    ((_ g0 g1 g2)
     (lambdag@ (s)
       (let ((s-inf (g0 s)))
         (case-inf s-inf
           (g2 s)
           ((s) (g1 s))
           ((s f) (bind s-inf g1))))))))

(define-syntax ifu
  (syntax-rules ()
    ((_ g0 g1 g2)
     (lambdag@ (s)
       (let ((s-inf (g0 s)))
         (case-inf s-inf
           (g2 s)
           ((s) (g1 s))
           ((s f) (g1 s))))))))

(+ 1 1)
