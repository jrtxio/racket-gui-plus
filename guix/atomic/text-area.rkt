#lang racket/gui

;; Text area component
;; Modern multi-line text input with customizable styles

(require "../style/config.rkt")

(define text-area%
  (class canvas%
    (init-field [placeholder ""] [callback (λ (t) (void))] [init-value ""] [style '()])
    
    ;; 设置初始文本
    (define showing-placeholder? (string=? init-value ""))
    (define current-text init-value)
    
    (super-new [style style]
               [min-height 100]
               [min-width 200])
    
    ;; 注册控件到全局列表，用于主题切换时刷新
    (register-widget this)
    
    ;; 设置为可伸展
    (send this stretchable-width #t)
    (send this stretchable-height #t)
    
    ;; 监听文本变化来隐藏占位符
    (define has-focus? #f)
    
    ;; 绘制方法
    (define/override (on-paint)
      (define dc (send this get-dc))
      (define-values (w h) (send this get-client-size))
      
      (send dc set-smoothing 'smoothed)
      
      ;; 计算边框宽度
      (define border-width (if has-focus? 2 1))
      (define half-border (/ border-width 2.0))
      
      ;; 绘制背景
      (send dc set-brush (color-bg-white) 'solid)
      (send dc set-pen (color-bg-white) 1 'transparent)
      (send dc draw-rectangle 0 0 w h)
      
      ;; 绘制圆角边框
      (send dc set-brush "white" 'transparent)
      (if has-focus?
          (send dc set-pen (color-border-focus) border-width 'solid)
          (send dc set-pen (color-border) border-width 'solid))
      (send dc draw-rounded-rectangle 
            half-border half-border 
            (- w border-width) (- h border-width)
            (border-radius-medium))
      
      ;; 绘制文本或占位符
      (send dc set-font (font-regular))
      (if (and showing-placeholder? (not has-focus?))
          (begin
            (send dc set-text-foreground (color-text-placeholder))
            (send dc draw-text placeholder 12 12))
          (begin
            (send dc set-text-foreground (color-text-main))
            (send dc draw-text current-text 12 12))))
    
    ;; 处理鼠标点击 - 获得焦点
    (define/override (on-event event)
      (when (send event button-down?)
        (send this focus)
        (set! has-focus? #t)
        (send this refresh)))
    
    ;; 处理键盘输入
    (define/override (on-char event)
      (define key (send event get-key-code))
      (cond
        ;; 普通字符 - 添加到文本
        [(char? key)
         (set! current-text (string-append current-text (string key)))
         (set! showing-placeholder? #f)
         (send this refresh)]
        ;; 退格键 - 删除字符
        [(equal? key 'back)
         (unless (string=? current-text "")
           (set! current-text (substring current-text 0 (- (string-length current-text) 1)))
           (set! showing-placeholder? (string=? current-text ""))
           (send this refresh))]
        ;; 回车键 - 换行
        [(equal? key #\return)
         (set! current-text (string-append current-text "\n"))
         (set! showing-placeholder? #f)
         (send this refresh)]
        ;; 制表键 - 添加制表符
        [(equal? key 'tab)
         (set! current-text (string-append current-text "\t"))
         (set! showing-placeholder? #f)
         (send this refresh)]
        ;; 删除键 - 删除光标后字符（简化实现）
        [(equal? key 'delete)
         (unless (string=? current-text "")
           (set! current-text (substring current-text 0 (- (string-length current-text) 1)))
           (set! showing-placeholder? (string=? current-text ""))
           (send this refresh))]))
    
    ;; 处理焦点变化
    (define/override (on-focus on?)
      (set! has-focus? on?)
      (send this refresh))
    
    ;; 公开方法
    (define/public (get-text)
      current-text)
    
    (define/public (set-text str)
      (set! current-text str)
      (set! showing-placeholder? (string=? str ""))
      (send this refresh))
    
    (define/public (clear)
      (set! current-text "")
      (set! showing-placeholder? #t)
      (send this refresh))
    
    ))

;; 导出控件类
(provide text-area%)
