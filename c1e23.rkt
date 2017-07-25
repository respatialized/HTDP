;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname c1e23) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
(check-expect 3 4)
; fails because the numbers are not equal

(check-member-of "green" "red" "yellow" "grey")
; fails because "green" does not match any of the text that
; follows in the expression

(check-within (make-posn #i1.0 #i1.1)
              (make-posn #i0.9 #i1.2)
              0.01)
; fails because 1.0 - 0.9 > 0.01 and 1.1 - 1.2 < -0.01

(check-range #i0.9 #i0.6 #i0.8)
; fails because 0.9 > 0.8, the upper bound of the test

(check-error (/ 1 1))
; fails because 1 divided by 1 is valid math!

(check-random (make-posn (random 3) (random 9))
              (make-posn (random 9) (random 3)))
; fails because different ranges for the random numbers are
; specified

(check-satisfied 4 odd?)
; fails because 4 is not odd and does not satisfy the predicate

; Exercise 128: different types of checks for valid programs