#lang racket/gui

;; Automated tests for Date Time Picker component
;; Using Racket's rackunit testing framework

(require rackunit
         racket/class
         racket/draw
         "../../../guix/extended/date-time-picker.rkt")

;; 创建一个简单的测试框架
(define test-frame
  (new frame%
       [label "Date Time Picker Test Frame"]
       [width 500]
       [height 400]
       [style '(no-resize-border)]))

;; 显示测试框架
(send test-frame show #t)

;; 测试套件
(define date-time-picker-tests
  (test-suite
   "date-time-picker% Tests"
   
   ;; 测试1: 基本创建和属性设置
   (test-case "Basic Creation and Properties" 
     (define date-time-picker
       (new date-time-picker%
            [parent test-frame]
            [year 2023]
            [month 12]
            [day 25]
            [hour 10]
            [minute 30]))
     
     (check-not-false date-time-picker "Date time picker should be created successfully")
     )
   
   ;; 测试2: 日期时间设置和获取
   (test-case "Date Time Setting and Getting" 
     (define date-time-picker
       (new date-time-picker%
            [parent test-frame]
            [year 2023]
            [month 12]
            [day 25]
            [hour 10]
            [minute 30]))
     
     ;; 获取初始日期时间
     (define-values (initial-year initial-month initial-day initial-hour initial-minute) 
       (send date-time-picker get-date-time))
     (check-equal? initial-year 2023 "Initial year should be 2023")
     (check-equal? initial-month 12 "Initial month should be 12")
     (check-equal? initial-day 25 "Initial day should be 25")
     (check-equal? initial-hour 10 "Initial hour should be 10")
     (check-equal? initial-minute 30 "Initial minute should be 30")
     
     ;; 设置新日期时间
     (send date-time-picker set-date-time 2024 1 15 14 45)
     (define-values (new-year new-month new-day new-hour new-minute) 
       (send date-time-picker get-date-time))
     (check-equal? new-year 2024 "Year should be updated to 2024")
     (check-equal? new-month 1 "Month should be updated to 1")
     (check-equal? new-day 15 "Day should be updated to 15")
     (check-equal? new-hour 14 "Hour should be updated to 14")
     (check-equal? new-minute 45 "Minute should be updated to 45")
     
     ;; 测试标准化方法
     (send date-time-picker set-value 2024 2 10 9 15)
     (define-values (std-year std-month std-day std-hour std-minute) 
       (send date-time-picker get-value))
     (check-equal? std-year 2024 "Standard year should be 2024")
     (check-equal? std-month 2 "Standard month should be 2")
     (check-equal? std-day 10 "Standard day should be 10")
     (check-equal? std-hour 9 "Standard hour should be 9")
     (check-equal? std-minute 15 "Standard minute should be 15")
     )
   
   ;; 测试3: 单独设置和获取日期部分
   (test-case "Date Setting and Getting" 
     (define date-time-picker
       (new date-time-picker%
            [parent test-frame]
            [year 2023]
            [month 12]
            [day 25]
            [hour 10]
            [minute 30]))
     
     ;; 获取初始日期
     (define-values (initial-year initial-month initial-day) 
       (send date-time-picker get-date))
     (check-equal? initial-year 2023 "Initial year should be 2023")
     (check-equal? initial-month 12 "Initial month should be 12")
     (check-equal? initial-day 25 "Initial day should be 25")
     
     ;; 单独设置日期
     (send date-time-picker set-date 2024 3 15)
     (define-values (new-year new-month new-day) 
       (send date-time-picker get-date))
     (check-equal? new-year 2024 "Year should be updated to 2024")
     (check-equal? new-month 3 "Month should be updated to 3")
     (check-equal? new-day 15 "Day should be updated to 15")
     
     ;; 验证时间部分未改变
     (define-values (new-hour new-minute) 
       (send date-time-picker get-time))
     (check-equal? new-hour 10 "Hour should remain 10")
     (check-equal? new-minute 30 "Minute should remain 30")
     )
   
   ;; 测试4: 单独设置和获取时间部分
   (test-case "Time Setting and Getting" 
     (define date-time-picker
       (new date-time-picker%
            [parent test-frame]
            [year 2023]
            [month 12]
            [day 25]
            [hour 10]
            [minute 30]))
     
     ;; 获取初始时间
     (define-values (initial-hour initial-minute) 
       (send date-time-picker get-time))
     (check-equal? initial-hour 10 "Initial hour should be 10")
     (check-equal? initial-minute 30 "Initial minute should be 30")
     
     ;; 单独设置时间
     (send date-time-picker set-time 14 45)
     (define-values (new-hour new-minute) 
       (send date-time-picker get-time))
     (check-equal? new-hour 14 "Hour should be updated to 14")
     (check-equal? new-minute 45 "Minute should be updated to 45")
     
     ;; 验证日期部分未改变
     (define-values (new-year new-month new-day) 
       (send date-time-picker get-date))
     (check-equal? new-year 2023 "Year should remain 2023")
     (check-equal? new-month 12 "Month should remain 12")
     (check-equal? new-day 25 "Day should remain 25")
     )
   
   ;; 测试5: 回调函数测试
   (test-case "Callback Function" 
     (define callback-called #f)
     (define callback-year 0)
     (define callback-month 0)
     (define callback-day 0)
     (define callback-hour 0)
     (define callback-minute 0)
     
     (define date-time-picker
       (new date-time-picker%
            [parent test-frame]
            [on-change (lambda (y m d h min) 
                         (set! callback-called #t)
                         (set! callback-year y)
                         (set! callback-month m)
                         (set! callback-day d)
                         (set! callback-hour h)
                         (set! callback-minute min))]))
     
     ;; 设置日期时间，触发回调
     (send date-time-picker set-date-time 2024 5 20 16 30)
     (check-equal? callback-called #t "Callback should be called when date time changes")
     (check-equal? callback-year 2024 "Callback should receive correct year")
     (check-equal? callback-month 5 "Callback should receive correct month")
     (check-equal? callback-day 20 "Callback should receive correct day")
     (check-equal? callback-hour 16 "Callback should receive correct hour")
     (check-equal? callback-minute 30 "Callback should receive correct minute")
     
     ;; 测试添加多个回调
     (define callback2-called #f)
     (send date-time-picker add-callback (lambda (y m d h min) (set! callback2-called #t)))
     (send date-time-picker set-time 17 45)
     (check-equal? callback2-called #t "Additional callback should be called")
     )
   
   ;; 测试6: 单独获取年、月、日、时、分
   (test-case "Individual Component Accessors" 
     (define date-time-picker
       (new date-time-picker%
            [parent test-frame]
            [year 2024]
            [month 6]
            [day 15]
            [hour 14]
            [minute 30]))
     
     (check-equal? (send date-time-picker get-year) 2024 "get-year should return 2024")
     (check-equal? (send date-time-picker get-month) 6 "get-month should return 6")
     (check-equal? (send date-time-picker get-day) 15 "get-day should return 15")
     (check-equal? (send date-time-picker get-hour) 14 "get-hour should return 14")
     (check-equal? (send date-time-picker get-minute) 30 "get-minute should return 30")
     )
   )
)

;; 运行测试
(require rackunit/text-ui)
(run-tests date-time-picker-tests)

;; 关闭测试框架
(send test-frame show #f)