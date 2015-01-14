;; ;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; ;; GAUCHE 用 flymake
;; (when (and (require 'flymake nil t))
;;   (defvar flymake-glint-err-line-patterns '(("^\\(.+\\):\\([0-9]+\\): \\(.+\\)$" 1 2 nil 3)))
;;   (defconst flymake-allowed-gauche-file-name-masks '(("\\.scm$" flymake-gauche-init)))

;;   (defun flymake-gauche-init ()
;;     (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-inplace))
;;            (local-file (file-relative-name
;;                         temp-file
;;                         (file-name-directory buffer-file-name))))
;;       (list "glint" (list local-file))))

;;   (defun flymake-gauche-load ()
;;     (interactive)
;;     (defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
;;       (setq flymake-check-was-interrupted t))
;;     (ad-activate 'flymake-post-syntax-check)
;;     (setq flymake-allowed-file-name-masks (append flymake-allowed-file-name-masks
;;                                                   flymake-allowed-gauche-file-name-masks))
;;     (setq flymake-err-line-patterns flymake-glint-err-line-patterns)
;;     (flymake-mode t))

;;   (add-hook 'scheme-mode-hook '(lambda ()
;;                                  (flymake-gauche-load)
;;                                  (define-key scheme-mode-map "\C-cd" 'flymake-display-err-minibuf))))
