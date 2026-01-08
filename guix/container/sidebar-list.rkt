#lang racket/gui

;; Sidebar list component
;; Modern sidebar list with customizable items

(require racket/class
         racket/draw
         "../style/config.rkt")

(provide sidebar-list%
         guix-sidebar-list%
         list-item)

;; New guix-sidebar-list% with updated naming convention
(define guix-sidebar-list% sidebar-list%)

;; List item class for sidebar items
(define list-item
  (class object%
    (init-field [label ""]
                [color (make-object color% 0 122 255)]
                [count 0]
                [data #f])
    
    ;; Public methods to access fields
    (define/public (get-label) label)
    (define/public (set-label! new-label) (set! label new-label))
    
    (define/public (get-color) color)
    (define/public (set-color! new-color) (set! color new-color))
    
    (define/public (get-count) count)
    (define/public (set-count! new-count) (set! count new-count))
    
    (define/public (get-data) data)
    (define/public (set-data! new-data) (set! data new-data))
    
    (super-new)
    ))

;; Sidebar list widget implementation
(define sidebar-list%
  (class canvas%
    (init-field [items '()]
                [on-select (λ (i) #f)]
                [on-rename (λ (i new-label) #f)]
                [on-delete (λ (i) #f)])
    
    (super-new [style '(no-focus)]
               [min-width 200])
    
    ;; Register widget for theme switching
    (register-widget this)
    
    (define selected-index 0)
    (define hover-index -1)
    (define context-menu #f)
    (define context-menu-item-index -1)
    
    (define/override (on-paint)
      (define dc (send this get-dc))
      (define-values (w h) (send this get-client-size))
      (send dc set-smoothing 'smoothed)
      
      ;; Draw background
      (send dc set-brush (color-bg-light) 'solid)
      (send dc set-pen (color-bg-light) 1 'solid)
      (send dc draw-rectangle 0 0 w h)
      
      (for ([item (in-list items)] [i (in-naturals)])
        (let* ([margin (spacing-xs)] ; Reduce margin from medium to xs to make layout more compact
               [item-h 34.0]
               [gap 0] ; No gap between items
               [y (+ margin (* i (+ item-h gap)))]
               [rect-x margin]
               [rect-w (max 0.0 (- w (* margin 2.0)))])
          
          (define is-selected (= i selected-index))
          (define is-hover (= i hover-index))

          ;; 1. Background drawing
          (cond
            [is-selected
             (send dc set-brush (color-accent) 'solid)
             (send dc set-pen (color-accent) 1 'solid)]
            [is-hover
             (send dc set-brush (make-object color% 0 0 0 0.05) 'solid)
             (send dc set-pen "lightgray" 1 'transparent)]
            [else
             (send dc set-brush "white" 'transparent)
             (send dc set-pen "white" 1 'transparent)])
          
          (send dc draw-rounded-rectangle rect-x y rect-w item-h (border-radius-small))
          
          ;; 2. Circular icon
          (let ([dot-size 18.0]
                [dot-x (+ rect-x 10.0)]
                [dot-y (+ y (/ (- item-h 18.0) 2.0))])
            (send dc set-brush (send item get-color) 'solid)
            (send dc set-pen "white" 1 'transparent)
            (send dc draw-ellipse dot-x dot-y dot-size dot-size))
          
          ;; 3. Text
          (send dc set-text-foreground (if is-selected "white" (color-text-main)))
          (send dc set-font (font-regular))
          ;; Calculate available width for text
          (define counter-margin 20) ; Space for counter badge
          (define text-start-x (+ rect-x 36.0))
          (define text-end-x (- w margin counter-margin))
          (define available-text-width (- text-end-x text-start-x))
          ;; Get full label text
          (define full-label (send item get-label))
          ;; Truncate text if it's too long
          (define label-to-draw
            (let-values ([(tw _1 _2 _3) (send dc get-text-extent full-label)])
              (if (> tw available-text-width)
                  ;; Truncate with ellipsis
                  (let loop ([length (string-length full-label)])
                    (if (<= length 0)
                        "..."
                        (let* ([truncated (string-append (substring full-label 0 length) "...")]
                               [truncated-width (let-values ([(w _) (send dc get-text-extent truncated)]) w)])
                          (if (<= truncated-width available-text-width)
                              truncated
                              (loop (- length 1))))))
                  full-label)))
          (send dc draw-text label-to-draw text-start-x (+ y 7.0))
          
          ;; 4. Counter
          (let* ([count-str (number->string (send item get-count))]
                 [text-color (if is-selected "white" (color-text-placeholder))])
            (send dc set-font (font-small))
            (send dc set-text-foreground text-color)
            (define-values (tw _1 _2 _3) (send dc get-text-extent count-str))
            (send dc draw-text count-str (- w margin 12.0 tw) (+ y 8.0))))))
    
    ;; Create context menu
    (define (create-context-menu)
      (unless context-menu
        (set! context-menu (new popup-menu%))
        
        ;; Rename menu item
        (new menu-item% [parent context-menu] [label "Rename"]
             [callback (lambda (menu-item event)
                         (when (>= context-menu-item-index 0) (rename-item context-menu-item-index)))])
        
        ;; Delete menu item
        (new menu-item% [parent context-menu] [label "Delete"]
             [callback (lambda (menu-item event)
                         (when (>= context-menu-item-index 0) (delete-item context-menu-item-index)))])
        ))
    
    ;; Rename item
    (define (rename-item idx)
      (when (and (>= idx 0) (< idx (length items)))
        (define item (list-ref items idx))
        (define old-label (send item get-label))
        
        ;; Create rename dialog
        (define dialog (new dialog% [label "Rename"] [width 300]))
        (define panel (new vertical-panel% [parent dialog] [border 10] [spacing 10]))
        
        (new message% [parent panel] [label "Enter new name："])
        (define input (new text-field% [parent panel] [label ""] [init-value old-label]))
        
        (define button-panel (new horizontal-panel% [parent panel] [alignment '(center center)] [spacing 10]))
        (new button% [parent button-panel] [label "OK"]
             [callback (lambda (btn evt)
                         (define new-label (send input get-value))
                         (when (not (string=? new-label ""))
                           ;; Update item
                           (send item set-label! new-label)
                           (on-rename item new-label)
                           (send this refresh))
                         (send dialog show #f))])
        (new button% [parent button-panel] [label "Cancel"]
             [callback (lambda (btn evt)
                         (send dialog show #f))])
        
        (send dialog show #t)))
    
    ;; Delete item
    (define (delete-item idx)
      (when (and (>= idx 0) (< idx (length items)))
        (define item (list-ref items idx))
        (define label (send item get-label))
        
        ;; Show confirmation dialog
        (define result (message-box "Confirm Delete" (format "Are you sure you want to delete '~a'?" label) #f '(yes-no caution)))
        (when (eq? result 'yes)
          ;; Delete item
          (define new-items (append (take items idx) (drop items (+ idx 1))))
          (set! items new-items)
          
          ;; Update selected index
          (when (>= selected-index idx)
            (set! selected-index (max 0 (- selected-index 1))))
          
          (on-delete item)
          (send this refresh))))
    
    ;; Show context menu
    (define (show-context-menu x y idx)
      (set! context-menu-item-index idx)
      (create-context-menu)
      (define top-window (send this get-top-level-window))
      ;; Convert canvas coordinates to screen coordinates, then to window coordinates
      (define-values (screen-x screen-y) (send this client->screen x y))
      (define-values (window-x window-y) (send top-window screen->client screen-x screen-y))
      (send top-window popup-menu context-menu window-x window-y))
    
    (define/override (on-event event)
      (define x (send event get-x))
      (define y (send event get-y))
      (define-values (w h) (send this get-client-size))
      
      (define idx (if (< y (spacing-medium)) -1 (inexact->exact (quotient (truncate (- y (spacing-medium))) (+ 34.0 (spacing-small))))))
      (define is-over-item (and (>= x (spacing-medium)) (<= x (- w (spacing-medium)))
                                (>= idx 0) (< idx (length items))))

      (case (send event get-event-type)
        [(leave) (set! hover-index -1) (send this refresh)]
        [(motion enter)
         (let ([old-hover hover-index])
           (set! hover-index (if is-over-item idx -1))
           (unless (= old-hover hover-index) (send this refresh)))]
        [(left-down)
         (when is-over-item
           (set! selected-index idx)
           (on-select (list-ref items idx))
           (send this refresh))]
        [(right-down)
         (when is-over-item
           (show-context-menu x y idx))]))
    
    ;; ---------------- 公共方法 ----------------
    (define/public (set-items! new-items)
      (set! items new-items)
      (send this refresh))
    
    (define/public (get-selected-item)
      (if (and (>= selected-index 0) (< selected-index (length items)))
          (list-ref items selected-index)
          #f))
    
    (define/public (get-items)
      items)
    
    (define/public (select-item idx)
      (when (and (>= idx 0) (< idx (length items)))
        (set! selected-index idx)
        (on-select (list-ref items idx))
        (send this refresh)))
    
    (define/public (get-value)
      (send this get-selected-item))
    
    (define/public (add-item item)
      (set! items (append items (list item)))
      (send this refresh))
    
    (define/public (remove-item idx)
      (when (and (>= idx 0) (< idx (length items)))
        (set! items (append (take items idx) (drop items (+ idx 1))))
        (send this refresh)))
    
    ))
