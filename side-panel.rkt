#lang racket/gui
(require racket/draw)

;; =========================
;; 状态管理
;; =========================
(define current-sidebar-width 240)
(define SIDEBAR-MIN 150)
(define SIDEBAR-MAX 500)
(define DIVIDER-COLOR (make-object color% 210 210 210))

(define frame (new frame% [label "macOS Sidebar Final"] [width 900] [height 600]))
(define root (new horizontal-panel% [parent frame] [spacing 0]))

;; =========================
;; 侧边栏
;; =========================
(define sidebar-pane
  (new vertical-panel%
       [parent root]
       [min-width current-sidebar-width]
       [stretchable-width #f]
       [style '(border)]))

(new message% [parent sidebar-pane] [label "LIBRARY"])
(new list-box% [parent sidebar-pane] [label #f] [choices '("Inbox" "Today" "Scheduled")])

;; =========================
;; 分割线 (完全修正版)
;; =========================
(define divider%
  (class canvas%
    (super-new [min-width 1] [stretchable-width #f])
    
    (define dragging? #f)
    (define last-mouse-x 0)

    (define/override (on-paint)
      (define dc (send this get-dc))
      (define-values (w h) (send this get-client-size))
      (send dc set-pen DIVIDER-COLOR 1 'solid)
      (send dc draw-line 0 0 0 h))

    (define/override (on-event e)
      (define event-type (send e get-event-type))
      (cond
        [(eq? event-type 'enter) (send this set-cursor (make-object cursor% 'size-e/w))]
        [(eq? event-type 'leave) (send this set-cursor (make-object cursor% 'arrow))]
        
        [(eq? event-type 'left-down)
         (set! dragging? #t)
         (set! last-mouse-x (send e get-x))]
        
        [(eq? event-type 'left-up)
         (set! dragging? #f)]
        
        [(and (eq? event-type 'motion) dragging?)
         ;; 计算增量
         (define dx (- (send e get-x) last-mouse-x))
         
         ;; 更新全局宽度变量
         (define next-w (+ current-sidebar-width dx))
         
         (when (and (>= next-w SIDEBAR-MIN) (<= next-w SIDEBAR-MAX))
           (set! current-sidebar-width next-w)
           ;; 同步到控件
           (send sidebar-pane min-width current-sidebar-width)
           ;; 刷新布局
           (send root reflow-container))]))))

(new divider% [parent root])

;; =========================
;; 内容区
;; =========================
(define content (new vertical-panel% [parent root] [border 20]))

(new text-field% 
     [parent content] 
     [label "Status:"] 
     [init-value "Fixed using Internal State Variable"])

(new text-field% 
     [parent content] 
     [label #f] 
     [style '(multiple)]
     [init-value "Directly using 'current-sidebar-width' to avoid API issues."])

(send frame show #t)