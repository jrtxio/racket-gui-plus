#lang racket/gui

;; Stepper component
;; Modern stepper with increment/decrement functionality

(require racket/class
         racket/draw
         "../style/config.rkt")

(provide stepper%
         guix-stepper%)

(define stepper%
  (class canvas%
    (inherit get-client-size get-parent refresh)
    
    ;;; Initialization parameters
    (init parent
          [value 0]
          [min-value #f]
          [max-value #f]
          [step 1]
          [enabled? #t]
          [theme-aware? #t]
          [callback #f])
    
    ;;; Instance variables
    (define current-parent parent)
    (define current-value value)
    (define min-val min-value)
    (define max-val max-value)
    (define step-value step)
    (define enabled-state enabled?)
    (define callback-proc callback)
    (define hover-area #f) ; 'decrement, 'increment, or #f
    (define pressed-area #f) ; 'decrement, 'increment, or #f
    (define theme-aware theme-aware?)
    
    ;;; Constructor
    (super-new 
     [parent parent]
     [paint-callback 
      (λ (canvas dc) 
        (on-paint dc))]
     [style '(transparent no-focus)]
     [min-width 60]
     [min-height 24])
    
    ;;; Theme management
    (when theme-aware
      (register-widget this))
    
    ;;; Drawing method
    (define (on-paint dc)
      (let-values ([(width height) (get-client-size)])
        (let* ([half-width (/ width 2)]
               [border-radius (border-radius-small)]
               [border-color (if enabled-state
                                 (if hover-area
                                     (color-border-hover)
                                     (color-border))
                                 (color-border))]
               [bg-color (color-bg-white)]
               [arrow-color (if enabled-state
                                (if hover-area
                                    (color-accent)
                                    (color-text-main))
                                (color-text-placeholder))]
               [pressed-bg-color (if enabled-state
                                     (color-bg-light)
                                     bg-color)])
          
          ; Draw background rectangle
          (send dc set-smoothing 'smoothed)
          (send dc set-brush bg-color 'solid)
          (send dc set-pen border-color 1 'solid)
          (send dc draw-rounded-rectangle 0 0 width height border-radius)
          
          ; Draw dividing line
          (send dc set-pen border-color 1 'solid)
          (send dc draw-line half-width 4 half-width (- height 4))
          
          ; Draw decrement arrow (left half)
          (when (or (not pressed-area) (eq? pressed-area 'decrement))
            (let ([center-x (/ half-width 2)]
                  [center-y (/ height 2)])
              (send dc set-brush "white" 'transparent)
              (send dc set-pen arrow-color 2 'solid)
              (send dc draw-line (- center-x 6) center-y (+ center-x 6) center-y)
              (send dc draw-line (- center-x 6) center-y (- center-x 2) (- center-y 4))
              (send dc draw-line (- center-x 6) center-y (- center-x 2) (+ center-y 4))))
          
          ; Draw decrement arrow pressed state
          (when (and pressed-area (eq? pressed-area 'decrement))
            (let ([center-x (/ half-width 2)]
                  [center-y (/ height 2)])
              (send dc set-brush pressed-bg-color 'solid)
              (send dc set-pen border-color 1 'solid)
              (send dc draw-rounded-rectangle 0 0 half-width height border-radius)
              
              (send dc set-brush "white" 'transparent)
              (send dc set-pen (color-accent) 2 'solid)
              (send dc draw-line (- center-x 6) center-y (+ center-x 6) center-y)
              (send dc draw-line (- center-x 6) center-y (- center-x 2) (- center-y 4))
              (send dc draw-line (- center-x 6) center-y (- center-x 2) (+ center-y 4))))
          
          ; Draw increment arrow (right half)
          (when (or (not pressed-area) (eq? pressed-area 'increment))
            (let ([center-x (+ half-width (/ half-width 2))]
                  [center-y (/ height 2)])
              (send dc set-brush "white" 'transparent)
              (send dc set-pen arrow-color 2 'solid)
              (send dc draw-line (- center-x 6) center-y (+ center-x 6) center-y)
              (send dc draw-line (+ center-x 6) center-y (+ center-x 2) (- center-y 4))
              (send dc draw-line (+ center-x 6) center-y (+ center-x 2) (+ center-y 4))))
          
          ; Draw increment arrow pressed state
          (when (and pressed-area (eq? pressed-area 'increment))
            (let ([center-x (+ half-width (/ half-width 2))]
                  [center-y (/ height 2)])
              (send dc set-brush pressed-bg-color 'solid)
              (send dc set-pen border-color 1 'solid)
              (send dc draw-rounded-rectangle half-width 0 half-width height border-radius)
              
              (send dc set-brush "white" 'transparent)
              (send dc set-pen (color-accent) 2 'solid)
              (send dc draw-line (- center-x 6) center-y (+ center-x 6) center-y)
              (send dc draw-line (+ center-x 6) center-y (+ center-x 2) (- center-y 4))
              (send dc draw-line (+ center-x 6) center-y (+ center-x 2) (+ center-y 4)))))))
    
    ;;; Get area from mouse position
    (define (get-area x)
      (let-values ([(width height) (get-client-size)])
        (if (< x (/ width 2)) 'decrement 'increment)))
    
    ;;; Handle mouse events
    (define (handle-mouse-event event)
      (let-values ([(x y) (send event get-position)])
        (case (send event get-event-type)
          [(enter)
           (set! hover-area (get-area x))
           (refresh)]
          [(leave)
           (set! hover-area #f)
           (set! pressed-area #f)
           (refresh)]
          [(motion)
           (set! hover-area (get-area x))
           (refresh)]
          [(left-down)
           (when enabled-state
             (set! pressed-area (get-area x))
             (refresh))]
          [(left-up)
           (when (and enabled-state pressed-area (equal? pressed-area hover-area))
             (cond [(eq? pressed-area 'decrement)
                    (decrement)]
                   [(eq? pressed-area 'increment)
                    (increment)]))
           (set! pressed-area #f)
           (refresh)])))
    
    ;;; Override event handling
    (define/override (on-event event)
      (handle-mouse-event event)
      (super on-event event))
    
    ;;; Increment value
    (define (increment)
      (let ([new-value (+ current-value step-value)])
        (when (or (not max-val) (<= new-value max-val))
          (set! current-value new-value)
          (when callback-proc
            (callback-proc this current-value))
          (refresh))))
    
    ;;; Decrement value
    (define (decrement)
      (let ([new-value (- current-value step-value)])
        (when (or (not min-val) (>= new-value min-val))
          (set! current-value new-value)
          (when callback-proc
            (callback-proc this current-value))
          (refresh))))
    
    ;;; Set value
    (define/public (set-value! new-value)
      (set! current-value new-value)
      (refresh))
    
    ;;; Get value
    (define/public (get-value)
      current-value)
    
    ;;; Set minimum value
    (define/public (set-min-value! new-min)
      (set! min-val new-min)
      (refresh))
    
    ;;; Get minimum value
    (define/public (get-min-value)
      min-val)
    
    ;;; Set maximum value
    (define/public (set-max-value! new-max)
      (set! max-val new-max)
      (refresh))
    
    ;;; Get maximum value
    (define/public (get-max-value)
      max-val)
    
    ;;; Set step value
    (define/public (set-step! new-step)
      (set! step-value new-step)
      (refresh))
    
    ;;; Get step value
    (define/public (get-step)
      step-value)
    
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
    
    ))

;; New guix-stepper% with updated naming convention
(define guix-stepper% stepper%)