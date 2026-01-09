#lang racket/gui

;; Tab view component
;; Modern tab container with customizable tabs and content

(require "../atomic/button.rkt"
         "../style/config.rkt")

(provide tab-view%
         guix-tab-view%)

(define tab-view%
  (class vertical-panel%
    (init-field [parent #f]
                [style '()]
                [theme (current-theme)])
    
    (super-new [parent parent]
               [style style]
               [spacing 0]
               [alignment '(center center)])
    
    ;; 设置为可伸展
    (send this stretchable-width #t)
    (send this stretchable-height #t)
    
    ;; 标签信息
    (define tab-data '()) ; 列表，每个元素是 (label callback content-panel)
    (define current-tab-index (make-parameter 0))
    
    ;; 标签栏
    (define tab-bar (new horizontal-panel%
                       [parent this]
                       [style '(border)]
                       [spacing 0]
                       [alignment '(center left)]
                       [stretchable-width #t]
                       [stretchable-height #f]))
    
    ;; 内容区域
    (define content-area (new panel%
                           [parent this]
                           [style '(border)]
                           [stretchable-width #t]
                           [stretchable-height #t]))
    
    ;; 创建标签按钮
    (define (create-tab-button label index)
      (new guix-button%
           [parent tab-bar]
           [label label]
           [type 'secondary]
           [callback (λ (btn evt) (switch-tab index))]
           [stretchable-width #t]
           [stretchable-height #f]
           [theme theme]))
    
    ;; 添加标签
    (define/public (add-tab label callback)
      (define tab-index (length tab-data))
      (define content-panel (new panel%
                               [parent content-area]
                               [style '()]
                               [stretchable-width #t]
                               [stretchable-height #t]))
      
      ;; 初始隐藏新面板
      (send content-panel show #f)
      
      ;; 添加标签数据
      (set! tab-data (append tab-data (list (list label callback content-panel))))
      
      ;; 创建标签按钮
      (create-tab-button label tab-index)
      
      ;; 如果是第一个标签，显示它
      (when (= tab-index 0)
        (switch-tab 0))
      
      tab-index)
    
    ;; 切换标签
    (define (switch-tab index)
      ;; 隐藏所有内容面板
      (for ([(tab idx) (in-indexed tab-data)])
        (send (third tab) show #f))
      
      ;; 显示选中的内容面板
      (send (third (list-ref tab-data index)) show #t)
      
      ;; 更新当前标签索引
      (current-tab-index index)
      
      ;; 调用回调
      ((second (list-ref tab-data index)))
      
      ;; 刷新界面
      (send this refresh))
    
    ;; 获取当前标签索引
    (define/public (get-current-tab)
      (current-tab-index))
    
    ;; 设置当前标签
    (define/public (set-current-tab! index)
      (switch-tab index))
    
    ;; 移除标签
    (define/public (remove-tab index)
      ;; 销毁内容面板
      (send (third (list-ref tab-data index)) destroy)
      
      ;; 移除标签数据
      (set! tab-data (append (take tab-data index)
                            (drop tab-data (add1 index))))
      
      ;; 重新创建标签栏
      ;; 注意：这是一个简单实现，实际可能需要更高效的方法
      (send tab-bar clear)
      (for ([(tab idx) (in-indexed tab-data)])
        (create-tab-button (first tab) idx))
      
      ;; 调整当前标签索引
      (define new-index (min index (sub1 (length tab-data))))
      (current-tab-index new-index)
      (switch-tab new-index))
    
    ;; 获取标签数量
    (define/public (get-tab-count)
      (length tab-data))
    
    ;; 主题切换时刷新
    (define/override (refresh)
      (super refresh)
      (send tab-bar refresh)
      (send content-area refresh)
      (for ([tab tab-data])
        (send (third tab) refresh)))
    
    ))

;; New guix-tab-view% with updated naming convention
(define guix-tab-view% tab-view%)
