#lang racket/gui

;; Label component
;; Modern label with customizable text styles

(require racket/class
         racket/draw
         "../core/base-control.rkt"
         "../style/config.rkt")

(provide label%
         guix-label%)

(define label%
  (class guix-base-control%
    (inherit get-client-size get-parent invalidate)
    
    ;;; Initialization parameters
    (init parent
          [label ""]
          [font-size 'regular]
          [font-weight 'normal]
          [theme-aware? #t] ; Deprecated, kept for compatibility
          [enabled? #t]
          [color #f])
    
    ;;; Instance variables
    (define current-label label)
    (define current-font-size font-size)
    (define current-font-weight font-weight)
    (define custom-color color)
    
    ;;; Constructor
    (super-new 
     [parent parent]
     [enabled? enabled?])
    
    ;;; Set minimum size
    (send this min-width 100)
    (send this min-height 24)
    
    ;;; Theme management is handled by base-control
    
    ;;; Get font based on size and weight
    (define (get-font)
      (case (list current-font-size current-font-weight)
        [('small 'normal) (font-small)]
        [('small 'bold) (send the-font-list find-or-create-font 10 'default 'normal 'bold)]
        [('regular 'normal) (font-regular)]
        [('regular 'bold) (send the-font-list find-or-create-font 13 'default 'normal 'bold)]
        [('medium 'normal) (font-medium)]
        [('medium 'bold) (send the-font-list find-or-create-font 14 'default 'normal 'bold)]
        [('large 'normal) (font-large)]
        [('large 'bold) (send the-font-list find-or-create-font 16 'default 'normal 'bold)]
        [else (font-regular)]))
    
    ;;; Get text color based on state and custom color
    (define (get-text-color)
      (if custom-color
          custom-color
          (if (send this get-enabled)
              (color-text-main)
              (color-text-disabled))))
    
    ;;; Drawing method
    (define/override (draw dc)
      (let-values ([(width height) (get-client-size)])
        (let* ([text-color (get-text-color)]
               [font (get-font)]
               [y (- (/ height 2) 7)])
          
          ; Draw text
          (send dc set-text-foreground text-color)
          (send dc set-font font)
          (send dc draw-text current-label 0 y))))
    
    ;;; Set label text
    (define/public (set-label-text! new-label)
      (set! current-label new-label)
      (invalidate))
    
    ;;; Get label text
    (define/public (get-label-text)
      current-label)
    
    ;;; Set font size
    (define/public (set-font-size! new-size)
      (set! current-font-size new-size)
      (invalidate))
    
    ;;; Get font size
    (define/public (get-font-size)
      current-font-size)
    
    ;;; Set font weight
    (define/public (set-font-weight! new-weight)
      (set! current-font-weight new-weight)
      (invalidate))
    
    ;;; Get font weight
    (define/public (get-font-weight)
      current-font-weight)
    
    ;;; Set custom color
    (define/public (set-color! new-color)
      (set! custom-color new-color)
      (invalidate))
    
    ;;; Get custom color
    (define/public (get-color)
      custom-color)
    
    ;;; Backward compatibility methods
    (define/public (set-enabled! [on? #t])
      (send this set-enabled on?))
    
    (define/public (get-enabled-state)
      (send this get-enabled))
    
    this)
  )

;; New guix-label% with updated naming convention
(define guix-label% label%)
