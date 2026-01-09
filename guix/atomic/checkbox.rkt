#lang racket/gui

;; Checkbox component
;; Modern checkbox with customizable styles and states

(require racket/class
         racket/draw
         "../core/base-control.rkt"
         "../style/config.rkt")

(provide checkbox%
         guix-checkbox%)

(define guix-checkbox%
  (class guix-base-control%
    (inherit get-client-size get-parent refresh)
    
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
     [min-width 150]  ; Set minimum width to accommodate text
     [stretchable-width #t]  ; Allow checkbox to stretch based on text length
     [min-height 24])
    
    ;;; Backward compatibility methods
    (define/public (get-enabled-state)
      (send this get-enabled))
    
    (define/public (set-enabled! [on? #t])
      (send this set-enabled on?))
    
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
           (set! checked-state (not checked-state))
           ;; Call callback with either 1 or 2 arguments depending on its arity
           (if (procedure-arity-includes? on-change-callback 2)
               (on-change-callback this event)
               (on-change-callback checked-state))
           (send this refresh-now))]))
    
    ;;; Drawing method as specified in PRD
    (define/override (render-control dc state theme)
      (let-values ([(width height) (get-client-size)])
        (let* ([box-size 20]
               [box-x 0]
               [box-y (- (/ height 2) (/ box-size 2))]
               [label-x (+ box-size 10)]
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
               [check-color (make-object color% 255 255 255)]
               [control-bg-color (color-bg-white)])  ; Use theme background color for control
          
          ; Clear the control area to match parent panel's background
          ; This prevents white artifacts around the checkbox
          (send dc clear)
          
          ; Draw checkbox background
          (send dc set-brush bg-color 'solid)
          (send dc set-pen border-color 1 'solid)
          ; Flat design: ≤2px radius
          (send dc draw-rounded-rectangle box-x box-y box-size box-size 2)
          
          ; Draw inner dot if checked
          (when (and checked-state (send this get-enabled))
            (send dc set-brush check-color 'solid)
            (send dc set-pen check-color 2 'solid)
            (send dc draw-lines (list (cons (+ box-x 5) (+ box-y 10))
                                      (cons (+ box-x 8) (+ box-y 13))
                                      (cons (+ box-x 15) (+ box-y 6)))))          
          ; Draw label
          (send dc set-text-foreground text-color)
          (send dc set-font (font-regular))
          ; Calculate text vertical position for proper alignment
          ; Center text vertically with checkbox
          (let-values ([(text-width text-height ascent descent) (send dc get-text-extent current-label)])
            (send dc draw-text current-label label-x (- (/ height 2) (/ text-height 2)))))))
    
    ;;; Set checked state
    (define/public (set-checked! [on? #t])
      (set! checked-state on?)
      (send this refresh-now))
    
    ;;; Get checked state
    (define/public (get-checked)
      checked-state)
    
    ;;; Set label
    (define/public (set-checkbox-label! new-label)
      (set! current-label new-label)
      (send this refresh-now))
    
    ;;; Get label
    (define/public (get-checkbox-label)
      current-label)
    
    ;;; Set enabled state
    (define/override (set-enabled e)
      (super set-enabled e)
      (send this refresh-now))
    
    this)
  )

;; Alias for backward compatibility
(define checkbox% guix-checkbox%)
