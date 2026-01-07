#lang racket/gui

;; Simple Side Panel Test File
;; Test only side panel component

(require racket/class
         racket/draw
         "../guix/style/config.rkt"
         "../guix/container/side-panel.rkt"
         "../guix/atomic/button.rkt"
         "../guix/atomic/label.rkt")

;; Create main window
(define frame
  (new frame%
       [label "Guix Side Panel Test"]
       [width 800]
       [height 600]))

;; Create side panel component
(define side-panel
  (new side-panel%
       [parent frame]
       [side-panel-width 250]
       [min-width 150]
       [max-width 400]
       [on-width-change (λ (w) (displayln (format "Side panel width changed to: ~a" w)))]))

;; Get sidebar and content panels
(define sidebar-pane (send side-panel get-side-panel))
(define content-pane (send side-panel get-content-panel))

;; Add content to sidebar
(new message%
     [parent sidebar-pane]
     [label "Sidebar Content"]
     [font (send the-font-list find-or-create-font 16 'default 'normal 'bold)]
     [color (make-object color% 0 122 255)])

(new message%
     [parent sidebar-pane]
     [label ""])

(new message%
     [parent sidebar-pane]
     [label "This is a sidebar panel"])

(new message%
     [parent sidebar-pane]
     [label "You can drag the divider"])

(new message%
     [parent sidebar-pane]
     [label "to adjust its width."])

(new message%
     [parent sidebar-pane]
     [label ""])

(new button%
     [parent sidebar-pane]
     [label "Sidebar Button"]
     [callback (λ (btn evt) (displayln "Sidebar button clicked"))])

;; Add content to main content area
(new message%
     [parent content-pane]
     [label "Main Content Area"]
     [font (send the-font-list find-or-create-font 20 'default 'normal 'bold)]
     [color (make-object color% 0 122 255)])

(new message%
     [parent content-pane]
     [label ""])

(new message%
     [parent content-pane]
     [label "This is the main content area"])

(new message%
     [parent content-pane]
     [label "The sidebar width can be adjusted by dragging"])

(new message%
     [parent content-pane]
     [label "the divider between sidebar and content."])

(new message%
     [parent content-pane]
     [label ""])

;; Add control panel for testing operations
(define control-panel
  (new vertical-panel%
       [parent content-pane]
       [alignment '(center center)]
       [spacing 15]
       [border 20]
       [min-width 300]))

;; Content title
(new message%
     [parent control-panel]
     [label "Side Panel Controls"]
     [font (send the-font-list find-or-create-font 16 'default 'normal 'bold)])

;; Width display
(define width-label
  (new message%
       [parent control-panel]
       [label (format "Current Width: ~a" (send side-panel get-side-panel-width))]
       [font (send the-font-list find-or-create-font 14 'default 'normal 'normal)]))

;; Update width display function
(define (update-width-display)
  (send width-label set-label (format "Current Width: ~a" (send side-panel get-side-panel-width))))

;; Button to set width to 200
(new button%
     [parent control-panel]
     [label "Set Width: 200"]
     [callback (λ (btn evt)
                 (send side-panel set-side-panel-width! 200)
                 (update-width-display))])

;; Button to set width to 300
(new button%
     [parent control-panel]
     [label "Set Width: 300"]
     [callback (λ (btn evt)
                 (send side-panel set-side-panel-width! 300)
                 (update-width-display))])

;; Button to set min width
(new button%
     [parent control-panel]
     [label "Set Min Width: 200"]
     [callback (λ (btn evt)
                 (send side-panel set-min-width! 200)
                 (displayln (format "Min width set to: ~a" (send side-panel get-min-width))))])

;; Button to set max width
(new button%
     [parent control-panel]
     [label "Set Max Width: 350"]
     [callback (λ (btn evt)
                 (send side-panel set-max-width! 350)
                 (displayln (format "Max width set to: ~a" (send side-panel get-max-width))))])

;; Button to reset min/max width
(new button%
     [parent control-panel]
     [label "Reset Min/Max Width"]
     [callback (λ (btn evt)
                 (send side-panel set-min-width! 150)
                 (send side-panel set-max-width! 400)
                 (displayln "Min/max width reset to default values"))])

;; Theme toggle button
(new button%
     [parent control-panel]
     [label "Toggle Theme"]
     [callback (λ (btn evt)
                 (if (equal? (current-theme) light-theme)
                     (set-theme! 'dark)
                     (set-theme! 'light))
                 (displayln "Toggled theme"))])

;; Show window
(send frame show #t)

;; Initial update
(update-width-display)

(displayln "Side Panel test started. Try:")
(displayln "- Dragging the divider to adjust sidebar width")
(displayln "- Using controls to set specific widths")
(displayln "- Setting min/max width constraints")
(displayln "- Toggling theme")
