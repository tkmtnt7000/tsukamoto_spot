(load "package://spoteus/spot-interface.l")

;; nilだとirt-viewerがでない
;; 現状は必要ないのでnil
(spot-init nil)

;; AutoWalkファイルへのパスを通す
(setq *path* "/home/spot/デスクトップ/2021-04-20 164658 2felevto100rho.walk")
(send *ri* :upload-path *path*)

;; 初期位置を設定する
(send *ri* :initial-localization-waypoint 0)
;; こちらだと初期位置を厳密に決める必要がない
;;(send *ri* :initial-localization-fiducial)

;; ゴールまで行く
(send *ri* :navigate-to -1)

(send *ri* :speak-jp "お茶をください")
(unix::sleep 5)

;; 初期位置まで戻る
;; 2mごとにポイントを立てているらしい
(send *ri* :navigate-to 0)
