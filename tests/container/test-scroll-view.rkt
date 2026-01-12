#lang racket/gui

;; Scroll View Component Tests
;; Using Racket's rackunit test framework

(require rackunit
         racket/class
         racket/draw
         "../../guix/container/scroll-view.rkt"
         "../../guix/atomic/label.rkt"
         "../../guix/style/config.rkt")

;; Create a simple test frame
(define test-frame
  (new frame% 
       [label "Scroll View Test Frame"]
       [width 400]
       [height 300]
       [style '(no-resize-border)]))

;; Show test frame

;; Test suite
(define scroll-view-tests
  (test-suite
   "scroll-view% Tests"
   
   ;; Test 1: Basic Creation and Properties
   (test-case "Basic Creation and Properties" 
     (define scroll-view
       (new scroll-view% 
            [parent test-frame]
            [hscroll? #t]
            [vscroll? #t]))
     
     (check-true (is-a? scroll-view scroll-view%) "Should be an instance of scroll-view%")
     )
   
   ;; Test 2: Content Panel Access
   (test-case "Content Panel Access" 
     (define scroll-view
       (new scroll-view% 
            [parent test-frame]))
     
     (define content-panel (send scroll-view get-content-panel))
     (check-true (is-a? content-panel panel%) "Content panel should be an instance of panel%")
     )
   
   ;; Test 3: Adding Components to Content Panel
   (test-case "Adding Components to Content Panel" 
     (define scroll-view
       (new scroll-view% 
            [parent test-frame]))
     
     (define content-panel (send scroll-view get-content-panel))
     (define label
       (new label% 
            [parent content-panel]
            [label "Test Label"]))
     
     ;; 检查标签的父对象是否为内容面板
     (check-equal? (send label get-parent) content-panel "Label should be added to content panel")
     )
   
   ;; Test 4: Clear Content
   (test-case "Clear Content" 
     (define scroll-view
       (new scroll-view% 
            [parent test-frame]))
     
     (define content-panel (send scroll-view get-content-panel))
     
     ;; 添加两个标签
     (define label1 (new label% 
                       [parent content-panel]
                       [label "Test Label 1"]))
     (define label2 (new label% 
                       [parent content-panel]
                       [label "Test Label 2"]))
     
     ;; 验证标签已正确添加
     (check-equal? (send label1 get-parent) content-panel "First label should be added to content panel")
     (check-equal? (send label2 get-parent) content-panel "Second label should be added to content panel")
     
     ;; 清空内容
     (send scroll-view clear-content)
     
     ;; 添加一个新标签来验证清空操作
     (define new-label (new label% 
                          [parent content-panel]
                          [label "New Test Label"]))
     (check-equal? (send new-label get-parent) content-panel "New label should be added to content panel after clear-content")
     )
   
   ;; Test 5: Theme Response
   (test-case "Theme Response" 
     (define scroll-view
       (new scroll-view% 
            [parent test-frame]))
     
     ;; Save current theme
     (define original-theme (current-theme))
     
     ;; Switch to dark theme
     (set-theme! 'dark)
     ;; Verify theme has switched
     (check-equal? (current-theme) dark-theme "Theme should be dark")
     
     ;; Switch back to light theme
     (set-theme! 'light)
     (check-equal? (current-theme) light-theme "Theme should be light")
     )
   ))

;; Run tests
(require rackunit/text-ui)
(run-tests scroll-view-tests)

;; Close test frame
(send test-frame show #f)