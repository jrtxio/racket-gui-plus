#lang racket/gui

;; Tab View Component Tests
;; Using Racket's rackunit test framework

(require rackunit
         racket/class
         racket/draw
         "../../../guix/container/tab-view.rkt"
         "../../../guix/atomic/label.rkt"
         "../../../guix/style/config.rkt")

;; Create a simple test frame
(define test-frame
  (new frame% 
       [label "Tab View Test Frame"]
       [width 400]
       [height 300]
       [style '(no-resize-border)]))

;; Show test frame

;; Test suite
(define tab-view-tests
  (test-suite
   "tab-view% Tests"
   
   ;; Test 1: Basic Creation and Properties
   (test-case "Basic Creation and Properties" 
     (define tab-view
       (new tab-view% 
            [parent test-frame]))
     
     (check-true (is-a? tab-view tab-view%) "Should be an instance of tab-view%")
     (check-equal? (send tab-view get-tab-count) 0 "Initial tab count should be 0")
     (check-equal? (send tab-view get-current-tab) 0 "Initial current tab index should be 0")
     )
   
   ;; Test 2: Adding Tabs
   (test-case "Adding Tabs" 
     (define tab-view
       (new tab-view% 
            [parent test-frame]))
     
     ;; Add tabs
     (define tab1-index (send tab-view add-tab "Tab 1" (λ () (void))))
     (define tab2-index (send tab-view add-tab "Tab 2" (λ () (void))))
     
     (check-equal? tab1-index 0 "First tab should have index 0")
     (check-equal? tab2-index 1 "Second tab should have index 1")
     (check-equal? (send tab-view get-tab-count) 2 "Tab count should be 2 after adding two tabs")
     )
   
   ;; Test 3: Tab Switching
   (test-case "Tab Switching" 
     (define tab-changed #f)
     (define tab-view
       (new tab-view% 
            [parent test-frame]))
     
     ;; Add tabs with callbacks
     (send tab-view add-tab "Tab 1" (λ () (set! tab-changed #t)))
     (send tab-view add-tab "Tab 2" (λ () (set! tab-changed #t)))
     
     (check-equal? (send tab-view get-current-tab) 0 "Current tab should be 0 initially")
     
     ;; Switch to tab 1
     (send tab-view set-current-tab! 1)
     (check-equal? (send tab-view get-current-tab) 1 "Current tab should be 1 after switching")
     (check-true tab-changed "Tab callback should be called when switching tabs")
     )
   
   ;; Test 4: Removing Tabs
   (test-case "Removing Tabs" 
     (define tab-view
       (new tab-view% 
            [parent test-frame]))
     
     ;; Add tabs
     (send tab-view add-tab "Tab 1" (λ () (void)))
     (send tab-view add-tab "Tab 2" (λ () (void)))
     (send tab-view add-tab "Tab 3" (λ () (void)))
     
     (check-equal? (send tab-view get-tab-count) 3 "Tab count should be 3 before removing")
     
     ;; Remove middle tab (index 1)
     (send tab-view remove-tab 1)
     
     (check-equal? (send tab-view get-tab-count) 2 "Tab count should be 2 after removing one tab")
     (check-equal? (send tab-view get-current-tab) 1 "Current tab should be adjusted after removing")
     )
   
   ;; Test 5: Theme Response
   (test-case "Theme Response" 
     (define tab-view
       (new tab-view% 
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
(run-tests tab-view-tests)

;; Close test frame
(send test-frame show #f)