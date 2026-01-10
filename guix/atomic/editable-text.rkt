#lang racket/gui

(require racket/class
         racket/draw
         "../style/config.rkt")

(provide editable-text%
         guix-editable-text%)

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
    
    (define current-text init-value)
    (define is-editing? #f)
    (define has-focus? #f)
    (define cursor-pos (string-length current-text))
    (define cursor-visible? #t)
    (define cursor-blink-timer #f)
    
    (register-widget this)
    (send this stretchable-width #t)
    
    (define/override (on-paint)
      (define dc (send this get-dc))
      (define-values (w h) (send this get-client-size))
      
      (send dc set-brush (color-bg-light) 'solid)
      (send dc set-pen (color-bg-light) 1 'transparent)
      (send dc draw-rectangle 0 0 w h)
      
      (send dc set-font (font-regular))
      
      (if (and (string=? current-text "") (not is-editing?))
          (begin
            (send dc set-text-foreground (color-text-placeholder))
            (send dc draw-text placeholder 12 12))
          (begin
            (send dc set-text-foreground (color-text-main))
            (send dc draw-text current-text 12 12)
            (when (and is-editing? has-focus? cursor-visible?)
              (let-values ([(text-width _1 _2 _3) (send dc get-text-extent (substring current-text 0 cursor-pos))])
                (send dc set-pen (color-text-main) 2 'solid)
                (send dc draw-line (+ 12 text-width) 5 (+ 12 text-width) (- h 5)))))))
    
    (define/override (on-event event)
      (when (send event button-down?)
        (set! is-editing? #t)
        (set! has-focus? #t)
        (send this focus)
        (send this refresh)))
    
    (define/override (on-char event)
      (define key (send event get-key-code))
      
      (cond
        [(equal? key #\return)
         (set! is-editing? #f)
         (set! has-focus? #f)
         (callback this)
         (send this refresh)]
        
        [(equal? key 'back)
         (when (and is-editing? (> cursor-pos 0))
           (set! current-text (string-append (substring current-text 0 (- cursor-pos 1))
                                            (substring current-text cursor-pos)))
           (set! cursor-pos (- cursor-pos 1))
           (send this refresh))]
        
        [(equal? key 'delete)
         (when (and is-editing? (< cursor-pos (string-length current-text)))
           (set! current-text (string-append (substring current-text 0 cursor-pos)
                                            (substring current-text (+ cursor-pos 1))))
           (set! cursor-pos (min cursor-pos (string-length current-text)))
           (send this refresh))]
        
        [(equal? key 'left)
         (when (and is-editing? (> cursor-pos 0))
           (set! cursor-pos (- cursor-pos 1))
           (send this refresh))]
        
        [(equal? key 'right)
         (when (and is-editing? (< cursor-pos (string-length current-text)))
           (set! cursor-pos (+ cursor-pos 1))
           (send this refresh))]
        
        [(char? key)
         (when is-editing?
           (set! current-text (string-append (substring current-text 0 cursor-pos)
                                            (string key)
                                            (substring current-text cursor-pos)))
           (set! cursor-pos (+ cursor-pos 1))
           (send this refresh))]))
    
    (define/override (on-focus on?)
      (set! has-focus? on?)
      (when (and (not on?) is-editing?)
        (set! is-editing? #f)
        (callback this)
        (when cursor-blink-timer
          (send cursor-blink-timer stop)
          (set! cursor-blink-timer #f)))
      (when on?
        (set! cursor-visible? #t)
        (set! cursor-blink-timer (new timer% 
                                     [interval 500] 
                                     [notify-callback (lambda ()
                                                        (set! cursor-visible? (not cursor-visible?))
                                                        (send this refresh))])))
      (send this refresh))
    
    (define/public (get-text) current-text)
    (define/public (set-text str)
      (set! current-text str)
      (set! cursor-pos (string-length current-text)) ; 更新光标位置
      (send this refresh))
    
    ;; 清除文本内容
    (define/public (clear)
      (set! current-text "")
      (set! cursor-pos 0) ; 重置光标位置
      (send this refresh))
    ))

(define guix-editable-text% editable-text%)