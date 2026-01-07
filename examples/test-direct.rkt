#lang racket/gui

;; 直接使用相对路径导入，绕过包系统的问题
(require "../racket-gui-plus/style-config.rkt")

;; 创建主窗口
(define frame (new frame% [label "直接导入测试"]
                          [width 400]
                          [height 200]))

;; 创建内容面板
(define panel (new vertical-panel% [parent frame]
                                   [border 10]
                                   [spacing 10]))

;; 显示当前主题的一些样式值
(new message% [parent panel]
     [label "当前主题样式值："]
     [font (make-object font% 14 'default 'normal 'bold)])

(new message% [parent panel]
     [label (format "边框圆角（小）：~a" (border-radius-small))])

(new message% [parent panel]
     [label (format "主文字颜色：~a" (color-text-main))])

(new message% [parent panel]
     [label (format "背景色：~a" (color-bg-white))])

;; 显示窗口
(send frame show #t)

(displayln "成功直接导入并使用了racket-gui-plus/style-config模块！")
