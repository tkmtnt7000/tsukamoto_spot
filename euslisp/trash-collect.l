#!/usr/bin/env roseus

;;
;; This script is for demonstration of GraphNav interface with euslisp.
;; By default, it is assumed that Spot is at the entrance of 73B2 and headed to the AR marker on the door.
;;
(ros::roseus-add-msgs "speech_recognition_msgs")
(load "package://spoteus/spot-interface.l")
(unless (boundp '*ri*)
  (spot-init)) ;; do not create-viewer

(defun look-at-desk ()
  (setq coord (make-cascoords :pos #f(800 0 500) :rpy (float-vector 0 (/ pi 4) 0)))
  (send *spotkinova* :head :inverse-kinematics coord :rotation-axis t)
  (send *ri* :angle-vector (send *spotkinova* :angle-vector) 5000)
  (send *ri* :wait-interpolation nil)
  (send *spotkinova* :kinova_joint_1 :joint-angle 30)
  ;; (send *spotkinova* :head :move-end-rot 30 :z)
  (send *ri* :angle-vector (send *spotkinova* :angle-vector) 3000)
  (send *ri* :wait-interpolation nil)
  (send *spotkinova* :kinova_joint_1 :joint-angle -30)
  ;; (send *spotkinova* :head :move-end-rot -30 :z)
  (send *ri* :angle-vector (send *spotkinova* :angle-vector) 3000)
  (send *ri* :wait-interpolation nil))

(defun put-on-desk (coord)
  (send *spotkinova* :head :inverse-kinematics coord :rotation-axis nil)
  (send *ri* :angle-vector (send *spotkinova* :angle-vector) 5000)
  (send *ri* :wait-interpolation nil))

(defun autowalk-data-upload ()
  (setq *path*
        (ros::get-param "~path" (format nil "~A/autowalk/73b2_inside.walk"
                                        (ros::rospack-find "spot_autowalk_data"))))
  (setq *init-waypoint* (floor (ros::get-param "~init_waypoint" 0)))
  (setq *upload* (ros::get-param "~upload" t))
  ;; Upload graphnav files to the robot.
  (if *upload*  (send *ri* :upload-path *path*))
  ;; Localize the robot in the map
  (ros::ros-info "initialize position with waypoint of ~A" *init-waypoint*)
  ;; (send *ri* :initial-localization-waypoint *init-waypoint*)
  (send *ri* :initial-localization-fiducial))

(defun go-to-desk ()
  (let (name position)
    (while (not (setq name (set-name)))
      (send *ri* :speak-jp "聞き取れませんでした" :wait t))
    (setq position (look-up-desk-position name))
    (ros::ros-info "~A" position)
    (send *ri* :speak-jp "~Aさんの机に向かいます" :wait t)
    (send *ri* :navigate-to (car position))
    ;; when spot needs to move navigate position
    (unless (and (= (second position) 0) (= (third position) 0) (= (fourth position) 0))
      (send *ri* :go-pos (float-vector (second position) (third position) (fourth position))))
    (send *ri* :speak-jp "~Aさん" :wait t)))

(defun set-name ()
  (ros::ros-info "talk to Spot")
  (let ((message
         (elt (send (one-shot-subscribe
                     "/speech_to_text_jp"
                     speech_recognition_msgs::SpeechRecognitionCandidates) :transcript) 0)))
    (ros::ros-info "~A" message)
    (cond
     ((substringp "北川" message) "kitagawa")
     ((substringp "新城" message) "shinjo")
     ((substringp "金沢" message) "kanazawa")
     ((substringp "若林" message) "wakabayashi")
     ((substringp "種本" message) "tanemoto")
     ((substringp "ギガ" message) "guiga")
     ((substringp "石田" message) "ishida")
     ((substringp "平岡" message) "hiraoka")
     ((substringp "おびなた" message) "obinata")
     ((substringp "市倉" message) "ichikura")
     ((substringp "塚本" message) "tsukamoto")
     ((substringp "PR" message) "pr2")
     ((substringp "hr" message) "hrp2")
     ((substringp "3Dプリンター" message) "3dprinter")
     (t nil))))

;; set desk position to hash table
(defvar *desk-position* (make-hash-table :test #'equal))
(defun add-entry-desk-position (key value)
  (setf (gethash (intern key) *desk-position*) value))
(defun look-up-desk-position (key)
  (gethash (intern key) *desk-position*))

(defun make-hash-desk-position ()
  (add-entry-desk-position "hrp2" (list 3 0 0 0 "hrpつー"))
  (add-entry-desk-position "hiraoka" (list 4 0 -0.2 0 "平岡"))
  (add-entry-desk-position "obinata" (list 4 0 0 0 "おびなた"))
  (add-entry-desk-position "ishida" (list 5 0 0 90 "石田"))
  (add-entry-desk-position "tsukamoto" (list 6 0 0 0 "塚本"))
  (add-entry-desk-position "PR2" (list 10 0 0 0 "prつー"))
  (add-entry-desk-position "ichikura" (list 11 0 0 0 "いちくら"))
  (add-entry-desk-position "kitagawa" (list 13 0 0 0 "北川"))
  (add-entry-desk-position "3dprinter" (list 12 0 0.2 0 "すりーdぷりんたー"))
  (add-entry-desk-position "shinjo" (list 16 0 0 0 "新城"))
  (add-entry-desk-position "kanazawa" (list 16 0.2 0 0 "金沢"))
  (add-entry-desk-position "wakabayashi" (list 17 0 -0.2 0 "若林"))
  (add-entry-desk-position "tanemoto" (list 18 0 0 0 "種本"))
  (add-entry-desk-position "guiga" (list 18 0.3 0.2 30 "ギガ")))

(defun main ()
  (autowalk-data-upload)
  (make-hash-desk-position)
  ;;(send *ri* :go-pos 1.0 1.2 0)
  (send *ri* :speak-jp "宅配便ですか" :wait t)
  (send *ri* :speak-jp "どこに届けますか" :wait t)
  (unix::sleep 1)
  (go-to-desk)

  (send *ri* :speak-jp "お届け物です" :wait t)
  (send *ri* :speak-jp "受け取ったら受け取りましたと言ってください" :wait t)
  (while (not
          (string=
           "受け取りました"
           (elt (send (one-shot-subscribe
                       "/speech_to_text_jp"
                       speech_recognition_msgs::SpeechRecognitionCandidates) :transcript) 0))))
  (send *ri* :speak-jp "戻ります")
  (send *ri* :navigate-to 0))
