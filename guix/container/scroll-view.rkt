#lang racket/gui

;; Scroll view component
;; Modern scrollable container with customizable styles

(provide scroll-view%
         guix-scroll-view%)

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
      ;; 使用try-catch循环删除所有子组件，因为panel%没有delete-children方法
      (let loop ()
        (with-handlers ([exn:fail? (λ (e) (void))]) ; 当没有子组件时停止
          (send content-panel delete-child 0) ; 尝试删除第一个子组件
          (loop))))
    
    ;; Destroy method (alias for consistency)
    (define/public (destroy)
      (send this delete-children))
    
    ;; 主题切换时刷新
    (define/override (refresh)
      (super refresh)
      ;; 刷新内容面板
      (send content-panel refresh))
    
    ))

;; New guix-scroll-view% with updated naming convention
(define guix-scroll-view% scroll-view%)
