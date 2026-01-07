#lang racket/gui

;; Text Field Demo
;; Shows how to use the text-field component

(require (rename-in "../guix/atomic/text-field.rkt" [text-field% guix-text-field%]))
(require "../guix/style/config.rkt")

;; Import necessary GUI classes
(require racket/gui/base)

(define (main)
  (define frame (new frame% [label "Text Field Demo"]
                     [width 400]
                     [height 300]
                     [alignment '(center top)]))
  
  ;; Create a panel for the demo
  (define panel (new vertical-panel% [parent frame]
                     [alignment '(center top)]
                     [spacing 20]
                     [vert-margin 20]
                     [horiz-margin 20]))
  
  ;; Create a title message
  (new message% [parent panel]
       [label "Text Field Examples"]
       [font (font-large)])
  
  ;; Create a horizontal panel for the text field demo
  (define text-field-panel (new horizontal-panel% [parent panel]
                                [alignment '(left center)]
                                [spacing 10]))
  
  ;; Create a vertical panel for labels
  (define labels-panel (new vertical-panel% [parent text-field-panel]
                            [alignment '(right center)]
                            [spacing 20]))
  
  ;; Create a vertical panel for text fields
  (define fields-panel (new vertical-panel% [parent text-field-panel]
                            [alignment '(left center)]
                            [spacing 20]))
  
  ;; Create labels using message%
  (new message% [parent labels-panel] [label "Basic:"][min-width 80])
  (new message% [parent labels-panel] [label "With Placeholder:"][min-width 80])
  (new message% [parent labels-panel] [label "With Callback:"][min-width 80])
  
  ;; Basic text field
  (new guix-text-field% [parent fields-panel])
  
  ;; Text field with placeholder
  (new guix-text-field% [parent fields-panel] [placeholder "Enter your text here"])
  
  ;; Create a callback that updates a label
  (define callback-label (new message% [parent panel]
                              [label "Entered text will appear here"]
                              [font (font-regular)]
                              [min-width 300]
                              [stretchable-width #t]))
  
  ;; Text field with callback
  (new guix-text-field% [parent fields-panel]
       [placeholder "Press Enter to submit"]
       [callback (λ (text) (send callback-label set-label (format "Entered: ~a" text)))])
  
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
