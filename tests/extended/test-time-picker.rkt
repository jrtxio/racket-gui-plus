#lang racket/gui

;; Automated tests for Time Picker component
;; Using Racket's rackunit testing framework

(require rackunit
         racket/class
         racket/draw
         "../../guix/extended/time-picker.rkt")

;; Create a simple test frame
(define test-frame
  (new frame%
       [label "Time Picker Test Frame"]
       [width 400]
       [height 300]
       [style '(no-resize-border)]))

;; Test suite
(define time-picker-tests
  (test-suite
   "time-picker% Tests"
   
   (test-case "Basic Creation and Properties" 
     (define time-picker
       (new time-picker%
            [parent test-frame]
            [hour 12]
            [minute 30]))
     
     (check-not-false time-picker "Time picker should be created successfully")
     )
   
   (test-case "Time Setting and Getting" 
     (define time-picker
       (new time-picker%
            [parent test-frame]
            [hour 12]
            [minute 30]))
     
     ;; Get initial time
     (define-values (initial-hour initial-minute) (send time-picker get-time))
     (check-equal? initial-hour 12 "Initial hour should be 12")
     (check-equal? initial-minute 30 "Initial minute should be 30")
     
     ;; Set new time
     (send time-picker set-time 15 45)
     (define-values (new-hour new-minute) (send time-picker get-time))
     (check-equal? new-hour 15 "Hour should be updated to 15")
     (check-equal? new-minute 45 "Minute should be updated to 45")
     
     ;; Test standardization methods
     (send time-picker set-value 9 15)
     (define-values (standard-hour standard-minute) (send time-picker get-value))
     (check-equal? standard-hour 9 "Standard hour should be 9")
     (check-equal? standard-minute 15 "Standard minute should be 15")
     )
   
   (test-case "Time Range Validation" 
     (define time-picker
       (new time-picker%
            [parent test-frame]))
     
     ;; Test hour range
     (send time-picker set-time 25 30) ; 超出范围
     (define-values (hour1 minute1) (send time-picker get-time))
     (check-equal? hour1 1 "Hour should wrap around to 1")
     
     (send time-picker set-time -1 30) ; 超出范围
     (define-values (hour2 minute2) (send time-picker get-time))
     (check-equal? hour2 23 "Hour should wrap around to 23")
     
     ;; Test minute range
     (send time-picker set-time 12 65) ; 超出范围
     (define-values (hour3 minute3) (send time-picker get-time))
     (check-equal? minute3 5 "Minute should wrap around to 5")
     
     (send time-picker set-time 12 -5) ; 超出范围
     (define-values (hour4 minute4) (send time-picker get-time))
     (check-equal? minute4 55 "Minute should wrap around to 55")
     )
   
   (test-case "Callback Function" 
     (define callback-called #f)
     (define callback-hour 0)
     (define callback-minute 0)
     
     (define time-picker
       (new time-picker%
            [parent test-frame]
            [on-change (lambda (h m) 
                         (set! callback-called #t)
                         (set! callback-hour h)
                         (set! callback-minute m))]))
     
     ;; Set time to trigger callback
     (send time-picker set-time 10 20)
     (check-equal? callback-called #t "Callback should be called when time changes")
     (check-equal? callback-hour 10 "Callback should receive correct hour")
     (check-equal? callback-minute 20 "Callback should receive correct minute")
     
     ;; Test adding multiple callbacks
     (define callback2-called #f)
     (send time-picker add-callback (lambda (h m) (set! callback2-called #t)))
     (send time-picker set-time 11 30)
     (check-equal? callback2-called #t "Additional callback should be called")
     )
   )
)

;; Run tests
(require rackunit/text-ui)
(run-tests time-picker-tests)

;; Close the test frame
(send test-frame show #f)