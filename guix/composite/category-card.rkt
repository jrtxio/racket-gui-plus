#lang racket/gui

(require racket/draw
         "../core/base-control.rkt"
         "../style/config.rkt")

(define category-card%
  (class guix-base-control%
    (inherit get-client-size invalidate)
    
    (init-field [label "Today"]
                [count 0]
                [bg-color #f]  ; 改为#f，在on-paint中动态获取
                [icon-symbol "📅"]
                [parent-bg #f])  ; 改为#f，在on-paint中动态获取
    (init [on-click (λ () (void))])
    
    (super-new [on-click on-click]
               [min-width 160] 
               [min-height 90])
    
    (define/private (adjust-color c amount)
      (define (clamp v) (max 0 (min 255 (round v))))
      (make-object color% (clamp (+ (send c red) amount))
                          (clamp (+ (send c green) amount))
                          (clamp (+ (send c blue) amount))))

    (define/override (draw dc)
      (define-values (w h) (send this get-client-size))
      (send dc set-smoothing 'smoothed)
      
      ;; 动态获取颜色（支持主题切换）
      (define actual-bg-color (if bg-color bg-color (color-accent)))
      (define actual-parent-bg (if parent-bg parent-bg (color-bg-light)))
      
      ;; 1. 背景同步(消除四个角的白边)
      (send dc set-brush actual-parent-bg 'solid)
      (send dc set-pen actual-parent-bg 1 'transparent)
      (send dc draw-rectangle 0 0 w h)
      
      ;; 2. 按钮主体
      (define draw-color (cond [(send this get-pressed) (adjust-color actual-bg-color -20)]
                               [(send this get-hover) (adjust-color actual-bg-color 15)]
                               [else actual-bg-color]))
      (send dc set-brush draw-color 'solid)
      (send dc set-pen draw-color 1 'transparent)
      (send dc draw-rounded-rectangle 0 0 w h (border-radius-large))

      ;; 3. 文字和图标
      (define pad 15) 
      ;; 文字颜色固定为白色，因为按钮背景是深色
      (send dc set-text-foreground (make-object color% 255 255 255))
      (send dc set-font (send the-font-list find-or-create-font 20 'swiss 'normal 'normal))
      (send dc draw-text icon-symbol pad pad)
      
      (send dc set-font (send the-font-list find-or-create-font 26 'swiss 'normal 'bold))
      (let* ([count-str (number->string count)]
             [tw-val (let-values ([(tw th _1 _2) (send dc get-text-extent count-str)]) tw)])
        (send dc draw-text count-str (- w tw-val pad 5) pad))
      
      ;; 浅色文字，固定为浅灰
      (send dc set-text-foreground (make-object color% 245 245 245))
      (send dc set-font (send the-font-list find-or-create-font 13 'swiss 'normal 'bold))
      (send dc draw-text label pad (- h 32)))
    ))

;; 导出分类卡片控件类
(provide category-card%
         guix-category-card%)

;; New guix-category-card% with updated naming convention
(define guix-category-card% category-card%)