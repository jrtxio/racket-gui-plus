#lang racket/gui

;; Task Item Component
;; A simple and reliable task item widget
;; with visual unity

(require racket/class
         racket/draw
         "../atomic/checkbox.rkt"
         "../atomic/button.rkt"
         "../atomic/text-field.rkt"
         "../atomic/label.rkt"
         "../style/config.rkt")

(provide task-item%
         guix-task-item%)

;; New guix-task-item% with updated naming convention
(define guix-task-item% task-item%)

;; ============================================================;
;; Task Item Widget - A simple and reliable task item component;
;; ============================================================;
(define task-item%
  (class vertical-panel%
    (init-field [parent #f]
                [task-text "New Task"]
                [checked? #f]
                [due-date #f]
                [notes ""]
                [on-change (lambda (text checked date note) (void))])
    
    (super-new [parent parent]
               [alignment '(left top)]
               [stretchable-height #f]
               [stretchable-width #t]
               [spacing 8]
               [border 10])
    
    ;; Instance variables to track current state
    (define current-text task-text)
    (define current-checked checked?)
    (define current-due-date due-date)
    (define current-notes notes)
    
    ;; Create a panel for the main task content (checkbox + title + info)
    (define main-content
      (new horizontal-panel%
           [parent this]
           [alignment '(left center)]
           [stretchable-height #f]
           [stretchable-width #t]
           [spacing 8]))
    
    ;; Checkbox
    (define checkbox
      (new checkbox%
           [parent main-content]
           [checked? checked?]
           [callback (lambda (cb evt)
                       (set! current-checked (send cb get-checked))
                       (on-change current-text current-checked current-due-date current-notes))]))
    
    ;; Task title - using a simple text-field for now
    (define title-field
      (new text-field%
           [parent main-content]
           [init-value task-text]
           [callback (lambda (tf)
                       (set! current-text (send tf get-text))
                       (on-change current-text current-checked current-due-date current-notes))]))
    
    ;; Info button
    (define info-btn
      (new button%
           [parent main-content]
           [label "⋮"]
           [min-width 20]
           [min-height 20]
           [callback (lambda (btn evt)
                       (on-change current-text current-checked current-due-date current-notes))]))
    
    ;; Notes label (non-editable for now)
    (define notes-label #f)
    (when (and notes (not (string=? notes "")))
      (set! notes-label
            (new label%
                 [parent this]
                 [label notes]
                 [stretchable-width #t])))
    
    ;; Due date label
    (define date-label #f)
    (when due-date
      (set! date-label
            (new label%
                 [parent this]
                 [label due-date]
                 [stretchable-width #t])))
    
    ;; Public methods
    (define/public (get-text) current-text)
    (define/public (get-checked) current-checked)
    (define/public (get-due-date) current-due-date)
    (define/public (get-notes) current-notes)
    
    (define/public (set-text txt)
      (set! current-text txt)
      (send title-field set-text txt)
      (on-change current-text current-checked current-due-date current-notes))
    
    (define/public (set-checked val)
      (set! current-checked val)
      (send checkbox set-checked! val)
      (on-change current-text current-checked current-due-date current-notes))
    
    (define/public (set-due-date date)
      (set! current-due-date date)
      ;; Simplified: We don't dynamically add/remove date row
      (void))
    
    (define/public (set-notes notes)
      (set! current-notes notes)
      (void))
    ))
