(declare-project
  :name "janet-js"
  :description "A compiler written in janet, to compile (a subset of) janet to javascript."
  :dependencies ["https://github.com/staab/janet-multimethod"
                 "https://github.com/janet-lang/json"])

(declare-source
  :source ["js"])
