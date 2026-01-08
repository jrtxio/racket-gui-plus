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
    
    ;; 光标相关状态
    (define cursor-pos (string-length current-text))
    (define cursor-visible? #t)
    (define cursor-blink-timer #f)
    
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
            (send dc draw-text current-text 12 12)
            ;; 绘制光标
            (when (and has-focus? cursor-visible?)
              (let-values ([(_ th _1 _2) (send dc get-text-extent "")])
                (define lines (string-split current-text "\n" #:trim? #f))
                (define current-line 0)
                (define current-col 0)
                (define remaining-pos cursor-pos)
                
                ;; 计算光标所在行和列
                (let loop ([lines-left lines] [pos remaining-pos])
                  (when (and (not (null? lines-left)) (> pos 0))
                    (define line-length (string-length (car lines-left)))
                    (if (<= pos line-length)
                        (begin
                          (set! current-col pos)
                          (set! remaining-pos 0))
                        (begin
                          (set! current-line (add1 current-line))
                          (loop (cdr lines-left) (- pos (add1 line-length)))
                          (set! remaining-pos (- pos (add1 line-length)))))))
                
                ;; 计算光标x坐标
                (define line-to-cursor (if (< current-line (length lines))
                                          (car (drop lines current-line))
                                          ""))
                (define cursor-x (+ 12 (let-values ([(cw _1 _2 _3) (send dc get-text-extent (substring line-to-cursor 0 current-col))]) cw) 1))
                (define cursor-y (+ 12 (* (add1 current-line) th) 2))
                
                (send dc set-pen (color-text-main) 2 'solid)
                (send dc draw-line cursor-x cursor-y cursor-x (+ cursor-y th)))))))
    
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
        ;; 普通字符 - 添加到光标位置
        [(char? key)
         (set! current-text (string-append (substring current-text 0 cursor-pos)
                                          (string key)
                                          (substring current-text cursor-pos)))
         (set! cursor-pos (+ cursor-pos 1))
         (set! showing-placeholder? #f)
         (send this refresh)]
        ;; 退格键 - 删除光标前的字符
        [(equal? key 'back)
         (unless (string=? current-text "")
           (when (> cursor-pos 0)
             (set! current-text (string-append (substring current-text 0 (- cursor-pos 1))
                                              (substring current-text cursor-pos)))
             (set! cursor-pos (- cursor-pos 1))
             (set! showing-placeholder? (string=? current-text ""))
             (send this refresh)))]
        ;; 删除键 - 删除光标后的字符
        [(equal? key 'delete)
         (unless (string=? current-text "")
           (when (< cursor-pos (string-length current-text))
             (set! current-text (string-append (substring current-text 0 cursor-pos)
                                              (substring current-text (+ cursor-pos 1))))
             ;; 保持光标位置在正确范围内
             (set! cursor-pos (min cursor-pos (string-length current-text)))
             (set! showing-placeholder? (string=? current-text ""))
             (send this refresh)))]
        ;; 回车键 - 在光标位置换行
        [(equal? key #\return)
         (set! current-text (string-append (substring current-text 0 cursor-pos)
                                          "\n"
                                          (substring current-text cursor-pos)))
         (set! cursor-pos (+ cursor-pos 1))
         (set! showing-placeholder? #f)
         (send this refresh)]
        ;; 制表键 - 添加制表符
        [(equal? key 'tab)
         (set! current-text (string-append (substring current-text 0 cursor-pos)
                                          "\t"
                                          (substring current-text cursor-pos)))
         (set! cursor-pos (+ cursor-pos 1))
         (set! showing-placeholder? #f)
         (send this refresh)]
        ;; 左箭头键 - 光标左移
        [(equal? key 'left)
         (when (> cursor-pos 0)
           (set! cursor-pos (- cursor-pos 1))
           (send this refresh))]
        ;; 右箭头键 - 光标右移
        [(equal? key 'right)
         (when (< cursor-pos (string-length current-text))
           (set! cursor-pos (+ cursor-pos 1))
           (send this refresh))]
        ;; 上箭头键 - 光标上移（简化实现）
        [(equal? key 'up)
         (define lines (string-split current-text "\n" #:trim? #f))
         (define current-line 0)
         (define remaining-pos cursor-pos)
         
         ;; 计算当前行
         (let loop ([lines-left lines] [pos remaining-pos])
           (when (and (not (null? lines-left)) (> pos 0))
             (define line-length (string-length (car lines-left)))
             (if (<= pos line-length)
                 (set! remaining-pos 0)
                 (begin
                   (set! current-line (add1 current-line))
                   (loop (cdr lines-left) (- pos (add1 line-length)))))))
         
         (when (> current-line 0)
           ;; 计算上一行的长度
           (define prev-line-length (string-length (list-ref lines (- current-line 1))))
           ;; 移动到上一行，保持列位置（不超过行长度）
           (set! cursor-pos (- cursor-pos (string-length (list-ref lines current-line)) 1))
           (set! cursor-pos (max 0 (min cursor-pos prev-line-length)))
           (send this refresh))]
        ;; 下箭头键 - 光标下移（简化实现）
        [(equal? key 'down)
         (define lines (string-split current-text "\n" #:trim? #f))
         (define current-line 0)
         (define remaining-pos cursor-pos)
         
         ;; 计算当前行
         (let loop ([lines-left lines] [pos remaining-pos])
           (when (and (not (null? lines-left)) (> pos 0))
             (define line-length (string-length (car lines-left)))
             (if (<= pos line-length)
                 (set! remaining-pos 0)
                 (begin
                   (set! current-line (add1 current-line))
                   (loop (cdr lines-left) (- pos (add1 line-length)))))))
         
         (when (< current-line (- (length lines) 1))
           ;; 计算下一行的长度
           (define next-line-length (string-length (list-ref lines (+ current-line 1))))
           ;; 移动到下一行，保持列位置（不超过行长度）
           (set! cursor-pos (+ cursor-pos (string-length (list-ref lines current-line)) 1))
           (set! cursor-pos (min cursor-pos (+ (string-length current-text) next-line-length)))
           (send this refresh))]
        ;; Home键 - 光标移到行首
        [(equal? key 'home)
         (define lines (string-split current-text "\n" #:trim? #f))
         (define current-line 0)
         (define remaining-pos cursor-pos)
         
         ;; 计算当前行
         (let loop ([lines-left lines] [pos remaining-pos])
           (when (and (not (null? lines-left)) (> pos 0))
             (define line-length (string-length (car lines-left)))
             (if (<= pos line-length)
                 (set! remaining-pos 0)
                 (begin
                   (set! current-line (add1 current-line))
                   (loop (cdr lines-left) (- pos (add1 line-length)))))))
         
         ;; 计算行首位置
         (define start-of-line 0)
         (for ([i (in-range current-line)])
           (set! start-of-line (+ start-of-line (string-length (list-ref lines i)) 1)))
         (set! cursor-pos start-of-line)
         (send this refresh)]
        ;; End键 - 光标移到行尾
        [(equal? key 'end)
         (define lines (string-split current-text "\n" #:trim? #f))
         (define current-line 0)
         (define remaining-pos cursor-pos)
         
         ;; 计算当前行
         (let loop ([lines-left lines] [pos remaining-pos])
           (when (and (not (null? lines-left)) (> pos 0))
             (define line-length (string-length (car lines-left)))
             (if (<= pos line-length)
                 (set! remaining-pos 0)
                 (begin
                   (set! current-line (add1 current-line))
                   (loop (cdr lines-left) (- pos (add1 line-length)))))))
         
         ;; 计算行尾位置
         (define end-of-line 0)
         (for ([i (in-range (add1 current-line))])
           (set! end-of-line (+ end-of-line (string-length (list-ref lines i)) 1)))
         (set! cursor-pos (- end-of-line 1))
         (send this refresh)]
        [else
         (void)]))
    
    ;; 处理焦点变化
    (define/override (on-focus on?)
      (set! has-focus? on?)
      (if on?
          (begin
            ;; 获得焦点时，显示光标并启动闪烁定时器
            (set! cursor-visible? #t)
            (set! cursor-blink-timer (new timer% 
                                         [interval 500] 
                                         [notify-callback (lambda ()
                                                            (set! cursor-visible? (not cursor-visible?))
                                                            (send this refresh))])))
          (begin
            ;; 失去焦点时，隐藏光标并停止定时器
            (set! cursor-visible? #f)
            (when cursor-blink-timer
              (send cursor-blink-timer stop)
              (set! cursor-blink-timer #f))))
      (send this refresh))
    
    ;; 公开方法
    (define/public (get-text)
      current-text)
    
    (define/public (set-text str)
      (set! current-text str)
      (set! cursor-pos (string-length str))
      (set! showing-placeholder? (string=? str ""))
      (send this refresh))
    
    (define/public (clear)
      (set! current-text "")
      (set! cursor-pos 0)
      (set! showing-placeholder? #t)
      (send this refresh))
    
    ))

;; 导出控件类
(provide text-area%)
