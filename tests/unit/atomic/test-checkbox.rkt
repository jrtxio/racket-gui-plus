#lang racket/gui

;; Automated tests for Checkbox component
;; Using Racket's rackunit testing framework

(require rackunit
         racket/class
         racket/draw
         "../../../guix/atomic/checkbox.rkt"
        "../../../guix/style/config.rkt")

;; 创建一个简单的测试框架
(define test-frame
  (new frame%
       [label "Checkbox Test Frame"]
       [width 400]
       [height 300]
       [style '(no-resize-border)]))

;; 显示测试框架
(send test-frame show #t)

;; 测试套件
(define checkbox-tests
  (test-suite
   "checkbox% Tests"
   
   ;; 测试1: 基本创建和属性设置
   (test-case "Basic Creation and Properties" 
     (define checkbox
       (new checkbox%
            [parent test-frame]
            [label "Test Checkbox"]
            [checked? #f]))
     
     (check-equal? (send checkbox get-checkbox-label) "Test Checkbox" "Checkbox label should be 'Test Checkbox'")
     (check-equal? (send checkbox get-checked) #f "Checkbox should be unchecked by default")
     (check-equal? (send checkbox get-enabled-state) #t "Checkbox should be enabled by default")
     )
   
   ;; 测试2: 选中/未选中状态切换
   (test-case "Checked/Unchecked State Switching" 
     (define checkbox
       (new checkbox%
            [parent test-frame]
            [label "Test Checkbox"]
            [checked? #f]))
     
     (send checkbox set-checked! #t)
     (check-equal? (send checkbox get-checked) #t "Checkbox should be checked after set-checked! #t")
     
     (send checkbox set-checked! #f)
     (check-equal? (send checkbox get-checked) #f "Checkbox should be unchecked after set-checked! #f")
     )
   
   ;; 测试3: 启用/禁用状态切换
   (test-case "Enable/Disable State" 
     (define checkbox
       (new checkbox%
            [parent test-frame]
            [label "Test Checkbox"]
            [checked? #f]))
     
     (send checkbox set-enabled! #f)
     (check-equal? (send checkbox get-enabled-state) #f "Checkbox should be disabled")
     
     (send checkbox set-enabled! #t)
     (check-equal? (send checkbox get-enabled-state) #t "Checkbox should be enabled")
     )
   
   ;; 测试4: 标签文本设置
   (test-case "Label Text Setting" 
     (define checkbox
       (new checkbox%
            [parent test-frame]
            [label "Initial Label"]
            [checked? #f]))
     
     (send checkbox set-checkbox-label! "New Label")
     (check-equal? (send checkbox get-checkbox-label) "New Label" "Checkbox label should be updated")
     )
   
   ;; 测试5: 主题响应
   (test-case "Theme Response" 
     (define checkbox
       (new checkbox%
            [parent test-frame]
            [label "Test Checkbox"]
            [checked? #f]
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
   
   ;; 测试6: 点击回调
   (test-case "Click Callback" 
     (define clicked #f)
     (define checkbox
       (new checkbox%
            [parent test-frame]
            [label "Test Checkbox"]
            [checked? #f]
            [callback (λ (cb event) (set! clicked #t))]))
     
     ;; 模拟点击事件
     (define dummy-event (make-object mouse-event% 'left-up 0 0 0 0 '(left) 0 #f 0 0 0 #f))
     (send checkbox on-event dummy-event)
     )
   )
)

;; 运行测试
(require rackunit/text-ui)
(run-tests checkbox-tests)

;; 关闭测试框架
(send test-frame show #f)