;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-
;; (require 'anything-template)
;;
;;; Change Log
;; 1.0.0:

;;; Code:

(require 'anything)

(defvar anything-c-source-template
  '((name . "anything-template")
    (init . (lambda (candidate) (setq hoge candidate))
    (candidates-in-buffer)
    (action
     ("Hoge-Action" . (lambda (candidate) (setq hoge candidate))
     ("Fuga-Action" . (lambda (candidate) (setq hoge candidate))))))))


(defun anything-template ()
  "anything-template using `anything'."
  (interactive)
  (setq hoge "hogehoge")
;  (anything
;   '(anything-c-source-template) nil "Find Bookmark: " nil nil))
)
(provide 'anything-template)
(setq anything-c-source-template anything-c-source-template anything-sources (list anything-c-source-template))
;;; end
;;; anything-template.el ends here

