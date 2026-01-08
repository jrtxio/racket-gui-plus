#lang racket/gui

;; Side Panel组件自动化测试
;; 使用Racket的rackunit测试框架

(require rackunit
         racket/class
         "../../../guix/container/side-panel.rkt"
        "../../../guix/style/config.rkt")

;; 创建一个简单的测试框架
(define test-frame
  (new frame%
       [label "Side Panel Test Frame"]
       [width 800]
       [height 600]
       [style '(no-resize-border)]))

;; 显示测试框架
(send test-frame show #t)

;; 测试套件
(define side-panel-tests
  (test-suite
   "side-panel% Tests"
   
   ;; 测试1: 基本创建和属性设置
   (test-case "Basic Creation and Properties" 
     (define side-panel
       (new side-panel%
            [parent test-frame]))
     
     ;; 验证初始属性
     (check-equal? (send side-panel get-side-panel-width) 240 "Default side panel width should be 240")
     (check-equal? (send side-panel get-min-width) 150 "Default min width should be 150")
     (check-equal? (send side-panel get-max-width) 500 "Default max width should be 500")
     )
   
   ;; 测试2: 侧边栏宽度控制
   (test-case "Side Panel Width Control" 
     (define side-panel
       (new side-panel%
            [parent test-frame]
            [side-panel-width 300]))
     
     ;; 测试获取宽度
     (check-equal? (send side-panel get-side-panel-width) 300 "Initial width should be 300")
     
     ;; 测试设置宽度
     (send side-panel set-side-panel-width! 350)
     (check-equal? (send side-panel get-side-panel-width) 350 "Width should be set to 350")
     )
   
   ;; 测试3: 最小宽度限制
   (test-case "Minimum Width Constraint" 
     (define side-panel
       (new side-panel%
            [parent test-frame]
            [side-panel-width 200]
            [min-width 180]))
     
     ;; 测试设置小于最小宽度的值
     (send side-panel set-side-panel-width! 150)
     (check-equal? (send side-panel get-side-panel-width) 180 "Width should not be less than min width")
     
     ;; 测试修改最小宽度
     (send side-panel set-min-width! 220)
     (check-equal? (send side-panel get-side-panel-width) 220 "Width should adjust to new min width")
     )
   
   ;; 测试4: 最大宽度限制
   (test-case "Maximum Width Constraint" 
     (define side-panel
       (new side-panel%
            [parent test-frame]
            [side-panel-width 400]
            [max-width 450]))
     
     ;; 测试设置大于最大宽度的值
     (send side-panel set-side-panel-width! 500)
     (check-equal? (send side-panel get-side-panel-width) 450 "Width should not be more than max width")
     
     ;; 测试修改最大宽度
     (send side-panel set-max-width! 380)
     (check-equal? (send side-panel get-side-panel-width) 380 "Width should adjust to new max width")
     )
   
   ;; 测试5: 宽度变化回调
   (test-case "Width Change Callback" 
     (define width-changed #f)
     (define new-width 0)
     
     (define side-panel
       (new side-panel%
            [parent test-frame]
            [on-width-change (λ (w) 
                               (set! width-changed #t)
                               (set! new-width w))]))
     
     ;; 触发宽度变化
     (send side-panel set-side-panel-width! 300)
     
     ;; 验证回调被调用
     (check-true width-changed "Width change callback should be called")
     (check-equal? new-width 300 "Callback should receive new width")
     )
   
   ;; 测试6: 主题响应
   (test-case "Theme Response" 
     (define side-panel
       (new side-panel%
            [parent test-frame]))
     
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
   
   ;; 测试7: 面板访问
   (test-case "Panel Access" 
     (define side-panel
       (new side-panel%
            [parent test-frame]))
     
     ;; 验证可以访问侧边栏和内容面板
     (check-not-false (send side-panel get-side-panel) "Should be able to get side panel")
     (check-not-false (send side-panel get-content-panel) "Should be able to get content panel")
     )
   ))

;; 运行测试
(require rackunit/text-ui)
(run-tests side-panel-tests)

;; 关闭测试框架
(send test-frame show #f)
