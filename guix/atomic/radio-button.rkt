#lang racket/gui

;; Radio button component
;; Modern radio button with customizable styles

(require racket/class
         racket/draw
         "../core/base-control.rkt"
         "../style/config.rkt")

(provide radio-button%
         guix-radio-button%)

(define guix-radio-button%
  (class guix-base-control%
    (inherit get-client-size get-parent)
    
    ;;; Initialization parameters
    (init parent
          [label ""]
          [checked? #f]
          [enabled? #t]
          [on-change void]
          [theme-aware? #t]  ; For backward compatibility
          [callback #f])  ; For backward compatibility
    
    ;;; Instance variables
    (field [current-label label]
           [checked-state checked?]
           [on-change-callback (if callback callback on-change)])
    
    ;;; Constructor
    (super-new 
     [parent parent]
     [enabled? enabled?]
     [min-width 200]
     [min-height 24])
    
    ;;; Mouse event handling
    (define/override (handle-mouse-event event)
      (case (send event get-event-type)
        [(enter)
         (when (and (send this get-enabled) (eq? (get-field state this) 'normal))
           (set-field! state this 'hover)
           (send this refresh-now))]
        [(leave)
         (set-field! state this (if (send this get-enabled) 'normal 'disabled))
         (send this refresh-now)]
        [(left-down)
         (when (send this get-enabled)
           (set-field! state this 'pressed)
           (send this refresh-now))]
        [(left-up)
         (when (send this get-enabled)
           (set-field! state this 'hover)
           (set! checked-state #t) ; Radio buttons become checked when clicked (unlike checkboxes which toggle)
           ;; Call callback with either 1 or 2 arguments depending on its arity
           (if (procedure-arity-includes? on-change-callback 2)
               (on-change-callback this event)
               (on-change-callback checked-state))
           (send this refresh-now))]))
    
    ;;; Drawing method as specified in PRD
    (define/override (render-control dc state theme)
      (let-values ([(width height) (get-client-size)])
        (let* ([radius 10] ; Radio button radius
               [center-x radius]
               [center-y (/ height 2)]
               [label-x (+ (* radius 3) 5)]
               [label-y (- (/ height 2) 7)]
               [enabled? (send this get-enabled)]
               [border-color (if enabled?
                                 (if (eq? state 'hover)
                                     (color-border-hover)
                                     (color-border))
                                 (color-border))]
               [bg-color (if enabled?
                             (if checked-state
                                 (color-accent)
                                 (color-bg-white))
                             (color-bg-pressed))]
               [text-color (if enabled?
                               (color-text-main)
                               (color-text-disabled))]
               [dot-color (make-object color% 255 255 255)])
          
          ; Draw radio button background
          (send dc set-brush bg-color 'solid)
          (send dc set-pen border-color 2 'solid)
          (send dc draw-ellipse (- center-x radius) (- center-y radius) (* radius 2) (* radius 2))
          
          ; Draw inner dot if checked
          (when (and checked-state enabled?)
            (send dc set-brush dot-color 'solid)
            (send dc set-pen dot-color 1 'solid)
            (send dc draw-ellipse (- center-x 5) (- center-y 5) 10 10))
          
          ; Draw label
          (send dc set-text-foreground text-color)
          (send dc set-font (font-regular))
          (send dc draw-text current-label label-x label-y))))
    
    ;;; Set checked state
    (define/public (set-checked! [on? #t])
      (set! checked-state on?)
      (send this refresh-now))
    
    ;;; Get checked state
    (define/public (get-checked)
      checked-state)
    
    ;;; Set label
    (define/public (set-radio-label! new-label)
      (set! current-label new-label)
      (send this refresh-now))
    
    ;;; Get label
    (define/public (get-radio-label)
      current-label)
    
    ;;; Set enabled state
    (define/override (set-enabled e)
      (super set-enabled e)
      (send this refresh-now))
    
    ;;; Backward compatibility methods
    (define/public (get-enabled-state)
      (send this get-enabled))
    
    (define/public (set-enabled! [on? #t])
      (send this set-enabled on?))
    
    this)
  )

;; Alias for backward compatibility
(define radio-button% guix-radio-button%)