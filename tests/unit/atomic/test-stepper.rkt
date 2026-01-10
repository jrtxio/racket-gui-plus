#lang racket/gui

;; Stepper Component Tests
;; Using Racket's rackunit test framework

(require rackunit
         racket/class
         racket/draw
         "../../../guix/atomic/stepper.rkt"
         "../../../guix/style/config.rkt")

;; Create a simple test frame
(define test-frame
  (new frame% 
       [label "Stepper Test Frame"]
       [width 400]
       [height 300]
       [style '(no-resize-border)]))

;; Show test frame

;; Test suite
(define stepper-tests
  (test-suite
   "stepper% Tests"
   
   ;; Test 1: Basic Creation and Properties
   (test-case "Basic Creation and Properties" 
     (define stepper
       (new stepper% 
            [parent test-frame]
            [value 5]
            [min-value 0]
            [max-value 10]
            [step 1]))
     
     (check-equal? (send stepper get-value) 5 "Stepper value should be 5")
     (check-equal? (send stepper get-min-value) 0 "Stepper minimum value should be 0")
     (check-equal? (send stepper get-max-value) 10 "Stepper maximum value should be 10")
     (check-equal? (send stepper get-step) 1 "Stepper step should be 1")
     (check-equal? (send stepper get-enabled-state) #t "Stepper should be enabled by default")
     )
   
   ;; Test 2: Value Setting
   (test-case "Value Setting" 
     (define stepper
       (new stepper% 
            [parent test-frame]))
     
     (send stepper set-value! 7)
     (check-equal? (send stepper get-value) 7 "Stepper value should be 7 after set-value! 7")
     
     (send stepper set-value! -3)
     (check-equal? (send stepper get-value) -3 "Stepper value should be -3 after set-value! -3")
     )
   
   ;; Test 3: Step Setting
   (test-case "Step Setting" 
     (define stepper
       (new stepper% 
            [parent test-frame]
            [value 0]
            [step 2]))
     
     ;; Test step increment
     (send stepper set-value! 0)
     (define dummy-event-down (make-object mouse-event% 'left-down 40 12 0 0 '(left) 0 #f 0 0 0 #f))
     (define dummy-event-up (make-object mouse-event% 'left-up 40 12 0 0 '(left) 0 #f 0 0 0 #f))
     
     (send stepper on-event dummy-event-down)
     (send stepper on-event dummy-event-up)
     
     (check-equal? (send stepper get-value) 2 "Stepper should increment by step value 2")
     
     ;; Change step
     (send stepper set-step! 3)
     (check-equal? (send stepper get-step) 3 "Stepper step should be 3 after set-step! 3")
     )
   
   ;; Test 4: Min/Max Value Constraints
   (test-case "Min/Max Value Constraints" 
     (define stepper
       (new stepper% 
            [parent test-frame]
            [value 5]
            [min-value 0]
            [max-value 10]
            [step 1]))
     
     ;; Test increment beyond max
     (send stepper set-value! 10)
     (define dummy-event-up (make-object mouse-event% 'left-up 40 12 0 0 '(left) 0 #f 0 0 0 #f))
     (define dummy-event-down (make-object mouse-event% 'left-down 40 12 0 0 '(left) 0 #f 0 0 0 #f))
     
     (send stepper on-event dummy-event-down)
     (send stepper on-event dummy-event-up)
     
     (check-equal? (send stepper get-value) 10 "Stepper should not exceed max value")
     
     ;; Test decrement below min
     (send stepper set-value! 0)
     (define dummy-event-down-left (make-object mouse-event% 'left-down 20 12 0 0 '(left) 0 #f 0 0 0 #f))
     (define dummy-event-up-left (make-object mouse-event% 'left-up 20 12 0 0 '(left) 0 #f 0 0 0 #f))
     
     (send stepper on-event dummy-event-down-left)
     (send stepper on-event dummy-event-up-left)
     
     (check-equal? (send stepper get-value) 0 "Stepper should not go below min value")
     )
   
   ;; Test 5: Enable/Disable State
   (test-case "Enable/Disable State" 
     (define stepper
       (new stepper% 
            [parent test-frame]
            [value 5]))
     
     (send stepper set-enabled! #f)
     (check-equal? (send stepper get-enabled-state) #f "Stepper should be disabled")
     
     (send stepper set-enabled! #t)
     (check-equal? (send stepper get-enabled-state) #t "Stepper should be enabled")
     )
   
   ;; Test 6: Callback Function
   (test-case "Callback Function" 
     (define callback-called #f)
     (define callback-stepper #f)
     (define callback-value #f)
     
     (define stepper
       (new stepper% 
            [parent test-frame]
            [value 0]
            [callback (λ (s v) 
                        (set! callback-called #t)
                        (set! callback-stepper s)
                        (set! callback-value v))]))
     
     ;; Simulate increment
     (send stepper set-value! 0)
     (define dummy-event-down (make-object mouse-event% 'left-down 40 12 0 0 '(left) 0 #f 0 0 0 #f))
     (define dummy-event-up (make-object mouse-event% 'left-up 40 12 0 0 '(left) 0 #f 0 0 0 #f))
     
     (send stepper on-event dummy-event-down)
     (send stepper on-event dummy-event-up)
     
     (check-equal? callback-called #t "Callback should be called when stepper is incremented")
     (check-equal? callback-stepper stepper "Callback should receive the stepper object")
     (check-equal? callback-value 1 "Callback should receive the new value 1")
     )
   
   ;; Test 7: Theme Response
   (test-case "Theme Response" 
     (define stepper
       (new stepper% 
            [parent test-frame]
            [theme-aware? #t]))
     
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
(run-tests stepper-tests)

;; Close test frame
(send test-frame show #f)