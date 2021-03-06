(ns evaluate-code-in-context
  (:require [clojure.java.io :as io]))

(defn log [message]
  (let [timestamp (.format (java.text.SimpleDateFormat. "yyyy-MM-dd'T'HH:mmZ")
                           (java.util.Date.))]
    (println timestamp "[INFO]" message)))

(defn process-events [events]
  (doseq [event events]
    (log (format "Event %s has been processed" (:id event)))))


(let [file (java.io.File. (System/getProperty "user.home") "event-stream.log")]
  (with-open [file (clojure.java.io/writer file :append true)]
    (binding [*out* file]
      (process-events [{:id 88896} {:id 88898}]))))

;; Sorta terrible, how can macros make this better?

(defn with-out-file-fn [file body-fn]
  (with-open [writer (io/writer file :append true)]
    (binding [*out* writer]
      (body-fn))))

(defmacro with-out-file [file & body]
  `(with-out-file-fn ~file
     (fn [] ~@body)))

(let [file (io/file (System/getProperty "user.home") "event-stream.log")]
  (with-out-file file
    (process-events [{:id 88896} {:id 88898}])))
