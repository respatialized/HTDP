;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname c1e19) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define WIDTH 200)
(define HEIGHT 600)

(define TANKSPEED 1)
(define UFOSPEED 2.5)
(define MISSILESPEED (* UFOSPEED 2.5))

(define UFO_WIDTH 51)
(define UFO_HEIGHT (* UFO_WIDTH 0.235))
(define UFO_DISK (* UFO_WIDTH 0.1765))
(define UFO_COLOR "green")

(define UFO
  (overlay
   (rectangle UFO_WIDTH UFO_DISK "solid" UFO_COLOR)
   (circle UFO_HEIGHT "solid" UFO_COLOR)))

(define TANK_WIDTH 22)
(define TANK_BODY_HEIGHT (* TANK_WIDTH 0.45))
(define TANK_CANNON_WIDTH (* TANK_WIDTH 0.45))
(define TANK_CANNON_HEIGHT (* TANK_CANNON_WIDTH 0.3333))
(define TANK_MOUNT_SIZE (* TANK_WIDTH 0.27))
(define TANK_COLOR "gray")

(define TANK
  (above/align "left"
   (beside
    (rectangle TANK_CANNON_WIDTH TANK_CANNON_HEIGHT
               "solid" TANK_COLOR)
    (rectangle TANK_MOUNT_SIZE TANK_MOUNT_SIZE
               "solid" TANK_COLOR))
   (rectangle TANK_WIDTH TANK_BODY_HEIGHT
              "solid" TANK_COLOR)))
(define TANK_HEIGHT (image-height TANK))

(define BACKG
  (empty-scene WIDTH HEIGHT "blue"))



; Number -> Image
; Creates a cloud composed of three circles of given basesize.
(define (cloud basesize)
  (overlay/xy
   (circle basesize "solid" "white")
   (* -0.2 basesize) (* 0.3 basesize)
   (overlay/xy
    (circle basesize "solid" "white")
    (* 0.8 basesize) (* 0.2 basesize)
    (circle basesize "solid" "white"))))

(check-expect (cloud 10)
              (overlay/xy
               (circle 10 "solid" "white")
               -2 3
               (overlay/xy
                (circle 10 "solid" "white")
                8 2
                (circle 10 "solid" "white"))))

; Exercise 94: the UFO approaches

(define-struct aim [ufo tank])
(define-struct fired [ufo tank missile])

; A UFO is a Posn.
; interpretation (make-posn x y) is the UFO's location
; (using the top-down, left-to-right convention)

(define-struct tank [loc vel])
; A Tank is a structure:
; (make-tank Number Number)
; interpretation (make-tank x dx) specifies the position:
; (x, HEIGHT) and the tank's speed: dx pixels/tick

; A Missile is a Posn.
; interpretation (make-posn x y) is the missile's place

; A SIGS is one of:
; - (make-aim UFO Tank)
; - (make-fired UFO Tank Missile)
; interpretation represents the complete state of a space
; invader game

; Combining structs and itemizations to come up with a
; complete description of the game world

(define scene1 (make-aim (make-posn 20 10)
                         (make-tank 28 -3)))
(define scene2 (make-fired
                (make-posn 20 10)
                (make-tank 28 -3)
                (make-posn 28 (- HEIGHT TANK_HEIGHT))))
(define scene3 (make-fired
                (make-posn 20 100)
                (make-tank 100 3)
                (make-posn 22 103)))

 

; SIGS -> Image
; adds the TANK, UFO, and possibly MISSILE to the BACKG
; scene
(define (si-render s)
  (cond
    [(aim? s)
     (tank-render (aim-tank s)
                  (ufo-render (aim-ufo s) BACKG))]
    [(fired? s)
     (tank-render
      (fired-tank s)
      (ufo-render (fired-ufo s)
                  (missile-render (fired-missile s)
                                  BACKG)))]))

; Tank Image -> Image
; adds t to the given image im
(define (tank-render t im)
  (overlay/xy TANK
   (tank-loc t)
              (- HEIGHT TANK_HEIGHT) im))

(check-expect (tank-render (make-tank 27 -3)
                           (empty-scene WIDTH HEIGHT))
              (place-image TANK
                           27
                           (- HEIGHT TANK_HEIGHT)
                           (empty-scene WIDTH HEIGHT)))



; UFO Image -> Image
; adds u to the given image im
(define (ufo-render u im) im)

; Missile Image -> Image
(define (missile-render m im) im)
