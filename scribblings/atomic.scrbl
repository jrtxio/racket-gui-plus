#lang scribble/manual

@title[#:tag "atomic-widgets"]{Atomic Widgets}

Atomic widgets are the basic building blocks of user interfaces, providing fundamental 
interaction elements that can be combined to create more complex components.

@section{Button}

@defclass[button% guix-base-control% ()]{
  A standard push button widget.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [label string? "Button"]
                   [on-click (-> any/c any) void]
                   [enabled? boolean? #t]
                   [visible? boolean? #t])]{
    Creates a new button with the given label and parent.
  }
  
  @defmethod[(set-label [label string?]) void?]{
    Sets the button's label.
  }
  
  @defmethod[(get-label) string?]{
    Returns the button's current label.
  }
  
  @defmethod[(set-on-click [callback (-> any/c any)]) void?]{
    Sets the callback function to be called when the button is clicked.
  }
}

@section{Checkbox}

@defclass[checkbox% guix-base-control% ()]{
  A checkbox widget that can be checked or unchecked.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [label string? "Checkbox"]
                   [checked? boolean? #f]
                   [on-change (-> boolean? any) void])]{
    Creates a new checkbox with the given label and initial state.
  }
  
  @defmethod[(set-checked [checked boolean?]) void?]{
    Sets the checkbox's checked state.
  }
  
  @defmethod[(get-checked) boolean?]{
    Returns the checkbox's current checked state.
  }
  
  @defmethod[(set-label [label string?]) void?]{
    Sets the checkbox's label.
  }
  
  @defmethod[(get-label) string?]{
    Returns the checkbox's current label.
  }
}

@section{Editable Text}

@defclass[editable-text% guix-base-control% ()]{
  A basic editable text widget.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [init-value string? ""]
                   [on-change (-> string? any) void]
                   [on-enter (-> string? any) void])]{
    Creates a new editable text widget with the given initial value.
  }
  
  @defmethod[(set-value [value string?]) void?]{
    Sets the text content.
  }
  
  @defmethod[(get-value) string?]{
    Returns the current text content.
  }
  
  @defmethod[(set-placeholder [placeholder string?]) void?]{
    Sets the placeholder text shown when the widget is empty.
  }
}

@section{Icon}

@defclass[icon% guix-base-control% ()]{
  An icon widget for displaying symbolic or image icons.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [icon-symbol string? "📱"]
                   [size number? 24])]{
    Creates a new icon widget with the given symbol and size.
  }
  
  @defmethod[(set-icon-symbol [symbol string?]) void?]{
    Sets the icon's symbol.
  }
  
  @defmethod[(get-icon-symbol) string?]{
    Returns the icon's current symbol.
  }
  
  @defmethod[(set-size [size number?]) void?]{
    Sets the icon's size.
  }
}

@section{Label}

@defclass[label% guix-base-control% ()]{
  A simple text label widget.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [label string? "Label"]
                   [font-size number? 14])]{
    Creates a new label with the given text and font size.
  }
  
  @defmethod[(set-label [label string?]) void?]{
    Sets the label's text.
  }
  
  @defmethod[(get-label) string?]{
    Returns the label's current text.
  }
  
  @defmethod[(set-font-size [size number?]) void?]{
    Sets the label's font size.
  }
}

@section{Radio Button}

@defclass[radio-button% guix-base-control% ()]{
  A radio button widget, typically used in groups where only one can be selected.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [label string? "Radio Button"]
                   [group (or/c #f radio-group%) #f]
                   [selected? boolean? #f]
                   [on-change (-> boolean? any) void])]{
    Creates a new radio button with the given label and optional group.
  }
  
  @defmethod[(set-selected [selected boolean?]) void?]{
    Sets the radio button's selected state.
  }
  
  @defmethod[(get-selected) boolean?]{
    Returns the radio button's current selected state.
  }
  
  @defmethod[(set-group [group (or/c #f radio-group%)]) void?]{
    Sets the radio button's group.
  }
}

@defclass[radio-group% object% ()]{
  A group for managing radio buttons, ensuring only one is selected at a time.
  
  @defconstructor[()]{
    Creates a new radio group.
  }
  
  @defmethod[(add-radio-button [radio-button (is-a?/c radio-button%)]) void?]{
    Adds a radio button to the group.
  }
  
  @defmethod[(get-selected-button) (or/c (is-a?/c radio-button%) #f)]{
    Returns the currently selected radio button in the group, or #f if none is selected.
  }
}

@section{Slider}

@defclass[slider% guix-base-control% ()]{
  A horizontal or vertical slider for selecting a value within a range.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [min-value number? 0]
                   [max-value number? 100]
                   [init-value number? 50]
                   [orientation (one-of/c 'horizontal 'vertical) 'horizontal]
                   [on-change (-> number? any) void])]{
    Creates a new slider with the given range and initial value.
  }
  
  @defmethod[(set-value [value number?]) void?]{
    Sets the slider's current value.
  }
  
  @defmethod[(get-value) number?]{
    Returns the slider's current value.
  }
  
  @defmethod[(set-range [min-value number?] [max-value number?]) void?]{
    Sets the slider's minimum and maximum values.
  }
}

@section{Stepper}

@defclass[stepper% guix-base-control% ()]{
  A widget with increment and decrement buttons for numeric input.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [init-value number? 0]
                   [min-value (or/c #f number?) #f]
                   [max-value (or/c #f number?) #f]
                   [step number? 1]
                   [on-change (-> number? any) void])]{
    Creates a new stepper with the given initial value and constraints.
  }
  
  @defmethod[(set-value [value number?]) void?]{
    Sets the stepper's current value.
  }
  
  @defmethod[(get-value) number?]{
    Returns the stepper's current value.
  }
  
  @defmethod[(increment) void?]{
    Increments the stepper's value by the step amount.
  }
  
  @defmethod[(decrement) void?]{
    Decrements the stepper's value by the step amount.
  }
}

@section{Switch}

@defclass[switch% guix-base-control% ()]{
  A toggle switch widget that can be in an on or off state.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [on? boolean? #f]
                   [on-change (-> boolean? any) void])]{
    Creates a new switch with the given initial state.
  }
  
  @defmethod[(set-on [on boolean?]) void?]{
    Sets the switch's on/off state.
  }
  
  @defmethod[(get-on) boolean?]{
    Returns the switch's current on/off state.
  }
}

@section{Text Area}

@defclass[text-area% guix-base-control% ()]{
  A multi-line text input widget.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [init-value string? ""]
                   [rows number? 5]
                   [columns number? 30]
                   [on-change (-> string? any) void])]{
    Creates a new text area with the given initial value and dimensions.
  }
  
  @defmethod[(set-value [value string?]) void?]{
    Sets the text area's content.
  }
  
  @defmethod[(get-value) string?]{
    Returns the text area's current content.
  }
  
  @defmethod[(set-rows [rows number?]) void?]{
    Sets the number of visible rows.
  }
  
  @defmethod[(set-columns [columns number?]) void?]{
    Sets the number of visible columns.
  }
}

@section{Text Field}

@defclass[text-field% guix-base-control% ()]{
  A single-line text input widget.
  
  @defconstructor[([parent (or/c frame% panel%)]
                   [init-value string? ""]
                   [placeholder string? ""]
                   [on-change (-> string? any) void]
                   [on-enter (-> string? any) void])]{
    Creates a new text field with the given initial value and placeholder.
  }
  
  @defmethod[(set-value [value string?]) void?]{
    Sets the text field's content.
  }
  
  @defmethod[(get-value) string?]{
    Returns the text field's current content.
  }
  
  @defmethod[(set-placeholder [placeholder string?]) void?]{
    Sets the placeholder text shown when the field is empty.
  }
}