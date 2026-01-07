#lang racket/gui

;; Sidebar list component
;; Modern sidebar list with customizable items

(provide sidebar-list% list-item)

(define list-item
  (class object%
    (super-new)
    ))

(define sidebar-list%
