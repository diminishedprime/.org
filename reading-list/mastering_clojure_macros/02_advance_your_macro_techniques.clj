(ns advance-your-macro-techniques)

;; In order to write a macro similar to Clojure's built-in assertion macro,
;; based on the tools we have so far, it would look something like this.

(defmacro assert [x]
  (when *assert* ;; check the dynamic var `clojure.core/*assert*` to make sure
    ;;   assertions are enabled
    (list 'when-not x
          (list 'throw
                (list 'new 'AssertionError
                      (list 'str "Assert failed: "
                            (list 'pr-str (list 'quote x))))))))
#_#'advance-your-macro-techniques/assert

;; This isn't the best when it comes to readability, though it does work.
#_(assert (= 1 2))
;; 1. Unhandled java.lang.AssertionError
;; Assert failed: (= 1 2)

(assert (= 1 1))
#_nil


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Syntax Quoting and Unquoting ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Syntax quote lets us make lists similar to how we would with the list syntax,
;; but also allow us to evaluate an expression via unquote.


(def a 4)
#_#'advance-your-macro-techniques/a

'(1 2 3 a 5)
#_(1 2 3 a 5)

(list 1 2 3 a 5)
#_(1 2 3 4 5)

;; Using a syntax quote with an unquote. Notice that this has the nice brevity
;; of ' from above, but allows us to decide what to evaluate and not evaluate.
`(1 2 3 ~a 4)
#_(1 2 3 4 4)

;; Assert from Clojure core. It uses syntax quote since it makes for easier to
;; read code.
(defmacro assert [x]
  (when *assert*
    `(when-not ~x
       (throw (new AssertionError (str "Assert failed: " (pr-str '~x)))))))

`(1 2 3 '~a 5)
#_(1 2 3 (quote 4) 5)

;; Be very careful with read-eval. It allows code to be executed during a read,
;; before the normal evaluation step would happen.
(read-string "#=(+ 1 2)")
#_3


;; Splicing unquote need.
(def other-numbers '(4 5 6 7 8))
#_#'advance-your-macro-techniques/other-numbers

;; This doesn't put other-numbers in-line.
`(1 2 3 ~other-numbers 9 10)
#_(1 2 3 (4 5 6 7 8) 9 10)

;; This does, but it makes you jump out of the normal macro-writing.
(concat '(1 2 3) other-numbers '(9 10))
#_(1 2 3 4 5 6 7 8 9 10)

;; Splicing unquote ~@ to the rescue.
`(1 2 3 ~@other-numbers 9 10)
#_(1 2 3 4 5 6 7 8 9 10)

;; There's a subtle, but important difference between quote and syntax quote as
;; show here.
'(a b c)
#_(a b c)

`(a b c)
#_(advance-your-macro-techniques/a advance-your-macro-techniques/b advance-your-macro-techniques/c)

;; Syntax quote namespace qualifies all symbols.

;; The reason why this difference is important.
(defmacro squares [xs] (list 'map '#(* % %) xs))
#_#'advance-your-macro-techniques/squares

;; Works as expected. What if map meant something different in the namespace,
;; though.
(squares (range 10))
#_(0 1 4 9 16 25 36 49 64 81)

(ns foo (:refer-clojure :exclude [map]))
#_nil

(def map {:a 1 :b 2})
#_#'foo/map

;; This isn't exactly expected...
(advance-your-macro-techniques/squares (range 10))
#_(0 1 2 3 4 5 6 7 8 9)

(advance-your-macro-techniques/squares :a)
#_:a
(first (macroexpand '(advance-your-macro-techniques/squares (range 10))))
#_map


(ns advance-your-macro-techniques)
#_nil
(defmacro squares [xs] `(map #(* % %) ~xs))
#_#'advance-your-macro-techniques/squares

(squares (range 10))
#_(0 1 4 9 16 25 36 49 64 81)

(ns foo (:refer-clojure :exclude [map]))
#_nil

(def map {:a 1 :b 2})
#_#'foo/map

(advance-your-macro-techniques/squares (range 10))
#_(0 1 4 9 16 25 36 49 64 81)

(first (macroexpand '(advance-your-macro-techniques/squares (range 10))))
#_clojure.core/map

(ns advance-your-macro-techniques)
;; We avoided some potential confusion earlier when we used the #() function
;; form instead of the fn form.
(defmacro squares [xs] `(map (fn [x] (* x x)) ~xs))
#_#'foo/squares

#_(squares (range 10))
;; CompilerException java.lang.RuntimeException:
;; Can't use qualified name as parameter: user/x, compiling: (NO_SOURCE_PATH:1:1)

;; Maybe something like this would work, then.
`(* ~'x ~'x)
#_(clojure.core/* x x)

(defmacro squares [xs] `(map (fn [~'x] (* ~'x ~'x)) ~xs))
#_#'advance-your-macro-techniques/squares

;; This seems to be working!
(squares (range 10))
#_(0 1 4 9 16 25 36 49 64 81)

(defmacro make-adder [x] `(fn [~'y] (+ ~x ~'y)))
#_#'advance-your-macro-techniques/make-adder

(macroexpand-1 '(make-adder 10))
#_(clojure.core/fn [y] (clojure.core/+ 10 y))

(def y 100)
#_#'advance-your-macro-techniques/y

;; It used the value of 5 instead of three???
((make-adder (+ y 3)) 5)
#_13

;; Oh, you can see that the y got shadowed since the argument to the function
;; was also y.
(macroexpand-1 '(make-adder (+ y 3)))
#_(clojure.core/fn [y] (clojure.core/+ (+ y 3) y))

;; Symbol capture has happened here, but fortunately there is a solution in the
;; name of gensym.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Approaching Hygiene with the Gensym ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(gensym)
#_G__16552
(gensym)
#_G__16555
(gensym "xyz")
#_xyz16558
(gensym "xyz")
#_xyz16561

;; Gensym generates a unique symbol name.


;; With this we can fix the previous shadowing problem with make-adder.
(defmacro make-adder [x]
  (let [y (gensym)]
    `(fn [~y] (+ ~x ~y))))
#_#'advance-your-macro-techniques/make-adder

y
#_100

((make-adder (+ y 3)) 5)
#_108
;; Yay, that's what we expected, though it is a bit verbose for what we were
;; trying to do.

(defmacro make-adder [x]
  `(fn [y#] (+ ~x y#)))
#_#'advance-your-macro-techniques/make-adder

y
#_100

((make-adder (+ y 3)) 5)
#_108

;;;;;;;;;;;;;;;;;;;;;;;;;
;; Secret Macro Voodoo ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro info-about-caller []
  (clojure.pprint/pprint {:form &form :env &env})
  `(println "macro was called!"))
#_#'advance-your-macro-techniques/info-about-caller

(info-about-caller)
#_{:form (info-about-caller), :env nil}
;; macro was called!
#_nil

(let [foo "bar"] (info-about-caller))
;; {:form (info-about-caller),
;; :env
;; {foo
;; #object[clojure.lang.Compiler$LocalBinding 0x77a8e01f "clojure.lang.Compiler$LocalBinding@77a8e01f"]}}
;;macro was called!
#_nil


(defmacro inspect-caller-locals []
  (->> (keys &env)
       (map (fn [k] [`'~k k]))
       (into {})))
#_#'advance-your-macro-techniques/inspect-caller-locals

(inspect-caller-locals)
#_{}

(let [foo "bar" baz "quux"] (inspect-caller-locals))
#_{foo "bar", baz "quux"}


(defmacro inspect-caller-locals-1 []
  (->> (keys &env)
       (map (fn [k] [`(quote ~k) k]))
       (into {})))
#_#'advance-your-macro-techniques/inspect-caller-locals-1


(defmacro inspect-caller-locals-2 []
  (->> (keys &env)
       (map (fn [k] [(list 'quote k) k]))
       (into {})))
#_#'advance-your-macro-techniques/inspect-caller-locals-2


(inspect-caller-locals-1)
#_{}
(inspect-caller-locals-2)
#_{}
(let [foo "bar" baz "quux"] (inspect-caller-locals-1))
#_{foo "bar", baz "quux"}
(let [foo "bar" baz "quux"] (inspect-caller-locals-2))
#_{foo "bar", baz "quux"}

;; We can use &form to get the list passed to the macro.

(defmacro inspect-called-form [& arguments]
  {:form (list 'quote &form)})
#_#'advance-your-macro-techniques/inspect-called-form

^{:doc "this is good stuff"} (inspect-called-form 1 2 3)
#_{:form (inspect-called-form 1 2 3)}

(meta (:form *1))
#_{:line 281, :column 0, :doc "this is good stuff"}

(inspect-called-form [] (+ 1 1))
