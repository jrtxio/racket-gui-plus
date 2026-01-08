#lang racket/gui

;; Guix - Modern Racket GUI Widget Library
;; Layout engine for widget positioning and sizing

(require racket/class
         racket/gui/base
         racket/list
         racket/math)

;; ===========================
;; Layout Constants
;; ===========================

;; Layout modes
(define LAYOUT-MODES '(stack flow grid))

;; Stack direction
(define STACK-DIRECTIONS '(vertical horizontal))

;; ===========================
;; Layout Constraints
;; ===========================

;; Layout constraint structure
(struct layout-constraint (
  min-width          ; Minimum width (pixels)
  max-width          ; Maximum width (pixels, +inf.0 for no limit)
  min-height         ; Minimum height (pixels)
  max-height         ; Maximum height (pixels, +inf.0 for no limit)
  preferred-width    ; Preferred width (pixels)
  preferred-height   ; Preferred height (pixels)
  stretch            ; Stretch factor (0.0 = no stretch, 1.0 = full stretch)
  shrink             ; Shrink factor (0.0 = no shrink, 1.0 = full shrink)
  margin             ; Margin (top right bottom left)
  padding            ; Padding (top right bottom left)
  ))

;; Default layout constraints
(define DEFAULT-CONSTRAINTS
  (layout-constraint 0 +inf.0 0 +inf.0 0 0 1.0 1.0 '(0 0 0 0) '(0 0 0 0)))

;; ===========================
;; Layout Manager Interface
;; ===========================

;; Base layout manager class
(define guix-layout-manager% 
  (class object%
    (super-new)
    
    ;; Layout mode
    (init-field [mode 'stack]            ; Layout mode
                [direction 'vertical]    ; Stack direction
                [gap 0])                 ; Gap between children
    
    ;; Validate mode and direction
    (unless (member mode LAYOUT-MODES)
      (error "Invalid layout mode: ~a" mode))
    
    (unless (member direction STACK-DIRECTIONS)
      (error "Invalid stack direction: ~a" direction))
    
    ;; ===========================
    ;; Layout Calculation
    ;; ===========================
    
    ;; Calculate layout for children within given bounds
    (define/public (calculate-layout children bounds)
      (case mode
        [(stack) (calculate-stack-layout children bounds)]
        [(flow) (calculate-flow-layout children bounds)]
        [(grid) (calculate-grid-layout children bounds)]))
    
    ;; ===========================
    ;; Stack Layout
    ;; ===========================
    
    ;; Calculate stack layout
    (define/private (calculate-stack-layout children bounds)
      (let* ([x (first bounds)]
             [y (second bounds)]
             [width (third bounds)]
             [height (fourth bounds)]
             [available-space (if (eq? direction 'vertical) height width)]
             [fixed-space 0]
             [stretchable-space 0]
             [stretch-total 0])
        
        ;; Calculate fixed space and total stretch factor
        (for-each (λ (child) 
                    (let ([constraints (get-child-constraints child)])
                      (set! fixed-space (+ fixed-space (if (eq? direction 'vertical)
                                                          (layout-constraint-preferred-height constraints)
                                                          (layout-constraint-preferred-width constraints))))
                      (set! stretch-total (+ stretch-total (layout-constraint-stretch constraints)))))
                  children)
        
        ;; Calculate available stretchable space
        (set! stretchable-space (max 0 (- available-space fixed-space (* gap (max 0 (sub1 (length children)))))))
        
        ;; Position children
        (let ([current-pos (if (eq? direction 'vertical) y x)])
          (for-each (λ (child) 
                      (let* ([constraints (get-child-constraints child)]
                             [pref-size (if (eq? direction 'vertical)
                                           (layout-constraint-preferred-height constraints)
                                           (layout-constraint-preferred-width constraints))]
                             [stretch-factor (layout-constraint-stretch constraints)]
                             [stretch-size (if (> stretch-total 0)
                                               (* stretchable-space (/ stretch-factor stretch-total))
                                               0)]
                             [child-size (max pref-size (+ pref-size stretch-size))]
                             [child-width (if (eq? direction 'vertical) width pref-size)]
                             [child-height (if (eq? direction 'vertical) child-size height)])
                        
                        ;; Set child bounds
                        (set-child-bounds child 
                                          (if (eq? direction 'vertical) x current-pos)
                                          (if (eq? direction 'vertical) current-pos y)
                                          child-width
                                          child-height)
                        
                        ;; Update current position
                        (set! current-pos (+ current-pos child-size gap))))
                    children))))
    
    ;; ===========================
    ;; Flow Layout
    ;; ===========================
    
    ;; Calculate flow layout
    (define/private (calculate-flow-layout children bounds)
      (let* ([x (first bounds)]
             [y (second bounds)]
             [width (third bounds)]
             [height (fourth bounds)]
             [current-x x]
             [current-y y]
             [line-height 0])
        
        (for-each (λ (child) 
                    (let* ([constraints (get-child-constraints child)]
                           [child-width (layout-constraint-preferred-width constraints)]
                           [child-height (layout-constraint-preferred-height constraints)])
                      
                      ;; Check if child fits in current line
                      (when (> (+ current-x child-width) (+ x width))
                        ;; Move to next line
                        (set! current-x x)
                        (set! current-y (+ current-y line-height gap))
                        (set! line-height 0))
                      
                      ;; Set child bounds
                      (set-child-bounds child current-x current-y child-width child-height)
                      
                      ;; Update line height
                      (set! line-height (max line-height child-height))
                      
                      ;; Update current x position
                      (set! current-x (+ current-x child-width gap))))
                  children)))
    
    ;; ===========================
    ;; Grid Layout
    ;; ===========================
    
    ;; Calculate grid layout (simple grid - needs improvement)
    (define/private (calculate-grid-layout children bounds)
      (let* ([x (first bounds)]
             [y (second bounds)]
             [width (third bounds)]
             [height (fourth bounds)]
             [cols (ceiling (sqrt (length children)))]
             [rows (ceiling (/ (length children) cols))]
             [cell-width (/ width cols)]
             [cell-height (/ height rows)])
        
        (for-each (λ (child index) 
                    (let* ([row (quotient index cols)]
                           [col (remainder index cols)]
                           [child-x (+ x (* col cell-width))]
                           [child-y (+ y (* row cell-height))])
                      
                      ;; Set child bounds
                      (set-child-bounds child child-x child-y cell-width cell-height)))
                  children (range (length children)))))
    
    ;; ===========================
    ;; Helper Methods
    ;; ===========================
    
    ;; Get child layout constraints
    (define/private (get-child-constraints child)
      (if (is-a? child guix-layoutable<%>)
          (send child get-layout-constraints)
          DEFAULT-CONSTRAINTS))
    
    ;; Set child bounds
    (define/private (set-child-bounds child x y width height)
      (when (is-a? child area<%>)
        (send child move x y)
        (send child resize width height)))
    
    ))

;; ===========================
;; Layoutable Interface
;; ===========================

;; Interface for widgets that support layout constraints
(define guix-layoutable<%>
  (interface ()
    ;; Get layout constraints
    get-layout-constraints
    
    ;; Set layout constraints
    set-layout-constraints
    
    ;; Update layout
    update-layout
    
    ;; Get preferred size
    get-preferred-size
    ))

;; ===========================
;; Layout Mixin
;; ===========================

;; Mixin for adding layout support to widgets
(define layout-mixin
  (mixin () (guix-layoutable<%>)
    
    ;; Layout constraints
    (field [layout-constraints DEFAULT-CONSTRAINTS])
    
    ;; Layout manager (for containers)
    (field [layout-manager #f])
    
    ;; ===========================
    ;; Layout Constraint Methods
    ;; ===========================
    
    ;; Get layout constraints
    (define/public (get-layout-constraints)
      layout-constraints)
    
    ;; Set layout constraints
    (define/public (set-layout-constraints constraints)
      (set! layout-constraints constraints)
      (send this update-layout))
    
    ;; Update specific constraint
    (define/public (update-constraint key value)
      (set! layout-constraints
            (case key
              [(min-width) (struct-copy layout-constraint layout-constraints [min-width value])]
              [(max-width) (struct-copy layout-constraint layout-constraints [max-width value])]
              [(min-height) (struct-copy layout-constraint layout-constraints [min-height value])]
              [(max-height) (struct-copy layout-constraint layout-constraints [max-height value])]
              [(preferred-width) (struct-copy layout-constraint layout-constraints [preferred-width value])]
              [(preferred-height) (struct-copy layout-constraint layout-constraints [preferred-height value])]
              [(stretch) (struct-copy layout-constraint layout-constraints [stretch value])]
              [(shrink) (struct-copy layout-constraint layout-constraints [shrink value])]
              [(margin) (struct-copy layout-constraint layout-constraints [margin value])]
              [(padding) (struct-copy layout-constraint layout-constraints [padding value])]
              [else (error "Invalid constraint key: ~a" key)]))
      (send this update-layout))
    
    ;; ===========================
    ;; Layout Manager Methods
    ;; ===========================
    
    ;; Set layout manager
    (define/public (set-layout-manager manager)
      (set! layout-manager manager))
    
    ;; Get layout manager
    (define/public (get-layout-manager)
      layout-manager)
    
    ;; ===========================
    ;; Size Methods
    ;; ===========================
    
    ;; Get preferred size
    (define/public (get-preferred-size)
      (values (layout-constraint-preferred-width layout-constraints)
              (layout-constraint-preferred-height layout-constraints)))
    
    ;; Get minimum size
    (define/public (get-min-size)
      (values (layout-constraint-min-width layout-constraints)
              (layout-constraint-min-height layout-constraints)))
    
    ;; Get maximum size
    (define/public (get-max-size)
      (values (layout-constraint-max-width layout-constraints)
              (layout-constraint-max-height layout-constraints)))
    
    ;; ===========================
    ;; Layout Update
    ;; ===========================
    
    ;; Update layout
    (define/public (update-layout)
      ;; Override in subclasses if needed
      (void))
    
    ))

;; ===========================
;; Container Layout Mixin
;; ===========================

;; Mixin for containers that manage child layouts
(define container-layout-mixin
  (mixin (area-container<%>) ()
    
    ;; ===========================
    ;; Layout Management
    ;; ===========================
    
    ;; Override add-child to update layout
    (define/override (add-child child)
      (super add-child child)
      (send this update-layout))
    
    ;; Override delete-child to update layout
    (define/override (delete-child child)
      (super delete-child child)
      (send this update-layout))
    
    ;; Update layout for all children
    (define/public (update-layout)
      (let ([layout-manager (if (is-a? this guix-layoutable<%>) 
                               (send this get-layout-manager) 
                               #f)])
        (when layout-manager
          (let ([bounds (list 0 0 (send this get-width) (send this get-height))])
            (send layout-manager calculate-layout (send this get-children) bounds)))))
    
    ;; ===========================
    ;; Size Methods
    ;; ===========================
    
    ;; No on-size method override needed for area-container<%> - use resize callback instead
    
    ))

;; ===========================
;; Layout Helper Functions
;; ===========================

;; Create default layout constraints
(define (make-default-constraints)
  DEFAULT-CONSTRAINTS)

;; Create custom layout constraints
(define (make-constraints #:min-width [min-width 0]
                          #:max-width [max-width +inf.0]
                          #:min-height [min-height 0]
                          #:max-height [max-height +inf.0]
                          #:preferred-width [preferred-width 0]
                          #:preferred-height [preferred-height 0]
                          #:stretch [stretch 1.0]
                          #:shrink [shrink 1.0]
                          #:margin [margin '(0 0 0 0)]
                          #:padding [padding '(0 0 0 0)])
  (layout-constraint min-width max-width min-height max-height
                     preferred-width preferred-height
                     stretch shrink margin padding))

;; Create stack layout manager
(define (make-stack-layout #:direction [direction 'vertical]
                          #:gap [gap 0])
  (new guix-layout-manager% [mode 'stack] [direction direction] [gap gap]))

;; Create flow layout manager
(define (make-flow-layout #:gap [gap 0])
  (new guix-layout-manager% [mode 'flow] [gap gap]))

;; Create grid layout manager
(define (make-grid-layout #:gap [gap 0])
  (new guix-layout-manager% [mode 'grid] [gap gap]))

;; ===========================
;; Export
;; ===========================
(provide
 ;; Layout constraints
 layout-constraint make-constraints make-default-constraints
 
 ;; Layout manager
 guix-layout-manager%
 
 ;; Layoutable interface
 guix-layoutable<%>
 
 ;; Mixins
 layout-mixin container-layout-mixin
 
 ;; Layout helper functions
 make-stack-layout make-flow-layout make-grid-layout
 
 ;; Constants
 LAYOUT-MODES STACK-DIRECTIONS)