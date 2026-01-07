#lang racket/gui

;; Simple Filter Button Test File
;; Test only filter button component, avoid dependencies on other incomplete components

(require racket/class
         racket/draw
         "../guix/style/config.rkt"
         "../guix/composite/filter-button.rkt")

;; Create main window
(define frame
  (new frame% 
       [label "Guix Filter Button Test"]
       [width 600]
       [height 400]))

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
     [label "Filter Button Test"]
     [font (send the-font-list find-or-create-font 16 'default 'normal 'bold)])

;; Create horizontal panel for filter buttons
(define buttons-panel
  (new horizontal-panel% 
       [parent panel]
       [alignment '(center center)]
       [spacing 20]
       [border 10]))

;; Test different filter buttons
(new filter-button%
     [parent buttons-panel]
     [label "Today"]
     [count 5]
     [icon-symbol "📅"]
     [callback (λ () 
                 (displayln "Today filter clicked!"))])

(new filter-button%
     [parent buttons-panel]
     [label "Week"]
     [count 12]
     [icon-symbol "📆"]
     [bg-color (make-object color% 52 199 89)]
     [callback (λ () 
                 (displayln "Week filter clicked!"))])

(new filter-button%
     [parent buttons-panel]
     [label "Month"]
     [count 30]
     [icon-symbol "📊"]
     [bg-color (make-object color% 255 149 0)]
     [callback (λ () 
                 (displayln "Month filter clicked!"))])

;; Theme toggle button
(new message% 
     [parent panel]
     [label ""])

(new button%
     [parent panel]
     [label "Toggle Theme"]
     [callback (λ (button event) 
                 (if (equal? (current-theme) light-theme)
                     (set-theme! 'dark)
                     (set-theme! 'light)))])

;; Show window
(send frame show #t)

(displayln "Filter button test started. Try clicking buttons and toggling theme!")
