(load "ss.scm")

(define multirember
  (lambda (a lat)
    ((Y (lambda (mr)
          (lambda (lat)
            (cond
             ((null? lat) '())
             ((eq? a (car lat)) (mr (cdr lat)))
             (else
              (cons (car lat) (mr (cdr lat))))))))
     lat)))

(multirember 'tuna '(shrimp salad tuna salad and tuna))

(define length
  ((lambda (le)
     ((lambda (f) (f f))
      (lambda (f)
        (le (lambda (x) ((f f) x))))))
   (lambda (length)
     (lambda (l)
       (cond
        ((null? l) 0)
        (else (add1 (length (cdr l)))))))))

(define length
  (Y (lambda (length)
       (lambda (l)
         (cond
          ((null? l) 0)
          (else (add1 (length (cdr l)))))))))

(length '(1 2 3 4))

(define multirember
  (lambda (a lat)
    ((letrec
         ((mr (lambda (lat)
                (cond
                 ((null? lat) '())
                 ((eq? a (car lat)) (mr (cdr lat)))
                 (else (cons (car lat) (mr (cdr lat))))))))
       mr)
     lat)))
;; Note that the letrec block is returning mr defined with the lambda.
;; The result of the letrec block (mr) is then applied to lat. That's
;; why there is the double (( in front of letrec instead of just a
;; single (

(multirember 'tuna '(shrimp salad tuna salad and tuna))
(multirember 'pie '(apple custard pie liszer pie torte))

(define multirember
  (lambda (a lat)
    (letrec
        ((mr (lambda (lat)
               (cond
                ((null? lat) '())
                ((eq? a (car lat)) (mr (cdr lat)))
                (else
                 (cons (car lat) (mr (cdr lat))))))))
      (mr lat))))
;; In this letrec, however. It is returning the value of mr (which is
;; bound through the letrec) applied with lat. This gives
;; approximately the same benefit as before, but in this scenerio, if
;; you were to define multiple functions, they could all be used
;; inside the letrec, whereas otherwise you could only use the last
;; one defined.

(multirember 'tuna '(shrimp salad tuna salad and tuna))
(multirember 'pie '(apple custard pie liszer pie torte))

(define rember-f
  (lambda (test?)
    (lambda (a l)
      (cond
       ((null? l) '())
       ((test? (car l) a) (cdr l))
       (else (cons (car l)
                   ((rember-f test?) a (cdr l))))))))

(define rember-eq? (rember-f eq?))

(define multirember-f
  (lambda (test?)
    (lambda (a lat)
      (cond
       ((null? lat) '())
       ((test? (car lat) a)
        ((multirember-f test?) a (cdr lat)))
       (else (cons
              (car lat)
              ((multi-rember-f test?) a (cdr lat))))))))

(define multirember-f
  (lambda (test?)
    (letrec
        ((m-f (lambda (a lat)
                (cond
                 ((null? lat) '())
                 ((test? (car lat) a) (m-f a (cdr lat)))
                 (else
                  (cons
                   (car lat)
                   (m-f a (cdr lat))))))))
      m-f)))

(multirember-f eq?)

(define member?
  (lambda (a lat)
    (cond
     ((null? lat) #f)
     ((eq? (car lat) a) #t)
     (else (member? a (cdr lat))))))

(member? 'ice '(salad greens with pears brie cheese frozen yogurt))

(define member?
  (lambda (a lat)
    ((letrec
         ((yes? (lambda (l)
                  (cond
                   ((null? l) #f)
                   ((eq? (car lat) a) #t)
                   (else (yes? (cdr l)))))))
       yes?)
     lat)))

(member? 'ice '(salad greens with pears brie cheese frozen yogurt))

(define member?
  (lambda (a lat)
    (letrec
        ((yes? (lambda (l)
                 (cond
                  ((null? l) #f)
                  ((eq? (car l) a) #t)
                  (else (yes? (cdr l)))))))
      (yes? lat))))

(member? 'ice '(salad greens with pears brie cheese frozen yogurt))
(member? 'ice '(ice ice baby))

;; These two have the same difference as before. One returns the
;; recursive function it defines and then applies it to the arguments,
;; where the other one returns the value of applying the recursive
;; function to the list

(define union
  (lambda (set1 set2)
    (cond
     ((null? set1) set2)
     ((member? (car set1) set2)
      (union (cdr set1) set2))
     (else (cons
            (car set1)
            (union (cdr set1) set2))))))

(union '(tomatoes and macaroni casserole)
       '(macaroni and cheese))

(define union
  (lambda (set1 set2)
    (letrec
        ((U (lambda (set)
              (cond
               ((null? set) set2)
               ((member? (car set) set2)
                (U (cdr set)))
               (else (cons
                      (car set)
                      (U (cdr set))))))))
      (U set1))))

(union '(tomatoes and macaroni casserole)
       '(macaroni and cheese))

(define union
  (lambda (set1 set2)
    (letrec
        ((A (lambda (set)
              (cond
               ((null? set) set2)
               ((member? (car set) set2)
                (A (cdr set)))
               (else (cons
                      (car set)
                      (A (cdr set))))))))
      (A set1))))

(union '(tomatoes and macaroni casserole)
       '(macaroni and cheese))

;; The name of the functions defined in the letrec don't matter as
;; long as thy are consistent. The only difference between this union
;; and the one before is naming the inner function A instead of U.

(define union
  (lambda (set1 set2)
    (letrec
        ((A (lambda (set)
              (cond
               ((null? set) set2)
               ((M? (car set) set2)
                (A (cdr set)))
               (else (cons
                      (car set)
                      (A (cdr set)))))))
         (M? (lambda (a lat)
               (cond
                ((null? lat) #f)
                ((eq? (car lat) a) #t)
                (else
                 (M? a (cdr lat)))))))
      (A set1))))

(union '(tomatoes and macaroni casserole)
       '(macaroni and cheese))

;; You can define more than one function inside of a letrec. It's
;; really just like a let, but it works much nicer for recursive
;; functions. I'm not sure if we've learned about lets yet, though. I
;; think we probably haven't.

(define union
  (lambda (set1 set2)
    (letrec
        ((A (lambda (set)
              (cond
               ((null? set) set2)
               ((M? (car set) set2)
                (A (cdr set)))
               (else (cons
                      (car set)
                      (A (cdr set)))))))
         (M? (lambda (a lat)
               (letrec
                   ((N? (lambda (lat)
                          (cond
                           ((null? lat) #f)
                           ((eq? (car lat) a) #t)
                           (else (N? (cdr lat)))))))
                 (N? lat)))))
      (A set1))))

(union '(tomatoes and macaroni casserole)
       '(macaroni and cheese))

;; You can also neest letrecs, though it seems like that can actually
;; cause more confusion than it solves.

(define two-in-a-row?
  (lambda (lat)
    (letrec
        ((W (lambda (a lat)
              (cond
               ((null? lat) #f)
               (else (or (eq? (car lat) a)
                         (W (car lat) (cdr lat))))))))
      (cond
       ((null? lat) #f)
       (else (W (car lat) (cdr lat)))))))

(two-in-a-row? '(a a b c d))
(two-in-a-row? '(a b c a d))

(define two-in-a-row?
  (letrec
      ((W (lambda (a lat)
            (cond
             ((null? lat) #f)
             (else (or (eq? (car lat) a)
                       (W (car lat) (cdr lat))))))))
    (lambda (lat)
      (cond
       ((null? lat) #f)
       (else (W (car lat) (cdr lat)))))))

(two-in-a-row? '(a a b c d))
(two-in-a-row? '(a b c a d))

;; Notice that this define is still perfectly happy because the letrec
;; ends up returning the (lambda (lat) ...). As far as the defined is
;; concerned, it got passed an anonymous function like usual.

(define sum-of-prefixes
  (lambda (tup)
    (letrec
        ((S (lambda (sss tup)
              (cond
               ((null? tup) '())
               (else (cons
                      (+ sss (car tup))
                      (S (+ sss (car tup)) (cdr tup))))))))
      (S 0 tup))))

(sum-of-prefixes '(1 1 1 1 1))

(define pick
  (lambda (n lat)
    (cond
     ((one? n) (car lat))
     (else (pick (sub1 n) (cdr lat))))))

(define scramble
  (lambda (tup)
    (letrec
        ((P (lambda (tup rp)
              (cond
               ((null? tup) '())
               (else (cons (pick (car tup)
                                 (cons (car tup) rp))
                           (P (cdr tup)
                              (cons (car tup) rp))))))))
      (P tup '()))))

(scramble '(1 1 1 1 4 2))

(define scramble
  (letrec
      ((P (lambda (tup rp)
            (cond
             ((null? tup) '())
             (else (cons (pick (car tup)
                               (cons (car tup) rp))
                         (P (cdr tup)
                            (cons (car tup) rp))))))))
    (lambda (tup)
      (P tup '()))))

(scramble '(1 1 1 1 4 2))

;;Pick should probably also be defined via the letrec, but that's
;;something I'm just not going to bother with since I understand the
;;fact that it should be done in the first place.
