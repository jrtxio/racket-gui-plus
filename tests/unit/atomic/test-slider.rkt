#lang racket/gui

;; Slider Component Tests
;; Using Racket's rackunit test framework

(require rackunit
         racket/class
         racket/draw
         "../../../guix/atomic/slider.rkt"
         "../../../guix/style/config.rkt")

;; Create a simple test frame
(define test-frame
  (new frame% 
       [label "Slider Test Frame"]
       [width 400]
       [height 300]
       [style '(no-resize-border)]))

;; Show test frame
(send test-frame show #t)

;; Test suite
(define slider-tests
  (test-suite
   "modern-slider% Tests"
   
   ;; Test 1: Basic Creation and Properties
   (test-case "Basic Creation and Properties" 
     (define slider
       (new modern-slider% 
            [parent test-frame]
            [label "Test Slider"]
            [min-value 0]
            [max-value 100]
            [init-value 50]))
     
     (check-equal? (send slider get-min-value) 0 "Slider minimum value should be 0")
     (check-equal? (send slider get-max-value) 100 "Slider maximum value should be 100")
     (check-equal? (send slider get-value) 50 "Slider initial value should be 50")
     )
   
   ;; Test 2: Value Setting
   (test-case "Value Setting" 
     (define slider
       (new modern-slider% 
            [parent test-frame]
            [min-value 0]
            [max-value 100]
            [init-value 0]))
     
     (send slider set-value! 25)
     (check-equal? (send slider get-value) 25 "Slider value should be 25 after set-value! 25")
     
     (send slider set-value! 75)
     (check-equal? (send slider get-value) 75 "Slider value should be 75 after set-value! 75")
     
     ;; Test boundary values
     (send slider set-value! 0)
     (check-equal? (send slider get-value) 0 "Slider value should be 0 after set-value! 0")
     
     (send slider set-value! 100)
     (check-equal? (send slider get-value) 100 "Slider value should be 100 after set-value! 100")
     )
   
   ;; Test 3: Value Range
   (test-case "Value Range" 
     (define slider
       (new modern-slider% 
            [parent test-frame]
            [min-value 10]
            [max-value 50]
            [init-value 25]))
     
     (check-equal? (send slider get-min-value) 10 "Slider minimum value should be 10")
     (check-equal? (send slider get-max-value) 50 "Slider maximum value should be 50")
     
     ;; Test with different range
     (define slider2
       (new modern-slider% 
            [parent test-frame]
            [min-value -50]
            [max-value 50]
            [init-value 0]))
     
     (check-equal? (send slider2 get-min-value) -50 "Slider minimum value should be -50")
     (check-equal? (send slider2 get-max-value) 50 "Slider maximum value should be 50")
     )
   
   ;; Test 4: Callback Function
   (test-case "Callback Function" 
     (define callback-called #f)
     (define callback-slider #f)
     (define callback-value #f)
     
     (define slider
       (new modern-slider% 
            [parent test-frame]
            [min-value 0]
            [max-value 100]
            [init-value 0]
            [callback (λ (s event) 
                        (set! callback-called #t)
                        (set! callback-slider s)
                        (set! callback-value (send s get-value)))]))
     
     ;; Simulate slider change
     (send slider set-value! 50)
     ;; Note: The built-in slider% doesn't call callback when set-value! is called programmatically,
     ;; but it does when user interacts with it. We'll test the callback by calling it directly.
     (define dummy-event (make-object control-event% 'slider))
     (send slider callback slider dummy-event)
     
     (check-equal? callback-called #t "Callback should be called when slider value changes")
     (check-equal? callback-slider slider "Callback should receive the slider object")
     (check-equal? callback-value 50 "Callback should receive the correct slider value")
     )
   
   ;; Test 5: Theme Response
   (test-case "Theme Response" 
     (define slider
       (new modern-slider% 
            [parent test-frame]
            [min-value 0]
            [max-value 100]
            [init-value 50]))
     
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
(run-tests slider-tests)

;; Close test frame
(send test-frame show #f)