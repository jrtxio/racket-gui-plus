#lang racket/gui

;; Simple Date Time Picker Test File
;; Test only date time picker component

(require racket/class
         racket/draw
         "../guix/app/date-time-picker.rkt")

;; Create main window
(define frame
  (new frame%
       [label "Guix Date Time Picker Test"]
       [width 500]
       [height 450]))

;; Create vertical panel
(define panel
  (new vertical-panel%
       [parent frame]
       [alignment '(center center)]
       [spacing 20]
       [border 20]))

;; Add title
(new message%
     [parent panel]
     [label "Date Time Picker Test"]
     [font (send the-font-list find-or-create-font 16 'default 'normal 'bold)])

;; Test basic date time picker
(new message%
     [parent panel]
     [label "Basic Date Time Picker:"])

(define basic-date-time-picker
  (new date-time-picker%
       [parent panel]
       [year 2024]
       [month 1]
       [day 15]
       [hour 14]
       [minute 30]
       [on-change (lambda (y m d h min) 
                    (displayln (format "Date Time Picker changed: ~a-~a-~a ~a:~a" 
                                      (~r y #:min-width 4 #:pad-string "0")
                                      (~r m #:min-width 2 #:pad-string "0")
                                      (~r d #:min-width 2 #:pad-string "0")
                                      (~r h #:min-width 2 #:pad-string "0")
                                      (~r min #:min-width 2 #:pad-string "0"))))]))

;; Test date time picker with default current date time
(new message%
     [parent panel]
     [label "Default Current Date Time:"])

(new date-time-picker%
     [parent panel]
     [on-change (lambda (y m d h min) 
                  (displayln (format "Current Date Time Picker changed: ~a-~a-~a ~a:~a" 
                                    (~r y #:min-width 4 #:pad-string "0")
                                    (~r m #:min-width 2 #:pad-string "0")
                                    (~r d #:min-width 2 #:pad-string "0")
                                    (~r h #:min-width 2 #:pad-string "0")
                                    (~r min #:min-width 2 #:pad-string "0"))))])

;; Show window
(send frame show #t)

(displayln "Date time picker test started. Try selecting dates and times!")