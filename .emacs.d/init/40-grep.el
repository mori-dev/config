;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;;日本語を無視する設定
;; M-x rgrep 検索対象ワード RET 拡張子("*.txt *.el"など複数ある場合はスペースで区切る)
(require 'grep)


;; (add-to-list 'grep-find-ignored-directories "public")
(add-to-list 'grep-find-ignored-directories "node_modules")



(add-to-list 'grep-find-ignored-directories ".cache")
(add-to-list 'grep-find-ignored-directories "cache")
(add-to-list 'grep-find-ignored-directories "tmp")
(add-to-list 'grep-find-ignored-directories "log")
(add-to-list 'grep-find-ignored-directories "auto-save-alist")
(add-to-list 'grep-find-ignored-directories "dropbox.db")
(add-to-list 'grep-find-ignored-directories "node_modules")

(add-to-list 'grep-find-ignored-files "lancers.js")
(add-to-list 'grep-find-ignored-files "lancers.js.map")


(setq grep-host-defaults-alist nil)
(setq grep-template "lgrep <C> -n <R> <F> <N>") ;lgrep
;; (setq grep-template "ack <C> --nocolor --nogroup <R> <F> <N>")
;; ack --nocolor --nogroup
 ;rgrep
;doing
;; (setq grep-find-template "find . <X> -type f <F> -print0 | xargs -0 -e lgrep <C> -n <R> <N>")

;; rgrep
;; (setq grep-find-template "~/Dropbox/bin/ack --nocolor --nogroup -a --follow <R>")

;; M-x grep, M-x anythig-grep
;; (setq grep-command "ack --nocolor --nogroup -a --follow ")



;; (setq grep-find-template "ack --nogroup <R>") ;rgrep
;; ack -i --nocolor --nogroup lin /dev/null
