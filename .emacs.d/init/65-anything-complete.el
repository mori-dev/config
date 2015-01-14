;; ;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; (require 'anything-complete)
;; ;; Automatically collect symbols by 150 secs
;; (anything-lisp-complete-symbol-set-timer 150)
;; (anything-read-string-mode t)

;; (defadvice anything-read-string-mode (around my-anything-read-string-mode activate)
;;   "If this minor mode is on, use `anything' version of `completing-read' and `read-file-name'."
;;   (interactive "P")
;;   (setq anything-read-string-mode (if arg (> (prefix-numeric-value arg) 0) (not anything-read-string-mode)))
;;   (cond (anything-read-string-mode
;;          ;; redefine to anything version
;;          ;; (defalias 'completing-read (symbol-function 'anything-completing-read))
;;          ;; (defalias 'read-file-name (symbol-function 'anything-read-file-name))
;;          (setq read-buffer-function 'anything-read-buffer)
;;          ;; (defalias 'read-buffer (symbol-function 'anything-read-buffer))
;;          ;; (defalias 'read-variable (symbol-function 'anything-read-variable))
;;          ;; (defalias 'read-command (symbol-function 'anything-read-command))
;;          ;; (substitute-key-definition 'execute-extended-command 'anything-execute-extended-command global-map)
;;          ;; (substitute-key-definition 'find-file 'anything-find-file global-map)
;;          (message "Installed anything version of read functions."))
;;         (t
;;          ;; restore to original version
;;          ;; (defalias 'completing-read (symbol-function 'anything-old-completing-read))
;;          ;; (defalias 'read-file-name (symbol-function 'anything-old-read-file-name))
;;          (setq read-buffer-function (get 'anything-read-string-mode 'orig-read-buffer-function))
;;          ;; (defalias 'read-buffer (symbol-function 'anything-old-read-buffer))
;;          ;; (defalias 'read-variable (symbol-function 'anything-old-read-variable))
;;          ;; (defalias 'read-command (symbol-function 'anything-old-read-command))
;;          ;; (substitute-key-definition 'anything-execute-extended-command 'execute-extended-command global-map)
;;          ;; (substitute-key-definition 'anything-find-file 'find-file global-map)
;;          (message "Uninstalled anything version of read functions."))))


;; (add-hook 'emacs-lisp-mode-hook
;;   (lambda()
;;     (define-key emacs-lisp-mode-map (kbd "C-o") 'anything-lisp-complete-symbol-partial-match)
;;     ))
