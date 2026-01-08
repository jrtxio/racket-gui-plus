#lang racket/gui

;; Guix - Modern Racket GUI Widget Library
;; Light theme preset

(require racket/class
         racket/hash
         "../colors.rkt"
         "../typography.rkt")

;; ===========================
;; Light Theme Definition
;; ===========================

(define light-theme
  (hash
   ;; Theme metadata
   'name "light"
   'display-name "Light"
   
   ;; Color palette
   'colors light-colors
   
   ;; Typography configuration
   'typography (make-typography-config)
   
   ;; Border radius configuration (pixels)
   'border-radius
   (hash 'small 6
         'medium 10
         'large 14)
   
   ;; Spacing configuration (pixels)
   'spacing
   (hash 'xs 4
         'sm 8
         'md 10
         'lg 14
         'xl 20
         'xxl 28)
   
   ;; Widget size configuration (pixels)
   'widget-sizes
   (hash 'input-height 40
         'button-height 40
         'progress-bar-height 12
         'toast-height 68
         'toast-width 340
         'icon-small 16
         'icon-medium 20
         'icon-large 24
         'slider-height 4
         'switch-height 28
         'switch-width 52
         'stepper-size 32)
   
   ;; Shadow configuration
   'shadows
   (hash 'small (list 0 2 4 0 (hash-ref light-colors 'shadow-light))
         'medium (list 0 4 12 0 (hash-ref light-colors 'shadow-medium))
         'large (list 0 8 24 0 (hash-ref light-colors 'shadow-heavy)))
   
   ;; Transition configuration
   'transitions
   (hash 'duration 200 ;; milliseconds
         'timing-function 'ease-in-out)
   
   ;; Opacity configuration
   'opacity
   (hash 'disabled 0.5
         'hover 0.8
         'active 0.6)
   ))

;; ===========================
;; Theme Accessor Functions
;; ===========================

;; Get a value from the theme
(define (light-theme-ref key [default #f])
  (hash-ref light-theme key default))

;; Get a color from the theme
(define (light-theme-color key [alpha 1.0])
  (let ([color-value (hash-ref (hash-ref light-theme 'colors) key #f)])
    (if color-value
        (hex->color color-value alpha)
        (error "Color not found in light theme: ~a" key))))

;; Get a font from the theme
(define (light-theme-font size-key weight-key [style-key 'normal])
  (let* ([typography (hash-ref light-theme 'typography)]
         [size (get-font-size typography size-key)]
         [weight (get-font-weight weight-key)]
         [style (get-font-style style-key)])
    (get-system-font "sans-serif" size weight style)))

;; ===========================
;; Export
;; ===========================
(provide
 light-theme
 light-theme-ref
 light-theme-color
 light-theme-font)