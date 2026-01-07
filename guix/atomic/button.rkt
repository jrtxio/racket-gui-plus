#lang racket/gui

;; Button component
;; Modern button with customizable styles and states
;; Supports theme switching (light/dark) and different button types

(require racket/class
         racket/draw
         "../style/config.rkt")

(provide modern-button%)

(define modern-button% 
  (class canvas% 
    (inherit get-client-size get-parent)
    
    ;;; 初始化参数
    (init parent
          [label "Button"]
          [type 'primary]      ; 按钮类型: 'primary, 'secondary, 'text
          [theme-aware? #t]    ; 是否响应主题变化
          [radius 'medium]     ; 边框半径: 'small, 'medium, 'large
          [enabled? #t]        ; 是否启用
          [callback #f])       ; 点击回调
    
    ;;; 实例变量
    (define current-parent parent)
    (define current-label label)
    (define current-type type)
    (define current-radius radius)
    (define enabled-state enabled?)
    (define callback-proc callback)
    (define hover? #f)
    (define pressed? #f)
    (define theme-aware theme-aware?)
    
    ;;; 构造函数
    (super-new 
     [parent parent]
     [paint-callback 
      (λ (canvas dc) 
        (on-paint dc))]
     [style '(transparent no-focus)]
     [min-width 100]
     [min-height (button-height)])
    
    ;;; 主题管理
    (when theme-aware
      (register-widget this))
    
    ;;; 获取当前边框半径值
    (define (get-radius-value)
      (case current-radius
        [(small) (border-radius-small)]
        [(medium) (border-radius-medium)]
        [(large) (border-radius-large)]
        [else (border-radius-medium)]))
    
    ;;; 根据按钮类型和状态获取背景颜色
    (define (get-background-color)
      (if enabled-state
          (case current-type
            [(primary)
             (if pressed?
                 (make-object color% 0 90 200)  ; 按下状态颜色
                 (color-accent))]  ; 正常状态颜色
            [(secondary)
             (if pressed?
                 (if (equal? (current-theme) light-theme)
                     (make-object color% 220 220 225)
                     (make-object color% 50 50 55))
                 (color-bg-light))]
            [(text) (make-object color% 0 0 0 0)]  ; 透明背景
            [else (color-accent)])
          ; 禁用状态
          (if (equal? (current-theme) light-theme)
              (make-object color% 230 230 235)
              (make-object color% 35 35 38))))
    
    ;;; 根据按钮类型和状态获取文本颜色
    (define (get-text-color)
      (if enabled-state
          (case current-type
            [(primary) (make-object color% 255 255 255)]
            [(secondary) (color-accent)]
            [(text) (color-accent)]
            [else (color-text-main)])
          ; 禁用状态
          (if (equal? (current-theme) light-theme)
              (make-object color% 170 170 170)
              (make-object color% 80 80 85))))
    
    ;;; 根据按钮类型获取边框颜色
    (define (get-border-color)
      (if enabled-state
          (case current-type
            [(primary) (make-object color% 0 0 0 0)]  ; 主按钮无边框
            [(secondary) (color-border)]
            [(text) (make-object color% 0 0 0 0)]  ; 文本按钮无边框
            [else (color-border)])
          (make-object color% 0 0 0 0)))
    
    ;;; 绘制方法
    (define (on-paint dc)
      (let-values ([(width height) (get-client-size)])
      (let* ([radius (get-radius-value)]
             [bg-color (get-background-color)]
             [text-color (get-text-color)]
             [border-color (get-border-color)])
        
        ; 绘制背景
        (send dc set-brush bg-color 'solid)
        (send dc set-pen border-color 1 'solid)
        (send dc draw-rounded-rectangle 0 0 width height radius)
        
        ; 绘制文本
        (send dc set-text-foreground text-color)
        (send dc set-font (font-regular))
        (send dc draw-text current-label 10 (- (/ height 2) 7)))))
    
    ;;; 处理鼠标事件
    (define (handle-mouse-event event)
      (case (send event get-event-type)
        [(enter)
         (set! hover? #t)
         (refresh)]
        [(leave)
         (set! hover? #f)
         (set! pressed? #f)
         (refresh)]
        [(left-down)
         (set! pressed? #t)
         (refresh)]
        [(left-up)
         (when (and pressed? hover? enabled-state callback-proc)
           (callback-proc this event))
         (set! pressed? #f)
         (refresh)]))
    
    ;;; 覆盖事件处理
    (define/override (on-event event)
      (handle-mouse-event event)
      (super on-event event))
    
    ;;; 刷新方法 - 响应主题变化
    (define/override (refresh)
      (super refresh))
    
    ;;; 设置按钮类型
    (define/public (set-type! new-type)
      (set! current-type new-type)
      (refresh))
    
    ;;; 获取按钮类型
    (define/public (get-type)
      current-type)
    
    ;;; 设置标签
    (define/public (set-button-label! new-label)
      (set! current-label new-label)
      (send this refresh))
    
    ;;; 获取标签
    (define/public (get-button-label)
      current-label)
    
    ;;; 设置边框半径
    (define/public (set-radius! new-radius)
      (set! current-radius new-radius)
      (refresh))
    
    ;;; 获取边框半径
    (define/public (get-radius)
      current-radius)
    
    ;;; 设置启用状态
    (define/public (set-enabled! [on? #t])
      (set! enabled-state on?)
      (send this refresh))
    
    ;;; 检查是否启用
    (define/public (get-enabled-state)
      enabled-state)
    
    ;;; 设置回调函数
    (define/public (set-callback! callback)
      (set! callback-proc callback))
    
    this)
  )
