#lang racket/gui
(require racket/draw)

;; ============================================================
;; 辅助工具:处理十六进制颜色
;; ============================================================
(define (hex->color hex-str)
  (define r (string->number (substring hex-str 1 3) 16))
  (define g (string->number (substring hex-str 3 5) 16))
  (define b (string->number (substring hex-str 5 7) 16))
  (make-object color% r g b))

;; ============================================================
;; 结构体定义: list-item
;; ============================================================
(struct list-item (label color count data) #:transparent)

;; ============================================================
;; 侧边栏列表控件: sidebar-list%
;; ============================================================
(define sidebar-list%
  (class canvas%
    (init-field [items '()]
                [on-select (λ (i) #f)])

    (super-new [style '(no-focus)]
               [min-width 200])

    (define selected-index 0)
    (define hover-index -1)
    
    (define/override (on-paint)
      (define dc (send this get-dc))
      (define-values (w h) (send this get-client-size))
      (send dc set-smoothing 'smoothed)
      
      ;; 绘制整个侧边栏的底色
      (send dc set-brush (hex->color "#F2F2F7") 'solid)
      (send dc set-pen (hex->color "#F2F2F7") 1 'solid)
      (send dc draw-rectangle 0 0 w h)
      
      (for ([item (in-list items)] [i (in-naturals)])
        (let* ([margin 10.0]
               [item-h 34.0]
               [gap 4.0]
               [y (+ margin (* i (+ item-h gap)))]
               [rect-x margin]
               [rect-w (max 0.0 (- w (* margin 2.0)))])
          
          (define is-selected (= i selected-index))
          (define is-hover (= i hover-index))

          ;; 1. 背景绘制
          (cond
            [is-selected
             (send dc set-brush (hex->color "#007AFF") 'solid)
             (send dc set-pen (hex->color "#007AFF") 1 'solid)]
            [is-hover
             ;; 悬停使用淡淡的灰色
             (send dc set-brush (make-object color% 0 0 0 0.05) 'solid)
             (send dc set-pen "lightgray" 1 'transparent)]
            [else
             ;; 未选中且未悬停时,背景透明(露出底部的 #F2F2F7)
             (send dc set-brush "white" 'transparent)
             (send dc set-pen "white" 1 'transparent)])
          
          (send dc draw-rounded-rectangle rect-x y rect-w item-h 6.0)
          
          ;; 2. 圆形图标
          (let ([dot-size 18.0]
                [dot-x (+ rect-x 10.0)]
                [dot-y (+ y (/ (- item-h 18.0) 2.0))])
            (send dc set-brush (hex->color (list-item-color item)) 'solid)
            (send dc set-pen "white" 1 'transparent)
            (send dc draw-ellipse dot-x dot-y dot-size dot-size))
          
          ;; 3. 文字
          (send dc set-text-foreground (if is-selected "white" (hex->color "#3A3A3C")))
          (send dc set-font (make-object font% 11 'default 'normal (if is-selected 'bold 'normal)))
          (send dc draw-text (list-item-label item) (+ rect-x 36.0) (+ y 7.0))
          
          ;; 4. 计数器
          (let* ([count-str (number->string (list-item-count item))]
                 [text-color (if is-selected "white" (hex->color "#8E8E93"))])
            (send dc set-font (make-object font% 10 'default))
            (send dc set-text-foreground text-color)
            (define-values (tw _1 _2 _3) (send dc get-text-extent count-str))
            (send dc draw-text count-str (- w margin 12.0 tw) (+ y 8.0))))))

    (define/override (on-event event)
      (define x (send event get-x))
      (define y (send event get-y))
      (define-values (w h) (send this get-client-size))
      
      (define idx (if (< y 10) -1 (quotient (truncate (- y 10)) 38)))
      (define is-over-item (and (>= x 10) (<= x (- w 10))
                                (>= idx 0) (< idx (length items))))

      (case (send event get-event-type)
        [(leave) (set! hover-index -1) (send this refresh)]
        [(motion enter)
         (let ([old-hover hover-index])
           (set! hover-index (if is-over-item idx -1))
           (unless (= old-hover hover-index) (send this refresh)))]
        [(left-down)
         (when is-over-item
           (set! selected-index idx)
           (on-select (list-ref items idx))
           (send this refresh))]))
     
    ;; ---------------- 公共方法 ----------------
    (define/public (set-items! new-items)
      (set! items new-items)
      (send this refresh))
    
    (define/public (get-selected-item)
      (if (and (>= selected-index 0) (< selected-index (length items)))
          (list-ref items selected-index)
          #f))
    
    (define/public (get-items)
      items)
    
    (define/public (select-item idx)
      (when (and (>= idx 0) (< idx (length items)))
        (set! selected-index idx)
        (on-select (list-ref items idx))
        (send this refresh)))
    
    (define/public (get-value)
      (send this get-selected-item))
    
    (define/public (add-item item)
      (set! items (append items (list item)))
      (send this refresh))
    
    (define/public (remove-item idx)
      (when (and (>= idx 0) (< idx (length items)))
        (set! items (append (take items idx) (drop items (+ idx 1))))
        (send this refresh)))
    )
)

;; 导出控件类和相关结构体
(provide sidebar-list%
         list-item)