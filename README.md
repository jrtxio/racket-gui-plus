<div align="center">
  <h1>✨ Guix</h1>
  <p>Modern Desktop Widget Library for <code>racket/gui</code></p>
  <p>Create beautiful, consistent, and cross-platform desktop applications with ease</p>
  
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
    <img src="https://via.placeholder.com/800x450?text=Guix+Demo+Screenshot" alt="Guix Demo Screenshot" style="width: 100%; max-width: 800px; height: auto;">
  </div>
</div>

Guix is a modern, feature-rich desktop widget library built on top of `racket/gui`. It provides a comprehensive set of cross-platform GUI widgets with consistent behavior across macOS, Windows, and Linux. Guix enhances the native `racket/gui` capabilities with modern design principles, theming support, composite widgets, and highly customizable styles.

Designed for both beginners and experienced Racket developers, Guix makes it easy to create beautiful, responsive desktop applications with minimal effort while maintaining the power and flexibility of the Racket programming language.

## ✨ Features

### 🎨 Modern Design
- Consistent, modern UI across all platforms
- Built-in light and dark theme support
- Customizable color schemes and typography
- Smooth animations and transitions

### 🔧 Comprehensive Widget Library
- **Atomic Widgets**: Buttons, checkboxes, text fields, sliders, and more
- **Composite Widgets**: Input fields, stepper inputs, segmented controls
- **Container Widgets**: Scroll views, tab views, split views, sidebar lists
- **Extended Widgets**: Calendar, date-time picker, time picker, toast notifications

### 📱 Cross-Platform
- Built on `racket/gui` for native performance
- Consistent behavior on macOS, Windows, and Linux
- No additional dependencies required

### 🔄 Flexible Architecture
- Event-driven programming model
- State management system
- Composable widget design
- Easy to extend and customize

### 🚀 Easy to Use
- Simple API with sensible defaults
- Comprehensive documentation
- Rich examples and tutorials
- Active development community

## 📦 Widget List

### 🧩 Atomic Widgets
Atomic widgets are the basic building blocks of UI, providing fundamental interaction elements.

| Widget Name | Class Name | Description |
|-------------|------------|-------------|
| Button | `modern-button%` | Modern, themed buttons with hover effects |
| Label | `label%` | Styled text labels with customizable typography |
| Text Field | `text-field%` | Single-line text input with placeholder support |
| Text Area | `text-area%` | Multi-line text input with scroll support |
| Switch | `switch%` | Modern toggle switches with smooth animations |
| Checkbox | `checkbox%` | Styled checkboxes with customizable appearance |
| Radio Button | `radio-button%` | Grouped radio buttons for exclusive selection |
| Slider | `modern-slider%` | Smooth, themed sliders for value selection |
| Stepper | `stepper%` | Increment/decrement controls for numeric values |
| Icon | `icon%` | Vector-based icons with color and size customization |

### 🛠️ Composite Widgets
Composite widgets combine multiple atomic widgets to create more complex UI elements.

| Widget Name | Class Name | Description |
|-------------|------------|-------------|
| Category Card | `category-card%` | Card-based layout for category display |
| Input Field | `input-field%` | Enhanced text input with label and validation |
| Progress Bar | `modern-progress-bar%` | Smooth progress indicators with customizable styles |
| Search Field | `search-field%` | Text input with built-in search functionality |
| Stepper Input | `stepper-input%` | Text field combined with stepper controls |
| Segmented Control | `segmented-control%` | Tab-like controls for mutually exclusive options |

### 📦 Container Widgets
Container widgets manage the layout and positioning of other widgets.

| Widget Name | Class Name | Description |
|-------------|------------|-------------|
| Custom List Box | `custom-list-box%` | Customizable list views with item templates |
| Scroll View | `scroll-view%` | Scrollable containers for overflow content |
| Side Panel | `side-panel%` | Collapsible side panels for additional content |
| Sidebar List | `sidebar-list%` | Hierarchical sidebar navigation with icons |
| Split View | `split-view%` | Resizable split panes for multi-panel layouts |
| Tab View | `tab-view%` | Tabbed interfaces for organizing content |
| Stack View | `stack-view%` | Layered container for managing visible content |

### 🌟 Extended Widgets
Extended widgets provide specialized functionality for common use cases.

| Widget Name | Class Name | Description |
|-------------|------------|-------------|
| Calendar | `calendar%` | Modern month-view calendar with date selection |
| Time Picker | `time-picker%` | Intuitive time selection interface |
| Date-Time Picker | `date-time-picker%` | Combined date and time selection widget |
| Toast Notification | `guix-toast%` | Lightweight, temporary notification messages |

## 🚀 Getting Started

### Prerequisites

- [Racket](https://racket-lang.org/) 8.0 or later
- Basic knowledge of Racket programming
- Familiarity with `racket/gui` is helpful but not required

### Installation

Install Guix widget library using Racket's package manager:

```bash
raco pkg install guix
```

### Hello World Example

A simple "Hello World" application using Guix widgets:

```racket
#lang racket/gui
(require guix/guix)

;; Create the main window
(define frame (new frame%
                   [label "Guix Hello World"]
                   [width 400]
                   [height 200]))

;; Create a vertical panel to hold our widgets
(define panel (new vertical-panel%
                   [parent frame]
                   [alignment '(center center)]
                   [spacing 20]))

;; Add a styled label
(new label%
     [parent panel]
     [label "Hello, Guix!"]
     [font (make-font #:size 24 #:face "Arial" #:weight 'bold)])

;; Add a modern button
(new modern-button%
     [parent panel]
     [label "Click Me"]
     [callback (lambda (btn evt)
                 (show-toast frame "Button clicked!" 2000))])

;; Show the window
(send frame show #t)
```

### Basic Usage Pattern

1. **Import Guix**
   ```racket
   (require guix/guix)
   ```

2. **Create a window**
   ```racket
   (define frame (new frame% [label "App Title"] [width 800] [height 600]))
   ```

3. **Create panels for layout**
   ```racket
   (define main-panel (new vertical-panel% [parent frame]))
   ```

4. **Add widgets**
   ```racket
   (new text-field% [parent main-panel] [placeholder "Enter text..."])
   (new modern-button% [parent main-panel] [label "Submit"])
   ```

5. **Show the window**
   ```racket
   (send frame show #t)
   ```

### Quick Tips

- Use `show-toast` for simple notifications
- Experiment with different themes using `set-current-theme!`
- Use panels to organize your widgets
- Check the examples directory for more comprehensive examples
- Use DrRacket's REPL for interactive testing

## 📖 Usage Examples

### Calendar Widget

Create a modern month-view calendar with date selection:

```racket
(define calendar
  (new calendar%
       [parent frame]
       [callback (lambda (date)
                  (printf "Selected date: ~a~n" date))]))
```

### Sidebar List Widget

Create a hierarchical sidebar navigation with icons:

```racket
(define sidebar
  (new sidebar-list%
       [parent frame]
       [on-select (lambda (item)
                  (printf "Selected item: ~a~n" (send item get-label)))]
       [items (list (list "Calendar" #f)
                    (list "Tasks" #f)
                    (list "Settings" #f))]))
```

### Segmented Control Widget

Create a tab-like control for mutually exclusive options:

```racket
(define control
  (new segmented-control%
       [parent frame]
       [labels (list "Option 1" "Option 2" "Option 3")]
       [callback (lambda (idx)
                  (printf "Selected option: ~a~n" idx))]))
```

### Toast Notification

Show lightweight, temporary notification messages:

```racket
;; Using the convenience function
(show-toast frame "Operation successful!" 2000)

;; Or create a toast instance
(define toast (new guix-toast% [parent frame]))
(send toast show-toast "Operation successful!" 2000)
```

### Date and Time Picker

Create a combined date and time selection widget:

```racket
(define dt-picker
  (new date-time-picker%
       [parent frame]
       [callback (lambda (date time)
                  (printf "Selected: ~a ~a~n" date time))]))
```

## 🎯 Complete Example

A comprehensive example demonstrating multiple Guix widgets working together:

```racket
#lang racket/gui
(require guix/guix)

;; Create main window
(define frame (new frame%
                   [label "Guix Comprehensive Example"]
                   [width 800]
                   [height 600]))

(define main-panel (new horizontal-panel% [parent frame]))

;; Left: Sidebar List
(define sidebar-panel (new vertical-panel%
                           [parent main-panel]
                           [stretchable-width #f]
                           [min-width 200]))

(define sidebar
  (new sidebar-list%
       [parent sidebar-panel]
       [on-select (lambda (item)
                  (printf "Selected item: ~a~n" (send item get-label)))]
       [items (list (list "Calendar" #f)
                    (list "Tasks" #f)
                    (list "Settings" #f))]))

;; Right: Main content area
(define content-panel (new vertical-panel% [parent main-panel]))

;; Top: Segmented Control
(define seg-panel (new horizontal-panel%
                         [parent content-panel]
                         [stretchable-height #f]
                         [border 10]
                         [alignment '(center center)]))

(new segmented-control%
     [parent seg-panel]
     [labels (list "All" "Active" "Completed")]
     [selected-index 0])

;; Middle: Calendar widget
(define calendar
  (new calendar%
       [parent content-panel]
       [callback (lambda (date)
                  (show-toast frame (format "Selected: ~a" date) 1500))]))

;; Bottom: Input field with button
(define input-panel (new horizontal-panel%
                         [parent content-panel]
                         [stretchable-height #f]
                         [border 10]))

(define input-field
  (new text-field%
       [parent input-panel]
       [placeholder "Enter task..."]
       [stretchable-width #t]))

(new modern-button%
     [parent input-panel]
     [label "Add Task"]
     [stretchable-width #f]
     [callback (lambda (btn evt)
                (define text (send input-field get-value))
                (unless (string=? (string-trim text) "")
                  (show-toast frame (format "Added: ~a" text) 1500)
                  (send input-field set-value "")))])

;; Show window
(send frame show #t)
```

## 📚 API Reference

### 🧩 Atomic Widgets

#### Button (`modern-button%`)
```racket
(new modern-button% [parent parent] [label label] [callback callback] [style style])
```
- **Arguments**:
  - `parent`: Parent container
  - `label`: Button text
  - `callback`: Click callback function
  - `style`: Button style (optional)
- **Methods**:
  - `(send btn get-label)`: Get button text
  - `(send btn set-label label)`: Set button text
  - `(send btn enable [enable? #t])`: Enable/disable button

#### Text Field (`text-field%`)
```racket
(new text-field% [parent parent] [label label] [init-value init-value] [placeholder placeholder])
```
- **Arguments**:
  - `parent`: Parent container
  - `label`: Label text (optional)
  - `init-value`: Initial value (optional)
  - `placeholder`: Placeholder text (optional)
- **Methods**:
  - `(send tf get-value)`: Get current text value
  - `(send tf set-value value)`: Set text value
  - `(send tf get-placeholder)`: Get placeholder text
  - `(send tf set-placeholder placeholder)`: Set placeholder text

#### Label (`label%`)
```racket
(new label% [parent parent] [label label] [font font] [color color])
```
- **Arguments**:
  - `parent`: Parent container
  - `label`: Label text
  - `font`: Font object (optional)
  - `color`: Text color (optional)
- **Methods**:
  - `(send lbl get-label)`: Get label text
  - `(send lbl set-label label)`: Set label text

### 🛠️ Composite Widgets

#### Segmented Control (`segmented-control%`)
```racket
(new segmented-control% [parent parent] [labels labels] [selected-index selected-index] [callback callback])
```
- **Arguments**:
  - `parent`: Parent container
  - `labels`: List of segment labels
  - `selected-index`: Initial selected index (optional, default: 0)
  - `callback`: Selection change callback function
- **Methods**:
  - `(send sc get-selected-index)`: Get current selected index
  - `(send sc set-selected-index idx)`: Set selected index

#### Progress Bar (`modern-progress-bar%`)
```racket
(new modern-progress-bar% [parent parent] [value value] [max-value max-value])
```
- **Arguments**:
  - `parent`: Parent container
  - `value`: Current progress value (optional, default: 0)
  - `max-value`: Maximum progress value (optional, default: 100)
- **Methods**:
  - `(send pb get-value)`: Get current progress value
  - `(send pb set-value value)`: Set progress value
  - `(send pb get-max-value)`: Get maximum progress value
  - `(send pb set-max-value max-value)`: Set maximum progress value

### 📦 Container Widgets

#### Sidebar List (`sidebar-list%`)
```racket
(new sidebar-list% [parent parent] [items items] [on-select on-select])
```
- **Arguments**:
  - `parent`: Parent container
  - `items`: List of sidebar items (each item is a list: `(label icon)`)
  - `on-select`: Item selection callback function
- **Methods**:
  - `(send sl get-selected-item)`: Get currently selected item
  - `(send sl set-selected-item item)`: Set selected item

#### Tab View (`tab-view%`)
```racket
(new tab-view% [parent parent] [tabs tabs] [callback callback])
```
- **Arguments**:
  - `parent`: Parent container
  - `tabs`: List of tab configurations
  - `callback`: Tab change callback function
- **Methods**:
  - `(send tv get-selected-tab)`: Get currently selected tab
  - `(send tv set-selected-tab tab)`: Set selected tab

### 🌟 Extended Widgets

#### Calendar (`calendar%`)
```racket
(new calendar% [parent parent] [callback callback])
```
- **Arguments**:
  - `parent`: Parent container
  - `callback`: Date selection callback function
- **Methods**:
  - `(send cal get-selected-date)`: Get currently selected date
  - `(send cal set-selected-date date)`: Set selected date

#### Toast Notification (`guix-toast%`)
```racket
(new guix-toast% [parent parent])
```
- **Arguments**:
  - `parent`: Parent container
- **Methods**:
  - `(send toast show-toast message duration)`: Show toast notification
    - `message`: Notification message
    - `duration`: Display duration in milliseconds (default: 2000)

#### Date-Time Picker (`date-time-picker%`)
```racket
(new date-time-picker% [parent parent] [callback callback])
```
- **Arguments**:
  - `parent`: Parent container
  - `callback`: Date-time selection callback function
- **Methods**:
  - `(send dtp get-date-time)`: Get selected date and time
  - `(send dtp set-date-time date time)`: Set date and time

### 🎨 Theme API

#### Set Current Theme
```racket
(set-current-theme! theme)
```
- **Arguments**:
  - `theme`: Theme name (`'light` or `'dark`)

#### Refresh All Widgets
```racket
(refresh-all-widgets)
```
- **Description**: Refresh all Guix widgets to apply theme changes

### 📞 Utility Functions

#### Show Toast Notification
```racket
(show-toast parent message [duration 2000])
```
- **Arguments**:
  - `parent`: Parent window
  - `message`: Notification message
  - `duration`: Display duration in milliseconds (default: 2000)

## 👨‍💻 Development Guide

### Setting Up Development Environment

1. **Clone the repository**:
   ```bash
   git clone https://github.com/jrtxio/racket-gui-plus.git
   cd racket-gui-plus
   ```

2. **Install dependencies**:
   ```bash
   raco pkg install --auto
   ```

3. **Run the tests** to ensure everything is working:
   ```bash
   raco test -t tests/
   ```

### Running Examples

Explore the examples to see Guix widgets in action:

```bash
racket examples/comprehensive-demo.rkt
racket examples/button-demo.rkt
racket examples/calendar-demo.rkt
```

### Running Tests

#### Unit Tests
```bash
raco test -t tests/unit/
```

#### All Tests
```bash
raco test -t tests/
```

### Project Structure

```
├── guix/              # Main library code
│   ├── atomic/        # Basic widgets (buttons, labels, etc.)
│   ├── composite/     # Combined widgets
│   ├── container/     # Layout containers
│   ├── core/          # Core functionality
│   ├── extended/      # Specialized widgets
│   └── style/         # Theming and styling
├── examples/          # Example applications
├── scribblings/       # Documentation
└── tests/             # Test suite
```

### Contributing

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/AmazingFeature`)
3. **Make your changes**
4. **Run the tests** to ensure they pass
5. **Commit your changes** (`git commit -m 'Add some AmazingFeature'`)
6. **Push to the branch** (`git push origin feature/AmazingFeature`)
7. **Open a Pull Request**

### Code Style Guidelines

- Follow Racket's [style guide](https://docs.racket-lang.org/style/index.html)
- Use consistent indentation (2 spaces)
- Write clear, descriptive comments
- Add unit tests for new functionality
- Update documentation when adding new features

### Building Documentation

```bash
raco scribble --html --dest doc scribblings/guix.scrbl
```

The documentation will be generated in the `doc` directory.

## 📄 License

This library is licensed under the MIT License. You can freely use, modify, and distribute it.

## 🤝 Contributions

Welcome to submit issue reports, feature requests, and pull requests!

### Report Issues

If you encounter any bugs or have suggestions for improvements, please [create an issue](https://github.com/jrtxio/racket-gui-plus/issues) on GitHub.

### Submit Pull Requests

We welcome contributions! Please follow the [development guide](#-development-guide) to set up your environment and submit your changes.
