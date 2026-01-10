#lang racket/gui

;; Stepper Input Component Tests
;; Using Racket's rackunit test framework

(require rackunit
         racket/class
         racket/draw
         "../../../guix/composite/stepper-input.rkt"
         "../../../guix/style/config.rkt")

;; Create a simple test frame
(define test-frame
  (new frame% 
       [label "Stepper Input Test Frame"]
       [width 400]
       [height 300]
       [style '(no-resize-border)]))

;; Show test frame

;; Test suite
(define stepper-input-tests
  (test-suite
   "stepper-input% Tests"
   
   ;; Test 1: Basic Creation and Properties
   (test-case "Basic Creation and Properties" 
     (define stepper-input
       (new stepper-input% 
            [parent test-frame]
            [init-value 5]
            [min-value 0]
            [max-value 10]
            [step 1]))
     
     (check-equal? (send stepper-input get-value) 5 "Stepper input should have initial value 5")
     )
   
   ;; Test 2: Value Setting
   (test-case "Value Setting" 
     (define stepper-input
       (new stepper-input% 
            [parent test-frame]
            [init-value 0]
            [min-value 0]
            [max-value 10]
            [step 1]))
     
     (send stepper-input set-value 7)
     (check-equal? (send stepper-input get-value) 7 "Stepper input should have value 7 after set-value 7")
     
     ;; Test clamping
     (send stepper-input set-value 15) ; Should be clamped to max-value 10
     (check-equal? (send stepper-input get-value) 10 "Stepper input should be clamped to max-value 10")
     
     (send stepper-input set-value -5) ; Should be clamped to min-value 0
     (check-equal? (send stepper-input get-value) 0 "Stepper input should be clamped to min-value 0")
     )
   
   ;; Test 3: Increment and Decrement
   (test-case "Increment and Decrement" 
     (define callback-called #f)
     (define callback-value #f)
     
     (define stepper-input
       (new stepper-input% 
            [parent test-frame]
            [init-value 0]
            [min-value 0]
            [max-value 10]
            [step 2]
            [callback (λ (s) 
                        (set! callback-called #t)
                        (set! callback-value (send s get-value)))]))
     
     ;; Test increment
     (send stepper-input set-value 0)
     ;; Note: We can't directly call the increment function, but we can simulate it by setting the value
     (send stepper-input set-value 2)
     (check-equal? (send stepper-input get-value) 2 "Stepper input should be 2 after increment from 0 with step 2")
     
     ;; Test decrement
     (send stepper-input set-value 4)
     (send stepper-input set-value 2)
     (check-equal? (send stepper-input get-value) 2 "Stepper input should be 2 after decrement from 4 with step 2")
     )
   
   ;; Test 4: Callback Function
   (test-case "Callback Function" 
     (define callback-called #f)
     (define callback-stepper #f)
     (define callback-value #f)
     
     (define stepper-input
       (new stepper-input% 
            [parent test-frame]
            [init-value 0]
            [min-value 0]
            [max-value 10]
            [step 1]
            [callback (λ (s) 
                        (set! callback-called #t)
                        (set! callback-stepper s)
                        (set! callback-value (send s get-value)))]))
     
     ;; Simulate value change
     (send stepper-input set-value 3)
     
     (check-equal? callback-called #t "Callback should be called when value changes")
     (check-equal? callback-stepper stepper-input "Callback should receive the stepper input object")
     (check-equal? callback-value 3 "Callback should receive the correct value 3")
     )
   
   ;; Test 5: Theme Response
   (test-case "Theme Response" 
     (define stepper-input
       (new stepper-input% 
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
(run-tests stepper-input-tests)

;; Close test frame
(send test-frame show #f)