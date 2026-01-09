#lang racket/gui

;; Simple Category Card Demo
;; Test only category card component, avoid dependencies on other incomplete components

(require racket/class
         racket/draw
         "../guix/style/config.rkt"
         "../guix/composite/category-card.rkt")

;; Create main window
(define frame
  (new frame% 
       [label "Guix Category Card Demo"]
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
     [label "Category Card Demo"]
     [font (send the-font-list find-or-create-font 16 'default 'normal 'bold)])

;; Create horizontal panel for category cards
(define cards-panel
  (new horizontal-panel% 
       [parent panel]
       [alignment '(center center)]
       [spacing 20]
       [border 10]))

;; Test different category cards
(new category-card%
     [parent cards-panel]
     [label "Today"]
     [count 5]
     [icon-symbol "📅"]
     [on-click (λ () 
                 (displayln "Today category clicked!"))])

(new category-card%
     [parent cards-panel]
     [label "Week"]
     [count 12]
     [icon-symbol "📆"]
     [bg-color (make-object color% 52 199 89)]
     [on-click (λ () 
                 (displayln "Week category clicked!"))])

(new category-card%
     [parent cards-panel]
     [label "Month"]
     [count 30]
     [icon-symbol "📊"]
     [bg-color (make-object color% 255 149 0)]
     [on-click (λ () 
                 (displayln "Month category clicked!"))])

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

displayln "Category card demo started. Try clicking cards and toggling theme!"