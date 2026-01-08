## 一、技术概述

### 1.1 定位

基于 `racket/gui` 的跨平台桌面控件库，提供统一的交互体验和主题系统。

### 1.2 设计原则

|原则|说明|
|---|---|
|务实优先|利用 racket/gui 原生能力，避免重复造轮|
|渐进增强|分阶段实现，优先保证核心功能|
|行为一致|跨平台交互逻辑统一，接受视觉差异|
|组合优先|通过组合原子控件构建复杂功能|

### 1.3 技术约束

- 基于 racket/gui，不依赖外部 GUI 框架
- 支持 macOS、Windows、Linux
- 不使用 JNI、FFI 调用系统 API
- 纯 Racket 实现

## 二、架构设计

### 2.1 目录结构

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
│  └─ extended/             # 扩展控件（racket/gui 缺失的常用控件）
│     ├─ color-picker.rkt   # 颜色选择器
│     ├─ date-picker.rkt    # 日期选择器
│     ├─ toolbar.rkt        # 工具栏
│     ├─ statusbar.rkt      # 状态栏
│     ├─ breadcrumb.rkt     # 面包屑导航
│     ├─ badge.rkt          # 徽章提示
│     ├─ chip.rkt           # 标签芯片
│     └─ tooltip.rkt        # 自定义提示
├─ tests/
│  ├─ unit/
│  └─ integration/
├─ examples/
└─ scribblings/
```

### 2.2 分层架构

```
┌─────────────────────────────────────┐
│  扩展控件 (extended)                 │  补充 racket/gui 缺失的常用控件
├─────────────────────────────────────┤
│  菜单 (menu)                         │
├─────────────────────────────────────┤
│  对话框 (dialog)                     │
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

## 三、核心系统

### 3.1 控件基类

```racket
(define guix-base-control%
  (class canvas%
    (init-field [enabled? #t]
                [visible? #t]
                [theme (current-theme)])
    
    ; 状态管理
    (define/public (get-enabled) enabled?)
    (define/public (set-enabled e) 
      (set! enabled? e)
      (invalidate))
    
    ; 事件处理
    (define/override (on-event event) ...)
    
    ; 绘制
    (define/override (on-paint) ...)
    
    (super-new)))
```

### 3.2 事件系统

**事件类型**：

|事件名|触发时机|参数|
|---|---|---|
|on-click|鼠标点击|event-data|
|on-double-click|双击|event-data|
|on-hover|鼠标悬停|event-data|
|on-change|值变化|new-value|
|on-focus|获得焦点|-|
|on-blur|失去焦点|-|

**事件传播**：

```racket
; 子控件向父控件冒泡
(define (handle-event event)
  (unless (send event stopped?)
    ; 处理事件
    (when (has-parent?)
      (send parent handle-event event))))
```

### 3.3 状态管理

**状态类型**：

- **本地状态**：控件内部状态（hover, pressed, focused）
- **受控状态**：由父组件管理（value, selected）

**响应式更新**：

```racket
(define/public (set-value v)
  (set! value v)
  (invalidate)              ; 触发重绘
  (fire-event 'on-change v)) ; 触发回调
```

### 3.4 主题系统

**主题定义**：

```racket
(define-theme light-theme
  #:colors (hash 'primary "#007AFF"
                 'background "#FFFFFF"
                 'text "#000000"
                 'border "#D1D1D6"
                 'hover "#E5E5EA"
                 'disabled "#C7C7CC")
  #:metrics (hash 'corner-radius 6
                  'padding 8
                  'spacing 8
                  'border-width 1)
  #:typography (hash 'size 13
                     'weight 400
                     'family (get-system-font)))
```

**主题切换**：

```racket
; 全局切换
(set-global-theme! dark-theme)

; 局部覆盖
(new guix-panel% [theme custom-theme])
```

### 3.5 布局引擎

**布局模式**：

|模式|说明|实现|
|---|---|---|
|stack|垂直/水平堆叠|基于 racket/gui panel%|
|flow|流式布局|自动换行|
|grid|网格布局|行列定位|

**约束系统**：

```racket
(define constraint
  (hash 'min-width 100
        'max-width 500
        'preferred-width 300
        'stretch 1.0))
```

## 四、控件清单

### 4.1 原子控件 (atomic/)

|控件|优先级|实现方式|关键技术|说明|
|---|---|---|---|---|
|button%|P0|自绘|hover/pressed 状态|标准按钮|
|label%|P0|自绘|文本渲染|文本标签|
|text-field%|P0|自绘|文本编辑、光标|单行输入|
|text-area%|P0|自绘|多行文本、滚动|多行输入|
|checkbox%|P0|自绘|二态/三态|复选框|
|radio-button%|P0|自绘|组管理|单选按钮|
|choice%|P0|封装 racket/gui|下拉选择|下拉选择器|
|icon%|P0|自绘|SVG/字体图标|图标显示|
|separator%|P0|自绘|水平/垂直线|分隔线|
|slider%|P1|自绘|拖拽交互|滑块|
|switch%|P1|自绘|开关动画|现代开关控件|
|image-view%|P1|bitmap%|图片显示|图片显示|
|progress-bar%|P1|自绘|进度显示|进度条|
|spinner%|P1|自绘|旋转动画|加载指示器|
|segmented-control%|P2|自绘|段选择逻辑|分段选择器|
|stepper%|P2|自绘|增减逻辑|数值步进器|

### 4.2 组合控件 (composite/)

|控件|优先级|组成|关键技术|
|---|---|---|---|
|input-field%|P0|label + text-field|表单输入|
|search-field%|P0|text-field + icon + button|搜索功能|
|radio-group%|P0|radio-button[]|互斥管理|
|list-view%|P0|scroll-view + items|虚拟滚动|
|table-view%|P1|scroll-view + grid|排序、编辑|
|tree-view%|P1|list-view + tree|树形展开|

### 4.3 容器控件 (container/)

|控件|优先级|功能|关键技术|说明|
|---|---|---|---|---|
|panel%|P0|基础容器|封装 racket/gui|基础面板|
|scroll-view%|P0|可滚动|系统滚动条|滚动容器|
|h-panel%|P0|水平布局|自动布局|水平排列|
|v-panel%|P0|垂直布局|自动布局|垂直排列|
|tab-panel%|P0|标签页|页面切换|多页面切换|
|group-box%|P1|分组容器|边框 + 标题|分组显示|
|split-panel%|P1|分割布局|拖拽调整|可调整分割|
|collapsible-panel%|P2|折叠容器|展开/折叠动画|可折叠内容|

### 4.4 对话框与通知 (dialog/)

|控件|优先级|实现方式|说明|
|---|---|---|---|
|message-box%|P0|dialog%|消息提示|
|input-dialog%|P0|dialog% + text-field|输入对话框|
|confirm-dialog%|P0|dialog%|确认对话框|
|notification%|P1|自绘 canvas + timer|应用内通知|

### 4.6 扩展控件 (extended/)

**说明**：这些控件是 racket/gui 缺失但跨平台应用常用的控件

|控件|优先级|实现方式|关键技术|说明|
|---|---|---|---|---|
|color-picker%|P1|自绘|RGB/HSV 选择器|颜色选择器|
|date-picker%|P1|自绘日历|日期计算|日期选择器|
|toolbar%|P1|h-panel + buttons|工具按钮布局|工具栏容器|
|statusbar%|P1|h-panel + labels|状态显示|状态栏容器|
|breadcrumb%|P2|buttons + separators|导航逻辑|面包屑导航|
|badge%|P2|自绘|数字/圆点提示|徽章提示|
|chip%|P2|button + icon|可关闭标签|标签芯片|
|tooltip%|P2|浮动 canvas|自定义样式|自定义提示框|

|控件|优先级|实现方式|说明|
|---|---|---|---|
|menu-bar%|P0|racket/gui 原生|菜单栏|
|popup-menu%|P0|racket/gui 原生|右键菜单|

**注**：window% 使用 racket/gui frame%，toolbar% 和 status-bar% 用普通 panel% 实现

## 五、实现策略

### 5.1 利用原生能力

|功能|racket/gui|Guix 策略|理由|
|---|---|---|---|
|下拉选择|choice%|封装 + 主题|跨平台一致|
|列表框|list-box%|封装 + 虚拟滚动|基础能力完善|
|菜单|popup-menu, menu-bar%|直接使用|系统集成好|
|对话框|dialog%, message-box|封装|模态机制完善|
|窗口|frame%|直接使用|无需自定义|
|滚动条|系统滚动条|直接使用|跨平台体验好|

### 5.2 自绘控件策略

**完全自绘**（跨平台一致性好，提升现代感）：

- button, label, text-field, text-area
- checkbox, radio-button
- slider, switch, progress-bar
- icon, separator
- segmented-control, stepper
- notification

**封装原生**（利用系统能力）：

- choice (下拉选择)
- list-box (列表框)
- dialog (对话框)
- menu (菜单)

**扩展控件**（racket/gui 缺失的常用控件）：

- color-picker, date-picker
- toolbar, statusbar
- breadcrumb, badge, chip
- tooltip (自定义样式)

**设计原则**：

1. 基础交互控件自绘，保证一致体验和现代外观
2. 复杂系统集成用原生，降低实现成本
3. 扩展控件补充 racket/gui 的不足
4. 所有控件统一应用主题颜色和字体

### 5.3 性能优化

**虚拟滚动**：

```racket
(define/private (render-visible-items dc)
  (define visible-start (quotient scroll-y item-height))
  (define visible-count (quotient viewport-height item-height))
  (define visible-end (+ visible-start visible-count 1))
  
  (for ([i (in-range visible-start visible-end)])
    (when (< i item-count)
      (render-item dc i))))
```

**脏矩形更新**：

```racket
(define/public (invalidate-region x y w h)
  (send canvas refresh-now x y w h))
```

**双缓冲**：

```racket
(define offscreen-bmp (make-bitmap width height))
(define offscreen-dc (new bitmap-dc% [bitmap offscreen-bmp]))

; 先绘制到离屏位图
(render-to-dc offscreen-dc)

; 再一次性绘制到屏幕
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

**DPI 缩放**：

```racket
(define (get-scale-factor)
  (case (system-type 'os)
    [(macosx) 
     ; Retina 自动处理
     1.0]
    [(windows)
     ; 读取系统 DPI
     (/ (get-display-dpi) 96.0)]
    [(unix)
     ; 读取 Xft.dpi
     (/ (get-xft-dpi) 96.0)]))
```

**键盘快捷键**：

```racket
(define (get-modifier-key)
  (case (system-type 'os)
    [(macosx) 'cmd]
    [(windows unix) 'ctrl]))
```

## 六、版本规划

### v0.1 核心基础（2-3 个月）

**目标**：核心系统 + 基础控件

**内容**：

- 核心系统：事件、状态、主题、布局
- 原子控件（P0）：9 个
- 组合控件（P0）：4 个
- 容器控件（P0）：5 个
- 对话框（P0）：3 个
- 菜单（P0）：2 个
- 单元测试框架

**技术交付**：

- 控件基类完成
- 主题系统可用
- 代码覆盖率 >70%
- 跨平台测试通过

### v0.2 现代控件（2-3 个月）

**目标**：扩展现代 UI 控件 + 高级特性

**内容**：

- 原子控件（P1）：5 个（含 switch, notification）
- 组合控件（P1）：2 个
- 容器控件（P1）：2 个
- 拖拽支持
- 虚拟滚动

**技术交付**：

- 现代控件体验良好
- 拖拽系统完成
- 虚拟滚动可处理 10000+ 项

### v0.3 高级控件（1-2 个月）

**目标**：完善高级控件

**内容**：

- 原子控件（P2）：2 个（segmented-control, stepper）
- 容器控件（P2）：1 个（collapsible-panel）
- 完整键盘导航

**技术交付**：

- 全键盘操作支持
- 高级控件完成

### v1.0 稳定版本（1-2 个月）

**目标**：API 稳定 + 文档完善

**内容**：

- API 冻结
- 全平台测试
- 完整文档
- 性能优化

**技术交付**：

- API 向后兼容承诺
- 测试覆盖率 >85%
- 文档覆盖率 100%

## 七、技术规范

### 7.1 命名规范

|类型|规范|示例|
|---|---|---|
|控件类|`guix-<name>%`|`guix-button%`|
|文件名|小写-连字符|`text-field.rkt`|
|函数名|小写-连字符|`set-enabled`|
|常量|大写下划线|`DEFAULT_PADDING`|
|事件|`on-<action>`|`on-click`|

### 7.2 API 设计

**控件创建**：

```racket
(new guix-button%
     [parent panel]
     [label "Click Me"]
     [enabled? #t]
     [on-click (lambda (e) ...)])
```

**状态更新**：

```racket
(send button set-label "New Label")
(send button set-enabled #f)
(send button invalidate)
```

**主题应用**：

```racket
(send control apply-theme dark-theme)
(set-global-theme! dark-theme)
```

### 7.3 测试规范

**单元测试**：

```racket
(require rackunit)

(test-case "button state"
  (define btn (new guix-button% [label "Test"]))
  (check-true (send btn get-enabled))
  (send btn set-enabled #f)
  (check-false (send btn get-enabled)))
```

**集成测试**：

```racket
(test-case "theme switch"
  (define panel (new guix-panel%))
  (define btn (new guix-button% [parent panel]))
  (set-global-theme! dark-theme)
  (check-equal? (send btn get-background-color) 
                (theme-ref dark-theme 'background)))
```

**覆盖率要求**：

- 所有公开 API：100%
- 核心逻辑：>90%
- 整体：>80%

### 7.4 文档规范

**Scribble 文档**：

```racket
@defclass[guix-button% canvas% ()]{
  标准按钮控件。

  @defconstructor[([parent (or/c frame% panel%)]
                   [label string?]
                   [enabled? boolean? #t]
                   [on-click (-> any/c any) void])]{
    创建一个按钮。
  }

  @defmethod[(set-label [label string?]) void?]{
    设置按钮文本。
  }
}
```

## 八、技术指标

### 8.1 性能指标

|指标|目标|测试方法|
|---|---|---|
|渲染帧率|>60 FPS|动画测试|
|虚拟滚动|10000+ 项流畅|大数据集测试|
|主题切换|<100ms|计时测试|
|内存占用|<50MB (100 控件)|内存分析|

### 8.2 兼容性指标

|平台|最低版本|测试版本|
|---|---|---|
|Racket|8.0|8.0, 8.12|
|macOS|10.14|10.14, 14.0|
|Windows|10|10, 11|
|Linux|Ubuntu 20.04|Ubuntu 20.04, 24.04|

### 8.3 代码质量指标

|指标|v0.1|v1.0|
|---|---|---|
|测试覆盖率|>70%|>85%|
|文档覆盖率|100%|100%|
|静态分析|0 错误|0 错误|
|平均函数长度|<30 行|<30 行|

## 九、技术风险

|风险|影响|缓解措施|
|---|---|---|
|跨平台渲染差异|中|持续三平台测试，接受合理差异|
|性能不达标|中|虚拟滚动、双缓冲等优化技术|
|自绘文本编辑复杂|高|先用基础实现，逐步完善|

## 十、参考资料

- [racket/gui 文档](https://docs.racket-lang.org/gui/)
- [racket/draw 文档](https://docs.racket-lang.org/draw/)
- [HIG - macOS](https://developer.apple.com/design/human-interface-guidelines/)
- [Material Design](https://material.io/design)