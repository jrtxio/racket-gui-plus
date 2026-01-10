#lang racket/gui

(require racket/class
         racket/draw
         "../guix/style/config.rkt"
         "../guix/atomic/label.rkt"
         "../guix/atomic/button.rkt")

;; Create main window
(define frame (new frame% [label "Guix Label Demo"] [width 500] [height 600]))

;; Create main vertical panel
(define main-panel (new vertical-panel% [parent frame] [alignment '(center top)] [spacing 20] [border 30]))

;; Add title
(new message% [parent main-panel] [label "Guix Label Component Demo"] [font (send the-font-list find-or-create-font 18 'default 'normal 'bold)])

;; Section 1: Basic Labels
(new message% [parent main-panel] [label "1. Basic Labels"] [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define basic-panel (new vertical-panel% [parent main-panel] [alignment '(center center)] [spacing 10]))

;; Simple label with default settings
(new label% [parent basic-panel] [label "Simple Label"])

;; Label with custom text
(new label% [parent basic-panel] [label "Custom Text Label"])

;; Label with empty text
(new label% [parent basic-panel] [label ""])

;; Section 2: Font Sizes
(new message% [parent main-panel] [label "2. Font Sizes"] [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define sizes-panel (new vertical-panel% [parent main-panel] [alignment '(center center)] [spacing 10]))

;; Labels with different font sizes
(new label% [parent sizes-panel] [label "Small Font Size"] [font-size 'small])
(new label% [parent sizes-panel] [label "Regular Font Size"] [font-size 'regular])
(new label% [parent sizes-panel] [label "Medium Font Size"] [font-size 'medium])
(new label% [parent sizes-panel] [label "Large Font Size"] [font-size 'large])

;; Section 3: Font Weights
(new message% [parent main-panel] [label "3. Font Weights"] [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define weights-panel (new vertical-panel% [parent main-panel] [alignment '(center center)] [spacing 10]))

;; Labels with different font weights
(new label% [parent weights-panel] [label "Normal Weight"] [font-weight 'normal])
(new label% [parent weights-panel] [label "Bold Weight"] [font-weight 'bold])
(new label% [parent weights-panel] [label "Small Normal"] [font-size 'small] [font-weight 'normal])
(new label% [parent weights-panel] [label "Small Bold"] [font-size 'small] [font-weight 'bold])
(new label% [parent weights-panel] [label "Large Normal"] [font-size 'large] [font-weight 'normal])
(new label% [parent weights-panel] [label "Large Bold"] [font-size 'large] [font-weight 'bold])

;; Section 4: Custom Colors
(new message% [parent main-panel] [label "4. Custom Colors"] [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define colors-panel (new vertical-panel% [parent main-panel] [alignment '(center center)] [spacing 10]))

;; Labels with custom colors
(new label% [parent colors-panel] [label "Red Text"] [color (make-object color% 255 0 0)])
(new label% [parent colors-panel] [label "Green Text"] [color (make-object color% 0 255 0)])
(new label% [parent colors-panel] [label "Blue Text"] [color (make-object color% 0 0 255)])
(new label% [parent colors-panel] [label "Yellow Text"] [color (make-object color% 255 255 0)])
(new label% [parent colors-panel] [label "Purple Text"] [color (make-object color% 128 0 128)])

;; Section 5: Enabled/Disabled States
(new message% [parent main-panel] [label "5. Enabled/Disabled States"] [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define enable-panel (new vertical-panel% [parent main-panel] [alignment '(center center)] [spacing 10]))

;; Enabled label
(new label% [parent enable-panel] [label "Enabled Label"] [enabled? #t])

;; Disabled label
(new label% [parent enable-panel] [label "Disabled Label"] [enabled? #f])

;; Disabled label with custom color (should be ignored when disabled)
(new label% [parent enable-panel] [label "Disabled Custom Color Label"] [enabled? #f] [color (make-object color% 255 0 0)])

;; Section 6: Dynamic Changes
(new message% [parent main-panel] [label "6. Dynamic Changes"] [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define dynamic-panel (new vertical-panel% [parent main-panel] [alignment '(center center)] [spacing 15]))

;; Target label for dynamic changes
(define dynamic-label (new label% [parent dynamic-panel] [label "Dynamic Label"] [font-size 'regular] [font-weight 'normal]))

;; Control panel for dynamic changes
(define dynamic-control-panel (new horizontal-panel% [parent dynamic-panel] [alignment '(center center)] [spacing 10]))

;; Button to change label text
(define (change-text-callback)
  (let ([current-text (send dynamic-label get-label-text)])
    (if (equal? current-text "Dynamic Label")
        (begin
          (send dynamic-label set-label-text! "Updated Label")
          (displayln "Label text changed to: Updated Label"))
        (begin
          (send dynamic-label set-label-text! "Dynamic Label")
          (displayln "Label text changed to: Dynamic Label"))))) 

(new modern-button% [parent dynamic-control-panel] [label "Change Text"] [on-click change-text-callback])

;; Button to change font size  
(define (toggle-size-callback)
  (let ([current-size (send dynamic-label get-font-size)])
    (if (equal? current-size 'regular)
        (begin
          (send dynamic-label set-font-size! 'large)
          (displayln "Font size changed to: large"))
        (begin
          (send dynamic-label set-font-size! 'regular)
          (displayln "Font size changed to: regular"))))) 

(new modern-button% [parent dynamic-control-panel] [label "Toggle Size"] [on-click toggle-size-callback])

;; Button to change font weight
(define (toggle-weight-callback)
  (let ([current-weight (send dynamic-label get-font-weight)])
    (if (equal? current-weight 'normal)
        (begin
          (send dynamic-label set-font-weight! 'bold)
          (displayln "Font weight changed to: bold"))
        (begin
          (send dynamic-label set-font-weight! 'normal)
          (displayln "Font weight changed to: normal"))))) 

(new modern-button% [parent dynamic-control-panel] [label "Toggle Weight"] [on-click toggle-weight-callback])

;; Section 7: Theme Switching
(new message% [parent main-panel] [label "7. Theme Switching"] [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define theme-panel (new vertical-panel% [parent main-panel] [alignment '(center center)] [spacing 10]))

;; Labels to demonstrate theme switching
(new label% [parent theme-panel] [label "Theme Demo Label 1"] [font-size 'regular] [font-weight 'normal])
(new label% [parent theme-panel] [label "Theme Demo Label 2"] [font-size 'medium] [font-weight 'bold])
(new label% [parent theme-panel] [label "Theme Demo Label 3"] [font-size 'large] [font-weight 'normal])

;; Button to toggle theme
(define (toggle-theme-callback)
  (if (equal? (current-theme) light-theme)
      (begin
        (set-theme! 'dark)
        (displayln "Theme switched to dark"))
      (begin
        (set-theme! 'light)
        (displayln "Theme switched to light")))) 

(new modern-button% [parent theme-panel] [label "Toggle Theme (Light/Dark)"] [on-click toggle-theme-callback])

;; Show window
(send frame show #t)

(displayln "Guix Label Demo started!")
(displayln "Features demonstrated:")
(displayln "  - Basic labels with different text")
(displayln "  - Different font sizes: small, regular, medium, large")
(displayln "  - Different font weights: normal, bold")
(displayln "  - Custom text colors")
(displayln "  - Enabled/disabled states")
(displayln "  - Dynamic changes to text, font size, and weight")
(displayln "  - Theme switching support")
(displayln "")
(displayln "Try clicking the buttons to dynamically change the label properties!")
