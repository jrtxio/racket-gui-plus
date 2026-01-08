## 一、项目定位

基于 racket/gui 的跨平台桌面控件库，提供统一的交互体验和主题系统。

**核心目标**：

- 统一的视觉风格和交互行为
- 完善的主题系统
- 补充 racket/gui 缺失的常用控件
- 保持跨平台一致性

**技术约束**：

- 纯 Racket 实现，基于 racket/gui
- 不依赖外部 GUI 框架、JNI、FFI
- 支持 macOS、Windows、Linux

## 二、设计原则

|原则|说明|
|---|---|
|**务实优先**|利用 racket/gui 原生能力，避免重复造轮|
|**渐进增强**|分阶段实现，优先保证核心功能|
|**行为一致**|跨平台交互逻辑统一，接受视觉差异|
|**分层实现**|根据控件复杂度选择自绘/封装/组合|

## 三、架构设计

### 3.1 目录结构

```
guix/
├─ guix/
│  ├─ guix.rkt              # 主入口
│  ├─ core/                 # 核心系统
│  │  ├─ base-control.rkt   # 控件基类
│  │  ├─ event.rkt          # 事件系统
│  │  ├─ state.rkt          # 状态管理
│  │  └─ layout.rkt         # 布局引擎
│  ├─ style/                # 主题系统
│  │  ├─ theme.rkt
│  │  ├─ colors.rkt
│  │  ├─ typography.rkt
│  │  └─ presets/
│  │     ├─ light.rkt
│  │     └─ dark.rkt
│  ├─ atomic/               # 原子控件
│  ├─ composite/            # 组合控件
│  ├─ container/            # 容器控件
│  ├─ dialog/               # 对话框
│  ├─ menu/                 # 菜单
│  └─ extended/             # 扩展控件
├─ tests/
├─ examples/
└─ scribblings/
```

### 3.2 分层架构

```
┌─────────────────────────────────────┐
│  扩展控件 (extended)                 │  补充 racket/gui 缺失功能
├─────────────────────────────────────┤
│  菜单 (menu) + 对话框 (dialog)       │
├─────────────────────────────────────┤
│  容器控件 (container)                │
├─────────────────────────────────────┤
│  组合控件 (composite)                │
├─────────────────────────────────────┤
│  原子控件 (atomic)                   │
├─────────────────────────────────────┤
│  核心系统 (core + style)            │
└─────────────────────────────────────┘
```

## 四、核心系统

### 4.1 控件基类

```racket
(define guix-base-control%
  (class canvas%
    (init-field [enabled? #t]
                [visible? #t]
                [theme (current-theme)])
    
    ;; State management
    (define/public (get-enabled) enabled?)
    (define/public (set-enabled e) 
      (set! enabled? e)
      (invalidate))
    
    ;; Event handling
    (define/override (on-event event) 
      (handle-mouse-event event)
      (handle-keyboard-event event))
    
    ;; Rendering
    (define/override (on-paint) 
      (render-to-dc (send this get-dc)))
    
    (super-new)))
```

### 4.2 事件系统

**支持的事件类型**：

|事件名|触发时机|参数|
|---|---|---|
|`on-click`|鼠标点击|event-data|
|`on-double-click`|双击|event-data|
|`on-hover`|鼠标悬停|event-data|
|`on-change`|值变化|new-value|
|`on-focus`|获得焦点|-|
|`on-blur`|失去焦点|-|

**事件冒泡**：子控件事件向父控件传播，可调用 `stop-propagation` 阻止。

### 4.3 主题系统

```racket
(define-theme modern-theme
  #:colors (hash 'primary "#007AFF"
                 'background "#FFFFFF"
                 'text "#000000"
                 'border "#D1D1D6"
                 'hover "#E5E5EA"
                 'disabled "#C7C7CC")
  #:metrics (hash 'corner-radius 2      ;; Small radius or square (technical limitation)
                  'padding 8
                  'spacing 8
                  'border-width 1)
  #:typography (hash 'size 13
                     'weight 400
                     'family (get-system-font)))
```

**主题切换**：

```racket
(set-global-theme! dark-theme)                ;; Global theme switch
(new guix-panel% [theme custom-theme])        ;; Local override
```

### 4.4 布局引擎

**布局模式**：

|模式|说明|实现基础|
|---|---|---|
|`stack`|垂直/水平堆叠|racket/gui panel%|
|`flow`|流式布局|自动换行|
|`grid`|网格布局|行列定位|

**约束示例**：

```racket
(define constraint
  (hash 'min-width 100
        'max-width 500
        'preferred-width 300
        'stretch 1.0))
```

## 五、实现策略

### 5.1 控件分类实现

**完全自绘**（简单控件，追求视觉一致性）：

- button, label, icon, separator
- checkbox, radio-button
- slider, progress-bar, spinner
- segmented-control, stepper

**封装增强**（利用原生编辑能力）：

- text-field（封装 text-field% + 回车/Esc 处理 + 占位符）
- text-area（封装 text% + 样式定制）
- choice（封装 choice% + 主题）

**混合方案**（平衡效果与成本）：

- editable-list-item（视图用 button%，编辑切换到 text-field%）
- tree-view（自绘布局 + 原生节点控件）

**直接使用**（系统集成良好）：

- menu-bar%, popup-menu%
- dialog%, message-box
- frame%, 系统滚动条

### 5.2 racket/gui 技术限制

**圆角控件问题**：

- **现象**：canvas% 绘制圆角后，四角背后仍有直角边界
- **原因**：canvas% 本身是矩形，不支持透明背景裁剪
- **解决方案**：使用小圆角（2-3px）或直角设计，通过配色和间距体现现代感
- **参考风格**：JetBrains IDEs、VS Code 的扁平化设计

**内联编辑限制**：

- **需求**：单击文本即可编辑（如 macOS Reminders）
- **racket/gui 困境**：无法在静态显示与可编辑状态间无缝切换
- **实现方案**：
```racket
;; View mode: button% or self-drawn canvas% for display;; Edit mode: hide view, show text-field%;; Ensure position alignment through precise layout
```
- **权衡**：切换时可能有轻微视觉跳动，但保证编辑功能完整（IME、剪贴板、撤销）

**文本编辑复杂度**：

- 自绘完整文本编辑器需要实现：光标、IME、剪贴板、撤销栈、选择、双击选词等
- **策略**：基础文本输入封装原生 text-field%，避免重复造轮

### 5.3 性能优化

**虚拟滚动**（列表/表格控件）：

```racket
(define/private (render-visible-items dc)
  (define visible-start (quotient scroll-y item-height))
  (define visible-count (quotient viewport-height item-height))
  (define visible-end (+ visible-start visible-count 1))
  
  (for ([i (in-range visible-start visible-end)])
    (when (< i item-count)
      (render-item dc i))))
```

**双缓冲**（减少闪烁）：

```racket
(define offscreen-bmp (make-bitmap width height))
(define offscreen-dc (new bitmap-dc% [bitmap offscreen-bmp]))
(render-to-dc offscreen-dc)
(send screen-dc draw-bitmap offscreen-bmp 0 0)
```

### 5.4 跨平台适配

**系统字体**：

```racket
(define (get-system-font)
  (case (system-type 'os)
    [(macosx) (make-font #:face "SF Pro Text" #:size 13)]
    [(windows) (make-font #:face "Segoe UI" #:size 9)]
    [(unix) (make-font #:face "Ubuntu" #:size 11)]))
```

**快捷键修饰符**：

```racket
(define (get-modifier-key)
  (case (system-type 'os)
    [(macosx) 'cmd]
    [else 'ctrl]))
```

## 六、控件清单

### 6.1 原子控件 (atomic/)

|控件|优先级|实现方式|说明|
|---|---|---|---|
|button%|P0|自绘|标准按钮|
|label%|P0|自绘|文本标签|
|text-field%|P0|封装 + 回车/Esc|单行输入|
|text-area%|P0|封装 text%|多行输入|
|checkbox%|P0|自绘|复选框（二态/三态）|
|radio-button%|P0|自绘|单选按钮|
|choice%|P0|封装|下拉选择器|
|icon%|P0|自绘|SVG/字体图标|
|separator%|P0|自绘|分隔线|
|slider%|P1|自绘|滑块|
|switch%|P1|自绘|开关控件|
|image-view%|P1|bitmap%|图片显示|
|progress-bar%|P1|自绘|进度条|
|spinner%|P1|自绘|加载指示器|
|segmented-control%|P2|自绘|分段选择器|
|stepper%|P2|自绘|数值步进器|

### 6.2 组合控件 (composite/)

|控件|优先级|组成|说明|
|---|---|---|---|
|input-field%|P0|label + text-field|带标签的输入框|
|search-field%|P0|text-field + icon + button|搜索框|
|radio-group%|P0|radio-button[]|单选组（互斥管理）|
|list-view%|P0|scroll-view + items|列表（支持虚拟滚动）|
|editable-list-item%|P1|button/canvas + text-field|可内联编辑的列表项|
|table-view%|P1|scroll-view + grid|表格（排序、编辑）|
|tree-view%|P1|list-view + tree|树形控件|

### 6.3 容器控件 (container/)

|控件|优先级|功能|说明|
|---|---|---|---|
|panel%|P0|基础容器|封装 racket/gui panel%|
|scroll-view%|P0|可滚动容器|系统滚动条|
|h-panel%|P0|水平布局|自动排列|
|v-panel%|P0|垂直布局|自动排列|
|tab-panel%|P0|标签页|多页面切换|
|group-box%|P1|分组容器|边框 + 标题|
|split-panel%|P1|分割布局|拖拽调整|
|collapsible-panel%|P2|折叠容器|展开/折叠|

### 6.4 对话框 (dialog/)

|控件|优先级|实现方式|说明|
|---|---|---|---|
|message-box%|P0|封装 dialog%|消息提示|
|input-dialog%|P0|dialog% + text-field|输入对话框|
|confirm-dialog%|P0|dialog%|确认对话框|
|notification%|P1|自绘 canvas + timer|应用内通知|

### 6.5 菜单 (menu/)

|控件|优先级|实现方式|说明|
|---|---|---|---|
|menu-bar%|P0|直接使用 racket/gui|菜单栏|
|popup-menu%|P0|直接使用 racket/gui|右键菜单|

### 6.6 扩展控件 (extended/)

补充 racket/gui 缺失的常用控件：

|控件|优先级|实现方式|说明|
|---|---|---|---|
|color-picker%|P1|自绘|RGB/HSV 选择器|
|date-picker%|P1|自绘日历|日期选择器|
|toolbar%|P1|h-panel + buttons|工具栏容器|
|statusbar%|P1|h-panel + labels|状态栏容器|
|breadcrumb%|P2|buttons + separators|面包屑导航|
|badge%|P2|自绘|徽章提示|
|chip%|P2|button + icon|可关闭标签|
|tooltip%|P2|浮动 canvas|自定义提示框|

## 七、API 设计

### 7.1 控件创建

```racket
(new guix-button%
     [parent panel]
     [label "Click Me"]
     [enabled? #t]
     [callback (lambda (event) ...)])
```

### 7.2 状态更新

```racket
(send button set-label "New Label")
(send button set-enabled #f)
(send button invalidate)
```

### 7.3 主题应用

```racket
(send control apply-theme dark-theme)
(set-global-theme! dark-theme)
```

### 7.4 内联编辑示例

```racket
(define editable-item%
  (class horizontal-panel%
    (init-field text)
    (define editing? #f)
    (define view-control #f)
    (define edit-control #f)
    
    (define/private (enter-edit-mode)
      (set! editing? #t)
      (send view-control show #f)
      (send edit-control show #t)
      (send edit-control focus))
    
    (define/private (exit-edit-mode)
      (set! editing? #f)
      (set! text (send edit-control get-value))
      (send view-control set-label text)
      (send view-control show #t)
      (send edit-control show #f))
    
    (super-new)
    
    ;; View mode: clickable button
    (set! view-control
          (new button%
               [parent this]
               [label text]
               [style '(flat)]
               [callback (λ (b e) (enter-edit-mode))]))
    
    ;; Edit mode: text input field
    (set! edit-control
          (new text-field%
               [parent this]
               [label ""]
               [init-value text]
               [callback (λ (t e) 
                          (when (equal? (send e get-event-type) 'text-field-enter)
                            (exit-edit-mode)))]))
    
    (send edit-control show #f)))
```

## 八、命名规范

|类型|规范|示例|
|---|---|---|
|控件类|`guix-<name>%`|`guix-button%`|
|文件名|小写-连字符|`text-field.rkt`|
|函数名|小写-连字符|`set-enabled`|
|常量|大写下划线|`DEFAULT_PADDING`|
|事件|`on-<action>`|`on-click`|

## 九、版本规划

### v0.1 核心基础（2-3 个月）

**目标**：核心系统 + 基础控件

**交付**：

- 核心系统：事件、状态、主题、布局
- 原子控件（P0）：9 个
- 组合控件（P0）：4 个
- 容器控件（P0）：5 个
- 对话框（P0）：3 个
- 菜单（P0）：2 个
- 测试覆盖率 >70%

### v0.2 现代控件（2-3 个月）

**目标**：扩展控件 + 高级特性

**交付**：

- 原子控件（P1）：5 个
- 组合控件（P1）：2 个（含 editable-list-item%）
- 容器控件（P1）：2 个
- 扩展控件（P1）：4 个
- 虚拟滚动支持

### v0.3 高级控件（1-2 个月）

**目标**：完善高级控件

**交付**：

- 原子控件（P2）：2 个
- 容器控件（P2）：1 个
- 扩展控件（P2）：4 个
- 全键盘导航

### v1.0 稳定版本（1-2 个月）

**目标**：API 稳定 + 文档完善

**交付**：

- API 冻结（向后兼容承诺）
- 测试覆盖率 >85%
- 完整 Scribble 文档
- 跨平台测试通过

## 十、质量指标

### 10.1 性能指标

|指标|目标|
|---|---|
|渲染帧率|>60 FPS|
|虚拟滚动|10000+ 项流畅|
|主题切换|<100ms|
|内存占用|<50MB（100 控件）|

### 10.2 兼容性

|平台|最低版本|
|---|---|
|Racket|8.0|
|macOS|10.14|
|Windows|10|
|Linux|Ubuntu 20.04|

### 10.3 代码质量

|指标|v0.1|v1.0|
|---|---|---|
|测试覆盖率|>70%|>85%|
|文档覆盖率|100%|100%|
|平均函数长度|<30 行|<30 行|

## 十一、技术风险

|风险|影响|缓解措施|
|---|---|---|
|圆角控件视觉问题|中|采用小圆角或扁平化设计|
|内联编辑切换不流畅|中|接受合理的视觉跳动，文档中说明|
|文本编辑功能受限|中|封装原生控件，保证核心功能|
|性能不达标|中|虚拟滚动、双缓冲等优化|

## 十二、实现注意事项

### 12.1 给 AI 的实现指引

**自绘控件模板**：

```racket
(define guix-<name>%
  (class canvas%
    (init-field [enabled? #t]
                [theme (current-theme)])
    
    (define hover? #f)
    (define pressed? #f)
    
    (define/override (on-event event)
      (case (send event get-event-type)
        [(enter) (set! hover? #t) (invalidate)]
        [(leave) (set! hover? #f) (invalidate)]
        [(left-down) (set! pressed? #t) (invalidate)]
        [(left-up) 
         (set! pressed? #f)
         (when (and hover? enabled?)
           (fire-callback))
         (invalidate)]))
    
    (define/override (on-paint)
      (define dc (send this get-dc))
      (define bg-color 
        (cond [pressed? (theme-ref theme 'pressed)]
              [hover? (theme-ref theme 'hover)]
              [else (theme-ref theme 'background)]))
      
      (send dc set-brush (new brush% [color bg-color]))
      (send dc set-pen (new pen% [color (theme-ref theme 'border)]))
      (send dc draw-rectangle 0 0 width height))
    
    (super-new [style '(transparent no-focus)])))
```

**封装增强模板**：

```racket
(define guix-enhanced-text-field%
  (class text-field%
    (init-field [placeholder ""]
                [on-submit void])
    
    (define/augment (on-char event)
      (case (send event get-key-code)
        [(#\return) (on-submit (send this get-value)) #t]
        [(escape) (send this set-value "") #t]
        [else (inner #f on-char event)]))
    
    (define/override (on-paint)
      (super on-paint)
      (when (and (string=? (send this get-value) "")
                 (not (send this has-focus?)))
        (draw-placeholder)))
    
    (super-new)))
```

### 12.2 测试要求

```racket
(require rackunit)

;; Unit test example
(test-case "button state"
  (define btn (new guix-button% [label "Test"]))
  (check-true (send btn get-enabled))
  (send btn set-enabled #f)
  (check-false (send btn get-enabled)))

;; Integration test example
(test-case "theme application"
  (define panel (new guix-panel%))
  (define btn (new guix-button% [parent panel]))
  (set-global-theme! dark-theme)
  (check-equal? (send btn get-background-color)
                (theme-ref dark-theme 'background)))
```