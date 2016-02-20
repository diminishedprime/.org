(load "mk.scm")
(load "mkextraforms.scm")

(define U fail) ;; => #<unspecified>
(define S succeed) ;; => #<unspecified>

(run* (q) U) ;; => ()

(run* (q)
      (== #t q)) ;; => (#t)

(run* (q)
      U
      (== #t q)) ;; => ()

(run* (q)
      S
      (== #t q)) ;; => (#t)

(run* (r)
      S
      (== 'corn r)) ;; => (corn)

(run* (r)
      U
      (== 'corn r)) ;; => ()

(run* (q)
      S
      (== #f q))

((let ((x #t))
   (== #f x)) 'temp) ;; => #f

((let ((x #f))
   (== #f x)) 'temp) ;; => temp

(run* (x)
      (let ((x #t))
        (== #f x))) ;; => ()

(run* (q)
      (fresh (x)
             (== #t x)
             (== #t q))) ;; => (#t)

;;;;;;;;;;;;;;;;;;;;;;
;; The Law Of Fresh ;;
;;;;;;;;;;;;;;;;;;;;;;

;; If x is fresh, then (== v x) suceeds and associates x with v.

(run* (q)
      (fresh (x)
             (== x #t)
             (== #t q))) ;; => (#t)

;;;;;;;;;;;;;;;;;;;
;; The Law of == ;;
;;;;;;;;;;;;;;;;;;;

;; (== v w) is the same as (== w v)

(run* (x)
      S) ;; => (_.0)

(run* (x)
      (let ((x #f))
        (fresh (x)
               (== #t x)))) ;; => (_.0)

(run* (r)
      (fresh (x y)
             (== (cons x (cons y '())) r))) ;; => ((_.0 _.1))

(run* (s)
      (fresh (t u)
             (== (cons t (cons u '())) s))) ;; => ((_.0 _.1))
;; the only difference between this and the previous frame is the
;; names of the lexical variables. Therefor the values are the same

(run* (r)
      (fresh (x)
             (let ((y x))
               (fresh (x)
                      (== (cons y (cons x (cons y '()))) r))))) ;; => ((_.0 _.1 _.0))
;; within the inner fresh, x and y are different variables and since
;; they are still fresh, they get different reified names. Reifying
;; r's value reifies the fresh variables in the order in which they
;; appear in the list.

(run* (r)
      (fresh (x)
             (let ((y x))
               (fresh (x)
                      (== (cons x (cons y (cons x '()))) r))))) ;; => ((_.0 _.1 _.0))

;; same value as above since reifing happens in the order in which
;; they appear in the list.

(run* (q)
      (== #f q)
      (== #t q)) ;; => ()
;; the first goal succeds, associating #f with q; #t cannot then be
;; associated with q, since q is no longer fresh.

(run* (q)
      (== #f q)
      (== #f q)) ;; => (#f)
;; in order for the run to succeed, both (== #f q) and (== #f q) must
;; succeed. The first goal succeds while associating #f with the fresh
;; variable q. The second goal succeeds beacues although q is no
;; longer fresh, #f is already associated with it.

(run* (q)
      (let ((x q))
        (== #t x))) ;; => (#t)
;; because q and x are the same

(run* (r)
      (fresh (x)
             (== x r))) ;; => (_.0)
;; _.0 because r starts out fresh and then r gets whatever association
;; that x gets, but both x and r remain fresh. When one variable is
;; associated with another, we say thay co-refer or share.

(run* (q)
      (fresh (x)
             (== #t x)
             (== x q))) ;; => (#t)
;; because q starts out fresh and then q gets x's association.

(run* (q)
      (fresh (x)
             (== x q)
             (== #t x))) ;; => (#t)
;; because the first goal ensures that whatever association x gets, q
;; also gets

(cond
 (#f #t)
 (else #f)) ;; => #f

(conde
 (U S)
 (else U)) ;; => #<procedure (? s5492)>
;; this fails because the question of the first conde line is the goal
;; U

(conde
 (U U)
 (else S)) ;; => #<procedure (? s5523)>
;; this succeeds. The question of the first conde line is the goal U
;; so conde tries the second line which suceeds.

(conde
 (S S)
 (else U)) ;; => #<procedure (? s5554)>
;; This suceeds because the question of the first conde line is the
;; goal S, so conde tries the answer of the first line

(run* (x)
      (conde
       ((== 'olive x) S)
       ((== 'oil x) S)
       (else U))) ;; => (olive oil)
;; (olive oil), because (== 'olive x) suceeds; therefore, the answer
;; is S. The S preserves the association of x to olive. To get the
;; second value, we pretend that (== 'olive x) fails; this imagined
;; failure refreshes x. Then (== 'oil x) suceeds. The S preserves the
;; association of x to oil. We then pretend that (== oild x) failes,
;; which once again refreshes x. Since no more goals suceed, we are
;; done.

;;;;;;;;;;;;;;;;;;;;;;
;; The Law of Conde ;;
;;;;;;;;;;;;;;;;;;;;;;

;; To get more values from conde, pretend that the successful conde line has
;; failed, refreshing all variables that got an association from that line.

(run 1 (x)
     (conde
      ((== 'olive x) S)
      ((== 'oil x) S)
      (else U))) ;; => (olive)
;; because ('olive x) succeeds and because run 1 produces at most one
;; value.

(run* (x)
      (conde
       ((== 'virgin x) U)
       ((== 'olive x) S)
       (S S)
       ((== 'oil x) S)
       (else U))) ;; => (olive _.0 oil)

;; (olive _.0 oil) onci the first conde line fails, it is as if that
;; line were not there.

(run 2 (x)
     (conde
      ((== 'extra x) S)
      ((== 'virgin x) U)
      ((== 'olive x) S)
      ((== 'oil x) S)
      (else U))) ;; => (extra olive)
;; (extra olive) since we do not want every value, we want only the first two values

(run* (r)
      (fresh (x y)
             (== 'split x)
             (== 'pea y)
             (== (cons x (cons y '())) r))) ;; => ((split pea))

(run* (r)
      (fresh (x y)
             (conde
              ((== 'split x) (== 'pea y))
              ((== 'navy x) (== 'bean y))
              (else U))
             (== (cons x (cons y '())) r))) ;; => ((split pea) (navy bean))
;; ((split pea) (navy bean))

(run* (r)
      (fresh (x y)
             (conde
              ((== 'split x) (== 'pea y))
              ((== 'navy x) (== 'bean y))
              (else U))
             (== (cons x (cons y (cons 'soup '()))) r))) ;; => ((split pea soup) (navy bean soup))
;; ((split pea soup) (navy bean soup))

(define teacup-o
  (lambda (x)
    (conde
     ((== 'tea x) S)
     ((== 'cup x) S)
     (else U)))) ;; => #<unspecified>
(run* (x)
      (teacup-o x)) ;; => (tea cup)
;; (tea cup)

(run* (r)
      (fresh (x y)
             (conde
              ((teacup-o x) (== #t y) S)
              ((== #f x) (== #t y))
              (else U))
             (== (cons x (cons y '())) r))) ;; => ((tea #t) (cup #t) (#f #t))
;; ((tea #t) (cup #t) (#f #t))

(run* (r)
      (fresh (x y z)
             (conde
              ((== y x) (fresh (x) (== z x)))
              ((fresh (x) (== y x)) (== z x))
              (else U))
             (== (cons y (cons z '())) r))) ;; => ((_.0 _.1) (_.0 _.1))
;; ((_.0 _.1) (_.0 _.1))

(run* (r)
      (fresh (x y z)
             (conde
              ((== y x) (fresh (x) (== z x)))
              ((fresh (x) (== y x)) (== z x))
              (else U))
             (== #f x)
             (== (cons y (cons z '())) r))) ;; => ((#f _.0) (_.0 #f))
;; ((#f _.0) (_.0 #f)) this clearly shows that the two occurrences of
;; _0 in the previous frame represent different variables.

(run* (q)
      (let ((a (== #t q))
            (b (== #f q)))
        b)) ;; => (#f)
;; (#f) which shows that (== #t q) and (== #f q) are expressions, each
;; of whose value is a goal. But, here we only treat the (== #f q)
;; expressions value, b, as a goal.

(run* (q)
      (let ((a (== #t q))
            (b (fresh (x)
                      (== x q)
                      (== #f x)))
            (c (conde
                ((== #t q) S)
                (else (== #f q)))))
        b)) ;; => (#f)
;; (#f), which shows that (== ...), (fresh ...), and (conde ...) are
;; expressions, each of whose value is a goal. But, here, we only
;; treat the fresh expressions value, b, as a goal. This is indeed
;; interesting.

;; JAMS STAINS AND STUFF!!!
