#lang racket

(require racket/file)

;; List of demo files to check
(define demo-files
  '("examples/button-demo.rkt"
    "examples/checkbox-demo.rkt"
    "examples/radio-button-demo.rkt"
    "examples/text-field-demo.rkt"
    "examples/icon-demo.rkt"
    "examples/label-demo.rkt"
    "examples/editable-text-demo.rkt"
    "examples/slider-demo.rkt"
    "examples/stepper-demo.rkt"
    "examples/switch-demo.rkt"
    "examples/text-area-demo.rkt"))

;; Check syntax for each file
(for ([file demo-files])
  (displayln (format "Checking syntax for: ~a" file))
  (with-handlers ([exn:fail? (λ (e) (displayln (format "  ERROR: ~a" e)))])
    (with-input-from-file file
      (λ ()
        (let loop ()
          (let ([expr (read)])
            (unless (eof-object? expr)
              (loop)))))))
  (displayln "  OK")
  (newline))
