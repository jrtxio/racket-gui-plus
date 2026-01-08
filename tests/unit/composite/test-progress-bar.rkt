#lang racket/gui

(require rackunit
         2htdp/image
         2htdp/universe
         "../../../guix/composite/progress-bar.rkt"
        "../../../guix/style/config.rkt")

;; Create a frame for testing
(define test-frame (new frame% [label "Test Progress Bar"] [width 400] [height 200]))

;; Test progress bar initialization
(test-case "Progress Bar Initialization" 
  (define progress-bar (new modern-progress-bar% [parent test-frame]))
  
  ;; Test initial progress value
  (check-equal? (send progress-bar get-progress) 0.0 "Initial progress should be 0.0")
  
  ;; Test min width and height
  (check-equal? (send progress-bar min-width) 200 "Min width should be 200")
  (check-equal? (send progress-bar min-height) (progress-bar-height) "Min height should match progress-bar-height")
  
  (send test-frame show #f))

;; Test setting progress value
(test-case "Setting Progress Value" 
  (define progress-bar (new modern-progress-bar% [parent test-frame]))
  
  ;; Set progress to 50%
  (send progress-bar set-progress 0.5)
  
  ;; Simulate ticking until progress reaches target
  (for ([i (in-range 20)])
    (send progress-bar tick))
  
  ;; Check if progress is approximately 50%
  (check-within (send progress-bar get-progress) 0.5 0.01 "Progress should be approximately 0.5 after ticking")
  
  ;; Set progress to 100%
  (send progress-bar set-progress 1.0)
  (for ([i (in-range 20)])
    (send progress-bar tick))
  (check-within (send progress-bar get-progress) 1.0 0.01 "Progress should be approximately 1.0 after ticking")
  
  ;; Set progress to 0%
  (send progress-bar set-progress 0.0)
  (for ([i (in-range 30)])
    (send progress-bar tick))
  (check-within (send progress-bar get-progress) 0.0 0.01 "Progress should be approximately 0.0 after ticking")
  
  (send test-frame show #f))

;; Test theme switching
(test-case "Theme Switching" 
  (define progress-bar (new modern-progress-bar% [parent test-frame]))
  
  ;; Set initial theme to light
  (set-theme! 'light)
  (send progress-bar refresh)
  
  ;; Switch to dark theme
  (set-theme! 'dark)
  (send progress-bar refresh)
  
  ;; Switch back to light theme
  (set-theme! 'light)
  (send progress-bar refresh)
  
  (send test-frame show #f))

;; Test progress animation
(test-case "Progress Animation" 
  (define progress-bar (new modern-progress-bar% [parent test-frame]))
  
  ;; Set progress to 0.7
  (send progress-bar set-progress 0.7)
  
  ;; Get initial progress
  (define initial-progress (send progress-bar get-progress))
  
  ;; Tick once and check if progress increased
  (send progress-bar tick)
  (define after-tick-progress (send progress-bar get-progress))
  
  (check-true (> after-tick-progress initial-progress) "Progress should increase after ticking")
  
  (send test-frame show #f))

;; Run all tests
(void)