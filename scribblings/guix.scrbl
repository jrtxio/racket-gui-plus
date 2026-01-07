#lang scribble/manual
@(require (for-label racket-gui-plus)
         scribble/eval)

@title{Racket GUI Plus}
@author{Your Name}
@date{2026-01-07}

@defmodule[racket-gui-plus]

@table-of-contents

@section{Introduction}

Racket GUI Plus 是一个增强的 Racket GUI 控件库，提供现代化的苹果风格 UI 控件，支持主题切换和全局刷新。

@section{Installation}

使用 @tt{raco} 包管理器安装：

@verbatim|{
raco pkg install racket-gui-plus
}|@

@section{Quick Start}

@codeblock|{
#lang racket/gui

(require racket-gui-plus)

;; 创建主窗口
(define frame (new frame% [label "GUI Plus Demo"]
                            [width 400]
                            [height 300]))

;; 创建按钮
(define button (new button% [parent frame]
                            [label "点击我"]
                            [callback (lambda (button event)
                                        (show-toast frame "按钮被点击了！"))]))

;; 显示窗口
(send frame show #t)
}|@

@section{Themes}

GUI Plus 支持两种主题：浅色主题和深色主题。

@defproc[(set-theme! [theme (or/c 'light 'dark)]) void?]
Sets the global theme.

@defproc[(get-current-theme) (or/c 'light 'dark)]
Returns the current global theme.

@codeblock|{
;; 设置为深色主题
(set-theme! 'dark)

;; 获取当前主题
(get-current-theme) ; 返回 'dark
}|@

@section{Widgets}

GUI Plus 提供了多种现代化的 UI 控件，按类别分为：

@subsection{Atomic Widgets}

- @tt{button%} - 现代化按钮
- @tt{label%} - 文本标签
- @tt{text-field%} - 文本输入框
- @tt{text-area%} - 多行文本输入框
- @tt{switch%} - 开关控件
- @tt{checkbox%} - 复选框
- @tt{radio-button%} - 单选按钮
- @tt{slider%} - 滑块控件
- @tt{stepper%} - 步进器
- @tt{icon%} - 图标控件

@subsection{Composite Widgets}

- @tt{filter-button%} - 筛选按钮
- @tt{input-field%} - 增强输入框
- @tt{progress-bar%} - 进度条
- @tt{search-field%} - 搜索框
- @tt{stepper-input%} - 带步进器的输入框
- @tt{segmented-control%} - 分段控制器

@subsection{Container Widgets}

- @tt{custom-list-box%} - 自定义列表框
- @tt{side-panel%} - 侧边面板
- @tt{sidebar-list%} - 侧边栏列表
- @tt{split-view%} - 分割视图
- @tt{tab-view%} - 标签页视图
- @tt{scroll-view%} - 滚动视图
- @tt{stack-view%} - 堆栈视图

@subsection{App Widgets}

- @tt{calendar%} - 日历控件
- @tt{time-picker%} - 时间选择器
- @tt{toast-info%} - 提示信息
- @tt{todo%} - 待办事项
- @tt{date-time-picker%} - 日期时间选择器
- @tt{table-view%} - 表格视图
- @tt{alert%} - 弹窗控件
- @tt{menu%} - 菜单控件

@section{Examples}

更多示例代码请查看 @filepath{examples/} 目录。

@section{API Reference}

完整的 API 参考请参考各个控件模块的文档。
