#lang racket/gui

(require "../style-config.rkt")

(define text-field%
  (class canvas%
    (init-field [placeholder ""] [callback (λ (t) (void))] [init-value ""] [style '()])
    
    ;; 过滤掉 canvas% 不支持的样式
    (define filtered-style (filter (λ (s) (not (member s '(single multiple)))) style))
    
    (super-new [style filtered-style]
               [min-height (input-height)]
               [min-width 200])
    
    ;; 设置初始文本
    (define showing-placeholder? (string=? init-value ""))
    (define current-text init-value)
    
    ;; 注册控件到全局列表，用于主题切换时刷新
    (register-widget this)
    
    ;; 设置为可伸展
    (send this stretchable-width #t)
    
    ;; 监听文本变化来隐藏占位符
    (define has-focus? #f)
    
    ;; 设置字体
    (define font (font-regular))
    
    ;; 绘制方法
    (define/override (on-paint)
      (define dc (send this get-dc))
      (define-values (w h) (send this get-client-size))
      
      (send dc set-smoothing 'smoothed)
      
      ;; 计算边框宽度
      (define border-width (if has-focus? 2 1))
      (define half-border (/ border-width 2.0))
      
      ;; 先绘制父背景覆盖整个区域
      (send dc set-brush (color-bg-light) 'solid)
      (send dc set-pen (color-bg-light) 1 'transparent)
      (send dc draw-rectangle 0 0 w h)
      
      ;; 绘制白色圆角背景
      (send dc set-brush (color-bg-white) 'solid)
      (send dc set-pen "white" 0 'transparent)
      (send dc draw-rounded-rectangle 
            border-width border-width 
            (- w (* 2 border-width)) (- h (* 2 border-width))
            (- (border-radius-medium) 1))
      
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
      (send dc set-font font)
      (if (and showing-placeholder? (not has-focus?))
          (begin
            (send dc set-text-foreground (color-text-placeholder))
            (let-values ([(_ th _1 _2) (send dc get-text-extent placeholder)])
              (send dc draw-text placeholder 12 (/ (- h th) 2))))
          (begin
            (send dc set-text-foreground (color-text-main))
            (let-values ([(_ th _1 _2) (send dc get-text-extent current-text)])
              (send dc draw-text current-text 12 (/ (- h th) 2))))))
    
    ;; 处理鼠标点击 - 获得焦点
    (define/override (on-event event)
      (when (send event button-down?)
        (set! has-focus? #t)
        (send this refresh)))
    
    ;; 处理键盘输入
    (define/override (on-char event)
      (define key (send event get-key-code))
      (cond
        ;; 回车键 - 提交
        [(equal? key #\return)
         (unless (string=? (string-trim current-text) "")
           (callback current-text))
         (set! current-text "")
         (set! showing-placeholder? #t)
         (send this refresh)]
        ;; 退格键 - 删除字符
        [(equal? key 'back)
         (unless (string=? current-text "")
           (set! current-text (substring current-text 0 (- (string-length current-text) 1)))
           (set! showing-placeholder? (string=? current-text ""))
           (send this refresh))]
        ;; 普通字符 - 添加到文本
        [(char? key)
         (set! current-text (string-append current-text (string key)))
         (set! showing-placeholder? #f)
         (send this refresh)]))
    
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
    
    )) ; 正确的括号匹配，canvas% 类没有 on-destroy 方法

;; 导出控件类
(provide text-field%)
(provide (rename-out [text-field% modern-input%]))
