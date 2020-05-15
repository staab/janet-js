(use multimethod)

(defmulti janet->js |(if (array? $) :multiple (get $ 0)))

(defmethod janet->js :multiple [xs]
  (map janet->js xs))

(defmethod janet->js :top [[_ tree]]
  @{:type "Program" :sourceType "script" :body (janet->js tree)})

(defmethod janet->js :ptuple [[_ tree]]
  @{:type "ExpressionStatement"
    :expression @{:type "CallExpression"
                  :callee (janet->js (get tree 0))
                  :arguments (map janet->js (drop 1 tree))}})

(defmethod janet->js :span [[_ tree]]
  (if-let [number (scan-number tree)]
    @{:type "Literal" :value number :raw tree}
    @{:type "Identifier" :name tree}))

(defmethod janet->js :string [[_ tree]]
  @{:type "Literal" :value (string/slice tree 1 -2) :raw tree})
