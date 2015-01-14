;;; anything-delete-commands.el

;; anything.el が (anything-enable-shortcuts 'alphabet) に対応している必要があります。
;; `anything.el' http://www.emacswiki.org/emacs/anything.el
;; prefix adc-

;; (defun delete-kugyo ()
;;  "空行を一括削除"
;;  (interactive)
;;  (save-excursion
;;    (goto-char (point-min))
;;    (flush-lines "^$")))

;; (defun my-delete-all-buffer-content ()
;;   "バッファの内容を全削除"
;;   (interactive)
;;   (goto-char (point-min))
;;   (flush-lines "\\.*"))

;; (defun my-delete-buffer-content-after-point ()
;;   "ポイントより後ろのバッファの内容を削除"
;;   (interactive)
;;   (save-excursion
;;     (newline)
;;     (flush-lines "\\.*")))

;; (defun delete-kugyo-region (start end)
;;  "リージョンの空行を一括削除"
;;  (interactive "r")
;;    (flush-lines "^$" start end))


(require 'anything)
(require 'anything-config)
(require 'anything-match-plugin)

(setq anything-delete-command-list
      '(("ポイントより上を kill" . "(kill-region (point) (point-min))")
        ("ポイントより下を kill" . "(kill-region (point) (point-max))")
        ("バッファ全体を kill" . "(kill-region (point-min) (point-max))")
        ("ポイントより上を delete" . "(delete-region (point) (point-min))")        
        ("ポイントより下を delete" . "(delete-region (point) (point-max))")
        ("バッファ全体を delete" . "(delete-region (point-min) (point-max))")
        ("現在のバッファのファイルを削除" . "(adc-delete-current-buffer-file)")))

(defvar anything-l-source-delete-commands
  '((name . "削除コマンド集")
    (candidates . anything-delete-command-list)    
    (type . sexp)))

(defun anything-delete-commands ()
  (interactive)
  (let ((anything-enable-digit-shortcuts t)
        (anything-enable-shortcuts 'alphabet))
    (anything (list anything-l-source-delete-commands) nil nil nil)))


(defun adc-delete-current-buffer-file()
  (buffer-file-name (current-buffer))
  (kill-buffer (current-buffer)))

(provide 'anything-delete-commands)
