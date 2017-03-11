;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname c1e04) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; For every constant mentioned in a problem statement,
; introduce one constant definition.

; Exercise 30

(define BASE_GUESTS 120)
(define BASE_PRICE 5.0)
(define PRICE_INTERVAL 0.1)
(define VAR_GUESTS (* PRICE_INTERVAL BASE_GUESTS 1.25))
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

; Reading and writing files
(write-file "sample.dat" "212")
(read-file "sample.dat")

(define (C f)
  (* 5/9 (- f 32)))

(define (convert in out)
  (write-file out
    (string-append
     (number->string
      (C
       (string->number
        (read-file in))))
     "\n")))

(convert "sample.dat" "out.dat")

; Exercise 31
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

(define (main in-fst in-lst in-signature out)
  (write-file out
              (letter (read-file in-fst)
                      (read-file in-lst)
                      (read-file in-signature))))

; Exercise 32

; 1. Cardiac arrest
; 2. Car acceleration
; 3. Weather changes
; 4. Extreme temperatures
; 5. Abnormal brain patterns
; 6. Intoxication
; 7. Changes in breathing patterns
; 8. Seeing your dog or other previously encountered animal
; 9. Ovulation cycles
; 10. Viral and bacterial infections

(define (number->square s)
  (square s "solid" "red"))

(define (reset s ke) 100)

;(me-h (tock (ke-h cw0 "a")) "button-down" 90 100)

(define BACKGROUND (empty-scene 100 100))
(define DOT (circle 3 "solid" "red"))

(define (main.v2 y)
  (big-bang y
            [on-tick sub1]
            [stop-when zero?]
            [to-draw place-dot-at]
            [on-key stop]))

(define (place-dot-at y)
  (place-image DOT 50 y BACKGROUND))

(define (stop y ke)
  0)