(load "mk.scm")
(load "mkextraforms.scm")
(load "previous_chapters.scm")

(define mem
  (lambda (x l)
    ((null? l) #f)
    ((eq-car? l x) l)
    (else (mem x (cdr l)))))

(mem 'tofu '(a b tofu d peas e))

