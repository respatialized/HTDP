;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname c1e20) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; A spdr is a Structure:
; (make-spdr NumLegs Number)
; with NumLegs legs remaining and taking up Number units of
; space
(define-struct spdr [legs space])
; A NumLegs is a Number between 0 and 8 (up to but not
; greater than) 
; interpretation the number of legs a Spider has left

; An Elephant is a Number:
; interpretation: an Elephant is represented solely by the
; number of units of space it takes up

; A boa is a Structure:
; (make-boa Number1 Number2)
; with Number1 units of length and Number2 units of girth
(define-struct boa [length girth])

; An armdlo is a Structure:
; (make-armdlo NumRidges Number)
; with NumRidges ridges on its back and taking up Number
; units of space
(define-struct armdlo [ridges space])

; A NumRidges is a Number between 2 and 6
; interpretation the number of ridges on an armadillo's back

; A ZooAnimal is one of:
; spdr
; Number (elephant)
; boa
; armdlo

; ZooAnimal, Number -> Boolean
; A function that compares the space taken up by a ZooAnimal
; to the volume of a given cage
(define (fits? am cg)
  (> cg (cond
          [(number? am) am]
          [(spdr? am) (spdr-space am)]
          [(boa? am) (* (boa-length am) (boa-girth am))]
          [(armdlo? am) (armdlo-space am)])))

(check-expect (fits? (make-boa 3 2) 8) #true)
(check-expect (fits? (make-spdr 8 3) 2) #false)
(check-expect (fits? 3 4) #true)
(check-expect (fits? (make-armdlo 5 18) 9) #false)

; Exercise 103: The animals!

; A Vehicle is one of:
; - truck
; - bus
; - van
; - suv
; - auto
; interpretation: all vehicles share the following properties:
; - pass (Number) - the number of passengers it can carry
; - tag (String) - the license plate number
; - mpg (Number) the number of miles/gallon it gets

; An auto is a Vehicle:
; (make-auto pass tag mpg)
; interpretation: a basic sedan-type car that can carry pass
; passengers, with a license plate of tag, and that gets mpg
; miles/gallon.
(define-struct auto [pass tag mpg])

; A suv is a Vehicle:
; (make-suv pass tag mpg freight)
; interpretation: a suv that can carry up to pass passengers,
; with a license plate of tag, that gets mpg miles/gallon,
; and can carry up to weight pounds of freight.
(define-struct suv [pass tag mpg weight])

; A van is a Vehicle:
; (make-van pass tag mpg freight)
; interpretation: a van that can carry up to pass passengers,
; with a license plate of tag, that gets mpg miles/gallon,
; and can carry up to weight pounds of freight.
(define-struct van [pass tag mpg weight])

; A truck is a Vehicle:
; (make-truck pass tag mpg freight)
; interpretation: a van that can carry up to pass passengers,
; with a license plate of tag, that gets mpg miles/gallon,
; and can carry up to weight pounds of freight.
(define-struct truck [pass tag mpg weight])


; A bus is a Vehicle:
; (make-bus pass tag mpg)
; interpretation: a bus that can carry up to pass passengers,
; with a license plate of tag, that gets mpg miles/gallon.
(define-struct bus [pass tag mpg])

; Vehicle -> EfficientOrNot
(define (freight-eff v)
  (cond
    [(bus? v) #false]
    [(auto? v) #false]
    [(van? v) (/ (van-weight v) (van-mpg v))]
    [(suv? v) (/ (suv-weight v) (suv-mpg v))]
    [(truck? v) (/ (truck-weight v) (truck-mpg v))]))

; An EfficientOrNot is one of:
; - Number
; #false
; interpretation: a data representation of the freight
; efficiency of a vehicle based on its mpg and weight
; capcity. for non-freight vehicles, it is simply #false.
; for load-bearing vehicles, it is a Number that is an
; efficiency coefficient

(check-expect (freight-eff (make-auto 4 "3CA" 25)) #false)
(check-expect (freight-eff (make-bus 41 "JJK10" 10)) #false)
(check-expect (freight-eff
               (make-truck 5 "EB7L1" 12.5 2500)) 200)
(check-expect (freight-eff
               (make-van 12 "97BR" 15 4200)) 280)
(check-expect (freight-eff
               (make-suv 7 "97BR" 12 1500)) 125)

; Exercise 104: storing attributes of vehicles

; A Coordinate is one of: 
; – a NegativeNumber 
; interpretation on the y axis, distance from top
; – a PositiveNumber 
; interpretation on the x axis, distance from left
; – a Posn
; interpretation an ordinary Cartesian point