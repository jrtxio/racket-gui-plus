#lang racket/gui

;; 现代化侧边栏控件

;; 辅助函数：将十六进制颜色字符串转换为color%对象
(define (hex->color hex-str)
  (if (not hex-str)
      (make-object color% 100 100 100)
      (let* ([r (string->number (substring hex-str 1 3) 16)]
             [g (string->number (substring hex-str 3 5) 16)]
             [b (string->number (substring hex-str 5 7) 16)])
        (if (and r g b)
            (make-object color% r g b)
            (make-object color% 100 100 100)))))

;; 定义侧边栏项的数据结构
(struct sidebar-item (label color count data) #:transparent)

;; 现代化侧边栏控件
(define modern-sidebar%
  (class canvas%
    (init-field [items '()] [callback (lambda (i) #f)])
    (super-new)
    
    (define selected-index 0)
    (define hover-index -1)
    
    (define/override (on-paint)
      (define dc (send this get-dc))
      (define-values (w h) (send this get-client-size))
      (send dc set-smoothing 'smoothed)
      
      (send dc set-brush (hex->color "#F2F2F7") 'solid)
      (send dc set-pen (hex->color "#F2F2F7") 1 'solid)
      (send dc draw-rectangle 0 0 w h))
    
    (define/override (on-event event)
      (define x (send event get-x))
      (define y (send event get-y))
      (define-values (w h) (send this get-client-size))
      
      (define idx (if (< y 10) -1 (quotient (truncate (- y 10)) 38)))
      (define is-over-item (and (>= x 10) (<= x (- w 10))
                                (>= idx 0) (< idx (length items))))

      (case (send event get-event-type)
        [(leave)
         (set! hover-index -1)
         (send this refresh)]
        [(motion enter)
         (let ([old-hover hover-index])
           (set! hover-index (if is-over-item idx -1))
           (unless (= old-hover hover-index)
             (send this refresh)))]
        [(left-down)
         (when is-over-item
           (set! selected-index idx)
           (callback (list-ref items idx))
           (send this refresh))]))
    
    (define/public (set-items! new-items)
      (set! items new-items)
      (send this refresh))

    (define/public (add-item item)
      (set! items (append items (list item)))
      (send this refresh))))

(provide modern-sidebar%)
(provide sidebar-item)
(provide sidebar-item-label)
(provide sidebar-item-color)
(provide sidebar-item-count)
(provide sidebar-item-data)