#lang racket/gui

;; Editable Text Component
;; A simple text component that can be clicked to enter edit mode
(require racket/class
         racket/draw
         "../style/config.rkt")

(provide editable-text%)

(define editable-text%
  (class canvas%
    (init-field [parent #f]
                [placeholder ""]
                [callback (λ (t) (void))]
                [init-value ""]
                [style '()])
    
    (super-new [parent parent]
               [style style]
               [min-height (input-height)]
               [min-width 200])
    
    ;; State variables
    (define current-text init-value)
    (define is-editing? #f)
    (define has-focus? #f)
    ;; Cursor related state
    (define cursor-pos (string-length current-text))
    (define cursor-visible? #t)
    (define cursor-blink-timer #f)
    
    ;; Register for theme changes
    (register-widget this)
    
    ;; Set stretchable width
    (send this stretchable-width #t)
    
    ;; Drawing method
    (define/override (on-paint)
      (define dc (send this get-dc))
      (define-values (w h) (send this get-client-size))
      
      ;; Draw background
      (send dc set-brush (color-bg-light) 'solid)
      (send dc set-pen (color-bg-light) 1 'transparent)
      (send dc draw-rectangle 0 0 w h)
      
      ;; Draw text
      (send dc set-font (font-regular))
      
      (if (and (string=? current-text "") (not is-editing?))
          ;; Show placeholder
          (begin
            (send dc set-text-foreground (color-text-placeholder))
            (send dc draw-text placeholder 12 12))
          ;; Show current text
          (begin
            (send dc set-text-foreground (color-text-main))
            (send dc draw-text current-text 12 12)
            ;; Draw cursor if editing
            (when (and is-editing? has-focus? cursor-visible?)
              (let-values ([(text-width _ _ _) (send dc get-text-extent (substring current-text 0 cursor-pos))])
                (send dc set-pen (color-text-main) 2 'solid)
                (send dc draw-line 
                      (+ 12 text-width) 5 
                      (+ 12 text-width) (- h 5))))))
    
    ;; Handle mouse events
    (define/override (on-event event)
      (when (send event button-down?)
        ;; Click to enter edit mode
        (set! is-editing? #t)
        (set! has-focus? #t)
        (send this focus)
        (send this refresh)))
    
    ;; Handle keyboard events
    (define/override (on-char event)
      (define key (send event get-key-code))
      
      (cond
        ;; Enter key - save and exit edit mode
        [(equal? key #\return)
         (set! is-editing? #f)
         (set! has-focus? #f)
         (callback this)
         (send this refresh)]
        
        ;; Backspace key - delete character before cursor
        [(equal? key 'back)
         (when (and is-editing? (not (string=? current-text "")) (> cursor-pos 0))
           (set! current-text (string-append (substring current-text 0 (- cursor-pos 1))
                                            (substring current-text cursor-pos)))
           (set! cursor-pos (- cursor-pos 1))
           (send this refresh))]
        
        ;; Delete key - delete character after cursor
        [(equal? key 'delete)
         (when (and is-editing? (not (string=? current-text "")) (< cursor-pos (string-length current-text)))
           (set! current-text (string-append (substring current-text 0 cursor-pos)
                                            (substring current-text (+ cursor-pos 1))))
           ;; Keep cursor position within valid range
           (set! cursor-pos (min cursor-pos (string-length current-text)))
           (send this refresh))]
        
        ;; Left arrow - move cursor left
        [(equal? key 'left)
         (when (and is-editing? (> cursor-pos 0))
           (set! cursor-pos (- cursor-pos 1))
           (send this refresh))]
        
        ;; Right arrow - move cursor right
        [(equal? key 'right)
         (when (and is-editing? (< cursor-pos (string-length current-text)))
           (set! cursor-pos (+ cursor-pos 1))
           (send this refresh))]
        
        ;; Normal character - insert at cursor position
        [(char? key)
         (when is-editing?
           (set! current-text (string-append (substring current-text 0 cursor-pos)
                                            (string key)
                                            (substring current-text cursor-pos)))
           (set! cursor-pos (+ cursor-pos 1))
           (send this refresh))]))
    
    ;; Handle focus changes
    (define/override (on-focus on?)
      (set! has-focus? on?)
      (when (and (not on?) is-editing?)
        ;; Lost focus, save and exit edit mode
        (set! is-editing? #f)
        (callback this)
        ;; Stop cursor blink timer
        (when cursor-blink-timer
          (send cursor-blink-timer stop)
          (set! cursor-blink-timer #f)))
      (when on?
        ;; Gain focus, start cursor blink timer
        (set! cursor-visible? #t)
        (set! cursor-blink-timer (new timer% 
                                     [interval 500] 
                                     [notify-callback (lambda ()
                                                        (set! cursor-visible? (not cursor-visible?))
                                                        (send this refresh))])))
      (send this refresh))
    
    ;; Public methods
    (define/public (get-text)
      current-text)
    
    (define/public (set-text str)
      (set! current-text str)
      (send this refresh))
    )
