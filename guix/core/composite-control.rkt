#lang racket/gui

;; Guix - Modern Racket GUI Widget Library
;; Composite control base class for widgets that need internal hit-testing

(require racket/class
         racket/gui/base
         racket/match
         "base-control.rkt"
         "event.rkt"
         "../style/config.rkt")

;; ===========================
;; Composite Control Base Class
;; ===========================
(define guix-composite-control%
  (class guix-base-control%
    ;; Control state extensions for composite controls
    (init-field [focused-region #f]          ; Currently focused region (symbol)
                [hovered-region #f])         ; Currently hovered region (symbol)
    
    ;; ===========================
    ;; Region Management
    ;; ===========================
    
    ;; Region definitions - to be overridden by subclasses
    (define/public (get-regions) '())
    
    ;; Hit test implementation - to be overridden by subclasses
    ;; Returns region symbol based on coordinates
    (define/public (hit-test x y) #f)
    
    ;; Get region bounds - to be overridden by subclasses
    ;; Returns (list left top right bottom) for given region
    (define/public (get-region-bounds region) #f)
    
    ;; ===========================
    ;; Event Handling - Enhanced for Composite Controls
    ;; ===========================
    
    ;; Track mouse position for hover detection
    (field [last-mouse-x -1]
           [last-mouse-y -1])
    
    ;; Handle mouse event with region detection
    (define/override (handle-mouse-event event)
      (define event-type (send event get-event-type))
      (define x (send event get-x))
      (define y (send event get-y))
      
      (match event-type
        ;; Mouse motion - track hover regions
        ['motion
         (define current-region (hit-test x y))
         
         ;; Handle hover exit from previous region
         (unless (equal? current-region hovered-region)
           (when hovered-region
             (on-region-hover-exit hovered-region))
           (set! hovered-region current-region)
           (when current-region
             (on-region-hover-enter current-region))
           (send this refresh-now))]
        
        ;; Mouse button events - dispatch to regions
        ['left-down
         (define clicked-region (hit-test x y))
         (when clicked-region
           (on-region-click clicked-region event))]
        
        ['left-up
         (define clicked-region (hit-test x y))
         (when clicked-region
           (on-region-release clicked-region event))]
        
        ;; Mouse exit - clear hover state
        ['leave
         (when hovered-region
           (on-region-hover-exit hovered-region)
           (set! hovered-region #f)
           (send this refresh-now))]
        
        ;; Mouse enter - update hover state
        ['enter
         (define current-region (hit-test x y))
         (unless (equal? current-region hovered-region)
           (when hovered-region
             (on-region-hover-exit hovered-region))
           (set! hovered-region current-region)
           (when current-region
             (on-region-hover-enter current-region))
           (send this refresh-now))]
        
        [_ ;; Ignore other events
         (void)])
  )
    
    ;; Handle keyboard events - focus management
    (define/override (handle-keyboard-event event)
      (when focused-region
        (on-region-key-event focused-region event)))
    
    ;; ===========================
    ;; Region Event Callbacks - To be overridden by subclasses
    ;; ===========================
    
    ;; Called when mouse enters a region
    (define/public (on-region-hover-enter region)
      (void))
    
    ;; Called when mouse exits a region
    (define/public (on-region-hover-exit region)
      (void))
    
    ;; Called when mouse button is pressed in a region
    (define/public (on-region-click region event)
      (void))
    
    ;; Called when mouse button is released in a region
    (define/public (on-region-release region event)
      (void))
    
    ;; Called when keyboard event occurs while region is focused
    (define/public (on-region-key-event region event)
      (void))
    
    ;; ===========================
    ;; Focus Management
    ;; ===========================
    
    ;; Set focus to a specific region
    (define/public (set-focused-region region)
      (unless (equal? region focused-region)
        (when focused-region
          (on-region-focus-exit focused-region))
        (set! focused-region region)
        (when region
          (on-region-focus-enter region))
        (send this refresh-now)))
    
    ;; Get currently focused region
    (define/public (get-focused-region) focused-region)
    
    ;; Get currently hovered region
    (define/public (get-hovered-region) hovered-region)
    
    ;; Region focus callbacks
    (define/public (on-region-focus-enter region)
      (void))
    
    (define/public (on-region-focus-exit region)
      (void))
    
    ;; ===========================
    ;; Rendering Helpers
    ;; ===========================
    
    ;; Draw a region boundary (for debugging)
    (define/public (draw-region-boundary dc region color)
      (define bounds (get-region-bounds region))
      (when bounds
        (match-define (list left top right bottom) bounds)
        (send dc set-pen color 1 'short-dash)
        (send dc draw-rectangle left top (- right left) (- bottom top))))
    
    ;; ===========================
    ;; Initialization
    ;; ===========================
    (super-new)
    ))

;; ===========================
;; Export
;; ===========================
(provide guix-composite-control%)
