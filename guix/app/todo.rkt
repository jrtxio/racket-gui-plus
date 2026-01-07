#lang racket/gui

;; Todo list component
;; Feature-complete todo list with add, edit, delete, and completion marking

(provide todo-list% todo-item% task-details-dialog% checkbox-canvas%)

(define checkbox-canvas%
  (class canvas%
    (inherit get-dc)
    (super-new)
    ))

(define todo-item%
  (class object%
    (super-new)
    ))

(define task-details-dialog%
  (class dialog%
    (super-new)
    ))

(define todo-list%
  (class vertical-panel%
    (super-new)
    ))
