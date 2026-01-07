#lang racket/gui

(require "style-config.rkt")

(define modern-input%
  (class editor-canvas%
    (init-field [placeholder ""] [callback (λ (t) (void))] [parent-bg COLOR-BG-LIGHT])
    
    ;; 禁止滚动条并设置尺寸约束
    (super-new [style '(no-hscroll no-vscroll transparent)]
               [min-height INPUT-HEIGHT]
               [min-width 200])
    
    ;; 设置为可伸展
    (send this stretchable-width #t)
    
    ;; 监听文本变化来隐藏占位符
    (define showing-placeholder? #t)
    
    ;; 设置字体
    (define font FONT-REGULAR)
    
    (define text (new text%))
    (send this set-editor text)
    
    ;; 关键：让编辑器可编辑
    (send text lock #f)
    
    ;; 设置字体样式
    (define style-delta (new style-delta%))
    (send style-delta set-delta 'change-size FONT-SIZE-REGULAR)
    (send text change-style style-delta)
    
    ;; 处理回车键提交
    (define/override (on-char event)
      (cond
        [(equal? (send event get-key-code) #\return)
         (define content (send text get-text))
         ;; 只有非空内容才处理
         (unless (string=? (string-trim content) "")
           (callback content))
         (send text erase)
         (set! showing-placeholder? #t)
         (send this refresh)]
        [else
         (super on-char event)
         (set! showing-placeholder? (= (send text last-position) 0))
         (send this refresh)]))
    
    (define/override (on-paint)
      (define dc (send this get-dc))
      (define-values (w h) (send this get-client-size))
      
      (define has-focus? (send this has-focus?))
      
      (send dc set-smoothing 'smoothed)
      
      ;; 关键：不调用clear，而是手动绘制所有内容
      
      ;; 1. 绘制控件背景(消除圆角外侧的直角)
      (send dc set-brush parent-bg 'solid)
      (send dc set-pen parent-bg 1 'solid)
      (send dc draw-rectangle 0 0 w h)
      
      ;; 2. 绘制输入框主体背景
      (send dc set-brush COLOR-BG-WHITE 'solid)
      (send dc set-pen COLOR-BG-WHITE 1 'solid)
      (send dc draw-rounded-rectangle 1 1 (- w 2) (- h 2) BORDER-RADIUS-MEDIUM)
      
      ;; 3. 绘制边框
      (send dc set-brush "white" 'transparent)
      (if has-focus?
          (send dc set-pen COLOR-BORDER-FOCUS 2 'solid)
          (send dc set-pen COLOR-BORDER 1 'solid))
      (send dc draw-rounded-rectangle 0 0 (- w 1) (- h 1) BORDER-RADIUS-MEDIUM)
      
      ;; 3. 绘制占位符
      (when (and showing-placeholder? (not has-focus?))
        (send dc set-text-foreground COLOR-TEXT-PLACEHOLDER)
        (send dc set-font font)
        (let-values ([(_ th _1 _2) (send dc get-text-extent placeholder)])
          (send dc draw-text placeholder 10 (/ (- h th) 2)))))
    
    (define/override (on-focus on?)
      (super on-focus on?)
      (send this refresh))))

;; 导出现代风格输入框控件类
(provide modern-input%)