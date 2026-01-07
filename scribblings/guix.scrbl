#lang scribble/manual
@(require (for-label guix)
         scribble/eval)

@title{Guix}
@author{Your Name}
@date{2026-01-07}

@defmodule[guix]

@table-of-contents

@section{Introduction}

Guix 是一套基于 @tt{racket/gui} 的现代桌面控件库，提供跨平台一致行为的 GUI 控件，支持主题化、组合控件、自定义样式，适用于 macOS、Windows 和 Linux。

@section{Installation}

使用 @tt{raco} 包管理器安装：

@verbatim{
raco pkg install guix
}

@section{Quick Start}

@codeblock{
#lang racket/gui

(require guix)

;; 创建主窗口
(define frame (new frame% [label "Guix Demo"]
                            [width 400]
                            [height 300]))

;; 创建垂直面板
(define panel (new vertical-panel% [parent frame]
                                    [alignment '(center center)]
                                    [spacing 20]
                                    [border 30]))

;; 创建现代化按钮
(new button% [parent panel]
             [label "Primary Button"]
             [type 'primary]
             [callback (lambda (button event)
                         (displayln "Primary button clicked!"))])

(new button% [parent panel]
             [label "Secondary Button"]
             [type 'secondary]
             [callback (lambda (button event)
                         (displayln "Secondary button clicked!"))])

;; 显示窗口
(send frame show #t)
}

@section{Themes}

Guix 支持两种主题：浅色主题和深色主题。

@defproc[(set-theme! [theme (or/c 'light 'dark)]) void?]
切换全局主题。

@defproc[(current-theme) theme?]
返回当前全局主题对象。

@codeblock{
;; 设置为深色主题
(set-theme! 'dark)

;; 获取当前主题
(current-theme) ; 返回 dark-theme 对象

;; 设置为浅色主题
(set-theme! 'light)
}

@section{Widgets}

Guix 提供了多种现代化的 UI 控件，按类别分为：

@subsection{Atomic Widgets}

- @tt{button%} / @tt{modern-button%} - 现代化按钮
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
- @tt{input%} - 基础输入组件
- @tt{progress-bar%} - 进度条
- @tt{search-field%} - 搜索框
- @tt{segmented-control%} - 分段控制器
- @tt{stepper-input%} - 带步进器的输入框

@subsection{Container Widgets}

- @tt{custom-list-box%} - 自定义列表框
- @tt{scroll-view%} - 滚动视图
- @tt{side-panel%} - 侧边面板
- @tt{sidebar-list%} - 侧边栏列表
- @tt{split-view%} - 分割视图
- @tt{stack-view%} - 堆栈视图
- @tt{tab-view%} - 标签页视图

@subsection{App Widgets}

- @tt{alert%} - 弹窗控件
- @tt{calendar%} - 日历控件
- @tt{date-time-picker%} - 日期时间选择器
- @tt{menu%} - 菜单控件
- @tt{table-view%} - 表格视图
- @tt{time-picker%} - 时间选择器
- @tt{toast-info%} / @tt{modern-toast%} - 提示信息
- @tt{todo%} - 待办事项

@section{Examples}

Guix 提供了多个示例文件，展示不同控件的用法：

- @filepath{examples/test-button.rkt} - 按钮控件测试
- @filepath{examples/simple-test-button.rkt} - 简化版按钮测试

你可以通过以下命令运行示例：

@codeblock{
racket examples/simple-test-button.rkt
}

@section{API Reference}

@subsection{Style Configuration}

Guix 提供了样式配置功能，可以自定义控件的外观和行为。

@defproc[(border-radius-small) number?] 返回小边框半径值

@defproc[(border-radius-medium) number?] 返回中边框半径值

@defproc[(border-radius-large) number?] 返回大边框半径值

@defproc[(button-height) number?] 返回按钮高度

@subsection{Widget Registration}

@defproc[(register-widget [widget area<%>]) void?] 注册控件以响应主题变化

@defproc[(unregister-widget [widget area<%>]) void?] 取消注册控件

@defproc[(refresh-all-widgets) void?] 全局刷新所有控件

@subsection{Atomic Widgets - Button}

@defclass[modern-button% canvas% ()]
现代化按钮控件，支持主题切换和多种样式。

@defconstructor[([parent (is-a?/c area<%>)]
                 [label string? "Button"]
                 [type (or/c 'primary 'secondary 'text) 'primary]
                 [theme-aware? boolean? #t]
                 [radius (or/c 'small 'medium 'large) 'medium]
                 [enabled? boolean? #t]
                 [callback (or/c #f (-> (is-a?/c modern-button%) (is-a?/c event%) any)) #f])]

@defmethod[(get-button-label) string?] 获取按钮标签

@defmethod[(set-button-label! [new-label string?]) void?] 设置按钮标签

@defmethod[(get-type) (or/c 'primary 'secondary 'text)] 获取按钮类型

@defmethod[(set-type! [new-type (or/c 'primary 'secondary 'text)]) void?] 设置按钮类型

@defmethod[(get-enabled-state) boolean?] 获取按钮启用状态

@defmethod[(set-enabled! [on? boolean? #t]) void?] 设置按钮启用状态

@defmethod[(get-radius) (or/c 'small 'medium 'large)] 获取按钮边框半径

@defmethod[(set-radius! [new-radius (or/c 'small 'medium 'large)]) void?] 设置按钮边框半径
