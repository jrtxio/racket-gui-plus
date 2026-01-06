#lang racket/gui

;; 创建主窗口
(define frame (new frame% 
                   [label "Todo 列表 - 可滚动"] 
                   [width 500] 
                   [height 600]))

;; 使用 pasteboard% 和 editor-canvas% 实现滚动
(define pasteboard (new pasteboard%))

;; 创建可滚动的编辑器画布
(define canvas
  (new editor-canvas%
       [parent frame]
       [editor pasteboard]
       [style '(auto-vscroll)]
       [horizontal-inset 10]
       [vertical-inset 10]))

;; 定义任务数据
(define tasks
  '(("完成项目文档" "包括需求分析、设计文档和用户手册" "2025-01-15")
    ("代码审查" "审查团队成员提交的 PR" "2025-01-10")
    ("准备周会演示" "" "2025-01-08")
    ("修复登录页面 Bug" "用户反馈无法在移动端正常登录" "2025-01-12")
    ("优化数据库查询性能" "重点关注用户列表页面的查询效率" "2025-01-20")
    ("学习 Racket GUI 编程" "重点学习滚动面板和事件处理" "")
    ("更新依赖库版本" "检查并更新所有过期的 npm 包" "2025-01-18")
    ("编写单元测试" "为新增的用户认证模块编写测试用例" "2025-01-25")
    ("部署到测试环境" "" "2025-01-11")
    ("客户需求沟通会议" "讨论下一版本的新功能需求" "2025-01-09")
    ("重构用户界面组件" "使用新的设计系统重构现有组件" "2025-01-30")
    ("性能监控配置" "配置 APM 工具监控生产环境性能" "2025-01-22")
    ("撰写技术博客" "分享最近项目中的技术心得" "")
    ("团队培训:Git 最佳实践" "准备培训材料和演示示例" "2025-01-16")
    ("清理过期的代码分支" "删除已合并超过3个月的分支" "2025-01-14")))

;; 在 pasteboard 中添加每个任务
(define y-pos 10)
(for ([task tasks])
  (define title (first task))
  (define notes (second task))
  (define date (third task))
  
  ;; 创建任务标题的 snip
  (define title-snip (make-object string-snip% (format "☐ ~a" title)))
  (send pasteboard insert title-snip 10 y-pos)
  (set! y-pos (+ y-pos 25))
  
  ;; 如果有备注,添加备注
  (when (not (string=? notes ""))
    (define notes-snip (make-object string-snip% (format "    ~a" notes)))
    (send pasteboard insert notes-snip 10 y-pos)
    (set! y-pos (+ y-pos 20)))
  
  ;; 如果有日期,添加日期
  (when (not (string=? date ""))
    (define date-snip (make-object string-snip% (format "    📅 ~a" date)))
    (send pasteboard insert date-snip 10 y-pos)
    (set! y-pos (+ y-pos 20)))
  
  ;; 添加间距
  (set! y-pos (+ y-pos 15)))

;; 显示窗口
(send frame show #t)