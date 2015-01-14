;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

(require 'html-helper-imenu)
(autoload 'html-helper-imenu-setup "html-helper-imenu")
(add-hook 'html-helper-mode-hook 'html-helper-imenu-setup)

