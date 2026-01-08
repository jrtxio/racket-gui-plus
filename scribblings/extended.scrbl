#lang scribble/manual

@title[#:tag "extended-widgets"]{Extended Widgets}

Extended widgets are additional UI components not provided by racket/gui, but commonly 
used in modern desktop applications.

@section{Calendar}

@defclass[calendar% panel% ()]{
  A calendar widget for selecting dates.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [on-date-select (-> date? any) void])]{
    Creates a new calendar widget with the given parent.
  }
  
  @defmethod[(set-date [date date?]) void?]{
    Sets the currently selected date.
  }
  
  @defmethod[(get-date) date?]{
    Returns the currently selected date.
  }
}

@section{Date Time Picker}

@defclass[date-time-picker% vertical-panel% ()]{
  A combined date and time picker widget.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [on-change (-> date? any) void])]{
    Creates a new date-time picker with the given parent.
  }
  
  @defmethod[(set-date-time [date date?]) void?]{
    Sets the selected date and time.
  }
  
  @defmethod[(get-date-time) date?]{
    Returns the selected date and time.
  }
}

@section{Time Picker}

@defclass[time-picker% panel% ()]{
  A time picker widget for selecting hours and minutes.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [on-change (-> (cons/c number? number?) any) void])]{
    Creates a new time picker with the given parent.
  }
  
  @defmethod[(set-time [time (cons/c number? number?)]) void?]{
    Sets the selected time as a pair of hours and minutes.
  }
  
  @defmethod[(get-time) (cons/c number? number?)]{
    Returns the selected time as a pair of hours and minutes.
  }
}

@section{Toast}

@defclass[toast% frame% ()]{
  A toast notification widget that appears temporarily to display messages.
  
  @defconstructor[([message string?]
                   [type (one-of/c 'success 'error 'info) 'success]
                   [on-remove (-> any/c any) void])]{
    Creates a new toast notification with the given message and type.
  }
  
  @defmethod[(show [duration (or/c number? 'infinite) 3000]) void?]{
    Shows the toast notification for the specified duration.
  }
  
  @defmethod[(hide) void?]{
    Hides the toast notification.
  }
}

@defproc[(show-toast [message string?]
                     [type (one-of/c 'success 'error 'info) 'success]
                     [duration (or/c number? 'infinite) 3000])
         toast?]{
  Creates and shows a toast notification with the given message, type, and duration.
}

@section{Color Picker}

@defclass[color-picker% panel% ()]{
  A color picker widget for selecting colors.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [on-color-change (-> color% any) void])]{
    Creates a new color picker with the given parent.
  }
  
  @defmethod[(set-color [color color%]) void?]{
    Sets the currently selected color.
  }
  
  @defmethod[(get-color) color%]{
    Returns the currently selected color.
  }
}

@section{Toolbar}

@defclass[toolbar% horizontal-panel% ()]{
  A toolbar widget for displaying frequently used actions.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [style (listof symbol?) '()])]{
    Creates a new toolbar with the given parent and style.
  }
  
  @defmethod[(add-button [button (is-a?/c button%)]) void?]{
    Adds a button to the toolbar.
  }
  
  @defmethod[(add-separator) void?]{
    Adds a separator to the toolbar.
  }
}

@section{Statusbar}

@defclass[statusbar% horizontal-panel% ()]{
  A status bar widget for displaying application status information.
  
  @defconstructor[([parent (or/c frame%)]
                   [style (listof symbol?) '()])]{
    Creates a new status bar with the given parent and style.
  }
  
  @defmethod[(set-status [text string?]) void?]{
    Sets the status text.
  }
  
  @defmethod[(get-status) string?]{
    Returns the current status text.
  }
}

@section{Breadcrumb}

@defclass[breadcrumb% horizontal-panel% ()]{
  A breadcrumb navigation widget for displaying the current location in a hierarchy.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [items (listof string?)]
                   [on-item-click (-> number? any) void])]{
    Creates a new breadcrumb widget with the given items and parent.
  }
  
  @defmethod[(set-items [items (listof string?)]) void?]{
    Sets the breadcrumb items.
  }
  
  @defmethod[(get-items) (listof string?)]{
    Returns the current breadcrumb items.
  }
}

@section{Badge}

@defclass[badge% canvas% ()]{
  A badge widget for displaying notifications or counts.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [count (or/c number? string?) 0]
                   [visible? boolean? #t])]{
    Creates a new badge with the given count and parent.
  }
  
  @defmethod[(set-count [count (or/c number? string?)]) void?]{
    Sets the count displayed in the badge.
  }
  
  @defmethod[(get-count) (or/c number? string?)]{
    Returns the count displayed in the badge.
  }
  
  @defmethod[(set-visible [visible boolean?]) void?]{
    Shows or hides the badge.
  }
}

@section{Chip}

@defclass[chip% horizontal-panel% ()]{
  A chip widget for displaying tags or small pieces of information.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [label string?]
                   [on-remove (-> any/c any) void])]{
    Creates a new chip with the given label and parent.
  }
  
  @defmethod[(set-label [label string?]) void?]{
    Sets the chip's label text.
  }
  
  @defmethod[(get-label) string?]{
    Returns the chip's current label text.
  }
}

@section{Tooltip}

@defclass[tooltip% canvas% ()]{
  A custom tooltip widget for displaying additional information on hover.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [text string?]
                   [target (is-a?/c widget%)])]{
    Creates a new tooltip for the given target widget.
  }
  
  @defmethod[(set-text [text string?]) void?]{
    Sets the tooltip's text.
  }
  
  @defmethod[(get-text) string?]{
    Returns the tooltip's current text.
  }
}
