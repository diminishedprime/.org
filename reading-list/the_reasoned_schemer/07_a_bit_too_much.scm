(load "mk.scm") ;; => #<unspecified>
(load "mkextraforms.scm") ;; => #<unspecified>
(load "previous_chapters.scm") ;; => #<unspecified>

(define bit-xoro
  (lambda (x y r)
    (conde
     ((== 0 x) (== 0 y) (== 0 r))
     ((== 1 x) (== 0 y) (== 1 r))
     ((== 0 x) (== 1 y) (== 1 r))
     ((== 1 x) (== 1 y) (== 0 r))
     (else U)))) ;; => #<unspecified>

(run* (s)
      (fresh (x y)
             (bit-xoro x y 0)
             (== `(,x ,y) s))) #| => |# '(
                                          (0 0)
                                          (1 1)
                                          )

(run* (s)
      (fresh (x y)
             (bit-xoro x y 1)
             (== `(,x ,y) s))) #| => |# '(
                                          (1 0)
                                          (0 1)
                                          )

(run* (s)
      (fresh (x y r)
             (bit-xoro x y r)
             (== `(,x ,y ,r) s))) #| => |# '(
                                             (0 0 0)
                                             (1 0 1)
                                             (0 1 1)
                                             (1 1 0)
                                             )
(define bit-ando
  (lambda (x y r)
    (conde
     ((== 0 x) (== 0 y) (== 0 r))
     ((== 1 x) (== 0 y) (== 0 r))
     ((== 0 x) (== 1 y) (== 0 r))
     ((== 1 x) (== 1 y) (== 1 r))
     (else U)))) ;; => #<unspecified>

(run* (s)
      (fresh (x y)
             (bit-ando x y 1)
             (== `(,x ,y) s))) ;; => ((1 1))

(define half-addero
  (lambda (x y r c)
    (all
     (bit-xoro x y r)
     (bit-ando x y c)))) ;; => #<unspecified>

(run* (r)
      (half-addero 1 1 r 1)) ;; => (0)

(run* (s)
      (fresh (x y r c)
             (half-addero x y r c)
             (== `(,x ,y ,r ,c) s))) #| => |# '(
                                                (0 0 0 0)
                                                (1 0 1 0)
                                                (0 1 1 0)
                                                (1 1 0 1)
                                                )

(define full-addero
  (lambda (b x y r c)
    (fresh (w xy wz)
           (half-addero x y w xy)
           (half-addero w b r wz)
           (bit-xoro xy wz c)))) ;; => #<unspecified>

(run* (s)
      (fresh (r c)
             (full-addero 0 1 1 r c)
             (== `(,r ,c) s))) ;; => ((0 1))

(run* (s)
      (fresh (r c)
             (full-addero 1 1 1 r c)
             (== `(,r ,c) s))) ;; => ((1 1))

(run* (s)
      (fresh (b x y r c)
             (full-addero b x y r c)
             (== `(,b ,x ,y ,r ,c) s))) #| => |# '(
                                                   (0 0 0 0 0)
                                                   (1 0 0 1 0)
                                                   (0 1 0 1 0)
                                                   (1 1 0 0 1)
                                                   (0 0 1 1 0)
                                                   (1 0 1 0 1)
                                                   (0 1 1 0 1)
                                                   (1 1 1 1 1)
                                                   )

(define build-num
  (lambda (n)
    (cond
     ((zero? n) '())
     ((and (not (zero? n)) (even? n)) (cons 0
                                            (build-num (/ n 2))))
     ((odd? n) (cons 1
                     (build-num (/ (- n 1) 2))))))) ;; => #<unspecified>

(define build-num
  (lambda (n)
    (cond
     ((odd? n) (cons 1
                     (build-num (/ (- n 1) 2))))
     ((and (not (zero? n)) (even? n)) (cons 0
                                            (build-num (/ n 2))))
     ((zero? n) '())))) ;; => #<unspecified>

(define poso
  (lambda (n)
    (fresh (a d)
           (== `(,a . ,d) n)))) ;; => #<unspecified>

(run* (q)
      (poso '(0 1 1))
      (== #t q)) ;; => (#t)

(run* (q)
      (poso '(1))
      (== #t q)) ;; => (#t)

(run* (q)
      (poso '())
      (== #t q)) ;; => ()

(run* (r)
      (poso r)) ;; => ((_.0 . _.1))

(define >1o
  (lambda (n)
    (fresh (a ad dd)
           (== `(,a ,ad . ,dd) n)))) ;; => #<unspecified>

(run* (q)
      (>1o '(0 1 1))
      (== #t q)) ;; => (#t)

(run* (q)
      (>1o '(0 1))
      (== #t q)) ;; => (#t)

(run* (q)
      (>1o '(1))
      (== #t q)) ;; => ()

(run* (q)
      (>1o '())
      (== #t q)) ;; => ()

(run* (q)
      (>1o q)) ;; => ((_.0 _.1 . _.2))

(define gen-addero
  (lambda (d n m r)
    (fresh (a b c e x y z)
           (== `(,a . ,x) n)
           (== `(,b . ,y) m) (poso y)
           (== `(,c . ,z) r) (poso z)
           (alli
            (full-addero d a b c e)
            (addero e x y z))))) ;; => #<unspecified>

(define addero
  (lambda (d n m r)
    (condi
     ((== 0 d) (== '() m) (== n r))
     ((== 0 d) (== '() n) (== m r) (poso m))
     ((== 1 d) (== '() m) (addero 0 n '(1) r))
     ((== 1 d) (== '() n) (poso m) (addero 0 '(1) m r))
     ((== '(1) n) (== '(1) m) (fresh (a c)
                                     (== `(,a ,c) r)
                                     (full-addero d 1 1 a c)))
     ((== '(1) n) (gen-addero d n m r))
     ((== '(1) m) (>1o n) (>1o r) (addero d '(1) n r))
     ((>1o n) (gen-addero d n m r))
     (else U)))) ;; => #<unspecified>


;; wait for addero
(run 3 (s)
     (fresh (x y r)
            (addero 0 x y r)
            (== `(,x ,y ,r) s))) #| => |# '(
                                            (_.0 () _.0)
                                            (() (_.0 . _.1) (_.0 . _.1))
                                            ((1) (1) (0 1))
                                            )

(run 22 (s)
     (fresh (x y r)
            (addero 0 x y r)
            (== `(,x ,y ,r) s))) #| => |# '(
                                            (_.0 () _.0)
                                            (() (_.0 . _.1) (_.0 . _.1))
                                            ((1) (1) (0 1))
                                            ((1) (0 _.0 . _.1) (1 _.0 . _.1))
                                            ((0 _.0 . _.1) (1) (1 _.0 . _.1))
                                            ((1) (1 1) (0 0 1))
                                            ((0 1) (0 1) (0 0 1))
                                            ((1) (1 0 _.0 . _.1) (0 1 _.0 . _.1))
                                            ((1 1) (1) (0 0 1))
                                            ((1) (1 1 1) (0 0 0 1))
                                            ((1 1) (0 1) (1 0 1))
                                            ((1) (1 1 0 _.0 . _.1) (0 0 1 _.0 . _.1))
                                            ((1 0 _.0 . _.1) (1) (0 1 _.0 . _.1))
                                            ((1) (1 1 1 1) (0 0 0 0 1))
                                            ((0 1) (0 0 _.0 . _.1) (0 1 _.0 . _.1))
                                            ((1) (1 1 1 0 _.0 . _.1) (0 0 0 1 _.0 . _.1))
                                            ((1 1 1) (1) (0 0 0 1))
                                            ((1) (1 1 1 1 1) (0 0 0 0 0 1))
                                            ((0 1) (1 1) (1 0 1))
                                            ((1) (1 1 1 1 0 _.0 . _.1) (0 0 0 0 1 _.0 . _.1))
                                            ((1 1 0 _.0 . _.1) (1) (0 0 1 _.0 . _.1))
                                            ((1) (1 1 1 1 1 1) (0 0 0 0 0 0 1))
                                            )

(define width
  (lambda (n)
    (cond
     ((null? n) 0)
     ((pair? n) (+ (width (cdr n)) 1))
     (else 1)))) ;; => #<unspecified>

(run* (s)
      (gen-addero 1 '(0 1 1) '(1 1) s)) ;; => ((0 1 0 1))

(run* (s)
      (fresh (x y)
             (addero 0 x y '(1 0 1))
             (== `(,x ,y) s))) #| => |# '(
                                          ((1 0 1) ())
                                          (() (1 0 1))
                                          ((1) (0 0 1))
                                          ((0 0 1) (1))
                                          ((1 1) (0 1))
                                          ((0 1) (1 1))
                                          )


(define +o
  (lambda (n m k)
    (addero 0 n m k))) ;; => #<unspecified>

(run* (s)
      (fresh (x y)
             (+o x y '(1 0 1))
             (== `(,x ,y) s))) #| => |# '(
                                          ((1 0 1) ())
                                          (() (1 0 1))
                                          ((1) (0 0 1))
                                          ((0 0 1) (1))
                                          ((1 1) (0 1))
                                          ((0 1) (1 1))
                                          )
(define -o
  (lambda (n m k)
    (+o m k n))) ;; => #<unspecified>

(run* (q)
      (-o '(0 0 0 1) '(1 0 1) q)) ;; => ((1 1))

(run* (q)
      (-o '(0 1 1) '(0 1 1) q)) ;; => (())

;; Since we don't handle negative numbers, we cannot subtract 8 from 6.
(run* (q)
      (-o '(0 1 1) '(0 0 0 1) q)) ;; => ()
