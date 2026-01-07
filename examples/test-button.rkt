#lang racket/gui

;; Simple Button控件测试文件
;; 仅测试button组件，避免依赖其他不完整组件

(require racket/class
         racket/draw
         "../guix/style/config.rkt"
         "../guix/atomic/button.rkt")

;; 创建主窗口
(define frame
  (new frame% 
       [label "Guix Button Test"]
       [width 400]
       [height 300]))

;; 创建垂直面板
(define panel
  (new vertical-panel% 
       [parent frame]
       [alignment '(center center)]
       [spacing 20]
       [border 30]))

;; 添加标题
(new message% 
     [parent panel]
     [label "Button Test"]
     [font (send the-font-list find-or-create-font 16 'default 'normal 'bold)])

;; 不同类型按钮测试
(new modern-button% 
     [parent panel]
     [label "Primary Button"]
     [type 'primary]
     [callback (λ (button event) 
                 (displayln "Primary button clicked!"))])

(new modern-button% 
     [parent panel]
     [label "Secondary Button"]
     [type 'secondary]
     [callback (λ (button event) 
                 (displayln "Secondary button clicked!"))])

(new modern-button% 
     [parent panel]
     [label "Text Button"]
     [type 'text]
     [callback (λ (button event) 
                 (displayln "Text button clicked!"))])

;; 禁用按钮测试
(new modern-button% 
     [parent panel]
     [label "Disabled Primary"]
     [type 'primary]
     [enabled #f])

;; 主题切换按钮
(new modern-button% 
     [parent panel]
     [label "Toggle Theme"]
     [type 'primary]
     [callback (λ (button event) 
                 (if (equal? (current-theme) light-theme)
                     (set-theme! 'dark)
                     (set-theme! 'light)))])

;; 显示窗口
(send frame show #t)

(displayln "Button test started. Try clicking buttons and toggling theme!")