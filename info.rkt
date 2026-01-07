#lang info

(define name "racket-gui-plus")
(define version "1.0.0")
(define description "Racket GUI 增强控件库，提供现代化的苹果风格 UI 控件")
(define dependencies '((racket "8.0") (racket/gui "1.0")))
(define author "Your Name")
(define license "MIT")
(define homepage "https://github.com/yourusername/racket-gui-plus")
(define scribblings '((lib "scribblings/racket-gui-plus.scrbl" "racket-gui-plus")))

;; 配置包的集合映射
(define collection-links
  `(("racket-gui-plus" ,(build-path "racket-gui-plus"))))
