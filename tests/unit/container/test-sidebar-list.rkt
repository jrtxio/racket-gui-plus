#lang racket/gui

;; Automated tests for Sidebar List component
;; Using Racket's rackunit testing framework

(require rackunit
         racket/class
         racket/draw
         "../../../guix/container/sidebar-list.rkt"
        "../../../guix/style/config.rkt")

;; 创建一个简单的测试框架
(define test-frame
  (new frame%
       [label "Sidebar List Test Frame"]
       [width 500]
       [height 400]
       [style '(no-resize-border)]))

;; 显示测试框架

;; 创建测试用的列表项
(define (create-test-items count)
  (for/list ([i (in-range count)])
    (new list-item
         [label (format "Item ~a" i)]
         [color (make-object color% (* 30 i) 122 255)]
         [count i]
         [data (format "Data ~a" i)])))

;; 测试套件
(define sidebar-list-tests
  (test-suite
   "sidebar-list% Tests"
   
   ;; 测试1: 基本创建和属性设置
   (test-case "Basic Creation and Properties" 
     (define items (create-test-items 3))
     (define sidebar-list
       (new sidebar-list%
            [parent test-frame]
            [items items]))
     
     ;; 验证初始属性
     (check-equal? (length (send sidebar-list get-items)) 3 "Sidebar should have 3 items")
     (check-not-false (send sidebar-list get-selected-item) "Should have selected item")
     )
   
   ;; 测试2: 项目选择功能
   (test-case "Item Selection" 
     (define items (create-test-items 5))
     (define selected-item #f)
     (define sidebar-list
       (new sidebar-list%
            [parent test-frame]
            [items items]
            [on-select (λ (item) (set! selected-item item))]))
     
     ;; 测试选择项目
     (send sidebar-list select-item 2)
     (check-equal? (send (send sidebar-list get-selected-item) get-label) "Item 2" "Should select item 2")
     (check-equal? (send selected-item get-label) "Item 2" "On-select callback should be called")
     )
   
   ;; 测试3: 添加和删除项目
   (test-case "Add and Remove Items" 
     (define initial-items (create-test-items 2))
     (define sidebar-list
       (new sidebar-list%
            [parent test-frame]
            [items initial-items]))
     
     ;; 测试添加项目
     (define new-item (new list-item [label "New Item"] [count 99]))
     (send sidebar-list add-item new-item)
     (check-equal? (length (send sidebar-list get-items)) 3 "Should have 3 items after add")
     
     ;; 测试删除项目
     (send sidebar-list remove-item 0)
     (check-equal? (length (send sidebar-list get-items)) 2 "Should have 2 items after remove")
     (check-equal? (send (car (send sidebar-list get-items)) get-label) "Item 1" "First item should be Item 1 after remove")
     )
   
   ;; 测试4: 设置项目列表
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
   
   ;; 测试5: 主题响应
   (test-case "Theme Response" 
     (define items (create-test-items 2))
     (define sidebar-list
       (new sidebar-list%
            [parent test-frame]
            [items items]))
     
     ;; 保存当前主题
     (define original-theme (current-theme))
     
     ;; 切换到深色主题
     (set-theme! 'dark)
     ;; 验证主题已切换
     (check-equal? (current-theme) dark-theme "Theme should be dark")
     
     ;; 切换回浅色主题
     (set-theme! 'light)
     (check-equal? (current-theme) light-theme "Theme should be light")
     )
   
   ;; 测试6: 列表项操作
   (test-case "List Item Operations" 
     (define item (new list-item [label "Test Item"] [count 5]))
     
     ;; 测试列表项属性访问
     (check-equal? (send item get-label) "Test Item" "Item label should be 'Test Item'")
     (check-equal? (send item get-count) 5 "Item count should be 5")
     
     ;; 测试列表项属性修改
     (send item set-label! "Updated Item")
     (send item set-count! 10)
     (check-equal? (send item get-label) "Updated Item" "Item label should be updated")
     (check-equal? (send item get-count) 10 "Item count should be updated")
     )
   ))

;; 运行测试
(require rackunit/text-ui)
(run-tests sidebar-list-tests)

;; 关闭测试框架
(send test-frame show #f)