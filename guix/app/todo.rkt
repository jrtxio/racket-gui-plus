#lang racket/gui

;; Todo list component
;; Feature-complete todo list with add, edit, delete, and completion marking

(require racket/class
         racket/draw
         "../style/config.rkt"
         "../atomic/checkbox.rkt")

(provide todo-list% todo-item% task-details-dialog% checkbox-canvas%)

;; ============================================================;
;; 1. Checkbox Canvas Widget (for backward compatibility);
;; ============================================================;
(define checkbox-canvas%
  (class canvas%
    (init-field [checked? #f]
                [on-change (lambda (val) (void))])
    
    (super-new [style '(transparent)]
               [stretchable-width #f]
               [stretchable-height #f]
               [min-width 30]
               [min-height 30])
    
    (define hover? #f)
    
    (define/override (on-paint)
      (let ([dc (send this get-dc)]
            [w (send this get-width)]
            [h (send this get-height)])
        (send dc set-smoothing 'smoothed)
        (define cx (/ w 2))
        (define cy 15)
        
        (if checked?
            ;; Checked state: blue filled circle + white check mark
            (begin
              (send dc set-pen (color-accent) 1 'solid)
              (send dc set-brush (color-accent) 'solid)
              (send dc draw-ellipse (- cx 9) (- cy 9) 18 18)
              
              ;; Draw check mark
              (send dc set-pen "white" 2 'solid)
              (send dc draw-line (- cx 4) cy (- cx 1) (+ cy 3))
              (send dc draw-line (- cx 1) (+ cy 3) (+ cx 4) (- cy 4)))
            
            ;; Unchecked state: hollow circle
            (begin
              (send dc set-pen (if hover? (color-accent) (color-border)) 1.5 'solid)
              (send dc set-brush "transparent" 'transparent)
              (send dc draw-ellipse (- cx 9) (- cy 9) 18 18)))))
    
    (define/override (on-event event)
      (cond
        [(equal? (send event get-event-type) 'left-down)
         (set! checked? (not checked?))
         (send this refresh)
         (on-change checked?)]
        
        [(equal? (send event get-event-type) 'enter)
         (set! hover? #t)
         (send this refresh)]
        
        [(equal? (send event get-event-type) 'leave)
         (set! hover? #f)
         (send this refresh)]))
    
    ;; Public methods
    (define/public (get-checked) checked?)
    (define/public (set-checked val)
      (set! checked? val)
      (send this refresh))
    ))

;; ============================================================;
;; 2. Task Details Dialog Widget;
;; ============================================================;
(define task-details-dialog%
  (class dialog%
    (init-field [task-text ""]
                [due-date #f]
                [notes ""]
                [on-save (lambda (text date notes) (void))])
    
    (super-new [label "Task Details"]
               [width 400]
               [height 350])
    
    (define main-panel (new vertical-panel% [parent this] [border 15] [spacing 10]))
    
    ;; Task title
    (new message% [parent main-panel] [label "Task Content:"])
    (define title-field
      (new text-field% 
           [parent main-panel]
           [label ""]
           [init-value task-text]))
    
    ;; Due date
    (new message% [parent main-panel] [label "Due Date:"])
    (define date-panel (new horizontal-panel% [parent main-panel] [stretchable-height #f]))
    
    (define date-field
      (new text-field%
           [parent date-panel]
           [label ""]
           [init-value (if due-date due-date "")]
           [style '(single)]))
    
    (new message% [parent date-panel] [label "  Format: YYYY-MM-DD"])
    
    ;; Notes
    (new message% [parent main-panel] [label "Notes:"])
    (define notes-text (new text%))
    (send notes-text insert notes)
    (new editor-canvas%
         [parent main-panel]
         [editor notes-text]
         [style '(no-hscroll)]
         [min-height 100])
    
    ;; Buttons
    (define btn-panel (new horizontal-panel% [parent main-panel] [stretchable-height #f]))
    (new horizontal-pane% [parent btn-panel])
    
    (new button%
         [parent btn-panel]
         [label "Cancel"]
         [callback (lambda (btn evt) (send this show #f))])
    
    (new button%
         [parent btn-panel]
         [label "Save"]
         [callback (lambda (btn evt)
                    (on-save 
                     (send title-field get-value)
                     (let ([d (send date-field get-value)])
                       (if (string=? d "") #f d))
                     (send notes-text get-text))
                    (send this show #f))])
    ))

;; ============================================================;
;; Text Callback Classes;
;; ============================================================;

;; Text callback class for task text
(define task-text-callback%
  (class text%
    (init-field [on-change-callback #f])
    (super-new)
    (define/augment (after-insert start len)
      (inner (void) after-insert start len)
      (when on-change-callback
        (on-change-callback)))
    (define/augment (after-delete start len)
      (inner (void) after-delete start len)
      (when on-change-callback
        (on-change-callback)))))

;; Text callback class for notes
(define notes-text-callback%
  (class text%
    (init-field [on-change-callback #f])
    (super-new)
    (define/augment (after-insert start len)
      (inner (void) after-insert start len)
      ;; Keep light gray style
      (let ([delta (new style-delta%)])
        (send delta set-delta-foreground (make-object color% 130 130 130))
        (send delta set-size-mult 0.9)
        (send this change-style delta 0 (send this last-position)))
      (when on-change-callback
        (on-change-callback)))
    (define/augment (after-delete start len)
      (inner (void) after-delete start len)
      (when on-change-callback
        (on-change-callback)))))

;; ============================================================;
;; 3. Todo Item Widget;
;; ============================================================;
(define todo-item%
  (class vertical-panel%
    (init-field [task-text "New Task"]
                [checked? #f]
                [due-date #f]
                [notes ""]
                [on-delete (lambda () (void))]
                [on-change (lambda (text checked date notes) (void))])
    
    (super-new [alignment '(left top)]
               [stretchable-height #f]
               [spacing 3])
    
    ;; First row: Checkbox + Text + Info button
    (define first-row (new horizontal-panel% 
                           [parent this]
                           [alignment '(left center)]
                           [stretchable-height #f]
                           [spacing 5]))
    
    ;; Left checkbox
    (define checkbox
      (new checkbox% 
           [parent first-row]
           [checked? checked?]
           [callback (lambda (cb evt)
                       (set! checked? (send cb get-checked))
                       (update-text-style)
                       (on-change (get-text) checked? due-date notes))]))
    
    ;; Task text editor
    (define text-obj (new task-text-callback%
                         [on-change-callback (lambda ()
                                               (on-change (get-text) checked? due-date notes))]))
    (send text-obj insert task-text)
    
    (define editor-canvas
      (new editor-canvas% 
           [parent first-row] 
           [editor text-obj] 
           [style '(no-border no-hscroll no-vscroll transparent)] 
           [min-height 30]
           [stretchable-width #t]))
    
    ;; Info button (right side)
    (define info-btn
      (new button%
           [parent first-row]
           [label "ⓘ"]
           [stretchable-width #f]
           [min-width 30]
           [font (make-object font% 16 'default 'normal 'normal)]
           [callback (lambda (btn evt) (show-details))]))
    
    ;; Second row: Notes (light gray, editable)
    (define notes-panel #f)
    (define notes-text #f)
    (define notes-canvas #f)
    (when (and notes (not (string=? notes "")))
      (set! notes-panel (new horizontal-panel% 
                             [parent this]
                             [alignment '(left top)]
                             [stretchable-height #f]
                             [spacing 0]))
      ;; Left indent (align with text)
      (new message% [parent notes-panel] [label "        "])
      
      ;; Notes editor
      (set! notes-text (new notes-text-callback%
                           [on-change-callback (lambda ()
                                                 (set! notes (send notes-text get-text))
                                                 (on-change (get-text) checked? due-date notes))]))
      (send notes-text insert notes)
      
      ;; Set notes style to light gray
      (let ([delta (new style-delta%)])
        (send delta set-delta-foreground (make-object color% 130 130 130))
        (send delta set-size-mult 0.9)
        (send notes-text change-style delta 0 (send notes-text last-position)))
      
      ;; Notes text editor
      (set! notes-canvas
            (new editor-canvas% 
                 [parent notes-panel] 
                 [editor notes-text] 
                 [style '(no-border no-hscroll no-vscroll transparent)] 
                 [min-height 24]
                 [stretchable-width #t])))
    
    ;; Third row: Date (light gray, indented display)
    (define date-panel #f)
    (define date-label #f)
    (when due-date
      (set! date-panel (new horizontal-panel% 
                            [parent this]
                            [alignment '(left center)]
                            [stretchable-height #f]
                            [spacing 0]))
      ;; Left indent
      (new message% [parent date-panel] [label "        "])
      ;; Date display (light gray)
      (define date-msg (new message%
                            [parent date-panel]
                            [label due-date]
                            [font (make-object font% 10 'default 'normal 'normal)]))
      (set! date-label date-msg))
    
    ;; Show details dialog
    (define/private (show-details)
      (define dlg
        (new task-details-dialog%
             [task-text (get-text)]
             [due-date due-date]
             [notes notes]
             [on-save (lambda (text date note)
                       (send text-obj begin-edit-sequence)
                       (send text-obj erase)
                       (send text-obj insert text)
                       (send text-obj end-edit-sequence)
                       (set! due-date date)
                       (set! notes note)
                       (update-notes-display)
                       (update-date-display)
                       (on-change text checked? date note))]))
      (send dlg show #t))
    
    ;; Update notes display
    (define/private (update-notes-display)
      ;; Delete old notes panel
      (when notes-panel
        (send this delete-child notes-panel)
        (set! notes-panel #f)
        (set! notes-text #f)
        (set! notes-canvas #f))
      
      ;; If there are notes, create new notes panel
      (when (and notes (not (string=? notes "")))
        (set! notes-panel (new horizontal-panel% 
                               [parent this]
                               [alignment '(left top)]
                               [stretchable-height #f]
                               [spacing 0]))
        ;; Left indent
        (new message% [parent notes-panel] [label "        "])
        
        ;; Notes editor
        (set! notes-text (new notes-text-callback%
                           [on-change-callback (lambda ()
                                                 (set! notes (send notes-text get-text))
                                                 (on-change (get-text) checked? due-date notes))]))
        (send notes-text insert notes)
        
        ;; Set notes style to light gray
        (let ([delta (new style-delta%)])
          (send delta set-delta-foreground (make-object color% 130 130 130))
          (send delta set-size-mult 0.9)
          (send notes-text change-style delta 0 (send notes-text last-position)))
        
        ;; Notes text editor
        (set! notes-canvas
              (new editor-canvas% 
                   [parent notes-panel] 
                   [editor notes-text] 
                   [style '(no-border no-hscroll no-vscroll transparent)] 
                   [min-height 24]
                   [stretchable-width #t]))) 
      
      ;; Reorder children: First row -> Notes -> Date
      (send this change-children
            (lambda (children)
              (filter values 
                      (list first-row notes-panel date-panel))))
      )
    
    ;; Update date display
    (define/private (update-date-display)
      ;; Delete old date panel
      (when date-panel
        (send this delete-child date-panel)
        (set! date-panel #f)
        (set! date-label #f))
      
      ;; If there is a date, create new date panel
      (when due-date
        (set! date-panel (new horizontal-panel% 
                              [parent this]
                              [alignment '(left center)]
                              [stretchable-height #f]
                              [spacing 0]))
        ;; Left indent
        (new message% [parent date-panel] [label "        "])
        
        ;; Create date text editor (read-only but can display gray)
        (define date-text (new text%))
        (send date-text insert due-date)
        
        ;; Set to light gray
        (let ([delta (new style-delta%)])
          (send delta set-delta-foreground (make-object color% 130 130 130))
          (send delta set-size-mult 0.9)
          (send date-text change-style delta 0 (send date-text last-position)))
        
        ;; Use editor-canvas to display date
        (set! date-label
              (new editor-canvas% 
                   [parent date-panel] 
                   [editor date-text] 
                   [style '(no-border no-hscroll no-vscroll transparent)] 
                   [min-height 20] 
                   [stretchable-width #f]))
        
        ;; Set to read-only
        (send date-text lock #t))
      
      ;; Reorder children: First row -> Notes -> Date
      (send this change-children
            (lambda (children)
              (filter values 
                      (list first-row notes-panel date-panel))))
      )
    
    ;; Update text style based on checked state
    (define/public (update-text-style)
      (send text-obj begin-edit-sequence)
      (let ([end (send text-obj last-position)])
        (if checked?
            ;; Checked: gray + italic
            (let ([delta (new style-delta%)])
              (send delta set-delta-foreground "gray")
              (send delta set-style-on 'italic)
              (send text-obj change-style delta 0 end))
            
            ;; Unchecked: reset to Standard
            (let ([std (send (send text-obj get-style-list) find-named-style "Standard")])
              (send text-obj change-style std 0 end))))
      (send text-obj end-edit-sequence)
      )
    
    ;; Public methods
    (define/public (get-text)
      (send text-obj get-text))
    
    (define/public (get-checked)
      (send checkbox get-checked))
    
    (define/public (get-due-date)
      due-date)
    
    (define/public (get-notes)
      notes)
    
    (define/public (set-text txt)
      (send text-obj begin-edit-sequence)
      (send text-obj erase)
      (send text-obj insert txt)
      (send text-obj end-edit-sequence)
      (update-text-style))
    
    (define/public (set-checked val)
      (send checkbox set-checked! val)
      (set! checked? val)
      (update-text-style))
    
    ;; Initialize style
    (update-text-style)
    ))

;; ============================================================;
;; 4. Todo List Manager Widget;
;; ============================================================;
(define todo-list%
  (class vertical-panel%
    (init-field [on-change (lambda (items) (void))] [min-height 200])
    
    (super-new [border 10]
               [style '(auto-vscroll)]
               [stretchable-height #t]
               [min-height min-height])
    
    (define items '())
    
    ;; Add task
    (define/public (add-item text [checked #f] [due-date #f] [notes ""])
      (define item
        (new todo-item%
             [parent this]
             [task-text text]
             [checked? checked]
             [due-date due-date]
             [notes notes]
             [on-delete (lambda () (remove-item item))]
             [on-change (lambda (txt chk date note) (notify-change))]))
      (set! items (append items (list item)))
      (notify-change)
      item)
    
    ;; Remove task
    (define/private (remove-item item)
      (send this delete-child item)
      (set! items (remove item items))
      (notify-change))
    
    ;; Get all tasks data
    (define/public (get-all-tasks)
      (for/list ([item items])
        (list (send item get-text) 
              (send item get-checked)
              (send item get-due-date)
              (send item get-notes))))
    
    ;; Clear completed tasks
    (define/public (clear-completed)
      (define completed (filter (lambda (item) (send item get-checked)) items))
      (for ([item completed])
        (remove-item item)))
    
    ;; Notify change
    (define/private (notify-change)
      (on-change (get-all-tasks)))
    ))
