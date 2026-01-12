#lang racket/gui

;; Switch component
;; Modern switch toggle with customizable styles

(require racket/class
         racket/draw
         "../core/base-control.rkt"
         "../style/config.rkt")

(provide switch%
         guix-switch%)

(define switch%
  (class guix-base-control%
    (inherit get-client-size get-parent)
    
    ;;; Initialization parameters
    (init parent
          [label ""]
          [checked? #f]
          [enabled? #t]
          [callback #f])
    
    ;;; Instance variables
    (define current-parent parent)
    (define current-label label)
    (define checked-state checked?)
    (define callback-proc callback)
    
    ;;; Constructor
    (super-new 
     [parent parent]
     [enabled? enabled?]
     [min-width 200]
     [min-height 24])
    
    ;;; Render method (overridden from guix-base-control%)
    (define/override (render-control dc state theme)
      (let-values ([(width height) (get-client-size)])
        (let* ([switch-width 50]
               [switch-height 28]
               [switch-x 0]
               [switch-y (- (/ height 2) (/ switch-height 2))]
               [thumb-width 26]
               [thumb-height 28]
               [thumb-x (if checked-state
                            (- (+ switch-x switch-width) thumb-width)
                            (+ switch-x 0))]
               [thumb-y switch-y]
               [border-color (if (send this get-enabled)
                                 (if (eq? state 'hover)
                                     (color-border-hover)
                                     (color-border))
                                 (color-border))]
               [bg-color (if (send this get-enabled)
                             (if checked-state
                                 (color-accent)
                                 (if (equal? theme light-theme)
                                     (make-object color% 200 200 205)
                                     (make-object color% 60 60 65)))
                             (if (equal? theme light-theme)
                                 (make-object color% 242 242 247)
                                 (make-object color% 44 44 46)))]
               [thumb-color (if (send this get-enabled)
                                (make-object color% 255 255 255)
                                (if (equal? theme light-theme)
                                    (make-object color% 220 220 225)
                                    (make-object color% 80 80 85)))]
               [text-color (if (send this get-enabled)
                               (color-text-main)
                               (if (equal? theme light-theme)
                                   (make-object color% 170 170 170)
                                   (make-object color% 80 80 85)))])
          
          ; Draw switch background with border
          (send dc set-brush bg-color 'solid)
          (send dc set-pen border-color 1 'solid)
          (send dc draw-rounded-rectangle switch-x switch-y switch-width switch-height 2)
          
          ; Draw thumb with border
          (send dc set-brush thumb-color 'solid)
          (send dc set-pen border-color 1 'solid)
          (send dc draw-rounded-rectangle thumb-x thumb-y thumb-width thumb-height 2)
          
          ; Draw label
          (send dc set-text-foreground text-color)
          (send dc set-font (font-regular))
          (send dc draw-text current-label (+ switch-width 10) (- (/ height 2) 7)))))
    
    ;;; Mouse event handling (overridden from guix-base-control%)
    (define/override (handle-mouse-event event)
      (case (send event get-event-type)
        [(enter)
         (when (send this get-enabled)
           (set-field! state this 'hover)
           (send this refresh-now))]
        [(leave)
         (when (send this get-enabled)
           (set-field! state this 'normal)
           (send this refresh-now))]
        [(left-down)
         (when (send this get-enabled)
           (set-field! state this 'pressed)
           (send this refresh-now))]
        [(left-up)
         (when (and (send this get-enabled) (eq? (get-field state this) 'pressed))
           (set-field! state this 'normal)
           (set! checked-state (not checked-state))
           (when callback-proc
             (callback-proc this event))
           (send this refresh-now))]))
    
    ;;; Set checked state
    (define/public (set-checked! [on? #t])
      (set! checked-state on?)
      (send this refresh-now))
    
    ;;; Get checked state
    (define/public (get-checked)
      checked-state)
    
    ;;; Set label
    (define/public (set-switch-label! new-label)
      (set! current-label new-label)
      (send this refresh-now))
    
    ;;; Get label
    (define/public (get-switch-label)
      current-label)
    
    ;;; API consistency: get-enabled (inherited from base class)
    
    ;;; Set enabled state (inherited from base class)
    
    ;;; API consistency: set-enabled! (backward compatibility)
    (define/public (set-enabled! [on? #t])
      (send this set-enabled on?))
    
    ;;; Set callback function
    (define/public (set-callback! callback)
      (set! callback-proc callback))
    
    this)
  )

;; New guix-switch% with updated naming convention
(define guix-switch% switch%)
