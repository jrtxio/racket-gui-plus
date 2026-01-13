#lang racket/gui

;; Todo Item Demo
;; Demonstrates the usage of the todo-item% widget

(require racket/draw
         "../guix/guix.rkt")

;; ===========================
;; Main Window
;; ===========================
(define frame (new frame%
                   [label "Todo Item Demo"]
                   [width 500]
                   [height 400]))

;; Main panel
(define main-panel (new vertical-panel%
                        [parent frame]
                        [border 20]
                        [spacing 10]))

;; Title
(new message%
     [parent main-panel]
     [label "Todo Items"]
     [font (make-object font% 16 'default 'normal 'bold)])

;; ===========================
;; Todo Item Examples
;; ===========================

;; Example 1: Basic todo item
(new message%
     [parent main-panel]
     [label "\n1. Basic Todo Item:"]
     [font (make-object font% 12 'default 'normal 'bold)])

(define todo1 (new todo-item%
                   [parent main-panel]
                   [task-text "Write a Racket program"]
                   [checked? #f]
                   [on-click (λ () (printf "Todo 1 clicked!\n"))]
                   [on-toggle (λ (val) (printf "Todo 1 toggled to: ~a\n" val))]
                   [on-settings (λ () (printf "Todo 1 settings clicked!\n"))]))

;; Example 2: Checked todo item
(new message%
     [parent main-panel]
     [label "\n2. Checked Todo Item:"]
     [font (make-object font% 12 'default 'normal 'bold)])

(define todo2 (new todo-item%
                   [parent main-panel]
                   [task-text "Complete homework assignment"]
                   [checked? #t]
                   [on-click (λ () (printf "Todo 2 clicked!\n"))]
                   [on-toggle (λ (val) (printf "Todo 2 toggled to: ~a\n" val))]
                   [on-settings (λ () (printf "Todo 2 settings clicked!\n"))]))

;; Example 3: Todo item with due date
(new message%
     [parent main-panel]
     [label "\n3. Todo Item with Due Date:"]
     [font (make-object font% 12 'default 'normal 'bold)])

(define todo3 (new todo-item%
                   [parent main-panel]
                   [task-text "Submit project proposal"]
                   [checked? #f]
                   [due-date "2026-01-20"]
                   [on-click (λ () (printf "Todo 3 clicked!\n"))]
                   [on-toggle (λ (val) (printf "Todo 3 toggled to: ~a\n" val))]
                   [on-settings (λ () (printf "Todo 3 settings clicked!\n"))]))

;; Example 4: Long text todo item
(new message%
     [parent main-panel]
     [label "\n4. Long Text Todo Item:"]
     [font (make-object font% 12 'default 'normal 'bold)])

(define todo4 (new todo-item%
                   [parent main-panel]
                   [task-text "This is a very long todo item that should demonstrate how text overflow is handled with ellipsis"]
                   [checked? #f]
                   [on-click (λ () (printf "Todo 4 clicked!\n"))]
                   [on-toggle (λ (val) (printf "Todo 4 toggled to: ~a\n" val))]
                   [on-settings (λ () (printf "Todo 4 settings clicked!\n"))]))

;; ===========================
;; Control Panel
;; ===========================
(new message%
     [parent main-panel]
     [label "\n5. Control Panel:"]
     [font (make-object font% 12 'default 'normal 'bold)])

(define control-panel (new horizontal-panel%
                           [parent main-panel]
                           [spacing 10]))

;; Button to update todo 1
(new button%
     [parent control-panel]
     [label "Update Todo 1"]
     [on-click (λ ()
                 (send todo1 set-text "Updated todo item text")
                 (send todo1 set-due-date "2026-01-25"))])

;; Button to toggle todo 2
(new button%
     [parent control-panel]
     [label "Toggle Todo 2"]
     [on-click (λ ()
                 (send todo2 set-checked (not (send todo2 get-checked))))])

;; Button to clear todo 3
(new button%
     [parent control-panel]
     [label "Clear Todo 3 Date"]
     [on-click (λ ()
                 (send todo3 set-due-date #f))])

;; ===========================
;; Show the window
;; ===========================
(send frame show #t)

;; ===========================
;; Usage Instructions
;; ===========================
(printf "Todo Item Demo Instructions:\n")
(printf "1. Click the checkbox to toggle completion status\n")
(printf "2. Click the task text to activate the item\n")
(printf "3. Click the '⋯' button on the right to open settings\n")
(printf "4. Use the control panel buttons to modify todo items\n")
