(import (chibi))
;;(define (say-hello)
;;  (display "The say hello function was called!")
;;  (newline))

;;(define lucky-number 666)

;;(define (square a)
;;  (* a a))

;;(define (my-str-len s)
;;  (letrec ((my-str-len-h (lambda (s acc)
;;    (if (null? s)
;;      acc
;;      (my-str-len-h (cdr s) (+ 1 acc))))))
;;		(my-str-len-h (string->list s) 0)))
;;
;;(define (my-test-c)
;;	(display "hello world")
;;	(display (testC)))

(display "in scheme")

(define (say-hello)
	(display "say-hello")
	(newline)
	(hello-user "testc"))



