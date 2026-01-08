#lang racket/gui

(require "../style/config.rkt")

(define text-field%
  (class canvas%
    (init-field [placeholder ""] [callback (λ (t) (void))] [init-value ""] [style '()])
    
    ;; Filter out styles not supported by canvas%
    (define filtered-style (filter (λ (s) (not (member s '(single multiple)))) style))
    
    (super-new [style filtered-style]
               [min-height (input-height)]
               [min-width 200])
    
    ;; Set initial text
    (define showing-placeholder? (string=? init-value ""))
    (define current-text init-value)
    
    ;; Cursor related state
    (define cursor-pos (string-length current-text))
    (define cursor-visible? #t)
    (define cursor-blink-timer #f)
    
    ;; Register widget to global list for theme switch refresh
    (register-widget this)
    
    ;; Set as stretchable
    (send this stretchable-width #t)
    
    ;; Listen for text changes to hide placeholder
    (define has-focus? #f)
    
    ;; Drawing method
    (define/override (on-paint)
      (define dc (send this get-dc))
      (define-values (w h) (send this get-client-size))
      
      (send dc set-smoothing 'smoothed)
      
      ;; Calculate border width
      (define border-width (if has-focus? 2 1))
      (define half-border (/ border-width 2.0))
      
      ;; First draw parent background to cover entire area
      (send dc set-brush (color-bg-light) 'solid)
      (send dc set-pen (color-bg-light) 1 'transparent)
      (send dc draw-rectangle 0 0 w h)
      
      ;; Draw white rounded background
      (send dc set-brush (color-bg-white) 'solid)
      (send dc set-pen "white" 0 'transparent)
      (send dc draw-rounded-rectangle 
            border-width border-width 
            (- w (* 2 border-width)) (- h (* 2 border-width))
            (- (border-radius-medium) 1))
      
      ;; Draw rounded border
      (send dc set-brush "white" 'transparent)
      (if has-focus?
          (send dc set-pen (color-border-focus) border-width 'solid)
          (send dc set-pen (color-border) border-width 'solid))
      (send dc draw-rounded-rectangle 
            half-border half-border 
            (- w border-width) (- h border-width)
            (border-radius-medium))
      
      ;; Draw text or placeholder
      (send dc set-font (font-regular))
      (if (and showing-placeholder? (not has-focus?))
          (begin
            (send dc set-text-foreground (color-text-placeholder))
            (let-values ([(_ th _1 _2) (send dc get-text-extent placeholder)])
              (send dc draw-text placeholder 12 (/ (- h th) 2))))
          (begin
            (send dc set-text-foreground (color-text-main))
            (let-values ([(_ th _1 _2) (send dc get-text-extent current-text)])
              (send dc draw-text current-text 12 (/ (- h th) 2))
              ;; Draw cursor
              (when (and has-focus? cursor-visible?)
                (let-values ([(cw _1 _2 _3) (send dc get-text-extent (substring current-text 0 cursor-pos))])
                  (define cursor-x (+ 12 cw 1))
                  (define cursor-y (/ (- h th) 2))
                  (send dc set-pen (color-text-main) 2 'solid)
                  (send dc draw-line cursor-x cursor-y cursor-x (+ cursor-y th))))))))
    
    ;; Handle mouse click - gain focus
    (define/override (on-event event)
      (when (send event button-down?)
        (send this focus)
        (set! has-focus? #t)
        (send this refresh)))
    
    ;; Handle keyboard input
    (define/override (on-char event)
      (define key (send event get-key-code))
      (cond
        ;; Enter key - submit
        [(equal? key #\return)
         (unless (string=? (string-trim current-text) "")
           (callback this))
         (set! current-text "")
         (set! cursor-pos 0)
         (set! showing-placeholder? #t)
         (send this refresh)]
        ;; Backspace key - delete character before cursor
        [(equal? key 'back)
         (unless (string=? current-text "")
           (when (> cursor-pos 0)
             (set! current-text (string-append (substring current-text 0 (- cursor-pos 1))
                                              (substring current-text cursor-pos)))
             (set! cursor-pos (- cursor-pos 1))
             (set! showing-placeholder? (string=? current-text ""))
             (send this refresh)))]
        ;; Delete key - delete character after cursor
        [(equal? key 'delete)
         (unless (string=? current-text "")
           (when (< cursor-pos (string-length current-text))
             (set! current-text (string-append (substring current-text 0 cursor-pos)
                                              (substring current-text (+ cursor-pos 1))))
             ;; Keep cursor position within valid range
             (set! cursor-pos (min cursor-pos (string-length current-text)))
             (set! showing-placeholder? (string=? current-text ""))
             (send this refresh)))]
        ;; Left arrow key - move cursor left
        [(equal? key 'left)
         (when (> cursor-pos 0)
           (set! cursor-pos (- cursor-pos 1))
           (send this refresh))]
        ;; Right arrow key - move cursor right
        [(equal? key 'right)
         (when (< cursor-pos (string-length current-text))
           (set! cursor-pos (+ cursor-pos 1))
           (send this refresh))]
        ;; Home key - move cursor to beginning
        [(equal? key 'home)
         (set! cursor-pos 0)
         (send this refresh)]
        ;; End key - move cursor to end
        [(equal? key 'end)
         (set! cursor-pos (string-length current-text))
         (send this refresh)]
        ;; Normal character - add at cursor position
        [(char? key)
         (set! current-text (string-append (substring current-text 0 cursor-pos)
                                          (string key)
                                          (substring current-text cursor-pos)))
         (set! cursor-pos (+ cursor-pos 1))
         (set! showing-placeholder? #f)
         (send this refresh)]))
    
    ;; Handle focus change
    (define/override (on-focus on?)
      (set! has-focus? on?)
      (if on?
          (begin
            ;; When gaining focus, show cursor and start blink timer
            (set! cursor-visible? #t)
            (set! cursor-blink-timer (new timer% 
                                         [interval 500] 
                                         [notify-callback (lambda ()
                                                            (set! cursor-visible? (not cursor-visible?))
                                                            (send this refresh))])))
          (begin
            ;; When losing focus, hide cursor and stop timer
            (set! cursor-visible? #f)
            (when cursor-blink-timer
              (send cursor-blink-timer stop)
              (set! cursor-blink-timer #f))))
      (send this refresh))
    
    ;; Public methods
    (define/public (get-text)
      current-text)
    
    (define/public (set-text str)
      (set! current-text str)
      (set! cursor-pos (string-length str))
      (set! showing-placeholder? (string=? str ""))
      (send this refresh))
    
    (define/public (clear)
      (set! current-text "")
      (set! cursor-pos 0)
      (set! showing-placeholder? #t)
      (send this refresh))
    
    ))

;; Export widget class
(provide text-field%
         guix-text-field%
         (rename-out [text-field% modern-input%]))

;; New guix-text-field% with updated naming convention
(define guix-text-field% text-field%)
