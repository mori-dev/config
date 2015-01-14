
(setq tramp-default-method "ssh")



;; http://ubulog.blogspot.com/2010/03/emacs-sudo.html
;; (defun file-root-p (filename)
;;   "Return t if file FILENAME created by root."
;;   (eq 0 (nth 2 (file-attributes filename))))

;; (defun th-rename-tramp-buffer ()
;;   (when (file-remote-p (buffer-file-name))
;;     (rename-buffer
;;      (format "%s:%s"
;;              (file-remote-p (buffer-file-name) 'method)
;;              (buffer-name)))))

;; (add-hook 'find-file-hook
;;           'th-rename-tramp-buffer)

;; (defadvice find-file (around th-find-file activate)
;;   "Open FILENAME using tramp's sudo method if it's read-only."
;;   (if (and (file-root-p (ad-get-arg 0))
;;            (not (file-writable-p (ad-get-arg 0)))
;;            (y-or-n-p (concat "File "
;;                              (ad-get-arg 0)
;;                              " is read-only.  Open it as root? ")))
;;       (th-find-file-sudo (ad-get-arg 0))
;;     ad-do-it))

;; (defun th-find-file-sudo (file)
;;   "Opens FILE with root privileges."
;;   (interactive "F")
;;   (set-buffer (find-file (concat "/sudo::" file))))


;;上の設定の後に書く。
(require 'tramp)
(setq tramp-shell-prompt-pattern "^.*[#$%>] *")


;;(require 'tramp)
;; (setq tramp-methods
;;       (cons
;;        '("my-sudo"  (tramp-login-program        "env SHELL=/bin/sh sudo")
;;          (tramp-login-args           (("-u" "%u")
;;                                       ("-s") ("-H") ("-p" "Password:")))
;;          (tramp-remote-sh            "/bin/sh")
;;          (tramp-copy-program         nil)
;;          (tramp-copy-args            nil)
;;          (tramp-copy-keep-date       nil)
;;          (tramp-password-end-of-line nil))
;;        tramp-methods))
