
(define-library (srfi 160 u16)
  (export
   make-u16vector
   u16?
   u16vector?
   u16vector-ref
   u16vector-set!
   u16vector-length
   (rename vector u16vector)
   (rename uvector-unfold u16vector-unfold)
   (rename uvector-unfold-right u16vector-unfold-right)
   (rename vector-copy u16vector-copy)
   (rename vector-reverse-copy u16vector-reverse-copy)
   (rename vector-append u16vector-append)
   (rename vector-concatenate u16vector-concatenate)
   (rename vector-append-subvectors u16vector-append-subvectors)
   (rename vector-empty? u16vector-empty?)
   (rename vector= u16vector=)
   (rename vector-take u16vector-take)
   (rename vector-take-right u16vector-take-right)
   (rename vector-drop u16vector-drop)
   (rename vector-drop-right u16vector-drop-right)
   (rename vector-segment u16vector-segment)
   (rename vector-fold u16vector-fold)
   (rename vector-fold-right u16vector-fold-right)
   (rename vector-map u16vector-map)
   (rename vector-map! u16vector-map!)
   (rename vector-for-each u16vector-for-each)
   (rename vector-count u16vector-count)
   (rename vector-cumulate u16vector-cumulate)
   (rename vector-take-while u16vector-take-while)
   (rename vector-take-while-right u16vector-take-while-right)
   (rename vector-drop-while u16vector-drop-while)
   (rename vector-drop-while-right u16vector-drop-while-right)
   (rename vector-index u16vector-index)
   (rename vector-index-right u16vector-index-right)
   (rename vector-skip u16vector-skip)
   (rename vector-skip-right u16vector-skip-right)
   (rename vector-binary-search u16vector-binary-search)
   (rename vector-any u16vector-any)
   (rename vector-every u16vector-every)
   (rename vector-partition u16vector-partition)
   (rename vector-filter u16vector-filter)
   (rename vector-remove u16vector-remove)
   (rename vector-swap! u16vector-swap!)
   (rename vector-fill! u16vector-fill!)
   (rename vector-reverse! u16vector-reverse!)
   (rename vector-copy! u16vector-copy!)
   (rename vector-reverse-copy! u16vector-reverse-copy!)
   (rename uvector->list u16vector->list)
   (rename reverse-vector->list reverse-u16vector->list)
   (rename list->uvector list->u16vector)
   (rename reverse-list->vector reverse-list->u16vector)
   (rename uvector->vector u16vector->vector)
   (rename vector->uvector vector->u16vector)
   (rename make-vector-generator make-u16vector-generator)
   (rename write-vector write-u16vector))
  (import (except (scheme base)
                  vector-append vector-copy vector-copy!
                  vector-map vector-for-each)
          (scheme write)
          (srfi 160 base))
  (begin
    (define uvector? u16vector?)
    (define make-uvector make-u16vector)
    (define uvector-length u16vector-length)
    (define uvector-ref u16vector-ref)
    (define uvector-set! u16vector-set!))
  (include "uvector.scm"))
