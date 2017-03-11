;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname c1e01) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
(define x 12)
(define y 5)

(define (distance x y a b) (sqrt (+ (sqr (- x a)) (sqr (- y b)))))

(define prefix "hello")
(define suffix "world")
(define (u_concat a b) (string-append a "_" b))

(define str "helloworld")
(define i 5)

(define (u_insert str pos) (string-append (string-append (substring str 0 i) "_") (substring str i)))
(define (char-del str pos) (string-append (substring str 0 (- pos 1)) (substring str pos)))

