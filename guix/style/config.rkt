#lang racket/gui

;; --- Unified Style Configuration ---
;; Apple-style design language
;; Supports theme switching (light/dark)

(require racket/class
         racket/list)

;; ===========================
;; Theme Definition
;; ===========================

;; Define theme structure
(struct theme (
  ;; Border radius configuration
  border-radius-small
  border-radius-medium
  border-radius-large
  
  ;; Background colors
  color-bg-white
  color-bg-light
  color-bg-overlay
  
  ;; Border colors
  color-border
  color-border-hover
  color-border-focus
  
  ;; Text colors
  color-text-main
  color-text-light
  color-text-placeholder
  
  ;; Functional colors
  color-accent
  color-success
  color-error
  color-warning
  
  ;; Font configuration
  font-size-small
  font-size-regular
  font-size-medium
  font-size-large
  font-small
  font-regular
  font-medium
  font-large
  
  ;; Widget size configuration
  input-height
  button-height
  progress-bar-height
  toast-height
  toast-width
  
  ;; Spacing configuration
  spacing-small
  spacing-medium
  spacing-large
  ))

;; ===========================
;; Light Theme
;; ===========================
(define light-theme
  (theme
   ;; Border radius configuration
   6   ; border-radius-small
   10  ; border-radius-medium
   14  ; border-radius-large
   
   ;; Background colors
   (make-object color% 255 255 255)      ; color-bg-white
   (make-object color% 242 242 247)      ; color-bg-light
   (make-object color% 255 255 255 0.95) ; color-bg-overlay
   
   ;; Border colors
   (make-object color% 200 200 200)      ; color-border
   (make-object color% 170 170 170)      ; color-border-hover
   (make-object color% 0 122 255)        ; color-border-focus
   
   ;; Text colors
   (make-object color% 44 44 46)         ; color-text-main
   (make-object color% 100 100 100)      ; color-text-light
   (make-object color% 160 160 160)      ; color-text-placeholder
   
   ;; Functional colors
   (make-object color% 0 122 255)        ; color-accent
   (make-object color% 52 199 89)        ; color-success
   (make-object color% 255 59 48)        ; color-error
   (make-object color% 255 149 0)        ; color-warning
   
   ;; Font configuration
   10  ; font-size-small
   13  ; font-size-regular
   14  ; font-size-medium
   16  ; font-size-large
   (send the-font-list find-or-create-font 10 'default 'normal 'normal)
   (send the-font-list find-or-create-font 13 'default 'normal 'normal)
   (send the-font-list find-or-create-font 14 'default 'normal 'bold)
   (send the-font-list find-or-create-font 16 'default 'normal 'bold)
   
   ;; Widget size configuration
   40  ; input-height
   40  ; button-height
   12  ; progress-bar-height
   68  ; toast-height
   340 ; toast-width
   
   ;; Spacing configuration
   4   ; spacing-small
   10  ; spacing-medium
   14  ; spacing-large
   ))

;; ===========================
;; Dark Theme
;; ===========================
(define dark-theme
  (theme
   ;; Border radius configuration
   6   ; border-radius-small
   10  ; border-radius-medium
   14  ; border-radius-large
   
   ;; Background colors
   (make-object color% 28 28 30)         ; color-bg-white
   (make-object color% 44 44 46)         ; color-bg-light
   (make-object color% 28 28 30 0.95)    ; color-bg-overlay
   
   ;; Border colors
   (make-object color% 60 60 60)         ; color-border
   (make-object color% 80 80 80)         ; color-border-hover
   (make-object color% 0 122 255)        ; color-border-focus
   
   ;; Text colors
   (make-object color% 255 255 255)      ; color-text-main
   (make-object color% 170 170 170)      ; color-text-light
   (make-object color% 100 100 100)      ; color-text-placeholder
   
   ;; Functional colors
   (make-object color% 0 122 255)        ; color-accent
   (make-object color% 52 199 89)        ; color-success
   (make-object color% 255 59 48)        ; color-error
   (make-object color% 255 149 0)        ; color-warning
   
   ;; Font configuration
   10  ; font-size-small
   13  ; font-size-regular
   14  ; font-size-medium
   16  ; font-size-large
   (send the-font-list find-or-create-font 10 'default 'normal 'normal)
   (send the-font-list find-or-create-font 13 'default 'normal 'normal)
   (send the-font-list find-or-create-font 14 'default 'normal 'bold)
   (send the-font-list find-or-create-font 16 'default 'normal 'bold)
   
   ;; Widget size configuration
   40  ; input-height
   40  ; button-height
   12  ; progress-bar-height
   68  ; toast-height
   340 ; toast-width
   
   ;; Spacing configuration
   4   ; spacing-small
   10  ; spacing-medium
   14  ; spacing-large
   ))

;; ===========================
;; Theme Switching Mechanism
;; ===========================

;; Current theme
(define current-theme (make-parameter light-theme))

;; List of theme change callback functions
(define theme-change-callbacks '())

;; List of all created widgets for global refresh when theme changes
(define all-widgets '())

;; Register theme change callback
(define (register-theme-callback callback)
  (set! theme-change-callbacks (append theme-change-callbacks (list callback))))

;; Unregister theme change callback
(define (unregister-theme-callback callback)
  (set! theme-change-callbacks (remove callback theme-change-callbacks)))

;; Register widget for refresh when theme changes
(define (register-widget widget)
  (set! all-widgets (cons widget all-widgets)))

;; Unregister widget
(define (unregister-widget widget)
  (set! all-widgets (remove widget all-widgets)))

;; Global refresh all widgets
(define (refresh-all-widgets)
  (for-each (λ (widget) 
              (when (is-a? widget area<%>) 
                (send widget refresh))) 
            all-widgets))

;; Switch theme
(define (set-theme! new-theme)
  (cond
    [(equal? new-theme 'light)
     (current-theme light-theme)
     (for-each (λ (callback) (callback light-theme)) theme-change-callbacks)
     (refresh-all-widgets)]
    [(equal? new-theme 'dark)
     (current-theme dark-theme)
     (for-each (λ (callback) (callback dark-theme)) theme-change-callbacks)
     (refresh-all-widgets)]
    [(theme? new-theme)
     (current-theme new-theme)
     (for-each (λ (callback) (callback new-theme)) theme-change-callbacks)
     (refresh-all-widgets)]))

;; ===========================
;; Convenient Access to Current Theme Properties
;; ===========================

;; Border radius配置
(define (border-radius-small) (theme-border-radius-small (current-theme)))
(define (border-radius-medium) (theme-border-radius-medium (current-theme)))
(define (border-radius-large) (theme-border-radius-large (current-theme)))

;; Background colors
(define (color-bg-white) (theme-color-bg-white (current-theme)))
(define (color-bg-light) (theme-color-bg-light (current-theme)))
(define (color-bg-overlay) (theme-color-bg-overlay (current-theme)))

;; Border colors
(define (color-border) (theme-color-border (current-theme)))
(define (color-border-hover) (theme-color-border-hover (current-theme)))
(define (color-border-focus) (theme-color-border-focus (current-theme)))

;; Text colors
(define (color-text-main) (theme-color-text-main (current-theme)))
(define (color-text-light) (theme-color-text-light (current-theme)))
(define (color-text-placeholder) (theme-color-text-placeholder (current-theme)))

;; Functional colors
(define (color-accent) (theme-color-accent (current-theme)))
(define (color-success) (theme-color-success (current-theme)))
(define (color-error) (theme-color-error (current-theme)))
(define (color-warning) (theme-color-warning (current-theme)))

;; Fonts
(define (font-size-small) (theme-font-size-small (current-theme)))
(define (font-size-regular) (theme-font-size-regular (current-theme)))
(define (font-size-medium) (theme-font-size-medium (current-theme)))
(define (font-size-large) (theme-font-size-large (current-theme)))
(define (font-small) (theme-font-small (current-theme)))
(define (font-regular) (theme-font-regular (current-theme)))
(define (font-medium) (theme-font-medium (current-theme)))
(define (font-large) (theme-font-large (current-theme)))

;; Widget sizes
(define (input-height) (theme-input-height (current-theme)))
(define (button-height) (theme-button-height (current-theme)))
(define (progress-bar-height) (theme-progress-bar-height (current-theme)))
(define (toast-height) (theme-toast-height (current-theme)))
(define (toast-width) (theme-toast-width (current-theme)))

;; Spacing
(define (spacing-small) (theme-spacing-small (current-theme)))
(define (spacing-medium) (theme-spacing-medium (current-theme)))
(define (spacing-large) (theme-spacing-large (current-theme)))

;; ===========================
;; Export All Style Constants and Theme Functions
;; ===========================
(provide 
 ;; Theme structure
 theme
 
 ;; Theme instances
 light-theme
 dark-theme
 
 ;; Theme switching
 current-theme
 set-theme!
 register-theme-callback
 unregister-theme-callback
 register-widget
 unregister-widget
 refresh-all-widgets
 
 ;; Border radius (function form, dynamically get current theme value)
 border-radius-small
 border-radius-medium
 border-radius-large
 
 ;; Colors (function form, dynamically get current theme value)
 color-bg-white
 color-bg-light
 color-bg-overlay
 color-border
 color-border-hover
 color-border-focus
 color-text-main
 color-text-light
 color-text-placeholder
 color-accent
 color-success
 color-error
 color-warning
 
 ;; Fonts (function form, dynamically get current theme value)
 font-size-small
 font-size-regular
 font-size-medium
 font-size-large
 font-small
 font-regular
 font-medium
 font-large
 
 ;; Widget sizes (function form, dynamically get current theme value)
 input-height
 button-height
 progress-bar-height
 toast-height
 toast-width
 
 ;; Spacing (function form, dynamically get current theme value)
 spacing-small
 spacing-medium
 spacing-large)