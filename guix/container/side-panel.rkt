#lang racket/gui

;; Side panel component
;; Modern side panel container with customizable styles

(require racket/class
         racket/draw
         "../style/config.rkt")

(provide side-panel%)

;; Side panel widget implementation
(define side-panel%
  (class horizontal-panel%
    (init-field [side-panel-width 240]
                [min-width 150]
                [max-width 500]
                [on-width-change (λ (w) #f)])
    
    (super-new [spacing 0])
    
    ;; Register widget for theme switching
    (register-widget this)
    
    ;; =========================
    ;; 内部状态
    ;; =========================
    (define dragging? #f)
    (define last-mouse-x 0)
    
    ;; =========================
    ;; 侧边栏面板
    ;; =========================
    (define sidebar-pane
      (new vertical-panel%
           [parent this]
           [min-width side-panel-width]
           [stretchable-width #f]
           [style '(border)]))
    
    ;; =========================
    ;; 分割线
    ;; =========================
    (define divider%
      (class canvas%
        (init-field [outer-panel #f])
        
        (super-new [min-width 1] [stretchable-width #f])
        
        ;; Register divider for theme switching
        (register-widget this)
        
        (define/override (on-paint)
          (define dc (send this get-dc))
          (define-values (w h) (send this get-client-size))
          (send dc set-pen (color-border) 1 'solid)
          (send dc draw-line 0 0 0 h))
        
        ;; Handle theme changes
        (define/public (on-theme-change)
          (send this refresh))
        
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
             
             ;; 更新侧边栏宽度
             (define next-w (+ side-panel-width dx))
             
             ;; 使用当前的 min-width 和 max-width 来限制宽度
             (when (and (>= next-w min-width) (<= next-w max-width))
               (set! side-panel-width next-w)
               ;; 同步到控件
               (send sidebar-pane min-width side-panel-width)
               ;; 刷新布局
               (send outer-panel reflow-container)
               ;; 触发宽度变化回调
               (on-width-change side-panel-width))]))))
    
    (define divider (new divider% [parent this] [outer-panel this]))
    
    ;; =========================
    ;; 内容区域
    ;; =========================
    (define content-pane
      (new vertical-panel%
           [parent this]
           [stretchable-width #t]
           [stretchable-height #t]))
    
    ;; =========================
    ;; 公共方法
    ;; =========================
    
    ;; 处理主题变化
    (define/public (on-theme-change)
      ;; 刷新分割线
      (send divider refresh)
      ;; 刷新所有子控件
      (send sidebar-pane refresh)
      (send content-pane refresh))
    
    ;; 获取侧边栏面板
    (define/public (get-side-panel)
      sidebar-pane)
    
    ;; 获取内容面板
    (define/public (get-content-panel)
      content-pane)
    
    ;; 获取当前侧边栏宽度
    (define/public (get-side-panel-width)
      side-panel-width)
    
    ;; 设置侧边栏宽度
    (define/public (set-side-panel-width! new-width)
      (define constrained-width (max min-width (min max-width new-width)))
      (when (not (= constrained-width side-panel-width))
        (set! side-panel-width constrained-width)
        (send sidebar-pane min-width side-panel-width)
        (send this reflow-container)
        (on-width-change side-panel-width)))
    
    ;; 获取最小宽度
    (define/public (get-min-width)
      min-width)
    
    ;; 设置最小宽度
    (define/public (set-min-width! new-min-width)
      (set! min-width new-min-width)
      ;; 如果当前宽度小于新的最小宽度，调整当前宽度
      (when (< side-panel-width min-width)
        (set-side-panel-width! min-width)))
    
    ;; 获取最大宽度
    (define/public (get-max-width)
      max-width)
    
    ;; 设置最大宽度
    (define/public (set-max-width! new-max-width)
      (set! max-width new-max-width)
      ;; 如果当前宽度大于新的最大宽度，调整当前宽度
      (when (> side-panel-width max-width)
        (set-side-panel-width! max-width)))
    
    ;; 获取宽度变化回调
    (define/public (get-on-width-change)
      on-width-change)
    
    ;; 设置宽度变化回调
    (define/public (set-on-width-change! new-callback)
      (set! on-width-change new-callback))
    
    )
)
