#lang racket/gui

;; Automated tests for Label component
;; Using Racket's rackunit testing framework

(require rackunit
         rackunit/text-ui
         racket/class
         racket/draw
         "../../guix/atomic/label.rkt"
        "../../guix/style/config.rkt")

;; 创建一个简单的测试框架
(define test-frame
  (new frame%
       [label "Label Test Frame"]
       [width 400]
       [height 300]
       [style '(no-resize-border)]))

;; 显示测试框架

;; 测试套件
(define label-tests
  (test-suite
   "label% Tests"
   
   ;; 测试1: 基本创建和属性设置
   (test-case "Basic Creation and Properties" 
     (define label
       (new label%
            [parent test-frame]
            [label "Test Label"]
            [font-size 'regular]
            [font-weight 'normal]))
     
     (check-equal? (send label get-label-text) "Test Label" "Label text should be 'Test Label'")
     (check-equal? (send label get-font-size) 'regular "Font size should be 'regular")
     (check-equal? (send label get-font-weight) 'normal "Font weight should be 'normal")
     (check-equal? (send label get-enabled-state) #t "Label should be enabled by default")
     )
   
   ;; 测试2: 文本设置和获取
   (test-case "Text Setting and Getting" 
     (define label
       (new label%
            [parent test-frame]
            [label "Initial Label"]))
     
     (send label set-label-text! "New Label")
     (check-equal? (send label get-label-text) "New Label" "Label text should be updated")
     )
   
   ;; 测试3: 字体大小设置
   (test-case "Font Size Setting" 
     (define label
       (new label%
            [parent test-frame]
            [label "Test Label"]
            [font-size 'regular]))
     
     (send label set-font-size! 'small)
     (check-equal? (send label get-font-size) 'small "Font size should be 'small")
     
     (send label set-font-size! 'medium)
     (check-equal? (send label get-font-size) 'medium "Font size should be 'medium")
     
     (send label set-font-size! 'large)
     (check-equal? (send label get-font-size) 'large "Font size should be 'large")
     )
   
   ;; 测试4: 字体粗细设置
   (test-case "Font Weight Setting" 
     (define label
       (new label%
            [parent test-frame]
            [label "Test Label"]
            [font-weight 'normal]))
     
     (send label set-font-weight! 'bold)
     (check-equal? (send label get-font-weight) 'bold "Font weight should be 'bold")
     
     (send label set-font-weight! 'normal)
     (check-equal? (send label get-font-weight) 'normal "Font weight should be 'normal")
     )
   
   ;; 测试5: 启用/禁用状态切换
   (test-case "Enable/Disable State" 
     (define label
       (new label%
            [parent test-frame]
            [label "Test Label"]
            [enabled? #t]))
     
     (send label set-enabled! #f)
     (check-equal? (send label get-enabled-state) #f "Label should be disabled")
     
     (send label set-enabled! #t)
     (check-equal? (send label get-enabled-state) #t "Label should be enabled")
     )
   
   ;; 测试6: 自定义颜色设置
   (test-case "Custom Color Setting" 
     (define custom-color (make-object color% 255 0 0))
     (define label
       (new label%
            [parent test-frame]
            [label "Test Label"]
            [color custom-color]))
     
     (check-equal? (send label get-color) custom-color "Custom color should be set")
     
     (define new-color (make-object color% 0 255 0))
     (send label set-color! new-color)
     (check-equal? (send label get-color) new-color "Custom color should be updated")
     )
   
   ;; 测试7: 主题响应
   (test-case "Theme Response" 
     (define label
       (new label%
            [parent test-frame]
            [label "Test Label"]
            [theme-aware? #t]))
     
     ;; 保存当前主题
     (define original-theme (current-theme))
     
     ;; 切换到深色主题
     (set-theme! 'dark)
     ;; 验证主题已切换
     (check-equal? (current-theme) dark-theme "Theme should be dark")
     
     ;; 切换回浅色主题
     (set-theme! 'light)
     ;; 验证主题已切换
     (check-equal? (current-theme) light-theme "Theme should be light")
     )
   ))

;; 运行测试套件
(void (run-tests label-tests))

;; 等待用户关闭窗口
(void (read-char))
