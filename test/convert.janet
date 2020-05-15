(import json)
(use tester)
(use js/parse)
(use js/convert)

(def test-string `
(add 1 2)`)

(defn esprimize [expr]
  (with [f (file/popen (string "node esprimize.js '" (string/replace-all "'" "\\'" expr) "'"))]
    (json/decode (file/read f :all) true true)))

(deftest
  (test
    "Emits a basic expression"
    (deep= (janet->js (make-tree test-string)) (esprimize "add(1, 2)"))))
