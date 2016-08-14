(define (df.evaluate e env fenv denv)
  (if (atom? e)
      (cond ((symbol? e) (lookup e env))
            ((or (number? e) (string? e) (char? e) (boolean? e) (vector? e)) e)
            (else (wrong "Cannot evaluate" e)))
      (case (car e)
        ((quote) (cadr e))
        ((if) (if (df.evaluate (cadr e) env fenv denv)
                  (df.evaluate (caddr e) env fenv denv)
                  (df.evaluate (cadddr e) env fenv denv)))
        ((begin) (df.eprogn (cdr e) env fenv denv))
        ((set!) (update! (cadr e) env (df.evaluate (caddr e) env fenv denv)))
        ((function) (cond
                     ((symbol? (cadr e)) (f.lookup (cadr e) fenv))
                     ((and (pair? (cadr e)) (eq? (car (cadr e)) 'lambda))
                      (df.make-function (cadr (cadr e)) (cddr (cadr e)) env fenv))
                     (else (wrong "Incorrect function" (cadr e)))))
        ((dynamic) (lookup (cadr e) denv))
        ((dynamic-set!) (update! (cadr e) denv (df.evaluate (caddr e) env fenv denv)))
        ((dynamic-let) (df.eprogn (cddr e)
                                  env
                                  fenv
                                  (extend denv
                                          (map car (cadr e))
                                          (map (lambda (e)
                                                 (df.evaluate e env fenv denv))
                                               (map cadr (cadr e))))))
        (else (df.evaluate-application (car e)
                                       (df.evlis (cdr e) env fenv denv)
                                       env
                                       fenv
                                       denv)))))

(define (df.evaluate-application fn args env fenv denv)
  (cond
   ((symbol? fn) ((f.lookup fn fenv) args denv))
   ((and (pair? fn) (eq? (car fn) 'lambda)) (df.eprogn (cddr fn)
                                                       (extend env (cadr fn) args)
                                                       fenv
                                                       denv))
   (else (wrong "Incorrect functional term" fn))))

(define (df.make-function variables body env fenv)
  (lambda (values denv)
    (df.eprogn body (extend env variables values) fenv denv)))

(define (df.eprogn e* env fenv denv)
  (if (pair? e*)
      (if (pair? (cdr e*))
          (begin (df.evaluate (car e*) env fenv denv)
                 (df.eprogn (cdr e*) env fenv denv))
          (df.evaluate (car e*) env fenv denv))
      empty-begin))
