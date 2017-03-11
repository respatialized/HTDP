;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname c1e03) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
(require 2htdp/batch-io)

; Letter program: overview of composition
(define (letter fst lst signature-name)
  (string-append
   (opening fst)
   "\n\n"
   (body fst lst)
   "\n\n"
   (closing signature-name)))

(define (opening fst)
  (string-append "Dear " fst ","))

(define (body fst lst)
  (string-append
   "We have discovered that all people with the" "\n"
   "last name " lst " have won our lottery. So, " "\n"
   fst ", " "hurry and pick up your prize."))

(define (closing signature-name)
  (string-append
   "Sincerely,"
   "\n\n"
   signature-name
   "\n"))

; Exercise 27 - Theater monopoly capitalism
(define BASE_GUESTS 120)
(define BASE_PRICE 5.0)
(define VAR_GUESTS 15)
(define PRICE_INTERVAL 0.1)
(define COST_FIXED 180)
(define COST_VAR 0.04)

(define (attendees ticket-price)
  (- BASE_GUESTS (* (- ticket-price BASE_PRICE) (/ VAR_GUESTS PRICE_INTERVAL))))

(define (revenue ticket-price)
  (* ticket-price (attendees ticket-price)))

(define (cost ticket-price)
  (+ COST_FIXED (* COST_VAR (attendees ticket-price))))

(define (profit ticket-price)
  (- (revenue ticket-price)
     (cost ticket-price)))

; Exercise 28
;(profit 2.9) optimal price - $2.90

(define (profit.v2 price)
  (- (* (+ 120
           (* (/ 15 0.1)
              (- 5.0 price)))
        price)
     (+ 180
        (* 0.04
           (+ 120
              (* (/ 15 0.1)
                 (- 5.0 price)))))))

;Exercise 29

(define COST_VAR2 1.50)

(define (cost.v2 ticket-price)
  (* (attendees ticket-price) COST_VAR2))

(define (profit.v3 ticket-price)
  (- (revenue ticket-price) (cost.v2 ticket-price)))


  