;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname c2-supp) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; An alon is either one of:
; '()
; (cons number alon)

; alon, function -> alon
; takes a list of numbers and applies an arithmetic function to each,
; returning a new alon
(define (mymap func alon)
  (cond [(empty? alon)'()]
        [else
         (cons (func (first alon))
               (mymap func alon))]))

(check-expect (mymap (