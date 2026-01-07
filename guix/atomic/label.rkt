#lang racket/gui

;; Label component
;; Modern label with customizable text styles

(require racket/class
         racket/draw
         "../style/config.rkt")

(provide label%)

(define label%
  (class canvas%
    (inherit get-client-size get-parent)
    
    ;;; Initialization parameters
    (init parent
          [label ""]
          [font-size 'regular]
          [font-weight 'normal]
          [theme-aware? #t]
          [enabled? #t]
          [color #f])
    
    ;;; Instance variables
    (define current-parent parent)
    (define current-label label)
    (define current-font-size font-size)
    (define current-font-weight font-weight)
    (define custom-color color)
    (define enabled-state enabled?)
    (define theme-aware theme-aware?)
    
    ;;; Constructor
    (super-new 
     [parent parent]
     [paint-callback (λ (canvas dc) (on-paint dc))]
     [style '(transparent no-focus)]
     [min-width 100]
     [min-height 24])
    
    ;;; Theme management
    (when theme-aware
      (register-widget this))
    
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
          (if enabled-state
              (color-text-main)
              (if (equal? (current-theme) light-theme)
                  (make-object color% 170 170 170)
                  (make-object color% 80 80 85)))))
    
    ;;; Drawing method
    (define (on-paint dc)
      (let-values ([(width height) (get-client-size)])
        (let* ([text-color (get-text-color)]
               [font (get-font)]
               [y (- (/ height 2) 7)])
          
          ; Draw text
          (send dc set-text-foreground text-color)
          (send dc set-font font)
          (send dc draw-text current-label 0 y))))
    
    ;;; Refresh method - respond to theme changes
    (define/override (refresh)
      (super refresh))
    
    ;;; Set label text
    (define/public (set-label-text! new-label)
      (set! current-label new-label)
      (send this refresh))
    
    ;;; Get label text
    (define/public (get-label-text)
      current-label)
    
    ;;; Set font size
    (define/public (set-font-size! new-size)
      (set! current-font-size new-size)
      (send this refresh))
    
    ;;; Get font size
    (define/public (get-font-size)
      current-font-size)
    
    ;;; Set font weight
    (define/public (set-font-weight! new-weight)
      (set! current-font-weight new-weight)
      (send this refresh))
    
    ;;; Get font weight
    (define/public (get-font-weight)
      current-font-weight)
    
    ;;; Set custom color
    (define/public (set-color! new-color)
      (set! custom-color new-color)
      (send this refresh))
    
    ;;; Get custom color
    (define/public (get-color)
      custom-color)
    
    ;;; Set enabled state
    (define/public (set-enabled! [on? #t])
      (set! enabled-state on?)
      (send this refresh))
    
    ;;; Check if enabled
    (define/public (get-enabled-state)
      enabled-state)
    
    this)
  )
