#lang racket/gui

(require racket/class
         "../style-config.rkt")

;; --- 风格配置面板 ---
(define TARGET-Y-START 50)
(define SPACING (spacing-large))

;; --- 控件实现 ---
(define modern-toast%
  (class frame%
    (init-field message [type 'success] [on-remove void])
    
    (super-new [label ""]
               [style '(no-resize-border no-caption float)]
               [width (toast-width)]
               [height (toast-height)])
    
    (define is-hovered #f)
    (define accent-color
      (case type
        [(success) (color-success)]
        [(error)   (color-error)]
        [else      (color-accent)]))

    (define canvas
      (new (class canvas%
             (super-new)
             (define/override (on-event event)
               (cond [(send event entering?) (set! is-hovered #t)]
                     [(send event leaving?)  (set! is-hovered #f)])))
           [parent this]
           [paint-callback
            (lambda (c dc)
              (send dc set-smoothing 'smoothed)
              (let-values ([(w h) (send c get-client-size)])
                ;; 关键修复:先用系统背景色填充整个区域
                (send dc set-brush (color-bg-light) 'solid)
                (send dc set-pen "white" 0 'transparent)
                (send dc draw-rectangle 0 0 w h)
                
                ;; 使用 dc-path% 绘制圆角背景
                (define bg-path (new dc-path%))
                (send bg-path rounded-rectangle 
                      1 1 
                      (- w 2) (- h 2)
                      (- (border-radius-large) 1))
                
                ;; 1. 绘制主体背景
                (send dc set-brush (color-bg-overlay) 'solid)
                (send dc set-pen "white" 0 'transparent)
                (send dc draw-path bg-path)
                
                ;; 2. 绘制边框(使用 dc-path% 确保圆角精确)
                (define border-path (new dc-path%))
                (send border-path rounded-rectangle 
                      0.5 0.5 
                      (- w 1) (- h 1)
                      (border-radius-large))
                
                (send dc set-brush "white" 'transparent)
                (send dc set-pen (color-border) 1 'solid)
                (send dc draw-path border-path)
                
                ;; 3. 绘制左侧的修饰条
                (send dc set-brush accent-color 'solid)
                (send dc set-pen "white" 0 'transparent)
                (send dc draw-rounded-rectangle 8 18 4 (- h 36) 2)
                
                ;; 4. 绘制文字
                (send dc set-text-foreground (color-text-main))
                (send dc set-font (make-object font% 11 'system 'normal 'bold))
                (let-values ([(tw th _1 _2) (send dc get-text-extent message)])
                  (send dc draw-text message 28 (/ (- h th) 2)))))]))

    (define display-elapsed 0)
    (define auto-close-timer
      (new timer% [notify-callback
                   (lambda ()
                     (unless is-hovered
                       (set! display-elapsed (+ display-elapsed 100))
                       (when (>= display-elapsed 3500)
                         (send auto-close-timer stop)
                         (send this show #f)
                         (on-remove))))]))

    (define/public (update-pos index)
      (let-values ([(sw sh) (get-display-size)])
        (let ([target-x (inexact->exact (round (/ (- sw (toast-width)) 2)))]
              [target-y (+ TARGET-Y-START (* index (+ (toast-height) SPACING)))])
          (send this move target-x target-y))))

    (define/public (launch index)
      (update-pos index)
      (send this show #t)
      (send auto-close-timer start 100 #f))))

;; --- 管理器 ---
(define active-toasts '())

(define (show-toast msg #:type [t 'success])
  (letrec ([t-obj (new modern-toast% 
                       [message msg] 
                       [type t]
                       [on-remove (lambda ()
                                    (set! active-toasts (remove t-obj active-toasts))
                                    (update-all-positions))])])
    (set! active-toasts (append active-toasts (list t-obj)))
    (send t-obj launch (- (length active-toasts) 1))))

(define (update-all-positions)
  (for ([t (in-list active-toasts)] [i (in-naturals)])
    (send t update-pos i)))

;; 导出toast控件和相关函数
(provide modern-toast%
         show-toast)

;; ===========================
;; 测试用例
;; ===========================
(module+ main
  ;; 创建测试窗口
  (define frame (new frame% 
                     [label "通知控件测试"]
                     [width 400]
                     [height 300]))
  
  (define main-panel (new vertical-panel%
                          [parent frame]
                          [style '()]
                          [alignment '(center center)]
                          [spacing 15]))
  
  (define title (new message% 
                     [parent main-panel]
                     [label "测试通知弹窗"]
                     [font (font-large)]))
  
  (new message% [parent main-panel] [label ""] [min-height 20])
  
  ;; 成功通知按钮
  (new button%
       [parent main-panel]
       [label "显示成功通知"]
       [callback (lambda (btn evt)
                   (show-toast "操作成功完成!" #:type 'success))])
  
  ;; 错误通知按钮
  (new button%
       [parent main-panel]
       [label "显示错误通知"]
       [callback (lambda (btn evt)
                   (show-toast "发生了一个错误!" #:type 'error))])
  
  ;; 信息通知按钮
  (new button%
       [parent main-panel]
       [label "显示信息通知"]
       [callback (lambda (btn evt)
                   (show-toast "这是一条提示信息" #:type 'info))])
  
  ;; 多个通知按钮
  (new button%
       [parent main-panel]
       [label "显示多个通知"]
       [callback (lambda (btn evt)
                   (show-toast "第一条通知" #:type 'success)
                   (show-toast "第二条通知" #:type 'info)
                   (show-toast "第三条通知" #:type 'error))])
  
  (new message% [parent main-panel] [label ""] [min-height 10])
  
  (new message% 
       [parent main-panel]
       [label "提示:通知会在3.5秒后自动关闭\n鼠标悬停可暂停倒计时"]
       [font (font-small)])
  
  (send frame show #t))