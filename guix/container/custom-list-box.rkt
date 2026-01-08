#lang racket/gui

;; Custom list box component
;; Modern sidebar component with customizable items
;; Also provides modern-sidebar% as the main export

(provide modern-sidebar% sidebar-item-data)

(define sidebar-item-data
  (class object%
    (init-field [label ""]
                [icon #f]
                [action (λ () (void))]
                [is-active #f])
    
    (super-new)
    
    ;; 获取标签
    (define/public (get-label)
      label)
    
    ;; 设置标签
    (define/public (set-label new-label)
      (set! label new-label))
    
    ;; 获取图标
    (define/public (get-icon)
      icon)
    
    ;; 设置图标
    (define/public (set-icon new-icon)
      (set! icon new-icon))
    
    ;; 获取操作
    (define/public (get-action)
      action)
    
    ;; 设置操作
    (define/public (set-action new-action)
      (set! action new-action))
    
    ;; 获取激活状态
    (define/public (get-active?)
      is-active)
    
    ;; 设置激活状态
    (define/public (set-active? new-active)
      (set! is-active new-active))
    
    ;; 执行操作
    (define/public (execute-action)
      (action))
    ))

(define modern-sidebar%
  (class list-box%
    (init-field [parent #f]
                [style '()]
                [callback (λ (l evt) (void))])
    
    (super-new [parent parent]
               [style style]
               [callback callback]
               [choices '()])
    
    ;; 侧边栏项目列表
    (define sidebar-items '())
    
    ;; 添加侧边栏项目
    (define/public (add-item item-data)
      (set! sidebar-items (append sidebar-items (list item-data)))
      ;; 更新列表框 - 使用正确的方法设置choices
      (send this set (map (λ (item) (send item get-label)) sidebar-items)))
    
    ;; 插入侧边栏项目
    (define/public (insert-item idx item-data)
      (set! sidebar-items (append (take sidebar-items idx)
                                  (list item-data)
                                  (drop sidebar-items idx)))
      ;; 更新列表框 - 使用正确的方法设置choices
      (send this set (map (λ (item) (send item get-label)) sidebar-items)))
    
    ;; 删除侧边栏项目
    (define/public (delete-item idx)
      (set! sidebar-items (append (take sidebar-items idx)
                                  (drop sidebar-items (add1 idx))))
      ;; 更新列表框 - 使用正确的方法设置choices
      (send this set (map (λ (item) (send item get-label)) sidebar-items)))
    
    ;; 清空侧边栏项目
    (define/public (clear-items)
      (set! sidebar-items '())
      (send this clear))
    
    ;; 获取侧边栏项目
    (define/public (get-item idx)
      (list-ref sidebar-items idx))
    
    ;; 获取所有侧边栏项目
    (define/public (get-all-items)
      sidebar-items)
    
    ;; 主题切换时刷新
    (define/override (refresh)
      (super refresh))
    
    ))