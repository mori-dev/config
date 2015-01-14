;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; Use Emacs23's eldoc
(require 'eldoc)

;; (install-elisp-from-emacswiki "eldoc-extension.el")

(require 'eldoc-extension)
(setq eldoc-idle-delay 0.10)
(setq eldoc-echo-area-use-multiline-p t)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
             (set-face-foreground 'eldoc-highlight-function-argument "Salmon")))
