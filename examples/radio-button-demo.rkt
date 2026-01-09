#lang racket/gui

;; Guix Radio Button Demo
;; Demonstrates the usage and features of Guix radio button components
;; Supports grouping, different states, dynamic operations, and theme switching

(require racket/class
         racket/draw
         "../guix/style/config.rkt"
         "../guix/atomic/radio-button.rkt")

;; Create main window
(define frame
  (new frame% 
       [label "Guix Radio Button Demo"]
       [width 500]
       [height 600]))

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
     [label "Guix Radio Button Component Demo"]
     [font (send the-font-list find-or-create-font 18 'default 'normal 'bold)])

;; Helper function to create radio button groups
;; Ensures only one radio button in the group is checked at a time
(define (create-radio-group)
  (let ([group-members '()])
    (values
     ;; Function to add a radio button to the group
     (λ (radio-button)
       (set! group-members (cons radio-button group-members)))
     ;; Function to handle radio button selection within the group
     (λ (selected-radio)
       ;; Uncheck all other radio buttons in the group
       (for-each (λ (radio)
                   (when (not (eq? radio selected-radio))
                     (send radio set-checked! #f)))
                 group-members)))))  

;; Section 1: Basic Radio Button Group
(new message% 
     [parent main-panel]
     [label "1. Basic Radio Button Group"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define basic-group-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(left center)]
       [spacing 10]))

;; Create a radio group for basic demo
(define-values (add-to-basic-group handle-basic-selection) (create-radio-group))

;; Create basic radio buttons
(define radio1
  (new radio-button% 
       [parent basic-group-panel]
       [label "Option 1"]
       [checked? #t]
       [on-change (λ (checked)
                   (when checked
                     (handle-basic-selection radio1)
                     (displayln "Option 1 selected!")))]))
(add-to-basic-group radio1)

(define radio2
  (new radio-button% 
       [parent basic-group-panel]
       [label "Option 2"]
       [checked? #f]
       [on-change (λ (checked)
                   (when checked
                     (handle-basic-selection radio2)
                     (displayln "Option 2 selected!")))]))
(add-to-basic-group radio2)

(define radio3
  (new radio-button% 
       [parent basic-group-panel]
       [label "Option 3"]
       [checked? #f]
       [on-change (λ (checked)
                   (when checked
                     (handle-basic-selection radio3)
                     (displayln "Option 3 selected!")))]))
(add-to-basic-group radio3)

;; Section 2: Radio Buttons with Long Labels
(new message% 
     [parent main-panel]
     [label "2. Radio Buttons with Long Labels"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define long-label-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(left center)]
       [spacing 10]))

;; Create a radio group for long labels
(define-values (add-to-long-label-group handle-long-label-selection) (create-radio-group))

;; Radio button with very long label
(define long-label-radio1
  (new radio-button% 
       [parent long-label-panel]
       [label "Option with a very long label that demonstrates how radio buttons handle text wrapping or stretching"]
       [checked? #t]
       [on-change (λ (checked)
                   (when checked
                     (handle-long-label-selection long-label-radio1)
                     (displayln "Long label option 1 selected!")))]))
(add-to-long-label-group long-label-radio1)

(define long-label-radio2
  (new radio-button% 
       [parent long-label-panel]
       [label "Another option with a long label to show consistent behavior across multiple radio buttons"]
       [checked? #f]
       [on-change (λ (checked)
                   (when checked
                     (handle-long-label-selection long-label-radio2)
                     (displayln "Long label option 2 selected!")))]))
(add-to-long-label-group long-label-radio2)

;; Section 3: Disabled Radio Buttons
(new message% 
     [parent main-panel]
     [label "3. Disabled Radio Buttons"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define disabled-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(left center)]
       [spacing 10]))

;; Create a radio group for disabled demo
(define-values (add-to-disabled-group handle-disabled-selection) (create-radio-group))

;; Enabled radio button in disabled group
(define enabled-radio
  (new radio-button% 
       [parent disabled-panel]
       [label "Enabled Option"]
       [checked? #t]
       [on-change (λ (checked)
                   (when checked
                     (handle-disabled-selection enabled-radio)
                     (displayln "Enabled option selected!")))]))
(add-to-disabled-group enabled-radio)

;; Disabled radio button (unchecked)
(define disabled-unchecked
  (new radio-button% 
       [parent disabled-panel]
       [label "Disabled Unchecked Option"]
       [checked? #f]
       [enabled? #f]
       [on-change (λ (checked)
                   (displayln "This should never be called!"))]))
(add-to-disabled-group disabled-unchecked)

;; Disabled radio button (checked)
(define disabled-checked
  (new radio-button% 
       [parent disabled-panel]
       [label "Disabled Checked Option"]
       [checked? #t]
       [enabled? #f]
       [on-change (λ (checked)
                   (displayln "This should never be called!"))]))
(add-to-disabled-group disabled-checked)

;; Section 4: Dynamic Operations
(new message% 
     [parent main-panel]
     [label "4. Dynamic Operations"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define dynamic-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Create a radio group for dynamic demo
(define-values (add-to-dynamic-group handle-dynamic-selection) (create-radio-group))

;; Target radio buttons for dynamic operations
(define dynamic-radio1
  (new radio-button% 
       [parent dynamic-panel]
       [label "Dynamic Option 1"]
       [checked? #t]
       [on-change (λ (checked)
                   (when checked
                     (handle-dynamic-selection dynamic-radio1)
                     (displayln "Dynamic option 1 selected!")))]))
(add-to-dynamic-group dynamic-radio1)

(define dynamic-radio2
  (new radio-button% 
       [parent dynamic-panel]
       [label "Dynamic Option 2"]
       [checked? #f]
       [on-change (λ (checked)
                   (when checked
                     (handle-dynamic-selection dynamic-radio2)
                     (displayln "Dynamic option 2 selected!")))]))
(add-to-dynamic-group dynamic-radio2)

;; Control panel for dynamic operations
(define dynamic-control-panel
  (new horizontal-panel% 
       [parent dynamic-panel]
       [alignment '(center center)]
       [spacing 10]))

;; Button to select Option 1
(new button% 
     [parent dynamic-control-panel]
     [label "Select Option 1"]
     [min-width 120]
     [callback (λ (btn event) 
                 (send dynamic-radio1 set-checked! #t)
                 (handle-dynamic-selection dynamic-radio1))])

;; Button to select Option 2
(new button% 
     [parent dynamic-control-panel]
     [label "Select Option 2"]
     [min-width 120]
     [callback (λ (btn event) 
                 (send dynamic-radio2 set-checked! #t)
                 (handle-dynamic-selection dynamic-radio2))])

;; Section 5: Label Manipulation
(new message% 
     [parent main-panel]
     [label "5. Label Manipulation"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define label-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Create a radio group for label demo
(define-values (add-to-label-group handle-label-selection) (create-radio-group))

;; Radio button with changeable label
(define label-radio
  (new radio-button% 
       [parent label-panel]
       [label "Original Label"]
       [checked? #t]
       [on-change (λ (checked)
                   (when checked
                     (handle-label-selection label-radio)
                     (displayln "Label radio selected!")))]))
(add-to-label-group label-radio)

;; Button to change the label
(new button% 
     [parent label-panel]
     [label "Change Label"]
     [min-width 120]
     [callback (λ (btn event) 
                 (let ([current-label (send label-radio get-radio-label)])
                   (if (equal? current-label "Original Label")
                       (send label-radio set-radio-label! "New Label")
                       (send label-radio set-radio-label! "Original Label"))
                   (displayln "Radio button label changed!")))])

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

;; Create a radio group for theme demo
(define-values (add-to-theme-group handle-theme-selection) (create-radio-group))

;; Radio buttons to demonstrate theme switching
(define theme-radio1
  (new radio-button% 
       [parent theme-panel]
       [label "Theme Demo Option 1"]
       [checked? #t]
       [on-change (λ (checked)
                   (when checked
                     (handle-theme-selection theme-radio1)
                     (displayln "Theme option 1 selected!")))]))
(add-to-theme-group theme-radio1)

(define theme-radio2
  (new radio-button% 
       [parent theme-panel]
       [label "Theme Demo Option 2"]
       [checked? #f]
       [on-change (λ (checked)
                   (when checked
                     (handle-theme-selection theme-radio2)
                     (displayln "Theme option 2 selected!")))]))
(add-to-theme-group theme-radio2)

(define theme-radio3
  (new radio-button% 
       [parent theme-panel]
       [label "Theme Demo Option 3"]
       [checked? #f]
       [on-change (λ (checked)
                   (when checked
                     (handle-theme-selection theme-radio3)
                     (displayln "Theme option 3 selected!")))]))
(add-to-theme-group theme-radio3)

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

;; Show window
(send frame show #t)

(displayln "Guix Radio Button Demo started!")
(displayln "Features demonstrated:")
(displayln "  - Basic radio button grouping")
(displayln "  - Radio buttons with long labels")
(displayln "  - Disabled radio buttons (checked and unchecked)")
(displayln "  - Dynamic selection operations")
(displayln "  - Label manipulation")
(displayln "  - Theme switching (light/dark)")
(displayln "")
(displayln "Try selecting different radio buttons to see their behavior!")