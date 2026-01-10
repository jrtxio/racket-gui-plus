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
    (define is-placeholder-shown? #f)
    
    ;;; Internal callback that handles placeholder behavior
    (define (internal-callback field event)
      ;; Call original callback
      (callback field event)
      
      ;; Update placeholder state
      (update-placeholder))
    
    ;;; Update placeholder visibility based on text content
    (define (update-placeholder)
      (define current-value (send this get-value))
      (if (and (string=? current-value "") (not (string=? current-placeholder "")))
          (unless is-placeholder-shown?
            (set! is-placeholder-shown? #t)
            ;; Set placeholder text with gray color
            (send this set-value current-placeholder)
            (send this set-field-background (color-bg-white)))
          (when is-placeholder-shown?
            (set! is-placeholder-shown? #f)
            ;; Only clear if the current value is exactly the placeholder
            ;; Otherwise, the user has started typing - keep their input
            (when (string=? current-value current-placeholder)
              (send this set-value "")))))
    
    ;;; Constructor
    (super-new [parent parent]
               [label label]
               [init-value (if (string=? init-value "") "" init-value)]
               [callback internal-callback]
               [style (cons 'single style)]
               [min-height (input-height)]
               [min-width 200])
    
    ;; Initialize placeholder state
    (set! is-placeholder-shown? (string=? init-value ""))
    (when is-placeholder-shown?
      (send this set-value current-placeholder))
    
    ;; Register widget to global list for theme switch refresh
    (register-widget this)
    
    ;; Set as stretchable
    (send this stretchable-width #t)
    
    ;; Public methods for backward compatibility
    (define/public (get-text)
      (if is-placeholder-shown? "" (send this get-value)))
    
    (define/public (set-text str)
      (when is-placeholder-shown?
        (set! is-placeholder-shown? #f))
      (send this set-value str))
    
    (define/public (clear)
      (send this set-value "")
      (update-placeholder))
    
    ;; Public method to get placeholder
    (define/public (get-placeholder)
      current-placeholder)
    
    ;; Public method to set placeholder
    (define/public (set-placeholder new-placeholder)
      (set! current-placeholder new-placeholder)
      (update-placeholder))
  )
)

;; New guix-text-field% with updated naming convention
(define guix-text-field% text-field%)