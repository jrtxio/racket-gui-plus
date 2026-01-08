#lang racket/gui

;; Task Item Component Tests
;; Using Racket's rackunit test framework

(require rackunit
         racket/class
         racket/draw
         "../../../guix/extended/task-item.rkt"
         "../../../guix/style/config.rkt")

;; Create a simple test frame
(define test-frame
  (new frame% 
       [label "Task Item Test Frame"]
       [width 400]
       [height 300]
       [style '(no-resize-border)]))

;; Show test frame
(send test-frame show #t)

;; Test suite
(define task-item-tests
  (test-suite
   "task-item% Tests"
   
   ;; Test 1: Basic Creation and Properties
   (test-case "Basic Creation and Properties" 
     (define task-item
       (new task-item% 
            [parent test-frame]
            [task-text "Test Task"]
            [checked? #f]
            [due-date "2023-12-31"]
            [notes "Test Notes"]
            [on-change (λ (text checked date note) (void))]))
     
     (check-true (is-a? task-item task-item%) "Should be an instance of task-item%")
     (check-equal? (send task-item get-text) "Test Task" "Task text should be 'Test Task'")
     (check-equal? (send task-item get-checked) #f "Task should be unchecked by default")
     (check-equal? (send task-item get-due-date) "2023-12-31" "Due date should be '2023-12-31'")
     (check-equal? (send task-item get-notes) "Test Notes" "Notes should be 'Test Notes'")
     )
   
   ;; Test 2: Text Getting and Setting
   (test-case "Text Getting and Setting" 
     (define task-item
       (new task-item% 
            [parent test-frame]
            [on-change (λ (text checked date note) (void))]))
     
     (send task-item set-text "New Task Text")
     (check-equal? (send task-item get-text) "New Task Text" "Task text should be updated after set-text")
     )
   
   ;; Test 3: Checked State Getting and Setting
   (test-case "Checked State Getting and Setting" 
     (define task-item
       (new task-item% 
            [parent test-frame]
            [on-change (λ (text checked date note) (void))]))
     
     (send task-item set-checked #t)
     (check-equal? (send task-item get-checked) #t "Task should be checked after set-checked #t")
     
     (send task-item set-checked #f)
     (check-equal? (send task-item get-checked) #f "Task should be unchecked after set-checked #f")
     )
   
   ;; Test 4: Due Date and Notes Getting and Setting
   (test-case "Due Date and Notes Getting and Setting" 
     (define task-item
       (new task-item% 
            [parent test-frame]
            [on-change (λ (text checked date note) (void))]))
     
     (send task-item set-due-date "2024-01-01")
     (check-equal? (send task-item get-due-date) "2024-01-01" "Due date should be updated after set-due-date")
     
     (send task-item set-notes "Updated Notes")
     (check-equal? (send task-item get-notes) "Updated Notes" "Notes should be updated after set-notes")
     )
   
   ;; Test 5: Callback Function
   (test-case "Callback Function" 
     (define callback-called #f)
     (define callback-text #f)
     (define callback-checked #f)
     (define callback-date #f)
     (define callback-note #f)
     
     (define task-item
       (new task-item% 
            [parent test-frame]
            [on-change (λ (text checked date note) 
                        (set! callback-called #t)
                        (set! callback-text text)
                        (set! callback-checked checked)
                        (set! callback-date date)
                        (set! callback-note note))]))
     
     ;; Trigger callback by setting text
     (send task-item set-text "Callback Test")
     
     (check-true callback-called "Callback should be called when task text changes")
     (check-equal? callback-text "Callback Test" "Callback should receive the correct text")
     (check-equal? callback-checked #f "Callback should receive the correct checked state")
     )
   
   ;; Test 6: Theme Response
   (test-case "Theme Response" 
     (define task-item
       (new task-item% 
            [parent test-frame]
            [on-change (λ (text checked date note) (void))]))
     
     ;; Save current theme
     (define original-theme (current-theme))
     
     ;; Switch to dark theme
     (set-theme! 'dark)
     ;; Verify theme has switched
     (check-equal? (current-theme) dark-theme "Theme should be dark")
     
     ;; Switch back to light theme
     (set-theme! 'light)
     (check-equal? (current-theme) light-theme "Theme should be light")
     )
   ))

;; Run tests
(require rackunit/text-ui)
(run-tests task-item-tests)

;; Close test frame
(send test-frame show #f)