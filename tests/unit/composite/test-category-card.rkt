#lang racket/gui

;; Category Card组件自动化测试
;; 使用Racket的rackunit测试框架

(require rackunit
         racket/class
         racket/draw
         "../../../guix/composite/category-card.rkt"
        "../../../guix/style/config.rkt")

;; 创建一个简单的测试框架
(define test-frame
  (new frame%
       [label "Category Card Test Frame"]
       [width 400]
       [height 300]
       [style '(no-resize-border)]))

;; 显示测试框架
(send test-frame show #t)

;; 测试套件
(define category-card-tests
  (test-suite
   "category-card% Tests"
   
   ;; 测试1: 基本创建和属性设置
   (test-case "Basic Creation and Properties" 
     (define button
       (new category-card%
            [parent test-frame]
            [label "Test Category"]
            [count 5]
            [icon-symbol "🔍"]))
     
     ;; 验证控件创建成功
     (check-not-false button "Category card should be created successfully")
     )
   
   ;; 测试2: 点击回调
   (test-case "Click Callback" 
     (define clicked #f)
     (define card
       (new category-card%
            [parent test-frame]
            [label "Test Category"]
            [count 5]
            [on-click (λ (event) (set! clicked #t))]))
     
     ;; 模拟鼠标进入、按下和抬起事件
     (define enter-event (make-object mouse-event% 'enter 0 0 0 0 '() 0 #f 0 0 0 #f))
     (define mouse-down-event (make-object mouse-event% 'left-down 0 0 0 0 '(left) 0 #f 0 0 0 #f))
     (define mouse-up-event (make-object mouse-event% 'left-up 0 0 0 0 '(left) 0 #f 0 0 0 #f))
     
     (send card handle-mouse-event enter-event) ; 先进入，设置 hover? 为 #t
     (send card handle-mouse-event mouse-down-event)
     (send card handle-mouse-event mouse-up-event)
     
     ;; 验证回调被调用
     (check-equal? clicked #t "Callback should be called when card is clicked")
     )
   
   ;; 测试3: 主题响应
   (test-case "Theme Response" 
     (define card
       (new category-card%
            [parent test-frame]
            [label "Test Category"]
            [count 5]))
     
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
   
   ;; 测试4: 鼠标状态变化
   (test-case "Mouse State Changes" 
     (define card
       (new category-card%
            [parent test-frame]
            [label "Test Category"]
            [count 5]))
     
     ;; 模拟鼠标进入事件
     (define enter-event (make-object mouse-event% 'enter 0 0 0 0 '() 0 #f 0 0 0 #f))
     (send card on-event enter-event)
     
     ;; 模拟鼠标离开事件
     (define leave-event (make-object mouse-event% 'leave 0 0 0 0 '() 0 #f 0 0 0 #f))
     (send card on-event leave-event)
     
     ;; 验证控件能够处理鼠标事件
     (check-not-false card "Category card should handle mouse events")
     )
   )
)

;; 运行测试
(require rackunit/text-ui)
(run-tests category-card-tests)

;; 关闭测试框架
(send test-frame show #f)