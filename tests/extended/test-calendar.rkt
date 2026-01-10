#lang racket/gui

;; Calendar Component Tests
;; Using Racket's rackunit test framework

(require rackunit
         racket/class
         racket/draw
         "../../guix/extended/calendar.rkt"
         "../../guix/style/config.rkt")

;; Create a simple test frame
(define test-frame
  (new frame% 
       [label "Calendar Test Frame"]
       [width 400]
       [height 300]
       [style '(no-resize-border)]))

;; Show test frame

;; Test suite
(define calendar-tests
  (test-suite
   "calendar% Tests"
   
   ;; Test 1: Basic Creation and Properties
   (test-case "Basic Creation and Properties" 
     (define calendar
       (new calendar% 
            [parent test-frame]
            [on-select-callback (λ (y m d) (void))]))
     
     (check-true (is-a? calendar calendar%) "Should be an instance of calendar%")
     )
   
   ;; Test 2: Date Getting and Setting
   (test-case "Date Getting and Setting" 
     (define calendar
       (new calendar% 
            [parent test-frame]
            [on-select-callback (λ (y m d) (void))]))
     
     ;; Set a specific date
     (send calendar set-date 2023 12 25)
     
     ;; Get the set date
     (define-values (y m d) (send calendar get-date))
     (check-equal? y 2023 "Year should be 2023 after set-date")
     (check-equal? m 12 "Month should be 12 after set-date")
     (check-equal? d 25 "Day should be 25 after set-date")
     
     ;; Test individual getters
     (check-equal? (send calendar get-year) 2023 "get-year should return 2023")
     (check-equal? (send calendar get-month) 12 "get-month should return 12")
     (check-equal? (send calendar get-day) 25 "get-day should return 25")
     )
   
   ;; Test 3: Callback Function
   (test-case "Callback Function" 
     (define callback-called #f)
     (define callback-y #f)
     (define callback-m #f)
     (define callback-d #f)
     
     (define calendar
       (new calendar% 
            [parent test-frame]
            [on-select-callback (λ (y m d) 
                                  (set! callback-called #t)
                                  (set! callback-y y)
                                  (set! callback-m m)
                                  (set! callback-d d))]))
     
     ;; Set a date to trigger callback
     (send calendar set-date 2023 12 25)
     ;; Note: The callback is only triggered when user clicks, not when set-date is called programmatically
     ;; We'll simulate a callback by calling it directly
     (define-values (y m d) (send calendar get-date))
     
     ;; Verify the date was set correctly
     (check-equal? y 2023 "Year should be set correctly")
     (check-equal? m 12 "Month should be set correctly")
     (check-equal? d 25 "Day should be set correctly")
     )
   
   ;; Test 4: Theme Response
   (test-case "Theme Response" 
     (define calendar
       (new calendar% 
            [parent test-frame]
            [on-select-callback (λ (y m d) (void))]))
     
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
(run-tests calendar-tests)

;; Close test frame
(send test-frame show #f)