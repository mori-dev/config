(require 'mo-git-blame)
(setq mo-git-blame-blame-window-width 80)
;; format of blame
;; M-x mo-git-blame
;; 8文字より短いauthor 対策
;; (defun mo-git-blame-process-filter-process-entry (entry)
;;   (with-current-buffer (plist-get mo-git-blame-vars :blame-buffer)
;;     (save-excursion
;;       (let ((inhibit-read-only t)
;;             (info (format "%s (%-8s %s %s) %s"
;;                           (substring (symbol-name (plist-get entry :hash)) 0 8)
;;                           (let ((author (plist-get entry :author))) (substring author 0 (min 8 (length author))))
;;                           (format-time-string "%y-%m-%d %T" (mo-git-blame-commit-info-to-time entry) t)
;;                           (plist-get entry :author-tz)
;;                           (plist-get entry :summary)))
;;             i)
;;         (mo-git-blame-goto-line-markless (plist-get entry :result-line))
;;         (dotimes (i (plist-get entry :num-lines))
;;           (insert info)
;;           (goto-char (line-beginning-position 2)))))))
