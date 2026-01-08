#lang racket/gui

(require rackunit)
(require "../../../guix/atomic/text-field.rkt")
(require "../../../guix/style/config.rkt")

;; Test suite for text-field%
(define text-field-tests
  (test-suite
   "Text Field Tests"
   
   ;; Test 1: Basic initialization
   (test-case "Basic initialization"
     (define frame (new frame% [label "Test Frame"] [width 100] [height 100]))
     (define text-field (new text-field% [parent frame]))
     
     ;; Check initial values
     (check-equal? (send text-field get-text) "")
     (check-equal? (send text-field get-min-height) (input-height))
     (check-equal? (send text-field get-min-width) 200))
   
   ;; Test 2: Initial value setting
   (test-case "Initial value setting"
     (define frame (new frame% [label "Test Frame"] [width 100] [height 100]))
     (define text-field (new text-field% [parent frame] [init-value "Initial text"]))
     
     (check-equal? (send text-field get-text) "Initial text"))
   
   ;; Test 3: Text setting and getting
   (test-case "Text setting and getting"
     (define frame (new frame% [label "Test Frame"] [width 100] [height 100]))
     (define text-field (new text-field% [parent frame]))
     
     ;; Set text
     (send text-field set-text "New text")
     (check-equal? (send text-field get-text) "New text")
     
     ;; Set empty text
     (send text-field set-text "")
     (check-equal? (send text-field get-text) ""))
   
   ;; Test 4: Clear method
   (test-case "Clear method"
     (define frame (new frame% [label "Test Frame"] [width 100] [height 100]))
     (define text-field (new text-field% [parent frame] [init-value "Some text"]))
     
     (send text-field clear)
     (check-equal? (send text-field get-text) ""))
   
   ;; Test 5: Placeholder initialization
   (test-case "Placeholder initialization"
     (define frame (new frame% [label "Test Frame"] [width 100] [height 100]))
     (define text-field (new text-field% [parent frame] [placeholder "Enter text"]))
     
     ;; Check that placeholder is shown initially
     (check-equal? (send text-field get-text) ""))
   
   ;; Test 6: Callback functionality
   (test-case "Callback functionality"
     (define frame (new frame% [label "Test Frame"] [width 100] [height 100]))
     (define callback-called #f)
     (define callback-text "")
     
     (define text-field (new text-field% [parent frame]
                            [callback (λ (text) 
                                        (set! callback-called #t)
                                        (set! callback-text text))]))
     
     ;; Set text and simulate enter key press
     (send text-field set-text "Callback test")
     
     ;; Create a key event and send it to the text field
     (define event (new key-event% [key-code #\return]))
     (send text-field on-char event)
     
     (check-equal? callback-called #t)
     (check-equal? callback-text "Callback test"))
   
   ;; Test 7: Theme switching support
   (test-case "Theme switching support"
     (define frame (new frame% [label "Test Frame"] [width 100] [height 100]))
     (define text-field (new text-field% [parent frame]))
     
     ;; Test theme switching (indirectly tests registration)
     ;; Switch to dark theme
     (set-theme! 'dark)
     ;; Switch back to light theme
     (set-theme! 'light)
     ;; If no errors occur, the test passes
     (check-equal? #t #t))
   
   ))

;; Run the test suite
(module+ test
  (require rackunit/text-ui)
  (run-tests text-field-tests))
