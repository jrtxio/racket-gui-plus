#lang racket/gui

;; Checkbox component
;; Modern checkbox with customizable styles and states

(require racket/class
         racket/draw
         "../style/config.rkt")

(provide checkbox%
         guix-checkbox%)

(define checkbox%
  (class canvas%
    (inherit get-client-size get-parent)
    
    ;;; Initialization parameters
    (init parent
          [label ""]
          [checked? #f]
          [enabled? #t]
          [theme-aware? #t]
          [callback #f])
    
    ;;; Instance variables
    (define current-parent parent)
    (define current-label label)
    (define checked-state checked?)
    (define enabled-state enabled?)
    (define callback-proc callback)
    (define hover? #f)
    (define pressed? #f)
    (define theme-aware theme-aware?)
    
    ;;; Constructor
    (super-new 
     [parent parent]
     [paint-callback 
      (λ (canvas dc) 
        (on-paint dc))]
     [style '(transparent no-focus)]
     [min-width 30]  ; Reduce min-width to make checkbox more compact
     [stretchable-width #f]  ; Prevent checkbox from stretching
     [min-height 24])
    
    ;;; Theme management
    (when theme-aware
      (register-widget this))
    
    ;;; Drawing method
    (define (on-paint dc)
      (let-values ([(width height) (get-client-size)])
        (let* ([box-size 20]
               [box-x 0]
               [box-y (- (/ height 2) (/ box-size 2))]
               [label-x (+ box-size 10)]
               [label-y (- (/ height 2) 7)]
               [border-color (if enabled-state
                                 (if hover?
                                     (color-border-hover)
                                     (color-border))
                                 (color-border))]
               [bg-color (if enabled-state
                             (if checked-state
                                 (color-accent)
                                 (if (equal? (current-theme) light-theme)
                                     (make-object color% 255 255 255)
                                     (make-object color% 28 28 30)))
                             (if (equal? (current-theme) light-theme)
                                 (make-object color% 242 242 247)
                                 (make-object color% 44 44 46)))]
               [text-color (if enabled-state
                               (color-text-main)
                               (if (equal? (current-theme) light-theme)
                                   (make-object color% 170 170 170)
                                   (make-object color% 80 80 85)))]
               [check-color (make-object color% 255 255 255)])
          
          ; Draw checkbox background
          (send dc set-brush bg-color 'solid)
          (send dc set-pen border-color 1 'solid)
          (send dc draw-rounded-rectangle box-x box-y box-size box-size 4)
          
          ; Draw checkmark if checked
          (when (and checked-state enabled-state)
            (send dc set-brush check-color 'solid)
            (send dc set-pen check-color 2 'solid)
            (send dc draw-lines (list (cons (+ box-x 5) (+ box-y 10))
                                      (cons (+ box-x 8) (+ box-y 13))
                                      (cons (+ box-x 15) (+ box-y 6)))))
          
          ; Draw label
          (send dc set-text-foreground text-color)
          (send dc set-font (font-regular))
          (send dc draw-text current-label label-x label-y))))
    
    ;;; Handle mouse events
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
         (when (and pressed? hover? enabled-state)
           (set! checked-state (not checked-state))
           (when callback-proc
             (callback-proc this event)))
         (set! pressed? #f)
         (refresh)]))
    
    ;;; Override event handling
    (define/override (on-event event)
      (handle-mouse-event event)
      (super on-event event))
    
    ;;; Refresh method - respond to theme changes
    (define/override (refresh)
      (super refresh))
    
    ;;; Set checked state
    (define/public (set-checked! [on? #t])
      (set! checked-state on?)
      (refresh))
    
    ;;; Get checked state
    (define/public (get-checked)
      checked-state)
    
    ;;; Set label
    (define/public (set-checkbox-label! new-label)
      (set! current-label new-label)
      (send this refresh))
    
    ;;; Get label
    (define/public (get-checkbox-label)
      current-label)
    
    ;;; Set enabled state
    (define/public (set-enabled! [on? #t])
      (set! enabled-state on?)
      (send this refresh))
    
    ;;; Check if enabled
    (define/public (get-enabled-state)
      enabled-state)
    
    ;;; API consistency: get-enabled (same as get-enabled-state)
    (define/public (get-enabled)
      enabled-state)
    
    ;;; API consistency: set-enabled (same as set-enabled!)
    (define/public (set-enabled e)
      (set! enabled-state e)
      (send this refresh))
    
    ;;; Set callback function
    (define/public (set-callback! callback)
      (set! callback-proc callback))
    
    this)
  )

;; New guix-checkbox% with updated naming convention
(define guix-checkbox% checkbox%)
