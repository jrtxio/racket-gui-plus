#lang racket/gui

;; Text area component
;; Modern multi-line text input with customizable styles

(require "../style/config.rkt")

(define text-area%
  (class canvas%
    (init-field [placeholder ""] [callback (λ (t) (void))] [init-value ""] [style '()])
    
    ;; Set initial text
    (define showing-placeholder? (string=? init-value ""))
    (define current-text init-value)
    
    ;; Cursor related state
    (define cursor-pos (string-length current-text))
    (define cursor-visible? #t)
    (define cursor-blink-timer #f)
    
    (super-new [style style]
               [min-height 100]
               [min-width 200])
    
    ;; Register widget to global list for theme switch refresh
    (register-widget this)
    
    ;; Set as stretchable
    (send this stretchable-width #t)
    (send this stretchable-height #t)
    
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
      
      ;; Draw background
      (send dc set-brush (color-bg-white) 'solid)
      (send dc set-pen (color-bg-white) 1 'transparent)
      (send dc draw-rectangle 0 0 w h)
      
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
            (send dc draw-text placeholder 12 12))
          (begin
            (send dc set-text-foreground (color-text-main))
            (send dc draw-text current-text 12 12)
            ;; Draw cursor
            (when (and has-focus? cursor-visible?)
              (let-values ([(_ th _1 _2) (send dc get-text-extent "")])
                (define lines (string-split current-text "\n" #:trim? #f))
                (define current-line 0)
                (define current-col 0)
                (define remaining-pos cursor-pos)
                
                ;; Calculate cursor row and column
                (let loop ([lines-left lines] [pos remaining-pos])
                  (when (and (not (null? lines-left)) (> pos 0))
                    (define line-length (string-length (car lines-left)))
                    (if (<= pos line-length)
                        (begin
                          (set! current-col pos)
                          (set! remaining-pos 0))
                        (begin
                          (set! current-line (add1 current-line))
                          (loop (cdr lines-left) (- pos (add1 line-length)))
                          (set! remaining-pos (- pos (add1 line-length)))))))
                
                ;; Calculate cursor x-coordinate
                (define line-to-cursor (if (< current-line (length lines))
                                          (car (drop lines current-line))
                                          ""))
                (define cursor-x (+ 12 (let-values ([(cw _1 _2 _3) (send dc get-text-extent (substring line-to-cursor 0 current-col))]) cw) 1))
                (define cursor-y (+ 12 (* (add1 current-line) th) 2))
                
                (send dc set-pen (color-text-main) 2 'solid)
                (send dc draw-line cursor-x cursor-y cursor-x (+ cursor-y th)))))))
    
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
        ;; Normal character - add at cursor position
        [(char? key)
         (set! current-text (string-append (substring current-text 0 cursor-pos)
                                          (string key)
                                          (substring current-text cursor-pos)))
         (set! cursor-pos (+ cursor-pos 1))
         (set! showing-placeholder? #f)
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
        ;; Enter key - insert newline at cursor
        [(equal? key #\return)
         (set! current-text (string-append (substring current-text 0 cursor-pos)
                                          "\n"
                                          (substring current-text cursor-pos)))
         (set! cursor-pos (+ cursor-pos 1))
         (set! showing-placeholder? #f)
         (send this refresh)]
        ;; Tab key - insert tab character
        [(equal? key 'tab)
         (set! current-text (string-append (substring current-text 0 cursor-pos)
                                          "\t"
                                          (substring current-text cursor-pos)))
         (set! cursor-pos (+ cursor-pos 1))
         (set! showing-placeholder? #f)
         (send this refresh)]
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
        ;; Up arrow key - move cursor up (simplified implementation)
        [(equal? key 'up)
         (define lines (string-split current-text "\n" #:trim? #f))
         (define current-line 0)
         (define remaining-pos cursor-pos)
         
         ;; Calculate current line
         (let loop ([lines-left lines] [pos remaining-pos])
           (when (and (not (null? lines-left)) (> pos 0))
             (define line-length (string-length (car lines-left)))
             (if (<= pos line-length)
                 (set! remaining-pos 0)
                 (begin
                   (set! current-line (add1 current-line))
                   (loop (cdr lines-left) (- pos (add1 line-length)))))))
         
         (when (> current-line 0)
           ;; Calculate previous line length
           (define prev-line-length (string-length (list-ref lines (- current-line 1))))
           ;; Move to previous line, maintain column position (not exceeding line length)
           (set! cursor-pos (- cursor-pos (string-length (list-ref lines current-line)) 1))
           (set! cursor-pos (max 0 (min cursor-pos prev-line-length)))
           (send this refresh))]
        ;; Down arrow key - move cursor down (simplified implementation)
        [(equal? key 'down)
         (define lines (string-split current-text "\n" #:trim? #f))
         (define current-line 0)
         (define remaining-pos cursor-pos)
         
         ;; Calculate current line
         (let loop ([lines-left lines] [pos remaining-pos])
           (when (and (not (null? lines-left)) (> pos 0))
             (define line-length (string-length (car lines-left)))
             (if (<= pos line-length)
                 (set! remaining-pos 0)
                 (begin
                   (set! current-line (add1 current-line))
                   (loop (cdr lines-left) (- pos (add1 line-length)))))))
         
         (when (< current-line (- (length lines) 1))
           ;; Calculate next line length
           (define next-line-length (string-length (list-ref lines (+ current-line 1))))
           ;; Move to next line, maintain column position (not exceeding line length)
           (set! cursor-pos (+ cursor-pos (string-length (list-ref lines current-line)) 1))
           (set! cursor-pos (min cursor-pos (+ (string-length current-text) next-line-length)))
           (send this refresh))]
        ;; Home key - move cursor to start of line
        [(equal? key 'home)
         (define lines (string-split current-text "\n" #:trim? #f))
         (define current-line 0)
         (define remaining-pos cursor-pos)
         
         ;; Calculate current line
         (let loop ([lines-left lines] [pos remaining-pos])
           (when (and (not (null? lines-left)) (> pos 0))
             (define line-length (string-length (car lines-left)))
             (if (<= pos line-length)
                 (set! remaining-pos 0)
                 (begin
                   (set! current-line (add1 current-line))
                   (loop (cdr lines-left) (- pos (add1 line-length)))))))
         
         ;; Calculate start of line position
         (define start-of-line 0)
         (for ([i (in-range current-line)])
           (set! start-of-line (+ start-of-line (string-length (list-ref lines i)) 1)))
         (set! cursor-pos start-of-line)
         (send this refresh)]
        ;; End key - move cursor to end of line
        [(equal? key 'end)
         (define lines (string-split current-text "\n" #:trim? #f))
         (define current-line 0)
         (define remaining-pos cursor-pos)
         
         ;; Calculate current line
         (let loop ([lines-left lines] [pos remaining-pos])
           (when (and (not (null? lines-left)) (> pos 0))
             (define line-length (string-length (car lines-left)))
             (if (<= pos line-length)
                 (set! remaining-pos 0)
                 (begin
                   (set! current-line (add1 current-line))
                   (loop (cdr lines-left) (- pos (add1 line-length)))))))
         
         ;; Calculate end of line position
         (define end-of-line 0)
         (for ([i (in-range (add1 current-line))])
           (set! end-of-line (+ end-of-line (string-length (list-ref lines i)) 1)))
         (set! cursor-pos (- end-of-line 1))
         (send this refresh)]
        [else
         (void)]))
    
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
(provide text-area%)
