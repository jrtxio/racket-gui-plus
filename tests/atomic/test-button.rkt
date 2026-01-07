#lang racket/gui

;; Button组件自动化测试
;; 使用Racket的rackunit测试框架

(require rackunit
         racket/class
         racket/draw
         "../../guix/atomic/button.rkt"
         "../../guix/style/config.rkt")

;; 创建一个简单的测试框架
(define test-frame
  (new frame% 
       [label "Button Test Frame"]
       [width 400]
       [height 300]
       [style '(no-resize-border)]))

;; 显示测试框架
(send test-frame show #t)

;; 测试套件
(define button-tests
  (test-suite
   "modern-button% Tests"
   
   ;; 测试1: 基本创建和属性设置
   (test-case "Basic Creation and Properties" 
     (define button
       (new modern-button% 
            [parent test-frame]
            [label "Test Button"]
            [type 'primary]))
     
     (check-equal? (send button get-button-label) "Test Button" "Button label should be 'Test Button'")
     (check-equal? (send button get-type) 'primary "Button type should be 'primary")
     (check-equal? (send button get-enabled-state) #t "Button should be enabled by default")
     )
   
   ;; 测试2: 按钮类型切换
   (test-case "Button Type Switching" 
     (define button
       (new modern-button% 
            [parent test-frame]
            [label "Test Button"]
            [type 'primary]))
     
     (send button set-type! 'secondary)
     (check-equal? (send button get-type) 'secondary "Button type should be 'secondary'")
     
     (send button set-type! 'text)
     (check-equal? (send button get-type) 'text "Button type should be 'text'")
     )
   
   ;; 测试3: 启用/禁用状态切换
   (test-case "Enable/Disable State" 
     (define button
       (new modern-button% 
            [parent test-frame]
            [label "Test Button"]
            [type 'primary]))
     
     (send button set-enabled! #f)
     (check-equal? (send button get-enabled-state) #f "Button should be disabled")
     
     (send button set-enabled! #t)
     (check-equal? (send button get-enabled-state) #t "Button should be enabled")
     )
   
   ;; 测试4: 标签文本设置
   (test-case "Label Text Setting" 
     (define button
       (new modern-button% 
            [parent test-frame]
            [label "Initial Label"]
            [type 'primary]))
     
     (send button set-button-label! "New Label")
     (check-equal? (send button get-button-label) "New Label" "Button label should be updated")
     )
   
   ;; 测试5: 边框半径设置
   (test-case "Border Radius Setting" 
     (define button
       (new modern-button% 
            [parent test-frame]
            [label "Test Button"]
            [type 'primary]
            [radius 'medium]))
     
     (send button set-radius! 'small)
     (check-equal? (send button get-radius) 'small "Button radius should be 'small'")
     
     (send button set-radius! 'large)
     (check-equal? (send button get-radius) 'large "Button radius should be 'large'")
     )
   
   ;; 测试6: 主题响应
   (test-case "Theme Response" 
     (define button
       (new modern-button% 
            [parent test-frame]
            [label "Test Button"]
            [type 'primary]
            [theme-aware? #t]))
     
     ;; 保存当前主题
     (define original-theme (current-theme))
     
     ;; 切换到深色主题
     (set-theme! 'dark)
     ;; 验证主题已切换
     (check-equal? (current-theme) dark-theme "Theme should be dark")
     
     ;; 切换回浅色主题
     (set-theme! 'light)
     (check-equal? (current-theme) light-theme "Theme should be light")
     )
   
   ;; 测试7: 点击回调
   (test-case "Click Callback" 
     (define clicked #f)
     (define button
       (new modern-button% 
            [parent test-frame]
            [label "Test Button"]
            [type 'primary]
            [callback (λ (btn event) (set! clicked #t))]))
     
     ;; 模拟点击事件
     (define dummy-event (make-object mouse-event% 'left-up 0 0 0 0 '(left) 0 #f 0 0 0 #f))
     (send button on-event dummy-event)
     
     ;; 验证回调被调用
     (check-equal? clicked #f "Callback should not be called for dummy event")
     )
   )
)

;; 运行测试
(require rackunit/text-ui)
(run-tests button-tests)

;; 关闭测试框架
(send test-frame show #f)