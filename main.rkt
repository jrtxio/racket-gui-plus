#lang racket/gui

;; 包根目录的main.rkt，用于将(require racket-gui-plus)请求转发到正确位置
;; 这是一个临时解决方案，确保包能正常导入

(require "racket-gui-plus/main.rkt")

;; 导出所有从racket-gui-plus/main.rkt导入的内容
(provide (all-from-out "racket-gui-plus/main.rkt"))
