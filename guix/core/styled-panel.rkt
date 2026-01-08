#lang racket/gui

;; Styled Panel Component
;; A enhanced panel component with support for selected and hover states
;; and unified event handling

(require racket/class
         racket/draw
         "../style/config.rkt")

(provide styled-panel%)

;; ============================================================;
;; Styled Panel Widget - Enhanced panel with state support;
;; ============================================================;
(define styled-panel%
  (class vertical-panel%
    (init-field [parent #f]
                [selected? #f]
                [on-selection-change (lambda (selected) (void))]
                [style '()])
    
    (super-new [parent parent]
               [style style]
               [alignment '(left top)]
               [stretchable-height #f])
    
    ;; Instance variables to track current state
    (define current-selected selected?)
    (define hover? #f)
    
    ;; Create a canvas for drawing selection and hover effects
    (define background-canvas
      (new (class canvas%
             (init [parent #f])
             
             (super-new [parent parent]
                        [style '(transparent)]
                        [stretchable-width #t]
                        [stretchable-height #t])
             
             ;; Override on-paint to draw selection and hover effects
             (define/override (on-paint)
               (let ([dc (send this get-dc)]
                     [w (send this get-width)]
                     [h (send this get-height)])
                 
                 ;; Draw selection background
                 (when current-selected
                   (send dc set-brush (make-color 200 220 255 0.4) 'solid)
                   (send dc set-pen (make-color 150 200 255) 1 'solid)
                   (send dc draw-rectangle 0 0 w h))
                 
                 ;; Draw hover effect
                 (when (and hover? (not current-selected))
                   (send dc set-brush (make-color 240 240 240 0.4) 'solid)
                   (send dc set-pen "transparent" 0 'solid)
                   (send dc draw-rectangle 0 0 w h))))) 
           [parent this]))
    
    ;; Override on-subwindow-event to handle mouse events for the entire panel
    (define/override (on-subwindow-event receiver event)
      (define event-type (send event get-event-type))
      
      (cond
        ;; Handle left mouse button down - toggle selection
        [(equal? event-type 'left-down)
         (set-selected! (not current-selected))
         #f]  ; Return #f to allow event to propagate to child controls
        
        ;; Handle mouse enter - set hover state
        [(equal? event-type 'enter)
         (set! hover? #t)
         (send background-canvas refresh)
         #f]
        
        ;; Handle mouse leave - clear hover state
        [(equal? event-type 'leave)
         (set! hover? #f)
         (send background-canvas refresh)
         #f]
        
        [else
         ;; Let other events propagate normally
         (super on-subwindow-event receiver event)]))
    
    ;; Public method to set selected state
    (define/public (set-selected! val)
      (set! current-selected val)
      (on-selection-change current-selected)
      (send background-canvas refresh))
    
    ;; Public method to get selected state
    (define/public (is-selected?)
      current-selected)
    
    ;; Public method to get hover state
    (define/public (is-hover?)
      hover?)
    ))
