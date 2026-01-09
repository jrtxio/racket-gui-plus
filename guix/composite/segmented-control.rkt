#lang racket/gui

;; Segmented control component
;; Modern segmented button group with customizable styles

(require "../atomic/button.rkt"
         "../style/config.rkt")

(provide segmented-control%
         guix-segmented-control%)

(define segmented-control%
  (class horizontal-panel%
    (init-field [segments '()]
                [selected-index 0]
                [callback (λ (idx) (void))]
                [style '()])
    
    (super-new [style style]
               [spacing 0]
               [alignment '(center center)]
               [min-height (button-height)]
               [min-width 160])
    
    ;; 设置为可伸展
    (send this stretchable-width #t)
    
    ;; 当前选中索引
    (define current-selected (make-parameter selected-index))
    
    ;; 按钮列表
    (define button-list '())
    
    ;; 更新按钮样式
    (define (update-button-styles)
      (for ([(btn idx) (in-indexed button-list)])
        (send btn set-label (list-ref segments idx))
        (send btn refresh)))
    
    ;; 创建分段按钮
    (define (create-segment-buttons)
      (for ([(segment idx) (in-indexed segments)])
        (define btn (new modern-button%
                         [parent this]
                         [label segment]
                         [type 'secondary]
                         [callback (λ (btn evt) 
                                     (set-selected-index idx))]
                         [stretchable-width #t]))
        (set! button-list (append button-list (list btn)))))
    
    ;; 设置选中索引
    (define (set-selected-index idx)
      (when (not (= idx (current-selected)))
        (current-selected idx)
        (callback idx)
        (update-button-styles)))
    
    ;; 初始化创建按钮
    (create-segment-buttons)
    
    ;; 更新分段
    (define/public (set-segments new-segments)
      ;; 清空现有按钮
      (for ([btn button-list])
        (send btn destroy))
      (set! button-list '())
      ;; 创建新按钮
      (set! segments new-segments)
      (create-segment-buttons)
      (update-button-styles))
    
    ;; 获取选中索引
    (define/public (get-selected-index)
      (current-selected))
    
    ;; 设置选中索引
    (define/public (set-selected-index! idx)
      (set-selected-index idx))
    
    ;; 主题切换时刷新
    (define/override (refresh)
      (super refresh)
      (for ([btn button-list])
        (send btn refresh)))
    
    ))

;; New guix-segmented-control% with updated naming convention
(define guix-segmented-control% segmented-control%)
