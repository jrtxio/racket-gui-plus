#lang scribble/manual

@title[#:tag "container-widgets"]{Container Widgets}

Container widgets are used to organize and layout other widgets, providing structure 
to the user interface.

@section{Scroll View}

@defclass[scroll-view% panel% ()]{
  A scrollable container widget that allows viewing content larger than its visible area.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [style (listof symbol?) '()])]{
    Creates a new scroll view with the given parent and style.
  }
  
  @defmethod[(set-horizontal-scrollable [scrollable boolean?]) void?]{
    Enables or disables horizontal scrolling.
  }
  
  @defmethod[(set-vertical-scrollable [scrollable boolean?]) void?]{
    Enables or disables vertical scrolling.
  }
}

@section{Side Panel}

@defclass[side-panel% panel% ()]{
  A side panel widget, typically used for navigation or additional controls.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [width (or/c number? 'auto) 'auto]
                   [style (listof symbol?) '()])]{
    Creates a new side panel with the given parent and width.
  }
  
  @defmethod[(set-width [width number?]) void?]{
    Sets the width of the side panel.
  }
}

@section{Sidebar List}

@defclass[sidebar-list% panel% ()]{
  A list widget optimized for use in sidebars, typically displaying navigation items.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [items (listof sidebar-item-data)]
                   [on-select (-> sidebar-item-data any) void])]{
    Creates a new sidebar list with the given items and parent.
  }
  
  @defmethod[(set-items [items (listof sidebar-item-data)]) void?]{
    Sets the items displayed in the sidebar list.
  }
  
  @defmethod[(get-selected-item) sidebar-item-data]{
    Returns the currently selected sidebar item.
  }
}

@section{Split View}

@defclass[split-view% panel% ()]{
  A split view container that divides its area into two resizable panels.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [orientation (one-of/c 'horizontal 'vertical) 'horizontal]
                   [initial-split 0.5])]{
    Creates a new split view with the given orientation and initial split ratio.
  }
  
  @defmethod[(set-split [ratio number?]) void?]{
    Sets the split ratio between the two panels.
  }
  
  @defmethod[(get-split) number?]{
    Returns the current split ratio.
  }
}

@section{Tab View}

@defclass[tab-view% panel% ()]{
  A tabbed container that allows switching between multiple pages.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [tabs (listof (cons/c string? (is-a?/c panel%)))]
                   [on-tab-change (-> number? any) void])]{
    Creates a new tab view with the given tabs and parent.
  }
  
  @defmethod[(add-tab [label string?] [panel (is-a?/c panel%)]) void?]{
    Adds a new tab to the tab view.
  }
  
  @defmethod[(remove-tab [index number?]) void?]{
    Removes the tab at the given index.
  }
  
  @defmethod[(set-selected-tab [index number?]) void?]{
    Sets the currently selected tab by index.
  }
  
  @defmethod[(get-selected-tab) number?]{
    Returns the index of the currently selected tab.
  }
}

@section{Stack View}

@defclass[stack-view% panel% ()]{
  A stack container that displays only one child at a time.
  
  @defconstructor[([parent (or/c frame% panel%)])]{
    Creates a new stack view with the given parent.
  }
  
  @defmethod[(add-view [panel (is-a?/c panel%)]) void?]{
    Adds a new view to the stack.
  }
  
  @defmethod[(set-current-view [index number?]) void?]{
    Sets the currently visible view by index.
  }
  
  @defmethod[(get-current-view) number?]{
    Returns the index of the currently visible view.
  }
}

@section{Custom List Box}

@defclass[custom-list-box% panel% ()]{
  A customizable list box widget with support for custom item rendering.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [items (listof any/c)]
                   [item-renderer (-> any/c (is-a?/c panel%) void)]
                   [on-select (-> any/c any) void])]{
    Creates a new custom list box with the given items, renderer, and parent.
  }
  
  @defmethod[(set-items [items (listof any/c)]) void?]{
    Sets the items displayed in the list box.
  }
  
  @defmethod[(get-selected-item) any/c]{
    Returns the currently selected item.
  }
}
