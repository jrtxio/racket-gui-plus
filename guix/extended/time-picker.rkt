#lang racket/gui
(require racket/class racket/draw)

;; Time picker component
;; Modern time input with hour and minute selection

(provide time-picker%
         guix-time-picker%)

(define time-picker%
  (class canvas%
    (init-field [parent #f]
                [label ""]
                [style '()]
                [hour 22]
                [minute 0]
                [on-change void])
    
    ;; Initialize parameters: set minimum size and disable default focus border
    (super-new [parent parent]
               [style (append style '(no-focus))]
               [label label]
               [min-width 70]
               [min-height 22])

    (define selected 'hour)  ; Currently selected part: 'hour or 'minute
    (define has-focus? #f)   ; Whether the control has focus
    (define callbacks '())   ; List of callback functions
    
    ;; Add default callback
    (when on-change
      (set! callbacks (cons on-change callbacks)))

    ;; Layout constants
    (define WIDTH 70)
    (define HEIGHT 22)
    (define STEPPER-W 16) ; Width of the right arrow area

    ;; Color scheme (consistent with other controls in the library)
    (define color-accent (make-object color% 0 122 255))      ; Apple blue
    (define color-text-main (make-object color% 40 40 40))     ; Dark gray text
    
    ;; Internal private method: adjust value and refresh interface
    (define/private (adjust-val delta)
      (if (eq? selected 'hour)
          (set! hour (modulo (+ hour delta) 24))
          (set! minute (modulo (+ minute delta) 60)))
      ;; Execute all registered callbacks
      (for ([cb callbacks]) (cb hour minute))
      (send this refresh))

    ;; Handle mouse clicks and scrolling
    (define/override (on-event event)
      (define x (send event get-x))
      (define y (send event get-y))
      (define type (send event get-event-type))

      (cond 
        [(eq? type 'left-down)
         (send this focus)
         (cond 
           ;; Click left time area
           [(< x (- WIDTH STEPPER-W))
            (set! selected (if (< x 26) 'hour 'minute))]
           ;; Click right up arrow area
           [(< y (/ HEIGHT 2)) (adjust-val 1)]
           ;; Click right down arrow area
           [else (adjust-val -1)])
         (send this refresh)]
        
        ;; Wheel support
        [(eq? type 'wheel-up)   (adjust-val 1)]
        [(eq? type 'wheel-down) (adjust-val -1)]))

    ;; Handle keyboard input: support arrow keys and Tab key switching
    (define/override (on-char event)
      (case (send event get-key-code)
        [(up)   (adjust-val 1)]
        [(down) (adjust-val -1)]
        [(tab)  (set! selected (if (eq? selected 'hour) 'minute 'hour))
                (send this refresh)]))

    ;; Redraw when focus state changes (blue highlight becomes gray)
    (define/override (on-focus on?)
      (set! has-focus? on?)
      (send this refresh))

    ;; Core drawing logic
    (define/override (on-paint) 
      (define dc (send this get-dc))
      (send dc set-smoothing 'smoothed)
      
      ;; 1. Draw outer capsule border and white background
      (send dc set-pen (make-object color% 210 210 210) 1 'solid)
      (send dc set-brush "white" 'solid)
      (send dc draw-rounded-rectangle 0 0 WIDTH HEIGHT 6)

      ;; 2. Draw selected part highlight background
      (define hl-color (if has-focus?
                           color-accent   ; macOS blue when focused
                           (make-object color% 230 230 230))) ; Light gray when unfocused
      (send dc set-brush hl-color 'solid)
      (send dc set-pen hl-color 1 'transparent)
      
      (if (eq? selected 'hour)
          (send dc draw-rounded-rectangle 2 2 24 (- HEIGHT 4) 4)
          (send dc draw-rounded-rectangle 28 2 24 (- HEIGHT 4) 4))

      ;; 3. Draw time numbers and colon
      (send dc set-font (make-object font% 11 'system 'normal 'bold))
      (define (draw-txt str x center-x color)
        (send dc set-text-foreground color)
        (define-values (txt-w txt-h txt-descender txt-ascent) (send dc get-text-extent str))
        (define y-pos (quotient (- HEIGHT txt-h) 2))
        (send dc draw-text str (+ x (- center-x (quotient txt-w 2))) y-pos))

      ;; Hour number
      (draw-txt (~r hour #:min-width 2 #:pad-string "0") 2 12
                (if (and (eq? selected 'hour) has-focus?) "white" color-text-main))
      
      ;; Colon
      (send dc set-text-foreground color-text-main)
      (send dc set-font (make-object font% 11 'system 'normal 'bold))
      (define-values (colon-w colon-h colon-descender colon-ascent) (send dc get-text-extent ":"))
      (define colon-y (quotient (- HEIGHT colon-h) 2))
      (send dc draw-text ":" 26 colon-y)
      
      ;; Minute number
      (draw-txt (~r minute #:min-width 2 #:pad-string "0") 28 12
                (if (and (eq? selected 'minute) has-focus?) "white" color-text-main))

      ;; 4. Draw right stepper divider line (very light gray)
      (send dc set-pen (make-object color% 240 240 240) 1 'solid)
      (send dc draw-line (- WIDTH STEPPER-W) 4 (- WIDTH STEPPER-W) (- HEIGHT 5))

      ;; 5. Draw micro arrows (polygon drawing)
      (send dc set-brush (make-object color% 60 60 60) 'solid)
      (send dc set-pen "black" 1 'transparent)
      
      ;; Up triangle arrow
      (send dc draw-polygon (list '(0 . 0) '(6 . 0) '(3 . -3.5)) (- WIDTH 10) 9)
      ;; Down triangle arrow
      (send dc draw-polygon (list '(0 . 0) '(6 . 0) '(3 . 3.5)) (- WIDTH 10) 14))

    ;; Public interface: add callback function for value changes
    (define/public (add-callback cb)
      (set! callbacks (cons cb callbacks)))
    
    ;; Public interface: get current time
    (define/public (get-time)
      (values hour minute))
    
    ;; Public interface: set current time
    (define/public (set-time h m)
      (set! hour (modulo h 24))
      (set! minute (modulo m 60))
      ;; Execute all registered callbacks
      (for ([cb callbacks]) (cb hour minute))
      (send this refresh))
    
    ;; Standardized methods
    (define/public (get-value)
      (send this get-time))
    
    (define/public (set-value h m)
      (send this set-time h m))
    
    (define/override (refresh)
      (super refresh))
    
    )
  )

;; New guix-time-picker% with updated naming convention
(define guix-time-picker% time-picker%)
