;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname c1e14) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp")) #f)))
(define MTS (empty-scene 100 100))
(define DOT (circle 3 "solid" "red"))

; A Posn represents the state of the world.

; Posn -> Posn
(define (main p0)
  (big-bang p0
    [on-tick x+]
    [on-mouse reset-dot]
    [to-draw scene+dot]))

; Posn -> Image
; adds a red spot to MTS at p
(define (scene+dot p)
  (place-image DOT (posn-x p) (posn-y p) MTS))

(check-expect (scene+dot (make-posn 10 20))
              (place-image DOT 10 20 MTS))
(check-expect (scene+dot (make-posn 88 73))
              (place-image DOT 88 73 MTS))


; Posn -> Posn
; increases the x-coordinate of p by 3
(check-expect (x+ (make-posn 10 0)) (make-posn 13 0))
(define (x+ p)
  (posn-up-x p (+ (posn-x p) 3)))

; Posn, Number -> Posn
; sets the x value of the input posn to p
(check-expect (posn-up-x (make-posn 3 10) 9) (make-posn 9 10))
(define (posn-up-x p n)
  (make-posn n (posn-y p)))
; Exercise 73: posn-up-x: a very small working example of a
; updater / functional setter - it also makes x+ smaller

; Posn Number Number MouseEvt -> Posn
; for mouse clicks, (make-posn x y); otherwise p
(define (reset-dot p x y me)
  (cond
    [(mouse=? "button-down" me) (make-posn x y)]
    [else p]))


(check-expect (reset-dot (make-posn 10 20) 29 31 "button-down")
              (make-posn 29 31))
(check-expect (reset-dot (make-posn 31 48) 0 15 "button-up")
              (make-posn 31 48))
; these two differing tests indicate that the interpretation
; of mouse click is when the button is pressed, not released


; Exercise 74: a more functional program with event handlers
; due to structs and the composability they offer

(define-struct ufo [loc vel])
; A UFO is a structure:
; (make-ufo Posn Vel)
; interpretation (make-ufo p v) is at location
; p moving at velocity v.

(define-struct vel [deltax deltay])
; a vel is a structure:
; (make-vel deltax deltay)
; interpretation (make-vel x y) is going
; x units right and
; y units down

(define v1 (make-vel 8 -3))
(define v2 (make-vel -5 -3))

(define p1 (make-posn 22 80))
(define p2 (make-posn 30 77))

(define u1 (make-ufo p1 v1))
(define u2 (make-ufo p1 v2))
(define u3 (make-ufo p2 v1))
(define u4 (make-ufo p2 v2))

; UFO -> UFO
; determines where u moves in one clock tick;
; leaves the velocity as is
(check-expect (ufo-move-1 u1) u3)
(check-expect (ufo-move-1 u2)
              (make-ufo (make-posn 17 77) v2))
(define (ufo-move-1 u)
  (make-ufo (posn+ (ufo-loc u) (ufo-vel u))
            (ufo-vel u)))
; note that this implies a structure that could access
; the underlying values from the posn and vel values
; in the UFO struct. to simplify: a general rule:

; if a function deals with nested structures, develop
; one function per level of nesting.

; Posn Vel -> Posn
; adds v to p
(define (posn+ p v)
  (make-posn (+ (posn-x p) (vel-deltax v))
             (+ (posn-y p) (vel-deltay v))))
; aim for congruency between the number of values in a struct
; and the number of expressions in a function (where applicable)
; it makes data mapping easier and more comprehensible
(check-expect (posn+ p1 v1) p2)
(check-expect (posn+ p1 v2) (make-posn 17 77))
; using the same unit tests from the larger function
; definition helps reach the expected behavior more quickly





; when we define functions like:
; Posn Vel -> Posn
; adds v to p
; (define (posn+ p v) p)
; that just pass a 'dummy' of what is needed, we aid in
; making programs composable, because it's possible to
; build them into other functons we're trying to get to
; a solution for before the steps are fully figured out. This
; is called "making a wish." It also lets us run the program
; so the tests can fail without throwing any errors.

; Exercise 75: wish lists!

