(ns build-a-solid-foundation) ;; => nil

;;;;;;;;;;;;;;;;;;;
;; Code is Data. ;;
;;;;;;;;;;;;;;;;;;;

;; This book explains that this statement is referring to the fact that Clojure
;; code is made only out of Clojure data-structures.

;;;;;;;;;;;;;;;;;;;;;;;
;; Transforming Code ;;
;;;;;;;;;;;;;;;;;;;;;;;

;; The repl, first reads, which takes an input stream and turns it into Clojure
;; data structures before going onto the eval step.

(read-string "(+ 1 2 3 4)") #_(+ 1 2 3 4)
(class (read-string "(+ 1 2 3 4)")) #_clojure.lang.PersistentList

(eval (read-string "(+ 1 2 3 4)")) #_10
(class (eval (read-string "(+ 1 2 3 4)"))) #_java.lang.Long

;; Because the process works like this, it's trivial to do something in between
;; these steps.

(let [expression (read-string "(+ 1 2 3 4 5)")]
  (cons (read-string "*")
        (rest expression))) #_(* 1 2 3 4 5)

;; *1 holds the result of the most recent repl evaluation.

(eval *1) #_120

;; Since quote is a special form, the list doesn't get evaluated. This makes it
;; easier to mess around with Clojure forms.
(let [expression (quote (+ 1 2 3 4 5))]
  (cons (quote *)
        (rest expression))) #_(* 1 2 3 4 5)

;; And to make using quote easier, there is a shorthand syntax (via reader macro).
(let [expression '(+ 1 2 3 4 5)]
  (cons (quote *)
        (rest expression))) #_(* 1 2 3 4 5)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Evaluating Your First Macro ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(when (= 2 (+ 1 1))
  (print "You got")
  (print " the touch!")
  (println)) #_nil

(list 'if
      '(= 2 (+ 1 1))
      (cons 'do
            '((print "You got")
              (print " the touch!")
              (println))))
#_(if (= 2 (+ 1 1))
    (do
      (print "You got")
      (print " the touch!")
      (println)))

;;;;;;;;;;;;;;;;;;;;
;; Macroexpansion ;;
;;;;;;;;;;;;;;;;;;;;

(macroexpand-1 '(when (= 1 2) (println "math is broken")))
#_(if (= 1 2)
    (do
      (println "math is broken")))

;; Don't forget the quote, because otherwise you will macroexpand the result of
;; evaluating the form, almost certainly not what you wanted.
(macroexpand-1 (when (= 1 2) (println "math is broken")))
#_nil

;; Showing what happens if your macro didn't return a form that could be
;; evaluated.

(defmacro broken-when [test & body]
  (list test (cons 'do body)))
#_#'build-a-solid-foundation/broken-when

(comment
  ;; This throws a Class cast exception since we left out the if. When this gets
  ;; expanded, it evaluates (= 1 1) which is true, then tries to invoke true as
  ;; a function.
  (broken-when (= 1 1) (println "Math Works")))

;; We can figure out the exception more easily by using macroexpand.
(macroexpand-1
 '(broken-when (= 1 1) (println "Math works!")))
#_((= 1 1) (do (println "Math works!")))

;; Difference between macroexpand-1 and macroexpand.


(defmacro when-falsy [test & body]
  (list 'when (list 'not test)
        (cons 'do body)))
#_#'build-a-solid-foundation/when-falsy

(macroexpand-1 '(when-falsy (= 1 2) (println "hi!")))
#_(when (not (= 1 2)) (do (println "hi!")))

;; macroexpand fully expands out all of the macros.
(macroexpand '(when-falsy (= 1 2) (println "hi!")))
#_(if (not (= 1 2)) (do (do (println "hi!"))))
