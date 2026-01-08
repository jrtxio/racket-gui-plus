#lang racket/gui

;; Input component
;; Basic input wrapper component that wraps text-field%

(require "../atomic/text-field.rkt"
         "../style/config.rkt")

(define input%
  (class horizontal-panel%
    (init-field [placeholder ""]
                [callback (λ (t) (void))]
                [init-value ""]
                [style '()])
    
    (super-new [style (cons 'border style)]
               [spacing 0]
               [alignment '(center center)]
               [min-height (input-height)]
               [min-width 200])
    
    ;; 设置为可伸展
    (send this stretchable-width #t)
    
    ;; 创建内部文本输入框
    (define text-field
      (new text-field%
           [parent this]
           [placeholder placeholder]
           [callback callback]
           [init-value init-value]
           [style '()]))
    
    ;; 公开方法，代理到内部text-field%
    (define/public (get-text)
      (send text-field get-text))
    
    (define/public (set-text str)
      (send text-field set-text str))
    
    (define/public (clear)
      (send text-field clear))
    
    ;; 主题切换时刷新
    (define/override (refresh)
      (super refresh)
      (send text-field refresh))
    
    ))

(provide input%
         guix-input%)

;; New guix-input% with updated naming convention
(define guix-input% input%)
