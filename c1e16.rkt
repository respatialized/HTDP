;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname c1e16) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct movie [title director year])

; Movie, String, Number -> Movie
; (def (remake oldmovie newdirector year))
; The function remake takes a movie, a director, and a remake
; year and returns a new Movie with the same title but an
; updated director and year

(define-struct person [name hair eyes phone])

; Person, Color -> Person
; (def (dye person color))
; The function dye takes a person and a color and returns a
; person with the same name, eye color, and phone number
; with an updated hair color

(define-struct pet [name number])

; Pet, Number -> Pet
; (def (adopt pet number))
; The function adopt takes a pet and a number and returns a
; new pet with the same name and an updated ID# reflecting
; its new ownership

(define-struct CD [artist title price])

; CD, Percentage -> CD
; (def (markdown CD pct))
; The function markdown takes a CD and a discount rate
; and returns a new CD with the same title and artist, with
; the price updated by 1 minus the markdown percentage

(define-struct sweater [material size color])

; Sweater -> Sweater
; (def (shrink sweater))
; The function shrink takes a sweater and returns a new
; sweater of the same material and color but one size smaller
; (requires an ordered SweaterSize enumeration)


; Exercise 80: function templates for structs

(define-struct time [hrs min sec])

(define (time->seconds t)
  (+ (time-sec t)
     (* (time-min t) 60)
     (* (time-hrs t) 3600)))
; Time -> Number
; the function takes a time t and converts that duration into
; seconds
(check-expect (time->seconds (make-time 1 0 0)) 3600)
(check-expect (time->seconds (make-time 12 30 2)) 45002)
; Exercise 81: converting between different representations
; of time

(define-struct word [l1 l2 l3])

(define (compare-word w1 w2)
  (make-word
   (cond
     [(string=? (word-l1 w1) (word-l1 w2)) (word-l1 w1)]
     [else #false])
   (cond
     [(string=? (word-l2 w1) (word-l2 w2)) (word-l2 w1)]
     [else #false])
   (cond
     [(string=? (word-l3 w1) (word-l3 w2)) (word-l3 w1)]
     [else #false])))
; Word, Word -> Word
; the function compare-word returns the letter-wise difference
; between two three letter strings w1 and w2
(check-expect (compare-word (make-word "b" "o" "w")
                            (make-word "w" "o" "w"))
              (make-word #false "o" "w"))
(check-expect (compare-word (make-word "m" "o" "w")
                            (make-word "m" "o" "p"))
              (make-word "m" "o" #false))
(check-expect (compare-word (make-word "b" "o" "p")
                            (make-word "b" "i" "p"))
              (make-word "b" #false "p"))
; Exercise 82: compare-word function


; A space-game is a Struct:
; (make-space-game Number Number)
; interpretation a Struct indicating the y-coordinate of the
; UFO in the game (as measured by the number of pixels from
; the top of the screen), and the x-coordinate of the tank
; in the game (as measured by the number of pixels from the
; right of the screen).
;(define-struct space-game [ufo tank])

; A SpaceGame is a structure:
; (make-space-game Posn Number).
; interpretation (make-space-game (make-posn ux uy) tx)
; describes a configuration where the UFO is at (ux, uy)
; and the tank's x-coordinate is tx

(define-struct editor [pre post])
; An Editor is a structure:
; (make-editor String String)
; interpretation (make-editor s t) describes an editor
; whose visible text is (string-append s t) with
; the cursor displayed between s and t

(define BACKG (empty-scene 200 20))
(define CURSOR (rectangle 1 20 "solid" "red"))

(define e-test (make-editor "blah " "bloo"))

; Editor -> Image
(define (render etext)
  (overlay/align
   "left"
   "center"
   (beside
    (text (editor-pre etext) 16 "black")
    CURSOR
    (text (editor-post etext) 16 "black"))
   BACKG))

(check-expect (render e-test) (overlay/align
                               "left"
                               "center"
                               (beside
                                (text "blah " 16 "black")
                                CURSOR
                                (text "bloo" 16 "black"))
                               BACKG))

; Exercise 83: rendering a simple text editor

; Editor, KeyEvent -> Editor
(define (edit ed stroke)
  (cond
    [(and (<= (image-width BACKG)
              (image-width (text
                            (string-append (editor-pre ed)
                                      (editor-post ed))
                            16
                            "black")))
          (not (string=? stroke "\b")))
     (make-editor (editor-pre ed) (editor-post ed))]
    [else
     (cond
       [(string=? stroke "\b")
        (make-editor
         (string-minus-one (editor-pre ed))
         (editor-post ed))]
       [(string=? stroke "left")
        (make-editor
         (string-minus-one (editor-pre ed))
         (string-append
          (string-last (editor-pre ed))
          (editor-post ed)))]
       [(string=? stroke "right")
        (make-editor
         (string-append
          (editor-pre ed)
          (string-first (editor-post ed)))
         (string-minus-first (editor-post ed)))]
       [(> (string-length stroke) 1)
        (make-editor
         (editor-pre ed)
         (editor-post ed))]
       [else
        (make-editor
         (string-append (editor-pre ed) stroke)
         (editor-post ed))])]))
; expects a KeyEvent stroke and an Editor ed, and returns an
; editor with the text before the cursor modified.

; A stroke is one of the following:
; an alphabetical character a-z
; a number 0-9
; one of the other special characters commonly found on a keyboard
; backspace "\b"
; the left arrow ("left")
; the right arrow ("right")

(define (string-first str)
  (cond
    [(> (string-length str) 0)
     (substring str 0 1)]
    [else str]))
(define (string-last str)
  (cond
    [(> (string-length str) 0)
     (substring str (- (string-length str) 1))]
    [else str]))
(define (string-minus-one str)
  (cond
   [(> (string-length str) 0)
    (substring str 0
               (- (string-length str) 1))]
   [else str]))
(define (string-minus-first str)
  (cond
    [(> (string-length str) 0)
     (substring str 1)]
    [else str]))
(check-expect (edit e-test "f") (make-editor "blah f" "bloo"))
(check-expect (edit e-test "1") (make-editor "blah 1" "bloo"))
(check-expect (edit e-test "#") (make-editor "blah #" "bloo"))
(check-expect (edit e-test "left") (make-editor "blah" " bloo"))
(check-expect (edit e-test "right") (make-editor "blah b" "loo"))
(check-expect (edit e-test "\b") (make-editor "blah" "bloo"))
(check-expect (edit e-test "down") (make-editor "blah " "bloo"))

(define etest2 (make-editor "" ""))
(define etest3 (make-editor "meeeeeeeeeeeeeeeeeeeeeeee" ""))

(check-expect (edit etest2 "left") (make-editor "" ""))
(check-expect (edit etest2 "right") (make-editor "" ""))
(check-expect (edit etest3 "\b") (make-editor "meeeeeeeeeeeeeeeeeeeeeee" ""))

; Exercise 84: the edit function, composed and recomposed
; using the principle of don't repeat yourself

; Exercise 86: checks to the length of the string reveal more
; issues to account for: left and right at the ends of strings

; String -> Editor
; Given a string s, creates a big-bang program with an internal
; state tracked by an editor created using s as the pre-cursor
; text
(define (run s)
  (big-bang (make-editor s "")
            (to-draw render)
            (on-key edit)))

; Exercise 85: uncovering new errors when using the interactive
; program for the first time
