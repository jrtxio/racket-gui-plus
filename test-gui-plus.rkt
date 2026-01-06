#lang racket/gui

;; 测试 GUI Plus 库的导入和基本功能
(require "gui-plus.rkt")

;; 创建主窗口
(define frame (new frame%
                   [label "GUI Plus 测试"]
                   [width 600]
                   [height 400]))

;; 创建面板
(define panel (new vertical-panel% [parent frame]))

;; 测试1: 导入验证
(new message%
     [parent panel]
     [label "GUI Plus 库导入成功！"]
     [font (make-object font% 16 'default 'normal 'bold)])

;; 测试2: 简单控件使用
(define test-panel (new horizontal-panel% [parent panel]))

;; 创建输入框
(define input
  (new mac-input%
       [parent test-panel]
       [label "输入框: "]
       [placeholder "请输入测试内容"]
       [stretchable-width #t]))

;; 创建过滤按钮
(new filter-button%
     [parent test-panel]
     [label "测试按钮"]
     [icon-symbol "🔍"]
     [callback (lambda ()
                (toast-apple "按钮被点击了！" #:type 'success))])

;; 显示窗口
(send frame show #t)

;; 输出测试信息
(printf "GUI Plus 库测试完成！~n")
(printf "已导入的控件: ~n")
(printf "- calendar%~n")
(printf "- apple-sidebar%~n")
(printf "- filter-button%~n")
(printf "- mac-input%~n")
(printf "- apple-toast%~n")
(printf "- todo-list%~n")
