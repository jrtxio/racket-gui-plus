#lang racket/gui

;; Icon Component Tests
;; Using Racket's rackunit test framework

(require rackunit
         racket/class
         racket/draw
         "../../../guix/atomic/icon.rkt"
         "../../../guix/style/config.rkt")

;; Create a simple test frame
(define test-frame
  (new frame% 
       [label "Icon Test Frame"]
       [width 400]
       [height 300]
       [style '(no-resize-border)]))

;; Show test frame

;; Test suite
(define icon-tests
  (test-suite
   "icon% Tests"
   
   ;; Test 1: Basic Creation and Properties
   (test-case "Basic Creation and Properties" 
     (define icon
       (new icon% 
            [parent test-frame]
            [icon-name "plus"]
            [size 24]
            [color "red"]))
     
     (check-equal? (send icon get-icon-name) "plus" "Icon name should be 'plus'")
     (check-equal? (send icon get-icon-size) 24 "Icon size should be 24")
     (check-equal? (send icon get-color) "red" "Icon color should be 'red'")
     (check-equal? (send icon get-enabled-state) #t "Icon should be enabled by default")
     )
   
   ;; Test 2: Icon Name Change
   (test-case "Icon Name Change" 
     (define icon
       (new icon% 
            [parent test-frame]
            [icon-name "plus"]))
     
     (send icon set-icon-name! "minus")
     (check-equal? (send icon get-icon-name) "minus" "Icon name should be changed to 'minus'")
     
     (send icon set-icon-name! "close")
     (check-equal? (send icon get-icon-name) "close" "Icon name should be changed to 'close'")
     )
   
   ;; Test 3: Icon Size Change
   (test-case "Icon Size Change" 
     (define icon
       (new icon% 
            [parent test-frame]
            [icon-name "plus"]
            [size 24]))
     
     (send icon set-icon-size! 32)
     (check-equal? (send icon get-icon-size) 32 "Icon size should be changed to 32")
     (check-equal? (send icon min-width) 32 "Icon minimum width should be updated to 32")
     (check-equal? (send icon min-height) 32 "Icon minimum height should be updated to 32")
     )
   
   ;; Test 4: Icon Color Change
   (test-case "Icon Color Change" 
     (define icon
       (new icon% 
            [parent test-frame]
            [icon-name "plus"]
            [color "red"]))
     
     (send icon set-color! "blue")
     (check-equal? (send icon get-color) "blue" "Icon color should be changed to 'blue'")
     )
   
   ;; Test 5: Enable/Disable State
   (test-case "Enable/Disable State" 
     (define icon
       (new icon% 
            [parent test-frame]
            [icon-name "plus"]))
     
     (send icon set-enabled! #f)
     (check-equal? (send icon get-enabled-state) #f "Icon should be disabled")
     (check-equal? (send icon get-enabled) #f "Icon should be disabled (using get-enabled)")
     
     (send icon set-enabled! #t)
     (check-equal? (send icon get-enabled-state) #t "Icon should be enabled")
     
     ;; Test API consistency with set-enabled
     (send icon set-enabled #f)
     (check-equal? (send icon get-enabled) #f "Icon should be disabled (using set-enabled)")
     )
   
   ;; Test 6: Callback Function
   (test-case "Callback Function" 
     (define callback-called #f)
     (define callback-icon #f)
     (define callback-event #f)
     
     (define icon
       (new icon% 
            [parent test-frame]
            [icon-name "plus"]
            [callback (λ (i e) 
                        (set! callback-called #t)
                        (set! callback-icon i)
                        (set! callback-event e))]))
     
     ;; Simulate mouse events to trigger callback
     (define mouse-down-event (make-object mouse-event% 'left-down 0 0 0 0 '(left) 0 #f 0 0 0 #f))
     (define mouse-up-event (make-object mouse-event% 'left-up 0 0 0 0 '(left) 0 #f 0 0 0 #f))
     
     (send icon on-event mouse-down-event)
     (send icon on-event mouse-up-event)
     
     (check-equal? callback-called #t "Callback should be called when icon is clicked")
     (check-equal? callback-icon icon "Callback should receive the icon object")
     (check-true (is-a? callback-event mouse-event%) "Callback should receive a mouse event")
     )
   
   ;; Test 7: Theme Response
   (test-case "Theme Response" 
     (define icon
       (new icon% 
            [parent test-frame]
            [icon-name "plus"]
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
(run-tests icon-tests)

;; Close test frame
(send test-frame show #f)