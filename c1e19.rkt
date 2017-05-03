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
(define TANK_HEIGHT (+ TANK_BODY_HEIGHT TANK_CANNON_HEIGHT))

(define TANK
  (above/align "left"
   (beside
    (rectangle TANK_CANNON_WIDTH TANK_CANNON_HEIGHT
               "solid" TANK_COLOR)
    (rectangle TANK_MOUNT_SIZE TANK_MOUNT_SIZE
               "solid" TANK_COLOR))
   (rectangle TANK_WIDTH TANK_BODY_HEIGHT
              "solid" TANK_COLOR)))

(define MISSILE (triangle 7 "solid" "red"))

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

(define BACKGROUND
  (place-image
   (cloud 10) 30 40
   (place-image
    (cloud 13)
    90 120
    BACKG)))

; Exercise 94: the UFO approaches

; Representations for the two possible game states
(define-struct aim [ufo tank])
(define-struct fired [ufo tank missile])

; A UFO is a Posn.
; interpretation (make-posn x y) is the UFO's location
; (using the top-down, left-to-right convention)

(define-struct tank [loc vel])
; A Tank is a structure:
;   (make-tank Number Number)
; interpretation (make-tank x dx) specifies the position:
; (x, HEIGHT) and the tank's speed: dx pixels/tick

; A Missile is a Posn.
; interpretation (make-posn x y) is the missile's place

; A SIGS is one of:
; - (make-aim UFO Tank)
; - (make-fired UFO Tank Missile)
; interpretation: represents the complete state of a
; space invader game

; Tank maneuvering into position to fire the missile
(define aim1 (make-aim (make-posn 20 10) (make-tank 28 -3)))

; The tank, UFO, and missile just after firing
(define fired1
  (make-fired (make-posn 20 10)
              (make-tank 28 -3)
              (make-posn 32 (- HEIGHT TANK_HEIGHT 10))))

; The tank, UFO, and missile just before the UFO is hit
(define fired2 (make-fired (make-posn 20 100)
                           (make-tank 100 3)
                           (make-posn 22 103)))

; SIGS -> Image
; adds TANK, UFO, and possibly MISSILE to
; the BACKGROUND scene
(define (si-render s)
  (cond
    [(aim? s) (tank-render (aim-tank s)
                           (ufo-render (aim-ufo s) BACKGROUND))]
    [(fired? s)
     (tank-render
      (fired-tank s)
      (ufo-render (fired-ufo s)
                  (missile-render (fired-missile s)
                                  BACKGROUND)))]))
    
; using this conditional template and remembering selectors
; for each data structure contained in SIGS, it is easy to
; com up with a wishlist for functions

; Tank Image -> Image
; adds a Tank t to the given image im
(define (tank-render t im)
  (place-image TANK (tank-loc t) (- HEIGHT TANK_HEIGHT 1) im))

(check-expect (tank-render (make-tank 50 0) BACKGROUND)
              (place-image TANK 50 (- HEIGHT TANK_HEIGHT 1)
                           BACKGROUND))
                                      

; UFO Image -> Image
; adds u to the given image im
(define (ufo-render u im)
  (place-image UFO (posn-x u) (posn-y u) im))

(check-expect (ufo-render (make-posn 50 0) BACKGROUND)
              (place-image UFO 50 0 BACKGROUND))


; Missile Image -> Image
; adds a Missile m to the given image im
(define (missile-render m im)
  (place-image MISSILE (posn-x m) (posn-y m) im))

(check-expect (missile-render (make-posn 50 0) BACKGROUND)
              (place-image MISSILE 50 0 BACKGROUND))

(define s1 (tank-render
            (fired-tank fired1)
            (ufo-render (fired-ufo fired1)
             (missile-render (fired-missile fired1)
                             BACKGROUND))))

(define s2 (ufo-render
            (fired-ufo fired1)
            (tank-render
             (fired-tank fired1)
             (missile-render (fired-missile fired1)
                             BACKGROUND))))

(define s3 (tank-render
            (fired-tank fired2)
            (ufo-render (fired-ufo fired2)
             (missile-render (fired-missile fired2)
                             BACKGROUND))))

(define s4 (ufo-render
            (fired-ufo fired2)
            (tank-render
             (fired-tank fired2)
             (missile-render (fired-missile fired2)
                             BACKGROUND))))

(define fired3 (make-fired
                (make-posn 20 595)
                (make-tank 20 2)
                (make-posn 30 20)))

(define s5 (tank-render
            (fired-tank fired3)
            (ufo-render (fired-ufo fired3)
             (missile-render (fired-missile fired3)
                             BACKGROUND))))

(define s6 (ufo-render
            (fired-ufo fired3)
            (tank-render
             (fired-tank fired3)
             (missile-render (fired-missile fired3)
                             BACKGROUND))))

; Exercise 97: testing how different rendering orders affect
; equality testing of images. Intuitively, the (equal? )
; predicate returns #false for the two images when objects
; in the scene are drawn on top of one another

; SIGS -> boolean
; A function to check whether the game-ending conditions
; are met. Interpretation: stop the game if the UFO reaches
; the bottom of the screen or the missile hits the ufo
(define (si-game-over? si)
  (or
   (and (fired? si)
        (and (< (abs (- (posn-y (fired-missile si))
                     (posn-y (fired-ufo si))))
                (/ UFO_HEIGHT 2))
             (< (abs (- (posn-x (fired-missile si))
                        (posn-x (fired-ufo si))))
                (/ UFO_WIDTH 2))))
   (> (posn-y (cond [(fired? si) (fired-ufo si)]
                    [(aim? si) (aim-ufo si)]))
      (- HEIGHT (/ UFO_HEIGHT 2)))))

(check-expect (si-game-over? (make-aim
                              (make-posn 20 600)
                              (make-tank 50 0)))
              #true)

(check-expect (si-game-over? (make-fired
                              (make-posn 20 100)
                              (make-tank 50 0)
                              (make-posn 21 98)))
              #true)

(check-expect (si-game-over? (make-aim
                              (make-posn 0 0)
                              (make-tank 0 3)))
              #false)

(check-expect (si-game-over? (make-fired
                              (make-posn 20 700)
                              (make-tank 50 0)
                              (make-posn 21 98)))
              #true)


; SIGS -> Image
; A function to render the final state of the game world
; when it terminates.
(define (si-render-final si)
  (overlay/align "center" "center"
                 (text "game over!" 24 "black")              
                 BACKGROUND))

(check-expect (si-render-final fired1)
              (overlay/align "center" "center"
                             (text "game over!" 24 "black")
                             BACKGROUND))

; Exercise 98: determining when to bring the game to a close
; -- though unclear if si-render-final has the right structure