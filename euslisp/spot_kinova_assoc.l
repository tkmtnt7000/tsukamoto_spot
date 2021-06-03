#!/usr/bin/env roseus

(load "spot.l")
(load "gen3_lite_gen3_lite_2f.l")

(defun spot-kinova ()
  ;;(gen3_lite_gen3_lite_2f)
  (objects (list (spot) (gen3_lite_gen3_lite_2f)))
  (send *spot* :locate #f(0 0 500))
  (send *gen3_lite_gen3_lite_2f* :locate #f(300 0 570))
  )
