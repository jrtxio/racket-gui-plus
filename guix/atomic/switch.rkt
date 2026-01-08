#lang racket/gui

;; Switch component
;; Modern switch toggle with customizable styles

(require racket/class
         racket/draw
         "../style/config.rkt")

(provide switch%
         guix-switch%)

(define switch%
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
     [min-width 200]
     [min-height 24])
    
    ;;; Theme management
    (when theme-aware
      (register-widget this))
    
    ;;; Drawing method
    (define (on-paint dc)
      (let-values ([(width height) (get-client-size)])
        (let* ([switch-width 50]
               [switch-height 28]
               [switch-x 0]
               [switch-y (- (/ height 2) (/ switch-height 2))]
               [thumb-width 24]
               [thumb-height 24]
               [thumb-x (if checked-state
                            (+ switch-x switch-width thumb-width -1)
                            (+ switch-x 2))]
               [thumb-y (- (/ height 2) (/ thumb-height 2))]
               [border-color (if enabled-state
                                 (if hover?
                                     (color-border-hover)
                                     (color-border))
                                 (color-border))]
               [bg-color (if enabled-state
                             (if checked-state
                                 (color-accent)
                                 (if (equal? (current-theme) light-theme)
                                     (make-object color% 200 200 205)
                                     (make-object color% 60 60 65)))
                             (if (equal? (current-theme) light-theme)
                                 (make-object color% 242 242 247)
                                 (make-object color% 44 44 46)))]
               [thumb-color (if enabled-state
                                (make-object color% 255 255 255)
                                (if (equal? (current-theme) light-theme)
                                    (make-object color% 220 220 225)
                                    (make-object color% 80 80 85)))]
               [text-color (if enabled-state
                               (color-text-main)
                               (if (equal? (current-theme) light-theme)
                                   (make-object color% 170 170 170)
                                   (make-object color% 80 80 85)))
               ])
          
          ; Draw switch background
          (send dc set-brush bg-color 'solid)
          (send dc set-pen bg-color 0 'solid)
          (send dc draw-rounded-rectangle switch-x switch-y switch-width switch-height (/ switch-height 2))
          
          ; Draw thumb
          (send dc set-brush thumb-color 'solid)
          (send dc set-pen border-color 1 'solid)
          (send dc draw-rounded-rectangle thumb-x thumb-y thumb-width thumb-height (/ thumb-height 2))
          
          ; Draw label
          (send dc set-text-foreground text-color)
          (send dc set-font (font-regular))
          (send dc draw-text current-label (+ switch-width 10) (- (/ height 2) 7)))))
    
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
    (define/public (set-switch-label! new-label)
      (set! current-label new-label)
      (send this refresh))
    
    ;;; Get label
    (define/public (get-switch-label)
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

;; New guix-switch% with updated naming convention
(define guix-switch% switch%)
