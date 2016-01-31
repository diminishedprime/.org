(load "ss.scm")

(define x
  (cons 'chicago
        (cons 'pizza
              '())))
x
;; x is original (chicage pizza)
(set! x 'gone)
x
;; after we set bang x, it is now gone.
(set! x 'skins)
x
;; now it's skins

(define gourmet
  (lambda (food)
    (cons food
          (cons x '()))))

(gourmet 'onion)
;; this is onion skins at this point in the code.

(set! x 'rings)
(gourmet 'onion)
;; this is now onion rings.

(define gourmand
  (lambda (food)
    (set! x food)
    (cons food
          (cons x '()))))
(gourmand 'potato)
;; this is potato potato...
(gourmand 'rice)
;; this is rice rice

(define diner
  (lambda (food)
    (cons 'milkshake
          (cons food
                '()))))
(define dinerR
  (lambda (food)
    (set! x food)
    (cons 'milkshake
          (cons food
                '()))))
(dinerR 'onion)
;; milkshake onion. Eww.
x
;; x is now onion
(dinerR 'pecanpie)
;;milkshake pecanpieq
x
;; x is now pecanpie

(gourmand 'onion)
x
;; onion onion, then it sets x to onion.

(define omnivore
  (let ((x 'minestrone))
    (lambda (food)
      (set! x food)
      (cons food
            (cons x
                  '())))))
(omnivore 'bouillabaisse)
;; bouillabaisse bouillabaisse
x
;; still onion. woo

(define gobbler
  (let ((x 'minestrone))
    (lambda (food)
      (set! x food)
      (cons food
            (cons x '())))))
(gobbler 'gumbo)
;; gumbo gumbo
x
;; x is still onion.

(define food 'none)
(define glutton
  (lambda (x)
    (set! food x)
    (cons 'more
          (cons x
                (cons 'more
                      (cons x '()))))))
(glutton 'garlic)
;; more garlic more garlic
x
;; still happily an onion.

(define chez-nous
  (lambda ()
    (set! food x)
    (set! x food)))

;;this version blows up the original value of food. We can ue a let to
;;fix this problem, however.

(define cheznous
  (lambda ()
    (let ((a food))
      (set! food x)
      (set! x a))))

(glutton 'garlic)
;; more garlic more garlic
food
;; garlic

(gourmand 'potato)
;; potato potato
x
;; potato
(cheznous)
food
;; now potato
x
;; now garlic
