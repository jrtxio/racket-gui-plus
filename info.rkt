#lang info

(define name "guix")
(define version "1.0.0")
(define description "基于 racket/gui 的现代桌面控件库，提供跨平台一致行为的 GUI 控件")
(define dependencies '((racket "8.0") (racket/gui "1.0")))
(define author "jrtxio")
(define license "MIT")
(define homepage "https://github.com/jrtxio/guix")
(define scribblings '((lib "scribblings/guix.scrbl" "guix")))

;; Configure package collection mapping
(define collection-links
  `(("guix" ,(build-path "guix"))))
