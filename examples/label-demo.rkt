#lang racket/gui

;; Simple Label Test File
;; Test only label component, avoid dependencies on other incomplete components

(require racket/class
         racket/draw
         "../guix/style/config.rkt"
         "../guix/atomic/label.rkt")

;; Create main window
(define frame
  (new frame%
       [label "Guix Label Test"]
       [width 500]
       [height 400]))

;; Create vertical panel
(define panel
  (new vertical-panel%
       [parent frame]
       [alignment '(center center)]
       [spacing 15]
       [border 30]))

;; Add title
(new message%
     [parent panel]
     [label "Label Test"]
     [font (send the-font-list find-or-create-font 18 'default 'normal 'bold)])

;; Section: Basic Labels
(new message%
     [parent panel]
     [label "Basic Labels"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

;; Basic label
(new label%
     [parent panel]
     [label "Basic Label"]
     [font-size 'regular]
     [font-weight 'normal])

;; Section: Different Font Sizes
(new message%
     [parent panel]
     [label "Different Font Sizes"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

;; Small font size
(new label%
     [parent panel]
     [label "Small Font Size"]
     [font-size 'small]
     [font-weight 'normal])

;; Regular font size
(new label%
     [parent panel]
     [label "Regular Font Size"]
     [font-size 'regular]
     [font-weight 'normal])

;; Medium font size
(new label%
     [parent panel]
     [label "Medium Font Size"]
     [font-size 'medium]
     [font-weight 'normal])

;; Large font size
(new label%
     [parent panel]
     [label "Large Font Size"]
     [font-size 'large]
     [font-weight 'normal])

;; Section: Different Font Weights
(new message%
     [parent panel]
     [label "Different Font Weights"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

;; Normal weight
(new label%
     [parent panel]
     [label "Normal Weight"]
     [font-size 'regular]
     [font-weight 'normal])

;; Bold weight
(new label%
     [parent panel]
     [label "Bold Weight"]
     [font-size 'regular]
     [font-weight 'bold])

;; Section: Different Colors
(new message%
     [parent panel]
     [label "Different Colors"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

;; Default color
(new label%
     [parent panel]
     [label "Default Color"]
     [font-size 'regular]
     [font-weight 'normal])

;; Red color
(new label%
     [parent panel]
     [label "Red Color"]
     [font-size 'regular]
     [font-weight 'normal]
     [color (make-object color% 255 0 0)])

;; Blue color
(new label%
     [parent panel]
     [label "Blue Color"]
     [font-size 'regular]
     [font-weight 'normal]
     [color (make-object color% 0 0 255)])

;; Green color
(new label%
     [parent panel]
     [label "Green Color"]
     [font-size 'regular]
     [font-weight 'normal]
     [color (make-object color% 0 128 0)])

;; Section: Disabled State
(new message%
     [parent panel]
     [label "Disabled State"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

;; Enabled label
(new label%
     [parent panel]
     [label "Enabled Label"]
     [font-size 'regular]
     [font-weight 'normal]
     [enabled? #t])

;; Disabled label
(new label%
     [parent panel]
     [label "Disabled Label"]
     [font-size 'regular]
     [font-weight 'normal]
     [enabled? #f])

;; Section: Combined Styles
(new message%
     [parent panel]
     [label "Combined Styles"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

;; Large bold red label
(new label%
     [parent panel]
     [label "Large Bold Red Label"]
     [font-size 'large]
     [font-weight 'bold]
     [color (make-object color% 255 0 0)])

;; Small bold blue label
(new label%
     [parent panel]
     [label "Small Bold Blue Label"]
     [font-size 'small]
     [font-weight 'bold]
     [color (make-object color% 0 0 255)])

;; Theme toggle button
(new button%
     [parent panel]
     [label "Toggle Theme"]
     [callback (λ (button event)
                 (if (equal? (current-theme) light-theme)
                     (set-theme! 'dark)
                     (set-theme! 'light)))])

;; Show window
(send frame show #t)

(displayln "Label test started. Try toggling the theme to see label changes!")
