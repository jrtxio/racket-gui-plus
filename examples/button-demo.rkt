#lang racket/gui

;; Guix Button Demo
;; Demonstrates the usage and features of Guix button components
;; Supports different button types, states, and theme switching

(require racket/class
         racket/draw
         "../guix/style/config.rkt"
         "../guix/atomic/button.rkt")

;; Create main window
(define frame
  (new frame% 
       [label "Guix Button Demo"]
       [width 600]
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
     [label "Guix Button Component Demo"]
     [font (send the-font-list find-or-create-font 18 'default 'normal 'bold)])

;; Section 1: Basic Button Types
(new message% 
     [parent main-panel]
     [label "1. Basic Button Types"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define type-panel
  (new horizontal-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

(new modern-button% 
     [parent type-panel]
     [label "Primary Button"]
     [type 'primary]
     [on-click (λ () 
                 (displayln "Primary button clicked!"))])

(new modern-button% 
     [parent type-panel]
     [label "Secondary Button"]
     [type 'secondary]
     [on-click (λ () 
                 (displayln "Secondary button clicked!"))])

(new modern-button% 
     [parent type-panel]
     [label "Text Button"]
     [type 'text]
     [on-click (λ () 
                 (displayln "Text button clicked!"))])

;; Section 2: Button States
(new message% 
     [parent main-panel]
     [label "2. Button States"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define state-panel
  (new horizontal-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

(new modern-button% 
     [parent state-panel]
     [label "Enabled Button"]
     [type 'primary]
     [on-click (λ () 
                 (displayln "Enabled button clicked!"))])

(new modern-button% 
     [parent state-panel]
     [label "Disabled Button"]
     [type 'primary]
     [enabled? #f])

;; Section 3: Dynamic Button Features
(new message% 
     [parent main-panel]
     [label "3. Dynamic Button Features"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define dynamic-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Create a button that can change its label dynamically
(define dynamic-button
  (new modern-button% 
       [parent dynamic-panel]
       [label "Click to Change Label"]
       [type 'secondary]
       [on-click (λ () 
                   (let ([current-label (send dynamic-button get-button-label)])
                     (if (equal? current-label "Click to Change Label")
                         (send dynamic-button set-button-label! "Label Changed!")
                         (send dynamic-button set-button-label! "Click to Change Label"))
                     (displayln "Button label changed!")))]))

;; Create a button that can toggle its type
(define type-toggle-button
  (new modern-button% 
       [parent dynamic-panel]
       [label "Toggle Button Type"]
       [type 'primary]
       [on-click (λ () 
                   (let ([current-type (send type-toggle-button get-type)])
                     (if (equal? current-type 'primary)
                         (send type-toggle-button set-type! 'secondary)
                         (send type-toggle-button set-type! 'primary))
                     (displayln "Button type toggled!")))]))

;; Section 4: Enable/Disable Toggle
(new message% 
     [parent main-panel]
     [label "4. Enable/Disable Toggle"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define enable-panel
  (new horizontal-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

(define target-button
  (new modern-button% 
       [parent enable-panel]
       [label "Target Button"]
       [type 'primary]
       [on-click (λ () 
                   (displayln "Target button clicked!"))]))

(new modern-button% 
     [parent enable-panel]
     [label "Toggle Enable/Disable"]
     [type 'secondary]
     [on-click (λ () 
                 (let ([current-state (send target-button get-enabled)])
                   (send target-button set-enabled (not current-state))
                   (displayln (format "Target button enabled: ~a" (not current-state)))))])

;; Section 5: Theme Switching
(new message% 
     [parent main-panel]
     [label "5. Theme Switching"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(new modern-button% 
     [parent main-panel]
     [label "Toggle Theme (Light/Dark)"]
     [type 'primary]
     [on-click (λ () 
                 (if (equal? (current-theme) light-theme)
                     (begin
                       (set-theme! 'dark)
                       (displayln "Theme switched to dark"))
                     (begin
                       (set-theme! 'light)
                       (displayln "Theme switched to light"))))])

;; Show window
(send frame show #t)

(displayln "Guix Button Demo started!")
(displayln "Features demonstrated:")
(displayln "  - Different button types: primary, secondary, text")
(displayln "  - Button states: enabled, disabled")
(displayln "  - Dynamic label changes")
(displayln "  - Dynamic type switching")
(displayln "  - Enable/disable toggling")
(displayln "  - Theme switching (light/dark)")
(displayln "")
(displayln "Try clicking the buttons to see their behavior!")