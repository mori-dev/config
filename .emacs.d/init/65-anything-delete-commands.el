;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

(require 'anything-delete-commands)

(eval-after-load "key-chord"
  '(key-chord-define-global "DD" 'anything-delete-commands))


(add-to-list 'anything-delete-command-list '("行末の空白を削除" . "(delete-trailing-whitespace)") t)
(add-to-list 'anything-delete-command-list '("空行を一括削除" . "(my-delete-all-blank-lines)") t)
(add-to-list 'anything-delete-command-list '("リージョンの空行を一括削除" . "(my-delete-blank-lines-in-region)") t)
(add-to-list 'anything-delete-command-list '("句読点を「, 」「. 」に置換" . "(text-adjust-kutouten)") t)
(add-to-list 'anything-delete-command-list '("全角文字と半角文字の間に空白を入れる" . "(text-adjust-space)") t)

(defun my-delete-all-blank-lines ()
 "空行を一括削除"
 (interactive)
 (save-excursion
   (goto-char (point-min))
   (flush-lines "^$")))

(defun my-delete-blank-lines-in-region (start end)
 "リージョンの空行を一括削除"
 (interactive "r")
   (flush-lines "^$" start end))
