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

(check-expect (si-render fired1) s1)
(check-expect (si-render aim1)
              (tank-render (aim-tank aim1)
                           (ufo-render (aim-ufo aim1)
                                       BACKGROUND)))

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

; SIGS -> SIGS
; A function to update the game state by moving the ufo
; in the world
(define (si-move w)
  (cond
    [(fired? w)
     (make-fired
      (si-move-proper (fired-ufo w)
                      (randomize 0.5))
      (fired-tank w)
      (fired-missile w))]
    [(aim? w)
     (make-aim
      (si-move-proper (aim-ufo w)
                      (randomize 0.5))
      (aim-tank w))]))

; SIGS Number -> SIGS
; move all the objects in the game world (with randomness)
(define (si-move.v1.5 w)
  (si-move-proper.v1.5 w (randomize 0.5)))

(check-random (si-move.v1.5 aim1)
              (si-move-proper.v1.5 aim1
                                 (-
                                  (random
                                   (round (* UFO_WIDTH 0.5)))
                                  (/ (* UFO_WIDTH 0.5) 2))))
        
; SIGS Number -> SIGS
; move all the objects in the game world (predictably)
; by delta
(define (si-move-proper.v1.5 w delta)
  (cond
    [(aim? w)
     (make-aim
      (make-posn (+ (posn-x (aim-ufo w)) delta)
                 (+ (posn-y (aim-ufo w)) UFOSPEED))
      (make-tank (+ (tank-loc (aim-tank w))
                    (tank-vel (aim-tank w)))
                 (tank-vel (aim-tank w))))]
    [(fired? w)
     (make-fired
      (make-posn (+ (posn-x (fired-ufo w)) delta)
                 (+ (posn-y (fired-ufo w)) UFOSPEED))
      (make-tank (+ (tank-loc (fired-tank w))
                    (tank-vel (fired-tank w)))
                 (tank-vel (fired-tank w)))
      (make-posn (posn-x (fired-missile w))
                 (- (posn-y (fired-missile w))
                    MISSILESPEED)))]))

(check-expect (si-move-proper.v1.5 aim1 3)
              (make-aim
               (make-posn 23 12.5)
               (make-tank 25 -3)))


(check-expect (si-move-proper.v1.5 fired1 3)
              (make-fired
               (make-posn 23 12.5)
               (make-tank 25 -3)
               (make-posn 32 (- HEIGHT TANK_HEIGHT 16.25))))

     
; Number -> Number
; Generate a new random value within a multiple n
; of UFO_WIDTH
(define (randomize n)
  (- (random (round (* UFO_WIDTH n)))
        (/ (* UFO_WIDTH n) 2)))

(check-random (randomize 2.5)
              (- (random (round (* UFO_WIDTH 2.5)))
                 (/ (* UFO_WIDTH 2.5) 2)))

; UFO Number -> UFO
; move the space invader object predictably to delta
(define (si-move-proper u delta)
 (make-posn (+ delta (posn-x u)) (+ (posn-y u) UFOSPEED)))
; this is much better than using a SIGS

(check-expect (si-move-proper (make-posn 100 30) -13)
              (make-posn 87 32.5))

; to test random functions, wrap a deterministic function
; (which is testable) in a bigger function that adds the
; random element
; -- alternatively, keep track of the random seed during tests
; -- or use (check-random)

; Exercise 99: controlling randomness through function
; composition

; SIGS, KeyEvent -> SIGS
; A function to change the state of the game using a KeyEvent
; interpretation: "left" changes the direction of the tank to
; left, "right" changes the direction of the tank to right,
; "space" launches a missile if it hasn't been launched yet
(define (si-control w ke)
  (cond
    [(aim? w)
     (cond
       [(and (string=? "left" ke)
            (> (tank-vel (aim-tank w)) 0))
        (make-aim
         (make-posn (posn-x (aim-ufo w))
                    (posn-y (aim-ufo w)))
         (reverse-tank (aim-tank w)))]
       [(and (string=? "right" ke)
             (< (tank-vel (aim-tank w)) 0))
        (make-aim
         (make-posn (posn-x (aim-ufo w))
                    (posn-y (aim-ufo w)))
         (reverse-tank (aim-tank w)))]
       [(string=? ke " ")
        (make-fired
         (aim-ufo w)
         (aim-tank w)
         (make-posn (tank-loc (aim-tank w))
                    (- HEIGHT TANK_HEIGHT 10)))]
       [else
        (make-aim (aim-ufo w) (aim-tank w))])]
    [(fired? w)
     (cond
       [(and (string=? "left" ke)
            (> (tank-vel (fired-tank w)) 0))
        (make-fired
         (make-posn (posn-x (fired-ufo w))
                    (posn-y (fired-ufo w)))
         (reverse-tank (fired-tank w))
         (make-posn (posn-x (fired-missile w))
                    (posn-y (fired-missile w))))]
       [(and (string=? "right" ke)
             (< (tank-vel (fired-tank w)) 0))
        (make-fired
         (make-posn (posn-x (fired-ufo w))
                    (posn-y (fired-ufo w)))
         (reverse-tank (fired-tank w))
         (make-posn (posn-x (fired-missile w))
                    (posn-y (fired-missile w))))]
       [else
        (make-fired (fired-ufo w)
                    (fired-tank w)
                    (fired-missile w))])]))

(check-expect (si-control aim1 "right")
              (make-aim
               (make-posn 20 10)
               (make-tank 28 3)))

(check-expect (si-control aim1 "left")
              (make-aim
               (make-posn 20 10)
               (make-tank 28 -3)))

(check-expect (si-control aim2 "left")
              aim1)

(define aim2 (make-aim (make-posn 20 10)
                       (make-tank 28 3)))

(define fired4 (make-fired (make-posn 20 10)
                           (make-tank 28 -3)
                           (make-posn 28 (- HEIGHT
                                            TANK_HEIGHT
                                            10))))

(define fired5 (make-fired (make-posn 20 10)
                           (make-tank 28 3)
                           (make-posn 28 (- HEIGHT
                                            TANK_HEIGHT
                                            10))))


(check-expect (si-control aim1 " ") fired4)
(check-expect (si-control fired4 "right") fired5)
(check-expect (si-control fired5 "left") fired4)
(check-expect (si-control fired5 "up") fired5)


; Tank -> Tank
; A function to reverse the direction of a Tank
; interpretation: returns a Tank with its direction reversed
(define (reverse-tank t)
  (make-tank (tank-loc t)
             (* -1 (tank-vel t))))

(check-expect (reverse-tank (aim-tank aim1))
              (make-tank 28 3))

; UFO, Tank -> SIGS
; A function to create the game world given the initial
; states of a UFO and Tank.
(define (si-main iufo itank)
  (big-bang (make-aim iufo itank)
            (on-tick si-move.v1.5)
            (to-draw si-render)
            (on-key si-control)
            (stop-when si-game-over? si-render-final)))

; Exercise 100: a complete game

(define-struct sigs [ufo tank missile])
; A SIGS.v2 (short for SIGS version 2) is a structure:
; (make-sigs UFO Tank MissileOrNot)
; interpretation: represents the complete state of a
; space invader game

; A MissileOrNot is one of:
; - #false
; - Posn
; interpretation #false means the missile is in the tank;
; Posn says the missile is at that location

; MissileOrNot Image -> Image
; adds an image of missile m to scene s
(define (missile-render.v2 m s)
  (cond
    [(false? m) s]
    [(posn? m) (missile-render m s)]))

(check-expect (missile-render.v2 #false (tank-render
                                         (make-tank 28 -3)
                                         (ufo-render
                                          (make-posn 20 10)
                                          BACKGROUND)))
              (tank-render (make-tank 28 -3)
                           (ufo-render (make-posn 20 10)
                                       BACKGROUND)))

(check-expect (missile-render.v2
               (make-posn
                32
                (- HEIGHT TANK_HEIGHT 10))
               (tank-render (make-tank 28 -3)
                            (ufo-render
                             (make-posn 20 10) BACKGROUND)))
              (missile-render
               (make-posn
                32
                (- HEIGHT TANK_HEIGHT 10))
               (tank-render (make-tank 28 -3)
                            (ufo-render
                             (make-posn 20 10) BACKGROUND))))
; Exercise 101: Test cases for alternative data definitions

(define (si-main.v2 iufo itank)
  (big-bang (make-sigs iufo itank #false)
            (on-tick si-move.v2)
            (to-draw si-render.v2)
            (on-key si-control.v2)
            (check-with sigs?)
            (stop-when si-game-over?.v2 si-render-final)))

; Exercise 114: checking the space invader game
; to ensure data definitions are respected

; SIGS -> Image
; Returns an image based on the current locations of the
; ufo, tank, and missile
(define (si-render.v2 s)
  (tank-render
   (sigs-tank s)
   (ufo-render (sigs-ufo s)
               (missile-render.v2 (sigs-missile s)
                                  BACKGROUND))))

; SIGS, KeyEvent -> SIGS
; A function to change the state of the game using a KeyEvent
; interpretation: "left" changes the direction of the tank to
; left, "right" changes the direction of the tank to right,
; "space" launches a missile if it hasn't been launched yet
(define (si-control.v2 w ke)
  (cond
    [(boolean? (sigs-missile w))
     (cond
       [(and (string=? "left" ke)
            (> (tank-vel (sigs-tank w)) 0))
        (make-sigs
         (make-posn (posn-x (sigs-ufo w))
                    (posn-y (sigs-ufo w)))
         (reverse-tank (sigs-tank w))
         #false)]
       [(and (string=? "right" ke)
             (< (tank-vel (sigs-tank w)) 0))
        (make-sigs
         (make-posn (posn-x (sigs-ufo w))
                    (posn-y (sigs-ufo w)))
         (reverse-tank (sigs-tank w))
         #false)]
       [(string=? ke " ")
        (make-sigs
         (sigs-ufo w)
         (sigs-tank w)
         (make-posn (tank-loc (sigs-tank w))
                    (- HEIGHT TANK_HEIGHT 10)))]
       [else
        (make-sigs (sigs-ufo w) (sigs-tank w) #false)])]
    [(posn? (sigs-missile w))
     (cond
       [(and (string=? "left" ke)
            (> (tank-vel (sigs-tank w)) 0))
        (make-sigs
         (make-posn (posn-x (sigs-ufo w))
                    (posn-y (sigs-ufo w)))
         (reverse-tank (sigs-tank w))
         (make-posn (posn-x (sigs-missile w))
                    (posn-y (sigs-missile w))))]
       [(and (string=? "right" ke)
             (< (tank-vel (sigs-tank w)) 0))
        (make-sigs
         (make-posn (posn-x (sigs-ufo w))
                    (posn-y (sigs-ufo w)))
         (reverse-tank (sigs-tank w))
         (make-posn (posn-x (sigs-missile w))
                    (posn-y (sigs-missile w))))]
       [else
        (make-sigs (sigs-ufo w)
                   (sigs-tank w)
                   (sigs-missile w))])]))

(define sigs1 (make-sigs
               (make-posn 100 20)
               (make-tank 20 3)
               #false))

(define sigs2 (make-sigs
               (make-posn 100 20)
               (make-tank 20 3)
               (make-posn
                20 (- HEIGHT
                      TANK_HEIGHT
                      10))))

(define sigs3 (make-sigs
               (make-posn 100 20)
               (make-tank 20 -3)
               #false))

(define sigs4 (make-sigs
               (make-posn 100 20)
               (make-tank 20 -3)
               (make-posn
                20 (- HEIGHT
                      TANK_HEIGHT
                      10))))

(define s10 (tank-render
             (sigs-tank sigs1)
             (ufo-render (sigs-ufo sigs1)
                         (missile-render.v2
                          (sigs-missile sigs1)
                          BACKGROUND))))


(check-expect (si-control.v2 sigs1 "left") sigs3)
(check-expect (si-control.v2 sigs3 "right") sigs1)
(check-expect (si-control.v2 sigs1 "right") sigs1)
(check-expect (si-control.v2 sigs3 "left") sigs3)
(check-expect (si-control.v2 sigs1 " ") sigs2)
(check-expect (si-control.v2 sigs2 "left") sigs4)
(check-expect (si-control.v2 sigs2 "right") sigs2)
(check-expect (si-control.v2 sigs4 "right") sigs2)
(check-expect (si-control.v2 sigs4 "left") sigs4)

; SIGS Number -> SIGS
; move all the objects in the game world (with randomness)
(define (si-move.v2 w)
  (si-move-proper.v2 w (randomize 0.5)))

(check-random (si-move.v2 sigs1)
              (si-move-proper.v2 sigs1
                                 (-
                                  (random
                                   (round (* UFO_WIDTH 0.5)))
                                  (/ (* UFO_WIDTH 0.5) 2))))
        
; SIGS Number -> SIGS
; move all the objects in the game world (predictably)
; by delta
(define (si-move-proper.v2 w delta)
  (cond
    [(boolean? (sigs-missile w))
     (make-sigs
      (make-posn (+ (posn-x (sigs-ufo w)) delta)
                 (+ (posn-y (sigs-ufo w)) UFOSPEED))
      (make-tank (+ (tank-loc (sigs-tank w))
                    (tank-vel (sigs-tank w)))
                 (tank-vel (sigs-tank w)))
      #false)]
    [(posn? (sigs-missile w))
     (make-sigs
      (make-posn (+ (posn-x (sigs-ufo w)) delta)
                 (+ (posn-y (sigs-ufo w)) UFOSPEED))
      (make-tank (+ (tank-loc (sigs-tank w))
                    (tank-vel (sigs-tank w)))
                 (tank-vel (sigs-tank w)))
      (make-posn (posn-x (sigs-missile w))
                 (- (posn-y (sigs-missile w))
                    MISSILESPEED)))]))

(check-expect (si-move-proper.v2 sigs1 3)
              (make-sigs
               (make-posn 103 22.5)
               (make-tank 23 3)
               #false))


(check-expect (si-move-proper.v2 sigs2 3)
              (make-sigs
               (make-posn 103 22.5)
               (make-tank 23 3)
               (make-posn 20 (- HEIGHT TANK_HEIGHT 16.25))))

(check-expect (si-render.v2 sigs1) s10)

; SIGS -> boolean
; A function to check whether the game-ending conditions
; are met. Interpretation: stop the game if the UFO reaches
; the bottom of the screen or the missile hits the ufo
(define (si-game-over?.v2 si)
  (cond
    [(boolean? (sigs-missile si))
     (>= (posn-y (sigs-ufo si)) (image-height BACKGROUND))]
    [(posn? (sigs-missile si))
     (or
      (>= (posn-y (sigs-ufo si)) (image-height BACKGROUND))
      (and
       (<= (abs
            (- (posn-y (sigs-ufo si))
               (posn-y (sigs-missile si))))
           2)
       (<= (abs
            (- (posn-x (sigs-ufo si))
               (posn-x (sigs-missile si))))
           5)))]))

         

(check-expect (si-game-over?.v2 (make-sigs
                                 (make-posn 20 600)
                                 (make-tank 50 0)
                                 #false))
              #true)

(check-expect (si-game-over?.v2 (make-sigs
                                 (make-posn 20 100)
                                 (make-tank 50 0)
                                 (make-posn 21 98)))
              #true)

(check-expect (si-game-over?.v2 (make-sigs
                                 (make-posn 0 0)
                                 (make-tank 0 3)
                                 #false))
              #false)

(check-expect (si-game-over?.v2 (make-sigs
                                 (make-posn 20 700)
                                 (make-tank 50 0)
                                 (make-posn 21 98)))
              #true)

; Exercise 102: reformulating the game on the basis of a
; different data definition

