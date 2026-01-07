#lang racket/gui
(require racket/draw
         "../style-config.rkt")

(define filter-button%
  (class canvas%
    (init-field [label "Today"]
                [count 0]
                [bg-color (color-accent)]
                [icon-symbol "📅"]
                [parent-bg (color-bg-light)]
                [callback (λ () (void))])
    
    (super-new [style '(no-focus)] 
               [min-width 160] 
               [min-height 90])
    
    (define hover? #f)
    (define pressed? #f)
    
    (define/private (adjust-color c amount)
      (define (clamp v) (max 0 (min 255 (round v))))
      (make-object color% (clamp (+ (send c red) amount))
                          (clamp (+ (send c green) amount))
                          (clamp (+ (send c blue) amount))))

    (define/override (on-paint)
      (define dc (send this get-dc))
      (define-values (w h) (send this get-client-size))
      (send dc set-smoothing 'smoothed)
      
      ;; 1. 背景同步(消除四个角的白边)
      (send dc set-brush parent-bg 'solid)
      (send dc set-pen parent-bg 1 'transparent)
      (send dc draw-rectangle 0 0 w h)
      
      ;; 2. 按钮主体
      (define draw-color (cond [pressed? (adjust-color bg-color -20)]
                               [hover? (adjust-color bg-color 15)]
                               [else bg-color]))
      (send dc set-brush draw-color 'solid)
      (send dc set-pen draw-color 1 'transparent)
      (send dc draw-rounded-rectangle 0 0 w h (border-radius-large))

      ;; 3. 文字和图标
      (define pad 15) 
      (send dc set-text-foreground "white")
      (send dc set-font (make-object font% 20 'swiss 'normal 'normal))
      (send dc draw-text icon-symbol pad pad)
      
      (send dc set-font (make-object font% 26 'swiss 'normal 'bold))
      (let* ([count-str (number->string count)]
             [tw-val (let-values ([(tw th _1 _2) (send dc get-text-extent count-str)]) tw)])
        (send dc draw-text count-str (- w tw-val pad 5) pad))
      
      (send dc set-text-foreground (make-object color% 245 245 245))
      (send dc set-font (make-object font% 13 'swiss 'normal 'bold))
      (send dc draw-text label pad (- h 32)))
    
    (define/override (on-event event)
      (define type (send event get-event-type))
      (cond 
        ;; 鼠标进入
        [(eq? type 'enter)
         (set! hover? #t)
         (send this refresh)]
        
        ;; 鼠标离开
        [(eq? type 'leave)
         (set! hover? #f)
         (set! pressed? #f)
         (send this refresh)]
        
        ;; 鼠标按下:关键点 - 显式获取焦点并记录按下状态
        [(send event button-down? 'left)
         (set! pressed? #t)
         (send this refresh)]
        
        ;; 鼠标抬起:只有在之前是按下状态时才触发 callback
        [(send event button-up? 'left)
         (when pressed?
           (set! pressed? #f)
           (send this refresh)
           ;; 立即执行回调
           (callback))]))
    ))

;; 导出过滤按钮控件类
(provide filter-button%)