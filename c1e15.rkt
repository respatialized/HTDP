;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname c1e15) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct ball [location velocity])

(define ball1 (make-ball 30 0))
(define ball-string (make-ball "here" "there"))
(define ball-nested (make-ball ball1 (make-ball 12 81)))

; because this struct is just a way of composing two values
; with no restriction on the values passed, it can literally
; be a combination of any two instances of anything in the
; universe of data.

; Movie is (make-movie String String Number)
(define-struct movie [title producer year])
; Person is (make-person String String String Phone) 
(define-struct person [name hair eyes phone])
; Pet is (make-pet String Number)
(define-struct pet [name number])
; CD is (make-CD String String Number)
(define-struct CD [artist title price])
; Sweater is (make-sweater String String String)
(define-struct sweater [material size producer])

; Exercise 76: setting expectations for structure data types

; ToD (time of day) is (make-ToD Number Number Number) 
(define-struct ToD [hours mins secs])
; Exercise 77: splitting up the timestamp into primitives

; 3lw is (make-3lw Letter Letter Letter)
; interpretation: a Letter is a 1-character string of
; a-z, or #false
(define-struct 3lw [l1 l2 l3])
; Exercise 78: setting up an idea for a hangman game

; A Color is one of:
; - "white"
; - "yellow"
; - "orange"
; - "green"
; - "red"
; - "blue"
; - "black"
; Color is (make-color String)
; e.g. (make-color "red")

; H is a Number between 0 and 100.
; interpretation represents a "happiness value"
; e.g. 1, or 30, or 99

(define-struct person [fstname lstname male?])
; a Person is a structure:
; (make-person String String Boolean)
; e.g. (make-person "John" "Smith" #true)
; it's not a good idea to use a predicate-like field name.
; it will confuse another reader of the code and make them
; think there might be a function where a value belongs.

(define-struct dog [owner name age happiness])
; A Dog is a structure:
;  (make-dog Person String PositiveInteger H)
; interpretation a Dog belongs to Person
; owner, with String
; name, and a PositiveInteger
; age, and H
; happiness

; A Weapon is one of:
; - #false
; - Posn
; interpretation #false means the missile hasn't been
; fired yet; a Posn means it is in flight
; Weapon is (make-weapon value)
; e.g.(make-weapon value) or (make-weapon (make-posn 0 0))

; Exercise 79: adding examples to function definitons