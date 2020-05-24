(import dom)

(defn get-node-type [selector]
  ((dom/query-selector selector) :node-type))
