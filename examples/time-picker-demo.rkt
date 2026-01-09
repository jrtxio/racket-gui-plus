#lang racket/gui

;; Simple Time Picker Test File
;; Test only time picker component

(require racket/class
         racket/draw
         "../guix/guix.rkt")

;; Create main window
(define frame
  (new frame%
       [label "Guix Time Picker Test"]
       [width 300]
       [height 200]))

;; Create vertical panel
(define panel
  (new vertical-panel%
       [parent frame]
       [alignment '(center center)]
       [spacing 20]
       [border 30]))

;; Add title
(new message%
     [parent panel]
     [label "Time Picker Test"]
     [font (send the-font-list find-or-create-font 16 'default 'normal 'bold)])

;; Test basic time picker
(new message%
     [parent panel]
     [label "Basic Time Picker:"])

(define basic-time-picker
  (new time-picker%
       [parent panel]
       [hour 12]
       [minute 30]
       [on-change (lambda (h m) 
                    (displayln (format "Basic Time Picker changed: ~a:~a" 
                                      (~r h #:min-width 2 #:pad-string "0")
                                      (~r m #:min-width 2 #:pad-string "0"))))]))

;; Test time picker with custom initial time
(new message%
     [parent panel]
     [label "Custom Initial Time:"])

(new time-picker%
     [parent panel]
     [hour 9]
     [minute 45]
     [on-change (lambda (h m) 
                  (displayln (format "Custom Time Picker changed: ~a:~a" 
                                    (~r h #:min-width 2 #:pad-string "0")
                                    (~r m #:min-width 2 #:pad-string "0"))))])

;; Show window
(send frame show #t)

(displayln "Time picker test started. Try interacting with the time pickers!")