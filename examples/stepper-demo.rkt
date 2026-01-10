#lang racket/gui

;; Guix Stepper Demo
;; Demonstrates the usage and features of Guix stepper components
;; Supports increment/decrement operations, custom ranges, and theme switching

(require racket/class
         racket/draw
         "../guix/style/config.rkt"
         "../guix/atomic/stepper.rkt")

;; Create main window
(define frame
  (new frame% 
       [label "Guix Stepper Demo"]
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
     [label "Guix Stepper Component Demo"]
     [font (send the-font-list find-or-create-font 18 'default 'normal 'bold)])

;; Section 1: Basic Stepper
(new message% 
     [parent main-panel]
     [label "1. Basic Stepper"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define basic-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Simple stepper with default settings
(new message% 
     [parent basic-panel]
     [label "Default stepper:"])

(new stepper% 
     [parent basic-panel]
     [value 0]
     [callback (λ (stp value)
                 (displayln (format "Basic stepper value: ~a" value)))])

;; Section 2: Stepper with Range Limits
(new message% 
     [parent main-panel]
     [label "2. Stepper with Range Limits"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define range-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Stepper with minimum and maximum values
(new message% 
     [parent range-panel]
     [label "With min/max limits (0-10):"])

(new stepper% 
     [parent range-panel]
     [value 5]
     [min-value 0]
     [max-value 10]
     [callback (λ (stp value)
                 (displayln (format "Range stepper value: ~a" value)))])

;; Section 3: Stepper with Custom Step
(new message% 
     [parent main-panel]
     [label "3. Stepper with Custom Step"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define step-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Stepper with custom step size
(new message% 
     [parent step-panel]
     [label "With custom step size (2):"])

(new stepper% 
     [parent step-panel]
     [value 0]
     [step 2]
     [callback (λ (stp value)
                 (displayln (format "Custom step stepper value: ~a" value)))])

;; Section 4: Stepper with Real-time Value Display
(new message% 
     [parent main-panel]
     [label "4. Stepper with Real-time Value Display"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define realtime-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Create a panel to hold stepper and value display
(define stepper-with-value-panel
  (new horizontal-panel% 
       [parent realtime-panel]
       [alignment '(center center)]
       [spacing 20]))

;; Create a message to display the stepper value
(define stepper-value-message
  (new message% 
       [parent stepper-with-value-panel]
       [label "Value: 0"]
       [font (send the-font-list find-or-create-font 16 'default 'normal 'bold)])
  )

;; Stepper that updates the message in real-time
(new stepper% 
     [parent stepper-with-value-panel]
     [value 0]
     [min-value -50]
     [max-value 50]
     [step 5]
     [callback (λ (stp value)
                 (send stepper-value-message set-label (format "Value: ~a" value))
                 (displayln (format "Real-time stepper value: ~a" value)))])

;; Section 5: Disabled Stepper
(new message% 
     [parent main-panel]
     [label "5. Disabled Stepper"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define disabled-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Disabled stepper
(new message% 
     [parent disabled-panel]
     [label "Disabled stepper:"])

(new stepper% 
     [parent disabled-panel]
     [value 0]
     [enabled? #f]
     [callback (λ (stp value)
                 (displayln "This should never be called!"))])

;; Section 6: Dynamic Stepper Operations
(new message% 
     [parent main-panel]
     [label "6. Dynamic Stepper Operations"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define dynamic-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Target stepper for dynamic operations
(new message% 
     [parent dynamic-panel]
     [label "Dynamic stepper:"])

(define dynamic-stepper
  (new stepper% 
       [parent dynamic-panel]
       [value 10]
       [min-value 0]
       [max-value 100]
       [step 1]
       [callback (λ (stp value)
                   (displayln (format "Dynamic stepper value: ~a" value)))]))

;; Control panel for dynamic operations
(define dynamic-control-panel
  (new horizontal-panel% 
       [parent dynamic-panel]
       [alignment '(center center)]
       [spacing 10]))

;; Button to set stepper to minimum value
(new button% 
     [parent dynamic-control-panel]
     [label "Set Min"]
     [min-width 100]
     [callback (λ (btn event) 
                 (send dynamic-stepper set-value! (send dynamic-stepper get-min-value))
                 (displayln "Stepper set to minimum value"))])

;; Define callback functions
(define (set-middle-callback btn event)
  (let ([min-val (send dynamic-stepper get-min-value)]
        [max-val (send dynamic-stepper get-max-value)])
    (send dynamic-stepper set-value! (quotient (+ min-val max-val) 2))
    (displayln "Stepper set to middle value")))

(define (set-max-callback btn event)
  (send dynamic-stepper set-value! (send dynamic-stepper get-max-value))
  (displayln "Stepper set to maximum value"))

(define (toggle-step-callback btn event)
  (let ([current-step (send dynamic-stepper get-step)])
    (if (= current-step 1)
        (begin
          (send dynamic-stepper set-step! 10)
          (displayln "Step changed to 10")
          (send dynamic-stepper set-value! 0))
        (begin
          (send dynamic-stepper set-step! 1)
          (displayln "Step changed to 1")
          (send dynamic-stepper set-value! 0)))))

(define (toggle-enabled-callback btn event)
  (let ([current-state (send dynamic-stepper get-enabled)])
    (send dynamic-stepper set-enabled! (not current-state))
    (displayln (format "Stepper enabled: ~a" (not current-state)))))

;; Button to set stepper to middle value
(new button% 
     [parent dynamic-control-panel]
     [label "Set Middle"]
     [min-width 100]
     [callback set-middle-callback])

;; Button to set stepper to maximum value
(new button% 
     [parent dynamic-control-panel]
     [label "Set Max"]
     [min-width 100]
     [callback set-max-callback])

;; Button to change step size
(new button% 
     [parent dynamic-control-panel]
     [label "Toggle Step"]
     [min-width 100]
     [callback toggle-step-callback])

;; Button to toggle enabled state
(new button% 
     [parent dynamic-control-panel]
     [label "Toggle Enabled"]
     [min-width 100]
     [callback toggle-enabled-callback])

;; Section 7: Multiple Steppers in a Group
(new message% 
     [parent main-panel]
     [label "7. Multiple Steppers in a Group"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define group-panel
  (new horizontal-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 20]))

;; Create a group of steppers for different settings
(new vertical-panel% 
     [parent group-panel]
     [alignment '(center center)]
     [spacing 10]
     [children (list
                (new message% [label "Setting 1:"])
                (new stepper% 
                     [value 0]
                     [min-value -10]
                     [max-value 10]
                     [callback (λ (stp value)
                                 (displayln (format "Setting 1 value: ~a" value)))])
                )])

(new vertical-panel% 
     [parent group-panel]
     [alignment '(center center)]
     [spacing 10]
     [children (list
                (new message% [label "Setting 2:"])
                (new stepper% 
                     [value 50]
                     [min-value 0]
                     [max-value 100]
                     [step 5]
                     [callback (λ (stp value)
                                 (displayln (format "Setting 2 value: ~a" value)))])
                )])

(new vertical-panel% 
     [parent group-panel]
     [alignment '(center center)]
     [spacing 10]
     [children (list
                (new message% [label "Setting 3:"])
                (new stepper% 
                     [value 0]
                     [min-value -100]
                     [max-value 100]
                     [step 25]
                     [callback (λ (stp value)
                                 (displayln (format "Setting 3 value: ~a" value)))])
                )])

;; Section 8: Theme Switching
(new message% 
     [parent main-panel]
     [label "8. Theme Switching"]
     [font (send the-font-list find-or-create-font 14 'default 'normal 'bold)])

(define theme-panel
  (new vertical-panel% 
       [parent main-panel]
       [alignment '(center center)]
       [spacing 15]))

;; Steppers to demonstrate theme switching
(new message% 
     [parent theme-panel]
     [label "Theme demo steppers:"])

(define theme-steppers-panel
  (new horizontal-panel% 
       [parent theme-panel]
       [alignment '(center center)]
       [spacing 20]))

(new stepper% 
     [parent theme-steppers-panel]
     [value 0]
     [min-value -50]
     [max-value 50]
     [callback (λ (stp value)
                 (displayln (format "Theme demo 1 stepper value: ~a" value)))])

(new stepper% 
     [parent theme-steppers-panel]
     [value 25]
     [min-value 0]
     [max-value 100]
     [step 5]
     [callback (λ (stp value)
                 (displayln (format "Theme demo 2 stepper value: ~a" value)))])

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
                       (displayln "Theme switched to light"))))]
  )

;; Usage instructions
(new message% 
     [parent main-panel]
     [label "\nUsage Instructions:"]
     [font (send the-font-list find-or-create-font 12 'default 'normal 'bold)])

(new message% 
     [parent main-panel]
     [label "1. Click the left arrow to decrease value"])

(new message% 
     [parent main-panel]
     [label "2. Click the right arrow to increase value"])

(new message% 
     [parent main-panel]
     [label "3. Some steppers have minimum/maximum limits"])

(new message% 
     [parent main-panel]
     [label "4. Use the control buttons to dynamically change settings"])

(new message% 
     [parent main-panel]
     [label "5. Try switching themes to see stepper appearance change"])

;; Show window
(send frame show #t)

(displayln "Guix Stepper Demo started!")
(displayln "Features demonstrated:")
(displayln "  - Basic increment/decrement functionality")
(displayln "  - Range limits (minimum and maximum values)")
(displayln "  - Custom step sizes")
(displayln "  - Real-time value display")
(displayln "  - Disabled state")
(displayln "  - Dynamic stepper operations")
(displayln "  - Multiple steppers in a group")
(displayln "  - Theme switching support")
(displayln "")
(displayln "Try clicking the stepper arrows to see their behavior!")