#lang racket/gui

;; Stack View Component Tests
;; Using Racket's rackunit test framework

(require rackunit
         racket/class
         racket/draw
         "../../../guix/container/stack-view.rkt"
         "../../../guix/atomic/label.rkt"
         "../../../guix/style/config.rkt")

;; Create a simple test frame
(define test-frame
  (new frame% 
       [label "Stack View Test Frame"]
       [width 400]
       [height 300]
       [style '(no-resize-border)]))

;; Show test frame
(send test-frame show #t)

;; Test suite
(define stack-view-tests
  (test-suite
   "stack-view% Tests"
   
   ;; Test 1: Basic Creation and Properties
   (test-case "Basic Creation and Properties" 
     (define stack-view
       (new stack-view% 
            [parent test-frame]))
     
     (check-true (is-a? stack-view stack-view%) "Should be an instance of stack-view%")
     (check-equal? (length (send stack-view get-views)) 0 "Initial view stack should be empty")
     )
   
   ;; Test 2: Adding Views
   (test-case "Adding Views" 
     (define stack-view
       (new stack-view% 
            [parent test-frame]))
     
     ;; Create some test panels with labels
     (define view1 (new panel% [parent stack-view] [style '()]))
     (new label% [parent view1] [label "View 1"] [alignment '(center center)])
     
     (define view2 (new panel% [parent stack-view] [style '()]))
     (new label% [parent view2] [label "View 2"] [alignment '(center center)])
     
     ;; Add views to stack-view
     (define index1 (send stack-view add-view view1))
     (define index2 (send stack-view add-view view2))
     
     (check-equal? index1 0 "First view should have index 0")
     (check-equal? index2 1 "Second view should have index 1")
     (check-equal? (length (send stack-view get-views)) 2 "Stack view should have 2 views after adding")
     )
   
   ;; Test 3: Switching Views
   (test-case "Switching Views" 
     (define stack-view
       (new stack-view% 
            [parent test-frame]))
     
     ;; Create some test panels with labels
     (define view1 (new panel% [parent stack-view] [style '()]))
     (new label% [parent view1] [label "View 1"] [alignment '(center center)])
     
     (define view2 (new panel% [parent stack-view] [style '()]))
     (new label% [parent view2] [label "View 2"] [alignment '(center center)])
     
     ;; Add views to stack-view
     (send stack-view add-view view1)
     (send stack-view add-view view2)
     
     ;; Switch to view 1 (index 0)
     (send stack-view switch-view 0)
     (check-equal? (send stack-view get-current-view-index) 0 "Current view index should be 0 after switching to view 0")
     (check-equal? (send stack-view get-current-view) view1 "Current view should be view1 after switching to view 0")
     
     ;; Switch to view 2 (index 1)
     (send stack-view switch-view 1)
     (check-equal? (send stack-view get-current-view-index) 1 "Current view index should be 1 after switching to view 1")
     (check-equal? (send stack-view get-current-view) view2 "Current view should be view2 after switching to view 1")
     )
   
   ;; Test 4: Next and Previous View
   (test-case "Next and Previous View" 
     (define stack-view
       (new stack-view% 
            [parent test-frame]))
     
     ;; Create some test panels with labels
     (define view1 (new panel% [parent stack-view] [style '()]))
     (new label% [parent view1] [label "View 1"] [alignment '(center center)])
     
     (define view2 (new panel% [parent stack-view] [style '()]))
     (new label% [parent view2] [label "View 2"] [alignment '(center center)])
     
     (define view3 (new panel% [parent stack-view] [style '()]))
     (new label% [parent view3] [label "View 3"] [alignment '(center center)])
     
     ;; Add views to stack-view
     (send stack-view add-view view1)
     (send stack-view add-view view2)
     (send stack-view add-view view3)
     
     ;; Start at view 0
     (send stack-view switch-view 0)
     (check-equal? (send stack-view get-current-view-index) 0 "Current view index should be 0 initially")
     
     ;; Go to next view (should be view 1)
     (send stack-view next-view)
     (check-equal? (send stack-view get-current-view-index) 1 "Current view index should be 1 after next-view from 0")
     
     ;; Go to next view (should be view 2)
     (send stack-view next-view)
     (check-equal? (send stack-view get-current-view-index) 2 "Current view index should be 2 after next-view from 1")
     
     ;; Go to next view (should wrap around to view 0)
     (send stack-view next-view)
     (check-equal? (send stack-view get-current-view-index) 0 "Current view index should wrap around to 0 after next-view from 2")
     
     ;; Go to previous view (should be view 2)
     (send stack-view prev-view)
     (check-equal? (send stack-view get-current-view-index) 2 "Current view index should be 2 after prev-view from 0")
     )
   
   ;; Test 5: Removing Views
   (test-case "Removing Views" 
     (define stack-view
       (new stack-view% 
            [parent test-frame]))
     
     ;; Create some test panels with labels
     (define view1 (new panel% [parent stack-view] [style '()]))
     (new label% [parent view1] [label "View 1"] [alignment '(center center)])
     
     (define view2 (new panel% [parent stack-view] [style '()]))
     (new label% [parent view2] [label "View 2"] [alignment '(center center)])
     
     (define view3 (new panel% [parent stack-view] [style '()]))
     (new label% [parent view3] [label "View 3"] [alignment '(center center)])
     
     ;; Add views to stack-view
     (send stack-view add-view view1)
     (send stack-view add-view view2)
     (send stack-view add-view view3)
     
     ;; Remove middle view (index 1)
     (send stack-view remove-view 1)
     
     (check-equal? (length (send stack-view get-views)) 2 "Stack view should have 2 views after removing one")
     (check-equal? (send stack-view get-current-view-index) 0 "Current view index should be 0 after removing middle view")
     )
   
   ;; Test 6: Clearing Views
   (test-case "Clearing Views" 
     (define stack-view
       (new stack-view% 
            [parent test-frame]))
     
     ;; Create some test panels
     (define view1 (new panel% [parent stack-view] [style '()]))
     (define view2 (new panel% [parent stack-view] [style '()]))
     
     ;; Add views to stack-view
     (send stack-view add-view view1)
     (send stack-view add-view view2)
     
     (check-equal? (length (send stack-view get-views)) 2 "Stack view should have 2 views before clear")
     
     ;; Clear all views
     (send stack-view clear-views)
     
     (check-equal? (length (send stack-view get-views)) 0 "Stack view should be empty after clear-views")
     )
   
   ;; Test 7: Theme Response
   (test-case "Theme Response" 
     (define stack-view
       (new stack-view% 
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
(run-tests stack-view-tests)

;; Close test frame
(send test-frame show #f)