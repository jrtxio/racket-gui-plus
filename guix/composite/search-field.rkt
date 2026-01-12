#lang racket/gui

;; Search field component
;; Enhanced input field with search functionality

(require "../atomic/text-field.rkt"
         "../atomic/button.rkt"
         "../style/config.rkt")

(provide search-field%
         guix-search-field%)

(define search-field%
  (class horizontal-panel%
    ;; 定义类参数
    (init-field [placeholder "Search..."]
                [on-callback (λ (sf event) (void))] ; 使用on-callback参数
                [init-value ""]
                [style '()]
                [theme (current-theme)])
    
    ;; 调用父类构造函数
    (super-new [style style]
               [spacing 8]
               [alignment '(center center)]
               [min-height (input-height)]
               [min-width 240])
    
    ;; 设置为可伸展
    (send this stretchable-width #t)
    
    ;; 创建搜索文本输入框
    (define search-text-field
      (new text-field%
           [parent this]
           [placeholder placeholder]
           [callback (λ (field event) (on-callback field event))] ; 传递on-callback参数
           [init-value init-value]
           [style '()]
           [theme theme]))
    
    ;; 设置文本输入框为主要伸展组件
    (send search-text-field stretchable-width #t)
    
    ;; 创建搜索按钮
    (define search-button
      (new guix-button%
           [parent this]
           [label "Search"]
           [type 'secondary]
           [on-click (λ () (on-callback search-text-field #f))] ; 点击按钮时调用on-callback
           [stretchable-width #f]
           [theme theme]))
    
    ;; 公开方法，代理到内部text-field%
    (define/public (get-text)
      (send search-text-field get-text))
    
    (define/public (set-text str)
      (send search-text-field set-text str))
    
    (define/public (clear)
      (send search-text-field clear))
    
    ;; 公共方法callback，兼容测试代码
    (define/public (callback [sf #f] [event #f])
      (on-callback search-text-field event))
    
    ;; 主题切换时刷新
    (define/override (refresh)
      (super refresh)
      (send search-text-field refresh)
      (send search-button refresh))
    
    ))

;; New guix-search-field% with updated naming convention
(define guix-search-field% search-field%)
