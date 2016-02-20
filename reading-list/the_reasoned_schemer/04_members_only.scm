(load "mk.scm") ;; => 2
(load "mkextraforms.scm") ;; => #<unspecified>
(load "previous_chapters.scm") ;; => #<unspecified>

(define mem
  (lambda (x l)
    (cond
     ((null? l) #f)
     ((eq-car? l x) l)
     (else (mem x (cdr l)))))) ;; => #<unspecified>

(mem 'tofu '(a b tofu d peas e)) ;; => (tofu d peas e)
(mem 'tofu '(a b peas d peas e)) ;; => #f

(run* (out)
      (== (mem 'tofu '(a b tofu d peaso e)) out)) ;; => ((tofu d peaso e))

(mem 'peas
     (mem 'tofu '(a b tofu d peas e))) ;; => (peas e)

(mem 'tofu
     (mem 'tofu '(a b tofu d tofu e))) ;; => (tofu d tofu e)

(mem 'tofu
     (cdr (mem 'tofu '(a b tofu d tofu e)))) ;; => (tofu e)


(define memo
  (lambda (x l out)
    (conde
     ((nullo l) U)
     ((eq-caro l x) (== l out))
     (else (fresh (d)
                  (cdro l d)
                  (memo x d out)))))) ;; => #<unspecified>

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Second Commandment ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; To transform a function whose value is not a Boolean into a function whose
;; value is a goal, add an extra argument to hold its value, replace cond with
;; conde, and un-nest each question and answer.

(run 1 (out)
     (memo 'tofu `(a b tofu d tofu e) out)) ;; => ((tofu d tofu e))

(run 1 (out)
     (fresh (x)
            (memo 'tofu `(a b ,x d tofu e) out))) ;; => ((tofu d tofu e))

(run* (r)
      (memo r
            '(a b tofu d tofu e)
            '(tofu d tofu e))) ;; => (tofu)

(run* (q)
      (memo 'tofu '(tofu e) '(tofu e))
      (== #t q)) ;; => (#t)

(run* (q)
      (memo 'tofu '(tofu e) '(tofu))
      (== #t q)) ;; => ()

(run* (x)
      (memo 'tofu '(tofu e) `(,x e))) ;; => (tofu)

(run* (x)
      (memo 'tofu '(tofu e) `(peas ,x))) ;; => ()

(run* (out)
      (fresh (x)
             (memo 'tofu `(a b ,x d tofu e) out))) ;; => ((tofu d tofu e) (tofu e))

(run 12 (z)
     (fresh (u)
            (memo 'tofu `(a b tofu d tofu e . ,z) u))) ;; =>
#|
(
 _.0
 _.0
 (tofu . _.0)
 (_.0 tofu . _.1)
 (_.0 _.1 tofu . _.2)
 (_.0 _.1 _.2 tofu . _.3)
 (_.0 _.1 _.2 _.3 tofu . _.4)
 (_.0 _.1 _.2 _.3 _.4 tofu . _.5)
 (_.0 _.1 _.2 _.3 _.4 _.5 tofu . _.6)
 (_.0 _.1 _.2 _.3 _.4 _.5 _.6 tofu . _.7)
 (_.0 _.1 _.2 _.3 _.4 _.5 _.6 _.7 tofu . _.8)
 (_.0 _.1 _.2 _.3 _.4 _.5 _.6 _.7 _.8 tofu . _.9))
|#

(define memo
  (lambda (x l out)
    (conde
     ((eq-caro l x) (== l out))
     (else (fresh (d)
                  (cdro l d)
                  (memo x d out)))))) ;; => #<unspecified>

(define rember
  (lambda (x l)
    (cond
     ((null? l) '())
     ((eq-car? l x) (cdr l))
     (else (cons (car l)
                 (rember x (cdr l))))))) ;; => #<unspecified>

(rember 'peas '(a b peas d peas e)) ;; => (a b d peas e)

(define rembero
  (lambda (x l out)
    (conde
     ((nullo l) (== '() out))
     ((eq-caro l x) (cdro l out))
     (else (fresh (res)
                  (fresh (d)
                         (cdro l d)
                         (rembero x d res))
                  (fresh (a)
                         (caro l a)
                         (conso a res out))))))) ;; => #<unspecified>

;; With onle one fresh.
(define rembero
  (lambda (x l out)
    (conde
     ((nullo l) (== '() out))
     ((eq-caro l x) (cdro l out))
     (else (fresh (a d res)
                  (cdro l d)
                  (rembero x d res)
                  (caro l a)
                  (conso a res out)))))) ;; => #<unspecified>

(run 1 (out)
     (fresh (y)
            (rembero 'peas `(a b ,y d peas e) out))) ;; => ((a b d peas e))

(run* (out)
      (fresh (y z)
             (rembero y `(a b ,y d ,z e) out))) ;; =>
#|
(
 (b a d _.0 e)
 (a b d _.0 e)
 (a b d _.0 e)
 (a b d _.0 e)
 (a b _.0 d e)
 (a b e d _.0)
 (a b _.0 d _.1 e)
 )
|#

(run* (r)
      (fresh (y z)
             (rembero y `(,y d ,z e) `(,y d e))
             (== `(,y ,z) r))) ;; =>
#|
(
 (d d)
 (d d)
 (_.0 _.0)
 (e e)
 )
|#

(run 13 (w)
     (fresh (y z out)
            (rembero y `(a b ,y d ,z . ,w) out))) ;; =>
#|
(
 _.0
 _.0
 _.0
 _.0
 _.0
 ()
 (_.0 . _.1)
 (_.0)
 (_.0 _.1 . _.2)
 (_.0 _.1)
 (_.0 _.1 _.2 . _.3)
 (_.0 _.1 _.2)
 (_.0 _.1 _.2 _.3 . _.4)
 )
|#

(define surpriseo
  (lambda (s)
    (rembero s '(a b c) '(a b c)))) ;; => #<unspecified>

(run* (r)
      (== 'd r)
      (surpriseo r)) ;; => (d)

(run* (r)
      (surpriseo r)) ;; => (_.0)

;; This shouldn't be fresh, though. r cannot be bound to a, b, or c and still succeed.

(run* (r)
      (surpriseo r)
      (== 'b r)) ;; => (b)

;; This is a surprise, indeed.
