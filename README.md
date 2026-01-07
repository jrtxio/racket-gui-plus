<div align="center">
  <h1>Guix</h1>
  <p>📱 Modern Desktop Widget Library for racket/gui</p>
  
  <!-- GitHub Badges -->
  <div style="margin: 1rem 0;">
    <a href="https://github.com/yourusername/guix/blob/main/LICENSE"><img src="https://img.shields.io/github/license/yourusername/guix.svg" alt="License"></a>
    <a href="https://github.com/yourusername/guix/stargazers"><img src="https://img.shields.io/github/stars/yourusername/guix.svg?style=social" alt="GitHub Stars"></a>
    <a href="https://github.com/yourusername/guix/forks"><img src="https://img.shields.io/github/forks/yourusername/guix.svg?style=social" alt="GitHub Forks"></a>
    <a href="https://github.com/yourusername/guix"><img src="https://img.shields.io/badge/GitHub-Project-blue.svg" alt="GitHub Project"></a>
    <a href="README.md"><img src="https://img.shields.io/badge/Language-English-blue.svg" alt="English"></a>
    <a href="README.zh-CN.md"><img src="https://img.shields.io/badge/%E8%AF%AD%E8%A8%80-%E4%B8%AD%E6%96%87-gray.svg" alt="中文"></a>
  </div>
</div>

Guix is a modern desktop widget library built on `racket/gui`, providing cross-platform consistent GUI widgets with theming support, composite widgets, and customizable styles, suitable for macOS, Windows, and Linux.

## Widget List

### 1. Calendar Widget (calendar%)
Modern month-view calendar with date selection functionality.

### 2. Sidebar Widget (modern-sidebar%)
Modern sidebar with customizable items and hierarchical structure.

### 3. Filter Button Widget (filter-button%)
Button group for filtering with exclusive selection support.

### 4. Text Field Widget (text-field%)
Modern single-line text input with customizable styles.

### 5. Toast Notification Widget (modern-toast%)
Lightweight toast notification for displaying temporary messages.

### 6. Todo List Widget (todo-list%)
Feature-complete todo list with add, edit, delete, and completion marking.

## Installation

Install Guix widget library using the following command:

```bash
raco pkg install guix
```

## Usage

### Import Library

```racket
#lang racket/gui
(require guix/guix)
```

### Create Window

```racket
(define frame (new frame%
                   [label "Guix Example"]
                   [width 800]
                   [height 600]))
```

### 1. Using Calendar Widget

```racket
(define calendar
  (new calendar%
       [parent frame]
       [callback (lambda (date)
                  (printf "Selected date: ~a~n" date))]))
```

### 2. Using Sidebar Widget

```racket
(define sidebar
  (new modern-sidebar%
       [parent frame]
       [on-select (lambda (item)
                  (printf "Selected item: ~a~n" (send item get-label)))]))

;; Add menu items
(send sidebar add-item (make-apple-item "MenuItem 1" #f))
(send sidebar add-item (make-apple-item "MenuItem 2" #f))
(define submenu (make-apple-item "Submenu" #f))
(send submenu add-item (make-apple-item "Submenu Item 1" #f))
(send sidebar add-item submenu)
```

### 3. Using Filter Button Widget

```racket
(define filter-panel (new horizontal-panel% [parent frame]))

(define filter-btn1
  (new filter-button%
       [parent filter-panel]
       [label "All"]
       [group "filter-group"]
       [selected #t]
       [callback (lambda (btn evt)
                  (when (send btn is-selected?)
                    (printf "Selected: ~a~n" (send btn get-label))))]))

(define filter-btn2
  (new filter-button%
       [parent filter-panel]
       [label "Uncompleted"]
       [group "filter-group"]
       [callback (lambda (btn evt)
                  (when (send btn is-selected?)
                    (printf "Selected: ~a~n" (send btn get-label))))]))
```

### 4. Using Text Field Widget

```racket
(define text-field
  (new text-field%
       [parent frame]
       [label ""]
       [init-value ""]
       [placeholder "Enter content..."]))
```

### 5. Using Toast Notification Widget

```racket
;; Create toast
(define toast
  (new modern-toast%
       [parent frame]))

;; Show toast
(send toast show-toast "Operation successful" 2000)

;; Or use the convenience function
(show-toast frame "Operation successful" 2000)
```

### 6. Using Todo List Widget

```racket
(define todo-list
  (new todo-list%
       [parent frame]
       [on-change (lambda (items)
                   (printf "Task list updated: ~a tasks~n" (length items)))]))

;; Add tasks
(send todo-list add-item "Task 1")
(send todo-list add-item "Task 2" #f "2024-12-31" "Note")

;; Clear completed tasks
(send todo-list clear-completed)
```

## Complete Example

```racket
#lang racket/gui
(require guix/guix)

;; Create main window
(define frame (new frame%
                   [label "Guix Comprehensive Example"]
                   [width 800]
                   [height 600]))

(define main-panel (new horizontal-panel% [parent frame]))

;; Left: Sidebar
(define sidebar-panel (new vertical-panel%
                           [parent main-panel]
                           [stretchable-width #f]
                           [min-width 200]))

(define sidebar
  (new modern-sidebar%
       [parent sidebar-panel]
       [on-select (lambda (item)
                  (printf "Selected item: ~a~n" (send item get-label)))]))

(send sidebar add-item (make-apple-item "Calendar" #f))
(send sidebar add-item (make-apple-item "Todo List" #f))
(send sidebar add-item (make-apple-item "Settings" #f))

;; Right: Main content area
(define content-panel (new vertical-panel% [parent main-panel]))

;; Top: Filter buttons
(define filter-panel (new horizontal-panel%
                         [parent content-panel]
                         [stretchable-height #f]
                         [border 10]))

(new filter-button%
     [parent filter-panel]
     [label "All"]
     [group "example-filter"]
     [selected #t])

(new filter-button%
     [parent filter-panel]
     [label "Uncompleted"]
     [group "example-filter"])

(new filter-button%
     [parent filter-panel]
     [label "Completed"]
     [group "example-filter"])

;; Middle: Calendar widget
(define calendar
  (new calendar%
       [parent content-panel]
       [callback (lambda (date)
                  (printf "Selected date: ~a~n" date))]))

;; Bottom: Input field and add button
(define input-panel (new horizontal-panel%
                         [parent content-panel]
                         [stretchable-height #f]
                         [border 10]))

(define input-field
  (new text-field%
       [parent input-panel]
       [placeholder "Enter content..."]
       [stretchable-width #t]))

(new button%
     [parent input-panel]
     [label "Add"]
     [stretchable-width #f]
     [callback (lambda (btn evt)
                (define text (send input-field get-value))
                (unless (string=? (string-trim text) "")
                  (show-toast frame (format "Added: ~a" text) 1500)
                  (send input-field set-value "")))])

;; Show window
(send frame show #t)
```

## Widget API Reference

### calendar%
- `(new calendar% [parent parent] [callback callback])`
  - `parent`: Parent container
  - `callback`: Date selection callback function

### modern-sidebar%
- `(new modern-sidebar% [parent parent] [on-select on-select])`
  - `parent`: Parent container
  - `on-select`: Item selection callback function
- `(send sidebar add-item item)`: Add menu item

### filter-button%
- `(new filter-button% [parent parent] [label label] [group group] [selected selected] [callback callback])`
  - `parent`: Parent container
  - `label`: Button text
  - `group`: Button group name (exclusive selection within group)
  - `selected`: Whether selected by default
  - `callback`: Click callback function
- `(send btn is-selected?)`: Get selected status
- `(send btn set-selected selected)`: Set selected status

### text-field%
- `(new text-field% [parent parent] [label label] [init-value init-value] [placeholder placeholder])`
  - `parent`: Parent container
  - `label`: Label text
  - `init-value`: Initial value
  - `placeholder`: Placeholder text

### modern-toast%
- `(new modern-toast% [parent parent])`
  - `parent`: Parent container
- `(send toast show-toast message duration)`: Show toast notification
  - `message`: Notification message
  - `duration`: Display duration (milliseconds)

### todo-list%
- `(new todo-list% [parent parent] [on-change on-change])`
  - `parent`: Parent container
  - `on-change`: List change callback function
- `(send todo-list add-item text [completed completed] [due-date due-date] [note note])`: Add task
- `(send todo-list clear-completed)`: Clear completed tasks

## License

This library is licensed under the MIT License. You can freely use, modify, and distribute it.

## Contributions

Welcome to submit issue reports and improvement suggestions!
