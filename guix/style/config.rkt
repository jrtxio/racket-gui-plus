#lang racket/gui

;; --- Unified Style Configuration ---
;; Apple-style design language
;; Supports theme switching (light/dark)

(require racket/class
         racket/list
         racket/hash
         "colors.rkt"
         "typography.rkt"
         "presets/light.rkt"
         "presets/dark.rkt")

;; ===========================
;; Theme Switching Mechanism
;; ===========================

;; Current theme (using hash-based theme structure)
(define current-theme (make-parameter light-theme))

;; List of theme change callback functions
(define theme-change-callbacks '())

;; List of all created widgets for global refresh when theme changes
(define all-widgets '())

;; Register theme change callback
(define (register-theme-callback callback)
  (set! theme-change-callbacks (append theme-change-callbacks (list callback))))

;; Unregister theme change callback
(define (unregister-theme-callback callback)
  (set! theme-change-callbacks (remove callback theme-change-callbacks)))

;; Register widget for refresh when theme changes
(define (register-widget widget)
  (set! all-widgets (cons widget all-widgets)))

;; Unregister widget
(define (unregister-widget widget)
  (set! all-widgets (remove widget all-widgets)))

;; Global refresh all widgets
(define (refresh-all-widgets)
  (for-each (λ (widget) 
              (when (is-a? widget area<%>) 
                (send widget refresh))) 
            all-widgets))

;; Switch theme
(define (set-theme! new-theme)
  (cond
    [(equal? new-theme 'light)
     (current-theme light-theme)
     (for-each (λ (callback) (callback light-theme)) theme-change-callbacks)
     (refresh-all-widgets)]
    [(equal? new-theme 'dark)
     (current-theme dark-theme)
     (for-each (λ (callback) (callback dark-theme)) theme-change-callbacks)
     (refresh-all-widgets)]
    [(hash? new-theme)
     (current-theme new-theme)
     (for-each (λ (callback) (callback new-theme)) theme-change-callbacks)
     (refresh-all-widgets)]
    [else
     (error "Invalid theme: ~a" new-theme)]))

;; ===========================
;; Theme Accessor Functions
;; ===========================

;; Helper to get theme value with fallback
(define (theme-ref key [default #f])
  (hash-ref (current-theme) key default))

;; Helper to get nested theme value
(define (theme-ref* keys [default #f])
  (let loop ([h (current-theme)] [keys keys])
    (if (null? keys) h
        (if (hash? h) (loop (hash-ref h (car keys) #f) (cdr keys))
            default))))

;; Get color from current theme
(define (theme-color key [alpha 1.0])
  (let* ([colors (theme-ref* '(colors))]
         [color-value (and colors (hash-ref colors key #f))])
    (if color-value
        (hex->color color-value alpha)
        (error "Color not found in theme: ~a" key))))

;; Get font from current theme
(define (theme-font size-key weight-key [style-key 'normal])
  (let ([typography (theme-ref* '(typography))])
    (if typography
        (let ([size (get-font-size typography size-key)]
              [weight (get-font-weight weight-key)]
              [style (get-font-style style-key)])
          (get-system-font "sans-serif" size weight style))
        (error "Typography not found in theme"))))

;; ===========================
;; Convenient Access to Current Theme Properties
;; ===========================

;; Border radius configuration
(define (border-radius-small) (theme-ref* '(border-radius small) 6))
(define (border-radius-medium) (theme-ref* '(border-radius medium) 10))
(define (border-radius-large) (theme-ref* '(border-radius large) 14))

;; Background colors
(define (color-bg-white) (theme-color 'background))
(define (color-bg-light) (theme-color 'background-light))
(define (color-bg-overlay) (theme-color 'background-overlay))
(define (color-bg-hover) (theme-color 'background-hover))
(define (color-bg-pressed) (theme-color 'background-pressed))

;; Border colors
(define (color-border) (theme-color 'border))
(define (color-border-hover) (theme-color 'border-hover))
(define (color-border-focus) (theme-color 'border-focus))
(define (color-border-disabled) (theme-color 'border-disabled))

;; Text colors
(define (color-text-main) (theme-color 'text-main))
(define (color-text-light) (theme-color 'text-light))
(define (color-text-placeholder) (theme-color 'text-placeholder))
(define (color-text-disabled) (theme-color 'text-disabled))

;; Functional colors
(define (color-accent) (theme-color 'accent))
(define (color-accent-hover) (theme-color 'accent-hover))
(define (color-accent-pressed) (theme-color 'accent-pressed))
(define (color-success) (theme-color 'success))
(define (color-success-hover) (theme-color 'success-hover))
(define (color-error) (theme-color 'error))
(define (color-error-hover) (theme-color 'error-hover))
(define (color-warning) (theme-color 'warning))
(define (color-warning-hover) (theme-color 'warning-hover))
(define (color-info) (theme-color 'info))
(define (color-info-hover) (theme-color 'info-hover))

;; Surface colors
(define (color-surface) (theme-color 'surface))
(define (color-surface-light) (theme-color 'surface-light))
(define (color-surface-dark) (theme-color 'surface-dark))

;; Shadow colors
(define (color-shadow-light) (theme-color 'shadow-light))
(define (color-shadow-medium) (theme-color 'shadow-medium))
(define (color-shadow-heavy) (theme-color 'shadow-heavy))

;; Fonts
(define (font-size-small) (theme-ref* '(typography font-sizes xs) 10))
(define (font-size-regular) (theme-ref* '(typography font-sizes base) 13))
(define (font-size-medium) (theme-ref* '(typography font-sizes md) 14))
(define (font-size-large) (theme-ref* '(typography font-sizes lg) 16))
(define (font-small) (theme-font 'xs 'regular))
(define (font-regular) (theme-font 'base 'regular))
(define (font-medium) (theme-font 'base 'medium))
(define (font-large) (theme-font 'lg 'bold))

;; Widget sizes
(define (input-height) (theme-ref* '(widget-sizes input-height) 40))
(define (button-height) (theme-ref* '(widget-sizes button-height) 40))
(define (progress-bar-height) (theme-ref* '(widget-sizes progress-bar-height) 12))
(define (toast-height) (theme-ref* '(widget-sizes toast-height) 68))
(define (toast-width) (theme-ref* '(widget-sizes toast-width) 340))
(define (icon-small) (theme-ref* '(widget-sizes icon-small) 16))
(define (icon-medium) (theme-ref* '(widget-sizes icon-medium) 20))
(define (icon-large) (theme-ref* '(widget-sizes icon-large) 24))

;; Spacing
(define (spacing-small) (theme-ref* '(spacing sm) 8))
(define (spacing-medium) (theme-ref* '(spacing md) 10))
(define (spacing-large) (theme-ref* '(spacing lg) 14))
(define (spacing-xs) (theme-ref* '(spacing xs) 4))
(define (spacing-xl) (theme-ref* '(spacing xl) 20))
(define (spacing-xxl) (theme-ref* '(spacing xxl) 28))

;; Opacity
(define (opacity-disabled) (theme-ref* '(opacity disabled) 0.5))
(define (opacity-hover) (theme-ref* '(opacity hover) 0.8))
(define (opacity-active) (theme-ref* '(opacity active) 0.6))

;; ===========================
;; Export All Style Constants and Theme Functions
;; ===========================
(provide 
 ;; Theme instances
 light-theme
 dark-theme
 
 ;; Theme switching
 current-theme
 set-theme!
 register-theme-callback
 unregister-theme-callback
 register-widget
 unregister-widget
 refresh-all-widgets
 
 ;; Theme accessors
 theme-ref
 theme-ref*
 theme-color
 theme-font
 
 ;; Border radius (function form, dynamically get current theme value)
 border-radius-small
 border-radius-medium
 border-radius-large
 
 ;; Colors (function form, dynamically get current theme value)
 color-bg-white
 color-bg-light
 color-bg-overlay
 color-bg-hover
 color-bg-pressed
 color-border
 color-border-hover
 color-border-focus
 color-border-disabled
 color-text-main
 color-text-light
 color-text-placeholder
 color-text-disabled
 color-accent
 color-accent-hover
 color-accent-pressed
 color-success
 color-success-hover
 color-error
 color-error-hover
 color-warning
 color-warning-hover
 color-info
 color-info-hover
 color-surface
 color-surface-light
 color-surface-dark
 color-shadow-light
 color-shadow-medium
 color-shadow-heavy
 
 ;; Fonts (function form, dynamically get current theme value)
 font-size-small
 font-size-regular
 font-size-medium
 font-size-large
 font-small
 font-regular
 font-medium
 font-large
 
 ;; Widget sizes (function form, dynamically get current theme value)
 input-height
 button-height
 progress-bar-height
 toast-height
 toast-width
 icon-small
 icon-medium
 icon-large
 
 ;; Spacing (function form, dynamically get current theme value)
 spacing-xs
 spacing-small
 spacing-medium
 spacing-large
 spacing-xl
 spacing-xxl
 
 ;; Opacity
 opacity-disabled
 opacity-hover
 opacity-active
 
 ;; Color utilities from colors.rkt
 hex->color
 get-color
 get-color-with-alpha
 
 ;; Typography utilities from typography.rkt
 make-typography-config
 get-system-font
 get-font-size
 get-line-height
 get-letter-spacing
 get-font-weight
 get-font-style
 make-font-from-preset
 calculate-line-height)