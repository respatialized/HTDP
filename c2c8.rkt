;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname c2c8) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define SOLARSYSTEM
  (cons "Pluto"
        (cons "Neptune"
              (cons "Uranus"
                    (cons "Saturn"
                          (cons "Jupiter"
                                (cons "Mars"
                                      (cons "Earth"
                                            (cons "Venus"
                                                  (cons "Mercury"
                                                        (cons "Sol" '())))))))))))

(define FOODITEMS
  (cons "Hamburger"
        (cons "Fries"
              (cons "Duck Wings"
                    (cons "Mochi"
                          (cons "Mints" '()))))))

(define MILLENIALCOLORS
  (cons "Rose Quartz"
        (cons "Serenity"
              (cons "Cream Gold"
                    (cons "Opal Blue"
                          (cons "Lavender Fog" '()))))))

; Exercise 129: the verbose specification of linked lists


(define FRIENDNAMES
  (cons "Zeerak"
        (cons "Kate"
              (cons "Marc"
                    (cons "Kristen"
                          (cons "Kelly" '()))))))
; Exercise 130: thinking about the CONSequences of a data definition


; A List-of-Booleans is one of either:
; - '()
; (cons Boolean List-of-Booleans)

; Exercise 131: recursion in a data definition for
; arbitrarily large data


; ConsOrEmpty -> Any
; extracts the left part of the given pair
(define (our-first a-list)
  (if (empty? a-list)
      (error 'our-first "...")
      (pair-left a-list)))

; ConsOrEmpty -> Any
; extracts the right part of the given pair
(define (our-rest a-list)
  (if (empty? a-list)
      (error 'our-rest "...")
      (pair-right a-list)))