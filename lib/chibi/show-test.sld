(define-library (chibi show-test)
  (export run-tests)
  (import (scheme base) (scheme char) (scheme read)
          (chibi test)
          (chibi show) (chibi show base) (chibi show color)
          (chibi show column) (chibi show pretty)
          (chibi show unicode))
  (begin
    (define-syntax test-pretty
      (syntax-rules ()
        ((test-pretty str)
         (let ((sexp (read (open-input-string str))))
           (test str (show #f (pretty sexp)))))))
    (define (run-tests)
      (test-begin "show")

      ;; basic data types

      (test "hi" (show #f "hi"))
      (test "\"hi\"" (show #f (written "hi")))
      (test "\"hi \\\"bob\\\"\"" (show #f (written "hi \"bob\"")))
      (test "\"hello\\nworld\"" (show #f (written "hello\nworld")))
      (test "#(1 2 3)" (show #f (written '#(1 2 3))))
      (test "(1 2 3)" (show #f (written '(1 2 3))))
      (test "(1 2 . 3)" (show #f (written '(1 2 . 3))))
      (test "ABC" (show #f (upcased "abc")))
      (test "abc" (show #f (downcased "ABC")))

      (test "abc     def" (show #f "abc" (tab-to) "def"))
      (test "abc  def" (show #f "abc" (tab-to 5) "def"))
      (test "abcdef" (show #f "abc" (tab-to 3) "def"))

      ;; numbers

      (test "-1" (show #f -1))
      (test "0" (show #f 0))
      (test "1" (show #f 1))
      (test "10" (show #f 10))
      (test "100" (show #f 100))
      (test "-1" (show #f (numeric -1)))
      (test "0" (show #f (numeric 0)))
      (test "1" (show #f (numeric 1)))
      (test "10" (show #f (numeric 10)))
      (test "100" (show #f (numeric 100)))
      (test "57005" (show #f #xDEAD))
      (test "#xdead" (show #f (with ((radix 16)) #xDEAD)))
      (test "#xdead1234" (show #f (with ((radix 16)) #xDEAD) 1234))
      (test "de.ad"
          (show #f (with ((radix 16) (precision 2)) (numeric (/ #xDEAD #x100)))))
      (test "d.ead"
          (show #f (with ((radix 16) (precision 3)) (numeric (/ #xDEAD #x1000)))))
      (test "0.dead"
          (show #f (with ((radix 16) (precision 4)) (numeric (/ #xDEAD #x10000)))))
      (test "1g"
          (show #f (with ((radix 17)) (numeric 33))))

      (test "3.14159" (show #f 3.14159))
      (test "3.14" (show #f (with ((precision 2)) 3.14159)))
      (test "3.14" (show #f (with ((precision 2)) 3.14)))
      (test "3.00" (show #f (with ((precision 2)) 3.)))
      (test "1.10" (show #f (with ((precision 2)) 1.099)))
      (test "0.00" (show #f (with ((precision 2)) 1e-17)))
      (test "0.0000000010" (show #f (with ((precision 10)) 1e-9)))
      (test "0.0000000000" (show #f (with ((precision 10)) 1e-17)))
      (test "0.000004" (show #f (with ((precision 6)) 0.000004)))
      (test "0.0000040" (show #f (with ((precision 7)) 0.000004)))
      (test "0.00000400" (show #f (with ((precision 8)) 0.000004)))
      (test "1.00" (show #f (with ((precision 2)) .997554209949891)))
      (test "1.00" (show #f (with ((precision 2)) .99755420)))
      (test "1.00" (show #f (with ((precision 2)) .99755)))
      (test "1.00" (show #f (with ((precision 2)) .997)))
      (test "0.99" (show #f (with ((precision 2)) .99)))
      (test "-15." (show #f (with ((precision 0)) -14.99995999999362)))

      (test "   3.14159" (show #f (with ((decimal-align 5)) (numeric 3.14159))))
      (test "  31.4159" (show #f (with ((decimal-align 5)) (numeric 31.4159))))
      (test " 314.159" (show #f (with ((decimal-align 5)) (numeric 314.159))))
      (test "3141.59" (show #f (with ((decimal-align 5)) (numeric 3141.59))))
      (test "31415.9" (show #f (with ((decimal-align 5)) (numeric 31415.9))))
      (test "  -3.14159" (show #f (with ((decimal-align 5)) (numeric -3.14159))))
      (test " -31.4159" (show #f (with ((decimal-align 5)) (numeric -31.4159))))
      (test "-314.159" (show #f (with ((decimal-align 5)) (numeric -314.159))))
      (test "-3141.59" (show #f (with ((decimal-align 5)) (numeric -3141.59))))
      (test "-31415.9" (show #f (with ((decimal-align 5)) (numeric -31415.9))))

      (cond
       ((exact? (/ 1 3)) ;; exact rationals
        (test "333.333333333333333333333333333333"
            (show #f (with ((precision 30)) (numeric 1000/3))))
        (test  "33.333333333333333333333333333333"
            (show #f (with ((precision 30)) (numeric 100/3))))
        (test   "3.333333333333333333333333333333"
            (show #f (with ((precision 30)) (numeric 10/3))))
        (test   "0.333333333333333333333333333333"
            (show #f (with ((precision 30)) (numeric 1/3))))
        (test   "0.033333333333333333333333333333"
            (show #f (with ((precision 30)) (numeric 1/30))))
        (test   "0.003333333333333333333333333333"
            (show #f (with ((precision 30)) (numeric 1/300))))
        (test   "0.000333333333333333333333333333"
            (show #f (with ((precision 30)) (numeric 1/3000))))
        (test   "0.666666666666666666666666666667"
            (show #f (with ((precision 30)) (numeric 2/3))))
        (test   "0.090909090909090909090909090909"
            (show #f (with ((precision 30)) (numeric 1/11))))
        (test   "1.428571428571428571428571428571"
            (show #f (with ((precision 30)) (numeric 10/7))))
        (test "0.123456789012345678901234567890"
            (show #f (with ((precision 30))
                       (numeric (/  123456789012345678901234567890
                                    1000000000000000000000000000000)))))
        (test  " 333.333333333333333333333333333333"
            (show #f (with ((precision 30) (decimal-align 5)) (numeric 1000/3))))
        (test  "  33.333333333333333333333333333333"
            (show #f (with ((precision 30) (decimal-align 5)) (numeric 100/3))))
        (test  "   3.333333333333333333333333333333"
            (show #f (with ((precision 30) (decimal-align 5)) (numeric 10/3))))
        (test  "   0.333333333333333333333333333333"
            (show #f (with ((precision 30) (decimal-align 5)) (numeric 1/3))))
        ))

      (test "11.75" (show #f (with ((precision 2)) (/ 47 4))))
      (test "-11.75" (show #f (with ((precision 2)) (/ -47 4))))

      (test "(#x11 #x22 #x33)" (show #f (with ((radix 16)) '(#x11 #x22 #x33))))

      (test "299792458" (show #f (with ((comma-rule 3)) 299792458)))
      (test "299,792,458" (show #f (with ((comma-rule 3)) (numeric 299792458))))
      (test "-29,97,92,458"
          (show #f (with ((comma-rule '(3 . 2))) (numeric -299792458))))
      (test "299.792.458"
          (show #f (with ((comma-rule 3) (comma-sep #\.)) (numeric 299792458))))
      (test "299.792.458,0"
          (show #f (with ((comma-rule 3) (decimal-sep #\,)) (numeric 299792458.0))))

      (test "100,000" (show #f (with ((comma-rule 3)) (numeric 100000))))
      (test "100,000.0"
          (show #f (with ((comma-rule 3) (precision 1)) (numeric 100000))))
      (test "100,000.00"
          (show #f (with ((comma-rule 3) (precision 2)) (numeric 100000))))

      (cond-expand
       (complex
        (test "1+2i" (show #f (string->number "1+2i")))
        (test "1.00+2.00i"
            (show #f (with ((precision 2)) (string->number "1+2i"))))
        (test "3.14+2.00i"
            (show #f (with ((precision 2)) (string->number "3.14159+2i"))))))

      (test "608" (show #f (numeric/si 608)))
      (test "3.9Ki" (show #f (numeric/si 3986)))
      (test "4kB" (show #f (numeric/si 3986 1000) "B"))
      (test "1.2Mm" (show #f (numeric/si 1.23e6 1000) "m"))
      (test "123km" (show #f (numeric/si 1.23e5 1000) "m"))
      (test "12.3km" (show #f (numeric/si 1.23e4 1000) "m"))
      (test "1.2km" (show #f (numeric/si 1.23e3 1000) "m"))
      (test "123m" (show #f (numeric/si 1.23e2 1000) "m"))
      (test "12.3m" (show #f (numeric/si 1.23e1 1000) "m"))
      (test "1.2m" (show #f (numeric/si 1.23 1000) "m"))
      (test "123mm" (show #f (numeric/si 0.123 1000) "m"))
      (test "12.3mm" (show #f (numeric/si 1.23e-2 1000) "m")) ;?
      (test "1.2mm" (show #f (numeric/si 1.23e-3 1000) "m"))
      (test "123µm" (show #f (numeric/si 1.23e-4 1000) "m"))  ;?
      (test "12.3µm" (show #f (numeric/si 1.23e-5 1000) "m")) ;?
      (test "1.2µm" (show #f (numeric/si 1.23e-6 1000) "m"))

      (test "1,234,567" (show #f (numeric/comma 1234567)))

      (test "1.23" (show #f (numeric/fitted 4 1.2345 10 2)))
      (test "1.00" (show #f (numeric/fitted 4 1 10 2)))
      (test "#.##" (show #f (numeric/fitted 4 12.345 10 2)))

      ;; padding/trimming

      (test "abc  " (show #f (padded 5 "abc")))
      (test "  abc" (show #f (padded/left 5 "abc")))
      (test " abc " (show #f (padded/both 5 "abc")))
      (test "abcde" (show #f (padded 5 "abcde")))
      (test "abcdef" (show #f (padded 5 "abcdef")))

      (test "abc" (show #f (trimmed 3 "abcde")))
      (test "abc" (show #f (trimmed 3 "abcd")))
      (test "abc" (show #f (trimmed 3 "abc")))
      (test "ab" (show #f (trimmed 3 "ab")))
      (test "a" (show #f (trimmed 3 "a")))
      (test "cde" (show #f (trimmed/left 3 "abcde")))
      (test "bcd" (show #f (trimmed/both 3 "abcde")))
      (test "bcdef" (show #f (trimmed/both 5 "abcdefgh")))
      (test "abc" (show #f (trimmed/lazy 3 "abcde")))
      (test "abc" (show #f (trimmed/lazy 3 "abc\nde")))

      (test "prefix: abc" (show #f "prefix: " (trimmed 3 "abcde")))
      (test "prefix: cde" (show #f "prefix: " (trimmed/left 3 "abcde")))
      (test "prefix: bcd" (show #f "prefix: " (trimmed/both 3 "abcde")))
      (test "prefix: abc" (show #f "prefix: " (trimmed/lazy 3 "abcde")))
      (test "prefix: abc" (show #f "prefix: " (trimmed/lazy 3 "abc\nde")))

      (test "abc :suffix" (show #f (trimmed 3 "abcde") " :suffix"))
      (test "cde :suffix" (show #f (trimmed/left 3 "abcde") " :suffix"))
      (test "bcd :suffix" (show #f (trimmed/both 3 "abcde") " :suffix"))
      (test "abc :suffix" (show #f (trimmed/lazy 3 "abcde") " :suffix"))
      (test "abc :suffix" (show #f (trimmed/lazy 3 "abc\nde") " :suffix"))

      (test "abcde"
          (show #f (with ((ellipsis "...")) (trimmed 5 "abcde"))))
      (test "ab..."
          (show #f (with ((ellipsis "...")) (trimmed 5 "abcdef"))))
      (test "abc..."
          (show #f (with ((ellipsis "...")) (trimmed 6 "abcdefg"))))
      (test "abcde"
          (show #f (with ((ellipsis "...")) (trimmed/left 5 "abcde"))))
      (test "...ef"
          (show #f (with ((ellipsis "...")) (trimmed/left 5 "abcdef"))))
      (test "...efg"
          (show #f (with ((ellipsis "...")) (trimmed/left 6 "abcdefg"))))
      (test "abcdefg"
          (show #f (with ((ellipsis "...")) (trimmed/both 7 "abcdefg"))))
      (test "...d..."
          (show #f (with ((ellipsis "...")) (trimmed/both 7 "abcdefgh"))))
      (test "...e..."
          (show #f (with ((ellipsis "...")) (trimmed/both 7 "abcdefghi"))))

      (test "abc  " (show #f (fitted 5 "abc")))
      (test "  abc" (show #f (fitted/left 5 "abc")))
      (test " abc " (show #f (fitted/both 5 "abc")))
      (test "abcde" (show #f (fitted 5 "abcde")))
      (test "abcde" (show #f (fitted/left 5 "abcde")))
      (test "abcde" (show #f (fitted/both 5 "abcde")))
      (test "abcde" (show #f (fitted 5 "abcdefgh")))
      (test "defgh" (show #f (fitted/left 5 "abcdefgh")))
      (test "bcdef" (show #f (fitted/both 5 "abcdefgh")))

      (test "prefix: abc   :suffix"
          (show #f "prefix: " (fitted 5 "abc") " :suffix"))
      (test "prefix:   abc :suffix"
          (show #f "prefix: " (fitted/left 5 "abc") " :suffix"))
      (test "prefix:  abc  :suffix"
          (show #f "prefix: " (fitted/both 5 "abc") " :suffix"))
      (test "prefix: abcde :suffix"
          (show #f "prefix: " (fitted 5 "abcde") " :suffix"))
      (test "prefix: abcde :suffix"
          (show #f "prefix: " (fitted/left 5 "abcde") " :suffix"))
      (test "prefix: abcde :suffix"
          (show #f "prefix: " (fitted/both 5 "abcde") " :suffix"))
      (test "prefix: abcde :suffix"
          (show #f "prefix: " (fitted 5 "abcdefgh") " :suffix"))
      (test "prefix: defgh :suffix"
          (show #f "prefix: " (fitted/left 5 "abcdefgh") " :suffix"))
      (test "prefix: bcdef :suffix"
          (show #f "prefix: " (fitted/both 5 "abcdefgh") " :suffix"))

      ;; joining

      (test "1 2 3" (show #f (joined each '(1 2 3) " ")))

      (test ":abc:123"
          (show #f (joined/prefix
                    (lambda (x) (trimmed 3 x))
                    '("abcdef" "123456")
                    ":")))

      (test "abc\n123\n"
          (show #f (joined/suffix
                    (lambda (x) (trimmed 3 x))
                    '("abcdef" "123456")
                    nl)))

      (test "lions, tigers, and bears"
          (show #f (joined/last
                    each
                    (lambda (x) (each "and " x))
                    '(lions tigers bears)
                    ", ")))

      (test "lions, tigers, or bears"
          (show #f (joined/dot
                    each
                    (lambda (x) (each "or " x))
                    '(lions tigers . bears)
                    ", ")))

      ;; escaping

      (test "hi, bob!" (show #f (escaped "hi, bob!")))
      (test "hi, \\\"bob!\\\"" (show #f (escaped "hi, \"bob!\"")))
      (test "bob" (show #f (maybe-escaped "bob" char-whitespace?)))
      (test "\"hi, bob!\""
          (show #f (maybe-escaped "hi, bob!" char-whitespace?)))

      ;; shared structures

      (test "#0=(1 . #0#)"
          (show #f (written (let ((ones (list 1))) (set-cdr! ones ones) ones))))
      (test "(0 . #0=(1 . #0#))"
          (show #f (written (let ((ones (list 1)))
                              (set-cdr! ones ones)
                              (cons 0 ones)))))
      (test "(sym . #0=(sym . #0#))"
          (show #f (written (let ((syms (list 'sym)))
                              (set-cdr! syms syms)
                              (cons 'sym syms)))))
      (test "(#0=(1 . #0#) #1=(2 . #1#))"
          (show #f (written (let ((ones (list 1))
                                  (twos (list 2)))
                              (set-cdr! ones ones)
                              (set-cdr! twos twos)
                              (list ones twos)))))
      (test "(#0=(1 . #0#) #0#)"
          (show #f (written (let ((ones (list 1)))
                              (set-cdr! ones ones)
                              (list ones ones)))))
      (test "((1) (1))"
          (show #f (written (let ((ones (list 1)))
                              (list ones ones)))))

      (test "(#0=(1) #0#)"
          (show #f (written-shared (let ((ones (list 1)))
                                     (list ones ones)))))

      ;; cycles without shared detection

      (test "(1 1 1 1 1"
          (show #f (trimmed/lazy
                    10
                    (written-simply
                     (let ((ones (list 1))) (set-cdr! ones ones) ones)))))

      (test "(1 1 1 1 1 "
          (show #f (trimmed/lazy
                    11
                    (written-simply
                     (let ((ones (list 1))) (set-cdr! ones ones) ones)))))

      ;; pretty printing

      (test-pretty "(foo bar)\n")

      (test-pretty
       "((self . aquanet-paper-1991)
 (type . paper)
 (title . \"Aquanet: a hypertext tool to hold your\"))
")

      (test-pretty
       "(abracadabra xylophone
             bananarama
             yellowstonepark
             cryptoanalysis
             zebramania
             delightful
             wubbleflubbery)\n")

      (test-pretty
       "#(0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
  26 27 28 29 30 31 32 33 34 35 36 37)\n")

      (test-pretty
       "(0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
 26 27 28 29 30 31 32 33 34 35 36 37)\n")

      (test-pretty
       "(#(0 1)   #(2 3)   #(4 5)   #(6 7)   #(8 9)   #(10 11) #(12 13) #(14 15)
 #(16 17) #(18 19))\n")

      (test-pretty
       "(define (fold kons knil ls)
  (define (loop ls acc)
    (if (null? ls) acc (loop (cdr ls) (kons (car ls) acc))))
  (loop ls knil))\n")

      (test-pretty
       "(do ((vec (make-vector 5)) (i 0 (+ i 1))) ((= i 5) vec) (vector-set! vec i i))\n")

      (test-pretty
       "(do ((vec (make-vector 5)) (i 0 (+ i 1))) ((= i 5) vec)
  (vector-set! vec i 'supercalifrajalisticexpialidocious))\n")

      (test-pretty
       "(do ((my-vector (make-vector 5)) (index 0 (+ index 1)))
    ((= index 5) my-vector)
  (vector-set! my-vector index index))\n")

      (test-pretty
       "(define (fold kons knil ls)
  (let loop ((ls ls) (acc knil))
    (if (null? ls) acc (loop (cdr ls) (kons (car ls) acc)))))\n")

      (test-pretty
       "(define (file->sexp-list pathname)
  (call-with-input-file pathname
    (lambda (port)
      (let loop ((res '()))
        (let ((line (read port)))
          (if (eof-object? line) (reverse res) (loop (cons line res))))))))\n")

      (test-pretty
       "(design
 (module (name \"\\\\testshiftregister\") (attributes (attribute (name \"\\\\src\"))))
 (wire (name \"\\\\shreg\") (attributes (attribute (name \"\\\\src\")))))\n")

      (test-pretty
       "(design
 (module (name \"\\\\testshiftregister\")
         (attributes
          (attribute (name \"\\\\src\") (value \"testshiftregister.v:10\"))))
 (wire (name \"\\\\shreg\")
       (attributes
        (attribute (name \"\\\\src\") (value \"testshiftregister.v:15\")))))\n")

      (test "(let ((ones '#0=(1 . #0#))) ones)\n"
          (show #f (pretty (let ((ones (list 1)))
                             (set-cdr! ones ones)
                             `(let ((ones ',ones)) ones)))))

      '(test
           "(let ((zeros '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
      (ones '#0=(1 . #0#)))
  (append zeros ones))\n"
           (show #f (pretty
                     (let ((ones (list 1)))
                       (set-cdr! ones ones)
                       `(let ((zeros '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
                              (ones ',ones))
                          (append zeros ones))))))

      ;; columns

      (test "abc\ndef\n"
          (show #f (show-columns (list displayed "abc\ndef\n"))))
      (test "abc123\ndef456\n"
          (show #f (show-columns (list displayed "abc\ndef\n")
                                 (list displayed "123\n456\n"))))
      (test "abc123\ndef456\n"
          (show #f (show-columns (list displayed "abc\ndef\n")
                                 (list displayed "123\n456"))))
      (test "abc123\ndef456\n"
          (show #f (show-columns (list displayed "abc\ndef")
                                 (list displayed "123\n456\n"))))
      (test "abc123\ndef456\nghi789\n"
          (show #f (show-columns (list displayed "abc\ndef\nghi\n")
                                 (list displayed "123\n456\n789\n"))))
      (test "abc123wuv\ndef456xyz\n"
          (show #f (show-columns (list displayed "abc\ndef\n")
                                 (list displayed "123\n456\n")
                                 (list displayed "wuv\nxyz\n"))))
      (test "abc  123\ndef  456\n"
          (show #f (show-columns (list (lambda (x) (padded/right 5 x))
                                       "abc\ndef\n")
                                 (list displayed "123\n456\n"))))
      (test "ABC  123\nDEF  456\n"
          (show #f (show-columns (list (lambda (x) (upcased (padded/right 5 x)))
                                       "abc\ndef\n")
                                 (list displayed "123\n456\n"))))
      (test "ABC  123\nDEF  456\n"
          (show #f (show-columns (list (lambda (x) (padded/right 5 (upcased x)))
                                       "abc\ndef\n")
                                 (list displayed "123\n456\n"))))

      (test "hello\nworld\n"
          (show #f (with ((width 8)) (wrapped "hello world"))))
      (test "\n" (show #f (wrapped "    ")))

      (test
          "The  quick
brown  fox
jumped
over   the
lazy dog
"
          (show #f
                (with ((width 10))
                  (justified "The quick brown fox jumped over the lazy dog"))))

      (test
          "The fundamental list iterator.
Applies KONS to each element of
LS and the result of the previous
application, beginning with KNIL.
With KONS as CONS and KNIL as '(),
equivalent to REVERSE.
"
          (show #f
                (with ((width 36))
                  (wrapped "The fundamental list iterator.  Applies KONS to each element of LS and the result of the previous application, beginning with KNIL.  With KONS as CONS and KNIL as '(), equivalent to REVERSE."))))

      (test
          "(define (fold kons knil ls)
  (let lp ((ls ls) (acc knil))
    (if (null? ls)
        acc
        (lp (cdr ls)
            (kons (car ls) acc)))))
"
          (show #f
                (with ((width 36))
                  (pretty '(define (fold kons knil ls)
                             (let lp ((ls ls) (acc knil))
                               (if (null? ls)
                                   acc
                                   (lp (cdr ls)
                                       (kons (car ls) acc)))))))))

      '(test
           "(define (fold kons knil ls)          ; The fundamental list iterator.
  (let lp ((ls ls) (acc knil))       ; Applies KONS to each element of
    (if (null? ls)                   ; LS and the result of the previous
        acc                          ; application, beginning with KNIL.
        (lp (cdr ls)                 ; With KONS as CONS and KNIL as '(),
            (kons (car ls) acc)))))  ; equivalent to REVERSE.
"
           (show #f
                 (show-columns
                  (list
                   (lambda (x) (padded/right 36 x))
                   (with ((width 36))
                     (pretty '(define (fold kons knil ls)
                                (let lp ((ls ls) (acc knil))
                                  (if (null? ls)
                                      acc
                                      (lp (cdr ls)
                                          (kons (car ls) acc))))))))
                  (list
                   (lambda (x) (each " ; " x))
                   (with ((width 36))
                     (wrapped "The fundamental list iterator.  Applies KONS to each element of LS and the result of the previous application, beginning with KNIL.  With KONS as CONS and KNIL as '(), equivalent to REVERSE."))))))

      '(test
           "(define (fold kons knil ls)          ; The fundamental list iterator.
  (let lp ((ls ls) (acc knil))       ; Applies KONS to each element of
    (if (null? ls)                   ; LS and the result of the previous
        acc                          ; application, beginning with KNIL.
        (lp (cdr ls)                 ; With KONS as CONS and KNIL as '(),
            (kons (car ls) acc)))))  ; equivalent to REVERSE.
"
           (show #f (with ((width 76))
                      (columnar
                       (pretty '(define (fold kons knil ls)
                                  (let lp ((ls ls) (acc knil))
                                    (if (null? ls)
                                        acc
                                        (lp (cdr ls)
                                            (kons (car ls) acc))))))
                       " ; "
                       (wrapped "The fundamental list iterator.  Applies KONS to each element of LS and the result of the previous application, beginning with KNIL.  With KONS as CONS and KNIL as '(), equivalent to REVERSE.")))))

      (test
          "- Item 1: The text here is
          indented according
          to the space \"Item
          1\" takes, and one
          does not known what
          goes here.
"
          (show #f (columnar 9 (each "- Item 1:") " " (with ((width 20)) (wrapped "The text here is indented according to the space \"Item 1\" takes, and one does not known what goes here.")))))

      (test
          "- Item 1: The text here is
          indented according
          to the space \"Item
          1\" takes, and one
          does not known what
          goes here.
"
          (show #f (columnar 9 (each "- Item 1:\n") " " (with ((width 20)) (wrapped "The text here is indented according to the space \"Item 1\" takes, and one does not known what goes here.")))))

      (test
          "- Item 1: The-text-here-is----------------------------------------------------
--------- indented-according--------------------------------------------------
--------- to-the-space-\"Item--------------------------------------------------
--------- 1\"-takes,-and-one---------------------------------------------------
--------- does-not-known-what-------------------------------------------------
--------- goes-here.----------------------------------------------------------
"
          (show #f (with ((pad-char #\-)) (columnar 9 (each "- Item 1:\n") " " (with ((width 20)) (wrapped "The text here is indented according to the space \"Item 1\" takes, and one does not known what goes here."))))))

      (test
          "a   | 123
bc  | 45
def | 6
"
          (show #f (with ((width 20))
                    (tabular (each "a\nbc\ndef\n") " | "
                             (each "123\n45\n6\n")))))

      ;; color
      (test "\x1B;[31mred\x1B;[0m" (show #f (as-red "red")))
      (test "\x1B;[31mred\x1B;[34mblue\x1B;[31mred\x1B;[0m"
          (show #f (as-red "red" (as-blue "blue") "red")))

      ;; unicode
      (test "〜日本語〜"
          (show #f (with ((pad-char #\〜)) (padded/both 5 "日本語"))))
      (test "日本語"
          (show #f (as-unicode (with ((pad-char #\〜)) (padded/both 5 "日本語")))))

      (test-end))))
