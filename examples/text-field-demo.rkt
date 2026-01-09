#lang racket/gui

;; Guix Text Field Demo
;; Demonstrates the usage and features of Guix text field components
;; Supports placeholder text, dynamic operations, and theme switching

(require racket/class
         racket/draw
         "../guix/style/config.rkt"
         "../guix/atomic/text-field.rkt")

;; Create main window
(define frame
  (new frame% 
       [label "Guix Text Field Demo"]
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
     [label "Guix Text Field Component Demo"]
     [font (send the-font-list find-or-create-font 18 'default 'normal 'bold)])

;; Section 1: Basic Text Fields
(new message% 
     [parent main-panel]
     [label "1. Basic Text Fields"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define basic-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Simple text field without placeholder
(new text-field% 
     [parent basic-panel]
     [label "Simple Text Field: "]
     [init-value ""]
     [callback (λ (tf event)
                 (displayln (format "Simple text field value: ~a" (send tf get-value))))])

;; Text field with placeholder
(new text-field% 
     [parent basic-panel]
     [label "With Placeholder: "]
     [init-value ""]
     [placeholder "Enter text here..."]
     [callback (λ (tf event)
                 (displayln (format "Placeholder text field value: ~a" (send tf get-value))))])

;; Text field with initial value
(new text-field% 
     [parent basic-panel]
     [label "With Initial Value: "]
     [init-value "Hello, Guix!"]
     [callback (λ (tf event)
                 (displayln (format "Initial value text field value: ~a" (send tf get-value))))])

;; Section 2: Text Field with Long Placeholder
(new message% 
     [parent main-panel]
     [label "2. Text Field with Long Placeholder"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define long-placeholder-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Text field with very long placeholder
(new text-field% 
     [parent long-placeholder-panel]
     [label "Long Placeholder: "]
     [init-value ""]
     [placeholder "This is a very long placeholder text that demonstrates how the text field handles lengthy hints for users"]
     [callback (λ (tf event)
                 (displayln (format "Long placeholder text field value: ~a" (send tf get-value))))])

;; Section 3: Dynamic Operations
(new message% 
     [parent main-panel]
     [label "3. Dynamic Operations"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define dynamic-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Target text field for dynamic operations
(define target-text-field
  (new text-field% 
       [parent dynamic-panel]
       [label "Target Field: "]
       [init-value ""]
       [placeholder "Dynamic operations target"]
       [callback (λ (tf event)
                   (displayln (format "Target text field value: ~a" (send tf get-value))))]))

;; Control panel for dynamic operations
(define dynamic-control-panel
  (new horizontal-panel% 
       [parent dynamic-panel]
       [alignment '(center center)]
       [spacing 10]))

;; Button to set a value
(new button% 
     [parent dynamic-control-panel]
     [label "Set Value"]
     [min-width 100]
     [callback (λ (btn event) 
                 (send target-text-field set-text "Dynamic value set!")
                 (displayln "Set value to: Dynamic value set!"))])

;; Button to clear the field
(new button% 
     [parent dynamic-control-panel]
     [label "Clear"]
     [min-width 100]
     [callback (λ (btn event) 
                 (send target-text-field clear)
                 (displayln "Field cleared!"))])

;; Button to change placeholder
(new button% 
     [parent dynamic-control-panel]
     [label "Change Placeholder"]
     [min-width 150]
     [callback (λ (btn event) 
                 (let ([current-placeholder (send target-text-field get-placeholder)])
                   (if (equal? current-placeholder "Dynamic operations target")
                       (begin
                         (send target-text-field set-placeholder "New placeholder text")
                         (displayln "Placeholder changed to: New placeholder text")
                         ;; Clear field to show new placeholder
                         (send target-text-field clear))
                       (begin
                         (send target-text-field set-placeholder "Dynamic operations target")
                         (displayln "Placeholder changed to: Dynamic operations target")
                         ;; Clear field to show new placeholder
                         (send target-text-field clear)))))])

;; Section 4: Theme Switching
(new message% 
     [parent main-panel]
     [label "4. Theme Switching"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define theme-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Text fields to demonstrate theme switching
(new text-field% 
     [parent theme-panel]
     [label "Theme Demo 1: "]
     [init-value ""]
     [placeholder "Theme demo field 1"]
     [callback (λ (tf event)
                 (displayln (format "Theme demo 1 value: ~a" (send tf get-value))))])

(new text-field% 
     [parent theme-panel]
     [label "Theme Demo 2: "]
     [init-value "Pre-filled value"]
     [callback (λ (tf event)
                 (displayln (format "Theme demo 2 value: ~a" (send tf get-value))))])

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

;; Section 5: Multiple Text Fields in a Group
(new message% 
     [parent main-panel]
     [label "5. Multiple Text Fields"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define group-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Text fields for a simple form
(new text-field% 
     [parent group-panel]
     [label "Name: "]
     [placeholder "Enter your name"]
     [callback (λ (tf event)
                 (displayln (format "Name: ~a" (send tf get-value))))])

(new text-field% 
     [parent group-panel]
     [label "Email: "]
     [placeholder "Enter your email"]
     [callback (λ (tf event)
                 (displayln (format "Email: ~a" (send tf get-value))))])

(new text-field% 
     [parent group-panel]
     [label "Phone: "]
     [placeholder "Enter your phone number"]
     [callback (λ (tf event)
                 (displayln (format "Phone: ~a" (send tf get-value))))])

;; Show window
(send frame show #t)

(displayln "Guix Text Field Demo started!")
(displayln "Features demonstrated:")
(displayln "  - Basic text input fields")
(displayln "  - Text fields with placeholder text")
(displayln "  - Text fields with initial values")
(displayln "  - Dynamic operations: set value, clear, change placeholder")
(displayln "  - Theme switching support")
(displayln "  - Multiple text fields in a group")
(displayln "")
(displayln "Try typing in the text fields to see their behavior!")