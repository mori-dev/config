;; ;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; ;session.el

;; (setq session-globals-max-string 100000000)


;; ;; ミニバッファ履歴リストの最大長：tなら無限
;; ;(setq history-length t)
;; ;; session.el
;; ;;   kill-ringやミニバッファで過去に開いたファイルなどの履歴を保存する
;; (when (require 'session nil t)
;;   ;; (setq session-initialize '(de-saveplace session keys menus places))
;;   ;; (setq session-globals-include '((kill-ring 80)
;;   ;;                                 (session-file-alist 500 t)
;;   ;;                                 (file-name-history 10000)))
;;   ;; (setq session-locals-include )
;;   (setq session-save-print-spec '(t nil nil))
;;   (add-hook 'after-init-hook 'session-initialize)
;;   ;; 前回閉じたときの位置にカーソルを復帰
;;   (setq session-undo-check -1))
