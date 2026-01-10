#lang racket/gui

;; Text Area Component Tests
;; Using Racket's rackunit test framework

(require rackunit
         racket/class
         racket/draw
         "../../../guix/atomic/text-area.rkt"
         "../../../guix/style/config.rkt")

;; Create a simple test frame
(define test-frame
  (new frame% 
       [label "Text Area Test Frame"]
       [width 400]
       [height 300]
       [style '(no-resize-border)]))

;; Show test frame

;; Test suite
(define text-area-tests
  (test-suite
   "text-area% Tests"
   
   ;; Test 1: Basic Creation and Properties
   (test-case "Basic Creation and Properties" 
     (define text-area
       (new text-area% 
            [parent test-frame]
            [placeholder "Enter text"]
            [init-value "Initial Text"]))
     
     (check-equal? (send text-area get-text) "Initial Text" "Text area should have initial value 'Initial Text'")
     )
   
   ;; Test 2: Text Setting
   (test-case "Text Setting" 
     (define text-area
       (new text-area% 
            [parent test-frame]
            [placeholder "Enter text"]))
     
     (send text-area set-text "New Text")
     (check-equal? (send text-area get-text) "New Text" "Text area should be able to set text")
     
     (send text-area set-text "Multi\nLine\nText")
     (check-equal? (send text-area get-text) "Multi\nLine\nText" "Text area should support multi-line text")
     )
   
   ;; Test 3: Clear Function
   (test-case "Clear Function" 
     (define text-area
       (new text-area% 
            [parent test-frame]
            [init-value "Text to clear"]))
     
     (send text-area clear)
     (check-equal? (send text-area get-text) "" "Text area should be cleared after calling clear")
     )
   
   ;; Test 4: Theme Response
   (test-case "Theme Response" 
     (define text-area
       (new text-area% 
            [parent test-frame]))
     
     ;; Save current theme
     (define original-theme (current-theme))
     
     ;; Switch to dark theme
     (set-theme! 'dark)
     ;; Verify theme has switched
     (check-equal? (current-theme) dark-theme "Theme should be dark")
     
     ;; Switch back to light theme
     (set-theme! 'light)
     (check-equal? (current-theme) light-theme "Theme should be light")
     )
   
   ;; Test 5: Placeholder Behavior
   (test-case "Placeholder Behavior" 
     (define text-area
       (new text-area% 
            [parent test-frame]
            [placeholder "Enter text"]
            [init-value ""]))
     
     ;; When empty, should show placeholder
     (check-equal? (send text-area get-text) "" "Text area should be empty initially")
     
     ;; After setting text, placeholder should be hidden
     (send text-area set-text "Some text")
     (check-equal? (send text-area get-text) "Some text" "Text area should have text after set-text")
     
     ;; After clearing, placeholder should be visible again
     (send text-area clear)
     (check-equal? (send text-area get-text) "" "Text area should be empty after clear")
     )
   ))

;; Run tests
(require rackunit/text-ui)
(run-tests text-area-tests)

;; Close test frame
(send test-frame show #f)