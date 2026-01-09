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
(require "composite/category-card.rkt"
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

;; Extended Widgets
(require "extended/calendar.rkt"
         "extended/time-picker.rkt"
         "extended/toast.rkt"
         "extended/date-time-picker.rkt")

;; ===========================
;; Export All Public Interfaces
;; ===========================

;; Export theme-related functionality
(provide (all-from-out "style/config.rkt")
         register-widget unregister-widget refresh-all-widgets)

;; Export all widget modules
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
         
         (all-from-out "composite/category-card.rkt")
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
         
         (all-from-out "extended/calendar.rkt")
        (all-from-out "extended/time-picker.rkt")
        (all-from-out "extended/toast.rkt")
        (all-from-out "extended/date-time-picker.rkt"))

;; Export specific widget classes
(provide text-field%
         label%
         modern-button%
         category-card%
         modern-progress-bar%
         modern-slider%
         sidebar-list%
         segmented-control%
         
         modern-sidebar%
         sidebar-item-data
         list-item
         
         calendar%
         time-picker%
         date-time-picker%
         guix-toast%
         show-toast)
