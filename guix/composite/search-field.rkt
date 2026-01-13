#lang racket/gui

;; guix-search-field% - Enhanced search input field with clear button
;; Single canvas implementation for consistent cross-platform behavior
;; 
;; Usage:
;; (new guix-search-field%
;;      [parent frame]
;;      [placeholder "Search..."]
;;      [on-callback (λ (sf event) (displayln (send sf get-text)))]
;;      [init-value "Initial search"])

(require racket/class
         racket/gui/base
         racket/match
         "../core/composite-control.rkt"
         "../style/config.rkt")

;; ===========================
;; Search Field - Single Canvas Implementation
;; ===========================
(define search-field%
  (class guix-composite-control%
    (init-field [placeholder "Search..."]
                [on-callback (λ (sf event) (void))]
                [init-value ""]
                [style '()])
    
    (field [text-value init-value]
           [cursor-position (string-length init-value)]
           [selection-start 0]
           [selection-end (string-length init-value)]
           [is-focused #f])
    
    (define/override (get-regions) '(search-input clear-button))
    
    (define/override (hit-test x y)
      (match-define (cons width height) (get-size))
      (define clear-button-x (- width 36))
      (if (and (> x clear-button-x) (< x width) (> y 0) (< y height))
          'clear-button
          'search-input))
    
    (define/override (get-region-bounds region)
      (match-define (cons width height) (get-size))
      
      (match region
        ['search-input
         (list 0 0 (- width 36) height)]
        ['clear-button
         (list (- width 36) 0 width height)]
        [_ #f]))
    
    (define/override (on-region-hover-enter region)
      (send this refresh-now))
    
    (define/override (on-region-hover-exit region)
      (send this refresh-now))
    
    (define/override (on-region-click region event)
      (match region
        ['search-input
         (set! is-focused #t)
         (send this set-focused-region 'search-input)
         (send this focus)
         (send this refresh-now)]
        ['clear-button
         (set! text-value "")
         (set! cursor-position 0)
         (set! selection-start 0)
         (set! selection-end 0)
         (on-callback this #f)
         (send this refresh-now)]))
    
    (define/override (on-region-release region event)
      (void))
    
    (define/override (on-char event)
      (when (or is-focused (send this has-focus?))
        (define key-code (send event get-key-code))
        (define control-down? (send event get-control-down))
        
        (cond
          [(and control-down? (eq? key-code #\a))
           (set! selection-start 0)
           (set! selection-end (string-length text-value))
           (send this refresh-now)]
          
          [(eq? key-code 'escape)
           (set! text-value "")
           (set! cursor-position 0)
           (set! selection-start 0)
           (set! selection-end 0)
           (on-callback this #f)
           (send this refresh-now)]
          
          [(and (char? key-code)
            (not (eq? key-code #\backspace)))
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
           (send this refresh-now)]
          
          [(eq? key-code #\backspace)
           (if (< selection-start selection-end)
               (begin
                 (set! text-value (string-append (substring text-value 0 selection-start)
                                                (substring text-value selection-end)))
                 (set! cursor-position selection-start)
                 (set! selection-start cursor-position)
                 (set! selection-end cursor-position)
                 (send this refresh-now))
               (when (> cursor-position 0)
                 (set! text-value (string-append (substring text-value 0 (sub1 cursor-position))
                                                (substring text-value cursor-position)))
                 (set! cursor-position (sub1 cursor-position))
                 (set! selection-start cursor-position)
                 (set! selection-end cursor-position)
                 (send this refresh-now)))
           ]
          
          [(eq? key-code 'delete)
           (if (< selection-start selection-end)
               (begin
                 (set! text-value (string-append (substring text-value 0 selection-start)
                                                (substring text-value selection-end)))
                 (set! cursor-position selection-start)
                 (set! selection-start cursor-position)
                 (set! selection-end cursor-position)
                 (send this refresh-now))
               (when (< cursor-position (string-length text-value))
                 (set! text-value (string-append (substring text-value 0 cursor-position)
                                                (substring text-value (add1 cursor-position))))
                 (set! cursor-position cursor-position)
                 (set! selection-start cursor-position)
                 (set! selection-end cursor-position)
                 (send this refresh-now)))
           ]
          
          [(eq? key-code 'left)
           (if (< selection-start selection-end)
               (begin
                 (set! cursor-position selection-start)
                 (set! selection-end cursor-position)
                 (send this refresh-now))
               (when (> cursor-position 0)
                 (set! cursor-position (sub1 cursor-position))
                 (set! selection-start cursor-position)
                 (set! selection-end cursor-position)
                 (send this refresh-now)))
           ]
          
          [(eq? key-code 'right)
           (if (< selection-start selection-end)
               (begin
                 (set! cursor-position selection-end)
                 (set! selection-start cursor-position)
                 (set! selection-end cursor-position)
                 (send this refresh-now))
               (when (< cursor-position (string-length text-value))
                 (set! cursor-position (add1 cursor-position))
                 (set! selection-start cursor-position)
                 (set! selection-end cursor-position)
                 (send this refresh-now)))
           ]
          
          [(eq? key-code 'home)
           (set! cursor-position 0)
           (set! selection-start cursor-position)
           (set! selection-end cursor-position)
           (send this refresh-now)]
          
          [(eq? key-code 'end)
           (set! cursor-position (string-length text-value))
           (set! selection-start cursor-position)
           (set! selection-end cursor-position)
           (send this refresh-now)]
          
          [(eq? key-code 'return)
           (on-callback this #f)
           (send this refresh-now)]
          [(eq? key-code 'kp-enter)
           (on-callback this #f)
           (send this refresh-now)])))
    
    (define/override (on-focus event)
      (super on-focus event)
      (set! is-focused #t)
      (send this refresh-now))
    
    (define/public (set-focused f)
      (set! is-focused f)
      (send this refresh-now))
    
    (define/public (is-focused?)
      is-focused)
    
    (define/override (render-control dc state theme)
      (match-define (cons width height) (get-size))
      
      (define background-color (color-surface-light))
      (define border-color (if (or is-focused (send this has-focus?)) 
                               (color-accent) 
                               (color-border)))
      
      (send dc set-brush (make-brush #:color background-color))
      (send dc set-pen (make-pen #:color border-color #:width 1.5))
      (send dc draw-rectangle 0 0 width height)
      
      (define icon-x 16)
      (define icon-y 12)
      (define icon-size 16)
      
      (send dc set-pen (make-pen #:color (color-text-light) #:width 1.5))
      (send dc set-brush (make-brush #:style 'transparent))
      (send dc draw-ellipse (- icon-x (/ icon-size 2) 2) (- icon-y (/ icon-size 2) 2) (+ icon-size 4) (+ icon-size 4))
      (send dc draw-line (+ icon-x 3) (+ icon-y 6) (+ icon-x 8) (+ icon-y 11))
      (send dc draw-line (+ icon-x 8) (+ icon-y 11) (+ icon-x 11) (+ icon-y 8))
      
      (define text-x 40)
      (define text-y 10)
      (define text-width (- width text-x 40))
      
      (send dc set-font (font-regular))
      
      (cond
        [(non-empty-string? text-value)
         (send dc set-text-foreground (color-text-main))
         (send dc draw-text text-value text-x text-y)]
        [else
         (send dc set-text-foreground (color-text-placeholder))
         (send dc draw-text placeholder text-x text-y)])
      
      (when (non-empty-string? text-value)
        (define clear-button-x (- width 30))
        (define clear-button-y 10)
        (define clear-button-size 16)
        
        (send dc set-pen (make-pen #:color (color-text-light) #:width 1))
        (send dc set-brush (make-brush #:style 'transparent))
        (send dc draw-ellipse (- clear-button-x (/ clear-button-size 2)) 
                              (- clear-button-y (/ clear-button-size 2)) 
                              clear-button-size 
                              clear-button-size)
        (send dc draw-line (- clear-button-x 5) (- clear-button-y 5) (+ clear-button-x 5) (+ clear-button-y 5))
        (send dc draw-line (+ clear-button-x 5) (- clear-button-y 5) (- clear-button-x 5) (+ clear-button-y 5)))
      
      (when (and is-focused (send this has-focus?))
        (define cursor-text (substring text-value 0 cursor-position))
        (define-values (cursor-width cursor-height cursor-descent cursor-ascent) 
          (send dc get-text-extent cursor-text))
        (define cursor-x (+ text-x cursor-width))
        (define cursor-y text-y)
        
        (send dc set-pen (make-pen #:color (color-text-main) #:width 1))
        (send dc draw-line cursor-x cursor-y cursor-x (+ cursor-y cursor-height)))
    )
    
    (define/public (get-text)
      text-value)
    
    (define/public (set-text str)
      (set! text-value str)
      (set! cursor-position (string-length str))
      (set! selection-start 0)
      (set! selection-end (string-length str))
      (send this refresh-now))
    
    (define/public (clear)
      (set-text ""))
    
    (define/public (callback self event)
      (on-callback self event))
    
    (define (get-size)
      (cons (send this get-width) (send this get-height)))
    
    (super-new [min-width 240]
               [min-height (input-height)])
    )
  )

;; Alias for backward compatibility
(define guix-search-field% search-field%)

(provide search-field%
         guix-search-field%)
