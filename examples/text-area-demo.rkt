#lang racket/gui

;; Text area component demo
;; Demonstrates various text area features and interactions

(require racket/class
         "../core/base-container.rkt"
         "../core/theme.rkt"
         "../style/config.rkt"
         "text-area.rkt")

;; Create a frame for the demo
(define frame (new frame% [label "Text Area Component Demo"]
                  [width 900]
                  [height 700]))

;; Create a panel with vertical alignment for the demo
(define main-panel (new vertical-panel% [parent frame]
                        [alignment '(center center)]
                        [spacing 20]
                        [border 20]))

;; Title label
(new message% [parent main-panel]
     [label "Text Area Component Demo"]
     [font (font-bold 16)])

;; Section: Basic Text Areas
(new message% [parent main-panel]
     [label "1. Basic Text Areas"]
     [font (font-semibold 12)])

(define basic-panel (new horizontal-panel% [parent main-panel]
                        [alignment '(center center)]
                        [spacing 20]))

;; Basic text area
(new guix-text-area% [parent basic-panel]
     [placeholder "Click to edit"]
     [callback (lambda (ta)
                 (displayln (format "Basic text area changed: ~a" (send ta get-text))))])

;; Text area with initial value
(new guix-text-area% [parent basic-panel]
     [placeholder "Click to edit"]
     [init-value "Initial multi-line text\nSecond line\nThird line"]
     [callback (lambda (ta)
                 (displayln (format "Value text area changed: ~a" (send ta get-text))))])

;; Section: Placeholder Text
(new message% [parent main-panel]
     [label "2. Placeholder Text"]
     [font (font-semibold 12)])

(define placeholder-panel (new horizontal-panel% [parent main-panel]
                              [alignment '(center center)]
                              [spacing 20]))

;; Text area with placeholder
(new guix-text-area% [parent placeholder-panel]
     [placeholder "Enter your message here..."]
     [callback (lambda (ta)
                 (displayln (format "Message: ~a" (send ta get-text))))])

;; Text area with long placeholder
(new guix-text-area% [parent placeholder-panel]
     [placeholder "This is a very long placeholder text that demonstrates how placeholders work in multi-line text areas.\nIt can even span multiple lines!"]
     [callback (lambda (ta)
                 (displayln (format "Long placeholder field changed: ~a" (send ta get-text))))])

;; Section: Text Area Sizes
(new message% [parent main-panel]
     [label "3. Different Sizes"]
     [font (font-semibold 12)])

(define sizes-panel (new vertical-panel% [parent main-panel]
                        [alignment '(center center)]
                        [spacing 20]))

;; Small text area
(define small-ta (new guix-text-area% [parent sizes-panel]
                     [placeholder "Small text area"]))
(send small-ta min-width 300)
(send small-ta min-height 80)

;; Medium text area (default size)
(new guix-text-area% [parent sizes-panel]
     [placeholder "Medium text area"])

;; Large text area
(define large-ta (new guix-text-area% [parent sizes-panel]
                     [placeholder "Large text area"]))
(send large-ta min-width 500)
(send large-ta min-height 150)

;; Section: Dynamic Text Changes
(new message% [parent main-panel]
     [label "4. Dynamic Operations"]
     [font (font-semibold 12)])

(define dynamic-panel (new horizontal-panel% [parent main-panel]
                          [alignment '(center center)]
                          [spacing 20]))

;; Dynamic text area
(define dynamic-ta (new guix-text-area% [parent dynamic-panel]
                         [placeholder "Dynamic text field"]
                         [callback (lambda (ta)
                                     (displayln (format "Dynamic field changed: ~a" (send ta get-text))))]))

;; Control buttons for dynamic changes
(define ta-controls (new vertical-panel% [parent dynamic-panel]
                             [alignment '(center center)]
                             [spacing 10]))

(new button% [parent ta-controls]
     [label "Set Text"]
     [callback (lambda (btn evt)
                 (send dynamic-ta set-text "Dynamically set text\nWith multiple lines\nAdded programmatically"))])

(new button% [parent ta-controls]
     [label "Clear"]
     [callback (lambda (btn evt)
                 (send dynamic-ta clear))])

(new button% [parent ta-controls]
     [label "Get Text"]
     [callback (lambda (btn evt)
                 (let ([text (send dynamic-ta get-text)])
                   (displayln (format "Dynamic field text: ~a" text))))])

;; Section: Theme Switching
(new message% [parent main-panel]
     [label "5. Theme Switching"]
     [font (font-semibold 12)])

(define theme-panel (new horizontal-panel% [parent main-panel]
                        [alignment '(center center)]
                        [spacing 20]))

;; Theme demo text area
(new guix-text-area% [parent theme-panel]
     [placeholder "Try switching themes"]
     [callback (lambda (ta)
                 (displayln (format "Theme demo field changed: ~a" (send ta get-text))))])

;; Theme switch buttons
(new button% [parent theme-panel]
     [label "Light Theme"]
     [callback (lambda (btn evt)
                 (set-theme! 'light)
                 (displayln "Switched to light theme"))])

(new button% [parent theme-panel]
     [label "Dark Theme"]
     [callback (lambda (btn evt)
                 (set-theme! 'dark)
                 (displayln "Switched to dark theme"))])

;; Section: Real-time Input Display
(new message% [parent main-panel]
     [label "6. Real-time Input Display"]
     [font (font-semibold 12)])

(define realtime-panel (new vertical-panel% [parent main-panel]
                           [alignment '(center center)]
                           [spacing 10]))

;; Realtime display text area
(new guix-text-area% [parent realtime-panel]
     [placeholder "Type here..."]
     [callback (lambda (ta)
                 (let ([text (send ta get-text)])
                   (send realtime-message set-label (format "Input: ~a" text))))])

;; Realtime display message
(define realtime-message (new message% [parent realtime-panel]
                              [label "Input: "]
                              [font (font-regular)]))

;; Section: Multiple Text Areas
(new message% [parent main-panel]
     [label "7. Multiple Text Areas"]
     [font (font-semibold 12)])

(define multiple-panel (new horizontal-panel% [parent main-panel]
                           [alignment '(center center)]
                           [spacing 20]))

;; Create multiple text areas for different purposes
(define (create-text-area label placeholder)
  (define ta-panel (new vertical-panel% [parent multiple-panel]
                        [alignment '(center center)]
                        [spacing 5]))
  
  (new message% [parent ta-panel]
       [label label]
       [font (font-regular 10)])
  
  (new guix-text-area% [parent ta-panel]
       [placeholder placeholder]
       [callback (lambda (ta)
                   (displayln (format "~a text area: ~a" label (send ta get-text))))]))

(create-text-area "Description" "Enter description here...")
(create-text-area "Notes" "Add your notes...")

;; Section: Keyboard Navigation Demo
(new message% [parent main-panel]
     [label "8. Keyboard Navigation"]
     [font (font-semibold 12)])

(define keyboard-panel (new vertical-panel% [parent main-panel]
                           [alignment '(center center)]
                           [spacing 10]))

(new message% [parent keyboard-panel]
     [label "Try these keyboard shortcuts:"]
     [font (font-regular 10)])

(new message% [parent keyboard-panel]
     [label "- Click to start editing"]
     [font (font-regular 10)])

(new message% [parent keyboard-panel]
     [label "- Type to enter text"]
     [font (font-regular 10)])

(new message% [parent keyboard-panel]
     [label "- Enter for new line"]
     [font (font-regular 10)])

(new message% [parent keyboard-panel]
     [label "- Backspace/Delete to remove text"]
     [font (font-regular 10)])

(new message% [parent keyboard-panel]
     [label "- Arrow keys to navigate"]
     [font (font-regular 10)])

(new message% [parent keyboard-panel]
     [label "- Home/End to jump to line start/end"]
     [font (font-regular 10)])

(new message% [parent keyboard-panel]
     [label "- Tab for indentation"]
     [font (font-regular 10)])

(new message% [parent keyboard-panel]
     [label "- Click outside to finish editing"]
     [font (font-regular 10)])

;; Demo field for keyboard navigation
(new guix-text-area% [parent keyboard-panel]
     [placeholder "Practice keyboard navigation here"]
     [callback (lambda (ta)
                 (displayln (format "Keyboard demo field changed: ~a" (send ta get-text))))])

;; Section: Scrollable Text Area
(new message% [parent main-panel]
     [label "9. Scrollable Text Area"]
     [font (font-semibold 12)])

(define scrollable-panel (new vertical-panel% [parent main-panel]
                              [alignment '(center center)]
                              [spacing 10]))

;; Create a panel with a vertical scrollbar to contain the text area
(define scrollable-container (new vertical-panel% [parent scrollable-panel]
                                  [style '(auto-vscroll)]
                                  [min-width 400]
                                  [min-height 150]))

;; Scrollable text area with long initial text
(new guix-text-area% [parent scrollable-container]
     [init-value "This is a scrollable text area with a lot of content.\n" 
                 #<<EOF
Line 1: This text area demonstrates scrolling behavior.
Line 2: When you have more text than can fit in the visible area,
Line 3: the container will show scrollbars.
Line 4: You can use the scrollbar to navigate through the content.
Line 5: This is useful for long documents or multi-line input.
Line 6: You can also use keyboard shortcuts to navigate.
Line 7: Try using the arrow keys to move around.
Line 8: Or use Page Up and Page Down.
Line 9: This text is intentionally long to demonstrate scrolling.
Line 10: Continue typing to see how the scrollbars work.
Line 11: The text area will automatically expand if needed.
Line 12: Or you can set a fixed size with scrollbars.
Line 13: This example uses a container with auto-vscroll style.
Line 14: You can also add horizontal scrollbars if needed.
Line 15: Scrollable text areas are useful for many applications.
Line 16: They provide a good user experience for long text input.
Line 17: Try adding more text to see the scrollbars in action.
Line 18: You can also use the mouse wheel to scroll.
Line 19: This is a convenient way to navigate through content.
Line 20: Scrollable text areas are a common UI component.
EOF
                 ]
     [callback (lambda (ta)
                 (displayln "Scrollable text area content changed"))])

;; Show the frame
(send frame show #t)

(displayln "Text area demo loaded successfully!")
(displayln "Try the following:")
(displayln "1. Click on any text area to start editing")
(displayln "2. Type text with multiple lines")
(displayln "3. Use Enter for new lines")
(displayln "4. Use Tab for indentation")
(displayln "5. Use keyboard shortcuts to navigate")
(displayln "6. Observe placeholder text appearing/disappearing")
(displayln "7. Use dynamic control buttons to manipulate text")
(displayln "8. Switch between light and dark themes")
(displayln "9. See real-time input updates")
(displayln "10. Compare different text area sizes")
(displayln "11. Try the scrollable text area")