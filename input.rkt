#lang racket/gui

(require "style-config.rkt")

(define modern-input%
  (class canvas%
    (init-field [placeholder ""] [callback (λ (t) (void))])
    
    (super-new [style '()]
               [min-height INPUT-HEIGHT]
               [min-width 200])
    
    ;; 设置为可伸展
    (send this stretchable-width #t)
    
    ;; 监听文本变化来隐藏占位符
    (define showing-placeholder? #t)
    (define has-focus? #f)
    
    ;; 设置字体
    (define font FONT-REGULAR)
    
    ;; 创建文本编辑器
    (define text (new text%))
    (send text lock #f)
    
    ;; 设置字体样式
    (define style-delta (new style-delta%))
    (send style-delta set-delta 'change-size FONT-SIZE-REGULAR)
    (send text change-style style-delta)
    
    ;; 文本内容
    (define current-text "")
    
    ;; 绘制方法
    (define/override (on-paint)
      (define dc (send this get-dc))
      (define-values (w h) (send this get-client-size))
      
      (send dc set-smoothing 'smoothed)
      
      ;; 计算边框宽度
      (define border-width (if has-focus? 2 1))
      (define half-border (/ border-width 2.0))
      
      ;; 先绘制父背景覆盖整个区域
      (send dc set-brush COLOR-BG-LIGHT 'solid)
      (send dc set-pen COLOR-BG-LIGHT 1 'transparent)
      (send dc draw-rectangle 0 0 w h)
      
      ;; 绘制白色圆角背景
      (send dc set-brush COLOR-BG-WHITE 'solid)
      (send dc set-pen "white" 0 'transparent)
      (send dc draw-rounded-rectangle 
            border-width border-width 
            (- w (* 2 border-width)) (- h (* 2 border-width))
            (- BORDER-RADIUS-MEDIUM 1))
      
      ;; 绘制圆角边框
      (send dc set-brush "white" 'transparent)
      (if has-focus?
          (send dc set-pen COLOR-BORDER-FOCUS border-width 'solid)
          (send dc set-pen COLOR-BORDER border-width 'solid))
      (send dc draw-rounded-rectangle 
            half-border half-border 
            (- w border-width) (- h border-width)
            BORDER-RADIUS-MEDIUM)
      
      ;; 绘制文本或占位符
      (send dc set-font font)
      (if (and showing-placeholder? (not has-focus?))
          (begin
            (send dc set-text-foreground COLOR-TEXT-PLACEHOLDER)
            (let-values ([(_ th _1 _2) (send dc get-text-extent placeholder)])
              (send dc draw-text placeholder 12 (/ (- h th) 2))))
          (begin
            (send dc set-text-foreground COLOR-TEXT-MAIN)
            (let-values ([(_ th _1 _2) (send dc get-text-extent current-text)])
              (send dc draw-text current-text 12 (/ (- h th) 2))))))
    
    ;; 处理鼠标点击 - 获得焦点
    (define/override (on-event event)
      (when (send event button-down?)
        (set! has-focus? #t)
        (send this refresh)))
    
    ;; 处理键盘输入
    (define/override (on-char event)
      (define key (send event get-key-code))
      (cond
        ;; 回车键 - 提交
        [(equal? key #\return)
         (unless (string=? (string-trim current-text) "")
           (callback current-text))
         (set! current-text "")
         (set! showing-placeholder? #t)
         (send this refresh)]
        ;; 退格键 - 删除字符
        [(equal? key 'back)
         (unless (string=? current-text "")
           (set! current-text (substring current-text 0 (- (string-length current-text) 1)))
           (set! showing-placeholder? (string=? current-text ""))
           (send this refresh))]
        ;; 普通字符 - 添加到文本
        [(char? key)
         (set! current-text (string-append current-text (string key)))
         (set! showing-placeholder? #f)
         (send this refresh)]))
    
    ;; 处理焦点变化
    (define/override (on-focus on?)
      (set! has-focus? on?)
      (send this refresh))
    
    ;; 公开方法
    (define/public (get-text)
      current-text)
    
    (define/public (set-text str)
      (set! current-text str)
      (set! showing-placeholder? (string=? str ""))
      (send this refresh))
    
    (define/public (clear)
      (set! current-text "")
      (set! showing-placeholder? #t)
      (send this refresh))))

;; 导出现代风格输入框控件类
(provide modern-input%)

;; ===========================
;; 测试用例
;; ===========================
(module+ main
  ;; 创建测试窗口
  (define frame (new frame% 
                     [label "圆角输入框测试"]
                     [width 500]
                     [height 300]))
  
  ;; 设置窗口背景色
  (define main-panel (new vertical-panel%
                          [parent frame]
                          [style '()]
                          [alignment '(center top)]
                          [spacing 20]))
  
  ;; 添加标题
  (define title-msg (new message%
                         [parent main-panel]
                         [label "测试圆角输入框"]
                         [font FONT-LARGE]))
  
  ;; 添加间距
  (new message% [parent main-panel] [label ""] [min-height 20])
  
  ;; 创建第一个输入框
  (define input1 (new modern-input%
                      [parent main-panel]
                      [placeholder "输入你的名字..."]
                      [callback (lambda (text)
                                  (send result-msg set-label 
                                        (format "你输入了: ~a" text)))]))
  
  ;; 添加间距
  (new message% [parent main-panel] [label ""] [min-height 10])
  
  ;; 创建第二个输入框
  (define input2 (new modern-input%
                      [parent main-panel]
                      [placeholder "输入你的邮箱..."]
                      [callback (lambda (text)
                                  (send result-msg set-label 
                                        (format "邮箱: ~a" text)))]))
  
  ;; 添加间距
  (new message% [parent main-panel] [label ""] [min-height 10])
  
  ;; 创建第三个输入框（带回调）
  (define input3 (new modern-input%
                      [parent main-panel]
                      [placeholder "按回车提交..."]
                      [callback (lambda (text)
                                  (send result-msg set-label 
                                        (format "最后输入: ~a" text))
                                  (send input3 clear))]))
  
  ;; 添加间距
  (new message% [parent main-panel] [label ""] [min-height 20])
  
  ;; 显示结果的标签
  (define result-msg (new message%
                          [parent main-panel]
                          [label "在输入框中输入内容并按回车..."]
                          [font FONT-MEDIUM]))
  
  ;; 添加测试按钮
  (define button-panel (new horizontal-panel%
                            [parent main-panel]
                            [alignment '(center center)]
                            [spacing 10]))
  
  (new button%
       [parent button-panel]
       [label "设置文本"]
       [callback (lambda (btn evt)
                   (send input1 set-text "测试文本"))])
  
  (new button%
       [parent button-panel]
       [label "清空所有"]
       [callback (lambda (btn evt)
                   (send input1 clear)
                   (send input2 clear)
                   (send input3 clear)
                   (send result-msg set-label "已清空所有输入框"))])
  
  ;; 显示窗口
  (send frame show #t))