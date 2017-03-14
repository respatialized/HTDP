;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname c1e12) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define one-posn (make-posn 8 6))

(define p (make-posn 31 26))

; computes the distance of ap to the origin
(define (distance-to-0 ap)
  (sqrt
   (+ (sqr (posn-x ap))
      (sqr (posn-y ap)))))

(check-expect (distance-to-0 (make-posn 0 5)) 5)
(check-expect (distance-to-0 (make-posn 7 0)) 7)
(check-expect (distance-to-0 (make-posn 3 4)) 5)
(check-expect (distance-to-0 (make-posn 5 12)) 13)
(check-expect (distance-to-0 (make-posn 8 6)) 10)

(distance-to-0 (make-posn 3 4))
(distance-to-0 (make-posn 6 8))
(+ (distance-to-0 (make-posn 5 12)) 10)
; Exercise 63: Pythagorean triples in your head

; posn -> Number
; calculates the Manhattan distance from the given posn
; to the origin
(check-expect (manhattan-distance (make-posn 3 4)) 7)
(check-expect (manhattan-distance (make-posn 0 5)) 5)
(check-expect (manhattan-distance (make-posn 5 12)) 17)

(define (manhattan-distance ap)
  (+ (posn-x ap) (posn-y ap)))
; Exercise 64: Taxicab geometry

(define-struct movie [title producer year])
(define mv (make-movie "a" "b" "c"))
(movie-title mv)
(movie-producer mv)
(movie-year mv)
(movie? mv)

(define-struct person [name hair eyes phone])
(define me (make-person "Andrew" "none" "blue" "buzzoff"))
(person-name me)
(person-hair me)
(person-eyes me)
(person-phone me)
(person? me)


(define-struct pet [name number])
(define meowz (make-pet "Meowzer" 1))
(pet-name meowz)
(pet-number meowz)
(pet? meowz)

(define-struct CD [artist title price])
(define ls (make-CD "GZA" "Liquid Swords" 14.99))
(CD-title ls)
(CD-artist ls)
(CD-price ls)
(CD? ls)

(define-struct sweater [material size producer])
(define fave (make-sweater "cotton" "med" "grana"))
(sweater-material fave)
(sweater-size fave)
(sweater-producer fave)
(sweater? fave)
; Exercises 65 & 66: introducing the syntax of define-struct

(define-struct ball [location velocity])
(make-ball 10 -3)
; by defining structures this way it exposes intent to the
; reader of the code

(define SPEED 3)
(define-struct balld [location direction])
(make-balld 10 "up")
(define falling (make-balld 20 "down"))
; Exercise 67: a struct to represent a ball based on its
; location and orientation, which uses a constant to represent
; speed

; we can use other structs to represent other attributes
(define-struct vel [deltax deltay])

(define ball1
  (make-ball (make-posn 30 40) (make-vel -10 5)))

(define-struct ballf [x y deltax deltay])
(define ball2
  (make-ballf 30 40 -10 5))
(check-expect (posn-x (ball-location ball1)) (ballf-x ball2))
; Exercise 68: flat representation of ball1 in ball2 

(define-struct centry [name home office cell])
(define-struct phone [area number])
(make-centry "Shriram Fisler"
             (make-phone 207 "363-2421")
             (make-phone 101 "776-1099")
             (make-phone 208 "112-9981"))
; nested data structures mirror the information's own
; structure

(vel-deltax (ball-velocity ball1))
; nested expressions to recover the data in the most
; usable form

(define ap (make-posn 7 0))

(define HEIGHT 200)
(define MIDDLE (quotient HEIGHT 2))
(define WIDTH 400)
(define CENTER (quotient WIDTH 2))
(define-struct game [left-player right-player ball])
(define game0
  (make-game MIDDLE MIDDLE (make-posn CENTER CENTER)))

(game-ball game0)
(posn? (game-ball game0))
(game-left-player game0)

; Exercise 71: Step-by-step interactions with structures