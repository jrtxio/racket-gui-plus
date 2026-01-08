#lang racket/gui

;; Simple Button Test File
;; Test only button component, avoid dependencies on other incomplete components

(require racket/class
         racket/draw
         "../guix/style/config.rkt"
         "../guix/atomic/button.rkt")

;; Create main window
(define frame
  (new frame% 
       [label "Guix Button Test"]
       [width 400]
       [height 300]))

;; Create vertical panel
(define panel
  (new vertical-panel% 
       [parent frame]
       [alignment '(center center)]
       [spacing 20]
       [border 30]))

;; Add title
(new message% 
     [parent panel]
     [label "Button Test"]
     [font (send the-font-list find-or-create-font 16 'default 'normal 'bold)])

;; Test different button types
(new modern-button% 
     [parent panel]
     [label "Primary Button"]
     [type 'primary]
     [callback (λ (button event) 
                 (displayln "Primary button clicked!"))])

(new modern-button% 
     [parent panel]
     [label "Secondary Button"]
     [type 'secondary]
     [callback (λ (button event) 
                 (displayln "Secondary button clicked!"))])

(new modern-button% 
     [parent panel]
     [label "Text Button"]
     [type 'text]
     [callback (λ (button event) 
                 (displayln "Text button clicked!"))])

;; Test disabled buttons
(new modern-button% 
     [parent panel]
     [label "Disabled Primary"]
     [type 'primary]
     [enabled? #f])

;; Theme toggle button
(new modern-button% 
     [parent panel]
     [label "Toggle Theme"]
     [type 'primary]
     [callback (λ (button event) 
                 (if (equal? (current-theme) light-theme)
                     (set-theme! 'dark)
                     (set-theme! 'light)))])

;; Show window
(send frame show #t)

(displayln "Button test started. Try clicking buttons and toggling theme!")