;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname c1e10) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; A Price falls into one of three intervals:
; - 0 through 1000
; - 1000 through 10000
; - 10000 and above.
; interpretation the price of an item

; Price -> Number
; computes the amount of tax charged for p

(check-expect (sales-tax 537) 0)
(check-expect (sales-tax 1000) (* 0.05 1000))
(check-expect (sales-tax 12017) (* 0.08 12017))
(check-expect (sales-tax 10000) (* 0.08 10000))
(check-expect (sales-tax 0) 0)
(check-expect (sales-tax 1282) (* 0.05 1282))

(define (sales-tax p)
  (* p (cond
         [(and (<= 0 p) (< p MID-BRACKET)) 0.0]
         [(and (<= MID-BRACKET p) (< p HIGH-BRACKET)) MID-RATE]
         [(>= p HIGH-BRACKET) HIGH-RATE])))
; passes all checks

(define LOW-RATE 0)
(define MID-BRACKET 1000)
(define MID-RATE 0.05)
(define HIGH-BRACKET 10000)
(define HIGH-RATE 0.08)
; Exercise 58: constants for rates and brackets