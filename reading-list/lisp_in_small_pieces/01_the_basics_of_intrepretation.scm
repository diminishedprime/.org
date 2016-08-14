(define (evaluate e env)

  (define (lookup id env)
    (if (pair? env)
        (if (eq? (caar env) id)
            (cadar env)
            (lookup id (cdr env)))
        (wrong "No such binding" id)))

  (define (wrong str e)
    (error str e))

  (define (atom? e)
    (not (pair? e)))

  (define (eprogn exps env)
    (if (pair? exps)
        (if (pair? (cdr exps))
            (begin (evaluate (car exps) env)
                   (eprogn (cdr exps) env))
            (evaluate (car exps) env))
        '()))

  (define (evlis exps env)
    (if (pair? exps)
        (cons (evaluate (car exps) env)
              (evlis (cdr exps) env))
        '()))

  (define (update! id env value)
    (if (pair? env)
        (if (eq? (caar env) id)
            (begin (set-cdr! (car env) value)
                   value)
            (update! id (cdr env) value))
        (wrong "No such binding" id)))

  (define (invoke fn args)
    (if (procedure? fn)
        (apply fn args)
        (wrong "Not a function" fn)))

  (define (extend env variables values)
    (cond ((pair? variables) (if (pair? values)
                                 (cons (cons (car variables) (car values))
                                       (extend env (cdr variables) (cdr values)))
                                 (wrong "Too few values" values)))
          ((null? variables) (if (null? values)
                                 env
                                 (wrong "Too many values" '())))
          ((symbol? variables) (cons (cons variables values) env))))

  (define (make-function variables body env)
    (lambda values
      (eprogn body (extend env variables values))))

  (if (atom? e)
      (cond ((symbol? e) (lookup e env))
            ((or (number? e) (string? e) (char? e) (boolean? e) (vector? e)) e)
            (else (wrong "Cannot evaluate" e)))
      (case (car e)
        ((quote) (cadr e))
        ((if) (if (evaluate (cadr e) env)
                  (evaluate (caddr e) env)
                  (evaluate (cadddr e) env)))
        ((begin) (eprogn (cdr e) env))
        ((set!) (update! (cadr e) env (evaluate (caddr e) env)))
        ((lambda) (make-function (cadr e) (cddr e) env))
        (else (invoke (evaluate (car e) env)
                      (evlis (cdr e) env))))))

(define empty-environment '(()))
(evaluate 3 empty-environment) ;; => 3
(evaluate #t empty-environment) ;; => #t
(evaluate '(quote (1 1)) empty-environment) ;; => (1 1)
(evaluate '(if #t 'hi 'not-hi) empty-environment) ;; => hi
(evaluate '(if #f 'hi 'not-hi) empty-environment) ;; => not-hi
(evaluate '(begin 'hi 'hello 'there) empty-environment) ;; => there
(evaluate '(lambda (a b) (+ a b)) empty-environment) ;; not defined

(define env (list (list '+ +)))
(evaluate '((lambda (a) (+ a 1)) 1) env) ;;=> 2
(evaluate '(+ 2 1) env) ;; => 3
(evaluate '(+ (+ 1 1) 2 3 4) env) ;; => 11
(evaluate '(+ 1 2) env)
