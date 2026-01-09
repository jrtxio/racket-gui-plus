#lang racket/gui

(require racket/draw
         "../core/base-control.rkt"
         "../style/config.rkt")

(define category-card%
  (class guix-base-control%
    (inherit get-client-size)
    
    (init-field [label "Today"]
                [count 0]
                [bg-color #f]
                [icon-symbol "📅"]
                [parent-bg #f]
                [on-click (λ () (void))])
    
    (super-new [min-width 160]
               [min-height 90])
    
    (define/private (adjust-color c amount)
      (define (clamp v) (max 0 (min 255 (round v))))
      (make-object color% (clamp (+ (send c red) amount))
                          (clamp (+ (send c green) amount))
                          (clamp (+ (send c blue) amount))))

    (define/private (get-color-from-theme theme key)
      (hash-ref (send theme get-colors) key))

    (define/override (handle-mouse-event event)
      (when (eq? (send event get-event-type) 'left-up)
        (on-click)))

    (define/override (render-control dc state theme)
      (define-values (w h) (get-client-size))
      (send dc set-smoothing 'smoothed)
      
      ;; 动态获取颜色
      (define actual-bg-color (if bg-color bg-color (color-accent)))
      (define actual-parent-bg (if parent-bg parent-bg (color-bg-light)))
      
      ;; 1. 背景同步
      (send dc set-brush actual-parent-bg 'solid)
      (send dc set-pen actual-parent-bg 1 'transparent)
      (send dc draw-rectangle 0 0 w h)
      
      ;; 2. 卡片主体
      (define draw-color (cond [(eq? state 'pressed) (adjust-color actual-bg-color -20)]
                               [(eq? state 'hover) (adjust-color actual-bg-color 15)]
                               [else actual-bg-color]))
      (send dc set-brush draw-color 'solid)
      (send dc set-pen draw-color 1 'transparent)
      (send dc draw-rectangle 0 0 w h)

      ;; 3. 文字和图标
      (define pad 15)
      (send dc set-text-foreground (make-object color% 255 255 255))
      
      ;; Icon
      (send dc set-font (send the-font-list find-or-create-font 20 'swiss 'normal 'normal))
      (send dc draw-text icon-symbol pad pad)
      
      ;; Count
      (send dc set-font (send the-font-list find-or-create-font 26 'swiss 'normal 'bold))
      (let* ([count-str (number->string count)]
             [tw-val (let-values ([(tw th _1 _2) (send dc get-text-extent count-str)]) tw)])
        (send dc draw-text count-str (- w tw-val pad 5) pad))
      
      ;; Label
      (send dc set-text-foreground (make-object color% 245 245 245))
      (send dc set-font (send the-font-list find-or-create-font 13 'swiss 'normal 'bold))
      (send dc draw-text label pad (- h 32)))
    ))

;; 导出分类卡片控件类
(provide category-card%
         guix-category-card%)

;; New guix-category-card% with updated naming convention
(define guix-category-card% category-card%)