#lang racket/gui

;; Simple Sidebar List Test File
;; Test only sidebar list component

(require racket/class
         racket/draw
         "../guix/style/config.rkt"
         "../guix/container/sidebar-list.rkt")

;; Create main window
(define frame
  (new frame%
       [label "Guix Sidebar List Test"]
       [width 600]
       [height 400]))

;; Create horizontal panel for sidebar and content
(define main-panel
  (new horizontal-panel%
       [parent frame]
       [alignment '(left top)]
       [spacing 0]))

;; Create test items
(define (create-test-items count)
  (for/list ([i (in-range count)])
    (new list-item
         [label (format "Item ~a" i)]
         [color (make-object color% (* 30 i) 122 255)]
         [count i]
         [data (format "Data ~a" i)])))

(define initial-items (create-test-items 5))

;; Create content panel to show selected item
(define content-panel
  (new vertical-panel%
       [parent main-panel]
       [alignment '(center center)]
       [spacing 20]
       [border 30]
       [min-width 300]))

;; Content title
(define content-title
  (new message%
       [parent content-panel]
       [label "Selected Item:"]
       [font (send the-font-list find-or-create-font 16 'default 'normal 'bold)]))

;; Content details
(define selected-item-label
  (new message%
       [parent content-panel]
       [label "None"]
       [font (send the-font-list find-or-create-font 14 'default 'normal 'normal)]))

;; Function to update content when selection changes
(define (update-content item)
  (when item
    (send selected-item-label set-label
          (format "Label: ~a\nCount: ~a\nData: ~a" 
                  (send item get-label)
                  (send item get-count)
                  (send item get-data)))))

;; Create sidebar list
(define sidebar-list
  (new sidebar-list%
       [parent main-panel]
       [items initial-items]
       [on-select update-content]
       [on-rename (λ (item new-label) 
                    (displayln (format "Renamed: ~a -> ~a" (send item get-label) new-label))
                    (update-content item))]
       [on-delete (λ (item) 
                    (displayln (format "Deleted: ~a" (send item get-label)))
                    (update-content (send sidebar-list get-selected-item)))]))

;; Add control panel for testing operations
(define control-panel
  (new vertical-panel%
       [parent content-panel]
       [alignment '(center center)]
       [spacing 10]
       [min-width 200]))

;; Add title for controls
(new message%
     [parent control-panel]
     [label "Controls"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

;; Button to add new item
(new button%
     [parent control-panel]
     [label "Add New Item"]
     [callback (λ (btn evt)
                 (define new-item (new list-item
                                      [label "New Item"]
                                      [color (make-object color% 255 100 100)]
                                      [count 0]
                                      [data "New Data"]))
                 (send sidebar-list add-item new-item)
                 (displayln "Added new item"))])

;; Button to remove selected item
(new button%
     [parent control-panel]
     [label "Remove Selected"]
     [callback (λ (btn evt)
                 (define selected (send sidebar-list get-selected-item))
                 (when selected
                   (define items (send sidebar-list get-items))
                   (define idx (index-of items selected))
                   (when idx
                     (send sidebar-list remove-item idx)
                     (displayln "Removed selected item"))))])

;; Theme toggle button
(new button%
     [parent control-panel]
     [label "Toggle Theme"]
     [callback (λ (btn evt)
                 (if (equal? (current-theme) light-theme)
                     (set-theme! 'dark)
                     (set-theme! 'light))
                 (displayln "Toggled theme"))])

;; Initial update
(update-content (send sidebar-list get-selected-item))

;; Show window
(send frame show #t)

(displayln "Sidebar List test started. Try:")
(displayln "- Clicking items to select")
(displayln "- Right-clicking items for context menu (rename/delete)")
(displayln "- Using controls to add/remove items")
(displayln "- Toggling theme")
