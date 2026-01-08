#lang racket/base

(require rackunit
         racket/gui
         racket/class
         racket/list
         (prefix-in gx: "../../guix/extended/toast.rkt")
         "../../guix/style/config.rkt")

;; Test suite for guix-toast%
(define toast-tests
  (test-suite
   "guix-toast% tests"
   
   ;; Test 1: Basic initialization
   (test-case "Basic initialization"
     (let ([toast (new gx:guix-toast%
                       [message "Test message"]
                       [type 'success]
                       [on-remove void])])
       (check-not-false toast "Toast should be initialized successfully")
       (check-true (is-a? toast frame%) "Toast should be a frame%")
       (send toast show #f)))
   
   ;; Test 2: Different types initialization
   (test-case "Different types initialization"
     (let ([success-toast (new gx:guix-toast%
                               [message "Success message"]
                               [type 'success]
                               [on-remove void])]
           [error-toast (new gx:guix-toast%
                             [message "Error message"]
                             [type 'error]
                             [on-remove void])]
           [info-toast (new gx:guix-toast%
                            [message "Info message"]
                            [type 'info]
                            [on-remove void])])
       (check-not-false success-toast "Success toast should be initialized successfully")
       (check-not-false error-toast "Error toast should be initialized successfully")
       (check-not-false info-toast "Info toast should be initialized successfully")
       (send success-toast show #f)
       (send error-toast show #f)
       (send info-toast show #f)))
   
   ;; Test 3: Show-toast function
   (test-case "show-toast function"
     (check-not-exn (lambda () (gx:show-toast "Test message")) "show-toast should not throw exception")
     (check-not-exn (lambda () (gx:show-toast "Success message" #:type 'success)) "show-toast with success type should not throw exception")
     (check-not-exn (lambda () (gx:show-toast "Error message" #:type 'error)) "show-toast with error type should not throw exception")
     (check-not-exn (lambda () (gx:show-toast "Info message" #:type 'info)) "show-toast with info type should not throw exception"))
   
   ;; Test 4: Theme switching
   (test-case "Theme switching compatibility"
     (let ([toast (new gx:guix-toast%
                       [message "Theme test"]
                       [type 'success]
                       [on-remove void])])
       (check-not-exn (lambda () (set-theme! 'dark)) "Setting dark theme should not throw exception")
       (check-not-exn (lambda () (set-theme! 'light)) "Setting light theme should not throw exception")
       (send toast show #f)))
   
   ;; Test 5: Multiple toasts handling
   (test-case "Multiple toasts handling"
     (check-not-exn (lambda ()
                      (gx:show-toast "First toast")
                      (gx:show-toast "Second toast")
                      (gx:show-toast "Third toast"))
                    "Multiple toasts should be handled correctly"))
   ))

;; Run the tests
(module+ test
  (require rackunit/text-ui)
  (run-tests toast-tests))