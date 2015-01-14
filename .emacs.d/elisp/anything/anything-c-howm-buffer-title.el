;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;;◆ 何ができるか
;;   ".howm" で終わる候補は該当ファイルの先頭行を表示します。
;;   howm のファイルは日付形式で，複数開いていると見分けにくいので，タイトルを表
;;   示するようにしました。

;;◆ 設定例
;; (require 'anything-c-howm-buffer-title)
;;
;; (defun anything-buffers ()
;;   (interactive)
;;   (anything-other-buffer
;;    '(anything-c-source-buffers+-howm-title
;;      anything-c-source-recentf
;;      ...
;;      )
;;    "*Buffer+File*"))
;; (global-set-key (kbd "M-h") 'anything-buffers)
;;
;; あるいは，
;; (setq anything-sources
;;       (list
;;         anything-c-source-buffers+-howm-title ;これを追加
;;         ;; anything-c-source-buffers はコメントアウト
;;         anything-c-source-recentf など
;;         ...
;;         ))
;; (global-set-key (kbd "M-h") 'anything)
;;

;; (require 'anything)
;; (require 'anything-config)

;; (defvar anything-c-source-buffers+-howm-title      
;;   '((name . "Buffers")
;;     (candidates . anything-c-buffer-list)
;;     (real-to-display . anything-howm-title-real-to-display)
;;     (type . buffer)
;;     (candidate-transformer
;;          anything-c-skip-current-buffer
;;          anything-c-highlight-buffers
;;          anything-c-skip-boring-buffers)
;;     (persistent-action . anything-c-buffers+-persistent-action)
;;     (persistent-help . "Show this buffer / C-u \\[anything-execute-persistent-action]: Kill this buffer")))
;; ;;(anything anything-c-source-buffers+-howm-title)

;; (defun anything-howm-title-real-to-display (file-name)
;;   (if (equal "howm" (file-name-extension file-name))
;;       (anything-howm-title-get-title file-name)
;;     file-name))

;; (defun anything-howm-title-get-title (buffer)
;;   (with-current-buffer buffer
;;     (let ((point (point-min)))
;;       (save-excursion
;;         (goto-char (point-min))
;;         (end-of-line)
;;         (buffer-substring point (point))))))

;; (provide 'anything-c-howm-buffer-title)
