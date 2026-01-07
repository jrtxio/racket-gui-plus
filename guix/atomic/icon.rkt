#lang racket/gui

;; Icon component
;; Icon component with support for different sizes and styles

(require racket/class
         racket/draw
         "../style/config.rkt")

(provide icon%)

(define icon%
  (class canvas%
    (inherit get-client-size refresh)
    
    ;;; Initialization parameters
    (init parent
          [icon-name #f]
          [size 24]
          [color #f]
          [enabled? #t]
          [theme-aware? #t]
          [callback #f])
    
    ;;; Instance variables
    (define current-parent parent)
    (define current-icon-name icon-name)
    (define icon-size size)
    (define custom-color color)
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
     [min-width size]
     [min-height size])
    
    ;;; Theme management
    (when theme-aware
      (register-widget this))
    
    ;;; Drawing method
    (define (on-paint dc)
      (let-values ([(width height) (get-client-size)])
        (let* ([center-x (/ width 2)]
               [center-y (/ height 2)]
               [icon-color (if custom-color
                              custom-color
                              (if enabled-state
                                  (if hover?
                                      (color-accent)
                                      (color-text-main))
                                  (color-text-placeholder)))]
               [border-radius (border-radius-small)])
          
          ; Draw pressed state background
          (when pressed?
            (send dc set-smoothing 'smoothed)
            (send dc set-brush (color-bg-light) 'solid)
            (send dc set-pen "white" 0 'transparent)
            (send dc draw-rounded-rectangle 0 0 width height border-radius))
          
          ; Draw icon
          (send dc set-smoothing 'smoothed)
          (send dc set-brush "white" 'transparent)
          (send dc set-pen icon-color 2 'solid)
          
          (case current-icon-name
            [("plus")
             ;; Draw plus icon
             (send dc draw-line (- center-x 8) center-y (+ center-x 8) center-y)
             (send dc draw-line center-y (- center-y 8) center-y (+ center-y 8))]
            [("minus")
             ;; Draw minus icon
             (send dc draw-line (- center-x 8) center-y (+ center-x 8) center-y)]
            [("close")
             ;; Draw close icon
             (send dc draw-line (- center-x 8) (- center-y 8) (+ center-x 8) (+ center-y 8))
             (send dc draw-line (+ center-x 8) (- center-y 8) (- center-x 8) (+ center-y 8))]
            [("arrow-left")
             ;; Draw left arrow icon
             (send dc draw-line (- center-x 8) center-y (+ center-x 8) center-y)
             (send dc draw-line (- center-x 8) center-y (- center-x 2) (- center-y 6))
             (send dc draw-line (- center-x 8) center-y (- center-x 2) (+ center-y 6))]
            [("arrow-right")
             ;; Draw right arrow icon
             (send dc draw-line (- center-x 8) center-y (+ center-x 8) center-y)
             (send dc draw-line (+ center-x 8) center-y (+ center-x 2) (- center-y 6))
             (send dc draw-line (+ center-x 8) center-y (+ center-x 2) (+ center-y 6))]
            [("arrow-up")
             ;; Draw up arrow icon
             (send dc draw-line center-x (- center-y 8) center-x (+ center-y 8))
             (send dc draw-line center-x (- center-y 8) (- center-x 6) (- center-y 2))
             (send dc draw-line center-x (- center-y 8) (+ center-x 6) (- center-y 2))]
            [("arrow-down")
             ;; Draw down arrow icon
             (send dc draw-line center-x (- center-y 8) center-x (+ center-y 8))
             (send dc draw-line center-x (+ center-y 8) (- center-x 6) (+ center-y 2))
             (send dc draw-line center-x (+ center-y 8) (+ center-x 6) (+ center-y 2))]
            [("search")
             ;; Draw search icon
             (send dc draw-ellipse (- center-x 8) (- center-y 8) 16 16)
             (send dc draw-line (+ center-x 2) (+ center-y 2) (+ center-x 6) (+ center-y 6))]
            [("menu")
             ;; Draw menu icon
             (send dc draw-line (- center-x 8) (- center-y 6) (+ center-x 8) (- center-y 6))
             (send dc draw-line (- center-x 8) center-y (+ center-x 8) center-y)
             (send dc draw-line (- center-x 8) (+ center-y 6) (+ center-x 8) (+ center-y 6))]
            [("check")
             ;; Draw check icon
             (send dc draw-line (- center-x 6) center-y (- center-x 2) (+ center-y 4))
             (send dc draw-line (- center-x 2) (+ center-y 4) (+ center-x 6) (- center-y 4))]
            [("star")
             ;; Draw star icon (simplified)
             (send dc draw-line center-x (- center-y 8) center-x (- center-y 8))
             (send dc draw-line (+ center-x 6) (+ center-y 2) (+ center-x 6) (+ center-y 2))
             (send dc draw-line (- center-x 8) (+ center-y 4) (- center-x 8) (+ center-y 4))
             (send dc draw-line (+ center-x 8) (+ center-y 4) (+ center-x 8) (+ center-y 4))
             (send dc draw-line (- center-x 6) (+ center-y 2) (- center-x 6) (+ center-y 2))]
            [else
             ;; Draw default icon (question mark)
             (send dc draw-text "?" (- center-x 6) (- center-y 10))]))))
    
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
        [(motion)
         (set! hover? #t)
         (refresh)]
        [(left-down)
         (when enabled-state
           (set! pressed? #t)
           (refresh))]
        [(left-up)
         (when (and enabled-state pressed? hover? callback-proc)
           (callback-proc this event))
         (set! pressed? #f)
         (refresh)]))
    
    ;;; Override event handling
    (define/override (on-event event)
      (handle-mouse-event event)
      (super on-event event))
    
    ;;; Set icon name
    (define/public (set-icon-name! new-icon-name)
      (set! current-icon-name new-icon-name)
      (refresh))
    
    ;;; Get icon name
    (define/public (get-icon-name)
      current-icon-name)
    
    ;;; Set icon size
    (define/public (set-size! new-size)
      (set! icon-size new-size)
      (send this min-width new-size)
      (send this min-height new-size)
      (refresh))
    
    ;;; Get icon size
    (define/public (get-size)
      icon-size)
    
    ;;; Set icon color
    (define/public (set-color! new-color)
      (set! custom-color new-color)
      (refresh))
    
    ;;; Get icon color
    (define/public (get-color)
      custom-color)
    
    ;;; Set enabled state
    (define/public (set-enabled! [on? #t])
      (set! enabled-state on?)
      (refresh))
    
    ;;; Check if enabled
    (define/public (get-enabled-state)
      enabled-state)
    
    ))