#lang racket/gui
(require racket/class racket/draw)

(provide time-picker%)

;; 时间选择器控件
(define time-picker%
  (class canvas%
    (init-field [parent #f]
                [label ""]
                [style '()]
                [hour 22]
                [minute 0]
                [on-change void])
    
    ;; 初始化参数:设定最小尺寸并关闭默认焦点框
    (super-new [parent parent]
               [style (append style '(no-focus))]
               [label label]
               [min-width 82]
               [min-height 24])

    (define selected 'hour)  ; 当前选中部分:'hour 或 'minute
    (define has-focus? #f)   ; 控件是否获得焦点
    (define callbacks '())   ; 回调函数列表
    
    ;; 添加默认回调
    (when on-change
      (set! callbacks (cons on-change callbacks)))

    ;; 布局常量
    (define WIDTH 82)
    (define HEIGHT 24)
    (define STEPPER-W 18) ; 右侧箭头区域宽度

    ;; 配色方案（与库中其他控件一致）
    (define color-accent (make-object color% 0 122 255))      ; 苹果蓝
    (define color-text-main (make-object color% 40 40 40))     ; 深灰文字
    
    ;; 内部私有方法:调整数值并刷新界面
    (define/private (adjust-val delta)
      (if (eq? selected 'hour)
          (set! hour (modulo (+ hour delta) 24))
          (set! minute (modulo (+ minute delta) 60)))
      ;; 执行所有注册的回调
      (for ([cb callbacks]) (cb hour minute))
      (send this refresh))

    ;; 处理鼠标点击与滚动
    (define/override (on-event event)
      (define x (send event get-x))
      (define y (send event get-y))
      (define type (send event get-event-type))

      (cond 
        [(eq? type 'left-down)
         (send this focus)
         (cond 
           ;; 点击左侧时间区域
           [(< x (- WIDTH STEPPER-W))
            (set! selected (if (< x (/ (- WIDTH STEPPER-W) 2)) 'hour 'minute))]
           ;; 点击右侧上箭头区域
           [(< y (/ HEIGHT 2)) (adjust-val 1)]
           ;; 点击右侧下箭头区域
           [else (adjust-val -1)])
         (send this refresh)]
        
        ;; 滚轮支持
        [(eq? type 'wheel-up)   (adjust-val 1)]
        [(eq? type 'wheel-down) (adjust-val -1)]))

    ;; 处理键盘输入:支持方向键和 Tab 键切换
    (define/override (on-char event)
      (case (send event get-key-code)
        [(up)   (adjust-val 1)]
        [(down) (adjust-val -1)]
        [(tab)  (set! selected (if (eq? selected 'hour) 'minute 'hour))
                (send this refresh)]))

    ;; 焦点状态改变时重新绘制(蓝色高亮变灰色)
    (define/override (on-focus on?)
      (set! has-focus? on?)
      (send this refresh))

    ;; 核心绘图逻辑
    (define/override (on-paint)
      (define dc (send this get-dc))
      (send dc set-smoothing 'smoothed)
      
      ;; 1. 绘制外层胶囊边框与白色背景
      (send dc set-pen (make-object color% 210 210 210) 1 'solid)
      (send dc set-brush "white" 'solid)
      (send dc draw-rounded-rectangle 0 0 WIDTH HEIGHT 6)

      ;; 2. 绘制选中部分的高亮背景
      (define hl-color (if has-focus?
                           color-accent   ; 聚焦时为 macOS 蓝色
                           (make-object color% 230 230 230))) ; 失焦时为淡灰色
      (send dc set-brush hl-color 'solid)
      (send dc set-pen hl-color 1 'transparent)
      
      (if (eq? selected 'hour)
          (send dc draw-rounded-rectangle 2 2 30 (- HEIGHT 4) 4)
          (send dc draw-rounded-rectangle 32 2 30 (- HEIGHT 4) 4))

      ;; 3. 绘制时间数字与冒号
      (send dc set-font (make-object font% 11 'system 'normal 'bold))
      (define (draw-txt str x color)
        (send dc set-text-foreground color)
        (send dc draw-text str x 3))

      ;; 小时数字
      (draw-txt (~r hour #:min-width 2 #:pad-string "0") 7
                (if (and (eq? selected 'hour) has-focus?) "white" color-text-main))
      
      ;; 冒号
      (send dc set-text-foreground color-text-main)
      (send dc draw-text ":" 28 3)
      
      ;; 分钟数字
      (draw-txt (~r minute #:min-width 2 #:pad-string "0") 36
                (if (and (eq? selected 'minute) has-focus?) "white" color-text-main))

      ;; 4. 绘制右侧步进器分隔线(非常淡的灰色)
      (send dc set-pen (make-object color% 240 240 240) 1 'solid)
      (send dc draw-line (- WIDTH STEPPER-W) 4 (- WIDTH STEPPER-W) (- HEIGHT 5))

      ;; 5. 绘制微型箭头(多边形绘制)
      (send dc set-brush (make-object color% 60 60 60) 'solid)
      (send dc set-pen "black" 1 'transparent)
      
      ;; 上三角箭头
      (send dc draw-polygon (list '(0 . 0) '(6 . 0) '(3 . -3.5)) (- WIDTH 12) 10)
      ;; 下三角箭头
      (send dc draw-polygon (list '(0 . 0) '(6 . 0) '(3 . 3.5)) (- WIDTH 12) 15))

    ;; 公开接口:添加数值改变时的回调函数
    (define/public (add-callback cb)
      (set! callbacks (cons cb callbacks)))
    
    ;; 公开接口:获取当前时间
    (define/public (get-time)
      (values hour minute))
    
    ;; 公开接口:设置当前时间
    (define/public (set-time h m)
      (set! hour (modulo h 24))
      (set! minute (modulo m 60))
      ;; 执行所有注册的回调
      (for ([cb callbacks]) (cb hour minute))
      (send this refresh))
    
    ;; 标准化方法
    (define/public (get-value)
      (send this get-time))
    
    (define/public (set-value h m)
      (send this set-time h m))
    
    (define/override (refresh)
      (super refresh))
    
    )
)