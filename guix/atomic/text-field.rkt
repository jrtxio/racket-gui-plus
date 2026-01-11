#lang racket/gui

(require racket/class
         (only-in racket/gui text-field% [text-field% original-text-field%])
         "../style/config.rkt")

(provide text-field%
         guix-text-field%
         (rename-out [text-field% modern-input%]))

;; Simple wrapper around racket/gui's text-field% with placeholder and theme support
(define text-field%
  (class original-text-field%
    (init-field [parent #f]
                [label ""]
                [init-value ""]
                [callback (λ (t e) (void))]
                [placeholder ""]
                [style '()]
                [theme (current-theme)])
    
    ;;; Instance variables
    (define current-placeholder placeholder)
    (define actual-value init-value)
    (define is-focused? #f)
    
    ;;; Update display based on focus and actual value
    (define (update-display)
      (let ([current-field-value (super get-value)])
        (cond
          [(and (string=? actual-value "") 
                (not is-focused?) 
                (string=? current-field-value "")
                (not (string=? current-placeholder "")))
           ;; Only show placeholder when:
           ;; 1. No actual value
           ;; 2. Not focused
           ;; 3. Current field is truly empty (not just placeholder text)
           ;; 4. Placeholder is not empty
           (super set-value current-placeholder)]
          [(and (string=? actual-value "") is-focused?)
           ;; When focused and no actual value, ensure field is empty
           ;; This prevents placeholder from reappearing during IME input
           (unless (string=? current-field-value "")
             (super set-value ""))]
          [else
           ;; When there's actual content, ensure field shows it
           ;; Only update if values differ to avoid unnecessary jumps
           (unless (string=? current-field-value actual-value)
             (super set-value actual-value))])))
    
    ;;; Internal callback that handles placeholder behavior and focus events
    (define (internal-callback field event)
      ;; Handle focus events
      (case (send event get-event-type)
        [(focus-in)
         (set! is-focused? #t)
         (update-display)]
        [(focus-out)
         (set! is-focused? #f)
         (update-display)]
        [(text-field-char text-field-delete text-field-change)
         ;; Update actual value immediately for any text change event
         ;; This ensures proper handling of Chinese IME input
         (set! actual-value (super get-value))
         ;; No need to call update-display here - actual value is already shown
         ])
      
      ;; Call original callback
      (callback field event))
    
    ;;; Constructor
    (super-new [parent parent]
               [label label]
               [init-value (if (string=? init-value "") "" init-value)]
               [callback internal-callback]
               [style (append '(single) style)]
               [font (font-regular)]
               [min-height 26] ; Reduced height to fix Chinese-English alignment
               [min-width 200]
               [vert-margin 4] ; Adjusted margin for new height
               [horiz-margin 4])
    
    ;; Initialize actual value and display
    (set! actual-value init-value)
    (update-display)
    
    ;; Register widget to global list for theme switch refresh
    (register-widget this)
    
    ;; Set as stretchable
    (send this stretchable-width #t)
    
    ;; Public methods for backward compatibility
    (define/public (get-text)
      actual-value)
    
    (define/public (set-text str)
      (set! actual-value str)
      (update-display))
    
    (define/public (clear)
      (set! actual-value "")
      (update-display))
    
    ;; Override get-value to return actual value
    (define/override (get-value)
      actual-value)
    
    ;; Override set-value to update actual value
    (define/override (set-value str)
      (set! actual-value str)
      (update-display))
    
    ;; Public method to get placeholder
    (define/public (get-placeholder)
      current-placeholder)
    
    ;; Public method to set placeholder
    (define/public (set-placeholder new-placeholder)
      (set! current-placeholder new-placeholder)
      (update-display))
  )
)

;; New guix-text-field% with updated naming convention
(define guix-text-field% text-field%)