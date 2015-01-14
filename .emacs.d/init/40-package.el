;; (require 'package)

;; ;;インストールするディレクトリを指定
;; (setq package-user-dir (concat user-emacs-directory "vendor/elpa"))
;; ;;リポジトリにMarmaladeを追加
;; (add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
;; (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
;; ;; (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
;; (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))

;; ;;インストールしたパッケージにロードパスを通してロードする
;; (package-initialize)

;; (require 'init-loader)


;; ;; (when (< emacs-major-version 24)
;; ;;   ;; Emacs23 では引数が足りないので定義しておく
;; ;;   (defadvice delete-directory (around add-trash (directory &optional recursive trash) activate)
;; ;;      ad-do-it)
;; ;;   ;; Emacs23 に存在しないボタンを定義しておく
;; ;;   ;; /usr/share/emacs/24.2/lisp/help-mode.el.gz
;; ;;   (define-button-type 'help-package
;; ;;     :supertype 'help-xref
;; ;;     'help-function 'describe-package
;; ;;     'help-echo (purecopy "mouse-2, RET: Describe package"))
;; ;;   (define-button-type 'help-package-def
;; ;;     :supertype 'help-xref
;; ;;     'help-function (lambda (file) (dired file))
;; ;;     'help-echo (purecopy "mouse-2, RET: visit package directory"))
;; ;;   )