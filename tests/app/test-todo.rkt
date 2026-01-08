#lang racket/gui

;; Unit tests for Todo components

(require rackunit
         racket/class
         racket/draw
         racket/gui/base
         "../../guix/app/todo.rkt")

;; ============================================================;
;; Test checkbox-canvas%;
;; ============================================================;
(test-case "checkbox-canvas% - basic functionality"
  (let* ([frame (new frame% [label "Test Frame"] [width 100] [height 100])]
         [panel (new vertical-panel% [parent frame])]
         [called? #f]
         [checkbox (new checkbox-canvas% 
                       [parent panel] 
                       [checked? #f] 
                       [on-change (lambda (val) (set! called? #t))])])
    
    ;; Test initial state
    (check-false (send checkbox get-checked) "Initial state should be unchecked")
    
    ;; Test setting checked state programmatically
    (send checkbox set-checked #t)
    (check-true (send checkbox get-checked) "Should be able to set checked state programmatically")
    
    (send checkbox set-checked #f)
    (check-false (send checkbox get-checked) "Should be able to set unchecked state programmatically")
    
    (send frame show #f)))

;; ============================================================;
;; Test todo-item%;
;; ============================================================;
(test-case "todo-item% - basic functionality"
  (let* ([frame (new frame% [label "Test Frame"] [width 300] [height 200])]
         [panel (new vertical-panel% [parent frame])]
         [called? #f]
         [item (new todo-item% 
                    [parent panel] 
                    [task-text "Test Task"] 
                    [on-change (lambda (text checked date notes) (set! called? #t))])])
    
    ;; Test initial state
    (check-equal? (send item get-text) "Test Task" "Initial text should be set correctly")
    (check-false (send item get-checked) "Initial state should be unchecked")
    (check-false (send item get-due-date) "Initial due date should be #f")
    (check-equal? (send item get-notes) "" "Initial notes should be empty string")
    
    ;; Test setting text
    (send item set-text "Updated Task")
    (check-equal? (send item get-text) "Updated Task" "Should be able to update text programmatically")
    
    ;; Test setting checked state
    (send item set-checked #t)
    (check-true (send item get-checked) "Should be able to set checked state programmatically")
    
    (send item set-checked #f)
    (check-false (send item get-checked) "Should be able to set unchecked state programmatically")
    
    (send frame show #f)))

;; ============================================================;
;; Test todo-list%;
;; ============================================================;
(test-case "todo-list% - basic functionality"
  (let* ([frame (new frame% [label "Test Frame"] [width 300] [height 200])]
         [panel (new vertical-panel% [parent frame])]
         [called? #f]
         [todo-list (new todo-list% 
                        [parent panel] 
                        [on-change (lambda (items) (set! called? #t))])])
    
    ;; Test initial state
    (check-equal? (length (send todo-list get-all-tasks)) 0 "Initial todo list should be empty")
    
    ;; Test adding items
    (send todo-list add-item "Task 1")
    (check-equal? (length (send todo-list get-all-tasks)) 1 "Should be able to add items")
    
    (send todo-list add-item "Task 2" #t)
    (check-equal? (length (send todo-list get-all-tasks)) 2 "Should be able to add multiple items")
    
    ;; Test clear-completed
    (send todo-list clear-completed)
    (check-equal? (length (send todo-list get-all-tasks)) 1 "Should be able to clear completed tasks")
    
    (send frame show #f)))

;; ============================================================;
;; Test todo-list% with complex items;
;; ============================================================;
(test-case "todo-list% - complex items"
  (let* ([frame (new frame% [label "Test Frame"] [width 300] [height 200])]
         [panel (new vertical-panel% [parent frame])]
         [todo-list (new todo-list% [parent panel])])
    
    ;; Add item with all parameters
    (send todo-list add-item "Complex Task" #f "2024-12-31" "Test notes")
    
    (let ([tasks (send todo-list get-all-tasks)])
      (check-equal? (length tasks) 1 "Should have one complex task")
      (check-equal? (first (first tasks)) "Complex Task" "Task text should be correct")
      (check-false (second (first tasks)) "Task should be unchecked")
      (check-equal? (third (first tasks)) "2024-12-31" "Due date should be set correctly")
      (check-equal? (fourth (first tasks)) "Test notes" "Notes should be set correctly"))
    
    (send frame show #f)))


