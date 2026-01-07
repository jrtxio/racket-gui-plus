#lang racket/gui

;; 简化测试：只测试 style-config.rkt 文件
(require racket-gui-plus/style-config)

;; 创建主窗口
(define frame (new frame% [label "Style Config Test"]
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

(displayln "成功导入并使用了racket-gui-plus/style-config模块！")
