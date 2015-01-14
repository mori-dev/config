;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; css-mode

(require 'css-mode)
(add-to-list 'auto-mode-alist '("\\.css\\'" . css-mode))
;; (add-to-list 'auto-mode-alist '("\\.scss\\'" . css-mode))
;; (add-to-list 'auto-mode-alist '("\\.less\\'" . css-mode))
(autoload 'css-mode "css-mode" nil t)
(setq css-indent-level 2)
