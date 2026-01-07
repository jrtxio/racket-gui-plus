<div align="center">
  <h1>Guix</h1>
  <p>📱 基于 racket/gui 的现代桌面控件库</p>
  
  <!-- GitHub Badges -->
  <div style="margin: 1rem 0;">
    <a href="https://github.com/yourusername/guix/blob/main/LICENSE"><img src="https://img.shields.io/github/license/yourusername/guix.svg" alt="License"></a>
    <a href="https://github.com/yourusername/guix/stargazers"><img src="https://img.shields.io/github/stars/yourusername/guix.svg?style=social" alt="GitHub Stars"></a>
    <a href="https://github.com/yourusername/guix/forks"><img src="https://img.shields.io/github/forks/yourusername/guix.svg?style=social" alt="GitHub Forks"></a>
    <a href="https://github.com/yourusername/guix"><img src="https://img.shields.io/badge/GitHub-Project-blue.svg" alt="GitHub Project"></a>
    <a href="README.md"><img src="https://img.shields.io/badge/Language-English-blue.svg" alt="English"></a>
    <a href="README.zh-CN.md"><img src="https://img.shields.io/badge/%E8%AF%AD%E8%A8%80-%E4%B8%AD%E6%96%87-gray.svg" alt="中文"></a>
  </div>
</div>

Guix 是一套基于 `racket/gui` 的现代桌面控件库，提供跨平台一致行为的 GUI 控件，支持主题化、组合控件、自定义样式，适用于 macOS、Windows 和 Linux。

## 控件列表

### 1. 日历控件 (calendar%)
现代化的月视图日历控件，支持选择日期。

### 2. 侧边栏控件 (modern-sidebar%)
现代化的侧边栏控件，支持多级列表和图标显示。

### 3. 过滤按钮控件 (filter-button%)
用于过滤功能的按钮组，支持单选和互斥选择。

### 4. 文本框控件 (text-field%)
现代化的单行文本输入框，支持占位符文本和焦点效果。

### 5. 提示框控件 (modern-toast%)
轻量级的提示框，用于显示临时消息。

### 6. 待办事项列表控件 (todo-list%)
功能完整的待办事项列表，支持添加、编辑、删除和标记完成。

## 安装方法

使用以下命令安装 Guix 控件库：

```bash
raco pkg install guix
```

## 使用方法

### 导入库

```racket
#lang racket/gui
(require guix/guix)
```

### 创建窗口

```racket
(define frame (new frame%
                   [label "Guix 示例"]
                   [width 800]
                   [height 600]))
```

### 1. 使用日历控件

```racket
(define calendar
  (new calendar%
       [parent frame]
       [callback (lambda (date)
                  (printf "选择日期: ~a~n" date))]))
```

### 2. 使用侧边栏控件

```racket
(define sidebar
  (new modern-sidebar%
       [parent frame]
       [on-select (lambda (item)
                  (printf "选择项: ~a~n" (send item get-label)))]))

;; 添加菜单项
(send sidebar add-item (make-apple-item "菜单项1" #f))
(send sidebar add-item (make-apple-item "菜单项2" #f))
(define submenu (make-apple-item "子菜单" #f))
(send submenu add-item (make-apple-item "子菜单项1" #f))
(send sidebar add-item submenu)
```

### 3. 使用过滤按钮控件

```racket
(define filter-panel (new horizontal-panel% [parent frame]))

(define filter-btn1
  (new filter-button%
       [parent filter-panel]
       [label "全部"]
       [group "filter-group"]
       [selected #t]
       [callback (lambda (btn evt)
                  (when (send btn is-selected?)
                    (printf "选择了: ~a~n" (send btn get-label))))]))

(define filter-btn2
  (new filter-button%
       [parent filter-panel]
       [label "未完成"]
       [group "filter-group"]
       [callback (lambda (btn evt)
                  (when (send btn is-selected?)
                    (printf "选择了: ~a~n" (send btn get-label))))]))
```

### 4. 使用文本框控件

```racket
(define text-field
  (new text-field%
       [parent frame]
       [label ""]
       [init-value ""]
       [placeholder "请输入内容..."]))
```

### 5. 使用提示框控件

```racket
;; 创建提示框
(define toast
  (new modern-toast%
       [parent frame]))

;; 显示提示
(send toast show-toast "操作成功" 2000)

;; 或者使用便捷函数
(show-toast frame "操作成功" 2000)
```

### 6. 使用待办事项列表控件

```racket
(define todo-list
  (new todo-list%
       [parent frame]
       [on-change (lambda (items)
                   (printf "任务列表更新: ~a 项任务~n" (length items)))]))

;; 添加任务
(send todo-list add-item "任务1")
(send todo-list add-item "任务2" #f "2024-12-31" "备注")

;; 清除已完成任务
(send todo-list clear-completed)
```

## 完整示例

```racket
#lang racket/gui
(require guix/guix)

;; 创建主窗口
(define frame (new frame%
                   [label "Guix 综合示例"]
                   [width 800]
                   [height 600]))

(define main-panel (new horizontal-panel% [parent frame]))

;; 左侧：侧边栏
(define sidebar-panel (new vertical-panel%
                           [parent main-panel]
                           [stretchable-width #f]
                           [min-width 200]))

(define sidebar
  (new modern-sidebar%
       [parent sidebar-panel]
       [on-select (lambda (item)
                  (printf "选择项: ~a~n" (send item get-label)))]))

(send sidebar add-item (make-apple-item "日历" #f))
(send sidebar add-item (make-apple-item "待办事项" #f))
(send sidebar add-item (make-apple-item "设置" #f))

;; 右侧：主内容区
(define content-panel (new vertical-panel% [parent main-panel]))

;; 顶部：过滤按钮
(define filter-panel (new horizontal-panel%
                         [parent content-panel]
                         [stretchable-height #f]
                         [border 10]))

(new filter-button%
     [parent filter-panel]
     [label "全部"]
     [group "example-filter"]
     [selected #t])

(new filter-button%
     [parent filter-panel]
     [label "未完成"]
     [group "example-filter"])

(new filter-button%
     [parent filter-panel]
     [label "已完成"]
     [group "example-filter"])

;; 中部：日历控件
(define calendar
  (new calendar%
       [parent content-panel]
       [callback (lambda (date)
                  (printf "选择日期: ~a~n" date))]))

;; 底部：输入框和添加按钮
(define input-panel (new horizontal-panel%
                         [parent content-panel]
                         [stretchable-height #f]
                         [border 10]))

(define input-field
  (new text-field%
       [parent input-panel]
       [placeholder "输入内容..."]
       [stretchable-width #t]))

(new button%
     [parent input-panel]
     [label "添加"]
     [stretchable-width #f]
     [callback (lambda (btn evt)
                (define text (send input-field get-value))
                (unless (string=? (string-trim text) "")
                  (show-toast frame (format "添加了: ~a" text) 1500)
                  (send input-field set-value "")))])

;; 显示窗口
(send frame show #t)
```

## 控件API参考

### calendar%
- `(new calendar% [parent parent] [callback callback])`
  - `parent`: 父容器
  - `callback`: 日期选择回调函数

### modern-sidebar%
- `(new modern-sidebar% [parent parent] [on-select on-select])`
  - `parent`: 父容器
  - `on-select`: 选择项回调函数
- `(send sidebar add-item item)`: 添加菜单项

### filter-button%
- `(new filter-button% [parent parent] [label label] [group group] [selected selected] [callback callback])`
  - `parent`: 父容器
  - `label`: 按钮文本
  - `group`: 按钮组名称（同组按钮互斥）
  - `selected`: 是否默认选中
  - `callback`: 点击回调函数
- `(send btn is-selected?)`: 获取选中状态
- `(send btn set-selected selected)`: 设置选中状态

### text-field%
- `(new text-field% [parent parent] [label label] [init-value init-value] [placeholder placeholder])`
  - `parent`: 父容器
  - `label`: 标签文本
  - `init-value`: 初始值
  - `placeholder`: 占位符文本

### modern-toast%
- `(new modern-toast% [parent parent])`
  - `parent`: 父容器
- `(send toast show-toast message duration)`: 显示提示框
  - `message`: 提示消息
  - `duration`: 显示时长（毫秒）

### todo-list%
- `(new todo-list% [parent parent] [on-change on-change])`
  - `parent`: 父容器
  - `on-change`: 列表变化回调函数
- `(send todo-list add-item text [completed completed] [due-date due-date] [note note])`: 添加任务
- `(send todo-list clear-completed)`: 清除已完成任务

## 许可证

本库采用 MIT 许可证，您可以自由使用、修改和分发。

## 贡献

欢迎提交问题报告和改进建议！