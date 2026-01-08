#lang racket/gui

;; Guix - Modern Racket GUI Widget Library
;; Event system for handling widget events

(require racket/class
         racket/gui/base)

;; ===========================
;; Event Structure
;; ===========================

;; Define event types
(define EVENT-TYPES '(on-click on-double-click on-hover on-change on-focus on-blur))

;; Event structure
(struct event (
  type        ; Event type (symbol)
  source      ; Event source widget
  data        ; Event data (any)
  (stopped? #:mutable) ; Whether event propagation is stopped
  timestamp)) ; Event timestamp

;; Create event with default values
(define (make-event type source data)
  (event type source data #f (current-inexact-milliseconds)))

;; ===========================
;; Event Manager
;; ===========================

;; Event manager class to handle event registration and dispatching
(define guix-event-manager% 
  (class object%
    (super-new)
    
    ;; Event callbacks storage
    (field [callbacks (make-hash)])
    
    ;; ===========================
    ;; Event Registration
    ;; ===========================
    
    ;; Register event callback
    (define/public (register-callback event-type callback)
      (unless (member event-type EVENT-TYPES)
        (error "Invalid event type: ~a" event-type))
      
      (hash-update! callbacks event-type
                    (λ (existing) (cons callback existing))
                    '()))
    
    ;; Unregister event callback
    (define/public (unregister-callback event-type callback)
      (when (hash-has-key? callbacks event-type)
        (hash-update! callbacks event-type
                      (λ (existing) (remove callback existing))
                      '())))
    
    ;; ===========================
    ;; Event Dispatching
    ;; ===========================
    
    ;; Dispatch event to registered callbacks
    (define/public (dispatch-event event)
      (when (hash-has-key? callbacks (event-type event))
        (for-each (λ (callback) (callback event))
                  (hash-ref callbacks (event-type event)))))
    
    ;; ===========================
    ;; Event Creation
    ;; ===========================
    
    ;; Create new event
    (define/public (create-event type source data)
      (event type source data #f (current-inexact-milliseconds)))
    
    ))

;; ===========================
;; Event Handling Mixin
;; ===========================

;; Mixin for adding event handling capabilities to widgets
(define event-handler-mixin
  (mixin () ()
    
    ;; Event manager for this widget
    (field [event-manager (new guix-event-manager%)])
    
    ;; ===========================
    ;; Event Registration API
    ;; ===========================
    
    ;; Register event callback
    (define/public (register-event-callback event-type callback)
      (send event-manager register-callback event-type callback))
    
    ;; Unregister event callback
    (define/public (unregister-event-callback event-type callback)
      (send event-manager unregister-callback event-type callback))
    
    ;; ===========================
    ;; Event Emission
    ;; ===========================
    
    ;; Emit event from this widget
    (define/public (emit-event event-type data)
      (let ([event (send event-manager create-event event-type this data)])
        ;; Dispatch event locally
        (send event-manager dispatch-event event)
        
        ;; Propagate event to parent if not stopped
        (unless (event-stopped? event)
          (propagate-event event))))
    
    ;; ===========================
    ;; Event Propagation
    ;; ===========================
    
    ;; Propagate event to parent widget
    (define/public (propagate-event event)
      (let ([parent (and (is-a? this area<%>) (send this get-parent))])
        (when (and parent (is-a? parent guix-event-manager%))
          (send parent dispatch-event event)
          (unless (event-stopped? event)
            (send parent propagate-event event)))))
    
    ;; ===========================
    ;; Event Stopping
    ;; ===========================
    
    ;; Stop event propagation
    (define/public (stop-event event)
      (set-event-stopped?! event #t))
    
    ;; Check if event is stopped
    (define/public (event-stopped? event)
      (event-stopped? event))
    
    ))

;; ===========================
;; Event Helper Functions
;; ===========================

;; Create a click event
(define (create-click-event source)
  (event 'on-click source #f #f (current-inexact-milliseconds)))

;; Create a change event
(define (create-change-event source new-value)
  (event 'on-change source new-value #f (current-inexact-milliseconds)))

;; Create a focus event
(define (create-focus-event source)
  (event 'on-focus source #f #f (current-inexact-milliseconds)))

;; Create a blur event
(define (create-blur-event source)
  (event 'on-blur source #f #f (current-inexact-milliseconds)))

;; Create a hover event
(define (create-hover-event source)
  (event 'on-hover source #f #f (current-inexact-milliseconds)))

;; ===========================
;; Export
;; ===========================
(provide
 ;; Event structure and types
 event event-type event-source event-data event-stopped? set-event-stopped?!
 EVENT-TYPES
 
 ;; Event manager class
 guix-event-manager%
 
 ;; Event handler mixin
 event-handler-mixin
 
 ;; Event helper functions
 create-click-event create-change-event create-focus-event create-blur-event create-hover-event)