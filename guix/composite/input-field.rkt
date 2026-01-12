#lang racket/gui

;; Input field component
;; Enhanced text input with additional features like icons and validation

(require racket/class
         racket/gui/base
         racket/match
         "../core/composite-control.rkt"
         "../style/config.rkt")

(provide input-field%
         guix-input-field%)

;; ===========================
;; Input Field - Single Canvas Implementation
;; ===========================
(define input-field%
  (class guix-composite-control%
    ;; Control parameters
    (init-field [placeholder ""]
                [callback (λ (t) (void))]
                [init-value ""]
                [style '()]
                [left-icon #f]
                [right-icon #f]
                [validation-state 'normal] ;; 'normal, 'error, 'warning
                )
    
    ;; ===========================
    ;; Internal State
    ;; ===========================
    
    ;; Text input state
    (field [text-value init-value]
           [cursor-position (string-length init-value)]
           [is-focused? #f]
           [current-left-icon left-icon]
           [current-right-icon right-icon]
           [current-validation-state validation-state])
    
    ;; ===========================
    ;; Region Definitions
    ;; ===========================
    
    ;; Define regions for hit-testing
    (define/override (get-regions)
      (append '(input-area)
              (if current-left-icon '(left-icon) '())
              (if current-right-icon '(right-icon) '())))
    
    ;; Hit test implementation
    (define/override (hit-test x y)
      (match-define (cons width height) (get-size))
      
      ;; Icon dimensions
      (define icon-size 24)
      (define icon-margin 8)
      
      (cond
        ;; Left icon region
        [(and current-left-icon (<= x (+ icon-size (* 2 icon-margin))))
         'left-icon]
        
        ;; Right icon region
        [(and current-right-icon (>= x (- width (+ icon-size (* 2 icon-margin)))))
         'right-icon]
        
        ;; Default: input area
        [else 'input-area]))
    
    ;; Get region bounds
    (define/override (get-region-bounds region)
      (match-define (cons width height) (get-size))
      
      ;; Icon dimensions
      (define icon-size 24)
      (define icon-margin 8)
      
      (match region
        ['input-area
         (list (if current-left-icon (+ icon-size (* 2 icon-margin)) 8)
               0
               (if current-right-icon (- width (+ icon-size (* 2 icon-margin))) width)
               height)]
        ['left-icon
         (list 8 0 (+ icon-size (* 2 icon-margin)) height)]
        ['right-icon
         (list (- width (+ icon-size (* 2 icon-margin))) 0 width height)]
        [_ #f]))
    
    ;; ===========================
    ;; Event Handling
    ;; ===========================
    
    ;; Handle region hover enter
    (define/override (on-region-hover-enter region)
      (send this refresh-now))
    
    ;; Handle region hover exit
    (define/override (on-region-hover-exit region)
      (send this refresh-now))
    
    ;; Handle region click
    (define/override (on-region-click region event)
      (match region
        ['input-area
         ;; Focus the control when input region is clicked
         (send this focus)
         (set! is-focused? #t)]
        ['left-icon
         ;; Handle left icon click - can be extended with callback
         (void)]
        ['right-icon
         ;; Handle right icon click - can be extended with callback
         (void)]))
    
    ;; Handle region release
    (define/override (on-region-release region event)
      (void))
    
    ;; ===========================
    ;; Event Handling Enhancements
    ;; ===========================
    
    ;; Handle keyboard events for text input
    (define/override (handle-keyboard-event event)
      (when is-focused?
        (define event-type (send event get-event-type))
        
        (match event-type
          ['char
           (define char (send event get-key-code))
           ;; Insert character at cursor position
           (set! text-value (string-append (substring text-value 0 cursor-position)
                                          (string char)
                                          (substring text-value cursor-position)))
           (set! cursor-position (add1 cursor-position))
           (callback this)
           (send this refresh-now)]
          
          ['backspace
           ;; Delete character before cursor
           (when (> cursor-position 0)
             (set! text-value (string-append (substring text-value 0 (sub1 cursor-position))
                                            (substring text-value cursor-position)))
             (set! cursor-position (sub1 cursor-position))
             (callback this)
             (send this refresh-now))]
          
          ['delete
           ;; Delete character after cursor
           (when (< cursor-position (string-length text-value))
             (set! text-value (string-append (substring text-value 0 cursor-position)
                                            (substring text-value (add1 cursor-position))))
             (callback this)
             (send this refresh-now))]
          
          ['left
           ;; Move cursor left
           (when (> cursor-position 0)
             (set! cursor-position (sub1 cursor-position))
             (send this refresh-now))]
          
          ['right
           ;; Move cursor right
           (when (< cursor-position (string-length text-value))
             (set! cursor-position (add1 cursor-position))
             (send this refresh-now))]
          
          ['home
           ;; Move cursor to start
           (set! cursor-position 0)
           (send this refresh-now)]
          
          ['end
           ;; Move cursor to end
           (set! cursor-position (string-length text-value))
           (send this refresh-now)])))
    
    ;; Focus management methods
    (define/public (set-focused f)
      (set! is-focused? f)
      (send this refresh-now))
    
    (define/public (is-focused)
      is-focused?)
    
    ;; ===========================
    ;; Rendering
    ;; ===========================
    
    ;; Main rendering method
    (define/override (render-control dc state theme)
      (match-define (cons width height) (get-size))
      
      ;; Icon dimensions
      (define icon-size 24)
      (define icon-margin 8)
      
      ;; Draw background with validation border
      (define border-color
        (match current-validation-state
          ['error (theme-color 'error)]
          ['warning (theme-color 'warning)]
          ['success (theme-color 'success)]
          [_ (theme-color 'border)]))
      
      (send dc set-brush (make-brush #:color (theme-color 'surface-light)))
      (send dc set-pen (make-pen #:color border-color #:width 1))
      (send dc draw-rectangle 0 0 width height)
      
      ;; Draw left icon
      (when current-left-icon
        ;; Simplified icon drawing - replace with actual icon rendering
        (send dc set-pen (make-pen #:color (theme-color 'text-secondary))) 
        (send dc draw-rectangle icon-margin (/ (- height icon-size) 2) icon-size icon-size)
        (send dc set-text-foreground (theme-color 'text-secondary))
        (send dc set-font (font-small))
        (send dc draw-text "I" (+ icon-margin (/ icon-size 2 3)) (+ (/ (- height icon-size) 2) 16)))
      
      ;; Draw right icon
      (when current-right-icon
        ;; Simplified icon drawing - replace with actual icon rendering
        (send dc set-pen (make-pen #:color (theme-color 'text-secondary))) 
        (define right-icon-x (- width (+ icon-size (* 2 icon-margin))))
        (send dc draw-rectangle (+ right-icon-x icon-margin) (/ (- height icon-size) 2) icon-size icon-size)
        (send dc set-text-foreground (theme-color 'text-secondary))
        (send dc set-font (font-small))
        (send dc draw-text "O" (+ right-icon-x icon-margin (/ icon-size 2 3)) (+ (/ (- height icon-size) 2) 16)))
      
      ;; Calculate text input position and size
      (define text-x (if current-left-icon (+ icon-size (* 2 icon-margin)) 8))
      (define text-y 10)
      (define text-width (if current-right-icon
                           (- width (+ text-x icon-size (* 2 icon-margin)))
                           (- width text-x 8)))
      
      ;; Set font for text input
      (send dc set-font (font-regular))
      
      ;; Draw text or placeholder
      (cond
        [(non-empty-string? text-value)
         (send dc set-text-foreground (theme-color 'text-main))
         (send dc draw-text text-value text-x text-y)]
        [else
         (send dc set-text-foreground (theme-color 'text-placeholder))
         (send dc draw-text placeholder text-x text-y)])
      
      ;; Draw cursor if focused
      (when (and is-focused? (send this has-focus?))
        (define cursor-x (+ text-x (send dc get-text-width (substring text-value 0 cursor-position))))
        (define cursor-y text-y)
        (define cursor-height (send dc get-font-height))
        
        (send dc set-pen (make-pen #:color (theme-color 'text-main) #:width 1))
        (send dc draw-line cursor-x cursor-y cursor-x (+ cursor-y cursor-height))))
    
    ;; ===========================
    ;; Public Interface
    ;; ===========================
    
    ;; Get current text value
    (define/public (get-text)
      text-value)
    
    ;; Set text value
    (define/public (set-text str)
      (set! text-value str)
      (set! cursor-position (string-length str))
      (send this refresh-now))
    
    ;; Clear text
    (define/public (clear)
      (set-text ""))
    
    ;; Set validation state
    (define/public (set-validation-state state)
      (set! current-validation-state state)
      (send this refresh-now))
    
    ;; Get validation state
    (define/public (get-validation-state)
      current-validation-state)
    
    ;; Set left icon
    (define/public (set-left-icon icon)
      (set! current-left-icon icon)
      (send this refresh-now))
    
    ;; Get left icon
    (define/public (get-left-icon)
      current-left-icon)
    
    ;; Set right icon
    (define/public (set-right-icon icon)
      (set! current-right-icon icon)
      (send this refresh-now))
    
    ;; Get right icon
    (define/public (get-right-icon)
      current-right-icon)
    
    ;; Get size helper
    (define (get-size)
      (cons (send this get-width) (send this get-height)))
    
    ;; ===========================
    ;; Initialization
    ;; ===========================
    
    ;; Initialize the control
    (super-new [min-width 240]
               [min-height (input-height)])
    ))

;; New guix-input-field% with updated naming convention
(define guix-input-field% input-field%)
