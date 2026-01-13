#lang racket/gui

(require racket/draw
         "../core/base-control.rkt"
         "../style/config.rkt")

;; ===========================
;; Todo Item Control
;; ===========================
;; A composite control for todo list items with checkbox, text, and settings button
;; Similar to Apple Reminders style

(define todo-item%
  (class guix-base-control%
    (inherit get-client-size)
    
    ;; ===========================
    ;; Initialization
    ;; ===========================
    (init-field [task-text "New Task"]
                [checked? #f]
                [due-date #f]
                [notes ""]
                [on-click (λ () (void))]
                [on-toggle (λ (val) (void))]
                [on-settings (λ () (void))])
    
    (super-new [min-width 400]
               [min-height 40])
    
    ;; ===========================
    ;; Local State
    ;; ===========================
    (field [hover-region #f]) ; Current hover region: #f | 'checkbox | 'content | 'settings
    
    ;; ===========================
    ;; Region Calculation
    ;; ===========================
    (define/private (get-checkbox-region w h)
      (values 10 (- (/ h 2) 8) 16 16))
    
    (define/private (get-content-region w h)
      (values 36 8 (- w 72) (- h 16)))
    
    (define/private (get-settings-region w h)
      (values (- w 28) (- (/ h 2) 8) 16 16))
    
    (define/private (point-in-region? x y rx ry rw rh)
      (and (>= x rx) (<= x (+ rx rw))
           (>= y ry) (<= y (+ ry rh))))
    
    (define/private (get-region-at x y)
      (define-values (w h) (get-client-size))
      (define-values (cbx cby cbw cbh) (get-checkbox-region w h))
      (define-values (cx cy cw ch) (get-content-region w h))
      (define-values (sx sy sw sh) (get-settings-region w h))
      
      (cond
        [(point-in-region? x y cbx cby cbw cbh) 'checkbox]
        [(point-in-region? x y cx cy cw ch) 'content]
        [(point-in-region? x y sx sy sw sh) 'settings]
        [else #f]))
    
    ;; ===========================
    ;; Event Handling
    ;; ===========================
    (define/override (handle-mouse-event event)
      (define event-type (send event get-event-type))
      (define x (send event get-x))
      (define y (send event get-y))
      
      (cond
        [(eq? event-type 'motion)
         (define new-region (get-region-at x y))
         (when (not (eq? new-region hover-region))
           (set! hover-region new-region)
           (send this refresh-now))]
        
        [(eq? event-type 'left-up)
         (define region (get-region-at x y))
         (case region
           [(checkbox)
            (set! checked? (not checked?))
            (on-toggle checked?)
            (send this refresh-now)]
           [(content)
            (on-click)]
           [(settings)
            (on-settings)])]
        
        [(eq? event-type 'leave)
         (set! hover-region #f)
         (send this refresh-now)]))
    
    ;; ===========================
    ;; Rendering
    ;; ===========================
    (define/override (render-control dc state theme)
      (define-values (w h) (get-client-size))
      (send dc set-smoothing 'smoothed)
      
      ;; ===========================
      ;; 1. Background
      ;; ===========================
      (send dc set-brush (color-bg-light) 'solid)
      (send dc set-pen (color-bg-light) 1 'transparent)
      (send dc draw-rectangle 0 0 w h)
      
      ;; ===========================
      ;; 2. Checkbox
      ;; ===========================
      (define-values (cbx cby cbw cbh) (get-checkbox-region w h))
      
      ;; Checkbox border
      (send dc set-pen (if checked? (color-accent) (color-border)) 1 'solid)
      (send dc set-brush (if checked? (color-accent) "white") 'solid)
      (send dc draw-rectangle cbx cby cbw cbh)
      
      ;; Checkmark
      (when checked?
        (send dc set-pen "white" 2 'solid)
        (send dc draw-line (+ cbx 3) (+ cby 8) (+ cbx 6) (+ cby 11))
        (send dc draw-line (+ cbx 6) (+ cby 11) (+ cbx 12) (+ cby 5)))
      
      ;; ===========================
      ;; 3. Content
      ;; ===========================
      (define-values (cx cy cw ch) (get-content-region w h))
      
      ;; Task text
      (send dc set-text-foreground (if checked? (color-text-light) (color-text-main)))
      (send dc set-font (send the-font-list find-or-create-font 14 'swiss (if checked? 'normal 'normal) 'normal))
      
      ;; Draw text with ellipsis if too long
      (define text-width (let-values ([(tw th _1 _2) (send dc get-text-extent task-text)]) tw))
      (define display-text
        (if (<= text-width cw)
            task-text
            (let loop ([t task-text])
              (if (<= (let-values ([(tw th _1 _2) (send dc get-text-extent (string-append t "..."))]) tw) cw)
                  (string-append t "...")
                  (loop (substring t 0 (- (string-length t) 1)))))))
      
      (send dc draw-text display-text cx (+ cy 2))
      
      ;; Due date (if present)
      (when due-date
        (define date-text (format "~a" due-date))
        (send dc set-text-foreground (color-text-light))
        (send dc set-font (send the-font-list find-or-create-font 11 'swiss 'normal 'normal))
        (send dc draw-text date-text cx (+ cy 20)))
      
      ;; ===========================
      ;; 4. Settings Button
      ;; ===========================
      (define-values (sx sy sw sh) (get-settings-region w h))
      
      ;; Settings icon
      (send dc set-text-foreground (if (eq? hover-region 'settings) (color-accent) (color-text-light)))
      (send dc set-font (send the-font-list find-or-create-font 14 'swiss 'normal 'normal))
      (send dc draw-text "⋯" sx (+ sy 1))
      )
    
    ;; ===========================
    ;; Public Interface
    ;; ===========================
    
    ;; Get task text
    (define/public (get-text) task-text)
    
    ;; Set task text
    (define/public (set-text txt)
      (set! task-text txt)
      (send this refresh-now))
    
    ;; Get checked state
    (define/public (get-checked) checked?)
    
    ;; Set checked state
    (define/public (set-checked val)
      (set! checked? val)
      (send this refresh-now))
    
    ;; Get due date
    (define/public (get-due-date) due-date)
    
    ;; Set due date
    (define/public (set-due-date date)
      (set! due-date date)
      (send this refresh-now))
    
    ;; Get notes
    (define/public (get-notes) notes)
    
    ;; Set notes
    (define/public (set-notes n)
      (set! notes n)
      (send this refresh-now))
    ))

;; ===========================
;; Export
;; ===========================
(provide todo-item%
         guix-todo-item%)

;; Alias for consistency
(define guix-todo-item% todo-item%)
