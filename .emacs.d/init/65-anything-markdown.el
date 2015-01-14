;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

(require 'anything-markdown)

(add-hook 'markdown-mode-hook
  (lambda()
    (define-key markdown-mode-map (kbd "C-]") 'anything-markdown-command)))




