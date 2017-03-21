;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname c1e13) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct entry [name phone email])
; An Entry is a structure:
; (make-entry String String String)
; interpretation a contact's name, phone#, and email

; A Ball-2d is a structure:
; (make-ball Posn Vel)
; interpretation a 2-dimensional position and velocity

; instead of specifying the interpretation of "position"
; arbitrarily when defining the Ball struct, we rely on
; previously defined data structures to keep things
; composable and consistent

(define-struct vel [deltax deltay])
; A Vel is a structure:
; (make-vel Number Number)
; interpretation (make-vel dx dy) means a velocity of
; dx pixels [per tick] along the horizontal and
; dy pixels [per tick] along the vertical direction

(define-struct phone# [area switch num])
; A Phone# is a structure:
; (make-phone Number Number Number)
; interpretation (make-phone area switch num) means a phone # with
; area for the area code,
; switch for the switch within that area code, and
; num for the number of that particular switch

; Exercise 72: domain knowledge as applied to the precise
; definition of a data type for a phone number

