#lang racket/gui

;; --- 统一样式配置 ---
;; 采用苹果风格的设计语言
;; 支持主题切换（light/dark）

(require racket/class
         racket/list)

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
   6   ; border-radius-small
   10  ; border-radius-medium
   14  ; border-radius-large
   
   ;; 背景色
   (make-object color% 255 255 255)      ; color-bg-white
   (make-object color% 242 242 247)      ; color-bg-light
   (make-object color% 255 255 255 0.95) ; color-bg-overlay
   
   ;; 边框色
   (make-object color% 200 200 200)      ; color-border
   (make-object color% 170 170 170)      ; color-border-hover
   (make-object color% 0 122 255)        ; color-border-focus
   
   ;; 文字色
   (make-object color% 44 44 46)         ; color-text-main
   (make-object color% 100 100 100)      ; color-text-light
   (make-object color% 160 160 160)      ; color-text-placeholder
   
   ;; 功能色
   (make-object color% 0 122 255)        ; color-accent
   (make-object color% 52 199 89)        ; color-success
   (make-object color% 255 59 48)        ; color-error
   (make-object color% 255 149 0)        ; color-warning
   
   ;; 字体配置
   10  ; font-size-small
   13  ; font-size-regular
   14  ; font-size-medium
   16  ; font-size-large
   (send the-font-list find-or-create-font 10 'default 'normal 'normal)
   (send the-font-list find-or-create-font 13 'default 'normal 'normal)
   (send the-font-list find-or-create-font 14 'default 'normal 'bold)
   (send the-font-list find-or-create-font 16 'default 'normal 'bold)
   
   ;; 控件尺寸配置
   40  ; input-height
   40  ; button-height
   12  ; progress-bar-height
   68  ; toast-height
   340 ; toast-width
   
   ;; 间距配置
   4   ; spacing-small
   10  ; spacing-medium
   14  ; spacing-large
   ))

;; ===========================
;; 暗色主题
;; ===========================
(define dark-theme
  (theme
   ;; 圆角配置
   6   ; border-radius-small
   10  ; border-radius-medium
   14  ; border-radius-large
   
   ;; 背景色
   (make-object color% 28 28 30)         ; color-bg-white
   (make-object color% 44 44 46)         ; color-bg-light
   (make-object color% 28 28 30 0.95)    ; color-bg-overlay
   
   ;; 边框色
   (make-object color% 60 60 60)         ; color-border
   (make-object color% 80 80 80)         ; color-border-hover
   (make-object color% 0 122 255)        ; color-border-focus
   
   ;; 文字色
   (make-object color% 255 255 255)      ; color-text-main
   (make-object color% 170 170 170)      ; color-text-light
   (make-object color% 100 100 100)      ; color-text-placeholder
   
   ;; 功能色
   (make-object color% 0 122 255)        ; color-accent
   (make-object color% 52 199 89)        ; color-success
   (make-object color% 255 59 48)        ; color-error
   (make-object color% 255 149 0)        ; color-warning
   
   ;; 字体配置
   10  ; font-size-small
   13  ; font-size-regular
   14  ; font-size-medium
   16  ; font-size-large
   (send the-font-list find-or-create-font 10 'default 'normal 'normal)
   (send the-font-list find-or-create-font 13 'default 'normal 'normal)
   (send the-font-list find-or-create-font 14 'default 'normal 'bold)
   (send the-font-list find-or-create-font 16 'default 'normal 'bold)
   
   ;; 控件尺寸配置
   40  ; input-height
   40  ; button-height
   12  ; progress-bar-height
   68  ; toast-height
   340 ; toast-width
   
   ;; 间距配置
   4   ; spacing-small
   10  ; spacing-medium
   14  ; spacing-large
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
(define (border-radius-small) (theme-border-radius-small (current-theme)))
(define (border-radius-medium) (theme-border-radius-medium (current-theme)))
(define (border-radius-large) (theme-border-radius-large (current-theme)))

;; 背景色
(define (color-bg-white) (theme-color-bg-white (current-theme)))
(define (color-bg-light) (theme-color-bg-light (current-theme)))
(define (color-bg-overlay) (theme-color-bg-overlay (current-theme)))

;; 边框色
(define (color-border) (theme-color-border (current-theme)))
(define (color-border-hover) (theme-color-border-hover (current-theme)))
(define (color-border-focus) (theme-color-border-focus (current-theme)))

;; 文字色
(define (color-text-main) (theme-color-text-main (current-theme)))
(define (color-text-light) (theme-color-text-light (current-theme)))
(define (color-text-placeholder) (theme-color-text-placeholder (current-theme)))

;; 功能色
(define (color-accent) (theme-color-accent (current-theme)))
(define (color-success) (theme-color-success (current-theme)))
(define (color-error) (theme-color-error (current-theme)))
(define (color-warning) (theme-color-warning (current-theme)))

;; 字体配置
(define (font-size-small) (theme-font-size-small (current-theme)))
(define (font-size-regular) (theme-font-size-regular (current-theme)))
(define (font-size-medium) (theme-font-size-medium (current-theme)))
(define (font-size-large) (theme-font-size-large (current-theme)))
(define (font-small) (theme-font-small (current-theme)))
(define (font-regular) (theme-font-regular (current-theme)))
(define (font-medium) (theme-font-medium (current-theme)))
(define (font-large) (theme-font-large (current-theme)))

;; 控件尺寸配置
(define (input-height) (theme-input-height (current-theme)))
(define (button-height) (theme-button-height (current-theme)))
(define (progress-bar-height) (theme-progress-bar-height (current-theme)))
(define (toast-height) (theme-toast-height (current-theme)))
(define (toast-width) (theme-toast-width (current-theme)))

;; 间距配置
(define (spacing-small) (theme-spacing-small (current-theme)))
(define (spacing-medium) (theme-spacing-medium (current-theme)))
(define (spacing-large) (theme-spacing-large (current-theme)))

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
 border-radius-small
 border-radius-medium
 border-radius-large
 
 ;; 颜色（函数形式，动态获取当前主题值）
 color-bg-white
 color-bg-light
 color-bg-overlay
 color-border
 color-border-hover
 color-border-focus
 color-text-main
 color-text-light
 color-text-placeholder
 color-accent
 color-success
 color-error
 color-warning
 
 ;; 字体（函数形式，动态获取当前主题值）
 font-size-small
 font-size-regular
 font-size-medium
 font-size-large
 font-small
 font-regular
 font-medium
 font-large
 
 ;; 控件尺寸（函数形式，动态获取当前主题值）
 input-height
 button-height
 progress-bar-height
 toast-height
 toast-width
 
 ;; 间距（函数形式，动态获取当前主题值）
 spacing-small
 spacing-medium
 spacing-large)