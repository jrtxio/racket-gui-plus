#lang racket/gui

;; Stack view component
;; Modern stack container for displaying multiple views

(provide stack-view%
         guix-stack-view%)

(define stack-view%
  (class panel%
    (init-field [parent #f]
                [style '()])
    
    (super-new [parent parent]
               [style style]
               [alignment '(center center)])
    
    ;; 设置为可伸展
    (send this stretchable-width #t)
    (send this stretchable-height #t)
    
    ;; 视图堆栈
    (define view-stack '())
    (define current-view-index (make-parameter 0))
    
    ;; 添加视图
    (define/public (add-view view-panel)
      (define view-index (length view-stack))
      
      ;; 初始隐藏新视图
      (send view-panel show #f)
      
      ;; 添加到视图堆栈
      (set! view-stack (append view-stack (list view-panel)))
      
      ;; 如果是第一个视图，显示它
      (when (= view-index 0)
        (switch-view 0))
      
      view-index)
    
    ;; 切换到指定索引的视图
    (define/public (switch-view index)
      (when (and (>= index 0) (< index (length view-stack)))
        ;; 隐藏当前视图
        (send (list-ref view-stack (current-view-index)) show #f)
        
        ;; 显示新视图
        (send (list-ref view-stack index) show #t)
        
        ;; 更新当前索引
        (current-view-index index)
        
        ;; 刷新界面
        (send this refresh)))
    
    ;; 切换到下一个视图
    (define/public (next-view)
      (define next-index (modulo (add1 (current-view-index)) (length view-stack)))
      (switch-view next-index))
    
    ;; 切换到上一个视图
    (define/public (prev-view)
      (define prev-index (modulo (sub1 (current-view-index)) (length view-stack)))
      (switch-view prev-index))
    
    ;; 获取当前视图索引
    (define/public (get-current-view-index)
      (current-view-index))
    
    ;; 获取当前视图
    (define/public (get-current-view)
      (list-ref view-stack (current-view-index)))
    
    ;; 获取所有视图
    (define/public (get-views)
      view-stack)
    
    ;; 移除视图
    (define/public (remove-view index)
      (when (and (>= index 0) (< index (length view-stack)))
        ;; 销毁视图
        (define view-panel (list-ref view-stack index))
        (send this delete-child view-panel)
        
        ;; 移除视图数据
        (set! view-stack (append (take view-stack index)
                              (drop view-stack (add1 index))))
        
        ;; 调整当前视图索引
        (define new-index (min (current-view-index) (sub1 (length view-stack))))
        (current-view-index new-index)
        
        ;; 如果还有视图，显示当前视图
        (when (not (empty? view-stack))
          (send (list-ref view-stack new-index) show #t))
        
        ;; 刷新界面
        (send this refresh)))
    
    ;; 清空所有视图
    (define/public (clear-views)
      ;; 销毁所有视图
      (for ([view view-stack])
        (send this delete-child view))
      
      ;; 重置数据
      (set! view-stack '())
      (current-view-index 0)
      
      ;; 刷新界面
      (send this refresh))
    
    ;; 主题切换时刷新
    (define/override (refresh)
      (super refresh)
      ;; 尝试刷新所有子组件
      (for ([view view-stack])
        (with-handlers ([exn:fail? (λ (e) (void))])
          (send view refresh))))
    
    ))

;; New guix-stack-view% with updated naming convention
(define guix-stack-view% stack-view%)
