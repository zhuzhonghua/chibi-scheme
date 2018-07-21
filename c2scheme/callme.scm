(import (chibi))

(display "hello world from scheme")
(newline)

(define (say-hello)
	(display "hello world from say-hello")
	(newline)
	(hello-user "chibi-scheme"))

(define (square a)
	(* a a))
