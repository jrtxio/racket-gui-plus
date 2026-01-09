#lang racket/gui

;; Stepper input component
;; Input field with stepper controls for increment/decrement

(require "../atomic/text-field.rkt"
         "../atomic/button.rkt"
         "../style/config.rkt")

(provide stepper-input%
         guix-stepper-input%)

(define stepper-input%
  (class horizontal-panel%
    (init-field [init-value 0]
                [min-value 0]
                [max-value 100]
                [step 1]
                [callback (λ (t) (void))]
                [style '()]
                [theme (current-theme)])
    
    (super-new [style style]
               [spacing 4]
               [alignment '(center center)]
               [min-height (input-height)]
               [min-width 120])
    
    ;; 设置为可伸展
    (send this stretchable-width #t)
    
    ;; 当前值
    (define current-value (make-parameter init-value))
    
    ;; 更新输入框值
    (define (update-input)
      (send stepper-text-field set-text (number->string (current-value))))
    
    ;; 增加值
    (define (increment)
      (define new-value (min (+ (current-value) step) max-value))
      (when (not (= new-value (current-value)))
        (current-value new-value)
        (update-input)
        (callback this)))
    
    ;; 减少值
    (define (decrement)
      (define new-value (max (- (current-value) step) min-value))
      (when (not (= new-value (current-value)))
        (current-value new-value)
        (update-input)
        (callback this)))
    
    ;; 创建减少按钮
    (define decrement-button
      (new guix-button%
           [parent this]
           [label "-" ]
           [type 'secondary]
           [callback (λ (btn evt) (decrement))]
           [min-width 32]
           [min-height 28]
           [stretchable-width #f]
           [theme theme]))
    
    ;; 创建文本输入框
    (define stepper-text-field
      (new text-field%
           [parent this]
           [init-value (number->string init-value)]
           [callback (λ (t evt) 
                       (define text (send t get-text))
                       (define num (string->number text))
                       (when (and num (>= num min-value) (<= num max-value))
                         (current-value num)
                         (callback this)))]
           [style '(single horizontal-label)]
           [min-width 50]
           [theme theme]))
    
    ;; 设置文本输入框为可伸展
    (send stepper-text-field stretchable-width #t)
    
    ;; 创建增加按钮
    (define increment-button
      (new guix-button%
           [parent this]
           [label "+" ]
           [type 'secondary]
           [callback (λ (btn evt) (increment))]
           [min-width 32]
           [min-height 28]
           [stretchable-width #f]
           [theme theme]))
    
    ;; 公开方法
    (define/public (get-value)
      (current-value))
    
    (define/public (set-value val)
      (define clamped-val (max min-value (min max-value val)))
      (current-value clamped-val)
      (update-input)
      (callback this))
    
    ;; 主题切换时刷新
    (define/override (refresh)
      (super refresh)
      (send decrement-button refresh)
      (send stepper-text-field refresh)
      (send increment-button refresh))
    
    ))

;; New guix-stepper-input% with updated naming convention
(define guix-stepper-input% stepper-input%)
