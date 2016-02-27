(load "mk.scm") ;; => #<unspecified>
(load "mkextraforms.scm") ;; => #<unspecified>
(load "previous_chapters.scm") ;; => #<unspecified>

;;;;;;;;;;;;;;;;;;;;;;
;; The Law of conda ;;
;;;;;;;;;;;;;;;;;;;;;;

;; If the question of a conda line succeeds, pretend that the remaining conda
;; lines have been replaced by a single (else #u)

(define not-pasto
  (lambda (x)
    (conda
     ((== 'pasta x) U)
     (else S)))) ;; => #<unspecified>

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Third Commandment ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; If prior to determining the question of a conda line a variable is fresh, it
;; must remain fresh in the question of that line.

;;;;;;;;;;;;;;;;;;;;;;
;; The Law of condu ;;
;;;;;;;;;;;;;;;;;;;;;;

;; condu behaves like conda, except that a successful question succeeds only
;; once.

(define onceo
  (lambda (g)
    (condu
     (g S)
     (else U)))) ;; => #<unspecified>

(define bumpo
  (lambda (n x)
    (conde
     ((== n x) S)
     (else (fresh (m)
                  (-o n `(1) m)
                  (bumpo m x)))))) ;; => #<unspecified>

(run* (x)
      (bumpo `(1 1 1) x)) #| => |# '(
                                     (1 1 1)
                                     (0 1 1)
                                     (1 0 1)
                                     (0 0 1)
                                     (1 1)
                                     (0 1)
                                     (1)
                                     ()
                                     )
(define gen&testo
  (lambda (op i j k)
    (onceo
     (fresh (x y z)
            (op x y z)
            (== i x)
            (== j y)
            (== k z))))) ;; => #<unspecified>

(run* (q)
      (gen&testo +o `(0 0 1) `(1 1) `(1 1 1))
      (== #t q)) ;; => (#t)

(define enumerato
  (lambda (op r n)
    (fresh (i j k)
           (bumpo n i)
           (bumpo n j)
           (op i j k)
           (gen&testo op i j k)
           (== `(,i ,j ,k) r)))) ;; => #<unspecified>

(run* (s)
      (enumerato +o s `(1 1))) #| => |# '(
                                          ((1 1) (1 1) (0 1 1))
                                          ((1 1) (0 1) (1 0 1))
                                          ((1 1) (1) (0 0 1))
                                          ((1 1) () (1 1))
                                          ((0 1) (1 1) (1 0 1))
                                          ((0 1) (0 1) (0 0 1))
                                          ((0 1) (1) (1 1))
                                          ((0 1) () (0 1))
                                          ((1) (1 1) (0 0 1))
                                          ((1) (0 1) (1 1))
                                          ((1) (1) (0 1))
                                          ((1) () (1))
                                          (() (1 1) (1 1))
                                          (() (0 1) (0 1))
                                          (() (1) (1))
                                          (() () ())
                                          )


(define gen-addero
  (lambda (d n m r)
    (fresh (a b c e x y z)
           (== `(,a . ,x) n)
           (== `(,b . ,y) m) (poso y)
           (== `(,c . ,z) r) (poso z)
           (all
            (full-addero d a b c e)
            (addero e x y z))))) ;; => #<unspecified>
