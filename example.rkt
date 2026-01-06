#lang racket/gui

;; GUI Plus 库综合示例
;; 展示如何使用所有控件
(require "gui-plus.rkt")

;; 创建主窗口
(define frame (new frame%
                   [label "GUI Plus 综合示例"]
                   [width 800]
                   [height 600]))

;; 创建主面板，改为水平布局
(define main-panel (new horizontal-panel% 
                       [parent frame]
                       [spacing 0]))

;; 创建侧边栏面板
(define sidebar-panel (new vertical-panel% 
                           [parent main-panel]
                           [stretchable-width #f]
                           [stretchable-height #t]
                           [min-width 200]
                           [style '(border)]))

;; 创建内容面板
(define content-panel (new vertical-panel% 
                           [parent main-panel]
                           [style '(auto-vscroll)]
                           [border 10]
                           [spacing 10]
                           [stretchable-width #t]
                           [stretchable-height #t]))

;; ============================================================
;; 1. 侧边栏列表控件示例
;; ============================================================
(new message%  
     [parent sidebar-panel]
     [label "1. 侧边栏列表控件"]
     [font (make-object font% 14 'default 'normal 'bold)])

(define sidebar-list
  (new sidebar-list%  
       [parent sidebar-panel]
       [on-select (lambda (item)
                   (show-toast (format "选择了: ~a" (match item [(list-item label _ _ _) label])) #:type 'info))]))

;; 添加菜单项
(define mock-items
  (list (list-item "日历控件" "#FF3B30" 1 #f)
        (list-item "过滤按钮" "#FF9500" 2 #f)
        (list-item "输入框" "#34C759" 3 #f)
        (list-item "提示框" "#007AFF" 4 #f)
        (list-item "待办事项" "#AF52DE" 5 #f)
        (list-item "进度条" "#5AC8FA" 6 #f)))

(send sidebar-list set-items! mock-items)

;; 2. 日历控件示例
(new message%  
     [parent content-panel]
     [label "2. 日历控件"]
     [font (make-object font% 16 'default 'normal 'bold)])

(define calendar
  (new calendar%
       [parent content-panel]
       [on-select-callback (lambda (year month day)
                            (show-toast (format "选择了日期: ~a年~a月~a日" year month day) #:type 'success))]))

;; 3. 过滤按钮控件示例
(new message%
     [parent content-panel]
     [label "3. 过滤按钮控件"]
     [font (make-object font% 16 'default 'normal 'bold)])

(define filter-panel (new horizontal-panel%
                         [parent content-panel]
                         [stretchable-height #f]
                         [border 10]))

(new filter-button%
     [parent filter-panel]
     [label "全部"]
     [icon-symbol "📅"]
     [callback (lambda ()
                (show-toast "选择了: 全部" #:type 'info))])

(new filter-button%
     [parent filter-panel]
     [label "未完成"]
     [icon-symbol "⏱️"]
     [callback (lambda ()
                (show-toast "选择了: 未完成" #:type 'info))])

;; 4. 输入框控件示例
(new message%
     [parent content-panel]
     [label "4. 输入框控件"]
     [font (make-object font% 16 'default 'normal 'bold)])

(new message%
     [parent content-panel]
     [label "姓名: "])

(define name-input
  (new modern-input%
       [parent content-panel]
       [placeholder "请输入您的姓名"]
       [stretchable-width #t]))

;; 5. 提示框控件示例
(new message%
     [parent content-panel]
     [label "5. 提示框控件"]
     [font (make-object font% 16 'default 'normal 'bold)])

(new button%
     [parent content-panel]
     [label "显示成功提示"]
     [callback (lambda (btn evt)
                (show-toast "操作成功！" #:type 'success))])

(new button%
     [parent content-panel]
     [label "显示错误提示"]
     [callback (lambda (btn evt)
                (show-toast "操作失败！" #:type 'error))])

(new button%
     [parent content-panel]
     [label "显示信息提示"]
     [callback (lambda (btn evt)
                (show-toast "这是一条信息。" #:type 'info))])

;; 6. 待办事项列表控件示例 (暂时注释)
;(new message%
;     [parent content-panel]
;     [label "6. 待办事项列表控件"]
;     [font (make-object font% 16 'default 'normal 'bold)])
;
;(define todo-list
;  (new todo-list%
;       [parent content-panel]
;       [on-change (lambda (items)
;                   (show-toast (format "任务列表更新: ~a 项任务" (length items)) #:type 'info))]))
;
;; 添加示例任务
;(send todo-list add-item "学习 Racket 编程")
;(send todo-list add-item "使用 GUI Plus 库")
;(send todo-list add-item "创建应用程序")

;; 7. 时间选择器控件示例
(new message%
     [parent content-panel]
     [label "7. 时间选择器控件"]
     [font (make-object font% 16 'default 'normal 'bold)])

(new message%
     [parent content-panel]
     [label "选择时间: "])

(define time-picker
  (new time-picker%
       [parent content-panel]
       [on-change (lambda (h m)
                    (show-toast (format "选择了时间: ~a:~a" 
                                         (~r h #:min-width 2 #:pad-string "0")
                                         (~r m #:min-width 2 #:pad-string "0")) 
                                 #:type 'info))]))

;; 8. 进度条控件示例
(new message%
     [parent content-panel]
     [label "8. 进度条控件示例"]
     [font (make-object font% 16 'default 'normal 'bold)])

(new message%
     [parent content-panel]
     [label "动态进度演示: "])

(define progress-bar
  (new modern-progress-bar%
       [parent content-panel]
       [min-width 400]
       [stretchable-width #t]))

;; 添加示例按钮控制进度
(define progress-panel (new horizontal-panel%
                           [parent content-panel]
                           [stretchable-height #f]
                           [border 10]
                           [spacing 10]))

(new button%
     [parent progress-panel]
     [label "0%"]
     [callback (lambda (btn evt)
                (send progress-bar set-progress 0.0))])

(new button%
     [parent progress-panel]
     [label "25%"]
     [callback (lambda (btn evt)
                (send progress-bar set-progress 0.25))])

(new button%
     [parent progress-panel]
     [label "50%"]
     [callback (lambda (btn evt)
                (send progress-bar set-progress 0.5))])

(new button%
     [parent progress-panel]
     [label "75%"]
     [callback (lambda (btn evt)
                (send progress-bar set-progress 0.75))])

(new button%
     [parent progress-panel]
     [label "100%"]
     [callback (lambda (btn evt)
                (send progress-bar set-progress 1.0))])

;; 添加定时器来更新进度条动画
(new timer%
     [interval 16]
     [notify-callback
      (lambda ()
        (send progress-bar tick))])

;; 显示窗口
(send frame show #t)

;; 初始提示
(show-toast "欢迎使用 GUI Plus 库！" #:type 'success)