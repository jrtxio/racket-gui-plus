#lang racket/gui

;; Input Field Component Tests
;; Using Racket's rackunit test framework

(require rackunit
         racket/class
         racket/draw
         "../../../guix/composite/input-field.rkt"
         "../../../guix/style/config.rkt")

;; Create a simple test frame
(define test-frame
  (new frame% 
       [label "Input Field Test Frame"]
       [width 400]
       [height 300]
       [style '(no-resize-border)]))

;; Show test frame

;; Test suite
(define input-field-tests
  (test-suite
   "input-field% Tests"
   
   ;; Test 1: Basic Creation and Properties
   (test-case "Basic Creation and Properties" 
     (define input-field
       (new input-field% 
            [parent test-frame]
            [placeholder "Enter text"]
            [init-value "Initial Text"]))
     
     (check-equal? (send input-field get-text) "Initial Text" "Input field should have initial value 'Initial Text'")
     (check-equal? (send input-field get-validation-state) 'normal "Input field should have normal validation state by default")
     )
   
   ;; Test 2: Text Setting
   (test-case "Text Setting" 
     (define input-field
       (new input-field% 
            [parent test-frame]
            [placeholder "Enter text"]))
     
     (send input-field set-text "New Text")
     (check-equal? (send input-field get-text) "New Text" "Input field should be able to set text")
     )
   
   ;; Test 3: Clear Function
   (test-case "Clear Function" 
     (define input-field
       (new input-field% 
            [parent test-frame]
            [init-value "Text to clear"]))
     
     (send input-field clear)
     (check-equal? (send input-field get-text) "" "Input field should be cleared after calling clear")
     )
   
   ;; Test 4: Validation State
   (test-case "Validation State" 
     (define input-field
       (new input-field% 
            [parent test-frame]))
     
     (send input-field set-validation-state 'error)
     (check-equal? (send input-field get-validation-state) 'error "Input field should have error validation state")
     
     (send input-field set-validation-state 'warning)
     (check-equal? (send input-field get-validation-state) 'warning "Input field should have warning validation state")
     
     (send input-field set-validation-state 'normal)
     (check-equal? (send input-field get-validation-state) 'normal "Input field should have normal validation state")
     )
   
   ;; Test 5: Theme Response
   (test-case "Theme Response" 
     (define input-field
       (new input-field% 
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
   ))

;; Run tests
(require rackunit/text-ui)
(run-tests input-field-tests)

;; Close test frame
(send test-frame show #f)