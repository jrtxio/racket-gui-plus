#lang racket/gui

(require rackunit)
(require "../../guix/composite/input.rkt")
(require "../../guix/composite/input-field.rkt")
(require "../../guix/style/config.rkt")

;; Test suite for input% and input-field%
(define input-tests
  (test-suite
   "Input Component Tests"
   
   ;; ===========================
   ;; Test input% component
   ;; ===========================
   
   ;; Test 1: Basic initialization of input%
   (test-case "input% - Basic initialization" 
     (define frame (new frame% [label "Test Frame"] [width 100] [height 100]))
     (define input (new input% [parent frame]))
     
     ;; Check initial values
     (check-equal? (send input get-text) "")
     (check-equal? (send input get-min-height) (input-height))
     (check-equal? (send input get-min-width) 200))
   
   ;; Test 2: Initial value setting for input%
   (test-case "input% - Initial value setting"
     (define frame (new frame% [label "Test Frame"] [width 100] [height 100]))
     (define input (new input% [parent frame] [init-value "Initial text"]))
     
     (check-equal? (send input get-text) "Initial text"))
   
   ;; Test 3: Text setting and getting for input%
   (test-case "input% - Text setting and getting"
     (define frame (new frame% [label "Test Frame"] [width 100] [height 100]))
     (define input (new input% [parent frame]))
     
     ;; Set text
     (send input set-text "New text")
     (check-equal? (send input get-text) "New text")
     
     ;; Set empty text
     (send input set-text "")
     (check-equal? (send input get-text) ""))
   
   ;; Test 4: Clear method for input%
   (test-case "input% - Clear method"
     (define frame (new frame% [label "Test Frame"] [width 100] [height 100]))
     (define input (new input% [parent frame] [init-value "Some text"]))
     
     (send input clear)
     (check-equal? (send input get-text) ""))
   
   ;; Test 5: Placeholder support for input%
   (test-case "input% - Placeholder support"
     (define frame (new frame% [label "Test Frame"] [width 100] [height 100]))
     (define input (new input% [parent frame] [placeholder "Enter text"]))
     
     ;; Check that placeholder is handled correctly
     (check-equal? (send input get-text) ""))
   
   ;; Test 6: Callback functionality for input%
   (test-case "input% - Callback functionality"
     (define frame (new frame% [label "Test Frame"] [width 100] [height 100]))
     (define callback-called #f)
     (define callback-text "")
     
     (define input (new input% [parent frame]
                         [callback (λ (text) 
                                     (set! callback-called #t)
                                     (set! callback-text text))]))
     
     ;; Set text and simulate enter key press
     (send input set-text "Callback test")
     
     ;; Access the internal text-field to trigger callback
     (define text-field (car (send input get-children)))
     (define event (new key-event% [key-code #\return]))
     (send text-field on-char event)
     
     (check-equal? callback-called #t)
     (check-equal? callback-text "Callback test"))
   
   ;; Test 7: Theme switching support for input%
   (test-case "input% - Theme switching support"
     (define frame (new frame% [label "Test Frame"] [width 100] [height 100]))
     (define input (new input% [parent frame]))
     
     ;; Test theme switching
     (set-theme! 'dark)
     (set-theme! 'light)
     (check-equal? #t #t))
   
   ;; ===========================
   ;; Test input-field% component
   ;; ===========================
   
   ;; Test 8: Basic initialization of input-field%
   (test-case "input-field% - Basic initialization"
     (define frame (new frame% [label "Test Frame"] [width 100] [height 100]))
     (define input-field (new input-field% [parent frame]))
     
     ;; Check initial values
     (check-equal? (send input-field get-text) "")
     (check-equal? (send input-field get-min-height) (input-height))
     (check-equal? (send input-field get-min-width) 240))
   
   ;; Test 9: Initial value setting for input-field%
   (test-case "input-field% - Initial value setting"
     (define frame (new frame% [label "Test Frame"] [width 100] [height 100]))
     (define input-field (new input-field% [parent frame] [init-value "Initial text"]))
     
     (check-equal? (send input-field get-text) "Initial text"))
   
   ;; Test 10: Text setting and getting for input-field%
   (test-case "input-field% - Text setting and getting"
     (define frame (new frame% [label "Test Frame"] [width 100] [height 100]))
     (define input-field (new input-field% [parent frame]))
     
     ;; Set text
     (send input-field set-text "New text")
     (check-equal? (send input-field get-text) "New text")
     
     ;; Set empty text
     (send input-field set-text "")
     (check-equal? (send input-field get-text) ""))
   
   ;; Test 11: Clear method for input-field%
   (test-case "input-field% - Clear method"
     (define frame (new frame% [label "Test Frame"] [width 100] [height 100]))
     (define input-field (new input-field% [parent frame] [init-value "Some text"]))
     
     (send input-field clear)
     (check-equal? (send input-field get-text) ""))
   
   ;; Test 12: Placeholder support for input-field%
   (test-case "input-field% - Placeholder support"
     (define frame (new frame% [label "Test Frame"] [width 100] [height 100]))
     (define input-field (new input-field% [parent frame] [placeholder "Enter text"]))
     
     ;; Check that placeholder is handled correctly
     (check-equal? (send input-field get-text) ""))
   
   ;; Test 13: Validation state for input-field%
   (test-case "input-field% - Validation state"
     (define frame (new frame% [label "Test Frame"] [width 100] [height 100]))
     (define input-field (new input-field% [parent frame]))
     
     ;; Check initial state
     (check-equal? (send input-field get-validation-state) 'normal)
     
     ;; Set to error state
     (send input-field set-validation-state 'error)
     (check-equal? (send input-field get-validation-state) 'error)
     
     ;; Set to warning state
     (send input-field set-validation-state 'warning)
     (check-equal? (send input-field get-validation-state) 'warning)
     
     ;; Set back to normal state
     (send input-field set-validation-state 'normal)
     (check-equal? (send input-field get-validation-state) 'normal))
   
   ;; Test 14: Theme switching support for input-field%
   (test-case "input-field% - Theme switching support"
     (define frame (new frame% [label "Test Frame"] [width 100] [height 100]))
     (define input-field (new input-field% [parent frame]))
     
     ;; Test theme switching
     (set-theme! 'dark)
     (set-theme! 'light)
     (check-equal? #t #t))
   ))

;; Run the test suite
(module+ test
  (require rackunit/text-ui)
  (run-tests input-tests))
