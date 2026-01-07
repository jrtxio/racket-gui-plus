#lang racket/gui

(require racket/class
         racket/list
         "../guix/guix.rkt")

;; Create main window for demo
(define frame (new frame%
                   [label "Guix Toast Demo"]
                   [width 400]
                   [height 350]
                   [style '(resize-border)]))

;; Create main panel
(define main-panel (new vertical-panel%
                        [parent frame]
                        [style '(border)]
                        [alignment '(center center)]
                        [spacing 15]))

;; Title label
(define title (new guix-label%
                   [parent main-panel]
                   [label "Toast Notification Demo"]
                   [font (font-large)]))

(new message% [parent main-panel] [label ""] [min-height 10])

;; Create buttons panel
(define buttons-panel (new vertical-panel%
                           [parent main-panel]
                           [alignment '(center center)]
                           [spacing 10]))

;; Success toast button
(new guix-button%
     [parent buttons-panel]
     [label "Show Success Toast"]
     [callback (lambda (btn evt)
                 (show-toast "Operation completed successfully!" #:type 'success))])

;; Error toast button
(new guix-button%
     [parent buttons-panel]
     [label "Show Error Toast"]
     [callback (lambda (btn evt)
                 (show-toast "An error occurred during operation!" #:type 'error))])

;; Info toast button
(new guix-button%
     [parent buttons-panel]
     [label "Show Info Toast"]
     [callback (lambda (btn evt)
                 (show-toast "This is an informational message." #:type 'info))])

;; Multiple toasts button
(new guix-button%
     [parent buttons-panel]
     [label "Show Multiple Toasts"]
     [callback (lambda (btn evt)
                 (show-toast "First notification message" #:type 'success)
                 (show-toast "Second notification message" #:type 'info)
                 (show-toast "Third notification message" #:type 'error))])

(new message% [parent main-panel] [label ""] [min-height 15])

;; Theme toggle button
(define theme-toggle-panel (new horizontal-panel%
                                [parent main-panel]
                                [alignment '(center center)]
                                [spacing 10]))

(define current-theme (make-parameter 'light))

(new guix-label%
     [parent theme-toggle-panel]
     [label "Theme:"])

(new guix-button%
     [parent theme-toggle-panel]
     [label "Toggle Light/Dark"]
     [callback (lambda (btn evt)
                 (if (eq? (current-theme) 'light)
                     (begin
                       (set-theme! 'dark)
                       (current-theme 'dark))
                     (begin
                       (set-theme! 'light)
                       (current-theme 'light))))])

(new message% [parent main-panel] [label ""] [min-height 10])

;; Instructions label
(define instructions (new guix-label%
                          [parent main-panel]
                          [label "Toasts will auto-close after 3.5 seconds\nHover to pause countdown"]
                          [font (font-small)]))

;; Show main window
(send frame show #t)