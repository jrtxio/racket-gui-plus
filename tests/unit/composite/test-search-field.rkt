#lang racket/gui

;; Search Field Component Tests
;; Using Racket's rackunit test framework

(require rackunit
         racket/class
         racket/draw
         "../../../guix/composite/search-field.rkt"
         "../../../guix/style/config.rkt")

;; Create a simple test frame
(define test-frame
  (new frame% 
       [label "Search Field Test Frame"]
       [width 400]
       [height 300]
       [style '(no-resize-border)]))

;; Show test frame
(send test-frame show #t)

;; Test suite
(define search-field-tests
  (test-suite
   "search-field% Tests"
   
   ;; Test 1: Basic Creation and Properties
   (test-case "Basic Creation and Properties" 
     (define search-field
       (new search-field% 
            [parent test-frame]
            [placeholder "Search..."]
            [init-value "Initial Search"]))
     
     (check-equal? (send search-field get-text) "Initial Search" "Search field should have initial value 'Initial Search'")
     )
   
   ;; Test 2: Text Setting
   (test-case "Text Setting" 
     (define search-field
       (new search-field% 
            [parent test-frame]
            [placeholder "Search..."]))
     
     (send search-field set-text "New Search")
     (check-equal? (send search-field get-text) "New Search" "Search field should be able to set text")
     )
   
   ;; Test 3: Clear Function
   (test-case "Clear Function" 
     (define search-field
       (new search-field% 
            [parent test-frame]
            [init-value "Text to clear"]))
     
     (send search-field clear)
     (check-equal? (send search-field get-text) "" "Search field should be cleared after calling clear")
     )
   
   ;; Test 4: Callback Function
   (test-case "Callback Function" 
     (define callback-called #f)
     (define callback-search-field #f)
     
     (define search-field
       (new search-field% 
            [parent test-frame]
            [init-value "Test Search"]
            [callback (λ (sf) 
                        (set! callback-called #t)
                        (set! callback-search-field (send sf get-text)))]))
     
     ;; Simulate search button click
     ;; Note: We can't directly access the search button from outside, but we can test the callback by calling it directly
     (define dummy-event (make-object control-event% 'button))
     (send search-field callback search-field dummy-event)
     
     (check-equal? callback-called #t "Callback should be called when search field is triggered")
     (check-equal? callback-search-field "Test Search" "Callback should receive the correct search text")
     )
   
   ;; Test 5: Theme Response
   (test-case "Theme Response" 
     (define search-field
       (new search-field% 
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
(run-tests search-field-tests)

;; Close test frame
(send test-frame show #f)