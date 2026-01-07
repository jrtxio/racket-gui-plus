#lang racket/gui

;; --- 统一样式配置 ---;;
;; 采用苹果风格的设计语言
;; 支持主题切换（light/dark）

(require racket/class)
(require racket/list)

;; ===========================
;; 主题定义
;; ===========================

;; 定义主题结构体
(struct theme (
  ;; 圆角配置
  border-radius-small
  border-radius-medium
  border-radius-large
  
  ;; 背景色
  color-bg-white
  color-bg-light
  color-bg-overlay
  
  ;; 边框色
  color-border
  color-border-hover
  color-border-focus
  
  ;; 文字色
  color-text-main
  color-text-light
  color-text-placeholder
  
  ;; 功能色
  color-accent
  color-success
  color-error
  color-warning
  
  ;; 字体配置
  font-size-small
  font-size-regular
  font-size-medium
  font-size-large
  font-small
  font-regular
  font-medium
  font-large
  
  ;; 控件尺寸配置
  input-height
  button-height
  progress-bar-height
  toast-height
  toast-width
  
  ;; 间距配置
  spacing-small
  spacing-medium
  spacing-large
))

;; ===========================
;; 亮色主题
;; ===========================
(define light-theme
  (theme
   ;; 圆角配置
   6   ; BORDER-RADIUS-SMALL
   10  ; BORDER-RADIUS-MEDIUM
   14  ; BORDER-RADIUS-LARGE
   
   ;; 背景色
   (make-object color% 255 255 255)      ; COLOR-BG-WHITE
   (make-object color% 242 242 247)      ; COLOR-BG-LIGHT
   (make-object color% 255 255 255 0.95) ; COLOR-BG-OVERLAY
   
   ;; 边框色
   (make-object color% 200 200 200)      ; COLOR-BORDER
   (make-object color% 170 170 170)      ; COLOR-BORDER-HOVER
   (make-object color% 0 122 255)        ; COLOR-BORDER-FOCUS
   
   ;; 文字色
   (make-object color% 44 44 46)         ; COLOR-TEXT-MAIN
   (make-object color% 100 100 100)      ; COLOR-TEXT-LIGHT
   (make-object color% 160 160 160)      ; COLOR-TEXT-PLACEHOLDER
   
   ;; 功能色
   (make-object color% 0 122 255)        ; COLOR-ACCENT
   (make-object color% 52 199 89)        ; COLOR-SUCCESS
   (make-object color% 255 59 48)        ; COLOR-ERROR
   (make-object color% 255 149 0)        ; COLOR-WARNING
   
   ;; 字体配置
   10  ; FONT-SIZE-SMALL
   13  ; FONT-SIZE-REGULAR
   14  ; FONT-SIZE-MEDIUM
   16  ; FONT-SIZE-LARGE
   (send the-font-list find-or-create-font 10 'default 'normal 'normal)
   (send the-font-list find-or-create-font 13 'default 'normal 'normal)
   (send the-font-list find-or-create-font 14 'default 'normal 'bold)
   (send the-font-list find-or-create-font 16 'default 'normal 'bold)
   
   ;; 控件尺寸配置
   40  ; INPUT-HEIGHT
   40  ; BUTTON-HEIGHT
   12  ; PROGRESS-BAR-HEIGHT
   68  ; TOAST-HEIGHT
   340 ; TOAST-WIDTH
   
   ;; 间距配置
   4   ; SPACING-SMALL
   10  ; SPACING-MEDIUM
   14  ; SPACING-LARGE
   ))

;; ===========================
;; 暗色主题
;; ===========================
(define dark-theme
  (theme
   ;; 圆角配置
   6   ; BORDER-RADIUS-SMALL
   10  ; BORDER-RADIUS-MEDIUM
   14  ; BORDER-RADIUS-LARGE
   
   ;; 背景色
   (make-object color% 28 28 30)         ; COLOR-BG-WHITE
   (make-object color% 44 44 46)         ; COLOR-BG-LIGHT
   (make-object color% 28 28 30 0.95)    ; COLOR-BG-OVERLAY
   
   ;; 边框色
   (make-object color% 60 60 60)         ; COLOR-BORDER
   (make-object color% 80 80 80)         ; COLOR-BORDER-HOVER
   (make-object color% 0 122 255)        ; COLOR-BORDER-FOCUS
   
   ;; 文字色
   (make-object color% 255 255 255)      ; COLOR-TEXT-MAIN
   (make-object color% 170 170 170)      ; COLOR-TEXT-LIGHT
   (make-object color% 100 100 100)      ; COLOR-TEXT-PLACEHOLDER
   
   ;; 功能色
   (make-object color% 0 122 255)        ; COLOR-ACCENT
   (make-object color% 52 199 89)        ; COLOR-SUCCESS
   (make-object color% 255 59 48)        ; COLOR-ERROR
   (make-object color% 255 149 0)        ; COLOR-WARNING
   
   ;; 字体配置
   10  ; FONT-SIZE-SMALL
   13  ; FONT-SIZE-REGULAR
   14  ; FONT-SIZE-MEDIUM
   16  ; FONT-SIZE-LARGE
   (send the-font-list find-or-create-font 10 'default 'normal 'normal)
   (send the-font-list find-or-create-font 13 'default 'normal 'normal)
   (send the-font-list find-or-create-font 14 'default 'normal 'bold)
   (send the-font-list find-or-create-font 16 'default 'normal 'bold)
   
   ;; 控件尺寸配置
   40  ; INPUT-HEIGHT
   40  ; BUTTON-HEIGHT
   12  ; PROGRESS-BAR-HEIGHT
   68  ; TOAST-HEIGHT
   340 ; TOAST-WIDTH
   
   ;; 间距配置
   4   ; SPACING-SMALL
   10  ; SPACING-MEDIUM
   14  ; SPACING-LARGE
   ))

;; ===========================
;; 主题切换机制
;; ===========================

;; 当前主题
(define current-theme (make-parameter light-theme))

;; 主题变更回调函数列表
(define theme-change-callbacks '())

;; 所有已创建的控件列表，用于主题切换时全局刷新
(define all-widgets '())

;; 注册主题变更回调
(define (register-theme-callback callback)
  (set! theme-change-callbacks (append theme-change-callbacks (list callback))))

;; 移除主题变更回调
(define (unregister-theme-callback callback)
  (set! theme-change-callbacks (remove callback theme-change-callbacks)))

;; 注册控件，用于主题切换时刷新
(define (register-widget widget)
  (set! all-widgets (cons widget all-widgets)))

;; 取消注册控件
(define (unregister-widget widget)
  (set! all-widgets (remove widget all-widgets)))

;; 全局刷新所有控件
(define (refresh-all-widgets)
  (for-each (λ (widget) 
              (when (is-a? widget area<%>) 
                (send widget refresh))) 
            all-widgets))

;; 切换主题
(define (set-theme! new-theme)
  (cond
    [(equal? new-theme 'light)
     (current-theme light-theme)
     (for-each (λ (callback) (callback light-theme)) theme-change-callbacks)
     (refresh-all-widgets)]
    [(equal? new-theme 'dark)
     (current-theme dark-theme)
     (for-each (λ (callback) (callback dark-theme)) theme-change-callbacks)
     (refresh-all-widgets)]
    [(theme? new-theme)
     (current-theme new-theme)
     (for-each (λ (callback) (callback new-theme)) theme-change-callbacks)
     (refresh-all-widgets)]))

;; ===========================
;; 便捷访问当前主题属性
;; ===========================

;; 圆角配置
(define (BORDER-RADIUS-SMALL) (theme-border-radius-small (current-theme)))
(define (BORDER-RADIUS-MEDIUM) (theme-border-radius-medium (current-theme)))
(define (BORDER-RADIUS-LARGE) (theme-border-radius-large (current-theme)))

;; 背景色
(define (COLOR-BG-WHITE) (theme-color-bg-white (current-theme)))
(define (COLOR-BG-LIGHT) (theme-color-bg-light (current-theme)))
(define (COLOR-BG-OVERLAY) (theme-color-bg-overlay (current-theme)))

;; 边框色
(define (COLOR-BORDER) (theme-color-border (current-theme)))
(define (COLOR-BORDER-HOVER) (theme-color-border-hover (current-theme)))
(define (COLOR-BORDER-FOCUS) (theme-color-border-focus (current-theme)))

;; 文字色
(define (COLOR-TEXT-MAIN) (theme-color-text-main (current-theme)))
(define (COLOR-TEXT-LIGHT) (theme-color-text-light (current-theme)))
(define (COLOR-TEXT-PLACEHOLDER) (theme-color-text-placeholder (current-theme)))

;; 功能色
(define (COLOR-ACCENT) (theme-color-accent (current-theme)))
(define (COLOR-SUCCESS) (theme-color-success (current-theme)))
(define (COLOR-ERROR) (theme-color-error (current-theme)))
(define (COLOR-WARNING) (theme-color-warning (current-theme)))

;; 字体配置
(define (FONT-SIZE-SMALL) (theme-font-size-small (current-theme)))
(define (FONT-SIZE-REGULAR) (theme-font-size-regular (current-theme)))
(define (FONT-SIZE-MEDIUM) (theme-font-size-medium (current-theme)))
(define (FONT-SIZE-LARGE) (theme-font-size-large (current-theme)))
(define (FONT-SMALL) (theme-font-small (current-theme)))
(define (FONT-REGULAR) (theme-font-regular (current-theme)))
(define (FONT-MEDIUM) (theme-font-medium (current-theme)))
(define (FONT-LARGE) (theme-font-large (current-theme)))

;; 控件尺寸配置
(define (INPUT-HEIGHT) (theme-input-height (current-theme)))
(define (BUTTON-HEIGHT) (theme-button-height (current-theme)))
(define (PROGRESS-BAR-HEIGHT) (theme-progress-bar-height (current-theme)))
(define (TOAST-HEIGHT) (theme-toast-height (current-theme)))
(define (TOAST-WIDTH) (theme-toast-width (current-theme)))

;; 间距配置
(define (SPACING-SMALL) (theme-spacing-small (current-theme)))
(define (SPACING-MEDIUM) (theme-spacing-medium (current-theme)))
(define (SPACING-LARGE) (theme-spacing-large (current-theme)))

;; ===========================
;; 导出所有样式常量和主题功能
;; ===========================
(provide 
 ;; 主题结构体
 theme
 
 ;; 主题实例
 light-theme
 dark-theme
 
 ;; 主题切换
 current-theme
 set-theme!
 register-theme-callback
 unregister-theme-callback
 register-widget
 unregister-widget
 refresh-all-widgets
 
 ;; 圆角（函数形式，动态获取当前主题值）
 BORDER-RADIUS-SMALL
 BORDER-RADIUS-MEDIUM
 BORDER-RADIUS-LARGE
 
 ;; 颜色（函数形式，动态获取当前主题值）
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
 
 ;; 字体（函数形式，动态获取当前主题值）
 FONT-SIZE-SMALL
 FONT-SIZE-REGULAR
 FONT-SIZE-MEDIUM
 FONT-SIZE-LARGE
 FONT-SMALL
 FONT-REGULAR
 FONT-MEDIUM
 FONT-LARGE
 
 ;; 控件尺寸（函数形式，动态获取当前主题值）
 INPUT-HEIGHT
 BUTTON-HEIGHT
 PROGRESS-BAR-HEIGHT
 TOAST-HEIGHT
 TOAST-WIDTH
 
 ;; 间距（函数形式，动态获取当前主题值）
 SPACING-SMALL
 SPACING-MEDIUM
 SPACING-LARGE)