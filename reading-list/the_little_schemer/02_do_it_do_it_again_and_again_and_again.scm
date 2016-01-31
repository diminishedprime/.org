(load "ls.scm") ;; => #<unspecified>

(define lat?
  (lambda (l)
    (cond
     ((null? l) #t)
     ((atom? (car l)) (lat? (cdr l)))
     (else #f))))

(lat? '(Jack Spart could eat no chicken fat)) ;; => #t
(lat? '((Jack) Spart could eat no chicken fat)) ;; => #f
(lat? '(Jack (Spart could) eat no chicken fat)) ;; => #f
(lat? '()) ;; => #t
(lat? '(bacon and eggs)) ;; => #t

(or (null? '())
    (atom? '(d e f))) ;; => #t
(or (atom? '(d e f))
    (null? '())) ;; => #t
(or (atom? '(a b c))
    (null? '(atom))) ;; => #f

(define member?
  (lambda (a lat)
    (cond
     ((null? lat) #f)
     (else (or (eq? (car lat) a)
               (member? a (cdr lat))))))) ;; => #<unspecified>

(member? 'tea '(coffee tea or milk)) ;; => #t
(member? 'poached '(friend eggs and scrambled eggs)) ;; => #f
(member? 'meat '(mashed potatoes and meat gravy)) ;; => #t

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The First Commandment ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (preliminary) Always ask null? as the first question in expressing any
;; question.
