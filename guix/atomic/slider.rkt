#lang racket/gui

;; Slider component
;; Modern slider with customizable styles and ranges
;; Supports theme switching (light/dark)

(require racket/class
         racket/draw
         "../style/config.rkt")

(provide modern-slider%)

(define modern-slider% 
  (class slider%
    ;;; Initialization parameters
    (init parent
          [label ""]
          [min-value 0]
          [max-value 100]
          [init-value 0]
          [style '(horizontal plain)]
          [callback #f])
    
    ;;; Instance variables
    (define current-callback callback)
    
    ;;; Constructor
    (super-new 
     [parent parent]
     [label label]
     [min-value min-value]
     [max-value max-value]
     [init-value init-value]
     [style style]
     [callback (λ (slider event) 
                 (when current-callback
                   (current-callback slider event)))])
    
    ;;; Register widget for theme updates
    (register-widget this)
    
    this)
  )