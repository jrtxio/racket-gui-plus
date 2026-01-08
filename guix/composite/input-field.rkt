#lang racket/gui

;; Input field component
;; Enhanced text input with additional features like icons and validation

(require "../atomic/text-field.rkt"
         "../style/config.rkt")

(define input-field%
  (class horizontal-panel%
    (init-field [placeholder ""]
                [callback (λ (t) (void))]
                [init-value ""]
                [style '()]
                [left-icon #f]
                [right-icon #f]
                [validation-state 'normal]) ;; 'normal, 'error, 'warning
    
    (super-new [style style]
               [spacing 8]
               [alignment '(center center)]
               [min-height (input-height)]
               [min-width 240])
    
    ;; 设置为可伸展
    (send this stretchable-width #t)
    
    ;; 创建左侧图标占位符
    (define left-icon-widget
      (new panel%
           [parent this]
           [min-width 0]
           [stretchable-width #f]))
    
    ;; 创建内部文本输入框
    (define text-field
      (new text-field%
           [parent this]
           [placeholder placeholder]
           [callback callback]
           [init-value init-value]
           [style '()]))
    
    ;; 设置文本输入框为主要伸展组件
    (send text-field stretchable-width #t)
    
    ;; 创建右侧图标占位符
    (define right-icon-widget
      (new panel%
           [parent this]
           [min-width 0]
           [stretchable-width #f]))
    
    ;; 公开方法，代理到内部text-field%
    (define/public (get-text)
      (send text-field get-text))
    
    (define/public (set-text str)
      (send text-field set-text str))
    
    (define/public (clear)
      (send text-field clear))
    
    ;; 设置验证状态
    (define/public (set-validation-state state)
      (set! validation-state state)
      (send this refresh))
    
    ;; 获取验证状态
    (define/public (get-validation-state)
      validation-state)
    
    ;; 主题切换时刷新
    (define/override (refresh)
      (super refresh)
      (send text-field refresh))
    
    ))

(provide input-field%
         guix-input-field%)

;; New guix-input-field% with updated naming convention
(define guix-input-field% input-field%)
