;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; smarty-mode

(add-to-list 'auto-mode-alist (cons "\\.tpl\\'" 'smarty-mode))
(autoload 'smarty-mode "smarty-mode" "Smarty Mode" t)

(setq smarty-left-delimiter "{{")
(setq smarty-right-delimiter "}}")

