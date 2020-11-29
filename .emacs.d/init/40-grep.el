(require 'grep)
(require 'grep-a-lot)
(require 'grep-edit)


;; (add-to-list 'grep-find-ignored-directories "public")
(add-to-list 'grep-find-ignored-directories "node_modules")

(add-to-list 'grep-find-ignored-directories ".cache")
(add-to-list 'grep-find-ignored-directories "cache")
(add-to-list 'grep-find-ignored-directories "tmp")
(add-to-list 'grep-find-ignored-directories "log")
(add-to-list 'grep-find-ignored-directories "auto-save-alist")
(add-to-list 'grep-find-ignored-directories "dropbox.db")
(add-to-list 'grep-find-ignored-directories "node_modules")

(add-to-list 'grep-find-ignored-files "bundle.js")
(add-to-list 'grep-find-ignored-files "bundle.js.map")

 ;rgrep
;; (setq grep-find-template "find . <X> -type f <F> -print0 | xargs -0 -e lgrep <C> -n <R> <N>")

;; rgrep
;; (setq grep-find-template "~/Dropbox/bin/ack --nocolor --nogroup -a --follow <R>")

;; M-x grep, M-x anythig-grep
;; (setq grep-command "ack --nocolor --nogroup -a --follow ")

;; (setq grep-find-template "ack --nogroup <R>") ;rgrep
;; ack -i --nocolor --nogroup lin /dev/null

;; M-x rgrepで置換箇所を出力して、M-x query-replaceで置換。

;; C-x s
;; ! を押して全て保存。

;; https://rubikitch.hatenadiary.org/entry/20081025/1224869598
(defadvice grep-edit-change-file (around inhibit-read-only activate)
  ""
  (let ((inhibit-read-only t))
    ad-do-it))
;; (progn (ad-disable-advice 'grep-edit-change-file 'around 'inhibit-read-only) (ad-update 'grep-edit-change-file)) 

(defun my-grep-edit-setup ()
  (define-key grep-mode-map '[up] nil)
  (define-key grep-mode-map "\C-c\C-c" 'grep-edit-finish-edit)
  (message (substitute-command-keys "\\[grep-edit-finish-edit] to apply changes."))
  (set (make-local-variable 'inhibit-read-only) t)
  )
(add-hook 'grep-setup-hook 'my-grep-edit-setup t)
