;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

(require 'anything-project)

(defun my-anything-project-cc()
  (interactive)
  (anything-project 'cache-clear))


(setq ap:default-filter-regexps
  '("\\.php$" "\\.pm$" "\\.t$" "\\.pl$" "\\.PL$"))

;; anything-projectの候補にディレクトリが含まれないようにする
(setq ap:project-files-filters
      (list
       (lambda (files)
         (remove-if 'file-directory-p files))))

;; (global-set-key (kbd "M-r") 'anything-project)
