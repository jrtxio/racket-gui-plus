#lang scribble/manual
@title[#:tag "guix"]{Guix - Modern Racket GUI Widget Library}

@author{Guix Development Team}

@section{Introduction}

Guix is a modern GUI widget library for Racket that extends racket/gui with 
modern UI components, a flexible theme system, and consistent cross-platform 
behavior. It follows the design principles of pragmatic use of native capabilities, 
progressive enhancement, consistent behavior, and composition-first design.

@subsection{Features}

@itemlist[
  @item{Modern, consistent UI components}
  @item{Flexible theme system with light and dark presets}
  @item{Cross-platform support (macOS, Windows, Linux)}
  @item{Pure Racket implementation}
  @item{Extensible architecture}
  @item{Comprehensive documentation}
]

@subsection{Getting Started}

To use Guix in your Racket project, simply install it and require the main module:

@codeblock{
#lang racket/gui
(require guix)

;; Create a frame
(define frame (new frame% [label "Guix Example"] [width 400] [height 300]))

;; Create a button using Guix
(new button% [parent frame] [label "Click Me"])

;; Show the frame
(send frame show #t)
}

@section{Architecture}

Guix follows a layered architecture, with core systems at the bottom and 
specialized components at the top:

@itemlist[
  @item{@emph{Core Systems}: Event handling, state management, theme system, layout engine}
  @item{@emph{Atomic Widgets}: Basic UI elements like buttons, labels, text fields}
  @item{@emph{Composite Widgets}: Components built from multiple atomic widgets}
  @item{@emph{Container Widgets}: Layout components for organizing other widgets}
  @item{@emph{Dialogs}: Modal and non-modal dialog boxes}
  @item{@emph{Menus}: Menu bars, popup menus}
  @item{@emph{Extended Widgets}: Additional widgets not provided by racket/gui}
]

@section{Theme System}

Guix provides a flexible theme system that allows you to customize the appearance 
of all widgets consistently. Themes are defined using hashes that specify colors, 
metrics, and typography.

@subsection{Using Themes}

@codeblock{
;; Use the global theme
(set-global-theme! dark-theme)

;; Create a widget with a custom theme
(new button% [parent frame] [label "Custom Theme"] [theme custom-theme])
}

@subsection{Creating Custom Themes}

@codeblock{
(define my-theme
  (make-theme
   #:colors (hash 'primary "#FF5733"
                  'background "#F5F5F5"
                  'text "#333333")
   #:metrics (hash 'corner-radius 8
                   'padding 10
                   'spacing 8)
   #:typography (hash 'size 14
                      'weight 400
                      'family "Segoe UI")))
}

@section{Widget Categories}

@include-section{atomic.scrbl}
@include-section{composite.scrbl}
@include-section{container.scrbl}
@include-section{extended.scrbl}

@section{Core Systems}

@include-section{core.scrbl}

@section{Examples}

Guix includes several examples demonstrating how to use the library. You can find 
them in the @filepath{examples/} directory of the Guix distribution.

@subsection{Running Examples}

@codeblock{
racket examples/button-demo.rkt
racket examples/todo-example.rkt
}

@section{API Reference}

@subsection{Main Module}

@defmodule[guix]

The main Guix module exports all public widgets and functions.

@subsection{Theme Functions}

@defproc[(current-theme) theme?]
  Returns the current global theme.

@defproc[(set-global-theme! [theme theme?]) void?]
  Sets the current global theme and updates all registered widgets.

@defproc[(register-widget [widget (is-a?/c guix-base-control%)]) void?]
  Registers a widget to receive theme change notifications.

@defproc[(unregister-widget [widget (is-a?/c guix-base-control%)]) void?]
  Unregisters a widget from theme change notifications.

@section{License}

Guix is released under the MIT License.

@subsection{Contributing}

Contributions to Guix are welcome! Please see the project's GitHub repository for 
guidelines on how to contribute.
