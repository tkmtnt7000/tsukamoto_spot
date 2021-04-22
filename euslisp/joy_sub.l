#!/usr/bin/env roseus

(ros::roseus-add-msgs "sensor_msgs")
(ros::load-ros-manifest "roseus")
(ros::roseus "joy_sub")

(setq *joy* nil)
(defun joy_cb(msg)
  (if msg
      (progn
        (setq *joy* msg)
        (ros::ros-info "done!"))))
(ros::subscribe "joy" sensor_msgs::Joy #'joy_cb)

(ros::rate 10)
(while (ros::ok)
  (if *joy*
      ;;(setq x (send (elt *joy* 0) :axes))
      ;;(ros::ros-info "done!"))
      )
  (ros::spin-once)
  (ros::sleep)
  )

(defclass joy-cb-class
  :slots (*joy*)
  )
(defmethod joy-sub
  (:init ()
         (ros::roseus "joy_sub")
         (ros::subscribe "joy" sensor_msgs::Joy #'send self :joy-cb)
         (setq *joy* nil)
         (ros::ros-info "init")
         self)
  (:joy-cb (msg)
           (setq *joy* msg)
           )
  (:joy-loop ()
             ))
