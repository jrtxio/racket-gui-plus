#lang racket/gui

;; Automated tests for Side Panel component
;; Using Racket's rackunit testing framework

(require rackunit
         racket/class
         "../../guix/container/side-panel.rkt"
        "../../guix/style/config.rkt")

;; Create a simple test frame
(define test-frame
  (new frame%
       [label "Side Panel Test Frame"]
       [width 800]
       [height 600]
       [style '(no-resize-border)]))

;; Test suite
(define side-panel-tests
  (test-suite
   "side-panel% Tests"
   
   (test-case "Basic Creation and Properties" 
     (define side-panel
       (new side-panel%
            [parent test-frame]))
     
     ;; Verify initial properties
     (check-equal? (send side-panel get-side-panel-width) 240 "Default side panel width should be 240")
     (check-equal? (send side-panel get-min-width) 150 "Default min width should be 150")
     (check-equal? (send side-panel get-max-width) 500 "Default max width should be 500")
     )
   
   (test-case "Side Panel Width Control" 
     (define side-panel
       (new side-panel%
            [parent test-frame]
            [side-panel-width 300]))
     
     ;; Test getting width
     (check-equal? (send side-panel get-side-panel-width) 300 "Initial width should be 300")
     
     ;; Test setting width
     (send side-panel set-side-panel-width! 350)
     (check-equal? (send side-panel get-side-panel-width) 350 "Width should be set to 350")
     )
   
   (test-case "Minimum Width Constraint" 
     (define side-panel
       (new side-panel%
            [parent test-frame]
            [side-panel-width 200]
            [min-width 180]))
     
     ;; Test setting width smaller than minimum
     (send side-panel set-side-panel-width! 150)
     (check-equal? (send side-panel get-side-panel-width) 180 "Width should not be less than min width")
     
     ;; Test modifying minimum width
     (send side-panel set-min-width! 220)
     (check-equal? (send side-panel get-side-panel-width) 220 "Width should adjust to new min width")
     )
   
   (test-case "Maximum Width Constraint" 
     (define side-panel
       (new side-panel%
            [parent test-frame]
            [side-panel-width 400]
            [max-width 450]))
     
     ;; Test setting width larger than maximum
     (send side-panel set-side-panel-width! 500)
     (check-equal? (send side-panel get-side-panel-width) 450 "Width should not be more than max width")
     
     ;; Test modifying maximum width
     (send side-panel set-max-width! 380)
     (check-equal? (send side-panel get-side-panel-width) 380 "Width should adjust to new max width")
     )
   
   (test-case "Width Change Callback" 
     (define width-changed #f)
     (define new-width 0)
     
     (define side-panel
       (new side-panel%
            [parent test-frame]
            [on-width-change (λ (w) 
                               (set! width-changed #t)
                               (set! new-width w))]))
     
     ;; Trigger width change
     (send side-panel set-side-panel-width! 300)
     
     ;; Verify callback was called
     (check-true width-changed "Width change callback should be called")
     (check-equal? new-width 300 "Callback should receive new width")
     )
   
   (test-case "Theme Response" 
     (define side-panel
       (new side-panel%
            [parent test-frame]))
     
     ;; Save current theme
     (define original-theme (current-theme))
     
     ;; Switch to dark theme
     (set-theme! 'dark)
     ;; Verify theme switched
     (check-equal? (current-theme) dark-theme "Theme should be dark")
     
     ;; Switch back to light theme
     (set-theme! 'light)
     (check-equal? (current-theme) light-theme "Theme should be light")
     )
   
   (test-case "Panel Access" 
     (define side-panel
       (new side-panel%
            [parent test-frame]))
     
     ;; Verify access to side and content panels
     (check-not-false (send side-panel get-side-panel) "Should be able to get side panel")
     (check-not-false (send side-panel get-content-panel) "Should be able to get content panel")
     )
   ))

;; Run tests
(require rackunit/text-ui)
(run-tests side-panel-tests)

;; Close the test frame
(send test-frame show #f)
