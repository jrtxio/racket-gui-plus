#lang racket/gui

(define modern-input%
  (class editor-canvas%
    (init-field [placeholder ""] [callback (λ (t) (void))])
    
    ;; 禁止滚动条并设置尺寸约束
    (super-new [style '(no-hscroll no-vscroll)]
               [min-height 40]
               [min-width 200])
    
    ;; 设置为可伸展
    (send this stretchable-width #t)
    
    ;; 监听文本变化来隐藏占位符
    (define showing-placeholder? #t)
    
    ;; 设置字体
    (define font (send the-font-list find-or-create-font 13 'default 'normal 'normal))
    
    (define text (new text%))
    (send this set-editor text)
    
    ;; 关键：让编辑器可编辑
    (send text lock #f)
    
    ;; 设置字体样式
    (define style-delta (new style-delta%))
    (send style-delta set-delta 'change-size 13)
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
      (super on-paint)
      (define dc (send this get-dc))
      (define-values (w h) (send this get-client-size))
      
      (define has-focus? (send this has-focus?))
      
      ;; 绘制边框
      (if has-focus?
          (send dc set-pen (make-object color% 0 122 255) 2 'solid)
          (send dc set-pen (make-object color% 200 200 200) 1 'solid))
      
      (send dc set-brush "white" 'transparent)
      (send dc draw-rounded-rectangle 0 0 w h 8) ; 使用统一的圆角
      
      ;; 绘制占位符
      (when (and showing-placeholder? (not has-focus?))
        (send dc set-text-foreground (make-object color% 160 160 160))
        (send dc set-font font)
        (send dc draw-text placeholder 10 10)))
    
    (define/override (on-focus on?)
      (super on-focus on?)
      (send this refresh))))

;; 导出现代风格输入框控件类
(provide modern-input%)