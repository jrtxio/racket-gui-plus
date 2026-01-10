#lang racket/gui

(require "../guix/composite/progress-bar.rkt"
         "../guix/style/config.rkt"
         "../guix/atomic/button.rkt"
         "../guix/atomic/slider.rkt")

;; Create the main frame
(define frame (new frame% [label "Progress Bar Demo"] [width 500] [height 300]))

;; Create a panel for the progress bar
(define panel (new vertical-panel% [parent frame] [alignment '(center center)] [spacing 20]))

;; Create a progress bar
(define progress-bar (new modern-progress-bar% [parent panel]))

;; Create a slider to control progress
(define slider (new modern-slider% 
                   [parent panel]
                   [label "Progress"]
                   [min-value 0]
                   [max-value 100]
                   [init-value 0]
                   [style '(horizontal plain)]
                   [callback (lambda (slider event) 
                               (define value (/ (send slider get-value) 100.0))
                               (send progress-bar set-progress value))]))

;; Create a theme toggle button
(define theme-button (new modern-button% 
                         [parent panel]
                         [label "Toggle Dark Mode"]
                         [on-click (lambda () 
                                     (if (eq? (current-theme) light-theme)
                                         (set-theme! 'dark)
                                         (set-theme! 'light)))]))

;; Create a button to animate progress
(define animate-button (new modern-button% 
                           [parent panel]
                           [label "Animate Progress"]
                           [on-click (lambda () 
                                       (define value (/ (random 101) 100.0))
                                       (send slider set-value (inexact->exact (floor (* value 100.0))))
                                       (send progress-bar set-progress value))]))

;; Create a timer to update the progress bar
(define timer (new timer% 
                   [notify-callback (lambda () (send progress-bar tick))]
                   [interval 30]))

;; Show the frame
(send frame show #t)