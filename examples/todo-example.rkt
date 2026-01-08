#lang racket/gui
(require "../guix/guix.rkt")

;; Todo Example - Using the new task-item% component

(define (main)
  (define frame (new frame% [label "Task List Example"] [width 600] [height 500]))
  
  ;; Main panel with vertical layout
  (define main-panel (new vertical-panel% [parent frame] [border 15] [spacing 10]))
  
  ;; Title
  (new label% [parent main-panel] [label "Task List"] [font-size 'large] [font-weight 'bold])
  
  ;; Task list container
  (define tasks-panel (new vertical-panel% [parent main-panel] 
                                          [min-height 300]
                                          [stretchable-height #t]
                                          [spacing 8]))
  
  ;; List to track all task items
  (define all-tasks '())
  
  ;; Task change callback
  (define (on-task-change text checked date notes)
    (printf "Task changed: ~a, ~a, ~a, ~a\n" text checked date notes))
  
  ;; Function to add a new task item
  (define (add-task-item title checked due-date notes)
    (define task-item
      (new task-item% [parent tasks-panel]
                      [task-text title]
                      [checked? checked]
                      [due-date due-date]
                      [notes notes]
                      [on-change on-task-change]))
    (set! all-tasks (append all-tasks (list task-item)))
    task-item)
  
  ;; Function to clear completed tasks
  (define (clear-completed-tasks)
    (for ([task (filter (lambda (t) (send t get-checked)) all-tasks)])
      (send tasks-panel delete-child task)
      (set! all-tasks (remove task all-tasks))))
  
  ;; Input panel for adding new tasks
  (define input-panel (new vertical-panel% [parent main-panel] [spacing 5]))
  (new label% [parent input-panel] [label "Add New Task"] [font-size 'medium] [font-weight 'bold])
  
  ;; Task title input
  (define title-field (new text-field% [parent input-panel] [label "Title:"] [stretchable-width #t] [init-value "New Task"]))
  
  ;; Task notes input
  (define notes-field (new text-field% [parent input-panel] [label "Notes:"] [stretchable-width #t] [init-value ""]))
  
  ;; Task date input
  (define date-field (new text-field% [parent input-panel] [label "Due Date:"] [stretchable-width #t] [init-value ""]))
  
  ;; Add button callback
  (define (add-button-callback btn evt)
    (let ([title (send title-field get-text)]
          [notes (send notes-field get-text)]
          [due-date (send date-field get-text)])
      (when (not (string=? title ""))
        (add-task-item title #f due-date notes)
        (send title-field set-text "New Task")
        (send notes-field set-text "")
        (send date-field set-text ""))))
  
  ;; Button panel
  (define button-panel (new horizontal-panel% [parent input-panel] [spacing 5]))
  
  ;; Add button
  (new button% [parent button-panel] [label "Add Task"] [callback add-button-callback])
  
  ;; Clear completed button
  (new button% [parent button-panel] 
               [label "Clear Completed"] 
               [callback (lambda (btn evt) (clear-completed-tasks))])
  
  ;; Load sample data
  (add-task-item "Learn Racket" #f "2026-01-15" "Study basic syntax and concepts")
  (add-task-item "Build GUI with Guix" #t "2026-01-22" "Create a sample application")
  (add-task-item "Create documentation" #f "2026-01-30" "Write comprehensive docs")
  
  (send frame show #t))

(main)
