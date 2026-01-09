#lang racket/gui

;; Guix - Modern Racket GUI Widget Library
;; Light theme preset

(require racket/class
         racket/hash
         "../colors.rkt"
         "../typography.rkt")

;; ===========================
;; Light Theme Definition
;; ===========================

;; Define theme directly without using macro to avoid circular dependency
(define light-theme
  (hash 'name "light"
        'colors light-colors
        'metrics (hash 'corner-radius 2      ;; Small radius or square (technical limitation)
                      'padding 8
                      'spacing 8
                      'border-width 1)
        'typography (make-typography-config)))

;; ===========================
;; Export
;; ===========================
(provide
 light-theme)