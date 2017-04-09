;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname c1e17) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct editor [text ix])
; An Editor is a structure:
;  (make-editor text ix)
; interpretation (make-editor "hello" 0) describes
; an Editor containing the text "hello" and the cursor
; all the way on the left side, before "h"

(define BACKG (empty-scene 200 20))
(define CURSOR (rectangle 1 20 "solid" "red"))

; Editor -> Image
; the function render creates an image from an editor struct
; by overlaying the cursor image over the editor's text at
; the editor's index
(define (render etext)
  (place-image
   CURSOR
   (get-ix etext) 10
   (overlay/align
    "left"
    "middle"
    (text (editor-text etext) 16 "black")
    BACKG)))



(define editor_blank (make-editor "" 0))
(define e1 (make-editor "e" 1))

(check-expect (render editor_blank)
              (place-image
               CURSOR
               0 10
               (overlay/align
                "left"
                "middle"
                (text "" 16 "black")
                BACKG)))
(check-expect (render e1)
              (place-image
               CURSOR
               (image-width
                (text
                 (substring (editor-text e1)
                            0
                            1)
                 16 "black"))
               10
               (overlay/align
                "left"
                "middle"
                (text "e" 16 "black")
                BACKG)))



; of note: an Image of blank text is distinct from no
; image at all.

; Editor -> Number
; returns the on-screen position of the cursor, given
; an editor
(define (get-ix etext)
  (cond
    [(= (string-length (editor-text etext)) 0) 0]
    [else
     (image-width
      (text
       (substring (editor-text etext)
                  0
                  (editor-ix etext))
       16 "black"))]))

(check-expect (get-ix editor_blank) 0)
(check-expect (get-ix e1) 9)

; Editor, KeyEvent -> Editor
; returns a new editor based on the different KeyEvents passed:
; left: move the cursor left one character
; right: move the cursor right one character
; backspace (\b): delete the character preceding the index
; any other single character: add the character after the index
(define (edit editor ke)
  (cond
    [(string=? ke "\b")
     (cond
       [(and
         (> (string-length (editor-text editor)) 0)
         (> (editor-ix editor) 0))
        (make-editor
         (string-append
          (substring (editor-text editor) 0
                     (- (editor-ix editor) 1))
          (cond
            [(= (string-length (editor-text editor))
                (editor-ix editor))
             ""]
            [else (substring (editor-text editor)
                             (editor-ix editor))]))
         (- (editor-ix editor) 1))]
       [else (make-editor (editor-text editor) 0)])]
     [(string=? ke "left")
      (make-editor
       (editor-text editor)
       (cond
         [(> (editor-ix editor) 0)
          (- (editor-ix editor) 1)]
         [else 0]))]
     [(string=? ke "right")
      (make-editor
       (editor-text editor)
       (cond
         [(< (editor-ix editor)
             (string-length (editor-text editor)))
          (+ (editor-ix editor) 1)]
         [else (editor-ix editor)]))]
     [else
      (cond
        [(= (string-length ke) 1)
         (make-editor
          (cond
            [(= (editor-ix editor) 0)
             (string-append ke (editor-text editor))]
            [(= (editor-ix editor)
                (string-length (editor-text editor)))
             (string-append (editor-text editor) ke)]
            [else
             (string-append
              (substring (editor-text editor)
                         0
                         (editor-ix editor))
              ke
              (substring (editor-text editor)
                         (editor-ix editor)))])
          (+ (editor-ix editor) 1))]
        [else (make-editor (editor-text editor)
                           (editor-ix editor))])]))

; the pre-post approach seems better for the current
; method of programming. text + index could accept an
; arbitrary index way beyond the end of the string, with
; nothing to enforce it except the expressions using the
; struct. with contracts, however, it might be different.
(check-expect (edit (make-editor "blah" 0) "\b")
              (make-editor "blah" 0))
(check-expect (edit (make-editor "blah" 4) "\b")
              (make-editor "bla" 3))
(check-expect (edit (make-editor "blah" 3) "\b")
              (make-editor "blh" 2))
(check-expect (edit (make-editor "bla" 3) "b")
              (make-editor "blab" 4))
(check-expect (edit (make-editor "blb" 2) "o")
              (make-editor "blob" 3))
(check-expect (edit (make-editor "lob" 0) "b")
              (make-editor "blob" 1))
(check-expect (edit (make-editor "blah" 4) "left")
              (make-editor "blah" 3))
(check-expect (edit (make-editor "blah" 4) "right")
              (make-editor "blah" 4))
(check-expect (edit (make-editor "blah" 0) "left")
              (make-editor "blah" 0))
(check-expect (edit (make-editor "blah" 0) "right")
              (make-editor "blah" 1))
(check-expect (edit (make-editor "blah" 0) "up")
              (make-editor "blah" 0))

(define (run text ix)
  (big-bang (make-editor text ix)
            (to-draw render)
            (on-key edit)))

; Exercise 87: another way to build an editor program.
; the first one felt more intuitive to build because
; the relationship between the two pieces of text defined
; the actions of edit and render in a way that seemed more
; direct than the arbitrary string + number combo. I think
; that's why it's preferable, actually - it's a tool for
; working with a string and nothing else, so it only accepts
; strings and defines everything else from there. the first
; method also allowed the previously built functions to
; compose the edit function. This exercise shows that it's
; important to force yourself to think of alternative
; representations of the data before getting started, because
; the "intuitive" way of string + index actually is harder
; to build and test.

; in general, this seems to be a virtue of Lisps - the way
; they encourage you to find a harmonious relationship
; between the data encoded by programs and the structure
; of the programs themselves.