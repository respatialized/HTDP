;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname c1e09) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define HEIGHT 300) ; distances in pixels
(define WIDTH 100)
(define YDELTA 3)
(define BACKG (empty-scene WIDTH HEIGHT))
(define ROCKET (rectangle 5 30 "solid" "red"))
(define CENTER (/ (image-height ROCKET) 2))


; A LRCD (for launching rocket count down) is one of:
; - "resting"
; - a Number between -3 and -1
; - a NonnegativeNumber
; - "gone"
; interpretation a grounded rocket, in count-down mode,
; a number denotes the number of pixels between the top
; of the canvas and the rocket (its height)
; "gone" indicates a rocket that has left the screen

; LRCD -> Image
; renders the state as a resting or flying rocket
(define (show x)
  (cond
    [(and (string? x) (string=? x "resting"))
     (rocket-place HEIGHT)]
    [(and (string? x) (string=? x "gone"))
     BACKG]
    [(<= -3 x -1)
     (place-image (text
                   (number->string x)
                   20 "red")
                   10 (* 3/4 WIDTH)
      (rocket-place HEIGHT))]
    [(>= x 0)
     (rocket-place x)]))
; Exercise 54: only the exactly right string for show       

; rocket-place: Number-> Image
; adjusts the y-position of the rocket to account for its size,
; then places it in the scene
(define (rocket-place y)
  (place-image ROCKET 10
  (- y CENTER) BACKG))
(check-expect (rocket-place 15)
              (place-image ROCKET 10
                           0 BACKG))
; Exercise 55: eliminating unecessary typing and removing
; control over superfluous variables for more concise code

(check-expect
 (show "resting")
 (place-image ROCKET 10 (- HEIGHT CENTER) BACKG))

(check-expect (show "gone") BACKG)

(check-expect
 (show -2)
 (place-image (text "-2" 20 "red")
              10 (* 3/4 WIDTH)
              (place-image ROCKET 10 (- HEIGHT CENTER) BACKG)))

(check-expect
 (show 53)
 (place-image ROCKET 10 (- 53 CENTER) BACKG))

(check-expect
 (show HEIGHT)
 (place-image ROCKET 10 (- HEIGHT CENTER) BACKG))

(check-expect
 (show 0)
 (place-image ROCKET 10 (- 0 CENTER) BACKG))

; LRCD KeyEvent -> LRCD
; starts the count-down when the space bar is pressed,
; if the rocket is still resting
(define (launch x ke)
  (cond
    [(string? x) (if (string=? " " ke) -3 x)]
    [(<= -3 x -1) x]
    [(>= x 0) x]))

(check-expect (launch "resting" " ") -3)
(check-expect (launch "resting" "a") "resting")
(check-expect (launch -3 " ") -3)
(check-expect (launch -1 " ") -1)
(check-expect (launch 33 " ") 33)
(check-expect (launch 33 "a") 33)

; passes all checks

; LRCD -> LRCD
; raises the rocket by YDELTA,
; if it is moving already
; also converts a height greater than the screen to "gone"
(check-expect (fly "resting") "resting")
(check-expect (fly -3) -2)
(check-expect (fly -2) -1)
(check-expect (fly -1) HEIGHT)
(check-expect (fly 10) (- 10 YDELTA))
(check-expect (fly 22) (- 22 YDELTA))
(check-expect (fly 0) "gone")

(define (fly x)
  (cond
    [(string? x) x]
    [(<= -3 x -1) (if (= x -1) HEIGHT (+ x 1))]
    [(> x 0) (- x YDELTA)]
    [(= x 0) "gone"]))
; passes all checks


; LRCD -> LRCD
(define (main1 s)
  (big-bang s
    [to-draw show]
    [on-key launch]))


; LRCD -> LRCD
(define (main2 s)
  (big-bang s
    [to-draw show]
    [on-key launch]
    [on-tick fly 0.1]
    [stop-when over]))

; LRCD -> Boolean
; checks to see if the rocket has left the screen
(check-expect (over 30) #false)
(check-expect (over "gone") #true)

(define (over h)
  (and (string? h) (string=? h "gone")))

; Exercise 56: changing the duration of the countdown
; by changing the frame drawing interval
; and adding a function to terminate the program when
; the rocket reaches the appointed height

; A LRCD2 (for launching rocket count down v2) is one of:
; - "resting"
; - a Number between -3 and -1
; - a NonnegativeNumber
; - "gone"
; interpretation "resting" is a grounded rocket, in count-down
; mode, a positive number denotes the number of pixels
; between the bottom of the canvas and the rocket (its height)
; "gone" indicates a rocket that has left the screen

; 
  
; Number -> Image
; places the rocket into the background according to the
; number passed to the function
(define (rocket-place.v2 y)
  (place-image
   ROCKET 10
   (- HEIGHT (+ y CENTER))
   BACKG))

(check-expect (rocket-place.v2 0)
  (place-image ROCKET 10
               (- HEIGHT CENTER)
               BACKG))
; passes checks

; LRCD2 -> LRCD2
; raises the rocket by YDELTA,
; if it is moving already
; also converts a height greater than the screen to "gone"
(check-expect (fly.v2 "resting") "resting")
(check-expect (fly.v2 -3) -2)
(check-expect (fly.v2 -2) -1)
(check-expect (fly.v2 -1) 0)
(check-expect (fly.v2 10) (+ 10 YDELTA))
(check-expect (fly.v2 22) (+ 22 YDELTA))
(check-expect (fly.v2 (+ 1 HEIGHT)) "gone")

(define (fly.v2 x)
  (cond
    [(string? x) x]
    [(<= -3 x -1) (if (= x -1) 0 (+ x 1))]
    [(>= HEIGHT x 0) (+ x YDELTA)]
    [(> x HEIGHT) "gone"]))
; passes all checks

; LRCD2 -> Image
; renders the state as a resting or flying rocket
(define (show.v2 x)
  (cond
    [(and (string? x) (string=? x "resting"))
     (rocket-place.v2 0)]
    [(and (string? x) (string=? x "gone"))
     BACKG]
    [(<= -3 x -1)
     (place-image (text
                   (number->string x)
                   20 "red")
                   10 (* 3/4 WIDTH)
      (rocket-place.v2 0))]
    [(>= x 0)
     (rocket-place.v2 x)]))

(check-expect
 (show.v2 "resting")
 (place-image ROCKET 10 (- HEIGHT CENTER) BACKG))

(check-expect (show "gone") BACKG)

(check-expect
 (show.v2 -2)
 (place-image (text "-2" 20 "red")
              10 (* 3/4 WIDTH)
              (place-image ROCKET 10 (- HEIGHT CENTER) BACKG)))

(check-expect
 (show.v2 53)
 (place-image ROCKET 10 (- HEIGHT (+ 53 CENTER)) BACKG))

(check-expect
 (show.v2 "gone") BACKG)

(check-expect
 (show.v2 0)
 (place-image ROCKET 10 (- HEIGHT CENTER) BACKG))


; LRCD -> LRCD
(define (main3 s)
  (big-bang s
    [to-draw show.v2]
    [on-key launch]
    [on-tick fly.v2 0.1]
    [stop-when over]))

; Exercise 57: the alternative interpretation of "height"
; more intuitive when visually inspecting the scene, but
; requires subtraction functions for it to play nicely with
; the way place-image works