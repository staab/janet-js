(use tester)
(use js/parse)

(def test-string `
(+ 1 2)`)

(deftest
  (test
    "Parses a basic expression"
    (deep= (make-tree test-string)
           '(:top @[(:ptuple @[(:span "+") (:span "1") (:span "2")])]))))
