#lang racket/gui

;; Guix Switch Demo
;; Demonstrates the usage and features of Guix switch components
;; Supports toggle operations, different states, and theme switching

(require racket/class
         racket/draw
         "../guix/style/config.rkt"
         "../guix/atomic/switch.rkt")

;; Create main window
(define frame
  (new frame% 
       [label "Guix Switch Demo"]
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
     [label "Guix Switch Component Demo"]
     [font (send the-font-list find-or-create-font 18 'default 'normal 'bold)])

;; Section 1: Basic Switches
(new message% 
     [parent main-panel]
     [label "1. Basic Switches"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define basic-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Simple switch with default settings (unchecked)
(new message% 
     [parent basic-panel]
     [label "Default switch (unchecked):"])

(new switch% 
     [parent basic-panel]
     [label "Switch"]
     [checked? #f]
     [callback (λ (swt event)
                 (displayln (format "Basic switch checked: ~a" (send swt get-checked))))])

;; Switch with initial checked state
(new message% 
     [parent basic-panel]
     [label "Pre-checked switch:"])

(new switch% 
     [parent basic-panel]
     [label "Switch"]
     [checked? #t]
     [callback (λ (swt event)
                 (displayln (format "Pre-checked switch checked: ~a" (send swt get-checked))))])

;; Section 2: Switches with Different Labels
(new message% 
     [parent main-panel]
     [label "2. Switches with Different Labels"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define labels-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Switch with no label
(new message% 
     [parent labels-panel]
     [label "Switch with no label:"])

(new switch% 
     [parent labels-panel]
     [label ""]
     [checked? #f]
     [callback (λ (swt event)
                 (displayln (format "No label switch checked: ~a" (send swt get-checked))))])

;; Switch with long label
(new message% 
     [parent labels-panel]
     [label "Switch with long label:"])

(new switch% 
     [parent labels-panel]
     [label "This is a very long label for the switch component"]
     [checked? #f]
     [callback (λ (swt event)
                 (displayln (format "Long label switch checked: ~a" (send swt get-checked))))])

;; Section 3: Enabled/Disabled States
(new message% 
     [parent main-panel]
     [label "3. Enabled/Disabled States"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define enable-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Enabled switch (unchecked)
(new message% 
     [parent enable-panel]
     [label "Enabled switch (unchecked):"])

(new switch% 
     [parent enable-panel]
     [label "Enabled"]
     [checked? #f]
     [enabled? #t]
     [callback (λ (swt event)
                 (displayln (format "Enabled switch checked: ~a" (send swt get-checked))))])

;; Enabled switch (checked)
(new message% 
     [parent enable-panel]
     [label "Enabled switch (checked):"])

(new switch% 
     [parent enable-panel]
     [label "Enabled"]
     [checked? #t]
     [enabled? #t]
     [callback (λ (swt event)
                 (displayln (format "Enabled switch checked: ~a" (send swt get-checked))))])

;; Disabled switch (unchecked)
(new message% 
     [parent enable-panel]
     [label "Disabled switch (unchecked):"])

(new switch% 
     [parent enable-panel]
     [label "Disabled"]
     [checked? #f]
     [enabled? #f]
     [callback (λ (swt event)
                 (displayln "This should never be called!"))])

;; Disabled switch (checked)
(new message% 
     [parent enable-panel]
     [label "Disabled switch (checked):"])

(new switch% 
     [parent enable-panel]
     [label "Disabled"]
     [checked? #t]
     [enabled? #f]
     [callback (λ (swt event)
                 (displayln "This should never be called!"))])

;; Section 4: Dynamic Switch Operations
(new message% 
     [parent main-panel]
     [label "4. Dynamic Switch Operations"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define dynamic-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Target switch for dynamic changes
(new message% 
     [parent dynamic-panel]
     [label "Dynamic switch:"])

(define dynamic-switch
  (new switch% 
       [parent dynamic-panel]
       [label "Dynamic Switch"]
       [checked? #f]
       [enabled? #t]
       [callback (λ (swt event)
                   (displayln (format "Dynamic switch checked: ~a" (send swt get-checked))))])
  )

;; Control panel for dynamic operations
(define dynamic-control-panel
  (new horizontal-panel% 
       [parent dynamic-panel]
       [alignment '(center center)]
       [spacing 10]))

;; Define callback functions
(define (toggle-switch-callback btn event)
  (let ([current-state (send dynamic-switch get-checked)])
    (send dynamic-switch set-checked! (not current-state))
    (displayln (format "Switch toggled to: ~a" (not current-state)))))

(define (toggle-enabled-callback btn event)
  (let ([current-state (send dynamic-switch get-enabled)])
    (send dynamic-switch set-enabled! (not current-state))
    (displayln (format "Switch enabled: ~a" (not current-state)))))

(define (get-state-callback btn event)
  (let ([checked (send dynamic-switch get-checked)]
        [enabled (send dynamic-switch get-enabled)])
    (displayln (format "Current state - Checked: ~a, Enabled: ~a" checked enabled))))

;; Button to toggle switch state
(new button% 
     [parent dynamic-control-panel]
     [label "Toggle Switch"]
     [min-width 120]
     [callback toggle-switch-callback])

;; Button to enable/disable switch
(new button% 
     [parent dynamic-control-panel]
     [label "Toggle Enabled"]
     [min-width 120]
     [callback toggle-enabled-callback])

;; Button to get current state
(new button% 
     [parent dynamic-control-panel]
     [label "Get State"]
     [min-width 120]
     [callback get-state-callback])

;; Section 5: Switch with Real-time Status Display
(new message% 
     [parent main-panel]
     [label "5. Switch with Real-time Status Display"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define status-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Create a message to display switch status
(define status-message
  (new message% 
       [parent status-panel]
       [label "Switch Status: OFF"]
       [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])
  )

;; Switch that updates status in real-time
(new switch% 
     [parent status-panel]
     [label "Real-time Status Switch"]
     [checked? #f]
     [callback (λ (swt event)
                 (let ([checked (send swt get-checked)])
                   (send status-message set-label (format "Switch Status: ~a" (if checked "ON" "OFF")))
                   (displayln (format "Status switch checked: ~a" checked))))])

;; Section 6: Multiple Switches in a Group
(new message% 
     [parent main-panel]
     [label "6. Multiple Switches in a Group"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define group-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Create a group of switches for different settings
(new message% 
     [parent group-panel]
     [label "Settings Panel Example:"])

;; Notification switch
(new switch% 
     [parent group-panel]
     [label "Enable Notifications"]
     [checked? #t]
     [callback (λ (swt event)
                 (displayln (format "Notifications enabled: ~a" (send swt get-checked))))])

;; Auto-save switch
(new switch% 
     [parent group-panel]
     [label "Auto-save"]
     [checked? #t]
     [callback (λ (swt event)
                 (displayln (format "Auto-save enabled: ~a" (send swt get-checked))))])

;; Dark mode switch
(new switch% 
     [parent group-panel]
     [label "Dark Mode"]
     [checked? #f]
     [callback (λ (swt event)
                 (displayln (format "Dark mode enabled: ~a" (send swt get-checked))))])

;; Section 7: Theme Switching
(new message% 
     [parent main-panel]
     [label "7. Theme Switching"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define theme-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Switches to demonstrate theme switching
(new message% 
     [parent theme-panel]
     [label "Theme demo switches:"])

(new switch% 
     [parent theme-panel]
     [label "Theme Switch 1"]
     [checked? #t]
     [callback (λ (swt event)
                 (displayln (format "Theme switch 1 checked: ~a" (send swt get-checked))))])

(new switch% 
     [parent theme-panel]
     [label "Theme Switch 2"]
     [checked? #f]
     [callback (λ (swt event)
                 (displayln (format "Theme switch 2 checked: ~a" (send swt get-checked))))])

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

;; Section 8: Switch with Dynamic Label Change
(new message% 
     [parent main-panel]
     [label "8. Switch with Dynamic Label Change"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define label-change-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Switch with changeable label
(new message% 
     [parent label-change-panel]
     [label "Switch with dynamic label:"])

(define label-switch
  (new switch% 
       [parent label-change-panel]
       [label "Original Label"]
       [checked? #f]
       [callback (λ (swt event)
                   (displayln (format "Label switch checked: ~a" (send swt get-checked))))]))

;; Define callback function for label change
(define (change-label-callback btn event)
  (let ([current-label (send label-switch get-switch-label)])
    (if (equal? current-label "Original Label")
        (begin
          (send label-switch set-switch-label! "New Label")
          (displayln "Switch label changed to: New Label"))
        (begin
          (send label-switch set-switch-label! "Original Label")
          (displayln "Switch label changed to: Original Label")))))

;; Button to change switch label
(new button% 
     [parent label-change-panel]
     [label "Change Label"]
     [min-width 120]
     [callback change-label-callback])

;; Usage instructions
(new message% 
     [parent main-panel]
     [label "\nUsage Instructions:"]
     [font (send the-font-list find-or-create-font 12 'default 'normal 'bold)])

(new message% 
     [parent main-panel]
     [label "1. Click on the switch to toggle its state"])

(new message% 
     [parent main-panel]
     [label "2. Hover over the switch to see the hover effect"])

(new message% 
     [parent main-panel]
     [label "3. Use the control buttons to dynamically change switch properties"])

(new message% 
     [parent main-panel]
     [label "4. Try switching themes to see switch appearance change"])

;; Show window
(send frame show #t)

(displayln "Guix Switch Demo started!")
(displayln "Features demonstrated:")
(displayln "  - Basic switch functionality")
(displayln "  - Pre-checked switch state")
(displayln "  - Switches with different labels")
(displayln "  - Enabled and disabled states")
(displayln "  - Dynamic switch operations")
(displayln "  - Real-time status display")
(displayln "  - Multiple switches in a group")
(displayln "  - Theme switching support")
(displayln "  - Dynamic label changes")
(displayln "")
(displayln "Try clicking the switches to see their behavior!")