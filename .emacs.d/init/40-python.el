;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

(require 'python-mode)
(setq py-beep-if-tab-change nil)
(add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))
(setq py-imenu-show-method-args-p t)
