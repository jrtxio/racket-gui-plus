#lang racket/gui

;; Simple Checkbox Test File
;; Test only checkbox component, avoid dependencies on other incomplete components

(require racket/class
         racket/draw
         "../guix/style/config.rkt"
         "../guix/atomic/checkbox.rkt"
         "../guix/atomic/button.rkt")

;; Create main window
(define frame
  (new frame%
       [label "Guix Checkbox Test"]
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
     [label "Checkbox Test"]
     [font (send the-font-list find-or-create-font 16 'default 'normal 'bold)])

;; Test different checkbox states
(new checkbox%
     [parent panel]
     [label "Unchecked Checkbox"]
     [checked? #f]
     [callback (λ (checkbox event)
                 (displayln (format "Checkbox '~a' checked: ~a" 
                                    (send checkbox get-checkbox-label)
                                    (send checkbox get-checked))))])

(new checkbox%
     [parent panel]
     [label "Checked Checkbox"]
     [checked? #t]
     [callback (λ (checkbox event)
                 (displayln (format "Checkbox '~a' checked: ~a" 
                                    (send checkbox get-checkbox-label)
                                    (send checkbox get-checked))))])

(new checkbox%
     [parent panel]
     [label "Disabled Checkbox"]
     [enabled? #f]
     [callback (λ (checkbox event)
                 (displayln "This should not be called"))])

;; Test group of checkboxes with callback
(new message%
     [parent panel]
     [label "Checkbox Group"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define hobbies '())
(define (update-hobbies checkbox hobby)
  (if (send checkbox get-checked)
      (set! hobbies (cons hobby hobbies))
      (set! hobbies (remove hobby hobbies)))
  (displayln (format "Selected hobbies: ~a" hobbies)))

(new checkbox%
     [parent panel]
     [label "Reading"]
     [callback (λ (checkbox event)
                 (update-hobbies checkbox "Reading"))])

(new checkbox%
     [parent panel]
     [label "Sports"]
     [callback (λ (checkbox event)
                 (update-hobbies checkbox "Sports"))])

(new checkbox%
     [parent panel]
     [label "Music"]
     [callback (λ (checkbox event)
                 (update-hobbies checkbox "Music"))])

;; Theme toggle button (using message% since button% might not be ready yet)
(new message%
     [parent panel]
     [label ""])
(new message%
     [parent panel]
     [label "Click below to toggle theme"])

;; Create a simple theme toggle
(define theme-toggle
  (new modern-button%
       [parent panel]
       [label "Toggle Theme"]
       [on-click (λ ()
                   (if (equal? (current-theme) light-theme)
                       (set-theme! 'dark)
                       (set-theme! 'light))
                   (displayln (format "Theme toggled to: ~a" 
                                      (if (equal? (current-theme) light-theme)
                                          "light"
                                          "dark"))))]))

;; Show window
(send frame show #t)

(displayln "Checkbox test started. Try clicking checkboxes and toggling theme!")