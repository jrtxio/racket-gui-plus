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
                [on-change void]              ; Change event callback
                [on-click void]               ; Click event callback
                [on-hover void]               ; Hover event callback
                [on-focus void]               ; Focus event callback
                [on-blur void]                ; Blur event callback
                [parent #f]                   ; Parent container
                [width #f]                    ; Control width
                [height #f]                   ; Control height
                [min-width #f]                ; Minimum width constraint
                [max-width #f]                ; Maximum width constraint
                [min-height #f]               ; Minimum height constraint
                [max-height #f]               ; Maximum height constraint
                [stretch 1.0])                ; Stretch factor for layout
    
    ;; ===========================
    ;; Local State
    ;; ===========================
    (field [hover? #f]                       ; Mouse hover state
           [pressed? #f]                     ; Mouse pressed state
           [focused? #f]                     ; Keyboard focus state
           [local-value #f])                 ; Local value storage
    
    ;; ===========================
    ;; Initialization
    ;; ===========================
    (super-new [parent parent]
               [style (list* (if visible? 'transparent 'hidden)
                             '(no-autoclear))]
               [enabled enabled?]
               [paint-callback (λ (canvas dc) (send canvas draw dc))])
    
    ;; Set initial size if provided
    (when (and width height)
      (send this min-width width)
      (send this min-height height)
      (send this resize width height))
    
    ;; Register this widget for theme updates
    (register-widget this)
    
    ;; ===========================
    ;; State Management
    ;; ===========================
    
    ;; Get/Set enabled state
    (define/public (get-enabled) enabled?)
    (define/public (set-enabled e)
      (set! enabled? e)
      (send this enable e)
      (invalidate))
    
    ;; Get/Set visible state
    (define/public (get-visible) visible?)
    (define/public (set-visible v)
      (set! visible? v)
      (send this show v)
      (invalidate))
    
    ;; Get/Set value (with change event)
    (define/public (get-value) local-value)
    (define/public (set-value v)
      (when (not (equal? v local-value))
        (set! local-value v)
        (invalidate)
        (on-change v)))
    
    ;; Get/Set theme
    (define/public (get-theme) theme)
    (define/public (set-theme t)
      (set! theme t)
      (invalidate))
    
    ;; Get/Set hover state
    (define/public (get-hover) hover?)
    (define/public (set-hover h)
      (set! hover? h)
      (invalidate))
    
    ;; Get/Set pressed state
    (define/public (get-pressed) pressed?)
    (define/public (set-pressed p)
      (set! pressed? p)
      (invalidate))
    
    ;; Get/Set focused state
    (define/public (get-focused) focused?)
    (define/public (set-focused f)
      (set! focused? f)
      (invalidate)
      (if f (on-focus) (on-blur)))
    
    ;; ===========================
    ;; Event Handling
    ;; ===========================
    
    ;; Mouse event handling
    (define/override (on-event event)
      (cond
        [(send event button-down?)
         (set! pressed? #t)
         (invalidate)]
        [(send event button-up?)
         (set! pressed? #f)
         (when hover?
           (on-click event))
         (invalidate)]
        [(equal? (send event get-event-type) 'enter)
         (set! hover? #t)
         (on-hover event)
         (invalidate)]
        [(equal? (send event get-event-type) 'leave)
         (set! hover? #f)
         (set! pressed? #f)
         (invalidate)]
        [(equal? (send event get-event-type) 'focus)
         (set! focused? #t)
         (on-focus)
         (invalidate)]
        [(equal? (send event get-event-type) 'blur)
         (set! focused? #f)
         (on-blur)
         (invalidate)]))
    
    ;; ===========================
    ;; Layout and Sizing
    ;; ===========================
    
    ;; Get minimum width constraint
    (define/public (get-min-width)
      (if min-width min-width 0))
    
    ;; Get minimum height constraint
    (define/public (get-min-height)
      (if min-height min-height 0))
    
    ;; Get maximum width constraint
    (define/public (get-max-width)
      (if max-width max-width +inf.0))
    
    ;; Get maximum height constraint
    (define/public (get-max-height)
      (if max-height max-height +inf.0))
    
    ;; Get stretch factor
    (define/public (get-stretch)
      stretch)
    
    ;; Resize callback
    (define/public (on-resize width height)
      ;; Override in subclasses if needed
      (void))
    
    ;; ===========================
    ;; Drawing
    ;; ===========================
    
    ;; Paint callback - override in subclasses
    (define/public (draw dc)
      ;; Default implementation - override in subclasses
      (void))
    
    ;; Convenience method to invalidate the control
    (define/public (invalidate)
      (when (is-a? this area<%>)
        (send this refresh)))
    
    ;; ===========================
    ;; Theme Management
    ;; ===========================
    
    ;; Apply theme to this control
    (define/public (apply-theme new-theme)
      (set-theme new-theme)
      (invalidate))
    
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