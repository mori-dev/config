;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; revive.el

(autoload 'save-current-configuration "revive" "Save status" t)
(autoload 'resume "revive" "Resume Emacs" t)
(autoload 'wipe "revive" "Wipe emacs" t)
;; (define-key ctl-x-map "S" 'save-current-configuration)    ; C-x S で状態保存
(define-key ctl-x-map "F" 'resume)                        ; C-x F で復元
(add-hook 'kill-emacs-hook 'save-current-configuration)   ; 終了時に状態保存

(defvar revive:configuration-file-bk "~/.revive-bk.el")

(defadvice save-current-configuration (before my-save-current-configuration activate)
  (copy-file (expand-file-name revive:configuration-file) revive:configuration-file-bk t))

(defadvice resume (around my-resume activate)
  "Resume window/buffer configuration.
Configuration should be saved by save-current-configuration."
  (interactive "p")
  ;; (setq num (or num 1))
  (setq num 1)
  (let (sexp bufs x config)
    ;; (find-file (expand-file-name revive:configuration-file-bk))

    (if current-prefix-arg
        (find-file (expand-file-name revive:configuration-file-bk))
      (find-file (expand-file-name revive:configuration-file)))
    (goto-char (point-min))
    (emacs-lisp-mode)
    (if (null (search-forward revive:version-prefix nil t))
        (error "Configuration file collapsed."))
    (if (and (not (string= revive:version
                           (buffer-substring
                            (point)
                            (prog2 (end-of-line) (point)))))
             (y-or-n-p
              "Configuration file's version conflicts. Continue?"))
        (error "Configuration file is old.  Please update."))
    (if (null (re-search-forward (format "^(%d" num) nil t))
        (error "Configuration empty."))
    (goto-char (match-beginning 0))
    (setq sexp (read (current-buffer))
          bufs (nth 1 sexp)
          config (nth 2 sexp))
    (kill-buffer (current-buffer))
    (revive:restore-buffers bufs)
    (restore-window-configuration config)
    (run-hooks 'resume-hook)))

;; 30分ごとにbufferを保存
(run-with-idle-timer 1800 t 'save-current-configuration)
