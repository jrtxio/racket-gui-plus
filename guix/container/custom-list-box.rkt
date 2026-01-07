#lang racket/gui

;; Custom list box component
;; Modern sidebar component with customizable items
;; Also provides modern-sidebar% as the main export

(provide modern-sidebar% sidebar-item-data)

(define sidebar-item-data
  (class object%
    (super-new)
    ))

(define modern-sidebar%
