#lang racket/gui

;; Automated tests for Category Card component
;; Using Racket's rackunit testing framework

(require rackunit
         racket/class
         racket/draw
         "../../guix/composite/category-card.rkt"
        "../../guix/style/config.rkt")

;; Create a simple test frame
(define test-frame
  (new frame%
       [label "Category Card Test Frame"]
       [width 400]
       [height 300]
       [style '(no-resize-border)]))

;; Test suite
(define category-card-tests
  (test-suite
   "category-card% Tests"
   
   (test-case "Basic Creation and Properties" 
     (define button
       (new category-card%
            [parent test-frame]
            [label "Test Category"]
            [count 5]
            [icon-symbol "🔍"]))
     
     ;; Verify control was created successfully
     (check-not-false button "Category card should be created successfully")
     )
   
   (test-case "Click Callback" 
     (define clicked #f)
     (define card
       (new category-card%
            [parent test-frame]
            [label "Test Category"]
            [count 5]
            [on-click (λ () (set! clicked #t))]))
     
     ;; Simulate mouse enter, down, and up events
     (define enter-event (make-object mouse-event% 'enter 0 0 0 0 '() 0 #f 0 0 0 #f))
     (define mouse-down-event (make-object mouse-event% 'left-down 0 0 0 0 '(left) 0 #f 0 0 0 #f))
     (define mouse-up-event (make-object mouse-event% 'left-up 0 0 0 0 '(left) 0 #f 0 0 0 #f))
     
     (send card handle-mouse-event enter-event) ; 先进入，设置 hover? 为 #t
     (send card handle-mouse-event mouse-down-event)
     (send card handle-mouse-event mouse-up-event)
     
     ;; Verify callback was called
     (check-equal? clicked #t "Callback should be called when card is clicked")
     )
   
   (test-case "Theme Response" 
     (define card
       (new category-card%
            [parent test-frame]
            [label "Test Category"]
            [count 5]))
     
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
   
   (test-case "Mouse State Changes" 
     (define card
       (new category-card%
            [parent test-frame]
            [label "Test Category"]
            [count 5]))
     
     ;; Simulate mouse enter event
     (define enter-event (make-object mouse-event% 'enter 0 0 0 0 '() 0 #f 0 0 0 #f))
     (send card on-event enter-event)
     
     ;; Simulate mouse leave event
     (define leave-event (make-object mouse-event% 'leave 0 0 0 0 '() 0 #f 0 0 0 #f))
     (send card on-event leave-event)
     
     ;; Verify control can handle mouse events
     (check-not-false card "Category card should handle mouse events")
     )
   )
)

;; Run tests
(require rackunit/text-ui)
(run-tests category-card-tests)

;; Close the test frame
(send test-frame show #f)