#lang racket/gui

;; Scroll view component
;; Modern scrollable container with customizable styles

(provide scroll-view%)

(define scroll-view%
  (class horizontal-panel%
    (init-field [parent #f]
                [style '()]
                [hscroll? #f] ; 是否显示水平滚动条
                [vscroll? #t]) ; 是否显示垂直滚动条
    
    (super-new [parent parent]
               [style style]
               [spacing 0]
               [alignment '(center center)])
    
    ;; 设置为可伸展
    (send this stretchable-width #t)
    (send this stretchable-height #t)
    
    ;; 内容面板 - 使用普通面板，依赖父组件的滚动
    (define content-panel (new panel%
                           [parent this]
                           [style '()]
                           [stretchable-width #t]
                           [stretchable-height #t]))
    
    ;; 获取内容面板
    (define/public (get-content-panel)
      content-panel)
    
    ;; 清空内容
    (define/public (clear-content)
      (for ([child (send content-panel get-children)])
        (send child destroy)))
    
    ;; 主题切换时刷新
    (define/override (refresh)
      (super refresh)
      ;; 尝试刷新所有子组件
      (for ([child (send content-panel get-children)])
        (with-handlers ([exn:fail? (λ (e) (void))])
          (send child refresh))))
    
    ))
