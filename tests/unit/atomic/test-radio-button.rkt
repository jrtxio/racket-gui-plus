#lang racket/gui

;; Radio Button Component Tests
;; Using Racket's rackunit test framework

(require rackunit
         racket/class
         racket/draw
         "../../../guix/atomic/radio-button.rkt"
         "../../../guix/style/config.rkt")

;; Create a simple test frame
(define test-frame
  (new frame% 
       [label "Radio Button Test Frame"]
       [width 400]
       [height 300]
       [style '(no-resize-border)]))

;; Show test frame
(send test-frame show #t)

;; Test suite
(define radio-button-tests
  (test-suite
   "radio-button% Tests"
   
   ;; Test 1: Basic Creation and Properties
   (test-case "Basic Creation and Properties" 
     (define radio-button
       (new radio-button% 
            [parent test-frame]
            [label "Test Radio"]
            [checked? #f]))
     
     (check-equal? (send radio-button get-radio-label) "Test Radio" "Radio button label should be 'Test Radio'")
     (check-equal? (send radio-button get-checked) #f "Radio button should be unchecked by default")
     (check-equal? (send radio-button get-enabled-state) #t "Radio button should be enabled by default")
     )
   
   ;; Test 2: Checked State
   (test-case "Checked State" 
     (define radio-button
       (new radio-button% 
            [parent test-frame]
            [label "Test Radio"]
            [checked? #f]))
     
     (send radio-button set-checked! #t)
     (check-equal? (send radio-button get-checked) #t "Radio button should be checked after set-checked! #t")
     
     (send radio-button set-checked! #f)
     (check-equal? (send radio-button get-checked) #f "Radio button should be unchecked after set-checked! #f")
     )
   
   ;; Test 3: Label Setting
   (test-case "Label Setting" 
     (define radio-button
       (new radio-button% 
            [parent test-frame]
            [label "Initial Label"]))
     
     (send radio-button set-radio-label! "New Label")
     (check-equal? (send radio-button get-radio-label) "New Label" "Radio button label should be updated")
     )
   
   ;; Test 4: Enable/Disable State
   (test-case "Enable/Disable State" 
     (define radio-button
       (new radio-button% 
            [parent test-frame]
            [label "Test Radio"]))
     
     (send radio-button set-enabled! #f)
     (check-equal? (send radio-button get-enabled-state) #f "Radio button should be disabled")
     (check-equal? (send radio-button get-enabled) #f "Radio button should be disabled (using get-enabled)")
     
     (send radio-button set-enabled! #t)
     (check-equal? (send radio-button get-enabled-state) #t "Radio button should be enabled")
     
     ;; Test API consistency with set-enabled
     (send radio-button set-enabled #f)
     (check-equal? (send radio-button get-enabled) #f "Radio button should be disabled (using set-enabled)")
     )
   
   ;; Test 5: Callback Function
   (test-case "Callback Function" 
     (define callback-called #f)
     (define callback-radio #f)
     (define callback-event #f)
     
     (define radio-button
       (new radio-button% 
            [parent test-frame]
            [label "Test Radio"]
            [callback (λ (r e) 
                        (set! callback-called #t)
                        (set! callback-radio r)
                        (set! callback-event e))]))
     
     ;; Simulate mouse events to trigger callback
     (define mouse-down-event (make-object mouse-event% 'left-down 0 0 0 0 '(left) 0 #f 0 0 0 #f))
     (define mouse-up-event (make-object mouse-event% 'left-up 0 0 0 0 '(left) 0 #f 0 0 0 #f))
     
     (send radio-button on-event mouse-down-event)
     (send radio-button on-event mouse-up-event)
     
     (check-equal? callback-called #t "Callback should be called when radio button is clicked")
     (check-equal? callback-radio radio-button "Callback should receive the radio button object")
     (check-true (is-a? callback-event mouse-event%) "Callback should receive a mouse event")
     (check-equal? (send radio-button get-checked) #t "Radio button should be checked after clicking")
     )
   
   ;; Test 6: Theme Response
   (test-case "Theme Response" 
     (define radio-button
       (new radio-button% 
            [parent test-frame]
            [label "Test Radio"]
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
(run-tests radio-button-tests)

;; Close test frame
(send test-frame show #f)