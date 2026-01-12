#lang racket/gui

;; Search field component
;; Enhanced input field with search functionality - Single canvas implementation

(require racket/class
         racket/gui/base
         racket/match
         "../core/composite-control.rkt"
         "../style/config.rkt")

(provide search-field%
         guix-search-field%)

;; ===========================
;; Search Field - Single Canvas Implementation
;; ===========================
(define search-field%
  (class guix-composite-control%
    ;; Control parameters
    (init-field [placeholder "Search..."]
                [on-callback (λ (sf event) (void))] ; Callback when text changes or search is triggered
                [init-value ""]
                [style '()])
    
    ;; ===========================
    ;; Internal State
    ;; ===========================
    
    ;; Text input state
    (field [text-value init-value]
           [search-button-rect #f]
           [cursor-position (string-length init-value)]
           [is-focused? #f])
    
    ;; ===========================
    ;; Region Definitions
    ;; ===========================
    
    ;; Define regions for hit-testing
    (define/override (get-regions) '(search-input search-button))
    
    ;; Hit test implementation
    (define/override (hit-test x y)
      (match-define (cons width height) (get-size))
      
      ;; Search button region (right side)
      (define button-width 60)
      (define button-left (- width button-width 8))
      
      (cond
        [(and (>= x button-left) (<= x width)) 'search-button]
        [else 'search-input]))
    
    ;; Get region bounds
    (define/override (get-region-bounds region)
      (match-define (cons width height) (get-size))
      
      (match region
        ['search-input
         (list 8 0 (- width 76) height)]
        ['search-button
         (list (- width 68) 0 (- width 8) height)]
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
        ['search-input
         ;; Focus the control when input region is clicked
         (send this focus)
         (set! is-focused? #t)]
        ['search-button
         ;; Trigger search callback when button is clicked
         (on-callback this #f)]))
    
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
           (on-callback this #f)
           (send this refresh-now)]
          
          ['backspace
           ;; Delete character before cursor
           (when (> cursor-position 0)
             (set! text-value (string-append (substring text-value 0 (sub1 cursor-position))
                                            (substring text-value cursor-position)))
             (set! cursor-position (sub1 cursor-position))
             (on-callback this #f)
             (send this refresh-now))]
          
          ['delete
           ;; Delete character after cursor
           (when (< cursor-position (string-length text-value))
             (set! text-value (string-append (substring text-value 0 cursor-position)
                                            (substring text-value (add1 cursor-position))))
             (on-callback this #f)
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
      
      ;; Draw background
      (send dc set-brush (make-brush #:color (theme-color 'surface-light)))
      (send dc set-pen (make-pen #:color (theme-color 'border) #:width 1))
      (send dc draw-rectangle 0 0 width height)
      
      ;; Draw search icon (magnifying glass) - simplified representation
      (send dc set-pen (make-pen #:color (theme-color 'text-light) #:width 1))
      (send dc draw-ellipse 12 10 8 8)
      (send dc draw-line 20 14 24 18)
      
      ;; Calculate button dimensions
      (define button-width 60)
      (define button-height (max 20 (- height 8)))
      (define button-left (max 8 (- width button-width 8)))
      (define button-top 4)
      
      ;; Update button rect for hit-testing
      (set! search-button-rect (list button-left button-top (- width 8) (+ button-top button-height)))
      
      ;; Draw search button
      (let ([button-state (if (equal? (send this get-hovered-region) 'search-button) 'hover 'normal)])
        (match button-state
          ['normal
           (send dc set-brush (make-brush #:color (theme-color 'accent)))
           (send dc set-pen (make-pen #:color (theme-color 'accent) #:width 1))]
          ['hover
           (send dc set-brush (make-brush #:color (theme-color 'accent-hover)))
           (send dc set-pen (make-pen #:color (theme-color 'accent-hover) #:width 1))])
        
        ;; Draw button background
        (send dc draw-rectangle button-left button-top button-width button-height)
        
        ;; Draw button text
        (send dc set-text-foreground (theme-color 'background))
        (send dc set-font (font-medium))
        (send dc draw-text "Search" (+ button-left 12) (+ button-top 9)))
      
      ;; Draw text input area
      (define text-x 40)
      (define text-y 10)
      (define text-width (- button-left text-x 8))
      
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
    
    ;; Callback method for external triggering
    (define/public (callback self event)
      (on-callback self event))
    
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

;; New guix-search-field% with updated naming convention
(define guix-search-field% search-field%)
