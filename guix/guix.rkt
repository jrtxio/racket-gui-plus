#lang racket/gui

;; Guix - Modern Racket GUI Widget Library
;; Provides a collection of Apple-style modern UI widgets
;; Supports theme switching and global refresh

;; Import style configuration and theme functionality
(require "style/config.rkt")

;; ===========================
;; Import All Widgets
;; ===========================

;; Atomic Widgets
(require "atomic/button.rkt"
         "atomic/label.rkt"
         "atomic/text-field.rkt"
         "atomic/text-area.rkt"
         "atomic/switch.rkt"
         "atomic/checkbox.rkt"
         "atomic/radio-button.rkt"
         "atomic/slider.rkt"
         "atomic/stepper.rkt"
         "atomic/icon.rkt")

;; Composite Widgets
(require "composite/filter-button.rkt"
         "composite/input-field.rkt"
         "composite/progress-bar.rkt"
         "composite/search-field.rkt"
         "composite/stepper-input.rkt"
         "composite/segmented-control.rkt")

;; Container Widgets
(require "container/custom-list-box.rkt"
         "container/side-panel.rkt"
         "container/sidebar-list.rkt"
         "container/split-view.rkt"
         "container/tab-view.rkt"
         "container/scroll-view.rkt"
         "container/stack-view.rkt")

;; Application Widgets
(require "app/calendar.rkt"
         "app/time-picker.rkt"
         "app/toast-info.rkt"
         "app/todo.rkt"
         "app/date-time-picker.rkt"
         "app/table-view.rkt"
         "app/alert.rkt"
         "app/menu.rkt")

;; ===========================
;; 导出所有公共接口
;; ===========================

;; 导出主题相关功能
(provide (all-from-out "style/config.rkt")
         register-widget unregister-widget refresh-all-widgets)

;; 导出所有控件模块
(provide (all-from-out "atomic/button.rkt")
         (all-from-out "atomic/label.rkt")
         (all-from-out "atomic/text-field.rkt")
         (all-from-out "atomic/text-area.rkt")
         (all-from-out "atomic/switch.rkt")
         (all-from-out "atomic/checkbox.rkt")
         (all-from-out "atomic/radio-button.rkt")
         (all-from-out "atomic/slider.rkt")
         (all-from-out "atomic/stepper.rkt")
         (all-from-out "atomic/icon.rkt")
         
         (all-from-out "composite/filter-button.rkt")
         (all-from-out "composite/input-field.rkt")
         (all-from-out "composite/progress-bar.rkt")
         (all-from-out "composite/search-field.rkt")
         (all-from-out "composite/stepper-input.rkt")
         (all-from-out "composite/segmented-control.rkt")
         
         (all-from-out "container/custom-list-box.rkt")
         (all-from-out "container/side-panel.rkt")
         (all-from-out "container/sidebar-list.rkt")
         (all-from-out "container/split-view.rkt")
         (all-from-out "container/tab-view.rkt")
         (all-from-out "container/scroll-view.rkt")
         (all-from-out "container/stack-view.rkt")
         
         (all-from-out "app/calendar.rkt")
         (all-from-out "app/time-picker.rkt")
         (all-from-out "app/toast-info.rkt")
         (all-from-out "app/todo.rkt")
         (all-from-out "app/date-time-picker.rkt")
         (all-from-out "app/table-view.rkt")
         (all-from-out "app/alert.rkt")
         (all-from-out "app/menu.rkt"))

;; 导出具体控件类（别名和向后兼容）
(provide text-field%
         modern-input% ; 别名，保持向后兼容
         
         filter-button%
         modern-progress-bar%
         
         modern-sidebar% ; 原 custom-list-box.rkt 实际导出的是 modern-sidebar%
         sidebar-list%
         list-item
         
         calendar%
         time-picker%
         modern-toast%
         show-toast
         checkbox-canvas%
         task-details-dialog%
         todo-item%
         todo-list%)
