#lang racket/gui

;; Input Components Demo
;; Shows how to use the input% and input-field% components

(require (rename-in "../guix/composite/input.rkt" [input% guix-input%]))
(require (rename-in "../guix/composite/input-field.rkt" [input-field% guix-input-field%]))
(require "../guix/style/config.rkt")

;; Import necessary GUI classes
(require racket/gui/base)

(define (main)
  (define frame (new frame% [label "Input Components Demo"]
                     [width 450]
                     [height 400]
                     [alignment '(center top)]))
  
  ;; Create a panel for the demo
  (define panel (new vertical-panel% [parent frame]
                     [alignment '(center top)]
                     [spacing 20]
                     [vert-margin 20]
                     [horiz-margin 20]))
  
  ;; Create a title message
  (new message% [parent panel]
       [label "Input Components Examples"]
       [font (font-large)])
  
  ;; Section 1: Basic input%
  (new message% [parent panel]
       [label "1. Basic input%"]
       [font (font-medium)])
  
  ;; Create a horizontal panel for basic input demo
  (define basic-input-panel (new horizontal-panel% [parent panel]
                                 [alignment '(left center)]
                                 [spacing 10]))
  
  ;; Create a vertical panel for labels
  (define basic-labels-panel (new vertical-panel% [parent basic-input-panel]
                                 [alignment '(right center)]
                                 [spacing 20]))
  
  ;; Create a vertical panel for input components
  (define basic-inputs-panel (new vertical-panel% [parent basic-input-panel]
                                 [alignment '(left center)]
                                 [spacing 20]))
  
  ;; Create labels using message%
  (new message% [parent basic-labels-panel] [label "Basic:"][min-width 80])
  (new message% [parent basic-labels-panel] [label "With Placeholder:"][min-width 80])
  (new message% [parent basic-labels-panel] [label "With Callback:"][min-width 80])
  
  ;; Basic input
  (new guix-input% [parent basic-inputs-panel])
  
  ;; Input with placeholder
  (new guix-input% [parent basic-inputs-panel] [placeholder "Enter your text here"])
  
  ;; Create a callback that updates a label
  (define callback-label (new message% [parent panel]
                              [label "Entered text will appear here"]
                              [font (font-regular)]
                              [min-width 350]
                              [stretchable-width #t]))
  
  ;; Input with callback
  (new guix-input% [parent basic-inputs-panel]
       [placeholder "Press Enter to submit"]
       [callback (λ (text) (send callback-label set-label (format "Entered: ~a" text)))])
  
  ;; Section 2: Enhanced input-field%
  (new message% [parent panel]
       [label "2. Enhanced input-field%"]
       [font (font-medium)])
  
  ;; Create a horizontal panel for input-field demo
  (define enhanced-input-panel (new horizontal-panel% [parent panel]
                                   [alignment '(left center)]
                                   [spacing 10]))
  
  ;; Create a vertical panel for labels
  (define enhanced-labels-panel (new vertical-panel% [parent enhanced-input-panel]
                                   [alignment '(right center)]
                                   [spacing 20]))
  
  ;; Create a vertical panel for input-field components
  (define enhanced-inputs-panel (new vertical-panel% [parent enhanced-input-panel]
                                   [alignment '(left center)]
                                   [spacing 20]))
  
  ;; Create labels using message%
  (new message% [parent enhanced-labels-panel] [label "Normal:"][min-width 80])
  (new message% [parent enhanced-labels-panel] [label "Error State:"][min-width 80])
  (new message% [parent enhanced-labels-panel] [label "Warning State:"][min-width 80])
  
  ;; Normal input-field
  (new guix-input-field% [parent enhanced-inputs-panel]
       [placeholder "Normal input field"])
  
  ;; Input-field with error state
  (define error-input (new guix-input-field% [parent enhanced-inputs-panel]
                           [placeholder "Error state input"]))
  (send error-input set-validation-state 'error)
  
  ;; Input-field with warning state
  (define warning-input (new guix-input-field% [parent enhanced-inputs-panel]
                             [placeholder "Warning state input"]))
  (send warning-input set-validation-state 'warning)
  
  ;; Create a theme toggle button
  (define theme-panel (new horizontal-panel% [parent panel]
                           [alignment '(center center)]
                           [spacing 10]))
  
  (define theme-toggle (new button% [parent theme-panel]
                            [label "Switch to Dark Theme"]
                            [callback (λ (btn evt)
                                        (cond
                                          [(equal? (current-theme) light-theme)
                                           (set-theme! 'dark)
                                           (send btn set-label "Switch to Light Theme")]
                                          [else
                                           (set-theme! 'light)
                                           (send btn set-label "Switch to Dark Theme")]))]))
  
  ;; Show the frame
  (send frame show #t)
  )

(main)