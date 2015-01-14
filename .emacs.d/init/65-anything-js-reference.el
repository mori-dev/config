;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

(autoload 'anything-js-reference "anything-js-reference" nil t)
;;key-bind
  (define-key js2-mode-map "\C-o" 'anything-js-insert)
  (define-key js2-mode-map "\C-c\C-i" 'anything-js-reference)

;;open-linkという関数でurlにアクセスしているので必要
  (defun open-link (html)
    (shell-command (concat "firefox --new-tab \"" html "\"")))

