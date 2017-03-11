;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname c1e05) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; Example of a stub and function statement

; Number String Image -> Image
; adds s to img,
; y pixels from the top and 10 from the left
(define (add-image.v0 y s img)
  (empty-scene 100 100))

; Number -> Number
; computers the area of a square with side len
; given 2, expect 4
; given 7, expect 49
(define (area-of-square.v0 len)
  (... len ...))
; noting the incompleteness of the function

; Number -> Number
; computers the area of a square with side len
; given 2, expect 4
; given 7, expect 49
(define (area-of-square len)
  (sqr len))
; a complete example

; Number String Image -> Image
; adds s to img, y pixels from top, 10 pixels to the left
; given:
;  5 for y,
;  "hello" for s, and
;  (empty-scene 100 100) for img
; expected:
;  (place-image (text "hello" 10 "red") 10 5 ...)
;  (where ... is (empty-scene 100 100)
(define (add-image y s img)
  (place-image (text s 10 "red") 10 y img))
; a more in-depth complete example

; Exercise 34
; String -> String
; returns the first character from a non-empty string
; given "string", expect "s"
; given "hello", expect "h"
(define (string-first s) (substring s 0 1))
; passes all checks

; Exercise 35
; String -> String
; returns the last character from a non-empty string
; given "string", expect "g"
; given "hello", expect "o"
(define (string-last s)
  (substring
   s
   (- (string-length s) 1)
   (string-length s)))
; passes all checks

; Exercise 36
; Image -> Number
; returns the pixel count of an image
; given a 10x10 image, expect 100
; given a 50x500 image, expect 25000
(define (image-area i)
  (* (image-width i) (image-height i)))
; passes all checks

; Exercise 37
; String -> String
; returns all but the first character of a string
; given "string", expect "tring"
; given "hello", expect "ello"
(define (string-rest s) 
  (substring
   s
   1
   (string-length s)))
; passes all checks

; Exercise 38
; String -> String
; returns all but the last character of a string
; given "string", expect "strin"
; given "hello", expect "hell"
(define (string-remove-last s)
  (substring
   s
   0
   (- (string-length s) 1)))
; passes all checks

