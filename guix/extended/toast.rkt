#lang racket/gui

(require racket/class
         racket/list
         "../style/config.rkt")

;; --- 常量定义 ---
(define TARGET-Y-START 50)
(define SPACING-LARGE (spacing-large))

;; --- 控件实现 ---
(define guix-toast%
  (class frame%
    (init-field message [type 'success] [on-remove void])
    
    (super-new [label ""]
               [style '(no-resize-border no-caption float)]
               [width (toast-width)]
               [height (toast-height)])
    
    ;; Register widget for theme change
    (register-widget this)
    
    (define is-hovered #f)
    
    (define (get-accent-color)
      (case type
        [(success) (color-success)]
        [(error)   (color-error)]
        [else      (color-accent)]))
    
    (define (get-bg-color) (color-bg-overlay))
    (define (get-border-color) (color-border))
    (define (get-text-color) (color-text-main))
    
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
                ;; Only draw if we have valid dimensions
                (when (and (>= w 2) (>= h 2))
                  ;; Fill with system background color
                  (send dc set-brush (color-bg-light) 'solid)
                  (send dc set-pen "white" 0 'transparent)
                  (send dc draw-rectangle 0 0 w h)
                  
                  ;; Draw rounded background using dc-path%
                  (define bg-path (new dc-path%))
                  (send bg-path rounded-rectangle 
                        1 1 
                        (- w 2) (- h 2)
                        (border-radius-large))
                  
                  ;; 1. Draw main background
                  (send dc set-brush (get-bg-color) 'solid)
                  (send dc set-pen "white" 0 'transparent)
                  (send dc draw-path bg-path)
                  
                  ;; 2. Draw border using dc-path%
                  (define border-path (new dc-path%))
                  (send border-path rounded-rectangle 
                        0.5 0.5 
                        (- w 1) (- h 1)
                        (border-radius-large))
                  
                  (send dc set-brush "white" 'transparent)
                  (send dc set-pen (get-border-color) 1 'solid)
                  (send dc draw-path border-path)
                  
                  ;; 3. Draw left accent bar
                  (when (>= h 36)
                    (send dc set-brush (get-accent-color) 'solid)
                    (send dc set-pen "white" 0 'transparent)
                    (send dc draw-rounded-rectangle 8 18 4 (- h 36) 2))
                  
                  ;; 4. Draw text
                  (send dc set-text-foreground (get-text-color))
                  (send dc set-font (font-regular))
                  (let-values ([(tw th _1 _2) (send dc get-text-extent message)])
                    (send dc draw-text message 28 (/ (- h th) 2))))))]))
    
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
              [target-y (+ TARGET-Y-START (* index (+ (toast-height) SPACING-LARGE)))])
          (send this move target-x target-y))))
    
    (define/public (launch index)
      (update-pos index)
      (send this show #t)
      (send auto-close-timer start 100 #f))
    
    ;; Override the show method to handle widget registration
    (define/override (show show?)
      (super show show?)
      (unless show?
        (unregister-widget this)))))

;; --- 管理器 ---
(define active-toasts '())

(define (show-toast msg #:type [t 'success])
  (letrec ([t-obj (new guix-toast% 
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

;; --- 导出 ---
(provide guix-toast%
         show-toast)