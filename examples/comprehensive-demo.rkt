#lang racket/gui

;; Guix 库综合示例
;; 展示如何使用所有控件
(require racket/class
         racket/list
         "../guix/guix.rkt")

;; 创建主窗口
(define frame (new frame%
                   [label "Guix 综合示例"]
                   [width 800]
                   [height 600]))

;; 创建主面板，水平布局
(define main-panel (new horizontal-panel%
                       [parent frame]
                       [spacing 0]))

;; 创建侧边栏面板
(define sidebar-panel (new vertical-panel%
                           [parent main-panel]
                           [stretchable-width #f]
                           [stretchable-height #t]
                           [min-width 200]
                           [style '(border)]
                           [spacing 5] ; Add spacing to control vertical space between panel items
                           ))

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
(new label%
     [parent sidebar-panel]
     [label "1. 侧边栏列表控件"]
     [font-size 'large])

(define sidebar-list
  (new sidebar-list%
       [parent sidebar-panel]
       [on-select (lambda (item)
                   (show-toast (format "选择了: ~a" (send item get-label)) #:type 'info))]))

;; 添加菜单项
(define mock-items
  (list (new list-item [label "日历控件"] [color (make-object color% 255 59 48)] [count 1])
        (new list-item [label "时间选择器"] [color (make-object color% 255 149 0)] [count 2])
        (new list-item [label "过滤按钮"] [color (make-object color% 52 199 89)] [count 3])
        (new list-item [label "输入控件"] [color (make-object color% 0 122 255)] [count 4])
        (new list-item [label "提示框"] [color (make-object color% 175 82 222)] [count 5])
        (new list-item [label "进度条"] [color (make-object color% 255 45 85)] [count 6])
        (new list-item [label "其他控件"] [color (make-object color% 142 142 147)] [count 7])))

(send sidebar-list set-items! mock-items)

;; ============================================================
;; 2. 日历控件示例
;; ============================================================
(new label%
     [parent content-panel]
     [label "2. 日历控件"]
     [font-size 'x-large])

(define calendar
  (new calendar%
       [parent content-panel]
       [on-select-callback (lambda (year month day)
                            (show-toast (format "选择了日期: ~a年~a月~a日" year month day) #:type 'success))]))

;; ============================================================
;; 3. 时间选择器控件示例
;; ============================================================
(new label%
     [parent content-panel]
     [label "3. 时间选择器控件"]
     [font-size 'x-large])

(new label%
     [parent content-panel]
     [label "时间选择器: "])

(define time-picker
  (new time-picker%
       [parent content-panel]
       [on-change (lambda (h m)
                    (show-toast (format "选择了时间: ~a:~a" 
                                         (~r h #:min-width 2 #:pad-string "0")
                                         (~r m #:min-width 2 #:pad-string "0")) 
                                 #:type 'info))]))

(new label%
     [parent content-panel]
     [label "日期时间选择器: "])

(define date-time-picker
  (new date-time-picker%
       [parent content-panel]
       [on-change (lambda (date time)
                    (show-toast (format "选择了日期时间: ~a ~a:~a" 
                                         date
                                         (~r (car time) #:min-width 2 #:pad-string "0")
                                         (~r (cdr time) #:min-width 2 #:pad-string "0")) 
                                 #:type 'info))]))

;; ============================================================
;; 4. 过滤按钮控件示例
;; ============================================================
(new label%
     [parent content-panel]
     [label "4. 过滤按钮控件"]
     [font-size 'x-large])

(define filter-panel (new horizontal-panel%
                         [parent content-panel]
                         [stretchable-height #f]
                         [border 10]))

(new category-card%
     [parent filter-panel]
     [label "全部"]
     [icon-symbol "📅"]
     [on-click (lambda ()
                (show-toast "选择了: 全部" #:type 'info))])

(new category-card%
     [parent filter-panel]
     [label "未完成"]
     [icon-symbol "⏱️"]
     [on-click (lambda ()
                (show-toast "选择了: 未完成" #:type 'info))])

(new category-card%
     [parent filter-panel]
     [label "已完成"]
     [icon-symbol "✅"]
     [on-click (lambda ()
                (show-toast "选择了: 已完成" #:type 'info))])

;; ============================================================
;; 5. 输入控件示例
;; ============================================================
(new label%
     [parent content-panel]
     [label "5. 输入控件示例"]
     [font-size 'x-large])

(new label%
     [parent content-panel]
     [label "普通输入框: "])

(define name-input
  (new text-field%
       [parent content-panel]
       [placeholder "请输入您的姓名"]
       [stretchable-width #t]))

(new label%
     [parent content-panel]
     [label "搜索框: "])

(define search-input
  (new search-field%
       [parent content-panel]
       [placeholder "搜索..."]
       [stretchable-width #t]
       [callback (lambda (field)
                   (show-toast (format "搜索: ~a" (send field get-text)) #:type 'info))]))

;; 步进输入框控件（暂时注释，等待库修复）
;(new label%
;     [parent content-panel]
;     [label "步进输入框: "])

;(define stepper-input
;  (new stepper-input%
;       [parent content-panel]
;       [init-value 50]
;       [min-value 0]
;       [max-value 100]
;       [step 5]
;       [stretchable-width #t]
;       [callback (lambda (component)
;                   (show-toast (format "步进值: ~a" (send component get-value)) #:type 'info))]))

;; ============================================================
;; 6. 提示框控件示例
;; ============================================================
(new label%
     [parent content-panel]
     [label "6. 提示框控件"]
     [font-size 'x-large])

(define toast-buttons-panel (new horizontal-panel%
                                [parent content-panel]
                                [spacing 10]))

(new modern-button%
     [parent toast-buttons-panel]
     [label "显示成功提示"]
     [on-click (lambda ()
                (show-toast "操作成功！" #:type 'success))])

(new modern-button%
     [parent toast-buttons-panel]
     [label "显示错误提示"]
     [on-click (lambda ()
                (show-toast "操作失败！" #:type 'error))])

(new modern-button%
     [parent toast-buttons-panel]
     [label "显示信息提示"]
     [on-click (lambda ()
                (show-toast "这是一条信息。" #:type 'info))])

;; ============================================================
;; 8. 进度条控件示例
;; ============================================================
(new label%
     [parent content-panel]
     [label "7. 进度条控件示例"]
     [font-size 'x-large])

(new label%
     [parent content-panel]
     [label "动态进度演示: "])

(define progress-bar
  (new modern-progress-bar%
       [parent content-panel]
       [stretchable-width #t]))

;; 添加示例按钮控制进度
(define progress-panel (new horizontal-panel%
                           [parent content-panel]
                           [stretchable-height #f]
                           [border 10]
                           [spacing 10]))

(new modern-button%
     [parent progress-panel]
     [label "0%"]
     [on-click (lambda ()
                (send progress-bar set-progress 0.0))])

(new modern-button%
     [parent progress-panel]
     [label "25%"]
     [on-click (lambda ()
                (send progress-bar set-progress 0.25))])

(new modern-button%
     [parent progress-panel]
     [label "50%"]
     [on-click (lambda ()
                (send progress-bar set-progress 0.5))])

(new modern-button%
     [parent progress-panel]
     [label "75%"]
     [on-click (lambda ()
                (send progress-bar set-progress 0.75))])

(new modern-button%
     [parent progress-panel]
     [label "100%"]
     [on-click (lambda ()
                (send progress-bar set-progress 1.0))])

;; 添加定时器来更新进度条动画
(new timer%
     [interval 16]
     [notify-callback
      (lambda ()
        (send progress-bar tick))])

;; ============================================================
;; 9. 其他控件示例
;; ============================================================
(new label%
     [parent content-panel]
     [label "8. 其他控件示例"]
     [font-size 'x-large])

;; 开关控件
(new label%
     [parent content-panel]
     [label "开关控件: "])

(define switch-panel (new horizontal-panel%
                         [parent content-panel]
                         [alignment '(left center)]
                         [spacing 10]))

(new switch%
     [parent switch-panel]
     [callback (lambda (component event)
                (show-toast (format "开关状态: ~a" (send component get-checked)) #:type 'info))])

(new label%
     [parent switch-panel]
     [label "开关描述"])

;; 复选框控件
(new label%
     [parent content-panel]
     [label "复选框控件: "])

(define checkbox-panel (new horizontal-panel%
                          [parent content-panel]
                          [alignment '(left center)]
                          [spacing 10]))

(new checkbox%
     [parent checkbox-panel]
     [label "选项1"]
     [callback (lambda (component event)
                (show-toast (format "选项1状态: ~a" (send component get-checked)) #:type 'info))])

(new checkbox%
     [parent checkbox-panel]
     [label "选项2"]
     [callback (lambda (component event)
                (show-toast (format "选项2状态: ~a" (send component get-checked)) #:type 'info))])

;; 单选按钮控件
(new label%
     [parent content-panel]
     [label "单选按钮控件: "])

(define radio-group (new radio-box%
                        [parent content-panel]
                        [label ""]
                        [style '(horizontal)]
                        [choices '("选项A" "选项B" "选项C")]
                        [callback (lambda (rb evt)
                                  (show-toast (format "选择了: ~a" (send rb get-selection)) #:type 'info))]))

;; 滑块控件
(new label%
     [parent content-panel]
     [label "滑块控件: "])

(define slider
  (new modern-slider%
       [parent content-panel]
       [label ""]
       [min-value 0]
       [max-value 100]
       [init-value 50]
       [stretchable-width #t]
       [callback (lambda (sld evt)
                  (show-toast (format "滑块值: ~a" (send sld get-value)) #:type 'info))]))

;; 分段控制器
(new label%
     [parent content-panel]
     [label "分段控制器: "])

(define segmented-control
  (new segmented-control%
       [parent content-panel]
       [segments '("选项1" "选项2" "选项3")]
       [callback (lambda (index)
                  (show-toast (format "选择了分段: ~a" index) #:type 'info))]))

;; ============================================================
;; 10. 主题切换功能
;; ============================================================
(new label%
     [parent content-panel]
     [label "9. 主题切换功能"]
     [font-size 'x-large])

(define theme-toggle-panel (new horizontal-panel%
                              [parent content-panel]
                              [alignment '(left center)]
                              [spacing 10]
                              [border 10]))

(define current-theme (make-parameter 'light))

(new label%
     [parent theme-toggle-panel]
     [label "当前主题: "])

(define theme-label (new label%
                        [parent theme-toggle-panel]
                        [label (symbol->string (current-theme))]
                        [font-size 'medium]))

(new modern-button%
     [parent theme-toggle-panel]
     [label "切换主题"]
     [on-click (lambda ()
                (if (eq? (current-theme) 'light)
                    (begin
                      (set-theme! 'dark)
                      (current-theme 'dark)
                      (send theme-label set-label "dark"))
                    (begin
                      (set-theme! 'light)
                      (current-theme 'light)
                      (send theme-label set-label "light"))))])

;; 显示窗口
(send frame show #t)

;; 初始提示
(show-toast "欢迎使用 Guix 库！" #:type 'success)
