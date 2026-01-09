#lang racket/gui

;; Guix - Modern Racket GUI Widget Library
;; Event system for handling widget events

;; ===========================
;; Event Type Definition Helper
;; ===========================

;; Event type definition helper
(define-syntax-rule (define-event-type name)
  (begin
    (define name 'name)
    (provide name)))

;; ===========================
;; Event Type Definitions
;; ===========================

;; Basic event types as specified in PRD
(define-event-type on-click)          ; Click event
(define-event-type on-hover-enter)    ; Mouse enter event
(define-event-type on-hover-exit)     ; Mouse leave event
(define-event-type on-focus)          ; Focus gain event
(define-event-type on-blur)           ; Focus loss event

;; Composite control specific event types
(define-event-type on-activate)       ; Main action (e.g. double-click list item)
(define-event-type on-secondary)      ; Secondary action (e.g. click delete button)

;; ===========================
;; Hit Test Helper Functions
;; ===========================

;; Example hit-test function for regions within a control
;; Returns the region symbol based on coordinates
(define (hit-test-regions x y width height)
  (cond
    [(< x 40) 'icon-region]              ; Left 40px: icon region
    [(> x (- width 60)) 'action-region]  ; Right 60px: action region
    [else 'content-region]))             ; Middle: content region

;; Hit test helper for point in rectangle
(define (point-in-rect? x y rect)  
  (match rect
    [(list left top right bottom)
     (and (<= left x right) (<= top y bottom))]
    [(vector left top right bottom)
     (and (<= left x right) (<= top y bottom))]
    [_ #f]))

;; ===========================
;; Export Additional Functions
;; ===========================
(provide hit-test-regions point-in-rect?)