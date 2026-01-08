#lang racket/gui

;; Guix - Modern Racket GUI Widget Library
;; State management system for widgets

(require racket/class
         racket/gui/base
         racket/contract)

;; ===========================
;; State Types
;; ===========================

;; State type enum
(define STATE-TYPES '(local controlled))

;; State structure
(struct state (
  type        ; State type (local or controlled)
  key         ; State key (symbol)
  value       ; State value (any)
  validator   ; Value validator (optional)
  (watchers #:mutable))) ; Functions to call when state changes

;; Create state with default values
(define (make-state type key value [validator #f])
  (state type key value validator '()))

;; ===========================
;; State Manager
;; ===========================

(define guix-state-manager% 
  (class object%
    (super-new)
    
    ;; State storage
    (field [states (make-hash)])
    
    ;; ===========================
    ;; State Registration
    ;; ===========================
    
    ;; Register a new state
    (define/public (register-state key type value [validator #f])
      (unless (member type STATE-TYPES)
        (error "Invalid state type: ~a" type))
      
      (hash-set! states key (make-state type key value validator)))
    
    ;; ===========================
    ;; State Access
    ;; ===========================
    
    ;; Get state value
    (define/public (get-state key)
      (let ([state (hash-ref states key #f)])
        (if state (state-value state) (error "State not found: ~a" key))))
    
    ;; ===========================
    ;; State Update
    ;; ===========================
    
    ;; Update state value
    (define/public (set-state! key new-value)
      (let ([current-state (hash-ref states key #f)])
        (unless current-state
          (error "State not found: ~a" key))
        
        ;; Validate new value if validator is provided
        (when (state-validator current-state)
          (unless ((state-validator current-state) new-value)
            (error "Invalid value for state ~a: ~a" key new-value)))
        
        ;; Update state value if it has changed
        (unless (equal? new-value (state-value current-state))
          (let ([new-state (struct-copy state current-state [value new-value])])
            (hash-set! states key new-state)
            ;; Notify all watchers
            (notify-watchers new-state)))))
    
    ;; ===========================
    ;; State Watching
    ;; ===========================
    
    ;; Watch state changes
    (define/public (watch-state key watcher)
      (let ([state (hash-ref states key #f)])
        (unless state
          (error "State not found: ~a" key))
        
        (let ([watchers (state-watchers state)])
          (unless (member watcher watchers)
            (set-state-watchers! state (cons watcher watchers))))))
    
    ;; Unwatch state changes
    (define/public (unwatch-state key watcher)
      (let ([state (hash-ref states key #f)])
        (when state
          (set-state-watchers! state (remove watcher (state-watchers state))))))
    
    ;; ===========================
    ;; Watcher Notification
    ;; ===========================
    
    ;; Notify all watchers of a state change
    (define/private (notify-watchers state)
      (for-each (λ (watcher) (watcher (state-key state) (state-value state)))
                (state-watchers state)))
    
    ;; ===========================
    ;; State Inspection
    ;; ===========================
    
    ;; Get all state keys
    (define/public (get-state-keys)
      (hash-keys states))
    
    ;; Get state type
    (define/public (get-state-type key)
      (let ([state (hash-ref states key #f)])
        (if state (state-type state) (error "State not found: ~a" key))))
    
    ))

;; ===========================
;; State Management Mixin
;; ===========================

;; Mixin for adding state management capabilities to widgets
(define state-manager-mixin
  (mixin () ()
    
    ;; State manager for this widget
    (field [state-manager (new guix-state-manager%)])
    
    ;; ===========================
    ;; State API
    ;; ===========================
    
    ;; Initialize local state
    (define/public (init-local-state key value [validator #f])
      (send state-manager register-state key 'local value validator))
    
    ;; Initialize controlled state
    (define/public (init-controlled-state key value [validator #f])
      (send state-manager register-state key 'controlled value validator))
    
    ;; Get state value
    (define/public (get-state key)
      (send state-manager get-state key))
    
    ;; Set state value
    (define/public (set-state! key value)
      (send state-manager set-state! key value))
    
    ;; Watch state changes
    (define/public (watch-state key watcher)
      (send state-manager watch-state key watcher))
    
    ;; Unwatch state changes
    (define/public (unwatch-state key watcher)
      (send state-manager unwatch-state key watcher))
    
    ;; ===========================
    ;; State Change Notification
    ;; ===========================
    
    ;; Set up state change watcher to trigger invalidate
    (define/public (bind-state-to-render key)
      (watch-state key (λ (k v) (send this invalidate))))
    
    ;; ===========================
    ;; Value Propagation
    ;; ===========================
    
    ;; Propagate state change to parent (for controlled components)
    (define/public (propagate-change key value)
      ;; This method should be overridden by widgets that support controlled state
      (void))
    
    ))

;; ===========================
;; State Validators
;; ===========================

;; Common state validators

;; Boolean validator
(define (boolean-validator value)
  (boolean? value))

;; Number validator
(define (number-validator value)
  (number? value))

;; String validator
(define (string-validator value)
  (string? value))

;; Non-empty string validator
(define (non-empty-string-validator value)
  (and (string? value) (not (zero? (string-length value)))))

;; Range validator
(define (range-validator min max)
  (λ (value)
    (and (number? value) (<= min value max))))

;; ===========================
;; Export
;; ===========================
(provide
 ;; State structure and types
 state state-type state-key state-value state-validator state-watchers set-state-watchers!
 STATE-TYPES
 
 ;; State manager class
 guix-state-manager%
 
 ;; State management mixin
 state-manager-mixin
 
 ;; Common validators
 boolean-validator number-validator string-validator non-empty-string-validator range-validator)