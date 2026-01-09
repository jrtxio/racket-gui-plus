#lang racket/gui

;; Guix Checkbox Demo
;; Demonstrates the usage and features of Guix checkbox components
;; Supports different states, dynamic operations, and theme switching

(require racket/class
         racket/draw
         "../guix/style/config.rkt"
         "../guix/atomic/checkbox.rkt")

;; Create main window
(define frame
  (new frame% 
       [label "Guix Checkbox Demo"]
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
     [label "Guix Checkbox Component Demo"]
     [font (send the-font-list find-or-create-font 18 'default 'normal 'bold)])

;; Section 1: Basic Checkboxes
(new message% 
     [parent main-panel]
     [label "1. Basic Checkboxes"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define basic-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(left center)]
       [spacing 10]))

;; Basic checkbox with label
(new checkbox% 
     [parent basic-panel]
     [label "Basic Checkbox"]
     [checked? #f]
     [on-change (λ (checked) 
                 (displayln (format "Basic checkbox checked: ~a" checked)))])

;; Pre-checked checkbox
(new checkbox% 
     [parent basic-panel]
     [label "Pre-checked Checkbox"]
     [checked? #t]
     [on-change (λ (checked) 
                 (displayln (format "Pre-checked checkbox checked: ~a" checked)))])

;; Checkbox with long label
(new checkbox% 
     [parent basic-panel]
     [label "Checkbox with a very long label that should wrap around or stretch the panel"]
     [checked? #f]
     [on-change (λ (checked) 
                 (displayln (format "Long label checkbox checked: ~a" checked)))])

;; Section 2: Disabled Checkboxes
(new message% 
     [parent main-panel]
     [label "2. Disabled Checkboxes"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define disabled-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(left center)]
       [spacing 10]))

;; Disabled unchecked checkbox
(new checkbox% 
     [parent disabled-panel]
     [label "Disabled Unchecked Checkbox"]
     [checked? #f]
     [enabled? #f]
     [on-change (λ (checked) 
                 (displayln "This should never be called!"))])

;; Disabled checked checkbox
(new checkbox% 
     [parent disabled-panel]
     [label "Disabled Checked Checkbox"]
     [checked? #t]
     [enabled? #f]
     [on-change (λ (checked) 
                 (displayln "This should never be called!"))])

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

;; Target checkbox for dynamic operations
(define target-checkbox
  (new checkbox% 
       [parent dynamic-panel]
       [label "Target Checkbox"]
       [checked? #f]
       [on-change (λ (checked) 
                   (displayln (format "Target checkbox checked: ~a" checked)))])
  )

;; Control panel for dynamic operations
(define control-panel
  (new horizontal-panel% 
       [parent dynamic-panel]
       [alignment '(center center)]
       [spacing 10]))

;; Button to check the target checkbox
(new button% 
     [parent control-panel]
     [label "Check"]
     [min-width 80]
     [callback (λ (btn event) 
                 (send target-checkbox set-checked! #t))])

;; Button to uncheck the target checkbox
(new button% 
     [parent control-panel]
     [label "Uncheck"]
     [min-width 80]
     [callback (λ (btn event) 
                 (send target-checkbox set-checked! #f))])

;; Button to toggle the target checkbox
(new button% 
     [parent control-panel]
     [label "Toggle"]
     [min-width 80]
     [callback (λ (btn event) 
                 (send target-checkbox set-checked! (not (send target-checkbox get-checked))))])

;; Section 4: Label Manipulation
(new message% 
     [parent main-panel]
     [label "4. Label Manipulation"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define label-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Checkbox with changeable label
(define label-checkbox
  (new checkbox% 
       [parent label-panel]
       [label "Original Label"]
       [checked? #f]
       [on-change (λ (checked) 
                   (displayln (format "Label checkbox checked: ~a" checked)))])
  )

;; Button to change the label
(new button% 
     [parent label-panel]
     [label "Change Label"]
     [min-width 120]
     [callback (λ (btn event) 
                 (let ([current-label (send label-checkbox get-checkbox-label)])
                   (if (equal? current-label "Original Label")
                       (send label-checkbox set-checkbox-label! "New Label")
                       (send label-checkbox set-checkbox-label! "Original Label"))
                   (displayln "Checkbox label changed!")))])

;; Section 5: Enable/Disable Toggle
(new message% 
     [parent main-panel]
     [label "5. Enable/Disable Toggle"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define enable-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Checkbox that can be enabled/disabled
(define enable-checkbox
  (new checkbox% 
       [parent enable-panel]
       [label "Enable/Disable Me"]
       [checked? #f]
       [on-change (λ (checked) 
                   (displayln (format "Enable checkbox checked: ~a" checked)))])
  )

;; Button to toggle enable/disable state
(new button% 
     [parent enable-panel]
     [label "Toggle Enable/Disable"]
     [min-width 150]
     [callback (λ (btn event) 
                 (let ([current-state (send enable-checkbox get-enabled)])
                   (send enable-checkbox set-enabled! (not current-state))
                   (displayln (format "Checkbox enabled: ~a" (not current-state)))))])

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

;; Checkboxes to demonstrate theme switching
(new checkbox% 
     [parent theme-panel]
     [label "Theme Demo Checkbox 1"]
     [checked? #t])

(new checkbox% 
     [parent theme-panel]
     [label "Theme Demo Checkbox 2"]
     [checked? #f])

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
                       (displayln "Theme switched to light"))))])

;; Show window
(send frame show #t)

(displayln "Guix Checkbox Demo started!")
(displayln "Features demonstrated:")
(displayln "  - Basic checkboxes with different initial states")
(displayln "  - Checkboxes with long labels")
(displayln "  - Disabled checkboxes (checked and unchecked)")
(displayln "  - Dynamic checking/unchecking/toggling")
(displayln "  - Label manipulation")
(displayln "  - Enable/disable toggling")
(displayln "  - Theme switching (light/dark)")
(displayln "")
(displayln "Try interacting with the checkboxes to see their behavior!")