(load "ls.scm") ;; => #<unspecified>

(define rember
  (lambda (a lat)
    (cond
     ((null? lat) '())
     ((eq? a (car lat)) (cdr lat))
     (else (cons (car lat)
                 (rember a (cdr lat))))))) ;; => #<unspecified>

(rember 'mint '(lamb chops and mint jelly)) ;; => (lamb chops and jelly)
(rember 'mint '(lamb chops and mint flavored mint jelly)) ;; => (lamb chops and flavored mint jelly)
(rember 'toast '(bacon lettuce and tomato)) ;; => (bacon lettuce and tomato)
(rember 'cup '(coffe cup tea cup and huck cup)) ;; => (coffe tea cup and huck cup)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Second Commandment ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Use cons to build lists. 

(rember 'and '(bacon lettuce and tomato)) ;; => (bacon lettuce tomato)
(rember 'sauce '(soy sauce and tomato sauce)) ;; => (soy and tomato sauce)

(define firsts
  (lambda (l)
    (cond
     ((null? l) '())
     (else (cons (car (car l))
                 (firsts (cdr l))))))) ;; => #<unspecified>

(firsts '((apple peach pumpkin)
          (plum pear cherry)
          (grape raisin pea)
          (bean carrot eggplant))) ;; => (apple plum grape bean)
(firsts '((a b) (c d) (e f))) ;; => (a c e)
(firsts '()) ;; => ()
(firsts '((five plums)
          (four)
          (eleven green oranges))) ;; => (five four eleven)
(firsts '(((five plums) four)
          (eleven green oranges)
          ((no) mone))) ;; => ((five plums) eleven (no))


(define insertR
  (lambda (new old lat)
    (cond
     ((null? lat) '())
     ((eq? old (car lat)) (cons old (cons new (cdr lat))))
     (else (cons (car lat) (insertR new old (cdr lat)))))));; => #<unspecified>

(insertR 'topping 'fudge '(ice cream with fudge for dessert)) ;; => (ice cream with fudge topping for dessert)
(insertR 'jalapeno 'and '(tacos tamales and salsa)) ;; => (tacos tamales and jalapeno salsa)
(insertR 'e 'd '(a b c d f g d h)) ;; => (a b c d e f g d h)

(define insertL
  (lambda (new old lat)
    (cond
     ((null? lat) '())
     ((eq? old (car lat)) (cons new (cons old (cdr lat))))
     (else (cons (car lat) (insertL new old (cdr lat))))))) ;; => #<unspecified>

(insertL 'topping 'fudge '(ice cream with fudge for dessert)) ;; => (ice cream with topping fudge for dessert)
(insertL 'jalapeno 'and '(tacos tamales and salsa)) ;; => (tacos tamales jalapeno and salsa)
(insertL 'e 'd '(a b c d f g d h)) ;; => (a b c e d f g d h)

(define subst
  (lambda (new old lat)
    (cond
     ((null? lat) '())
     ((eq? old (car lat)) (cons new (cdr lat)))
     (else (cons (car lat) (subst new old (cdr lat)))))));; => #<unspecified>

(subst 'topping 'fudge '(ice cream with fudge for dessert)) ;; => (ice cream with topping for dessert)
(subst 'jalapeno 'and '(tacos tamales and salsa)) ;; => (tacos tamales jalapeno salsa)
(subst 'e 'd '(a b c d f g d h)) ;; => (a b c e f g d h)

(define subst2
  (lambda (new old1 old2 lat)
    (cond
     ((null? lat) '())
     ( (or (eq? old1 (car lat))
           (eq? old2 (car lat))) (cons new (cdr lat)))
     (else (cons (car lat) (subst2 new old1 old2 (cdr lat))))))) ;; => #<unspecified>

(subst2 'vanilla 'chocolate 'banana '(banana ice cream with chocolate topping)) ;; => (vanilla ice cream with chocolate topping)

(define multirember
  (lambda (a lat)
    (cond
     ((null? lat) '())
     ((eq? a (car lat)) (multirember a (cdr lat)))
     (else (cons (car lat) (multirember a (cdr lat))))))) ;; => #<unspecified>

(multirember 'cup '(coffee cup tea cup and hick cup));; => (coffee tea and hick)

(define multiinsertR
  (lambda (new old lat)
    (cond
     ((null? lat) '())
     ((eq? old (car lat)) (cons old (cons new (multiinsertR new old (cdr lat)))))
     (else (cons (car lat) (multiinsertR new old (cdr lat))))))) ;; => #<unspecified>

(multiinsertR 'is-great 'cup '(coffee cup tea cup and hick cup)) ;; => (coffee cup is-great tea cup is-great and hick cup is-great)

(define multiinsertL
  (lambda (new old lat)
    (cond
     ((null? lat) '())
     ((eq? old (car lat)) (cons new (cons old (multiinsertL new old (cdr lat)))))
     (else (cons (car lat) (multiinsertL new old (cdr lat)))))));; => #<unspecified>

(multiinsertL 'is-great 'cup '(coffee cup tea cup and hick cup)) ;; => (coffee is-great cup tea is-great cup and hick is-great cup)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Fourth Commandment ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (preliminary) Always change at least one argument while recurring. It must be
;; changed to be closer to termination. The changing argument must be tested in
;; the termination condition: when using cdr, test termination with null?

(define multisubst
  (lambda (new old lat)
    (cond
     ((null? lat) '())
     ((eq? old (car lat)) (cons new (multisubst new old (cdr lat))))
     (else (cons (car lat) (multisubst new old (cdr lat))))))) ;; => #<unspecified>

(multisubst 'is-great 'cup '(coffee cup tea cup and hick cup)) ;; => (coffee is-great tea is-great and hick is-great)
