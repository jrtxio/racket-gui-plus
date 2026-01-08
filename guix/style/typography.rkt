#lang racket/gui

;; Guix - Modern Racket GUI Widget Library
;; Typography definitions for theme system

(require racket/class
         racket/system)

;; ===========================
;; Font Definitions
;; ===========================

;; Get system font based on OS
(define (get-system-font face size weight style)
  (let ([os (system-type 'os)])
    (case os
      [(macosx)
       (make-font #:size size #:face "SF Pro Text" #:style style #:weight weight)]
      [(windows)
       (make-font #:size size #:face "Segoe UI" #:style style #:weight weight)]
      [(unix)
       (make-font #:size size #:face "Ubuntu" #:style style #:weight weight)]
      [else
       (make-font #:size size #:face face #:style style #:weight weight)])))

;; Font weights
(define FONT-WEIGHTS
  (hash 'thin 'ultra-light
        'light 'light
        'regular 'normal
        'medium 'medium
        'semibold 'semibold
        'bold 'bold
        'heavy 'heavy
        'black 'black))

;; Font styles
(define FONT-STYLES
  (hash 'normal 'normal
        'italic 'italic
        'oblique 'slant))

;; ===========================
;; Typography Scale
;; ===========================

;; Font size scale (pixels)
(define FONT-SIZES
  (hash 'xs 10
        'sm 12
        'base 13
        'md 14
        'lg 16
        'xl 18
        'xxl 20
        'xxxl 24))

;; Line height scale (relative to font size)
(define LINE-HEIGHTS
  (hash 'tight 1.2
        'normal 1.4
        'relaxed 1.6
        'loose 1.8))

;; Letter spacing scale (pixels)
(define LETTER-SPACING
  (hash 'tight -0.5
        'normal 0
        'wide 0.5
        'wider 1.0
        'widest 2.0))

;; ===========================
;; Typography Presets
;; ===========================

;; Create typography configuration
(define (make-typography-config)
  (hash
   ;; Font family
   'font-family
   (hash 'sans-serif "SF Pro Text, Segoe UI, Ubuntu, sans-serif")
   
   ;; Font sizes
   'font-sizes FONT-SIZES
   
   ;; Line heights
   'line-heights LINE-HEIGHTS
   
   ;; Letter spacing
   'letter-spacing LETTER-SPACING
   
   ;; Font weights
   'font-weights FONT-WEIGHTS
   
   ;; Font styles
   'font-styles FONT-STYLES
   
   ;; Text presets
   'presets
   (hash
    ;; Headings
    'heading-1 (hash 'size 'xxxl 'weight 'bold 'line-height 'tight)
    'heading-2 (hash 'size 'xxl 'weight 'bold 'line-height 'tight)
    'heading-3 (hash 'size 'xl 'weight 'semibold 'line-height 'normal)
    'heading-4 (hash 'size 'lg 'weight 'semibold 'line-height 'normal)
    'heading-5 (hash 'size 'md 'weight 'medium 'line-height 'normal)
    'heading-6 (hash 'size 'base 'weight 'medium 'line-height 'normal)
    
    ;; Body text
    'body-large (hash 'size 'md 'weight 'regular 'line-height 'relaxed)
    'body (hash 'size 'base 'weight 'regular 'line-height 'relaxed)
    'body-small (hash 'size 'sm 'weight 'regular 'line-height 'normal)
    'body-xs (hash 'size 'xs 'weight 'regular 'line-height 'tight)
    
    ;; Labels
    'label (hash 'size 'sm 'weight 'medium 'line-height 'tight)
    'caption (hash 'size 'xs 'weight 'regular 'line-height 'tight)
    
    ;; Buttons
    'button-large (hash 'size 'md 'weight 'medium 'line-height 'tight)
    'button (hash 'size 'base 'weight 'medium 'line-height 'tight)
    'button-small (hash 'size 'sm 'weight 'medium 'line-height 'tight)
    
    ;; Inputs
    'input (hash 'size 'base 'weight 'regular 'line-height 'normal)
    'input-small (hash 'size 'sm 'weight 'regular 'line-height 'normal)
    
    ;; Navigation
    'nav-item (hash 'size 'base 'weight 'medium 'line-height 'normal)
    'nav-item-small (hash 'size 'sm 'weight 'medium 'line-height 'normal))))

;; ===========================
;; Typography Helper Functions
;; ===========================

;; Get font size in pixels
(define (get-font-size typography-config size-key)
  (let ([sizes (hash-ref typography-config 'font-sizes)])
    (if (hash-has-key? sizes size-key)
        (hash-ref sizes size-key)
        (hash-ref sizes 'base))))

;; Get line height multiplier
(define (get-line-height typography-config line-height-key)
  (let ([heights (hash-ref typography-config 'line-heights)])
    (if (hash-has-key? heights line-height-key)
        (hash-ref heights line-height-key)
        (hash-ref heights 'normal))))

;; Get letter spacing in pixels
(define (get-letter-spacing typography-config spacing-key)
  (let ([spacing (hash-ref typography-config 'letter-spacing)])
    (if (hash-has-key? spacing spacing-key)
        (hash-ref spacing spacing-key)
        (hash-ref spacing 'normal))))

;; Get font weight symbol
(define (get-font-weight weight-key)
  (if (hash-has-key? FONT-WEIGHTS weight-key)
      (hash-ref FONT-WEIGHTS weight-key)
      'normal))

;; Get font style symbol
(define (get-font-style style-key)
  (if (hash-has-key? FONT-STYLES style-key)
      (hash-ref FONT-STYLES style-key)
      'normal))

;; Create font object from typography preset
(define (make-font-from-preset typography-config preset-key)
  (let* ([presets (hash-ref typography-config 'presets)]
         [preset (if (hash-has-key? presets preset-key)
                     (hash-ref presets preset-key)
                     (hash-ref presets 'body))]
         [size (get-font-size typography-config (hash-ref preset 'size 'base))]
         [weight (get-font-weight (hash-ref preset 'weight 'regular))]
         [style (get-font-style (hash-ref preset 'style 'normal))])
    (get-system-font "sans-serif" size weight style)))

;; ===========================
;; Typography Utilities
;; ===========================

;; Calculate line height in pixels
(define (calculate-line-height font-size line-height-multiplier)
  (round (* font-size line-height-multiplier)))

;; ===========================
;; Export
;; ===========================
(provide
 ;; Typography configuration
 make-typography-config
 
 ;; Helper functions
 get-system-font
 get-font-size
 get-line-height
 get-letter-spacing
 get-font-weight
 get-font-style
 make-font-from-preset
 calculate-line-height
 
 ;; Constants
 FONT-WEIGHTS
 FONT-STYLES
 FONT-SIZES
 LINE-HEIGHTS
 LETTER-SPACING)