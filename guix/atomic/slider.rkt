#lang racket/gui

;; Slider component
;; Modern slider with customizable styles and ranges
;; Supports theme switching (light/dark)

(require racket/class
         racket/draw
         "../style/config.rkt")

(provide modern-slider%
         guix-slider%)

(define modern-slider% 
  (class slider%
    ;;; Initialization parameters
    (init parent
          [label ""]
          [min-value 0]
          [max-value 100]
          [init-value 0]
          [style '(horizontal plain)]
          [callback-proc #f])
    
    ;;; Instance variables
    (define current-callback callback-proc)
    (define min-val min-value)
    (define max-val max-value)
    
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
    
    ;;; Get minimum value (alias for consistency)
    (define/public (get-min-value)
      min-val)
    
    ;;; Get maximum value (alias for consistency)
    (define/public (get-max-value)
      max-val)
    
    ;;; Set value (alias for consistency)
    (define/public (set-value! val)
      (send this set-value val))
    
    ;;; Trigger callback manually (for testing)
    (define/public (callback slider event)
      (when current-callback
        (current-callback slider event)))
    
    this)
  )

;; New guix-slider% with updated naming convention
(define guix-slider% modern-slider%)