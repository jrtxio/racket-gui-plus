#lang racket/gui

;; 简单测试程序，只测试一个控件
(require "../gui-plus.rkt")

;; 创建主窗口
(define frame (new frame%
                   [label "简单测试"]
                   [width 400]
                   [height 200]))

;; 创建内容面板
(define content-panel (new vertical-panel%
                           [parent frame]
                           [border 20]
                           [spacing 10]))

;; 添加一个输入框控件
(new message% [parent content-panel] [label "测试输入框："])
(define input (new modern-input%
                   [parent content-panel]
                   [placeholder "请输入文本"]
                   [stretchable-width #t]))

;; 添加一个按钮，用于显示通知
(new button%
     [parent content-panel]
     [label "显示通知"]
     [callback (lambda (btn evt)
                (show-toast "测试通知" #:type 'success))])

;; 显示窗口
(send frame show #t)