#lang racket/gui
(require racket/date racket/class racket/draw)

;; Calendar component
;; Modern month-view calendar with date selection functionality

(provide calendar%
         guix-calendar%)

;; New guix-calendar% with updated naming convention
(define guix-calendar% calendar%)

(define calendar%
  (class canvas%
    (init-field [parent #f]
                [on-select-callback void])
    
    (super-new [parent parent]
               [style '()]
               [min-width 280]
               [min-height 280])
    
    ;; ---------------- State and Date Calculations ----------------
    (define today-date (current-date))
    (define today-y (date-year today-date))
    (define today-m (date-month today-date))
    (define today-d (date-day today-date))

    (define current-year today-y)
    (define current-month today-m)
    (define selected-day today-d) ; Default to today
    
    ;; ---------------- Color Scheme (Reminders Style) ----------------
    (define color-accent (make-object color% 0 122 255))      ; Apple blue
    (define color-text-main (make-object color% 40 40 40))     ; Dark gray text
    (define color-text-light (make-object color% 170 170 170)) ; Weekday text
    
    (define header-height 50)
    (define weekday-height 30)
    (define days-of-week '("日" "一" "二" "三" "四" "五" "六"))
    
    (define (days-in-month y m)
      (let ([leap? (and (= (modulo y 4) 0) (or (not (= (modulo y 100) 0)) (= (modulo y 400) 0)))])
        (list-ref (list 0 31 (if leap? 29 28) 31 30 31 30 31 31 30 31 30 31) m)))

    (define (first-day-of-month y m)
      (date-week-day (seconds->date (find-seconds 0 0 0 1 m y))))

    ;; ---------------- Drawing Logic ----------------
    (define/override (on-paint) 
      (define dc (send this get-dc))
      (send dc set-smoothing 'smoothed) ; Anti-aliasing for smooth circles
      (define-values (w h) (send this get-client-size))
      
      ;; 1. Background
      (send dc set-brush "white" 'solid)
      (send dc set-pen "white" 1 'transparent)
      (send dc draw-rectangle 0 0 w h)
      
      ;; 2. Header (Year and Month)
      (send dc set-text-foreground color-text-main)
      (send dc set-font (make-object font% 14 'default 'normal 'bold))
      (define title (format "~a年 ~a月" current-year current-month))
      (define-values (tw th td ta) (send dc get-text-extent title))
      (send dc draw-text title 20 (/ (- header-height th) 2)) 
      
      ;; Navigation buttons
      (send dc set-text-foreground color-accent)
      (send dc draw-text "<" (- w 80) (/ (- header-height th) 2))
      (send dc draw-text ">" (- w 40) (/ (- header-height th) 2))
      
      ;; 3. Weekday headers
      (send dc set-font (make-object font% 10 'default 'normal 'normal))
      (send dc set-text-foreground color-text-light)
      (define cell-w (/ w 7))
      (for ([i (in-range 7)] [d days-of-week])
        (define-values (dtw dth _1 _2) (send dc get-text-extent d))
        (send dc draw-text d (+ (* i cell-w) (/ (- cell-w dtw) 2)) header-height))
      
      ;; 4. Date grid
      (define start-day (first-day-of-month current-year current-month))
      (define total-days (days-in-month current-year current-month))
      (define y-start (+ header-height weekday-height))
      (define cell-h 38)
      
      (for ([day (in-range 1 (+ total-days 1))])
        (define pos (+ start-day day -1))
        (define col (modulo pos 7))
        (define row (quotient pos 7))
        (define x (* col cell-w))
        (define y (+ y-start (* row cell-h)))
        
        (define day-str (number->string day))
        (define-values (dtw dth _1 _2) (send dc get-text-extent day-str))
        
        ;; Use let to bind local variables for drawing, avoiding syntax errors
        (let ([is-selected? (equal? selected-day day)]
              [is-today? (and (= current-year today-y) (= current-month today-m) (= day today-d))]
              [radius 15])
          
          (cond [is-selected?
                 (send dc set-brush color-accent 'solid)
                 (send dc set-pen color-accent 1 'solid)
                 (send dc draw-ellipse 
                           (+ x (/ cell-w 2) (- radius)) 
                           (+ y (/ cell-h 2) (- radius)) 
                           (* radius 2) (* radius 2))
                 (send dc set-text-foreground "white")]
                [is-today?
                 (send dc set-text-foreground color-accent)]
                [else
                 (send dc set-text-foreground color-text-main)])
          
          (send dc draw-text day-str (+ x (/ (- cell-w dtw) 2)) (+ y (/ (- cell-h dth) 2))))))

    ;; ---------------- Event Handling ----------------
    (define/override (on-event event)
      (when (send event button-down? 'left)
        (define x (send event get-x))
        (define y (send event get-y))
        (define-values (w h) (send this get-client-size))
        
        (cond
          ;; Click right navigation buttons in header
          [(and (< y header-height) (> x (- w 100)))
           (if (< x (- w 50)) (change-month -1) (change-month 1))]
          
          ;; Click date area
          [(> y (+ header-height weekday-height))
           (let* ([cell-w (/ w 7)]
                  [cell-h 38]
                  [col (quotient (exact-floor x) (exact-floor cell-w))]
                  [row (quotient (exact-floor (- y header-height weekday-height)) cell-h)]
                  [start-day (first-day-of-month current-year current-month)]
                  [day (+ (* row 7) col (- start-day) 1)])
             
             (when (and (>= day 1) (<= day (days-in-month current-year current-month)))
               (set! selected-day day)
               (on-select-callback current-year current-month selected-day)
               (send this refresh)))])))

    (define (change-month delta)
      (set! current-month (+ current-month delta))
      (cond [(= current-month 0) (begin (set! current-month 12) (set! current-year (- current-year 1)))]
            [(= current-month 13) (begin (set! current-month 1) (set! current-year (+ current-year 1)))])
      ;; Optimization: Automatically select today when returning to current month, otherwise no selection
      (if (and (= current-year today-y) (= current-month today-m))
          (set! selected-day today-d)
          (set! selected-day #f))
      (send this refresh))

    (define/public (set-date y m d)
      (set! current-year y)
      (set! current-month m)
      (set! selected-day d)
      (send this refresh))
      
    ;; Public interface: Get currently selected date
    (define/public (get-date)
      (values current-year current-month selected-day))
    
    ;; Public interface: Get current year
    (define/public (get-year)
      current-year)
    
    ;; Public interface: Get current month
    (define/public (get-month)
      current-month)
    
    ;; Public interface: Get currently selected day
    (define/public (get-day)
      selected-day)
    )
)
