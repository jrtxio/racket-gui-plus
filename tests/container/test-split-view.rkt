#lang racket/gui

;; Split View Component Tests
;; Using Racket's rackunit test framework

(require rackunit
         racket/class
         racket/draw
         "../../guix/container/split-view.rkt"
         "../../guix/atomic/label.rkt"
         "../../guix/style/config.rkt")

;; Create a simple test frame
(define test-frame
  (new frame% 
       [label "Split View Test Frame"]
       [width 400]
       [height 300]
       [style '(no-resize-border)]))

;; Show test frame

;; Test suite
(define split-view-tests
  (test-suite
   "split-view% Tests"
   
   ;; Test 1: Basic Creation and Properties
   (test-case "Basic Creation and Properties" 
     (define split-view
       (new split-view% 
            [parent test-frame]
            [orientation 'horizontal]
            [size-ratio 0.5]))
     
     (check-true (is-a? split-view split-view%) "Should be an instance of split-view%")
     (check-equal? (send split-view get-size-ratio) 0.5 "Initial size ratio should be 0.5")
     )
   
   ;; Test 2: Panel Access
   (test-case "Panel Access" 
     (define split-view
       (new split-view% 
            [parent test-frame]))
     
     (define panel1 (send split-view get-first-panel))
     (define panel2 (send split-view get-second-panel))
     
     (check-true (is-a? panel1 panel%) "First panel should be an instance of panel%")
     (check-true (is-a? panel2 panel%) "Second panel should be an instance of panel%")
     )
   
   ;; Test 3: Adding Components to Panels
   (test-case "Adding Components to Panels" 
     (define split-view
       (new split-view% 
            [parent test-frame]))
     
     (define panel1 (send split-view get-first-panel))
     (define panel2 (send split-view get-second-panel))
     
     (define label1
       (new label% 
            [parent panel1]
            [label "Panel 1 Label"]))
     (define label2
       (new label% 
            [parent panel2]
            [label "Panel 2 Label"]))
     
     ;; 由于panel%没有get-children方法，我们通过检查组件的父对象来验证添加是否成功
     (check-equal? (send label1 get-parent) panel1 "Label 1's parent should be panel 1")
     (check-equal? (send label2 get-parent) panel2 "Label 2's parent should be panel 2")
     )
   
   ;; Test 4: Size Ratio Setting
   (test-case "Size Ratio Setting" 
     (define split-view
       (new split-view% 
            [parent test-frame]))
     
     (send split-view set-size-ratio 0.3)
     (check-equal? (send split-view get-size-ratio) 0.3 "Size ratio should be set to 0.3")
     
     (send split-view set-size-ratio 0.7)
     (check-equal? (send split-view get-size-ratio) 0.7 "Size ratio should be set to 0.7")
     
     ;; Test clamping
     (send split-view set-size-ratio -0.1) ; Should be clamped to 0.0
     (check-equal? (send split-view get-size-ratio) 0.0 "Size ratio should be clamped to 0.0")
     
     (send split-view set-size-ratio 1.1) ; Should be clamped to 1.0
     (check-equal? (send split-view get-size-ratio) 1.0 "Size ratio should be clamped to 1.0")
     )
   
   ;; Test 5: Vertical Orientation
   (test-case "Vertical Orientation" 
     (define split-view
       (new split-view% 
            [parent test-frame]
            [orientation 'vertical]
            [size-ratio 0.4]))
     
     (check-true (is-a? split-view split-view%) "Vertical split view should be an instance of split-view%")
     (check-equal? (send split-view get-size-ratio) 0.4 "Initial size ratio for vertical split view should be 0.4")
     )
   
   ;; Test 6: Theme Response
   (test-case "Theme Response" 
     (define split-view
       (new split-view% 
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
(run-tests split-view-tests)

;; Close test frame
(send test-frame show #f)