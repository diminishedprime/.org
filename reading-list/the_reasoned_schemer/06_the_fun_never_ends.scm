(load "mk.scm") ;; => 2
(load "mkextraforms.scm") ;; => #<unspecified>
(load "previous_chapters.scm") ;; => #<unspecified>

(define anyo
  (lambda (g)
    (conde
     (g S)
     (else (anyo g))))) ;; => #<unspecified>

(define nevero (anyo U)) ;; => #<unspecified>

'(run 1 (q)
      nevero
      (== #t q))

(run 1 (q)
     U
     nevero) ;; => ()

(define alwayso (anyo S)) ;; => #<unspecified>

(run 1 (q)
     alwayso
     (== #t q)) ;; => (#t)

'(run* (q)
       alwayso
       (== #t q))

(run 5 (q)
     alwayso
     (== #t q)) ;; => (#t #t #t #t #t)

(run 5 (q)
     (== #t q)
     alwayso) ;; => (#t #t #t #t #t)

;; sal stands for succeeds at least once.
(define salo
  (lambda (g)
    (conde
     (S S)
     (else g)))) ;; => #<unspecified>

(run 1 (q)
     (salo alwayso)
     (== #t q)) ;; => (#t)

(run 1 (q)
     (salo nevero)
     (== #t q)) ;; => (#t)


'(run* (q)
       (salo nevero)
       (== #t q))

'(run 1 (q)
      (salo nevero)
      U
      (== #t q))

'(run 1 (q)
      alwayso
      U
      (== #t q))

'(run 1 (q)
      (conde
       ((== #f q) alwayso)
       (else (anyo (== #t q))))
      (== #t q))

(run 1 (q)
     (condi
      ((== #f q) alwayso)
      (else (anyo (== #t q))))
     (== #t q)) ;; => (#t)

'(run 2 (q)
      (condi
       ((== #f q) alwayso)
       (else (anyo (== #t q))))
      (== #t q))

(run 5 (q)
     (condi
      ((== #f q) alwayso)
      (else (anyo (== #t q))))
     (== #t q)) ;; => (#t #t #t #t #t)

;;;;;;;;;;;;;;;;;;;;;;
;; The Law of Condi ;;
;;;;;;;;;;;;;;;;;;;;;;

;; condi behaves like conde, except that its values are interleaved.

(run 5 (r)
     (cond
      ((teacupo r) S)
      ((== #f r) S)
      (else U))) ;; => (tea #f cup)

(run 5 (q)
     (condi
      ((== #f q) alwayso)
      ((== #t q) alwayso)
      (else U))
     (== #t q)) ;; => (#t #t #t #t #t)

(run 5 (q)
     (conde
      (alwayso S)
      (else nevero))
     (== #t q)) ;; => (#t #t #t #t #t)

'(run 5 (q)
      (condi
       (alwayso S)
       (else nevero))
      (== #t q))
'(run 1 (q)
      (all
       (conde
        ((== #f q) S)
        (else (== #t q)))
       alwayso)
      (== #t q))

(run 1 (q)
     (alli
      (conde
       ((== #f q) S)
       (else (== #t q)))
      alwayso)
     (== #t q)) ;; => (#t)

(run 5 (q)
     (alli
      (conde
       ((== #f q) S)
       (else (== #t q)))
      alwayso)
     (== #t q)) ;; => (#t #t #t #t #t)

(run 5 (q)
     (alli
      (conde
       ((== #t q) S)
       (else (== #f q)))
      alwayso)
     (== #t q)) ;; => (#t #t #t #t #t)

(run 5 (q)
     (all
      (conde
       (S S)
       (else nevero))
      alwayso)
     (== #t q)) ;; => (#t #t #t #t #t)

'(run 5 (q)
      (all
       (condi
        (S S)
        (else nevero))
       alwayso)
      (== #t q))
