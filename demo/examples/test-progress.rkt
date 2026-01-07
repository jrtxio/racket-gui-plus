#lang racket/gui

(define simple-progress-bar%
  (class canvas%
    (super-new)
    (define/override (on-paint)
      (define dc (send this get-dc))
      (send dc draw-rectangle 0 0 100 20))
    ))

(provide simple-progress-bar%)