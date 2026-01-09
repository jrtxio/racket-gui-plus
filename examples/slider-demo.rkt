#lang racket/gui

;; Guix Slider Demo
;; Demonstrates the usage and features of Guix slider components
;; Supports different ranges, real-time value display, and theme switching

(require racket/class
         racket/draw
         "../guix/style/config.rkt"
         "../guix/atomic/slider.rkt")

;; Create main window
(define frame
  (new frame% 
       [label "Guix Slider Demo"]
       [width 500]
       [height 550]))

;; Create main vertical panel
(define main-panel
  (new vertical-panel% 
       [parent frame]
       [alignment '(center top)]
       [spacing 20]
       [border 30]))

;; Add title
(new message% 
     [parent main-panel]
     [label "Guix Slider Component Demo"]
     [font (send the-font-list find-or-create-font 18 'default 'normal 'bold)])

;; Section 1: Basic Slider
(new message% 
     [parent main-panel]
     [label "1. Basic Slider"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define basic-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Simple slider with default settings
(new message% 
     [parent basic-panel]
     [label "Default slider (0-100):"])

(new modern-slider% 
     [parent basic-panel]
     [min-value 0]
     [max-value 100]
     [init-value 50]
     [callback (λ (slider event)
                 (displayln (format "Basic slider value: ~a" (send slider get-value))))])

;; Section 2: Sliders with Different Ranges
(new message% 
     [parent main-panel]
     [label "2. Sliders with Different Ranges"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define range-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Slider with small range
(new message% 
     [parent range-panel]
     [label "Small range slider (0-10):"])

(new modern-slider% 
     [parent range-panel]
     [min-value 0]
     [max-value 10]
     [init-value 5]
     [callback (λ (slider event)
                 (displayln (format "Small range slider value: ~a" (send slider get-value))))])

;; Slider with large range
(new message% 
     [parent range-panel]
     [label "Large range slider (0-1000):"])

(new modern-slider% 
     [parent range-panel]
     [min-value 0]
     [max-value 1000]
     [init-value 500]
     [callback (λ (slider event)
                 (displayln (format "Large range slider value: ~a" (send slider get-value))))])

;; Slider with negative values
(new message% 
     [parent range-panel]
     [label "Slider with negative values (-50 to 50):"])

(new modern-slider% 
     [parent range-panel]
     [min-value -50]
     [max-value 50]
     [init-value 0]
     [callback (λ (slider event)
                 (displayln (format "Negative range slider value: ~a" (send slider get-value))))])

;; Section 3: Slider with Real-time Value Display
(new message% 
     [parent main-panel]
     [label "3. Slider with Real-time Value Display"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define realtime-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Create a panel to hold slider and value display
(define slider-with-value-panel
  (new vertical-panel% 
       [parent realtime-panel]
       [alignment '(center center)]
       [spacing 10]))

(new message% 
     [parent slider-with-value-panel]
     [label "Slider with real-time value display:"])

;; Create a message to display the slider value
(define slider-value-message
  (new message% 
       [parent slider-with-value-panel]
       [label "Value: 50"]
       [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])
  )

;; Slider that updates the message in real-time
(new modern-slider% 
     [parent slider-with-value-panel]
     [min-value 0]
     [max-value 100]
     [init-value 50]
     [callback (λ (slider event)
                 (let ([value (send slider get-value)])
                   (send slider-value-message set-label (format "Value: ~a" value))
                   (displayln (format "Real-time slider value: ~a" value))))])

;; Section 4: Dynamic Slider Operations
(new message% 
     [parent main-panel]
     [label "4. Dynamic Slider Operations"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define dynamic-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Target slider for dynamic operations
(new message% 
     [parent dynamic-panel]
     [label "Dynamic slider:"])

(define dynamic-slider
  (new modern-slider% 
       [parent dynamic-panel]
       [min-value 0]
       [max-value 100]
       [init-value 25]
       [callback (λ (slider event)
                   (displayln (format "Dynamic slider value: ~a" (send slider get-value))))])
  )

;; Control panel for dynamic operations
(define dynamic-control-panel
  (new horizontal-panel% 
       [parent dynamic-panel]
       [alignment '(center center)]
       [spacing 10]))

;; Button to set slider to minimum value
(new button% 
     [parent dynamic-control-panel]
     [label "Min"]
     [min-width 80]
     [callback (λ (btn event) 
                 (send dynamic-slider set-value (send dynamic-slider get-min-value))
                 (displayln "Slider set to minimum value"))])

;; Button to set slider to middle value
(new button% 
     [parent dynamic-control-panel]
     [label "Middle"]
     [min-width 80]
     [callback (λ (btn event) 
                 (let ([min-val (send dynamic-slider get-min-value)]
                       [max-val (send dynamic-slider get-max-value)])
                   (send dynamic-slider set-value (quotient (+ min-val max-val) 2))
                   (displayln "Slider set to middle value")))]
  )

;; Button to set slider to maximum value
(new button% 
     [parent dynamic-control-panel]
     [label "Max"]
     [min-width 80]
     [callback (λ (btn event) 
                 (send dynamic-slider set-value (send dynamic-slider get-max-value))
                 (displayln "Slider set to maximum value"))])

;; Button to get current slider value
(new button% 
     [parent dynamic-control-panel]
     [label "Get Value"]
     [min-width 100]
     [callback (λ (btn event) 
                 (let ([current-value (send dynamic-slider get-value)])
                   (displayln (format "Current slider value: ~a" current-value))))])

;; Section 5: Multiple Sliders in a Group
(new message% 
     [parent main-panel]
     [label "5. Multiple Sliders in a Group"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define group-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Create a group of sliders for different settings
(new message% 
     [parent group-panel]
     [label "Settings Panel Example:"])

;; Brightness slider
(new message% 
     [parent group-panel]
     [label "Brightness:"])

(new modern-slider% 
     [parent group-panel]
     [min-value 0]
     [max-value 100]
     [init-value 75]
     [callback (λ (slider event)
                 (displayln (format "Brightness: ~a%" (send slider get-value))))])

;; Volume slider
(new message% 
     [parent group-panel]
     [label "Volume:"])

(new modern-slider% 
     [parent group-panel]
     [min-value 0]
     [max-value 100]
     [init-value 50]
     [callback (λ (slider event)
                 (displayln (format "Volume: ~a%" (send slider get-value))))])

;; Contrast slider
(new message% 
     [parent group-panel]
     [label "Contrast:"])

(new modern-slider% 
     [parent group-panel]
     [min-value 0]
     [max-value 100]
     [init-value 60]
     [callback (λ (slider event)
                 (displayln (format "Contrast: ~a%" (send slider get-value))))])

;; Section 6: Theme Switching
(new message% 
     [parent main-panel]
     [label "6. Theme Switching"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define theme-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Sliders to demonstrate theme switching
(new message% 
     [parent theme-panel]
     [label "Theme Demo Sliders:"])

(new modern-slider% 
     [parent theme-panel]
     [min-value 0]
     [max-value 100]
     [init-value 30]
     [callback (λ (slider event)
                 (displayln (format "Theme demo 1 slider value: ~a" (send slider get-value))))])

(new modern-slider% 
     [parent theme-panel]
     [min-value 0]
     [max-value 50]
     [init-value 25]
     [callback (λ (slider event)
                 (displayln (format "Theme demo 2 slider value: ~a" (send slider get-value))))])

;; Button to toggle theme
(new button% 
     [parent theme-panel]
     [label "Toggle Theme (Light/Dark)"]
     [min-width 180]
     [callback (λ (btn event) 
                 (if (equal? (current-theme) light-theme)
                     (begin
                       (set-theme! 'dark)
                       (displayln "Theme switched to dark"))
                     (begin
                       (set-theme! 'light)
                       (displayln "Theme switched to light"))))]
  )

;; Usage instructions
(new message% 
     [parent main-panel]
     [label "\nUsage Instructions:"]
     [font (send the-font-list find-or-create-font 12 'default 'normal 'bold)])

(new message% 
     [parent main-panel]
     [label "1. Click and drag the slider thumb to change value"])

(new message% 
     [parent main-panel]
     [label "2. Click on the slider track to jump to that position"])

(new message% 
     [parent main-panel]
     [label "3. Use the control buttons to dynamically set values"])

(new message% 
     [parent main-panel]
     [label "4. Try switching themes to see slider appearance change"])

;; Show window
(send frame show #t)

(displayln "Guix Slider Demo started!")
(displayln "Features demonstrated:")
(displayln "  - Basic slider functionality")
(displayln "  - Different value ranges")
(displayln "  - Real-time value display")
(displayln "  - Dynamic slider operations")
(displayln "  - Multiple sliders in a group")
(displayln "  - Theme switching support")
(displayln "")
(displayln "Try interacting with the sliders to see their behavior!")