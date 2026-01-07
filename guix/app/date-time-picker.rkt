#lang racket/gui
(require racket/class racket/draw racket/date)
(require "calendar.rkt")
(require "time-picker.rkt")

;; Date time picker component
;; Modern combined date and time picker

(provide date-time-picker%)

(define date-time-picker%
  (class vertical-panel%
    (init-field [parent #f]
                [style '()]
                [on-change void]
                [year (date-year (current-date))]
                [month (date-month (current-date))]
                [day (date-day (current-date))]
                [hour 0]
                [minute 0])
    
    ;; Initialize vertical panel
    (super-new [parent parent]
               [style (append style '(border))]
               [spacing 10]
               [alignment '(center center)])
    
    ;; List of callback functions
    (define callbacks '())
    
    ;; Add default callback
    (when on-change
      (set! callbacks (cons on-change callbacks)))
    
    ;; Calendar selection callback
    (define (on-calendar-change y m d)
      (set! year y)
      (set! month m)
      (set! day d)
      (notify-change))
    
    ;; Time selection callback
    (define (on-time-change h min)
      (set! hour h)
      (set! minute min)
      (notify-change))
    
    ;; Notify all callback functions
    (define (notify-change)
      (for ([cb callbacks])
        (cb year month day hour minute)))
    
    ;; Create calendar control
    (define calendar (new calendar%
                         [parent this]
                         [on-select-callback on-calendar-change]))
    
    ;; Create time picker control
    (define time-picker (new time-picker%
                           [parent this]
                           [hour hour]
                           [minute minute]
                           [on-change on-time-change]))
    
    ;; Public interface: Add callback function
    (define/public (add-callback cb)
      (set! callbacks (cons cb callbacks)))
    
    ;; Public interface: Get complete date and time
    (define/public (get-date-time)
      (values year month day hour minute))
    
    ;; Public interface: Set complete date and time
    (define/public (set-date-time y m d h min)
      (set! year y)
      (set! month m)
      (set! day d)
      (set! hour h)
      (set! minute min)
      (send calendar set-date y m d)
      (send time-picker set-time h min)
      (notify-change))
    
    ;; Public interface: Get date part
    (define/public (get-date)
      (values year month day))
    
    ;; Public interface: Set date part
    (define/public (set-date y m d)
      (set! year y)
      (set! month m)
      (set! day d)
      (send calendar set-date y m d)
      (notify-change))
    
    ;; Public interface: Get time part
    (define/public (get-time)
      (values hour minute))
    
    ;; Public interface: Set time part
    (define/public (set-time h min)
      (set! hour h)
      (set! minute min)
      (send time-picker set-time h min)
      (notify-change))
    
    ;; Public interface: Get year
    (define/public (get-year)
      year)
    
    ;; Public interface: Get month
    (define/public (get-month)
      month)
    
    ;; Public interface: Get day
    (define/public (get-day)
      day)
    
    ;; Public interface: Get hour
    (define/public (get-hour)
      hour)
    
    ;; Public interface: Get minute
    (define/public (get-minute)
      minute)
    
    ;; Standardized methods
    (define/public (get-value)
      (send this get-date-time))
    
    (define/public (set-value y m d h min)
      (send this set-date-time y m d h min))
    )
)
