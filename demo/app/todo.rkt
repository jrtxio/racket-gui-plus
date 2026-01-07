#lang racket/gui

;; ============================================================
;; 1. 自定义 Checkbox 控件
;; ============================================================
(define checkbox-canvas%
  (class canvas%
    (init-field [checked? #f] 
                [on-change (lambda (val) (void))])
    
    (super-new [style '(transparent)] 
               [stretchable-width #f] 
               [stretchable-height #f] 
               [min-width 30] 
               [min-height 30])
    
    (define hover? #f)
    
    (define/override (on-paint)
      (let ([dc (send this get-dc)] 
            [w (send this get-width)] 
            [h (send this get-height)])
        (send dc set-smoothing 'smoothed)
        (define cx (/ w 2)) 
        (define cy 15)
        
        (if checked?
            ;; 选中状态：蓝色填充圆圈 + 白色勾选标记
            (begin 
              (send dc set-pen "#007AFF" 1 'solid) 
              (send dc set-brush "#007AFF" 'solid)
              (send dc draw-ellipse (- cx 9) (- cy 9) 18 18)
              
              ;; 绘制勾选标记
              (send dc set-pen "white" 2 'solid)
              (send dc draw-line (- cx 4) cy (- cx 1) (+ cy 3))
              (send dc draw-line (- cx 1) (+ cy 3) (+ cx 4) (- cy 4)))
            
            ;; 未选中状态：空心圆圈
            (begin 
              (send dc set-pen (if hover? "#007AFF" "lightgray") 1.5 'solid) 
              (send dc set-brush "transparent" 'transparent)
              (send dc draw-ellipse (- cx 9) (- cy 9) 18 18)))))
    
    (define/override (on-event event)
      (cond
        [(equal? (send event get-event-type) 'left-down)
         (set! checked? (not checked?)) 
         (send this refresh) 
         (on-change checked?)]
        
        [(equal? (send event get-event-type) 'enter)
         (set! hover? #t)
         (send this refresh)]
        
        [(equal? (send event get-event-type) 'leave)
         (set! hover? #f)
         (send this refresh)]))
    
    ;; 公共方法
    (define/public (get-checked) checked?)
    (define/public (set-checked val)
      (set! checked? val)
      (send this refresh))
    ))

;; ============================================================
;; 2. 任务详情对话框
;; ============================================================
(define task-details-dialog%
  (class dialog%
    (init-field [task-text ""] 
                [due-date #f] 
                [notes ""]
                [on-save (lambda (text date notes) (void))])
    
    (super-new [label "任务详情"] 
               [width 400] 
               [height 350])
    
    (define main-panel (new vertical-panel% [parent this] [border 15] [spacing 10]))
    
    ;; 任务标题
    (new message% [parent main-panel] [label "任务内容:"])
    (define title-field
      (new text-field% 
           [parent main-panel]
           [label ""]
           [init-value task-text]))
    
    ;; 截止日期
    (new message% [parent main-panel] [label "截止日期:"])
    (define date-panel (new horizontal-panel% [parent main-panel] [stretchable-height #f]))
    
    (define date-field
      (new text-field%
           [parent date-panel]
           [label ""]
           [init-value (if due-date due-date "")]
           [style '(single)]))
    
    (new message% [parent date-panel] [label "  格式: YYYY-MM-DD"])
    
    ;; 备注
    (new message% [parent main-panel] [label "备注:"])
    (define notes-text (new text%))
    (send notes-text insert notes)
    (new editor-canvas%
         [parent main-panel]
         [editor notes-text]
         [style '(no-hscroll)]
         [min-height 100])
    
    ;; 按钮
    (define btn-panel (new horizontal-panel% [parent main-panel] [stretchable-height #f]))
    (new horizontal-pane% [parent btn-panel])
    
    (new button%
         [parent btn-panel]
         [label "取消"]
         [callback (lambda (btn evt) (send this show #f))])
    
    (new button%
         [parent btn-panel]
         [label "保存"]
         [callback (lambda (btn evt)
                    (on-save 
                     (send title-field get-value)
                     (let ([d (send date-field get-value)])
                       (if (string=? d "") #f d))
                     (send notes-text get-text))
                    (send this show #f))])
    ))

;; ============================================================
;; 3. 增强的 Todo Item 控件
;; ============================================================
(define todo-item%
  (class vertical-panel%
    (init-field [task-text "New Task"] 
                [checked? #f]
                [due-date #f]
                [notes ""]
                [on-delete (lambda () (void))]
                [on-change (lambda (text checked date notes) (void))])
    
    (super-new [alignment '(left top)] 
               [stretchable-height #f] 
               [spacing 3])
    
    ;; 第一行：复选框 + 文本 + 信息按钮
    (define first-row (new horizontal-panel% 
                           [parent this]
                           [alignment '(left center)]
                           [stretchable-height #f]
                           [spacing 5]))
    
    ;; 左侧复选框
    (define checkbox
      (new checkbox-canvas% 
           [parent first-row] 
           [checked? checked?]
           [on-change (lambda (is-checked) 
                       (set! checked? is-checked) 
                       (update-text-style)
                       (on-change (get-text) is-checked due-date notes))]))
    
    ;; 任务文本编辑器
    (define text-obj (new text%))
    (send text-obj insert task-text)
    
    ;; 监听文本变化
    (define text-callback%
      (class text%
        (super-new)
        (define/augment (after-insert start len)
          (inner (void) after-insert start len)
          (on-change (get-text) checked? due-date notes))
        (define/augment (after-delete start len)
          (inner (void) after-delete start len)
          (on-change (get-text) checked? due-date notes))))
    
    (set! text-obj (new text-callback%))
    (send text-obj insert task-text)
    
    (define editor-canvas
      (new editor-canvas% 
           [parent first-row] 
           [editor text-obj] 
           [style '(no-border no-hscroll no-vscroll transparent)] 
           [min-height 30]
           [stretchable-width #t]))
    
    ;; 信息按钮（右侧）
    (define info-btn
      (new button%
           [parent first-row]
           [label "ⓘ"]
           [stretchable-width #f]
           [min-width 30]
           [font (make-object font% 16 'default 'normal 'normal)]
           [callback (lambda (btn evt) (show-details))]))
    
    ;; 第二行：备注（浅灰色，可编辑）
    (define notes-panel #f)
    (define notes-text #f)
    (define notes-canvas #f)
    (when (and notes (not (string=? notes "")))
      (set! notes-panel (new horizontal-panel% 
                             [parent this]
                             [alignment '(left top)]
                             [stretchable-height #f]
                             [spacing 0]))
      ;; 左侧缩进（对齐文本）
      (new message% [parent notes-panel] [label "        "])
      
      ;; 备注编辑器
      (set! notes-text (new text%))
      (send notes-text insert notes)
      
      ;; 设置备注样式为浅灰色
      (let ([delta (new style-delta%)])
        (send delta set-delta-foreground (make-object color% 130 130 130))
        (send notes-text change-style delta 0 (send notes-text last-position)))
      
      ;; 备注文本编辑器
      (set! notes-canvas
            (new editor-canvas% 
                 [parent notes-panel] 
                 [editor notes-text] 
                 [style '(no-border no-hscroll no-vscroll transparent)] 
                 [min-height 24]
                 [stretchable-width #t]))
      
      ;; 监听备注文本变化
      (define notes-callback%
        (class text%
          (super-new)
          (define/augment (after-insert start len)
            (inner (void) after-insert start len)
            ;; 保持浅灰色样式
            (let ([delta (new style-delta%)])
              (send delta set-delta-foreground (make-object color% 130 130 130))
              (send this change-style delta 0 (send this last-position)))
            (set! notes (send this get-text))
            (on-change (get-text) checked? due-date notes))
          (define/augment (after-delete start len)
            (inner (void) after-delete start len)
            (set! notes (send this get-text))
            (on-change (get-text) checked? due-date notes))))
      
      (set! notes-text (new notes-callback%))
      (send notes-text insert notes)
      (let ([delta (new style-delta%)])
        (send delta set-delta-foreground (make-object color% 130 130 130))
        (send delta set-size-mult 0.9)
        (send notes-text change-style delta 0 (send notes-text last-position)))
      
      (set! notes-canvas
            (new editor-canvas% 
                 [parent notes-panel] 
                 [editor notes-text] 
                 [style '(no-border no-hscroll no-vscroll transparent)] 
                 [min-height 24]
                 [stretchable-width #t])))
    
    ;; 第三行：日期（浅灰色，缩进显示）
    (define date-panel #f)
    (define date-label #f)
    (when due-date
      (set! date-panel (new horizontal-panel% 
                            [parent this]
                            [alignment '(left center)]
                            [stretchable-height #f]
                            [spacing 0]))
      ;; 左侧缩进
      (new message% [parent date-panel] [label "        "])
      ;; 日期显示（浅灰色）
      (define date-msg (new message%
                            [parent date-panel]
                            [label due-date]
                            [font (make-object font% 10 'default 'normal 'normal)]))
      (set! date-label date-msg))
    
    ;; 显示详情对话框
    (define/private (show-details)
      (define dlg
        (new task-details-dialog%
             [task-text (get-text)]
             [due-date due-date]
             [notes notes]
             [on-save (lambda (text date note)
                       (send text-obj begin-edit-sequence)
                       (send text-obj erase)
                       (send text-obj insert text)
                       (send text-obj end-edit-sequence)
                       (set! due-date date)
                       (set! notes note)
                       (update-notes-display)
                       (update-date-display)
                       (on-change text checked? date note))]))
      (send dlg show #t))
    
    ;; 更新备注显示
    (define/private (update-notes-display)
      ;; 删除旧的备注面板
      (when notes-panel
        (send this delete-child notes-panel)
        (set! notes-panel #f)
        (set! notes-text #f)
        (set! notes-canvas #f))
      
      ;; 如果有备注，创建新的备注面板
      (when (and notes (not (string=? notes "")))
        (set! notes-panel (new horizontal-panel% 
                               [parent this]
                               [alignment '(left top)]
                               [stretchable-height #f]
                               [spacing 0]))
        ;; 左侧缩进
        (new message% [parent notes-panel] [label "        "])
        
        ;; 备注编辑器
        (define notes-callback%
          (class text%
            (super-new)
            (define/augment (after-insert start len)
              (inner (void) after-insert start len)
              ;; 保持浅灰色样式
              (let ([delta (new style-delta%)])
                (send delta set-delta-foreground (make-object color% 130 130 130))
                (send delta set-size-mult 0.9)
                (send this change-style delta 0 (send this last-position)))
              (set! notes (send this get-text))
              (on-change (get-text) checked? due-date notes))
            (define/augment (after-delete start len)
              (inner (void) after-delete start len)
              (set! notes (send this get-text))
              (on-change (get-text) checked? due-date notes))))
        
        (set! notes-text (new notes-callback%))
        (send notes-text insert notes)
        (let ([delta (new style-delta%)])
          (send delta set-delta-foreground (make-object color% 130 130 130))
          (send delta set-size-mult 0.9)
          (send notes-text change-style delta 0 (send notes-text last-position)))
        
        (set! notes-canvas
              (new editor-canvas% 
                   [parent notes-panel] 
                   [editor notes-text] 
                   [style '(no-border no-hscroll no-vscroll transparent)] 
                   [min-height 24]
                   [stretchable-width #t])))
      
      ;; 重新排列子控件顺序：第一行 -> 备注 -> 日期
      (send this change-children
            (lambda (children)
              (filter values 
                      (list first-row notes-panel date-panel)))))
    
    ;; 更新日期显示
    (define/private (update-date-display)
      ;; 删除旧的日期面板
      (when date-panel
        (send this delete-child date-panel)
        (set! date-panel #f)
        (set! date-label #f))
      
      ;; 如果有日期，创建新的日期面板
      (when due-date
        (set! date-panel (new horizontal-panel% 
                              [parent this]
                              [alignment '(left center)]
                              [stretchable-height #f]
                              [spacing 0]))
        ;; 左侧缩进
        (new message% [parent date-panel] [label "        "])
        
        ;; 创建日期文本编辑器（只读，但可以显示灰色）
        (define date-text (new text%))
        (send date-text insert due-date)
        
        ;; 设置为浅灰色
        (let ([delta (new style-delta%)])
          (send delta set-delta-foreground (make-object color% 130 130 130))
          (send delta set-size-mult 0.9)
          (send date-text change-style delta 0 (send date-text last-position)))
        
        ;; 使用 editor-canvas 显示日期
        (set! date-label
              (new editor-canvas% 
                   [parent date-panel] 
                   [editor date-text] 
                   [style '(no-border no-hscroll no-vscroll transparent)] 
                   [min-height 20]
                   [stretchable-width #f]))
        
        ;; 设置为只读
        (send date-text lock #t))
      
      ;; 重新排列子控件顺序：第一行 -> 备注 -> 日期
      (send this change-children
            (lambda (children)
              (filter values 
                      (list first-row notes-panel date-panel)))))
    
    ;; 样式更新
    (define/public (update-text-style)
      (send text-obj begin-edit-sequence)
      (let ([end (send text-obj last-position)])
        (if checked?
            ;; 选中: 变灰 + 斜体
            (let ([delta (new style-delta%)])
              (send delta set-delta-foreground "gray")
              (send delta set-style-on 'italic)
              (send text-obj change-style delta 0 end))
            
            ;; 取消选中: 重置为 Standard
            (let ([std (send (send text-obj get-style-list) find-named-style "Standard")])
              (send text-obj change-style std 0 end))))
      (send text-obj end-edit-sequence))
    
    ;; 公共方法
    (define/public (get-text)
      (send text-obj get-text))
    
    (define/public (get-checked)
      (send checkbox get-checked))
    
    (define/public (get-due-date)
      due-date)
    
    (define/public (get-notes)
      notes)
    
    (define/public (set-text txt)
      (send text-obj begin-edit-sequence)
      (send text-obj erase)
      (send text-obj insert txt)
      (send text-obj end-edit-sequence)
      (update-text-style))
    
    (define/public (set-checked val)
      (send checkbox set-checked val)
      (update-text-style))
    
    ;; 初始化样式
    (update-text-style)
    ))

;; ============================================================
;; 4. Todo 列表管理器
;; ============================================================
(define todo-list%
  (class vertical-panel%
    (init-field [on-change (lambda (items) (void))] [min-height 200])
    
    (super-new [border 10] 
               [style '(auto-vscroll)]
               [stretchable-height #t]
               [min-height min-height])
    
    (define items '())
    
    ;; 添加任务
    (define/public (add-item text [checked #f] [due-date #f] [notes ""])
      (define item
        (new todo-item%
             [parent this]
             [task-text text]
             [checked? checked]
             [due-date due-date]
             [notes notes]
             [on-delete (lambda () (remove-item item))]
             [on-change (lambda (txt chk date note) (notify-change))]))
      (set! items (append items (list item)))
      (notify-change)
      item)
    
    ;; 删除任务
    (define/private (remove-item item)
      (send this delete-child item)
      (set! items (remove item items))
      (notify-change))
    
    ;; 获取所有任务数据
    (define/public (get-all-tasks)
      (for/list ([item items])
        (list (send item get-text) 
              (send item get-checked)
              (send item get-due-date)
              (send item get-notes))))
    
    ;; 清空已完成任务
    (define/public (clear-completed)
      (define completed (filter (lambda (item) (send item get-checked)) items))
      (for ([item completed])
        (remove-item item)))
    
    ;; 通知变化
    (define/private (notify-change)
      (on-change (get-all-tasks)))
    ))

;; 导出公共接口
(provide checkbox-canvas%
         task-details-dialog%
         todo-item%
         todo-list%)

;; ============================================================
;; 5. 主界面 (仅在直接运行时执行)
;; ============================================================
(module+ main
  (define frame (new frame% 
                     [label "Todo List"] 
                     [width 500] 
                     [height 600]))

  (define main-panel (new vertical-panel% [parent frame]))

  ;; 标题栏
  (define title-panel (new horizontal-panel% 
                           [parent main-panel]
                           [stretchable-height #f]
                           [border 15]))

  (new message% 
       [parent title-panel]
       [label "我的任务"]
       [font (make-object font% 20 'default 'normal 'bold)])

  (new horizontal-pane% [parent title-panel])

  (define clear-btn
    (new button%
         [parent title-panel]
         [label "清除已完成"]
         [callback (lambda (btn evt)
                    (send todo-list clear-completed))]))

  ;; 任务列表
  (define todo-list
    (new todo-list%
         [parent main-panel]
         [on-change (lambda (items)
                     (printf "任务列表更新: ~a 项任务~n" (length items)))]))

  ;; 添加示例任务
  (send todo-list add-item "点击文字可以直接编辑任务内容")
  (send todo-list add-item "点击右侧 ⓘ 图标设置日期和备注" #f "2024-12-31" "这是一个示例备注")
  (send todo-list add-item "已完成的任务会显示灰色斜体" #t)
  (send todo-list add-item "尝试添加新任务吧！")

  ;; 底部输入栏
  (define input-panel (new horizontal-panel%
                           [parent main-panel]
                           [stretchable-height #f]
                           [border 15]))

  (define input-field
    (new text-field%
         [parent input-panel]
         [label ""]
         [init-value ""]
         [style '(single)]
         [callback (lambda (field evt)
                    (when (equal? (send evt get-event-type) 'text-field-enter)
                      (define txt (send field get-value))
                      (unless (string=? (string-trim txt) "")
                        (send todo-list add-item txt)
                        (send field set-value ""))))]))

  (define add-btn
    (new button%
         [parent input-panel]
         [label "添加任务"]
         [stretchable-width #f]
         [callback (lambda (btn evt)
                    (define txt (send input-field get-value))
                    (unless (string=? (string-trim txt) "")
                      (send todo-list add-item txt)
                      (send input-field set-value "")))]))

  ;; 状态栏
  (define status-panel (new horizontal-panel%
                            [parent main-panel]
                            [stretchable-height #f]
                            [border 10]
                            [style '(border)]))

  (define status-msg
    (new message%
         [parent status-panel]
         [label "提示: 按回车快速添加任务"]))

  (send frame show #t)
)
