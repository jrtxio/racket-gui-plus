#lang racket/gui

;; Guix - Modern Racket GUI Widget Library
;; Color definitions for theme system

(require racket/class)

;; ===========================
;; Color Palette
;; ===========================

;; Light theme colors
(define light-colors
  (hash
   ;; Background colors
   'background "#FFFFFF"
   'background-light "#F2F2F7"
   'background-overlay "#FFFFFF95"
   'background-hover "#E5E5EA"
   'background-pressed "#D1D1D6"
   
   ;; Border colors
   'border "#D1D1D6"
   'border-hover "#C7C7CC"
   'border-focus "#007AFF"
   'border-disabled "#E5E5EA"
   
   ;; Text colors
   'text-main "#2C2C2E"
   'text-light "#646464"
   'text-placeholder "#A0A0A0"
   'text-disabled "#C7C7CC"
   
   ;; Functional colors
   'accent "#007AFF"
   'accent-hover "#0051D5"
   'accent-pressed "#003A9E"
   'success "#34C759"
   'success-hover "#28A745"
   'error "#FF3B30"
   'error-hover "#D70015"
   'warning "#FF9500"
   'warning-hover "#FF6B35"
   'info "#5AC8FA"
   'info-hover "#34AADC"
   
   ;; Surface colors
   'surface "#FFFFFF"
   'surface-light "#F2F2F7"
   'surface-dark "#E5E5EA"
   
   ;; Shadow colors
   'shadow-light "#00000010"
   'shadow-medium "#00000020"
   'shadow-heavy "#00000030"))

;; Dark theme colors
(define dark-colors
  (hash
   ;; Background colors
   'background "#1C1C1E"
   'background-light "#2C2C2E"
   'background-overlay "#1C1C1E95"
   'background-hover "#3A3A3C"
   'background-pressed "#48484A"
   
   ;; Border colors
   'border "#3C3C3E"
   'border-hover "#48484A"
   'border-focus "#007AFF"
   'border-disabled "#3C3C3E"
   
   ;; Text colors
   'text-main "#FFFFFF"
   'text-light "#AEAEB2"
   'text-placeholder "#8E8E93"
   'text-disabled "#636366"
   
   ;; Functional colors
   'accent "#007AFF"
   'accent-hover "#3498DB"
   'accent-pressed "#2980B9"
   'success "#34C759"
   'success-hover "#2ECC71"
   'error "#FF3B30"
   'error-hover "#E74C3C"
   'warning "#FF9500"
   'warning-hover "#F39C12"
   'info "#5AC8FA"
   'info-hover "#3498DB"
   
   ;; Surface colors
   'surface "#1C1C1E"
   'surface-light "#2C2C2E"
   'surface-dark "#3A3A3C"
   
   ;; Shadow colors
   'shadow-light "#FFFFFF10"
   'shadow-medium "#FFFFFF20"
   'shadow-heavy "#FFFFFF30"))

;; ===========================
;; Color Helper Functions
;; ===========================

;; Convert hex string to color object
(define (hex->color hex [alpha 1.0])
  (define (hex->int s)
    (string->number (string-append "#x" s)))
  
  (let* ([hex (if (string-prefix? hex "#") (substring hex 1) hex)]
         [r (hex->int (substring hex 0 2))]
         [g (hex->int (substring hex 2 4))]
         [b (hex->int (substring hex 4 6))]
         [hex-alpha (if (= (string-length hex) 8) (hex->int (substring hex 6 8)) 255)]
         [final-alpha (* (/ hex-alpha 255.0) alpha)])
    (make-object color% r g b final-alpha)))

;; Get color from palette
(define (get-color palette color-name)
  (if (hash-has-key? palette color-name)
      (hex->color (hash-ref palette color-name))
      (error "Color not found: ~a" color-name)))

;; Get color with alpha transparency
(define (get-color-with-alpha palette color-name alpha)
  (let ([color (get-color palette color-name)])
    (make-object color% 
                 (send color red) 
                 (send color green) 
                 (send color blue) 
                 alpha)))

;; ===========================
;; Export
;; ===========================
(provide
 ;; Color palettes
 light-colors dark-colors
 
 ;; Color helper functions
 hex->color get-color get-color-with-alpha)