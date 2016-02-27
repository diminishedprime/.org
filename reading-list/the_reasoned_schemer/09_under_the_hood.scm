(define var vector) ;; => #<unspecified>
(define var? vector?) ;; => #<unspecified>

(define u (var 'u)) ;; => #<unspecified>
(define v (var 'v)) ;; => #<unspecified>
(define w (var 'w)) ;; => #<unspecified>
(define x (var 'x)) ;; => #<unspecified>
(define y (var 'y)) ;; => #<unspecified>
(define z (var 'z)) ;; => #<unspecified>

(define lhs car) ;; => #<unspecified>
(define rhs cdr) ;; => #<unspecified>

(rhs `(,z . b)) ;; => b
(rhs `(,z . ,w)) ;; => #(w)
(rhs `(,z . (,x e ,y))) ;; => (#(x) e #(y))

(define empty-s '()) ;; => #<unspecified>

(define walk
  (lambda (v s)
    (cond
     ((var? v) (cond
                ((assq v s) => (lambda (a)
                                 (walk (rhs a) s)))
                (else v)))
     (else v)))) ;; => #<unspecified>

(walk u `((,x . b) (,w . (,x e ,x)) (,u . ,w))) ;; => (#(x) e #(x))

(define ext-s
  (lambda (x v s)
    (cons `(,x . ,v) s))) ;; => #<unspecified>

'(walk x (ext-s x y `((,z . ,x) (,y . ,z)))) ;; no value, has infinity recursion.
(walk y `((,x . e))) ;; => #(y)
(walk y (ext-s y x `((,x . e)))) ;; => e
(walk x `((,y . ,z) (,x . ,y))) ;; => #(z)
(walk x (ext-s z 'b `((,y . ,z) (,x . ,y)))) ;; => b
(walk x (ext-s z w `((,y . ,z) (,x . ,y)))) ;; => #(w)

(define unify
  (lambda (v w s)
    (let ((v (walk v s))
          (w (walk w s)))
      (cond
       ((eq? v w) s)
       ((var? v) (ext-s v w s))
       ((var? w) (ext-s w v s))
       ((and (pair? v) (pair? w)) (cond
                                   ((unify (car v) (car w) s) => (lambda (s)
                                                                   (unify (cdr v) (cdr w) s)))
                                   (else #f)))
       ((equal? v w) s)
       (else #f))))) ;; => #<unspecified>

(define walk*
  (lambda (v s)
    (let ((v (walk v s)))
      (cond
       ((var? v) v)
       ((pair? v) (cons (walk* (car v) s)
                        (walk* (cdr v) s)))
       (else v))))) ;; => #<unspecified>

(walk* x `((,y . (a ,z c))
           (,x . ,y)
           (,z . a))) ;; => (a a c)

(walk* x `((,y . (,z ,w c))
           (,x . ,y)
           (,z . a))) ;; => (a #(w) c)

(walk* y `((,y . (,w ,z c))
           (,v . b)
           (,x . ,v)
           (,z . ,x)
           )) ;; => (#(w) b c)

(define reify-name
  (lambda (n)
    (string->symbol
     (string-append "_" "." (number->string n))))) ;; => #<unspecified>

(define size-s length) ;; => #<unspecified>

(define reify-s
  (lambda (v s)
    (let ((v (walk v s)))
      (cond
       ((var? v) (ext-s v (reify-name (size-s s)) s))
       ((pair? v) (reify-s (cdr v)
                           (reify-s (car v) s)))
       (else s))))) ;; => #<unspecified>

(let ((r `(,w ,x ,y)))
  (walk* r (reify-s r empty-s))) ;; => (_.0 _.1 _.2)

(let ((r (walk* `(,x ,y ,z) empty-s)))
  (walk* r (reify-s r empty-s))) ;; => (_.0 _.1 _.2)

(let ((r `(,u (,v (,w ,x) ,y) ,x)))
  (walk* r (reify-s r empty-s))) ;; => (_.0 (_.1 (_.2 _.3) _.4) _.3)

(let ((s `((,y . (,z ,w c ,w))
           (,x . ,y)
           (,z . a))))
  (let ((r (walk* x s)))
    (walk* r (reify-s r empty-s)))) ;; => (a _.0 c _.0)

(define occurs-check
  (lambda (x v s)
    (let ((v (walk v s)))
      (cond
       ((var? v) (eq? v x))
       ((pair? v) (or (occurs-check x (car v) s)
                      (occurs-check x (cdr v) s)))
       (else #f))))) ;; => #<unspecified>

(define ext-s-check
  (lambda (x v s)
    (cond
     ((occurs-check x v s) #f)
     (else (ext-s x v s))))) ;; => #<unspecified>

(define unify-check
  (lambda (v w s)
    (let ((v (walk v s))
          (w (walk w s)))
      (cond
       ((eq? v w) s)
       ((var? v) (ext-s-check v w s))
       ((var? w) (ext-s-check w v s))
       ((and (pair? v)
             (pair? w)) (cond
                         ((unify-check (car v) (car w) s) => (lambda (s)
                                                               (unify-check (cdr v) (cdr w) s)))
                         (else #f)))
       ((equal? v w) s)
       (else #f))))) ;; => #<unspecified>
