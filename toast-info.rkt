#lang racket/gui

(require racket/class
         "style-config.rkt")

;; --- 风格配置面板 ---;
(define TARGET-Y-START 50)
(define SPACING SPACING-LARGE)

;; 调色盘:采用了苹果风格的亮色模式
(define color-bg        COLOR-BG-OVERLAY)
(define color-border    COLOR-BORDER)
(define color-text-main COLOR-TEXT-MAIN)
(define color-success   COLOR-SUCCESS)
(define color-error     COLOR-ERROR)
(define color-info      COLOR-ACCENT)

;; --- 控件实现 ---
(define modern-toast%
  (class frame%
    (init-field message [type 'success] [on-remove void])
    
    (super-new [label ""]
               [style '(no-resize-border no-caption float)]
               [width TOAST-WIDTH]
               [height TOAST-HEIGHT])
    
    (define is-hovered #f)
    (define accent-color
      (case type
        [(success) color-success]
        [(error)   color-error]
        [else      color-info]))

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
                ;; 0. 绘制背景(消除圆角外侧的直角)
                ;; 通知弹窗是顶层窗口，使用系统默认背景色
                (send dc set-brush COLOR-BG-LIGHT 'solid)
                (send dc set-pen COLOR-BG-LIGHT 1 'solid)
                (send dc draw-rectangle 0 0 w h)
                
                ;; 1. 绘制主体背景(带淡淡的描边增加精致感)
                (send dc set-brush color-bg 'solid)
                (send dc set-pen color-border 1 'solid)
                (send dc draw-rounded-rectangle 0 0 (- w 1) (- h 1) BORDER-RADIUS-LARGE)
                
                ;; 2. 绘制左侧的修饰条(让通知更有设计感,而不是一个简单的框)
                (send dc set-brush accent-color 'solid)
                (send dc set-pen accent-color 1 'transparent)
                (send dc draw-rounded-rectangle 8 18 4 (- h 36) 2)
                
                ;; 3. 绘制文字 (使用更现代的排版)
                (send dc set-text-foreground color-text-main)
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
        (let ([target-x (inexact->exact (round (/ (- sw TOAST-WIDTH) 2)))]
              [target-y (+ TARGET-Y-START (* index (+ TOAST-HEIGHT SPACING)))])
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