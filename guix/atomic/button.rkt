#lang racket/gui

;; Button component
;; Modern button with customizable styles and states
;; Supports theme switching (light/dark) and different button types

(require racket/class
         racket/draw
         "../core/base-control.rkt"
         "../style/config.rkt")

(provide guix-button%
         button%
         modern-button%)

(define guix-button% 
  (class guix-base-control%
    (inherit get-client-size get-parent refresh)
    
    ;;; Initialization parameters
    (init parent
          [label "Button"]
          [type 'primary]      ; Button type: 'primary, 'secondary, 'text
          [on-click void])     ; Click callback
    
    ;;; Instance variables
    (field [current-label label]
           [current-type type]
           [on-click-callback on-click])
    
    ;;; Constructor
    (super-new 
     [parent parent]
     [min-width 100]
     [min-height (button-height)])
    
    ;;; Get background color based on button type and state
(define (get-background-color state theme)
  (if (send this get-enabled)
      (case current-type
        [(primary)
         (case state
           [(pressed) (color-bg-pressed)]
           [(hover) (color-accent)]
           [else (color-accent)])]
        [(secondary)
         (case state
           [(pressed) (color-bg-pressed)]
           [(hover) (color-bg-hover)]
           [else (color-bg-light)])]
        [(text) (make-object color% 0 0 0 0)]  ; Transparent background
        [else (color-accent)])
      ; Disabled state
      (color-bg-pressed)))

;;; Get text color based on button type and state
(define (get-text-color state theme)
  (if (send this get-enabled)
      (case current-type
        [(primary) (make-object color% 255 255 255)]
        [(secondary) (color-accent)]
        [(text) (color-accent)]
        [else (color-text-main)])
      ; Disabled state
      (color-text-disabled)))

;;; Get border color based on button type
(define (get-border-color state theme)
  (if (send this get-enabled)
      (case current-type
        [(primary) (make-object color% 0 0 0 0)]  ; Primary button has no border
        [(secondary) (color-border)]
        [(text) (make-object color% 0 0 0 0)]  ; Text button has no border
        [else (color-border)])
      (make-object color% 0 0 0 0)))
    
    ;;; Mouse event handling
    (define/override (handle-mouse-event event)
      (case (send event get-event-type)
        [(left-down)
         (set-field! state this 'pressed)
         (send this refresh-now)]
        [(left-up)
         (set-field! state this 'hover)
         (on-click-callback)
         (send this refresh-now)]
        [(enter)
         (when (eq? (get-field state this) 'normal)
           (set-field! state this 'hover)
           (send this refresh-now))]
        [(leave)
         (set-field! state this (if (send this get-enabled) 'normal 'disabled))
         (send this refresh-now)]))
    
    ;;; Drawing method as specified in PRD
    (define/override (render-control dc state theme)
      (let-values ([(width height) (get-client-size)])
      (let* ([bg-color (get-background-color state theme)]
             [text-color (get-text-color state theme)]
             [border-color (get-border-color state theme)])
        
        ; Clear the control area to match parent panel's background
        ; This prevents white artifacts around the button
        (send dc clear)
        
        ; Draw button background
        (send dc set-brush bg-color 'solid)
        (send dc set-pen border-color 1 'solid)
        ; Flat design: ≤2px radius
        (send dc draw-rounded-rectangle 0 0 width height 2)
        
        ; Draw text
        (send dc set-text-foreground text-color)
        (send dc set-font (font-regular))
        ; Calculate text position for proper alignment
        ; Center text horizontally and vertically in button
        (let-values ([(text-width text-height ascent descent) (send dc get-text-extent current-label)])
          (send dc draw-text current-label 
                (- (/ width 2) (/ text-width 2))  ; Center horizontally
                (- (/ height 2) (/ text-height 2)))))))
    
    ;;; Set button type
    (define/public (set-type! new-type)
      (set! current-type new-type)
      (send this refresh-now))
    
    ;;; Get button type
    (define/public (get-type)
      current-type)
    
    ;;; Set label
    (define/public (set-button-label! new-label)
      (set! current-label new-label)
      (send this refresh-now))
    
    ;;; Get label
    (define/public (get-button-label)
      current-label)
    
    ;;; Backward compatibility methods
    (define/public (get-enabled-state)
      (send this get-enabled))
    
    (define/public (set-enabled! [on? #t])
      (send this set-enabled on?))
    
    this)
  )

;; Alias for backward compatibility
(define button% guix-button%)

;; Modern button alias for backward compatibility
(define modern-button% guix-button%)
