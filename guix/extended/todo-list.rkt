#lang racket/gui

;; Todo List Component
;; Modern todo list widget with editable items

(require racket/class
         racket/draw
         "task-item.rkt"
         "../style/config.rkt")

(provide todo-list%
         guix-todo-list%)

(define todo-list%
  (class vertical-panel%
    (init-field [parent #f]
                [on-change (lambda (items) (void))])
    
    (super-new [parent parent]
               [alignment '(left top)]
               [stretchable-height #t]
               [stretchable-width #t]
               [spacing 5])
    
    ;; Instance variables
    (define task-items '())
    
    ;; Update callback wrapper
    (define (notify-change)
      (on-change task-items))
    
    ;; Create a task item and add it to the list
    (define (create-task-item text [checked #f] [due-date #f] [notes ""])
      (define task-item
        (new task-item%
             [parent this]
             [task-text text]
             [checked? checked]
             [due-date due-date]
             [notes notes]
             [on-change (lambda (updated-text updated-checked updated-date updated-notes)
                         ;; Update the item in the list
                         (for ([item (in-list task-items)])
                           (when (eq? item task-item)
                             ;; We don't need to update the list since we're modifying the object in place
                             (void)))
                         (notify-change))]))
      task-item)
    
    ;; Public methods
    (define/public (add-item text [checked #f] [due-date #f] [notes ""])
      (define new-item (create-task-item text checked due-date notes))
      (set! task-items (append task-items (list new-item)))
      (notify-change)
      new-item)
    
    (define/public (remove-item item)
      (set! task-items (remove item task-items))
      (send item destroy)
      (notify-change))
    
    (define/public (get-items)
      task-items)
    
    (define/public (get-count)
      (length task-items))
    
    (define/public (clear-items)
      (for-each (lambda (item) (send item destroy)) task-items)
      (set! task-items '())
      (notify-change))
    
    (define/override (refresh)
      (super refresh)
      (for-each (lambda (item) (send item refresh)) task-items))
    
    ))

;; New guix-todo-list% with updated naming convention
(define guix-todo-list% todo-list%)