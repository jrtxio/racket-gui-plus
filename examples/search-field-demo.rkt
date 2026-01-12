#lang racket/gui

;; Guix Search Field Demo
;; Demonstrates the usage and features of Guix search field components
;; Supports placeholder text, search callbacks, and theme switching

(require racket/class
         racket/draw
         "../guix/style/config.rkt"
         "../guix/composite/search-field.rkt")

;; Create main window
(define frame
  (new frame% 
       [label "Guix Search Field Demo"]
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
     [label "Guix Search Field Component Demo"]
     [font (send the-font-list find-or-create-font 18 'default 'normal 'bold)])

;; Section 1: Basic Search Fields
(new message% 
     [parent main-panel]
     [label "1. Basic Search Fields"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define basic-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Simple search field with default placeholder
(new search-field% 
     [parent basic-panel]
     [placeholder "Search..."]
     [on-callback (λ (sf event)
                    (displayln (format "Search triggered: ~a" (send sf get-text))))])

;; Search field with custom placeholder
(new search-field% 
     [parent basic-panel]
     [placeholder "Type to search..."]
     [on-callback (λ (sf event)
                    (displayln (format "Custom search triggered: ~a" (send sf get-text))))])

;; Search field with initial value
(new search-field% 
     [parent basic-panel]
     [placeholder "Search..."]
     [init-value "Initial search text"]
     [on-callback (λ (sf event)
                    (displayln (format "Initial value search triggered: ~a" (send sf get-text))))])

;; Section 2: Search Results Display
(new message% 
     [parent main-panel]
     [label "2. Search Results Display"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define results-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Search field for results demo
(define results-search-field
  (new search-field% 
       [parent results-panel]
       [placeholder "Search and see results below..."]
       [on-callback (λ (sf event)
                      (define search-text (send sf get-text))
                      (if (non-empty-string? search-text)
                          (send results-label set-label 
                                (format "Searching for: ~a\nFound ~a results" 
                                        search-text 
                                        (string-length search-text)))
                          (send results-label set-label "Enter search text to see results")))]))

;; Label to display search results
(define results-label
  (new message% 
       [parent results-panel]
       [label "Enter search text to see results"]
       [font (send the-font-list find-or-create-font 12 'default 'normal 'normal)]
       [min-width 400]
       [stretchable-width #t]))

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

;; Target search field for dynamic operations
(define target-search-field
  (new search-field% 
       [parent dynamic-panel]
       [placeholder "Dynamic operations target"]
       [on-callback (λ (sf event)
                      (displayln (format "Target search field value: ~a" (send sf get-text))))]))

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
                 (send target-search-field set-text "Dynamic search value!")
                 (displayln "Set value to: Dynamic search value!"))])

;; Button to clear the field
(new button% 
     [parent dynamic-control-panel]
     [label "Clear"]
     [min-width 100]
     [callback (λ (btn event) 
                 (send target-search-field clear)
                 (displayln "Field cleared!"))])

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

;; Search fields to demonstrate theme switching
(new search-field% 
     [parent theme-panel]
     [placeholder "Theme demo search 1"]
     [on-callback (λ (sf event)
                    (displayln (format "Theme demo 1 search: ~a" (send sf get-text))))])

(new search-field% 
     [parent theme-panel]
     [placeholder "Theme demo search 2"]
     [init-value "Pre-filled search"]
     [on-callback (λ (sf event)
                    (displayln (format "Theme demo 2 search: ~a" (send sf get-text))))])

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

(displayln "Guix Search Field Demo started!")
(displayln "Features demonstrated:")
(displayln "  - Basic search input fields")
(displayln "  - Search fields with placeholder text")
(displayln "  - Search fields with initial values")
(displayln "  - Search results display")
(displayln "  - Dynamic operations: set value, clear")
(displayln "  - Theme switching support")
(displayln "")
(displayln "Try typing in the search fields and clicking the Search button!")
