#lang racket/gui

;; Switch Component Tests
;; Using Racket's rackunit test framework

(require rackunit
         racket/class
         racket/draw
         "../../../guix/atomic/switch.rkt"
         "../../../guix/style/config.rkt")

;; Create a simple test frame
(define test-frame
  (new frame% 
       [label "Switch Test Frame"]
       [width 400]
       [height 300]
       [style '(no-resize-border)]))

;; Show test frame

;; Test suite
(define switch-tests
  (test-suite
   "switch% Tests"
   
   ;; Test 1: Basic Creation and Properties
   (test-case "Basic Creation and Properties" 
     (define switch
       (new switch% 
            [parent test-frame]
            [label "Test Switch"]
            [checked? #f]))
     
     (check-equal? (send switch get-switch-label) "Test Switch" "Switch label should be 'Test Switch'")
     (check-equal? (send switch get-checked) #f "Switch should be unchecked by default")
     (check-equal? (send switch get-enabled-state) #t "Switch should be enabled by default")
     )
   
   ;; Test 2: Checked State
   (test-case "Checked State" 
     (define switch
       (new switch% 
            [parent test-frame]
            [label "Test Switch"]
            [checked? #f]))
     
     (send switch set-checked! #t)
     (check-equal? (send switch get-checked) #t "Switch should be checked after set-checked! #t")
     
     (send switch set-checked! #f)
     (check-equal? (send switch get-checked) #f "Switch should be unchecked after set-checked! #f")
     )
   
   ;; Test 3: Label Setting
   (test-case "Label Setting" 
     (define switch
       (new switch% 
            [parent test-frame]
            [label "Initial Label"]))
     
     (send switch set-switch-label! "New Label")
     (check-equal? (send switch get-switch-label) "New Label" "Switch label should be updated")
     )
   
   ;; Test 4: Enable/Disable State
   (test-case "Enable/Disable State" 
     (define switch
       (new switch% 
            [parent test-frame]
            [label "Test Switch"]))
     
     (send switch set-enabled! #f)
     (check-equal? (send switch get-enabled-state) #f "Switch should be disabled")
     (check-equal? (send switch get-enabled) #f "Switch should be disabled (using get-enabled)")
     
     (send switch set-enabled! #t)
     (check-equal? (send switch get-enabled-state) #t "Switch should be enabled")
     
     ;; Test API consistency with set-enabled
     (send switch set-enabled #f)
     (check-equal? (send switch get-enabled) #f "Switch should be disabled (using set-enabled)")
     )
   
   ;; Test 5: Callback Function
   (test-case "Callback Function" 
     (define callback-called #f)
     (define callback-switch #f)
     (define callback-state #f)
     
     (define switch
       (new switch% 
            [parent test-frame]
            [label "Test Switch"]
            [checked? #f]
            [callback (λ (s event) 
                        (set! callback-called #t)
                        (set! callback-switch s)
                        (set! callback-state (send s get-checked)))]))
     
     ;; Simulate switch toggle
     (define mouse-down-event (make-object mouse-event% 'left-down 20 12 0 0 '(left) 0 #f 0 0 0 #f))
     (define mouse-up-event (make-object mouse-event% 'left-up 20 12 0 0 '(left) 0 #f 0 0 0 #f))
     
     (send switch on-event mouse-down-event)
     (send switch on-event mouse-up-event)
     
     (check-equal? callback-called #t "Callback should be called when switch is toggled")
     (check-equal? callback-switch switch "Callback should receive the switch object")
     (check-equal? callback-state #t "Switch should be checked after toggle")
     )
   
   ;; Test 6: Theme Response
   (test-case "Theme Response" 
     (define switch
       (new switch% 
            [parent test-frame]
            [label "Test Switch"]
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
   
   ;; Test 7: Callback Setting
   (test-case "Callback Setting" 
     (define callback-called #f)
     
     (define switch
       (new switch% 
            [parent test-frame]
            [label "Test Switch"]))
     
     ;; Set callback after creation
     (send switch set-callback! (λ (s event) (set! callback-called #t)))
     
     ;; Simulate switch toggle
     (define mouse-down-event (make-object mouse-event% 'left-down 20 12 0 0 '(left) 0 #f 0 0 0 #f))
     (define mouse-up-event (make-object mouse-event% 'left-up 20 12 0 0 '(left) 0 #f 0 0 0 #f))
     
     (send switch on-event mouse-down-event)
     (send switch on-event mouse-up-event)
     
     (check-equal? callback-called #t "Callback set via set-callback! should be called")
     )
   ))

;; Run tests
(require rackunit/text-ui)
(run-tests switch-tests)

;; Close test frame
(send test-frame show #f)