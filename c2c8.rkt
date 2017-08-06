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