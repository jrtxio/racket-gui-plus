#lang scribble/manual

@title[#:tag "core-systems"]{Core Systems}

The core systems provide the foundation for the Guix library, including 
event handling, state management, theming, and layout functionality.

@section{Base Control}

@defclass[guix-base-control% canvas% ()]{
  The base class for all Guix widgets, providing common functionality like 
  event handling, state management, and theme support.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [enabled? boolean? #t]
                   [visible? boolean? #t]
                   [theme (or/c #f theme?) #f])]{
    Creates a new base control with the given parent and theme.
  }
  
  @defmethod[(set-enabled [enabled boolean?]) void?]{
    Enables or disables the control.
  }
  
  @defmethod[(get-enabled) boolean?]{
    Returns whether the control is enabled.
  }
  
  @defmethod[(set-visible [visible boolean?]) void?]{
    Shows or hides the control.
  }
  
  @defmethod[(get-visible) boolean?]{
    Returns whether the control is visible.
  }
  
  @defmethod[(set-theme [theme theme?]) void?]{
    Sets the control's theme.
  }
  
  @defmethod[(get-theme) theme?]{
    Returns the control's current theme.
  }
  
  @defmethod[(invalidate) void?]{
    Marks the control for redraw.
  }
}

@section{Event System}

The event system handles user interactions and provides a consistent 
event propagation mechanism across all widgets.

@subsection{Event Types}

@itemlist[
  @item{@bold{on-click}: Mouse click event}
  @item{@bold{on-double-click}: Mouse double-click event}
  @item{@bold{on-hover}: Mouse hover event}
  @item{@bold{on-change}: Value change event}
  @item{@bold{on-focus}: Focus gained event}
  @item{@bold{on-blur}: Focus lost event}
]

@subsection{Event Propagation}

Events propagate from child widgets to their parents, allowing for 
centralized event handling. Widgets can stop event propagation by 
calling @method[event% stop].

@defproc[(fire-event [widget (is-a?/c guix-base-control%)]
                     [event-type symbol?]
                     [data any/c #f])
         void?]{
  Fires an event of the given type with the specified data.
}

@defproc[(add-event-listener [widget (is-a?/c guix-base-control%)]
                             [event-type symbol?]
                             [callback (-> any/c any)])
         void?]{
  Adds an event listener for the specified event type.
}

@defproc[(remove-event-listener [widget (is-a?/c guix-base-control%)]
                                [event-type symbol?]
                                [callback (-> any/c any)])
         void?]{
  Removes an event listener for the specified event type.
}

@section{State Management}

The state management system handles both local widget state and 
controlled state from parent components.

@subsection{State Types}

@itemlist[
  @item{@emph{Local State}: Internal state managed by the widget itself (e.g., hover, pressed, focused)}
  @item{@emph{Controlled State}: State managed by parent components (e.g., value, selected)}
]

@subsection{State Methods}

@defclass[stateful-control% guix-base-control% ()]{
  A mixin for controls that have state.
  
  @defmethod[(set-state [state-hash hash?]) void?]{
    Sets multiple state properties at once.
  }
  
  @defmethod[(get-state) hash?]{
    Returns the current state as a hash.
  }
  
  @defmethod[(set-state-property [key symbol?] [value any/c]) void?]{
    Sets a single state property.
  }
  
  @defmethod[(get-state-property [key symbol?] [default any/c #f]) any/c]{
    Returns the value of a state property, or the default if it doesn't exist.
  }
}

@section{Layout Engine}

The layout engine provides flexible layout options for organizing widgets.

@subsection{Layout Modes}

@itemlist[
  @item{@bold{stack}: Vertical or horizontal stacking of widgets}
  @item{@bold{flow}: Flow layout that automatically wraps widgets}
  @item{@bold{grid}: Grid layout for precise positioning}
]

@subsection{Layout Constraints}

Constraints can be applied to widgets to control their sizing and positioning:

@codeblock{
(define constraint
  (hash 'min-width 100
        'max-width 500
        'preferred-width 300
        'stretch 1.0))
}

@subsection{Layout Functions}

@defproc[(stack-layout [widgets (listof (is-a?/c guix-base-control%))]
                       [orientation (one-of/c 'horizontal 'vertical) 'vertical]
                       [spacing number? 8])
         void?]{
  Arranges widgets in a vertical or horizontal stack.
}

@defproc[(flow-layout [widgets (listof (is-a?/c guix-base-control%))]
                      [spacing number? 8])
         void?]{
  Arranges widgets in a flow layout that wraps as needed.
}

@defproc[(grid-layout [widgets (listof (is-a?/c guix-base-control%))]
                      [rows number?]
                      [columns number?]
                      [spacing number? 8])
         void?]{
  Arranges widgets in a grid layout with the specified number of rows and columns.
}

@section{Theme System}

The theme system allows for consistent styling across all widgets.

@subsection{Theme Definition}

Themes are defined using hashes that specify colors, metrics, and typography:

@codeblock{
(define-theme my-theme
  #:colors (hash 'primary "#007AFF"
                 'background "#FFFFFF"
                 'text "#000000")
  #:metrics (hash 'corner-radius 6
                  'padding 8
                  'spacing 8)
  #:typography (hash 'size 13
                     'weight 400
                     'family "SF Pro Text"))
}

@subsection{Theme Functions}

@defproc[(make-theme [#:colors colors-hash hash?] [#:metrics metrics-hash hash?] [#:typography typography-hash hash?]) theme?]{
  Creates a new theme with the given color, metric, and typography hashes.
}

@defproc[(theme-ref [theme theme?] [key symbol?] [default any/c #f]) any/c]{
  Retrieves a value from the theme using the specified key path.
}

@defproc[(set-global-theme! [theme theme?]) void?]{
  Sets the global theme and updates all registered widgets.
}

@defproc[(current-theme) theme?]{
  Returns the current global theme.
}

@defproc[(register-widget [widget (is-a?/c guix-base-control%)]) void?]{
  Registers a widget to receive theme change notifications.
}

@defproc[(unregister-widget [widget (is-a?/c guix-base-control%)]) void?]{
  Unregisters a widget from theme change notifications.
}
