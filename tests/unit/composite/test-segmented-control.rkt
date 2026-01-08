#lang racket/gui

;; Segmented Control Component Tests
;; Using Racket's rackunit test framework

(require rackunit
         racket/class
         racket/draw
         "../../../guix/composite/segmented-control.rkt"
         "../../../guix/style/config.rkt")

;; Create a simple test frame
(define test-frame
  (new frame% 
       [label "Segmented Control Test Frame"]
       [width 400]
       [height 300]
       [style '(no-resize-border)]))

;; Show test frame
(send test-frame show #t)

;; Test suite
(define segmented-control-tests
  (test-suite
   "segmented-control% Tests"
   
   ;; Test 1: Basic Creation and Properties
   (test-case "Basic Creation and Properties" 
     (define segments '("First" "Second" "Third"))
     (define segmented-control
       (new segmented-control% 
            [parent test-frame]
            [segments segments]
            [selected-index 0]))
     
     (check-equal? (send segmented-control get-selected-index) 0 "Segmented control should have initial selected index 0")
     )
   
   ;; Test 2: Selected Index Setting
   (test-case "Selected Index Setting" 
     (define segments '("First" "Second" "Third"))
     (define segmented-control
       (new segmented-control% 
            [parent test-frame]
            [segments segments]
            [selected-index 0]))
     
     (send segmented-control set-selected-index! 1)
     (check-equal? (send segmented-control get-selected-index) 1 "Segmented control should have selected index 1 after set-selected-index! 1")
     
     (send segmented-control set-selected-index! 2)
     (check-equal? (send segmented-control get-selected-index) 2 "Segmented control should have selected index 2 after set-selected-index! 2")
     )
   
   ;; Test 3: Segments Setting
   (test-case "Segments Setting" 
     (define initial-segments '("First" "Second" "Third"))
     (define new-segments '("A" "B" "C" "D"))
     (define segmented-control
       (new segmented-control% 
            [parent test-frame]
            [segments initial-segments]
            [selected-index 0]))
     
     (send segmented-control set-segments new-segments)
     ;; After setting new segments, selected index should be 0 by default
     (check-equal? (send segmented-control get-selected-index) 0 "Segmented control should have selected index 0 after setting new segments")
     )
   
   ;; Test 4: Callback Function
   (test-case "Callback Function" 
     (define callback-called #f)
     (define callback-index #f)
     (define segments '("First" "Second" "Third"))
     
     (define segmented-control
       (new segmented-control% 
            [parent test-frame]
            [segments segments]
            [selected-index 0]
            [callback (λ (idx) 
                        (set! callback-called #t)
                        (set! callback-index idx))]))
     
     ;; Simulate segment selection
     (send segmented-control set-selected-index! 1)
     
     (check-equal? callback-called #t "Callback should be called when segment is selected")
     (check-equal? callback-index 1 "Callback should receive the correct selected index 1")
     )
   
   ;; Test 5: Theme Response
   (test-case "Theme Response" 
     (define segments '("First" "Second" "Third"))
     (define segmented-control
       (new segmented-control% 
            [parent test-frame]
            [segments segments]))
     
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
(run-tests segmented-control-tests)

;; Close test frame
(send test-frame show #f)