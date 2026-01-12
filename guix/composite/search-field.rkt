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
           [cursor-position (string-length init-value)]
           [selection-start 0]           ; Selection start position
           [selection-end (string-length init-value)] ; Selection end position
           [is-focused? #f])
    
    ;; ===========================
    ;; Region Definitions
    ;; ===========================
    
    ;; Define regions for hit-testing
    (define/override (get-regions) '(search-input))
    
    ;; Hit test implementation
    (define/override (hit-test x y)
      'search-input)  ; Entire area is search input
    
    ;; Get region bounds
    (define/override (get-region-bounds region)
      (match-define (cons width height) (get-size))
      
      (match region
        ['search-input
         (list 0 0 width height)]
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
         (set! is-focused? #t)
         (send this set-focused-region 'search-input)
         (send this focus) ;; 获取系统焦点
         (send this refresh-now)]))
    
    ;; Handle region release
    (define/override (on-region-release region event)
      (void))
    
    ;; ===========================
    ;; Event Handling Enhancements
    ;; ===========================
    
    ;; Handle character input for text entry
    (define/override (on-char event)
      (when (or is-focused? (send this has-focus?))
        (define key-code (send event get-key-code))
        (define control-down? (send event get-control-down))
        
        (cond
          ;; Handle Ctrl+A (select all)
          [(and control-down? (eq? key-code #\a))
           (set! selection-start 0)
           (set! selection-end (string-length text-value))
           (send this refresh-now)]
          
          ;; Handle printable characters
          [(char? key-code)
           ;; If text is selected, replace it with the new character
           (if (< selection-start selection-end)
               (begin
                 (set! text-value (string-append (substring text-value 0 selection-start)
                                                (string key-code)
                                                (substring text-value selection-end)))
                 (set! cursor-position (add1 selection-start))
                 (set! selection-start cursor-position)
                 (set! selection-end cursor-position))
               (begin
                 (set! text-value (string-append (substring text-value 0 cursor-position)
                                                (string key-code)
                                                (substring text-value cursor-position)))
                 (set! cursor-position (add1 cursor-position))
                 (set! selection-start cursor-position)
                 (set! selection-end cursor-position)))
           (on-callback this #f)
           (send this refresh-now)]
          
          ;; Handle backspace
          [(eq? key-code #\backspace)
           (if (< selection-start selection-end)
               ;; Delete selected text
               (begin
                 (set! text-value (string-append (substring text-value 0 selection-start)
                                                (substring text-value selection-end)))
                 (set! cursor-position selection-start)
                 (set! selection-start cursor-position)
                 (set! selection-end cursor-position)
                 (on-callback this #f)
                 (send this refresh-now))
               ;; Delete character before cursor
               (when (> cursor-position 0)
                 (set! text-value (string-append (substring text-value 0 (sub1 cursor-position))
                                                (substring text-value cursor-position)))
                 (set! cursor-position (sub1 cursor-position))
                 (set! selection-start cursor-position)
                 (set! selection-end cursor-position)
                 (on-callback this #f)
                 (send this refresh-now)))]
          
          ;; Handle delete
          [(eq? key-code 'delete)
           (if (< selection-start selection-end)
               ;; Delete selected text
               (begin
                 (set! text-value (string-append (substring text-value 0 selection-start)
                                                (substring text-value selection-end)))
                 (set! cursor-position selection-start)
                 (set! selection-start cursor-position)
                 (set! selection-end cursor-position)
                 (on-callback this #f)
                 (send this refresh-now))
               ;; Delete character after cursor
               (when (< cursor-position (string-length text-value))
                 (set! text-value (string-append (substring text-value 0 cursor-position)
                                                (substring text-value (add1 cursor-position))))
                 (set! cursor-position cursor-position)
                 (set! selection-start cursor-position)
                 (set! selection-end cursor-position)
                 (on-callback this #f)
                 (send this refresh-now)))]
          
          ;; Handle left arrow
          [(eq? key-code 'left)
           (if (< selection-start selection-end)
               ;; If text is selected, move cursor to selection start
               (begin
                 (set! cursor-position selection-start)
                 (set! selection-end cursor-position)
                 (send this refresh-now))
               ;; Otherwise move cursor left
               (when (> cursor-position 0)
                 (set! cursor-position (sub1 cursor-position))
                 (set! selection-start cursor-position)
                 (set! selection-end cursor-position)
                 (send this refresh-now)))]
          
          ;; Handle right arrow
          [(eq? key-code 'right)
           (if (< selection-start selection-end)
               ;; If text is selected, move cursor to selection end
               (begin
                 (set! cursor-position selection-end)
                 (set! selection-start cursor-position)
                 (send this refresh-now))
               ;; Otherwise move cursor right
               (when (< cursor-position (string-length text-value))
                 (set! cursor-position (add1 cursor-position))
                 (set! selection-start cursor-position)
                 (set! selection-end cursor-position)
                 (send this refresh-now)))]
          
          ;; Handle home
          [(eq? key-code 'home)
           (set! cursor-position 0)
           (set! selection-start cursor-position)
           (set! selection-end cursor-position)
           (send this refresh-now)]
          
          ;; Handle end
          [(eq? key-code 'end)
           (set! cursor-position (string-length text-value))
           (set! selection-start cursor-position)
           (set! selection-end cursor-position)
           (send this refresh-now)]
          
          ;; Handle enter key for search and clear
          [(eq? key-code 'return)
           (on-callback this #f)
           ;; Clear the input field after search
           (set! text-value "")
           (set! cursor-position 0)
           (set! selection-start 0)
           (set! selection-end 0)
           (send this refresh-now)]
          [(eq? key-code 'kp-enter)
           (on-callback this #f)
           ;; Clear the input field after search
           (set! text-value "")
           (set! cursor-position 0)
           (set! selection-start 0)
           (set! selection-end 0)
           (send this refresh-now)])))
    
    ;; Handle keyboard events for text input
    (define/override (handle-keyboard-event event)
      (when (or is-focused? (send this has-focus?))
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
           (send this refresh-now)]
          
          [_ ;; Ignore other event types
           (void)])))
    
    ;; Focus event handlers
    (define/override (on-focus event)
      (super on-focus event)
      (set! is-focused? #t)
      (send this refresh-now))
    
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
      
      ;; Draw background with focus feedback
      (define background-color (theme-color 'surface-light))
      (define border-color (if (or is-focused? (send this has-focus?)) 
                               (theme-color 'accent) 
                               (theme-color 'border)))
      
      (send dc set-brush (make-brush #:color background-color))
      (send dc set-pen (make-pen #:color border-color #:width 1.5))
      (send dc draw-rectangle 0 0 width height)
      
      ;; Draw search icon (magnifying glass) - improved flat design
      (define icon-x 16)
      (define icon-y 12)
      (define icon-size 16)
      
      ;; Draw magnifying glass circle
      (send dc set-pen (make-pen #:color (theme-color 'text-light) #:width 1.5))
      (send dc set-brush (make-brush #:style 'transparent))
      (send dc draw-ellipse (- icon-x (/ icon-size 2) 2) (- icon-y (/ icon-size 2) 2) (+ icon-size 4) (+ icon-size 4))
      
      ;; Draw magnifying glass handle - more complete design
      (send dc draw-line (+ icon-x 3) (+ icon-y 6) (+ icon-x 8) (+ icon-y 11))
      (send dc draw-line (+ icon-x 8) (+ icon-y 11) (+ icon-x 11) (+ icon-y 8))
      
      ;; Draw text input area
      (define text-x 40)
      (define text-y 10)
      (define text-width (- width text-x 16))
      
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
        (define cursor-text (substring text-value 0 cursor-position))
        (define-values (cursor-width cursor-height cursor-descent cursor-ascent) 
          (send dc get-text-extent cursor-text))
        (define cursor-x (+ text-x cursor-width))
        (define cursor-y text-y)
        
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
