#lang racket/gui

;; (require racket-gui-plus) 入口文件
;; 从 gui-plus.rkt 导出所有公共接口

(require "gui-plus.rkt")

;; 导出所有从 gui-plus.rkt 导入的内容
(provide (all-from-out "gui-plus.rkt"))
