(load "ss.scm")

(define intersect
  (lambda (set1 set2)
    (cond
     ((null? set1) '())
     ((member? (car set1) set2)
      (cons (car set1) (intersect (cdr set1) set2)))
     (else (intersect (cdr set1) set2)))))

(intersect '(tomatoes and macaroni) '(macaroni and cheese))

(define intersect
  (lambda (set1 set2)
    (letrec
        ((I (lambda (set)
              (cond
               ((null? set) '())
               ((member? (car set) set2)
                (cons (car set) (I (cdr set))))
               (else (I (cdr set)))))))
      (I set1))))

(intersect '(tomatoes and macaroni) '(macaroni and cheese))

(define intersectall
  (lambda (lset)
    (cond
     ((null? (cdr lset)) (car lset))
     (else (intersect (car lset)
                      (intersectall (cdr lset)))))))

;; intersectall that doesn't assume lset isn't null
(define intersectall
  (lambda (lset)
    (cond
     ((null? lset) '())
     ((null? (cdr lset)) (car lset))
     (else (intersect (car lset)
                      (intersectall (cdr lset)))))))

;; but we ask if it's null every time which is unnecessary since after
;; the initial call, intersectall does not recur when it knows that
;; the cdr of the list is empty. Better to use letrec to clean it up.

(define intersectall
  (lambda (lset)
    (letrec
        ((intersectall (lambda (lset)
                         (cond
                          ((null? (cdr lset)) (car lset))
                          (else (intersect (car lset)
                                           (intersectall (cdr lset))))))))
      (cond
       ((null? lset) '())
       (else (intersectall lset))))))

(intersectall '((3 mangos and ) (3 kiwis and) (3 hamburgers)))
(intersectall '((3 mangoes and) () (3 diet hamburgers)))

;; but this still isn't completly ideal. As show in the previous
;; example, if the empty list is one of the arguments, the result will
;; always be the empty list. So if the empty list is somewhere in the
;; middle, it would be best if we could stop the calculation and
;; return '().

;; And that is where letcc comes in...

(define intersectall
  (lambda (lset)
    (call-with-current-continuation
     (lambda (hop)
       (letrec
           ((A (lambda (lset)
                 (cond
                  ((null? (car lset)) (hop '(for teh proofz)))
                  ((null? (cdr lset)) (car lset))
                  (else (intersect (car lset)
                                   (A (cdr lset))))))))
         (cond
          ((null? lset) '())
          (else (A lset))))))))

(intersectall '((3 mangos and ) (3 kiwis and) (3 hamburgers)))
(intersectall '((3 mangoes and) () (3 diet hamburgers)))

;; This new version is better. When it sees an empty set as one of the
;; arguments, it skips the rest of the argument and returns '(for teh
;; proofz) which is just something I put in there to prove that it's
;; actually working

(intersectall '((3 steaks and)
                (no food and)
                (three baked potatoes)
                (3 diet hamburgers)))

;; It's still not ideal, though. As we go through, we find ourselves
;; trying to intersect on the empty set again...

(define intersect
  (lambda (set1 set2)
    (letrec
        ((I (lambda (set)
              (cond
               ((null? set) '())
               ((member? (car set) set2)
                (cons (car set) (I (cdr set))))
               (else (I (cdr set)))))))
      (cond
       ((null? set2) '())
       (else (I set1))))))

;; this slightly improves the situation, at least it returns
;; immedietly when the second argument is the empty list now. We still
;; have a problem, though, because as soon as one of the intersects
;; returns the empty list, we know our answer. When end up duplicating
;; the question


(define intersectall
  (lambda (lset)
    (call-with-current-continuation
     (lambda (hop)
       (letrec
           ((A (lambda (lset)
                 (cond
                  ((null? (car lset)) (hop '(don't you go givin me a null)))
                  ((null? (cdr lset)) (car lset))
                  (else (I (car lset)
                           (A (cdr lset)))))))
            (I (lambda (s1 s2)
                 (letrec
                     ((I (lambda (s1)
                           (cond
                            ((null? s1) '())
                            ((member? (car s1) s2)
                             (cons (car s1) (I (cdr s1))))
                            (else (I (cdr s1)))))))
                   (cond
                    ((null? s2) (hop '(aww yiss you have me a null)))
                    (else (I s1)))))))
         (cond
          ((null? lset) '())
          (else (A lset))))))))

(intersectall '((3 steaks and)
                (no food and)
                (three baked potatoes)
                (3 diet hamburgers)))

;; It mights seem weird that I used the function name I twice, both in
;; letrecs, but the names don't matter when it comes to shadowing.
;; Also, this version is pretty cool, it returns promptly as soon as
;; s2 is null.

(define rember
  (lambda (a lat)
    (letrec
        ((R (lambda (lat)
              (cond
               ((null? lat) '())
               ((eq? (car lat) a) (cdr lat))
               (else (cons (car lat) (R (cdr lat))))))))
      (R lat))))

(define rember-beyond-first
  (lambda (a lat)
    (letrec
        ((R (lambda (lat)
              (cond
               ((null? lat) '())
               ((eq? (car lat) a) '())
               (else (cons (car lat) (R (cdr lat))))))))
      (R lat))))

(rember-beyond-first 'roots '(noodles spaghetti spatzle bean-thread roots potatoes yam others rice))
(rember-beyond-first 'others '(noodles spaghetti spatzle bean-thread roots potatoes yam others rice))
(rember-beyond-first 'sweetthing '(noodles spaghetti spatzle bean-thread roots potatoes yam others rice))
(rember-beyond-first 'desserts '(cookies chocolate minths caramel delight ginger snaps desserts chocolate
                                         mousse vanilla ice cream German chocolate cake more desserts
                                         gingerbreadman chocolate chip brownies))

;; This method simple returns the list passed in up-to the first
;; occurance of a, or the entire list if a is not present

(define rember-upto-last
  (lambda (a lat)
    (call-with-current-continuation
     (lambda (skip)
       (letrec
           ((R (lambda (lat)
                 (cond
                  ((null? lat) '())
                  ((eq? (car lat) a) (skip (R (cdr lat))))
                  (else (cons (car lat) (R (cdr lat))))))))
         (R lat))))))

(rember-upto-last 'roots '(noodles spaghetti spatzle bean-thread roots potatoes yam others rice))
(rember-upto-last 'sweetthing '(noodles spaghetti spatzle bean-thread roots potatoes yam others rice))
(rember-upto-last 'desserts '(cookies chocolate minths caramel delight ginger snaps desserts chocolate
                                      mousse vanilla ice cream German chocolate cake more desserts
                                      gingerbreadman chocolate chip brownies))

;; This version, returns the list passed in after the first occurance
;; of a, or the entire list if a is not present. It uses the magic of
;; call/cc or call-with-current-continuation
