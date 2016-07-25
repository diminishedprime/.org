(ns speed-up-your-systems
  (:require [criterium.core :as crit]))

(defn length-1 [x] (.length x))

(crit/with-progress-reporting
  (crit/bench (length-1 "hi there!")))

(defn length-2 [^String x] (.length x))

(crit/with-progress-reporting
  (crit/bench (length-2 "hi there!")))
