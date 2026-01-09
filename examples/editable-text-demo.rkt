#lang racket/gui

;; Guix Editable Text Demo
;; Demonstrates the usage and features of Guix editable text components
;; Supports basic text editing, placeholders, and theme switching

(require racket/class
         racket/draw
         "../guix/style/config.rkt"
         "../guix/atomic/editable-text.rkt")

;; Create main window
(define frame
  (new frame% 
       [label "Guix Editable Text Demo"]
       [width 500]
       [height 500]))

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
     [label "Guix Editable Text Component Demo"]
     [font (send the-font-list find-or-create-font 18 'default 'normal 'bold)])

;; Section 1: Basic Editable Text
(new message% 
     [parent main-panel]
     [label "1. Basic Editable Text"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define basic-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Simple editable text without placeholder
(new message% 
     [parent basic-panel]
     [label "Click to edit text:"])

(define simple-text
  (new editable-text% 
       [parent basic-panel]
       [init-value ""]
       [callback (λ (et)
                   (displayln (format "Simple editable text changed: ~a" (send et get-text))))])
  )

;; Section 2: Editable Text with Placeholder
(new message% 
     [parent main-panel]
     [label "2. Editable Text with Placeholder"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define placeholder-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Editable text with placeholder
(new message% 
     [parent placeholder-panel]
     [label "With placeholder text:"])

(new editable-text% 
     [parent placeholder-panel]
     [init-value ""]
     [placeholder "Enter text here..."]
     [callback (λ (et)
                 (displayln (format "Placeholder text changed: ~a" (send et get-text))))])

;; Section 3: Pre-filled Editable Text
(new message% 
     [parent main-panel]
     [label "3. Pre-filled Editable Text"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define prefilled-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Editable text with initial value
(new message% 
     [parent prefilled-panel]
     [label "With initial value:"])

(define prefilled-text
  (new editable-text% 
       [parent prefilled-panel]
       [init-value "Pre-filled text"]
       [callback (λ (et)
                   (displayln (format "Prefilled text changed: ~a" (send et get-text))))])
  )

;; Section 4: Dynamic Text Changes
(new message% 
     [parent main-panel]
     [label "4. Dynamic Text Changes"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define dynamic-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Target editable text for dynamic changes
(new message% 
     [parent dynamic-panel]
     [label "Dynamic editable text:"])

(define dynamic-text
  (new editable-text% 
       [parent dynamic-panel]
       [init-value "Dynamic text"]
       [placeholder "Dynamic placeholder"]
       [callback (λ (et)
                   (displayln (format "Dynamic text changed: ~a" (send et get-text))))])
  )

;; Control panel for dynamic changes
(define dynamic-control-panel
  (new horizontal-panel% 
       [parent dynamic-panel]
       [alignment '(center center)]
       [spacing 10]))

;; Button to set text
(new button% 
     [parent dynamic-control-panel]
     [label "Set Text"]
     [min-width 100]
     [callback (λ (btn event) 
                 (send dynamic-text set-text "Programmatically set text")
                 (displayln "Text set programmatically"))])

;; Button to clear text
(new button% 
     [parent dynamic-control-panel]
     [label "Clear"]
     [min-width 100]
     [callback (λ (btn event) 
                 (send dynamic-text set-text "")
                 (displayln "Text cleared"))])

;; Button to get current text
(new button% 
     [parent dynamic-control-panel]
     [label "Get Text"]
     [min-width 100]
     [callback (λ (btn event) 
                 (let ([current-text (send dynamic-text get-text)])
                   (displayln (format "Current text: ~a" current-text))))])

;; Section 5: Multiple Editable Text Fields
(new message% 
     [parent main-panel]
     [label "5. Multiple Editable Text Fields"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define multi-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Editable text fields for a simple form
(new message% 
     [parent multi-panel]
     [label "Simple Form Example:"])

(new editable-text% 
     [parent multi-panel]
     [init-value ""]
     [placeholder "Enter your name"]
     [callback (λ (et)
                 (displayln (format "Name: ~a" (send et get-text))))])

(new editable-text% 
     [parent multi-panel]
     [init-value ""]
     [placeholder "Enter your email"]
     [callback (λ (et)
                 (displayln (format "Email: ~a" (send et get-text))))])

(new editable-text% 
     [parent multi-panel]
     [init-value ""]
     [placeholder "Enter your phone number"]
     [callback (λ (et)
                 (displayln (format "Phone: ~a" (send et get-text))))])

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

;; Editable text fields to demonstrate theme switching
(new message% 
     [parent theme-panel]
     [label "Theme Demo 1:"])

(new editable-text% 
     [parent theme-panel]
     [init-value "Theme demo text"]
     [placeholder "Theme demo placeholder"]
     [callback (λ (et)
                 (displayln (format "Theme demo 1 changed: ~a" (send et get-text))))])

(new message% 
     [parent theme-panel]
     [label "Theme Demo 2:"])

(new editable-text% 
     [parent theme-panel]
     [init-value ""]
     [placeholder "Click to edit in different theme"]
     [callback (λ (et)
                 (displayln (format "Theme demo 2 changed: ~a" (send et get-text))))])

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
     [label "1. Click on any editable text field to start editing"])

(new message% 
     [parent main-panel]
     [label "2. Type to enter text"])

(new message% 
     [parent main-panel]
     [label "3. Use arrow keys to move cursor"])

(new message% 
     [parent main-panel]
     [label "4. Use Backspace and Delete to remove text"])

(new message% 
     [parent main-panel]
     [label "5. Press Enter or click elsewhere to finish editing"])

;; Show window
(send frame show #t)

(displayln "Guix Editable Text Demo started!")
(displayln "Features demonstrated:")
(displayln "  - Basic text editing functionality")
(displayln "  - Placeholder text support")
(displayln "  - Pre-filled text")
(displayln "  - Dynamic text changes")
(displayln "  - Multiple editable text fields")
(displayln "  - Theme switching support")
(displayln "")
(displayln "Try clicking on the editable text fields to start editing!")