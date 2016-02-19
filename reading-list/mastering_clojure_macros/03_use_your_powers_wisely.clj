(ns use-your-powers-wisely)
#_nil

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Macros Aren't Values ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn square [x] (* x x))
#_#'use-your-powers-wisely/square

(map square (range 10))
#_(0 1 4 9 16 25 36 49 64 81)

(defmacro square [x] `(* ~x ~x))
#_#'use-your-powers-wisely/square

#_(map square (range 10))
;; CompilerException java.lang.RuntimeException:
;; Can't take value of a macro: #'user/square, compiling: (NO_SOURCE_PATH:1:1)

;; In this simple, case, you can fix this by wrapping the expression in a
;; function.
(defmacro square [x] `(* ~x ~x))
#_#'use-your-powers-wisely/square

(map (fn [n] (square n)) (range 10))
#_(0 1 4 9 16 25 36 49 64 81)

;; This technique doesn't not always work, though...
(defmacro do-multiplication [expression]
  (cons `* (rest expression)))
#_#'use-your-powers-wisely/do-multiplication

(do-multiplication (+ 3 4))
#_12

#_(map (fn [x] (do-multiplication x)) ['(+ 3 4) '(- 2 3)])
;; CompilerException java.lang.IllegalArgumentException:
;;   Don't know how to create ISeq from: clojure.lang.Symbol,
;;   compiling:(NO_SOURCE_PATH:1:14)

;; This doesn't work because when it is time to evaluate the macro, it is only
;; given the symbol x, not the value '(+ 3 4) or '(- 2 3).

;; At the end of the day, macros are technically functions, but that doesn't
;; really help us.

(defmacro square [x] `(* ~x ~x))
#_#'use-your-powers-wisely/square

@#'square
;;#object[use_your_powers_wisely$square 0x72a22c98 "use_your_powers_wisely$square@72a22c98"]

(fn? @#'square)
#_true

#_(@#'square 9)

;; ArityException Wrong number of args (1) passed to: user$square
;;  clojure.lang.AFn.throwArity (AFn.java:437)

;; The macro is expecting to get &env and &forms passed to it, in case they are
;; needed.
(@#'square nil nil 9)
#_(clojure.core/* 9 9)

;; In this case, though, it'd be better to just use macroexpand-1

(macroexpand-1 '(square 9))
#_(clojure.core/* 9 9)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Macros can be contagious ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(require '[clojure.string :as string])
#_nil
(defmacro log [& args]
  `(println (str "[INFO] " (string/join " : " ~(vec args)))))
#_#'use-your-powers-wisely/log

(log "that went well")
;; [INFO] that went well
#_nil

(log "item #1 created" "by user #42")
;; [INFO] item #1 created : by user #42
#_nil

(defn send-email [user messages]
  (Thread/sleep 1000)) ;; this would send email in a real implementation
#_#'use-your-powers-wisely/send-email


(def admin-user "kathy@example.com")
#_#'use-your-powers-wisely/admin-user

(def current-user "colin@example.com")
#_#'use-your-powers-wisely/current-user

#_(defn notify-everyone [messages]
    (apply log messages)
    (send-email admin-user messages)
    (send-email current-user messages))

;; CompilerException java.lang.RuntimeException:
;;   Can't take value of a macro: #'user/log, compiling:(NO_SOURCE_PATH:2:3)

(defmacro notify-everyone [messages]
  `(do
     (send-email admin-user ~messages)
     (send-email current-user ~messages)
     (log ~@messages)))
#_#'use-your-powers-wisely/notify-everyone

(notify-everyone ["item #1 processed" "by worker #72"])
;; [INFO] item #1 processed : by worker #72
#_nil

;; You didn't need to use a macro for this, however.

(require '[clojure.string :as string])
#_nil

(defn log [& args]
  (println (str "[INFO] " (string/join " : " args))))
#_#'use-your-powers-wisely/log

(log "hi" "there")
;; [INFO] hi : there
#_nil

(apply log ["hi" "there"])
;; [INFO] hi : there
#_nil

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Macros are Tricky to get Right ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro our-and
  ([] true)
  ([x] x)
  ([x & next]
   `(if ~x (our-and ~@next) ~x)))
#_#'use-your-powers-wisely/our-and

(our-and true true)
#_true

(our-and true false)
#_false

(our-and true true false)
#_false

(our-and true true nil)
#_nil

(our-and 1 2 3)
#_3

(our-and (do (println "hi there") (= 1 2)) (= 3 4))
;; hi there
;; hi there
#_false

;; Oh no, our do got evaluated two times. We didn't put enough care into making
;; sure that our macro wouldn't evaluate an expression more than once.

(macroexpand-1 '(our-and (do (println "hi there") (= 1 2)) (= 3 4)))
#_(if (do (println "hi there") (= 1 2))
    (use-your-powers-wisely/our-and (= 3 4))
    (do (println "hi there") (= 1 2)))

;; We can fix our and pretty easily in this case.


(defmacro our-and-fixed
  ([] true)
  ([x] x)
  ([x & next]
   `(let [arg# ~x]
      (if arg# (our-and-fixed ~@next) arg#))))
#_#'use-your-powers-wisely/our-and-fixed

(our-and-fixed (do (println "hi there") (= 1 2)) (= 3 4))
#_false
;; hi there
