#lang racket/gui

;; Split view component
;; Modern split panel container with resizable panes

(provide split-view%
         guix-split-view%)

(define split-view%
  (class horizontal-panel%
    (init-field [parent #f]
                [orientation 'horizontal] ;; 'horizontal or 'vertical
                [style '()]
                [size-ratio 0.5]) ;; 0.0 to 1.0, ratio of first pane to total size
    
    (super-new [parent parent]
               [style style]
               [spacing 0]
               [alignment '(center center)])
    
    ;; 设置为可伸展
    (send this stretchable-width #t)
    (send this stretchable-height #t)
    
    ;; 面板列表
    (define panels '())
    
    ;; 分隔条
    (define divider #f)
    
    ;; 分隔条宽度
    (define divider-width 4)
    
    ;; 初始化拆分视图
    (define (init-split-view)
      ;; 根据方向创建基础面板
      (if (eq? orientation 'horizontal)
          (super-new [style (append style '(border))])
          (super-new [style (append style '(border vertical))]))
      
      ;; 创建第一个面板
      (define panel1 (new panel%
                         [parent this]
                         [style '(border)]
                         [stretchable-width #t]
                         [stretchable-height #t]))
      
      ;; 创建分隔条
      (define divider-panel (new panel%
                                [parent this]
                                [style '(border)]
                                [min-width divider-width]
                                [min-height divider-width]
                                [stretchable-width #f]
                                [stretchable-height #f]))
      
      ;; 创建第二个面板
      (define panel2 (new panel%
                         [parent this]
                         [style '(border)]
                         [stretchable-width #t]
                         [stretchable-height #t]))
      
      (set! panels (list panel1 panel2))
      (set! divider divider-panel))
    
    ;; 获取第一个面板
    (define/public (get-first-panel)
      (first panels))
    
    ;; 获取第二个面板
    (define/public (get-second-panel)
      (second panels))
    
    ;; 设置大小比例
    (define/public (set-size-ratio ratio)
      (set! size-ratio (max 0.0 (min 1.0 ratio)))
      ;; 这里可以添加调整大小的逻辑
      (send this refresh))
    
    ;; 获取当前大小比例
    (define/public (get-size-ratio)
      size-ratio)
    
    ;; 主题切换时刷新
    (define/override (refresh)
      (super refresh)
      (for ([panel panels])
        (send panel refresh))
      (when divider
        (send divider refresh)))
    
    ;; 初始化
    (init-split-view)
    ))

;; New guix-split-view% with updated naming convention
(define guix-split-view% split-view%)
