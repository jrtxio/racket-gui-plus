<div align="center">
  <h1>✨ Guix</h1>
  <p>基于 <code>racket/gui</code> 的现代桌面控件库</p>
  <p>轻松创建美观、一致且跨平台的桌面应用程序</p>
  
  <!-- GitHub Badges -->
  <div style="margin: 1rem 0; display: flex; flex-wrap: wrap; gap: 0.5rem; justify-content: center;">
    <a href="https://github.com/jrtxio/racket-gui-plus/blob/main/LICENSE"><img src="https://img.shields.io/github/license/jrtxio/racket-gui-plus.svg" alt="License"></a>
    <a href="https://github.com/jrtxio/racket-gui-plus/stargazers"><img src="https://img.shields.io/github/stars/jrtxio/racket-gui-plus.svg?style=social" alt="GitHub Stars"></a>
    <a href="https://github.com/jrtxio/racket-gui-plus/forks"><img src="https://img.shields.io/github/forks/jrtxio/racket-gui-plus.svg?style=social" alt="GitHub Forks"></a>
    <a href="README.md"><img src="https://img.shields.io/badge/Language-English-blue.svg" alt="English"></a>
    <a href="README.zh-CN.md"><img src="https://img.shields.io/badge/%E8%AF%AD%E8%A8%80-%E4%B8%AD%E6%96%87-gray.svg" alt="中文"></a>
  </div>
  
  <!-- Demo Screenshot -->
  <div style="margin: 2rem 0; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);">
    <img src="https://via.placeholder.com/800x450?text=Guix+Demo+Screenshot" alt="Guix 演示截图" style="width: 100%; max-width: 800px; height: auto;">
  </div>
</div>

Guix 是一套基于 `racket/gui` 构建的现代化、功能丰富的桌面控件库。它提供了一套全面的跨平台 GUI 控件，在 macOS、Windows 和 Linux 上具有一致的行为。Guix 通过现代设计原则、主题支持、组合控件和高度可定制的样式增强了原生 `racket/gui` 的功能。

Guix 专为初学者和经验丰富的 Racket 开发者设计，使您能够以最小的努力创建美观、响应式的桌面应用程序，同时保持 Racket 编程语言的强大功能和灵活性。

## ✨ 功能特性

### 🎨 现代设计
- 跨平台一致的现代 UI 设计
- 内置明暗主题支持
- 可定制的配色方案和排版
- 流畅的动画和过渡效果

### 🔧 全面的控件库
- **原子控件**: 按钮、复选框、文本框、滑块等
- **组合控件**: 输入框、步进输入、分段控制
- **容器控件**: 滚动视图、标签视图、分割视图、侧边栏列表
- **扩展控件**: 日历、日期时间选择器、时间选择器、提示通知

### 📱 跨平台支持
- 基于 `racket/gui` 构建，提供原生性能
- 在 macOS、Windows 和 Linux 上行为一致
- 无需额外依赖

### 🔄 灵活的架构
- 事件驱动的编程模型
- 状态管理系统
- 可组合的控件设计
- 易于扩展和定制

### 🚀 易于使用
- 简单的 API，带有合理的默认值
- 全面的文档
- 丰富的示例和教程
- 活跃的开发社区

## 📦 控件列表

### 🧩 原子控件
原子控件是 UI 的基本构建块，提供基本的交互元素。

| 控件名称 | 类名 | 描述 |
|---------|------|------|
| 按钮 | `modern-button%` | 现代化、主题化的按钮，带有悬停效果 |
| 标签 | `label%` | 样式化文本标签，支持自定义排版 |
| 文本框 | `text-field%` | 单行文本输入框，支持占位符文本 |
| 文本区域 | `text-area%` | 多行文本输入框，支持滚动 |
| 开关 | `switch%` | 现代化的切换开关，带有流畅的动画效果 |
| 复选框 | `checkbox%` | 样式化的复选框，支持自定义外观 |
| 单选按钮 | `radio-button%` | 分组的单选按钮，用于互斥选择 |
| 滑块 | `modern-slider%` | 流畅、主题化的滑块，用于值选择 |
| 步进器 | `stepper%` | 用于数值增减的控制组件 |
| 图标 | `icon%` | 基于矢量的图标，支持颜色和大小自定义 |

### 🛠️ 组合控件
组合控件结合多个原子控件，创建更复杂的 UI 元素。

| 控件名称 | 类名 | 描述 |
|---------|------|------|
| 分类卡片 | `category-card%` | 基于卡片的布局，用于分类展示 |
| 输入框 | `input-field%` | 增强型文本输入，带有标签和验证 |
| 进度条 | `modern-progress-bar%` | 流畅的进度指示器，支持自定义样式 |
| 搜索框 | `search-field%` | 内置搜索功能的文本输入框 |
| 步进输入 | `stepper-input%` | 结合了文本框和步进器的控件 |
| 分段控制 | `segmented-control%` | 类似标签的控件，用于互斥选项 |

### 📦 容器控件
容器控件管理其他控件的布局和定位。

| 控件名称 | 类名 | 描述 |
|---------|------|------|
| 自定义列表框 | `custom-list-box%` | 可定制的列表视图，支持项目模板 |
| 滚动视图 | `scroll-view%` | 可滚动的容器，用于溢出内容 |
| 侧边面板 | `side-panel%` | 可折叠的侧边面板，用于附加内容 |
| 侧边栏列表 | `sidebar-list%` | 分层侧边栏导航，带有图标 |
| 分割视图 | `split-view%` | 可调整大小的分割窗格，用于多面板布局 |
| 标签视图 | `tab-view%` | 标签式界面，用于组织内容 |
| 堆栈视图 | `stack-view%` | 分层容器，用于管理可见内容 |

### 🌟 扩展控件
扩展控件为常见用例提供专门的功能。

| 控件名称 | 类名 | 描述 |
|---------|------|------|
| 日历 | `calendar%` | 现代化的月视图日历，支持日期选择 |
| 时间选择器 | `time-picker%` | 直观的时间选择界面 |
| 日期时间选择器 | `date-time-picker%` | 结合日期和时间选择的控件 |
| 提示通知 | `guix-toast%` | 轻量级的临时通知消息 |

## 🚀 快速开始

### 前提条件

- [Racket](https://racket-lang.org/) 8.0 或更高版本
- 基本的 Racket 编程知识
- 熟悉 `racket/gui` 会有帮助，但不是必需的

### 安装方法

使用 Racket 的包管理器安装 Guix 控件库：

```bash
raco pkg install guix
```

### Hello World 示例

一个使用 Guix 控件的简单 "Hello World" 应用：

```racket
#lang racket/gui
(require guix/guix)

;; 创建主窗口
(define frame (new frame%
                   [label "Guix Hello World"]
                   [width 400]
                   [height 200]))

;; 创建一个垂直面板来容纳我们的控件
(define panel (new vertical-panel%
                   [parent frame]
                   [alignment '(center center)]
                   [spacing 20]))

;; 添加一个样式化标签
(new label%
     [parent panel]
     [label "你好，Guix！"]
     [font (make-font #:size 24 #:face "Arial" #:weight 'bold)])

;; 添加一个现代化按钮
(new modern-button%
     [parent panel]
     [label "点击我"]
     [callback (lambda (btn evt)
                 (show-toast frame "按钮被点击了！" 2000))])

;; 显示窗口
(send frame show #t)
```

### 基本使用模式

1. **导入 Guix**
   ```racket
   (require guix/guix)
   ```

2. **创建窗口**
   ```racket
   (define frame (new frame% [label "应用标题"] [width 800] [height 600]))
   ```

3. **创建用于布局的面板**
   ```racket
   (define main-panel (new vertical-panel% [parent frame]))
   ```

4. **添加控件**
   ```racket
   (new text-field% [parent main-panel] [placeholder "请输入文本..."])
   (new modern-button% [parent main-panel] [label "提交"])
   ```

5. **显示窗口**
   ```racket
   (send frame show #t)
   ```

### 快速提示

- 使用 `show-toast` 显示简单通知
- 使用 `set-current-theme!` 尝试不同主题
- 使用面板来组织控件
- 查看 examples 目录获取更全面的示例
- 使用 DrRacket 的 REPL 进行交互式测试

## 📖 使用示例

### 日历控件

创建一个现代化的月视图日历，支持日期选择：

```racket
(define calendar
  (new calendar%
       [parent frame]
       [callback (lambda (date)
                  (printf "选择日期: ~a~n" date))]))
```

### 侧边栏列表控件

创建一个带有图标的分层侧边栏导航：

```racket
(define sidebar
  (new sidebar-list%
       [parent frame]
       [on-select (lambda (item)
                  (printf "选择项: ~a~n" (send item get-label)))]
       [items (list (list "日历" #f)
                    (list "任务" #f)
                    (list "设置" #f))]))
```

### 分段控制控件

创建一个类似标签的控件，用于互斥选项：

```racket
(define control
  (new segmented-control%
       [parent frame]
       [labels (list "选项1" "选项2" "选项3")]
       [callback (lambda (idx)
                  (printf "选择选项: ~a~n" idx))]))
```

### 提示通知

显示轻量级的临时通知消息：

```racket
;; 使用便捷函数
(show-toast frame "操作成功！" 2000)

;; 或者创建提示框实例
(define toast (new guix-toast% [parent frame]))
(send toast show-toast "操作成功！" 2000)
```

### 日期时间选择器

创建一个结合日期和时间选择的控件：

```racket
(define dt-picker
  (new date-time-picker%
       [parent frame]
       [callback (lambda (date time)
                  (printf "选择: ~a ~a~n" date time))]))
```

## 🎯 完整示例

一个综合示例，展示多个 Guix 控件协同工作：

```racket
#lang racket/gui
(require guix/guix)

;; 创建主窗口
(define frame (new frame%
                   [label "Guix 综合示例"]
                   [width 800]
                   [height 600]))

(define main-panel (new horizontal-panel% [parent frame]))

;; 左侧：侧边栏列表
(define sidebar-panel (new vertical-panel%
                           [parent main-panel]
                           [stretchable-width #f]
                           [min-width 200]))

(define sidebar
  (new sidebar-list%
       [parent sidebar-panel]
       [on-select (lambda (item)
                  (printf "选择项: ~a~n" (send item get-label)))]
       [items (list (list "日历" #f)
                    (list "任务" #f)
                    (list "设置" #f))]))

;; 右侧：主内容区
(define content-panel (new vertical-panel% [parent main-panel]))

;; 顶部：分段控制
(define seg-panel (new horizontal-panel%
                         [parent content-panel]
                         [stretchable-height #f]
                         [border 10]
                         [alignment '(center center)]))

(new segmented-control%
     [parent seg-panel]
     [labels (list "全部" "活跃" "已完成")]
     [selected-index 0])

;; 中部：日历控件
(define calendar
  (new calendar%
       [parent content-panel]
       [callback (lambda (date)
                  (show-toast frame (format "选择了: ~a" date) 1500))]))

;; 底部：输入框和按钮
(define input-panel (new horizontal-panel%
                         [parent content-panel]
                         [stretchable-height #f]
                         [border 10]))

(define input-field
  (new text-field%
       [parent input-panel]
       [placeholder "输入任务..."]
       [stretchable-width #t]))

(new modern-button%
     [parent input-panel]
     [label "添加任务"]
     [stretchable-width #f]
     [callback (lambda (btn evt)
                (define text (send input-field get-value))
                (unless (string=? (string-trim text) "")
                  (show-toast frame (format "添加了: ~a" text) 1500)
                  (send input-field set-value "")))])

;; 显示窗口
(send frame show #t)
```

## 📚 API 参考

### 🧩 原子控件

#### 按钮 (`modern-button%`)
```racket
(new modern-button% [parent parent] [label label] [callback callback] [style style])
```
- **参数**:
  - `parent`: 父容器
  - `label`: 按钮文本
  - `callback`: 点击回调函数
  - `style`: 按钮样式（可选）
- **方法**:
  - `(send btn get-label)`: 获取按钮文本
  - `(send btn set-label label)`: 设置按钮文本
  - `(send btn enable [enable? #t])`: 启用/禁用按钮

#### 文本框 (`text-field%`)
```racket
(new text-field% [parent parent] [label label] [init-value init-value] [placeholder placeholder])
```
- **参数**:
  - `parent`: 父容器
  - `label`: 标签文本（可选）
  - `init-value`: 初始值（可选）
  - `placeholder`: 占位符文本（可选）
- **方法**:
  - `(send tf get-value)`: 获取当前文本值
  - `(send tf set-value value)`: 设置文本值
  - `(send tf get-placeholder)`: 获取占位符文本
  - `(send tf set-placeholder placeholder)`: 设置占位符文本

#### 标签 (`label%`)
```racket
(new label% [parent parent] [label label] [font font] [color color])
```
- **参数**:
  - `parent`: 父容器
  - `label`: 标签文本
  - `font`: 字体对象（可选）
  - `color`: 文本颜色（可选）
- **方法**:
  - `(send lbl get-label)`: 获取标签文本
  - `(send lbl set-label label)`: 设置标签文本

### 🛠️ 组合控件

#### 分段控制 (`segmented-control%`)
```racket
(new segmented-control% [parent parent] [labels labels] [selected-index selected-index] [callback callback])
```
- **参数**:
  - `parent`: 父容器
  - `labels`: 分段标签列表
  - `selected-index`: 初始选中索引（可选，默认：0）
  - `callback`: 选择变化回调函数
- **方法**:
  - `(send sc get-selected-index)`: 获取当前选中索引
  - `(send sc set-selected-index idx)`: 设置选中索引

#### 进度条 (`modern-progress-bar%`)
```racket
(new modern-progress-bar% [parent parent] [value value] [max-value max-value])
```
- **参数**:
  - `parent`: 父容器
  - `value`: 当前进度值（可选，默认：0）
  - `max-value`: 最大进度值（可选，默认：100）
- **方法**:
  - `(send pb get-value)`: 获取当前进度值
  - `(send pb set-value value)`: 设置进度值
  - `(send pb get-max-value)`: 获取最大进度值
  - `(send pb set-max-value max-value)`: 设置最大进度值

### 📦 容器控件

#### 侧边栏列表 (`sidebar-list%`)
```racket
(new sidebar-list% [parent parent] [items items] [on-select on-select])
```
- **参数**:
  - `parent`: 父容器
  - `items`: 侧边栏项列表（每项为一个列表：`(label icon)`）
  - `on-select`: 项选择回调函数
- **方法**:
  - `(send sl get-selected-item)`: 获取当前选中项
  - `(send sl set-selected-item item)`: 设置选中项

#### 标签视图 (`tab-view%`)
```racket
(new tab-view% [parent parent] [tabs tabs] [callback callback])
```
- **参数**:
  - `parent`: 父容器
  - `tabs`: 标签配置列表
  - `callback`: 标签变化回调函数
- **方法**:
  - `(send tv get-selected-tab)`: 获取当前选中标签
  - `(send tv set-selected-tab tab)`: 设置选中标签

### 🌟 扩展控件

#### 日历 (`calendar%`)
```racket
(new calendar% [parent parent] [callback callback])
```
- **参数**:
  - `parent`: 父容器
  - `callback`: 日期选择回调函数
- **方法**:
  - `(send cal get-selected-date)`: 获取当前选中日期
  - `(send cal set-selected-date date)`: 设置选中日期

#### 提示通知 (`guix-toast%`)
```racket
(new guix-toast% [parent parent])
```
- **参数**:
  - `parent`: 父容器
- **方法**:
  - `(send toast show-toast message duration)`: 显示提示通知
    - `message`: 提示消息
    - `duration`: 显示时长（毫秒，默认：2000）

#### 日期时间选择器 (`date-time-picker%`)
```racket
(new date-time-picker% [parent parent] [callback callback])
```
- **参数**:
  - `parent`: 父容器
  - `callback`: 日期时间选择回调函数
- **方法**:
  - `(send dtp get-date-time)`: 获取选中的日期和时间
  - `(send dtp set-date-time date time)`: 设置日期和时间

### 🎨 主题 API

#### 设置当前主题
```racket
(set-current-theme! theme)
```
- **参数**:
  - `theme`: 主题名称（`'light` 或 `'dark`）

#### 刷新所有控件
```racket
(refresh-all-widgets)
```
- **描述**: 刷新所有 Guix 控件以应用主题变化

### 📞 工具函数

#### 显示提示通知
```racket
(show-toast parent message [duration 2000])
```
- **参数**:
  - `parent`: 父窗口
  - `message`: 提示消息
  - `duration`: 显示时长（毫秒，默认：2000）

## 👨‍💻 开发指南

### 设置开发环境

1. **克隆仓库**:
   ```bash
   git clone https://github.com/jrtxio/racket-gui-plus.git
   cd racket-gui-plus
   ```

2. **安装依赖**:
   ```bash
   raco pkg install --auto
   ```

3. **运行测试**以确保一切正常工作:
   ```bash
   raco test -t tests/
   ```

### 运行示例

探索示例，查看 Guix 控件的实际效果:

```bash
racket examples/comprehensive-demo.rkt
racket examples/button-demo.rkt
racket examples/calendar-demo.rkt
```

### 运行测试

#### 单元测试
```bash
raco test -t tests/unit/
```

#### 所有测试
```bash
raco test -t tests/
```

### 项目结构

```
├── guix/              # 主库代码
│   ├── atomic/        # 基本控件（按钮、标签等）
│   ├── composite/     # 组合控件
│   ├── container/     # 布局容器
│   ├── core/          # 核心功能
│   ├── extended/      # 专业控件
│   └── style/         # 主题和样式
├── examples/          # 示例应用
├── scribblings/       # 文档
└── tests/             # 测试套件
```

### 贡献

1. **Fork 仓库**
2. **创建特性分支** (`git checkout -b feature/AmazingFeature`)
3. **进行修改**
4. **运行测试**确保通过
5. **提交更改** (`git commit -m 'Add some AmazingFeature'`)
6. **推送分支** (`git push origin feature/AmazingFeature`)
7. **打开 Pull Request**

### 代码风格指南

- 遵循 Racket 的 [风格指南](https://docs.racket-lang.org/style/index.html)
- 使用一致的缩进（2 个空格）
- 编写清晰、描述性的注释
- 为新功能添加单元测试
- 添加新功能时更新文档

### 构建文档

```bash
raco scribble --html --dest doc scribblings/guix.scrbl
```

文档将生成在 `doc` 目录中。

## 📄 许可证

本库采用 MIT 许可证，您可以自由使用、修改和分发。

## 🤝 贡献

欢迎提交问题报告、功能请求和拉取请求！

### 报告问题

如果您遇到任何错误或有改进建议，请在 GitHub 上 [创建问题](https://github.com/jrtxio/racket-gui-plus/issues)。

### 提交拉取请求

我们欢迎贡献！请按照 [开发指南](#-开发指南) 设置您的环境并提交您的更改。