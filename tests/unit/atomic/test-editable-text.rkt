#lang racket/gui

;; Editable Text Component Tests
;; Using Racket's rackunit test framework

(require rackunit
         racket/class
         racket/draw
         "../../../guix/atomic/editable-text.rkt"
         "../../../guix/style/config.rkt")

;; Create a simple test frame
(define test-frame
  (new frame% 
       [label "Editable Text Test Frame"]
       [width 400]
       [height 300]
       [style '(no-resize-border)]))

;; Show test frame

;; Test suite
(define editable-text-tests
  (test-suite
   "editable-text% Tests"
   
   ;; Test 1: Basic Creation and Properties
   (test-case "Basic Creation and Properties" 
     (define editable-text
       (new editable-text% 
            [parent test-frame]
            [placeholder "Enter text"]
            [init-value "Initial Text"]))
     
     (check-equal? (send editable-text get-text) "Initial Text" "Editable text should have initial value 'Initial Text'")
     )
   
   ;; Test 2: Text Setting
   (test-case "Text Setting" 
     (define editable-text
       (new editable-text% 
            [parent test-frame]
            [placeholder "Enter text"]))
     
     (send editable-text set-text "New Text")
     (check-equal? (send editable-text get-text) "New Text" "Editable text should be able to set text")
     )
   
   ;; Test 3: Callback Function
   (test-case "Callback Function" 
     (define callback-called #f)
     (define callback-text "")
     
     (define editable-text
       (new editable-text% 
            [parent test-frame]
            [placeholder "Enter text"]
            [callback (λ (t) 
                        (set! callback-called #t)
                        (set! callback-text (send t get-text)))]))
     
     ;; Set text and simulate lost focus to trigger callback
     (send editable-text set-text "Callback Test")
     ;; Simulate lost focus
     (send editable-text on-focus #f)
     
     (check-equal? callback-called #t "Callback should be called when focus is lost")
     (check-equal? callback-text "Callback Test" "Callback should receive the correct text")
     )
   
   ;; Test 4: Theme Response
   (test-case "Theme Response" 
     (define editable-text
       (new editable-text% 
            [parent test-frame]
            [placeholder "Enter text"]))
     
     ;; Save current theme
     (define original-theme (current-theme))
     
     ;; Switch to dark theme
     (set-theme! 'dark)
     ;; Verify theme has changed
     (check-equal? (current-theme) dark-theme "Theme should be dark")
     
     ;; Switch back to light theme
     (set-theme! 'light)
     (check-equal? (current-theme) light-theme "Theme should be light")
     )
   ))

;; Run tests
(require rackunit/text-ui)
(run-tests editable-text-tests)

;; Close test frame
(send test-frame show #f)