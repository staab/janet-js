# Adapted from https://github.com/janet-lang/spork/blob/master/spork/fmt.janet

(defn- pnode
  "Make a capture function for a node."
  [tag]
  (fn [x] [tag x]))

(def- parse-peg
  "Peg to parse Janet with extra information, namely comments."
  (peg/compile
    ~{:ws (+ (set " \t\r\f\0\v") '"\n")
      :readermac (/ '(set "';~,|") ,(pnode :readermac))
      :symchars (+ (range "09" "AZ" "az" "\x80\xFF") (set "!$%&*+-./:<?=>@^_"))
      :token (some :symchars)
      :hex (range "09" "af" "AF")
      :escape (* "\\" (+ (set "ntrzfev0\"\\")
                         (* "x" :hex :hex)
                         (* "u" :hex :hex :hex :hex)
                         (* "U" :hex :hex :hex :hex :hex :hex)
                         (error (constant "bad hex escape"))))
      :comment (/ (* "#" '(any (if-not (+ "\n" -1) 1)) (+ "\n" -1)) ,(pnode :comment))
      :span (/ ':token ,(pnode :span))
      :bytes '(* "\"" (any (+ :escape (if-not "\"" 1))) "\"")
      :string (/ :bytes ,(pnode :string))
      :buffer (/ (* "@" :bytes) ,(pnode :buffer))
      :long-bytes '{:delim (some "`")
                    :open (capture :delim :n)
                    :close (cmt (* (not (> -1 "`")) (-> :n) ':delim) ,=)
                    :main (drop (* :open (any (if-not :close 1)) :close))}
      :long-string (/ :long-bytes ,(pnode :string))
      :long-buffer (/ (* "@" :long-bytes) ,(pnode :buffer))
      :raw-value (+ :comment
                    :string :buffer :long-string :long-buffer
                    :parray :barray :ptuple :btuple :struct :dict :span)
      :value (* (any (+ :ws :readermac)) :raw-value (any :ws))
      :root (any :value)
      :root2 (any (* :value :value))
      :ptuple (/ (group (* "(" :root (+ ")" (error "")))) ,(pnode :ptuple))
      :btuple (/ (group (* "[" :root (+ "]" (error "")))) ,(pnode :btuple))
      :struct (/ (group (* "{" :root2 (+ "}" (error "")))) ,(pnode :struct))
      :parray (/ (group (* "@(" :root (+ ")" (error "")))) ,(pnode :array))
      :barray (/ (group (* "@[" :root (+ "]" (error "")))) ,(pnode :array))
      :dict (/ (group (* "@{" :root2 (+ "}" (error "")))) ,(pnode :table))
      :main :root}))

(defn make-tree
  "Turn a string of source code into a tree that will be printed"
  [source]
  [:top (peg/match parse-peg source)])
