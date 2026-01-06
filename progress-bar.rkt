#lang racket/gui

(define modern-progress-bar%
  (class canvas%
    (init-field [progress 0.0] [target 0.0] [min-width 200] [min-height 12])
    
    (define/public (set-progress v)
      (set! target (max 0.0 (min 1.0 v))))
    
    (define/public (tick)
      (set! progress (+ progress (* 0.18 (- target progress))))
      (when (< (abs (- progress target)) 0.0005)
        (set! progress target))
      (send this refresh))
    
    (define/override (on-paint)
      (define dc (send this get-dc))
      (define w (send this get-width))
      (define h (send this get-height))
      
      (send dc set-smoothing 'aligned)
      (send dc clear)
      
      (define draw-h 12)
      (define y (/ (- h draw-h) 2))
      (define radius (/ draw-h 2))
      (define bar-width (* w progress))
      
      (define bg-color (make-object color% 238 238 242))
      (define fg-color (make-object color% 0 122 255))
      
      (send dc set-pen "transparent" 0 'solid)
      
      (send dc set-brush bg-color 'solid)
      (send dc draw-rounded-rectangle 0 y w draw-h radius)
      
      (when (> bar-width 1)
        (send dc set-brush fg-color 'solid)
        (send dc draw-rounded-rectangle 0 y bar-width draw-h radius)))
    
    (super-new [style '(transparent)] [min-width min-width] [min-height min-height])))

(provide modern-progress-bar%)