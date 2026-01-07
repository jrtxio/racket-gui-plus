# Racket GUI Plus 使用指南

## 目录

- [安装](#安装)
- [基本使用](#基本使用)
- [控件示例](#控件示例)
- [主题切换](#主题切换)
- [常见用例](#常见用例)
- [最佳实践](#最佳实践)

## 安装

### 从源码安装

1. 克隆或下载项目源码
2. 将项目目录添加到 Racket 的 `collects` 目录中，或使用 `raco link` 命令链接
3. 或者直接在项目目录中使用，通过相对路径导入

## 基本使用

### 导入库

```racket
#lang racket/gui

;; 从项目目录中导入
(require "../src/gui-plus.rkt")

;; 或者如果已安装到 collects 目录
;; (require gui-plus)
```

### 创建基本窗口

```racket
#lang racket/gui

(require "../src/gui-plus.rkt")

;; 创建主窗口
(define frame (new frame% [label "Racket GUI Plus 示例"]
                          [width 800]
                          [height 600]))

;; 添加控件...

;; 显示窗口
(send frame show #t)
```

## 控件示例

### 原子控件

#### 按钮 (button%)

```racket
(define button (new button% [parent frame]
                            [label "点击我"]
                            [callback (λ (btn event) (printf "按钮被点击！\n"))]))
```

#### 标签 (label%)

```racket
(define label (new label% [parent frame]
                          [label "这是一个标签"]))
```

#### 文本框 (text-field%)

```racket
(define text-field (new text-field% [parent frame]
                                    [label "输入文本："]
                                    [init-value "默认值"]))
```

### 复合控件

#### 过滤按钮 (filter-button%)

```racket
(define filter-btn (new filter-button% [parent frame]
                                       [label "Today"]
                                       [count 10]
                                       [icon-symbol "📅"]
                                       [callback (λ () (printf "过滤按钮被点击！\n"))]))
```

#### 进度条 (modern-progress-bar%)

```racket
(define progress-bar (new modern-progress-bar% [parent frame]
                                               [min-width 300]
                                               [value 50]))

;; 更新进度
(send progress-bar set-value 75)
```

### 容器控件

#### 侧边栏列表 (sidebar-list%)

```racket
(define sidebar (new sidebar-list% [parent frame]
                                   [min-width 200]))

;; 添加列表项
(send sidebar add-item (list-item "项目1" "📄"))
(send sidebar add-item (list-item "项目2" "📁"))
(send sidebar add-item (list-item "项目3" "🔧"))
```

#### 标签页 (tab-view%)

```racket
(define tab-view (new tab-view% [parent frame]))

;; 添加标签页
(define tab1 (send tab-view add-tab "标签1"))
(define tab2 (send tab-view add-tab "标签2"))

;; 向标签页添加控件
(new button% [parent tab1] [label "标签1中的按钮"])
(new button% [parent tab2] [label "标签2中的按钮"])
```

### 应用控件

#### 日历 (calendar%)

```racket
(define calendar (new calendar% [parent frame]
                                [callback (λ (date) (printf "选择了日期：~a\n" date))]))
```

#### 时间选择器 (time-picker%)

```racket
(define time-picker (new time-picker% [parent frame]
                                      [callback (λ (time) (printf "选择了时间：~a\n" time))]))
```

#### 提示框 (toast-info%)

```racket
;; 创建提示框
(define toast (new modern-toast% [parent frame]))

;; 显示提示
(show-toast toast "操作成功！" 'success)
(show-toast toast "警告信息" 'warning)
(show-toast toast "错误信息" 'error)
```

## 主题切换

### 设置主题

```racket
;; 切换到暗色主题
(set-theme! 'dark)

;; 切换到亮色主题
(set-theme! 'light)

;; 使用自定义主题
(define custom-theme
  (theme
   ;; 圆角配置
   8   ; border-radius-small
   12  ; border-radius-medium
   16  ; border-radius-large
   
   ;; 背景色
   (make-object color% 255 255 255)  ; color-bg-white
   (make-object color% 245 245 245)  ; color-bg-light
   (make-object color% 255 255 255 0.95)  ; color-bg-overlay
   
   ;; 其他主题属性...
   ))

(set-theme! custom-theme)
```

### 获取当前主题

```racket
(define current-theme (current-theme))
```

### 主题变更回调

```racket
;; 注册主题变更回调
(register-theme-callback
 (λ (new-theme)
   (printf "主题已切换到：~a\n" (if (equal? new-theme light-theme) "light" "dark"))))
```

## 常见用例

### 创建带侧边栏的应用

```racket
#lang racket/gui

(require "../src/gui-plus.rkt")

(define frame (new frame% [label "带侧边栏的应用"]
                          [width 1000]
                          [height 700]))

;; 创建分割视图
(define split-view (new split-view% [parent frame]
                                    [orientation 'vertical]
                                    [position 200]))

;; 在左侧添加侧边栏列表
(define sidebar (new sidebar-list% [parent (send split-view get-left-panel)]))
(send sidebar add-item (list-item "首页" "🏠"))
(send sidebar add-item (list-item "设置" "⚙️"))
(send sidebar add-item (list-item "关于" "ℹ️"))

;; 在右侧添加主内容
(define main-panel (send split-view get-right-panel))
(new label% [parent main-panel] [label "主内容区域"])
(new button% [parent main-panel] [label "点击我"])

(send frame show #t)
```

### 创建带标签页的应用

```racket
#lang racket/gui

(require "../src/gui-plus.rkt")

(define frame (new frame% [label "带标签页的应用"]
                          [width 800]
                          [height 600]))

;; 创建标签页控件
(define tab-view (new tab-view% [parent frame]))

;; 添加标签页
(define tab1 (send tab-view add-tab "用户管理"))
(define tab2 (send tab-view add-tab "数据统计"))
(define tab3 (send tab-view add-tab "系统设置"))

;; 向标签页添加控件
(new button% [parent tab1] [label "添加用户"])
(new button% [parent tab2] [label "生成报表"])
(new button% [parent tab3] [label "保存设置"])

(send frame show #t)
```

### 创建带过滤功能的列表

```racket
#lang racket/gui

(require "../src/gui-plus.rkt")

(define frame (new frame% [label "带过滤功能的列表"]
                          [width 600]
                          [height 400]))

;; 创建垂直面板
(define vertical-panel (new vertical-panel% [parent frame]
                                            [style '(border)]
                                            [spacing 10]
                                            [alignment '(center top)]))

;; 添加过滤按钮
(define filter-btn (new filter-button% [parent vertical-panel]
                                       [label "全部"]
                                       [count 100]))

;; 添加列表
(define list-box (new list-box% [parent vertical-panel]
                                [label #f]
                                [choices '("项目1" "项目2" "项目3" "项目4" "项目5")]
                                [min-height 200]))

(send frame show #t)
```

## 最佳实践

### 控件组织

1. **使用面板组织控件**：使用 `vertical-panel%`、`horizontal-panel%` 等面板控件来组织和布局你的 UI 元素
2. **合理使用容器控件**：对于复杂应用，使用 `split-view%`、`tab-view%` 等容器控件来划分功能区域
3. **保持控件层次清晰**：避免过深的控件嵌套，保持 UI 结构清晰

### 事件处理

1. **使用回调函数**：为控件添加合适的回调函数来处理用户交互
2. **避免长时间运行的回调**：如果回调函数需要执行耗时操作，考虑使用线程或异步机制
3. **合理处理事件冒泡**：了解 Racket GUI 库的事件传递机制，避免不必要的事件处理

### 主题和样式

1. **使用主题系统**：尽量使用主题系统提供的样式，而不是硬编码颜色、字体等
2. **支持主题切换**：确保你的控件在主题切换时能正确刷新
3. **保持视觉一致性**：使用统一的主题和样式，确保整个应用的视觉一致性

### 性能优化

1. **延迟创建控件**：对于复杂应用，考虑延迟创建某些控件，只在需要时才创建
2. **避免不必要的刷新**：仅在必要时调用控件的 `refresh` 方法
3. **合理使用画布**：对于自定义绘制的控件，优化绘制逻辑，避免不必要的计算和绘制

### 代码组织

1. **模块化设计**：将不同功能的代码组织到不同的模块中
2. **封装复杂逻辑**：将复杂的 UI 逻辑封装到自定义控件中
3. **使用面向对象设计**：充分利用 Racket 的面向对象特性，创建可重用的控件类

## 故障排除

### 控件不显示

1. 确保已将控件添加到父容器中
2. 检查父容器的布局和尺寸设置
3. 确保父容器已添加到可见的窗口中

### 主题切换不生效

1. 确保控件已正确注册到主题系统中
2. 检查控件的绘制逻辑是否使用了主题提供的样式
3. 尝试手动调用控件的 `refresh` 方法

### 控件响应缓慢

1. 检查控件的事件处理逻辑，避免耗时操作
2. 优化自定义绘制逻辑
3. 考虑使用线程处理复杂计算

## 示例项目

查看项目的 `examples/` 目录，包含多个完整的示例：

- `example.rkt`：综合示例
- `test-gui-plus.rkt`：控件测试
- `test-simple.rkt`：简单示例
- `test-progress.rkt`：进度条示例

运行示例：

```bash
racket examples/example.rkt
```

## API 参考

### 核心函数

- `set-theme!`：切换主题
- `current-theme`：获取当前主题
- `register-theme-callback`：注册主题变更回调
- `register-widget`：注册控件，用于主题切换时刷新
- `refresh-all-widgets`：刷新所有注册的控件

### 样式访问函数

- `border-radius-small`、`border-radius-medium`、`border-radius-large`：获取圆角大小
- `color-bg-white`、`color-bg-light`、`color-bg-overlay`：获取背景色
- `color-border`、`color-border-hover`、`color-border-focus`：获取边框色
- `color-text-main`、`color-text-light`、`color-text-placeholder`：获取文字色
- `color-accent`、`color-success`、`color-error`、`color-warning`：获取功能色
- `font-small`、`font-regular`、`font-medium`、`font-large`：获取字体
- `input-height`、`button-height`、`progress-bar-height`：获取控件尺寸
- `spacing-small`、`spacing-medium`、`spacing-large`：获取间距

## 版本历史

### 0.1.0
- 初始版本
- 包含基本控件集合
- 支持主题切换

## 贡献

欢迎提交问题和拉取请求！请遵循项目的代码风格和贡献指南。

## 许可证

本项目采用 MIT 许可证，详见项目根目录下的 `LICENSE` 文件。
