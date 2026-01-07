#lang racket/gui

;; Text field component
;; Modern single-line text input with customizable styles
;; Also provides modern-input% as an alias for backward compatibility

(provide text-field% (rename-out [text-field% modern-input%]))

(define text-field%
