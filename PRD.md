## 1. 产品概述

**Guix** 是一套基于 `racket/gui` 的现代桌面控件库，提供跨平台一致行为的 GUI 控件，支持主题化、组合控件、自定义样式，适用于 **macOS、Windows 和 Linux**。

目标用户：

- Racket 桌面应用开发者
- 需要比 `racket/gui` 更现代、可控控件库
- 希望跨平台行为一致

设计原则：

1. **跨平台行为一致性优先于像素级还原**
2. **原子控件优先，组合控件可复用**
3. **状态显式化、可主题化**
4. **可用优先于完美**
5. **避免依赖操作系统原生控件或服务**

非目标：

- 不追求 macOS 原生还原
- 不实现系统服务（分享、iCloud、通知）
- 不绑定系统原生控件

## 2. 仓库架构

```
guix/                         ; 库根目录
│
├─ guix.rkt                    ; 库主入口，聚合导出所有控件
│                               ; 支持主题切换、全局刷新
│
├─ style/                       ; 全局主题和样式配置
│                               ; color-scheme, dark-mode, metrics (圆角、padding)
│
├─ control/                     ; 原子控件与组合控件
│  ├─ atomic/                   ; 原子控件（最小单元）
│  │   ├─ button%               ; 支持 hover/pressed/disabled
│  │   ├─ label%                ; 文本显示控件
│  │   ├─ text-field%           ; 单行输入框
│  │   ├─ text-area%            ; 多行输入框
│  │   ├─ checkbox%             ; 复选框
│  │   ├─ radio-button%         ; 单选按钮
│  │   ├─ switch%               ; 开关控件
│  │   ├─ slider%               ; 滑块
│  │   ├─ stepper%              ; 步进控件
│  │   └─ icon%                 ; 图标
│  │
│  ├─ composite/                ; 由原子控件组合的控件
│  │   ├─ input-field%          ; Label + TextField/TextArea
│  │   ├─ progress-bar%         ; Slider + 填充 + 动画
│  │   ├─ filter-button%        ; Button + Icon
│  │   ├─ search-field%         ; TextField + ClearButton + Icon
│  │   ├─ stepper-input%        ; TextField + Stepper
│  │   └─ segmented-control%    ; 按钮组切换选项
│
├─ container/                  ; 布局容器
│  ├─ side-panel%               ; 可折叠/拖拽侧边栏
│  ├─ sidebar-list%             ; 列表容器
│  ├─ split-view%               ; 拖拽分割布局
│  ├─ tab-view%                 ; 标签页容器
│  ├─ scroll-view%              ; 可滚动容器
│  └─ stack-view%               ; 堆叠布局
│
├─ app/                        ; 高级组合控件（应用层面）
│  ├─ calendar%                 ; 日历控件
│  ├─ time-picker%              ; 时间选择
│  ├─ date-time-picker%         ; 日期+时间组合
│  ├─ table-view%               ; 表格，可排序/选择
│  ├─ toast-info%               ; 弹窗提示
│  ├─ alert%                    ; 确认/警告弹窗
│  └─ menu%                     ; 下拉菜单模拟
│
├─ scribblings/                ; 文档（Scribble）
│  └─ guix.scrbl
│
├─ tests/                       ; 单元测试 & 自动化测试
│  ├─ atomic/
│  ├─ composite/
│  └─ container/
│
└─ examples/                    ; 示例脚本
```

## 3. 控件层级说明

1. **原子控件**：最小绘制单元，独立交互
2. **组合控件**：原子控件组合形成可复用控件
3. **容器控件**：布局和子控件管理
4. **高级应用控件**：组合控件 + 容器控件组合形成应用场景控件

## 4. 跨平台行为约束

- **点击/双击/长按、键盘操作、焦点切换**：行为在 macOS/Windows/Linux 一致
- **Hover/Tooltip**：桌面端显示，触控可弱化
- **滚动**：逻辑一致，滚动条自绘
- **布局**：最小尺寸、padding、字体、圆角由主题控制
- **主题**：Light/Dark 模式由库实现，不依赖 OS
- **动画**：可自定义，但不依赖操作系统动画 API
- **系统特性**：不依赖原生控件或系统服务

## 5. 主题与样式

- 颜色：primary/secondary/background/hover/disabled
- 字体：大小/粗细
- 圆角、padding、间距
- 动画时长
- 支持用户自定义主题

## 6. 测试规范

- 单元测试目录：`tests/atomic/`、`tests/composite/`、`tests/container/`
- 测试内容：初始化状态、交互事件、样式应用、布局
- 覆盖三平台

## 7. 示例规范

- 示例目录：`examples/`
- 展示控件用法、组合控件布局、主题切换
- 不包含平台依赖

## 8. 发布规范

- 仓库名：`guix`
- Collection 名称：`guix`
- 入口模块：`guix/guix.rkt`
- 控件类名前缀：`guix-`
- 文件名：小写 + 下划线
- 安装命令：

```bash
raco pkg install guix
```

✅ 总结

- 代码纯净、跨平台、自绘控件
- PRD 中描述跨平台行为和约束
- 原子 → 组合 → 容器 → 高级应用控件
- 测试、示例、文档齐全