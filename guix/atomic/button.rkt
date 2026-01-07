#lang racket/gui

;; Button component
;; Modern button with customizable styles and states
;; Supports theme switching (light/dark) and different button types

(require racket/class
         racket/draw
         "../style/config.rkt")

(provide modern-button%)

(define modern-button% 
  (class canvas% 
    (inherit get-client-size get-parent)
    
    ;;; Initialization parameters
    (init parent
          [label "Button"]
          [type 'primary]      ; Button type: 'primary, 'secondary, 'text
          [theme-aware? #t]    ; Whether to respond to theme changes
          [radius 'medium]     ; Border radius: 'small, 'medium, 'large
          [enabled? #t]        ; Whether to enable
          [callback #f])       ; Click callback
    
    ;;; Instance variables
    (define current-parent parent)
    (define current-label label)
    (define current-type type)
    (define current-radius radius)
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
     [min-width 100]
     [min-height (button-height)])
    
    ;;; Theme management
    (when theme-aware
      (register-widget this))
    
    ;;; Get current border radius value
    (define (get-radius-value)
      (case current-radius
        [(small) (border-radius-small)]
        [(medium) (border-radius-medium)]
        [(large) (border-radius-large)]
        [else (border-radius-medium)]))
    
    ;;; Get background color based on button type and state
    (define (get-background-color)
      (if enabled-state
          (case current-type
            [(primary)
             (if pressed?
                 (make-object color% 0 90 200)  ; Pressed state color
                 (color-accent))]  ; Normal state color
            [(secondary)
             (if pressed?
                 (if (equal? (current-theme) light-theme)
                     (make-object color% 220 220 225)
                     (make-object color% 50 50 55))
                 (color-bg-light))]
            [(text) (make-object color% 0 0 0 0)]  ; Transparent background
            [else (color-accent)])
          ; Disabled state
          (if (equal? (current-theme) light-theme)
              (make-object color% 230 230 235)
              (make-object color% 35 35 38))))
    
    ;;; Get text color based on button type and state
    (define (get-text-color)
      (if enabled-state
          (case current-type
            [(primary) (make-object color% 255 255 255)]
            [(secondary) (color-accent)]
            [(text) (color-accent)]
            [else (color-text-main)])
          ; Disabled state
          (if (equal? (current-theme) light-theme)
              (make-object color% 170 170 170)
              (make-object color% 80 80 85))))
    
    ;;; Get border color based on button type
    (define (get-border-color)
      (if enabled-state
          (case current-type
            [(primary) (make-object color% 0 0 0 0)]  ; Primary button has no border
            [(secondary) (color-border)]
            [(text) (make-object color% 0 0 0 0)]  ; Text button has no border
            [else (color-border)])
          (make-object color% 0 0 0 0)))
    
    ;;; Drawing method
    (define (on-paint dc)
      (let-values ([(width height) (get-client-size)])
      (let* ([radius (get-radius-value)]
             [bg-color (get-background-color)]
             [text-color (get-text-color)]
             [border-color (get-border-color)])
        
        ; Draw background
        (send dc set-brush bg-color 'solid)
        (send dc set-pen border-color 1 'solid)
        (send dc draw-rounded-rectangle 0 0 width height radius)
        
        ; 绘制文本
        (send dc set-text-foreground text-color)
        (send dc set-font (font-regular))
        (send dc draw-text current-label 10 (- (/ height 2) 7)))))
    
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
         (when (and pressed? hover? enabled-state callback-proc)
           (callback-proc this event))
         (set! pressed? #f)
         (refresh)]))
    
    ;;; Override event handling
    (define/override (on-event event)
      (handle-mouse-event event)
      (super on-event event))
    
    ;;; Refresh method - respond to theme changes
    (define/override (refresh)
      (super refresh))
    
    ;;; Set button type
    (define/public (set-type! new-type)
      (set! current-type new-type)
      (refresh))
    
    ;;; Get button type
    (define/public (get-type)
      current-type)
    
    ;;; Set label
    (define/public (set-button-label! new-label)
      (set! current-label new-label)
      (send this refresh))
    
    ;;; Get label
    (define/public (get-button-label)
      current-label)
    
    ;;; Set border radius
    (define/public (set-radius! new-radius)
      (set! current-radius new-radius)
      (refresh))
    
    ;;; Get border radius
    (define/public (get-radius)
      current-radius)
    
    ;;; Set enabled state
    (define/public (set-enabled! [on? #t])
      (set! enabled-state on?)
      (send this refresh))
    
    ;;; Check if enabled
    (define/public (get-enabled-state)
      enabled-state)
    
    ;;; Set callback function
    (define/public (set-callback! callback)
      (set! callback-proc callback))
    
    this)
  )
