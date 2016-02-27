(ns primative-data
  (:require [clojure.string :as str]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 1.1 Capitalization of a String ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(str/capitalize "this is a proper sentence") ;; => "This is a proper sentence"

(str/upper-case "loud noises") ;; => "LOUD NOISES"

(str/lower-case "COLUMN_HEADER_ONE") ;; => "column_header_one"

;; Non letters don't get changed.
(str/lower-case "!@#$%^&*()") ;; => "!@#$%^&*()"

;; Also works for other languages thanks to the utf-16-ness of the strings.
(str/upper-case "Dépêchez-vous, l'ordinateur!") ;; => "DÉPÊCHEZ-VOUS, L'ORDINATEUR!"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 1.2 Cleaning up Whitespace in a string ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(str/trim " \tBacon ipsum dolor sit.\n") ;; => "Bacon ipsum dolor sit."

;; Using the "\s+" regex to say get rid of all whitespace longer than one
;; whitespace and replace it with one space
(str/replace "Who\t\nput  all this\fwhitespace here?"
             #"\s+"
             " ") ;; => "Who put all this whitespace here?"

;; Windows->Unix style newlines
(str/replace "Line 1\r\nLine 2"
             "\r\n"
             "\n") ;; => "Line 1\nLine 2"

;; You can also just trim the whitespace from the left or right side of a
;; string.
(str/triml ) ;; => "Bacon ipsum dolor sit.\n"
(str/trimr " \tBacon ipsum dolor sit.\n") ;; => " \tBacon ipsum dolor sit."

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 1.3 Building a String from Parts ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(str "John" " " "Doe") ;; => "John Doe"

;; Str works on vars, let values, etc.
(let [first-name "John"
      last-name "Doe"
      age 42]
  (str last-name ", " first-name " - age: " age)) ;; => "Doe, John - age: 42"


;; Use apply to take a seq of Chars and turn them back into a string.
(apply str "ROT13: " [\W \h \y \v \h \f \  \P \n \r \f \n \e]) ;; => "ROT13: Whyvhf Pnrfne"

;; apply makes it easy to do things like splitting up data, etc, since it isn't
;; a fancy string set up specifically for string manipulation.
(let [header "first_name,last_name,employee_number\n"
      rows ["luke,vanderhart,1","ryan,neufeld,2"]]
  (apply str header (interpose "\n" rows))) ;; => "first_name,last_name,employee_number\nluke,vanderhart,1\nryan,neufeld,2"


;; If all you are doing is joining data together, maybe with a separator, you
;; might just want to use
(let [food-items ["milk" "butter" "flour" "eggs"]]
  (str/join ", " food-items)) ;; => "milk, butter, flour, eggs"

(str/join [1 2 3 4]) ;; => "1234"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 1.4 Treating a String as a sequence of Chars ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(seq "Hello, World") ;; => (\H \e \l \l \o \, \space \W \o \r \l \d)

;; You don't need to call seq, though. Any collection fn will coerce it for you.
(frequencies (str/lower-case "An adult all about A's")) ;; => {\space 4, \a 5, \b 1, \d 1, \' 1, \l 3, \n 1, \o 1, \s 1, \t 2, \u 2}

;; Is every letter in a string capitalized?
(let [yelling? (fn [s] (every? #(or (not (Character/isLetter %))
                                    (Character/isUpperCase %))
                               s))]
  [(yelling? "LOUD NOISES!")
   (yelling? "Take a DEEP breath.")]) ;; => [true false]

;; When you're done messing with a string, you should just use apply str to turn
;; it back into a "proper string"
(apply str [\H \e \l \l \o \, \space \w \o \r \l \d \!]) ;; => "Hello, world!"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 1.5. Converting Between Characters and Integers ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; int turns a char into its integer value

(int \a) ;; => 97
(int \ø) ;; => 248

;; Greek letter alpha
(int \α) ;; => 945

;; Alpha via code point
(int \u03B1) ;; => 945

(map int "Hello, World") ;; => (72 101 108 108 111 44 32 87 111 114 108 100)

;; To go the other way, use the char function.

(char 97) ;; => \a
(char 248) ;; => \ø
(char 945) ;; => \α

(apply str
       (map char [115 101 99 114 101 116 32 109 101 115 115 97 103 101 115])) ;; => "secret messages"

;; Prints out all the Cyrillic letters.
(map char (range 0x0410 0x042F)) ;; => (\А \Б \В \Г \Д \Е \Ж \З \И \Й \К \Л \М \Н \О \П \Р \С \Т \У \Ф \Х \Ц \Ч \Ш \Щ \Ъ \Ы \Ь \Э \Ю)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 1.6. Formatting Strings ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; One of the easiest ways to manipulate strings is through the str function.
(let [me {:first-name "Matt", :favorite-language "Probably Clojure"}]
  (str "My name is " (:first-name me)
       ", and I really like to program in " (:favorite-language me))) ;; => "My name is Matt, and I really like to program in Probably Clojure"

(apply str (interpose " " [1 2.000 (/ 3 1) (/ 4 9)])) ;; => "1 2.0 3 4/9"

(let [filename (fn [name i]
                 (format "%03d-%s" i name))]
  (filename "my-awesome-file.txt" 42)) ;; => "042-my-awesome-file.txt"

;; The 0 flag indicates to pad a digit (d) with zeros (three, in this case).
;; The - flag indicates to left justify the string (s), giving it a total minimum width of 20 characters.
(let [tableify (fn [row]
                 (apply format "%-20s | %-20s | %-20s" row))
      header ["First Name", "Last Name", "Employee ID"]
      employees [["Ryan", "Neufeld", 2]
                 ["Luke", "Vanderhart", 1]]]
  (->> (concat [header] employees)
       (map tableify)
       (mapv println))) ;; => [nil nil nil]

;; The output looked like this

;; First Name           | Last Name            | Employee ID
;; Ryan                 | Neufeld              | 2
;; Luke                 | Vanderhart           | 1
