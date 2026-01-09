#lang scribble/manual

@title[#:tag "composite-widgets"]{Composite Widgets}

Composite widgets are built from multiple atomic widgets, combining their 
functionality to create more complex UI components.

@section{Category Card}

@defclass[category-card% guix-base-control% ()]{
  A category display card with icon, count, and label, typically used for filtering or category selection.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [label string? "Today"]
                   [count number? 0]
                   [icon-symbol string? "📅"]
                   [bg-color (or/c color% #f) #f]
                   [on-click (-> any/c any) void])]{
    Creates a new category card with the given label, count, icon, and parent.
  }
}

@section{Input Field}

@defclass[input-field% vertical-panel% ()]{
  A composite input widget consisting of a label and a text field.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [label string?]
                   [init-value string? ""]
                   [on-change (-> string? any) void])]{
    Creates a new input field with the given label and parent.
  }
  
  @defmethod[(get-value) string?]{
    Returns the current value of the input field.
  }
  
  @defmethod[(set-value [value string?]) void?]{
    Sets the value of the input field.
  }
}

@section{Progress Bar}

@defclass[progress-bar% canvas% ()]{
  A modern progress bar widget for displaying progress of operations.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [min-value number? 0]
                   [max-value number? 100]
                   [value number? 0]
                   [style (listof symbol?) '()])]{
    Creates a new progress bar with the given range and initial value.
  }
  
  @defmethod[(set-value [value number?]) void?]{
    Sets the current progress value.
  }
  
  @defmethod[(get-value) number?]{
    Returns the current progress value.
  }
}

@section{Search Field}

@defclass[search-field% horizontal-panel% ()]{
  A search input widget with a search button and clear functionality.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [init-value string? ""]
                   [on-search (-> string? any) void]
                   [on-change (-> string? any) void])]{
    Creates a new search field with the given parent and initial value.
  }
  
  @defmethod[(get-value) string?]{
    Returns the current search query.
  }
  
  @defmethod[(set-value [value string?]) void?]{
    Sets the search query.
  }
  
  @defmethod[(clear) void?]{
    Clears the search field.
  }
}

@section{Segmented Control}

@defclass[segmented-control% horizontal-panel% ()]{
  A segmented control widget for selecting one option from multiple choices.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [options (listof string?)]
                   [selected-index number? 0]
                   [on-change (-> number? any) void])]{
    Creates a new segmented control with the given options and parent.
  }
  
  @defmethod[(set-selected-index [index number?]) void?]{
    Sets the selected segment by index.
  }
  
  @defmethod[(get-selected-index) number?]{
    Returns the index of the currently selected segment.
  }
  
  @defmethod[(get-selected-option) string?]{
    Returns the currently selected option text.
  }
}

@section{Stepper Input}

@defclass[stepper-input% horizontal-panel% ()]{
  A numeric input widget with increment and decrement buttons.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [init-value number? 0]
                   [min-value (or/c #f number?) #f]
                   [max-value (or/c #f number?) #f]
                   [on-change (-> number? any) void])]{
    Creates a new stepper input with the given initial value and constraints.
  }
  
  @defmethod[(get-value) number?]{
    Returns the current value.
  }
  
  @defmethod[(set-value [value number?]) void?]{
    Sets the value.
  }
}
