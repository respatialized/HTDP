;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname c2c9) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; contains-flatt? and how-many have the exact same template when
; starting out because they both deal with the same fundamental data
; type: a linked list of strings. Thus the functions don't require
; selector expressions or corner cases and their cond expressions
; have the same number of clauses because they deal with a data
; definiton with only two possibilities: an empty list or a cons of
; a string with an empty list.

; Exercise 137: explaining function isomorphism by reference to a
; data definition

; A List-of-amounts is one of:
; - '()
; - (cons PositiveNumber List-of-amounts)

(define amount1 (cons 2 (cons 3 (cons 6 '()))))
(define amount2 (cons 81 (cons 52 (cons 95 (cons 67 '())))))

; aloa -> Number
(define (sum aloa)
  (cond
    [(empty? aloa) 0]
    [else
     (+ (first aloa) (sum (rest aloa)))]))

(check-expect (sum amount1) 11)
(check-expect (sum amount2) 295)

; Exercise 138: the first example of reducing a list to a single
; value

; A List-of-numbers is one of:
; -'()
; - (cons Number List-of-numbers)

; List-of-numbers -> Boolean
; a function to determine whether every element of a list is
; positive
(define (pos? lon)
  (cond
    [(empty? lon) #true]
    [else
     (and (< 0 (first lon)) (pos? (rest lon)))]))

(check-expect (pos? (cons 1 (cons 2 '()))) #true)
(check-expect (pos? (cons -1 '())) #false)

; List-of-numbers -> Number
(define (checked-sum lon)
  (cond
    [(pos? lon)
     (sum lon)]
    [else (error 'check-sum "failed because"
                 "list wasn't positive")]
    ))

(check-expect (checked-sum '()) 0)
(check-expect (checked-sum (cons 2 (cons 3 (cons 31 '())))) 36)
;(check-error (checked-sum (cons -1 '()))
;(error 'check-sum "failed because list wasn't positive"))

; Exercise 139: for each element in a List-of-numbers, sum computes
; the sum of all elements following the element in the list.

; A lob is either one of:
; '()
; (cons Boolean lob)

; lob -> Boolean
(define (all-true lob)
  (cond
    [(empty? lob) #true]
    [else
     (and (first lob) (all-true (rest lob)))]))

(check-expect (all-true '()) #true)
(check-expect (all-true (cons #false '())) #false)
(check-expect (all-true (cons #true (cons #true '()))) #true)

; lob -> Boolean
(define (one-true lob)
  (cond
    [(empty? lob) #false]
    [else
     (or (first lob) (one-true (rest lob)))]))

(check-expect (one-true '()) #false)
(check-expect (one-true (cons #true '())) #true)
(check-expect (one-true (cons #false (cons #true '()))) #true)
(check-expect (one-true (cons #false (cons #false '()))) #false)
(check-expect (one-true (cons #false '())) #false)
(check-expect (one-true (cons #true (cons #false '()))) #true)


; Exercise 140: an empty list has to take on a different value,
; depending on the role it plays in the program.

; List-of-string -> String
; concatenate all strings l into one long string

(check-expect (cat '()) "")
(check-expect (cat (cons "a" (cons "b" '()))) "ab")


(define (cat l)
  (cond
    [(empty? l) ""]
    [else (string-append (first l) (cat (rest l)))]))

(cat (cons "a" '()))

; Exercise 141: an empty list as an actually empty value


; An ImageOrFalse is one of:
; - Image
; - False