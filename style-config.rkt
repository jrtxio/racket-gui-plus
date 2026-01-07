#lang racket/gui

;; --- 统一样式配置 ---;;
;; 采用苹果风格的设计语言
;; 所有控件共用的样式常量

(require racket/class)

;; ===========================
;; 圆角配置
;; ===========================
(define BORDER-RADIUS-SMALL 6)   ; 小控件圆角（如列表项）
(define BORDER-RADIUS-MEDIUM 10)  ; 中等控件圆角（如输入框、按钮）
(define BORDER-RADIUS-LARGE 14)   ; 大控件圆角（如通知框、对话框）

;; ===========================
;; 颜色配置
;; 采用苹果风格的亮色模式
;; ===========================

;; 背景色
(define COLOR-BG-WHITE        (make-object color% 255 255 255))      ; 纯白色
(define COLOR-BG-LIGHT        (make-object color% 242 242 247))      ; 极浅灰背景
(define COLOR-BG-OVERLAY      (make-object color% 255 255 255 0.95)) ; 半透明背景

;; 边框色
(define COLOR-BORDER          (make-object color% 200 200 200))      ; 浅灰边框
(define COLOR-BORDER-HOVER    (make-object color% 170 170 170))      ; 悬停状态边框
(define COLOR-BORDER-FOCUS    (make-object color% 0 122 255))        ; 聚焦状态边框

;; 文字色
(define COLOR-TEXT-MAIN       (make-object color% 44 44 46))         ; 深文字色
(define COLOR-TEXT-LIGHT      (make-object color% 100 100 100))      ; 浅文字色
(define COLOR-TEXT-PLACEHOLDER (make-object color% 160 160 160))     ; 占位符文字色

;; 功能色
(define COLOR-ACCENT          (make-object color% 0 122 255))        ; 苹果蓝（主色调）
(define COLOR-SUCCESS         (make-object color% 52 199 89))        ; 成功绿
(define COLOR-ERROR           (make-object color% 255 59 48))        ; 错误红
(define COLOR-WARNING         (make-object color% 255 149 0))        ; 警告橙

;; ===========================
;; 字体配置
;; ===========================
(define FONT-SIZE-SMALL 10)   ; 小号字体
(define FONT-SIZE-REGULAR 13) ; 常规字体
(define FONT-SIZE-MEDIUM 14)  ; 中号字体
(define FONT-SIZE-LARGE 16)   ; 大号字体

;; 字体对象
(define FONT-SMALL  (send the-font-list find-or-create-font FONT-SIZE-SMALL 'default 'normal 'normal))
(define FONT-REGULAR (send the-font-list find-or-create-font FONT-SIZE-REGULAR 'default 'normal 'normal))
(define FONT-MEDIUM  (send the-font-list find-or-create-font FONT-SIZE-MEDIUM 'default 'normal 'bold))
(define FONT-LARGE   (send the-font-list find-or-create-font FONT-SIZE-LARGE 'default 'normal 'bold))

;; ===========================
;; 控件尺寸配置
;; ===========================
(define INPUT-HEIGHT 40)       ; 输入框高度
(define BUTTON-HEIGHT 40)       ; 按钮高度
(define PROGRESS-BAR-HEIGHT 12) ; 进度条高度
(define TOAST-HEIGHT 68)        ; 通知框高度
(define TOAST-WIDTH 340)        ; 通知框宽度

;; ===========================
;; 间距配置
;; ===========================
(define SPACING-SMALL 4)        ; 小间距
(define SPACING-MEDIUM 10)      ; 中间距
(define SPACING-LARGE 14)       ; 大间距

;; ===========================
;; 导出所有样式常量
;; ===========================
(provide 
 ;; 圆角
 BORDER-RADIUS-SMALL
 BORDER-RADIUS-MEDIUM
 BORDER-RADIUS-LARGE
 
 ;; 颜色
 COLOR-BG-WHITE
 COLOR-BG-LIGHT
 COLOR-BG-OVERLAY
 COLOR-BORDER
 COLOR-BORDER-HOVER
 COLOR-BORDER-FOCUS
 COLOR-TEXT-MAIN
 COLOR-TEXT-LIGHT
 COLOR-TEXT-PLACEHOLDER
 COLOR-ACCENT
 COLOR-SUCCESS
 COLOR-ERROR
 COLOR-WARNING
 
 ;; 字体
 FONT-SIZE-SMALL
 FONT-SIZE-REGULAR
 FONT-SIZE-MEDIUM
 FONT-SIZE-LARGE
 FONT-SMALL
 FONT-REGULAR
 FONT-MEDIUM
 FONT-LARGE
 
 ;; 控件尺寸
 INPUT-HEIGHT
 BUTTON-HEIGHT
 PROGRESS-BAR-HEIGHT
 TOAST-HEIGHT
 TOAST-WIDTH
 
 ;; 间距
 SPACING-SMALL
 SPACING-MEDIUM
 SPACING-LARGE)