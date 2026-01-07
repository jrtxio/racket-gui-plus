#lang racket/gui

;; 包根目录的main.rkt，用于将(require guix)请求转发到正确位置

(require "guix/guix.rkt")

;; 导出所有从guix/guix.rkt导入的内容
(provide (all-from-out "guix/guix.rkt"))
