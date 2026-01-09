#lang racket/gui

;; Guix - Modern Racket GUI Widget Library
;; Base control class for all Guix widgets

(require racket/class
         racket/gui/base
         "../style/config.rkt")

;; ===========================
;; Guix Base Control
;; ===========================
(define guix-base-control% 
  (class canvas%
    (init-field [enabled? #t]                 ; Control enabled state
                [visible? #t]                 ; Control visible state
                [theme (current-theme)]       ; Control theme
                [min-width 0]                 ; Minimum width constraint
                [min-height 0])               ; Minimum height constraint
    
    ;; ===========================
    ;; Local State
    ;; ===========================
    (field [state 'normal])                   ; Control state: normal | hover | pressed | disabled
    
    ;; ===========================
    ;; Initialization
    ;; ===========================
    (super-new [style '(no-focus)]
               [min-width min-width]
               [min-height min-height])
    
    ;; Set initial state based on enabled?
    (set! state (if enabled? 'normal 'disabled))
    
    ;; Register this widget for theme updates
    (register-widget this)
    
    ;; ===========================
    ;; Public Interface
    ;; ===========================
    
    ;; Get enabled state
    (define/public (get-enabled) enabled?)
    
    ;; Set enabled state and update control state
    (define/public (set-enabled e)
      (set! enabled? e)
      (set! state (if e 'normal 'disabled))
      (send this refresh-now))
    
    ;; Get current control state
    (define/public (get-state) state)
    
    ;; Get theme
    (define/public (get-theme) theme)
    
    ;; Set theme and refresh
    (define/public (set-theme t)
      (set! theme t)
      (send this refresh-now))
    
    ;; ===========================
    ;; Event Handling
    ;; ===========================
    
    ;; Mouse event handler - to be overridden by subclasses
    (define/public (handle-mouse-event event)
      (void))
    
    ;; Keyboard event handler - to be overridden by subclasses
    (define/public (handle-keyboard-event event)
      (void))
    
    ;; Event dispatcher
    (define/override (on-event event)
      (when enabled?
        (handle-mouse-event event)
        (handle-keyboard-event event)))
    
    ;; ===========================
    ;; Drawing
    ;; ===========================
    
    ;; Paint callback - entry point for rendering
    (define/override (on-paint)
      (define dc (send this get-dc))
      (render-control dc state theme))
    
    ;; Render control - must be overridden by subclasses
    (define/public (render-control dc state theme)
      (void))
    
    ;; ===========================
    ;; Helper Methods
    ;; ===========================
    
    ;; Invalidate the control (for backward compatibility)
    (define/public (invalidate)
      (send this refresh-now))
    
    ;; ===========================
    ;; Cleanup
    ;; ===========================
    
    ;; Unregister this widget when destroyed
    (define/public (on-destroy)
      (unregister-widget this))
    
    ))

;; ===========================
;; Export
;; ===========================
(provide guix-base-control%)