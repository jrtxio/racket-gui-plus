#lang racket/gui

;; Automated tests for Sidebar List component
;; Using Racket's rackunit testing framework

(require rackunit
         racket/class
         racket/draw
         "../../guix/container/sidebar-list.rkt"
        "../../guix/style/config.rkt")

;; Create a simple test frame
(define test-frame
  (new frame%
       [label "Sidebar List Test Frame"]
       [width 500]
       [height 400]
       [style '(no-resize-border)]))

;; Create test list items
(define (create-test-items count)
  (for/list ([i (in-range count)])
    (new list-item
         [label (format "Item ~a" i)]
         [color (make-object color% (* 30 i) 122 255)]
         [count i]
         [data (format "Data ~a" i)])))

;; Test suite
(define sidebar-list-tests
  (test-suite
   "sidebar-list% Tests"
   
   (test-case "Basic Creation and Properties" 
     (define items (create-test-items 3))
     (define sidebar-list
       (new sidebar-list%
            [parent test-frame]
            [items items]))
     
     ;; Verify initial properties
     (check-equal? (length (send sidebar-list get-items)) 3 "Sidebar should have 3 items")
     (check-not-false (send sidebar-list get-selected-item) "Should have selected item")
     )
   
   (test-case "Item Selection" 
     (define items (create-test-items 5))
     (define selected-item #f)
     (define sidebar-list
       (new sidebar-list%
            [parent test-frame]
            [items items]
            [on-select (λ (item) (set! selected-item item))]))
     
     ;; Test item selection
     (send sidebar-list select-item 2)
     (check-equal? (send (send sidebar-list get-selected-item) get-label) "Item 2" "Should select item 2")
     (check-equal? (send selected-item get-label) "Item 2" "On-select callback should be called")
     )
   
   (test-case "Add and Remove Items" 
     (define initial-items (create-test-items 2))
     (define sidebar-list
       (new sidebar-list%
            [parent test-frame]
            [items initial-items]))
     
     ;; Test adding an item
     (define new-item (new list-item [label "New Item"] [count 99]))
     (send sidebar-list add-item new-item)
     (check-equal? (length (send sidebar-list get-items)) 3 "Should have 3 items after add")
     
     ;; Test removing an item
     (send sidebar-list remove-item 0)
     (check-equal? (length (send sidebar-list get-items)) 2 "Should have 2 items after remove")
     (check-equal? (send (car (send sidebar-list get-items)) get-label) "Item 1" "First item should be Item 1 after remove")
     )
   
   (test-case "Set Items" 
     (define initial-items (create-test-items 2))
     (define sidebar-list
       (new sidebar-list%
            [parent test-frame]
            [items initial-items]))
     
     (define new-items (create-test-items 4))
     (send sidebar-list set-items! new-items)
     (check-equal? (length (send sidebar-list get-items)) 4 "Should have 4 items after set-items!")
     )
   
   (test-case "Theme Response" 
     (define items (create-test-items 2))
     (define sidebar-list
       (new sidebar-list%
            [parent test-frame]
            [items items]))
     
     ;; Save current theme
     (define original-theme (current-theme))
     
     ;; Switch to dark theme
     (set-theme! 'dark)
     ;; Verify theme switched
     (check-equal? (current-theme) dark-theme "Theme should be dark")
     
     ;; Switch back to light theme
     (set-theme! 'light)
     (check-equal? (current-theme) light-theme "Theme should be light")
     )
   
   (test-case "List Item Operations" 
     (define item (new list-item [label "Test Item"] [count 5]))
     
     ;; Test list item property access
     (check-equal? (send item get-label) "Test Item" "Item label should be 'Test Item'")
     (check-equal? (send item get-count) 5 "Item count should be 5")
     
     ;; Test list item property modification
     (send item set-label! "Updated Item")
     (send item set-count! 10)
     (check-equal? (send item get-label) "Updated Item" "Item label should be updated")
     (check-equal? (send item get-count) 10 "Item count should be updated")
     )
   ))

;; Run tests
(require rackunit/text-ui)
(run-tests sidebar-list-tests)

;; Close the test frame
(send test-frame show #f)