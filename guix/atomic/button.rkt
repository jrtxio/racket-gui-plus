#lang racket/gui

;; Button component
;; Modern button with customizable styles and states
;; Supports theme switching (light/dark) and different button types

(require racket/class
         racket/draw
         "../core/base-control.rkt"
         "../core/event.rkt"
         "../core/state.rkt"
         "../core/layout.rkt"
         "../style/config.rkt")

(provide modern-button%
         guix-button%
         button%)

(define modern-button% 
  (class guix-base-control%
    (inherit get-client-size get-parent invalidate)
    
    ;;; Initialization parameters
    (init parent
          [label "Button"]
          [type 'primary]      ; Button type: 'primary, 'secondary, 'text
          [theme-aware? #t]    ; Whether to respond to theme changes
          [radius 'medium]     ; Border radius: 'small, 'medium, 'large
          [enabled? #t]        ; Whether to enable
          [callback #f])       ; Click callback
    
    ;;; Instance variables
    (define current-label label)
    (define current-type type)
    (define current-radius radius)
    
    ;;; Constructor
    (super-new 
     [parent parent]
     [enabled? enabled?]
     [on-click (λ (event) (when callback (callback this event)))])
    
    ;;; Set minimum size
    (send this min-width 100)
    (send this min-height (button-height))
    
    ;;; Theme management is handled by base-control
    
    ;;; Get current border radius value
    (define (get-radius-value)
      (case current-radius
        [(small) (border-radius-small)]
        [(medium) (border-radius-medium)]
        [(large) (border-radius-large)]
        [else (border-radius-medium)]))
    
    ;;; Get background color based on button type and state
    (define (get-background-color)
      (if (send this get-enabled)
          (case current-type
            [(primary)
             (if (send this get-pressed)
                 (color-accent-pressed)
                 (color-accent))]
            [(secondary)
             (if (send this get-pressed)
                 (color-bg-pressed)
                 (color-bg-light))]
            [(text) (make-object color% 0 0 0 0)]  ; Transparent background
            [else (color-accent)])
          ; Disabled state
          (color-bg-pressed)))
    
    ;;; Get text color based on button type and state
    (define (get-text-color)
      (if (send this get-enabled)
          (case current-type
            [(primary) (make-object color% 255 255 255)]
            [(secondary) (color-accent)]
            [(text) (color-accent)]
            [else (color-text-main)])
          ; Disabled state
          (color-text-disabled)))
    
    ;;; Get border color based on button type
    (define (get-border-color)
      (if (send this get-enabled)
          (case current-type
            [(primary) (make-object color% 0 0 0 0)]  ; Primary button has no border
            [(secondary) (color-border)]
            [(text) (make-object color% 0 0 0 0)]  ; Text button has no border
            [else (color-border)])
          (make-object color% 0 0 0 0)))
    
    ;;; Drawing method
    (define/override (draw dc)
      (let-values ([(width height) (get-client-size)])
      (let* ([radius (get-radius-value)]
             [bg-color (get-background-color)]
             [text-color (get-text-color)]
             [border-color (get-border-color)])
        
        ; Draw background
        (send dc set-brush bg-color 'solid)
        (send dc set-pen border-color 1 'solid)
        (send dc draw-rounded-rectangle 0 0 width height radius)
        
        ; Draw text
        (send dc set-text-foreground text-color)
        (send dc set-font (font-regular))
        (send dc draw-text current-label 10 (- (/ height 2) 7)))))
    
    ;;; Set button type
    (define/public (set-type! new-type)
      (set! current-type new-type)
      (invalidate))
    
    ;;; Get button type
    (define/public (get-type)
      current-type)
    
    ;;; Set label
    (define/public (set-button-label! new-label)
      (set! current-label new-label)
      (invalidate))
    
    ;;; Get label
    (define/public (get-button-label)
      current-label)
    
    ;;; Set border radius
    (define/public (set-radius! new-radius)
      (set! current-radius new-radius)
      (invalidate))
    
    ;;; Get border radius
    (define/public (get-radius)
      current-radius)
    
    ;;; Set enabled state (override to ensure proper invalidation)
    (define/override (set-enabled e)
      (super set-enabled e)
      (invalidate))
    
    ;;; Backward compatibility methods
    (define/public (get-enabled-state)
      (send this get-enabled))
    
    (define/public (set-enabled! [on? #t])
      (send this set-enabled on?))
    
    this)
  )

;; New guix-button% with updated naming convention
(define guix-button% modern-button%)
