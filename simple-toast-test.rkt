#lang racket/gui

;; Simple test for the guix-toast% widget
(require "guix/app/toast.rkt")

;; Create a simple frame to test the toast
(define frame (new frame%
                   [label "Simple Toast Test"]
                   [width 400]
                   [height 300]))

;; Create a button to show the toast
(define panel (new vertical-panel%
                   [parent frame]
                   [alignment '(center center)]
                   [spacing 20]))

(new message%
     [parent panel]
     [label "Click the button to show a toast notification"])

(new button%
     [parent panel]
     [label "Show Toast"]
     [callback (lambda (btn evt)
                 (show-toast "Hello, this is a toast notification!" #:type 'success))])

(new button%
     [parent panel]
     [label "Show Error Toast"]
     [callback (lambda (btn evt)
                 (show-toast "This is an error message!" #:type 'error))])

(new button%
     [parent panel]
     [label "Show Info Toast"]
     [callback (lambda (btn evt)
                 (show-toast "This is an informational message." #:type 'info))])

;; Show the frame
(send frame show #t)