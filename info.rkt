#lang info

(define name "guix")
(define version "0.0.1")
(define description "Modern desktop widget library based on racket/gui, providing cross-platform consistent GUI controls")
(define dependencies '((racket "8.0") (racket/gui "1.0")))
(define author "jrtxio")
(define license 'MIT)
(define homepage "https://github.com/jrtxio/guix")
(define scribblings '((lib "scribblings/guix.scrbl" "guix")))

;; Configure package collection mapping
(define collection-links
  `(("guix" ,(build-path "guix"))))
