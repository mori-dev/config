;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;;$ man --path | tr : '\n'
(setq woman-manpath '("/opt/local/man/ja"
                      "/opt/local/man"
                      "/opt/local/share/man/ja"
                      "/opt/local/share/man"
                      "/Users/mori/.rvm/rubies/ruby-1.9.2-p290/share/man"
                      "/Users/mori/.rvm/man"
                      "/usr/share/man"
                      "/usr/local/share/man/ja"
                      "/usr/local/share/man"
                      "/usr/X11/man"
                      "/Library/Java/Home/man"))

;; (setq woman-manpath '("/usr/share/man/ja" "/opt/local/man" "/opt/local/man"))

(setq woman-use-own-frame nil)
(setq woman-imenu-generic-expression
      '((nil "^\\(   \\)?\\([ぁ-んァ-ヴー一-龠a-zA-Z0-9ａ-ｚＡ-Ｚ０-９]+\\)" 2)))

(eval-after-load "anything"
  '(progn
     (defun my-man ()
       (interactive)
       (anything anything-c-source-man-pages))))
