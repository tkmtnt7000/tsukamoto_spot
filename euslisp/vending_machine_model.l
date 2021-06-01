#!/usr/bin/env roseus

(defun make-body nil
  (setq c1 (make-cube 900 1150 1850)) ;; body
  (send c1 :set-color :white)
  (send c1 :locate #f(0 0 925))
  (setq c2 (make-cube 10 40 20)) ;; button sample
  (setq c3 (make-cube 250 700 140)) ;; outlet of machine
  (send c3 :locate #f(450 0 500))
  (setq c4 (body- c1 c3))
  (send c4 :set-color :red)
  c4)

(defun make-outlet nil
  (setq outlet (make-cube 250 700 140))
  (send outlet :locate #f(300 0 500))
  outlet)

(defun make-button nil
  (setq button_row_high (make-cube 900 800 100))
  (send button_row_high :set-color :blue)
  (send button_row_high :locate #f(50 0 1560))

  (setq button_row_middle (make-cube 900 800 100))
  (send button_row_middle :set-color :blue)
  (send button_row_middle :locate #f(50 0 1270))

  (setq button_row_low (make-cube 900 800 100))
  (send button_row_low :set-color :blue)
  (send button_row_low :locate #f(50 0 1000))
  )

(setq c5 (body+ c4 button_row_high button_row_middle button_row_low))

(defun make-touch-device nil
  (setq ic_touch (make-cube 900 150 160))
  (send ic_touch :set-color :black)
  (send ic_touch :locate #f(100 200 790))
  ic_touch)

(make-body)
(make-outlet)
(make-button)
(make-touch-device)
(setq c6 (body+ c5 ic_touch))
(send c6 :set-color :green)
(objects (list c4 outlet button_row_low button_row_middle button_row_high ic_touch))
