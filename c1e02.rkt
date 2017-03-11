;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname c1e02) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
(require 2htdp/image)

; Exercise 11
(define (distance x y) (sqrt (+ (sqr x) (sqr y))))

; Exercise 12
(define (cvolume s) (expt s 3))
(define (csurface s) (* (expt s 2) 6))

; Exercise 13
(define (string-first str) (substring str 0 1))

; Exercise 14
(define (string-last str) (substring str (- (string-length str) 1)))

; Exercise 15
(define (==> sunny friday) (and (not sunny) friday))
(define S false)
(define F true)

; Exercise 16
(define (image-area i) (* (image-width i) (image-height i)))

; Exercise 17
(define (image-classify i) (cond
  [(= (image-width i) (image-height i)) "square"]
  [(> (image-width i) (image-height i)) "wide"]
  [(< (image-width i) (image-height i)) "tall"]))

; Exercise 18
(define (string-join a b) (string-append (string-append a "_") b))

; Exercise 19
(define (string-insert str i) (string-append (substring str 0 i) "_" (substring str i)))

; Exercise 20
(define (string-delete str i) (string-append (substring str 0 i) (substring str (+ i 1))))

; Exercise 21
(define (ff a) (* a 10))
;(ff (ff 1))
;(+ (ff 1) (ff 1))
; DrRacket appears to not reuse the evaluation of (ff 1) even though it appears twice

; Exercise 22
(define (distance-to-origin x y)
  (sqrt (+ (sqr x) (sqr y))))
;(distance-to-origin 3 4)

; Exercise 23
(define (string-first.v2 s)
  (substring s 0 1))
;(string-first "research")

; Exercise 24
(define (==>.v2 x y)
  (or (not x) y))
;(==>.v2 #true #false)

; Exercise 25
(define (image-classify.v2 img)
  (cond
    [(>= (image-height img) (image-width img))
     "tall"]
    [(= (image-height img) (image-width img))
     "square"]
    [(<= (image-height img) (image-width img))
     "wide"]))
;(image-classify.v2 (circle 3 "solid" "red"))

; Exercise 26
(define (string-insert.v2 s i)
  (string-append (substring s 0 i)
                 "_"
                 (substring s i)))
(string-insert.v2 "helloworld" 6)

