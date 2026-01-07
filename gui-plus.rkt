#lang racket/gui

;; GUI Plus - 增强的Racket GUI控件库
;; 提供苹果风格的现代化UI控件集合
;; 支持主题切换和全局刷新

;; 导入样式配置和主题功能
(require "style-config.rkt")

;; ===========================
;; 导入原子控件
;; ===========================
(require "atomic/button.rkt")
(require "atomic/label.rkt")
(require "atomic/text-field.rkt")
(require "atomic/text-area.rkt")
(require "atomic/switch.rkt")
(require "atomic/checkbox.rkt")
(require "atomic/radio-button.rkt")
(require "atomic/slider.rkt")
(require "atomic/stepper.rkt")
(require "atomic/icon.rkt")

;; ===========================
;; 导入复合控件
;; ===========================
(require "composite/filter-button.rkt")
;(require "composite/input.rkt") ; 已迁移到 atomic/text-field.rkt
(require "composite/input-field.rkt")
(require "composite/progress-bar.rkt")
(require "composite/search-field.rkt")
(require "composite/stepper-input.rkt")
(require "composite/segmented-control.rkt")

;; ===========================
;; 导入容器控件
;; ===========================
(require "container/custom-list-box.rkt")
(require "container/side-panel.rkt")
(require "container/sidebar-list.rkt")
(require "container/split-view.rkt")
(require "container/tab-view.rkt")
(require "container/scroll-view.rkt")
(require "container/stack-view.rkt")

;; ===========================
;; 导入应用控件
;; ===========================
(require "app/calendar.rkt")
(require "app/time-picker.rkt")
(require "app/toast-info.rkt")
(require "app/todo.rkt")
(require "app/date-time-picker.rkt")
(require "app/table-view.rkt")
(require "app/alert.rkt")
(require "app/menu.rkt")

;; ===========================
;; 主题切换功能由 style-config.rkt 提供
;; ===========================

;; ===========================
;; 导出所有公共接口
;; ===========================

;; 导出主题相关功能
(provide (all-from-out "style-config.rkt"))
(provide register-widget unregister-widget refresh-all-widgets)

;; 导出原子控件
(provide (all-from-out "atomic/button.rkt"))
(provide (all-from-out "atomic/label.rkt"))
(provide (all-from-out "atomic/text-field.rkt"))
(provide (all-from-out "atomic/text-area.rkt"))
(provide (all-from-out "atomic/switch.rkt"))
(provide (all-from-out "atomic/checkbox.rkt"))
(provide (all-from-out "atomic/radio-button.rkt"))
(provide (all-from-out "atomic/slider.rkt"))
(provide (all-from-out "atomic/stepper.rkt"))
(provide (all-from-out "atomic/icon.rkt"))

;; 导出复合控件
(provide (all-from-out "composite/filter-button.rkt"))
;(provide (all-from-out "composite/input.rkt")) ; 已迁移到 atomic/text-field.rkt
(provide (all-from-out "composite/input-field.rkt"))
(provide (all-from-out "composite/progress-bar.rkt"))
(provide (all-from-out "composite/search-field.rkt"))
(provide (all-from-out "composite/stepper-input.rkt"))
(provide (all-from-out "composite/segmented-control.rkt"))

;; 导出容器控件
(provide (all-from-out "container/custom-list-box.rkt"))
(provide (all-from-out "container/side-panel.rkt"))
(provide (all-from-out "container/sidebar-list.rkt"))
(provide (all-from-out "container/split-view.rkt"))
(provide (all-from-out "container/tab-view.rkt"))
(provide (all-from-out "container/scroll-view.rkt"))
(provide (all-from-out "container/stack-view.rkt"))

;; 导出应用控件
(provide (all-from-out "app/calendar.rkt"))
(provide (all-from-out "app/time-picker.rkt"))
(provide (all-from-out "app/toast-info.rkt"))
(provide (all-from-out "app/todo.rkt"))
(provide (all-from-out "app/date-time-picker.rkt"))
(provide (all-from-out "app/table-view.rkt"))
(provide (all-from-out "app/alert.rkt"))
(provide (all-from-out "app/menu.rkt"))

;; 导出具体控件类
(provide 
         ;; 原子控件
         text-field%
         modern-input% ; 别名，保持向后兼容
         
         ;; 复合控件
         filter-button%
         modern-progress-bar%
         
         ;; 容器控件
         modern-sidebar% ; 原 custom-list-box.rkt 实际导出的是 modern-sidebar%
         sidebar-list%
         list-item
         
         ;; 应用控件
         calendar%
         time-picker%
         modern-toast%
         show-toast
         checkbox-canvas%
         task-details-dialog%
         todo-item%
         todo-list%)
