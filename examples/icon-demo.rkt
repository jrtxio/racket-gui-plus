#lang racket/gui

;; Guix Icon Demo
;; Demonstrates the usage and features of Guix icon components
;; Supports different icons, sizes, colors, and themes

(require racket/class
         racket/draw
         "../guix/style/config.rkt"
         "../guix/atomic/icon.rkt")

;; Create main window
(define frame
  (new frame% 
       [label "Guix Icon Demo"]
       [width 600]
       [height 650]))

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
     [label "Guix Icon Component Demo"]
     [font (send the-font-list find-or-create-font 18 'default 'normal 'bold)])

;; Section 1: Available Icons
(new message% 
     [parent main-panel]
     [label "1. Available Icons"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define icons-panel
  (new horizontal-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 20]
       [min-height 80]))

;; Show all available icons
(define icon-names '("plus" "minus" "close" "arrow-left" "arrow-right" "arrow-up" "arrow-down" "search" "menu" "check" "star"))

(for-each (λ (icon-name)
            (let ([icon-panel (new vertical-panel% [parent icons-panel] [alignment '(center center)])])
              (new icon% 
                   [parent icon-panel]
                   [icon-name icon-name]
                   [size 32]
                   [callback (λ (icon event)
                               (displayln (format "~a icon clicked!" icon-name)))])))
          icon-names)

;; Section 2: Icon Sizes
(new message% 
     [parent main-panel]
     [label "2. Icon Sizes"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define sizes-panel
  (new horizontal-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 20]))

;; Show same icon in different sizes
(define (create-size-demo icon-name)
  (let ([size 16])
    (for ([i (in-range 4)])
      (let ([size-panel (new vertical-panel% [parent sizes-panel] [alignment '(center center)])])
        (new icon% 
             [parent size-panel]
             [icon-name icon-name]
             [size size])
        (new message% 
             [parent size-panel]
             [label (format "~apx" size)])
        (set! size (+ size 12))))))

(create-size-demo "search")

;; Section 3: Icon Colors
(new message% 
     [parent main-panel]
     [label "3. Icon Colors"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define colors-panel
  (new horizontal-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 20]))

;; Show same icon in different colors
(define (create-color-demo icon-name size)
  (let ([colors (list (make-object color% 255 0 0)    ; Red
                      (make-object color% 0 255 0)    ; Green
                      (make-object color% 0 0 255)    ; Blue
                      (make-object color% 255 255 0)  ; Yellow
                      (make-object color% 255 0 255)  ; Magenta
                      (make-object color% 0 255 255))]) ; Cyan
    (for-each (λ (color)
                (new icon% 
                     [parent colors-panel]
                     [icon-name icon-name]
                     [size size]
                     [color color]))
              colors)))

(create-color-demo "check" 32)

;; Section 4: Interactive Icons
(new message% 
     [parent main-panel]
     [label "4. Interactive Icons"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define interactive-panel
  (new horizontal-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 40]))

;; Interactive icons with click callbacks
(define (create-interactive-icon icon-name)
  (new icon% 
       [parent interactive-panel]
       [icon-name icon-name]
       [size 48]
       [callback (λ (icon event)
                   (displayln (format "Interactive ~a icon clicked!" icon-name)))]))

(create-interactive-icon "plus")
(create-interactive-icon "minus")
(create-interactive-icon "close")

;; Section 5: Enabled/Disabled Icons
(new message% 
     [parent main-panel]
     [label "5. Enabled/Disabled Icons"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define enable-panel
  (new horizontal-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 40]))

;; Enabled icon
(new icon% 
     [parent enable-panel]
     [icon-name "star"]
     [size 48]
     [enabled? #t]
     [callback (λ (icon event)
                 (displayln "Enabled star icon clicked!"))])

;; Disabled icon
(new icon% 
     [parent enable-panel]
     [icon-name "star"]
     [size 48]
     [enabled? #f]
     [callback (λ (icon event)
                 (displayln "This should never be called!"))])

;; Section 6: Dynamic Icon Changes
(new message% 
     [parent main-panel]
     [label "6. Dynamic Icon Changes"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define dynamic-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Target icon for dynamic changes
(define dynamic-icon
  (new icon% 
       [parent dynamic-panel]
       [icon-name "arrow-right"]
       [size 48]
       [callback (λ (icon event)
                   (displayln "Dynamic icon clicked!"))]))

;; Control panel for dynamic changes
(define dynamic-control-panel
  (new horizontal-panel% 
       [parent dynamic-panel]
       [alignment '(center center)]
       [spacing 10]))

;; Button to change icon name
(new button% 
     [parent dynamic-control-panel]
     [label "Change Icon"]
     [min-width 120]
     [callback (λ (btn event) 
                 (let ([current-icon (send dynamic-icon get-icon-name)])
                   (if (equal? current-icon "arrow-right")
                       (begin
                         (send dynamic-icon set-icon-name! "arrow-left")
                         (displayln "Icon changed to arrow-left"))
                       (begin
                         (send dynamic-icon set-icon-name! "arrow-right")
                         (displayln "Icon changed to arrow-right")))))])
  )

;; Button to change icon size
(new button% 
     [parent dynamic-control-panel]
     [label "Change Size"]
     [min-width 120]
     [callback (λ (btn event) 
                 (let ([current-size (send dynamic-icon get-icon-size)])
                   (if (= current-size 48)
                       (begin
                         (send dynamic-icon set-icon-size! 32)
                         (displayln "Icon size changed to 32px"))
                       (begin
                         (send dynamic-icon set-icon-size! 48)
                         (displayln "Icon size changed to 48px"))))])

;; Button to toggle enabled state
(new button% 
     [parent dynamic-control-panel]
     [label "Toggle Enabled"]
     [min-width 120]
     [callback (λ (btn event) 
                 (let ([current-state (send dynamic-icon get-enabled)])
                   (send dynamic-icon set-enabled (not current-state))
                   (displayln (format "Icon enabled: ~a" (not current-state))))])

;; Section 7: Theme Switching
(new message% 
     [parent main-panel]
     [label "7. Theme Switching"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define theme-icon-panel
  (new horizontal-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 30]))

;; Icons to demonstrate theme switching
(new icon% 
     [parent theme-icon-panel]
     [icon-name "search"]
     [size 48])

(new icon% 
     [parent theme-icon-panel]
     [icon-name "check"]
     [size 48])

(new icon% 
     [parent theme-icon-panel]
     [icon-name "menu"]
     [size 48])

;; Button to toggle theme
(new button% 
     [parent main-panel]
     [label "Toggle Theme (Light/Dark)"]
     [min-width 180]
     [callback (λ (btn event) 
                 (if (equal? (current-theme) light-theme)
                     (begin
                       (set-theme! 'dark)
                       (displayln "Theme switched to dark"))
                     (begin
                       (set-theme! 'light)
                       (displayln "Theme switched to light"))))]
  )

;; Show window
(send frame show #t)

(displayln "Guix Icon Demo started!")
(displayln "Available icons:")
(displayln "  plus, minus, close, arrow-left, arrow-right, arrow-up, arrow-down, search, menu, check, star")
(displayln "")
(displayln "Features demonstrated:")
(displayln "  - All available icons")
(displayln "  - Different icon sizes")
(displayln "  - Custom icon colors")
(displayln "  - Interactive icons with click callbacks")
(displayln "  - Enabled/disabled states")
(displayln "  - Dynamic icon changes (name, size, enabled state)")
(displayln "  - Theme switching support")
(displayln "")
(displayln "Try clicking the interactive icons and changing the theme!")