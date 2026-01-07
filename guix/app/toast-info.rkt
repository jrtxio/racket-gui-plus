#lang racket/gui

;; Toast info component
;; Lightweight toast notification for displaying temporary messages
;; Also provides show-toast as a convenience function

(provide modern-toast% show-toast)

(define modern-toast%
  (class object%
    (super-new)
    ))

(define (show-toast parent message duration)
  ;; Show toast notification
  )
