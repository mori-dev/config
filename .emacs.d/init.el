

;; (setq initial-major-mode 'emacs-lisp-mode)

;; ;; ;; 個別の設定
;; ;; (cond
;; ;;  ;; Meadow の場合
;; ;;  ((featurep 'meadow) (setting-for-meadow))
;; ;;  ;; emacs22 の場合
;; ;;  ((equal emacs-major-version 22) (setting-for-emacs22))
;; ;;  ;; emacs23 の場合
;; ;;  ((equal emacs-major-version 23) (setting-for-emacs23))
;; ;;  (t nil))

(defun my-add-load-path-subdir (dirlist)
  (with-temp-buffer
    (dolist (dir dirlist)
      (cd dir)
      (normal-top-level-add-subdirs-to-load-path))))

;; Warning: `mapcar' called for effect; use `mapc' or `dolist' instead を防ぐ
(setq byte-compile-warnings '(free-vars unresolved
                              callargs redefine
                              obsolete noruntime cl-functions
                              interactive-only make-local))

(setq initial-major-mode 'emacs-lisp-mode)

;;;; ロードパスの設定
(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/elisp")

(add-to-list 'load-path "~/.emacs.d/init")
(add-to-list 'load-path "~/.emacs.d/elisp/dired-extension")
(add-to-list 'load-path "~/.emacs.d/elisp/howm")
(add-to-list 'load-path "~/.emacs.d/elisp/magit")
(add-to-list 'load-path "~/.emacs.d/elisp/ruby")
(add-to-list 'load-path "~/.emacs.d/elisp/php")
(add-to-list 'load-path "~/.emacs.d/elisp/sdic")
(add-to-list 'load-path "~/.emacs.d/elisp/yasnippet")
(add-to-list 'load-path "~/.emacs.d/elisp/mylib")


(setq load-path (nreverse load-path))

(defun my-add-load-path-subdir (dirlist)
  (with-temp-buffer
    (dolist (dir dirlist)
      (cd dir)
      (add-to-list 'load-path dir)
      (normal-top-level-add-subdirs-to-load-path))))

(my-add-load-path-subdir
 '(
   "~/.emacs.d/elisp/anything"
   "~/.emacs.d/elisp/emacs-deferred"
   ;; "~/.emacs.d/elisp/auto-complete"
   ))


;; 準備
(eval-when-compile (require 'cl))
(setq default-tab-width 4)
(setq tab-width 4)

;; ;; 個別の設定
;; (cond
;;  ;; emacs23 の場合
;;  ((equal emacs-major-version 23) (setting-for-emacs23))
;;  (t nil))

(require 'package)

;;インストールするディレクトリを指定
(setq package-user-dir (concat user-emacs-directory "vendor/elpa"))
;;リポジトリにMarmaladeを追加
(add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
;;インストールしたパッケージにロードパスを通してロードする
(package-initialize)

;; (when (< emacs-major-version 24)
;;   ;; Emacs23 では引数が足りないので定義しておく
;;   (defadvice delete-directory (around add-trash (directory &optional recursive trash) activate)
;;      ad-do-it)
;;   ;; Emacs23 に存在しないボタンを定義しておく
;;   ;; /usr/share/emacs/24.2/lisp/help-mode.el.gz
;;   (define-button-type 'help-package
;;     :supertype 'help-xref
;;     'help-function 'describe-package
;;     'help-echo (purecopy "mouse-2, RET: Describe package"))
;;   (define-button-type 'help-package-def
;;     :supertype 'help-xref
;;     'help-function (lambda (file) (dired file))
;;     'help-echo (purecopy "mouse-2, RET: visit package directory"))
;;   )

(require 'init-loader)
(init-loader-load "~/.emacs.d/init")

;====================================
;フレーム位置設定(ウィンドウ）
;====================================
(setq initial-frame-alist
      (append
       '((top . 22)    ; フレームの Y 位置(ピクセル数)
     ;; (left . 45)    ; フレームの X 位置(ピクセル数)
    ;; (width . 164)    ; フレーム幅(文字数)
         (height . 35)   ; フレーム高(文字数)
    ) initial-frame-alist))


;; 文字コード
(set-default-coding-systems 'utf-8-unix)
(prefer-coding-system 'utf-8-unix)


;;; 行末の空白を表示
(setq-default show-trailing-whitespace t)
(set-face-background 'trailing-whitespace nil)
(set-face-underline 'trailing-whitespace "Knobcolor")

;; (require 'auto-save-buffers)
;; (run-with-idle-timer 0.1 t 'auto-save-buffers)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tango-dark)))
 '(php-doc-author (format "your name <%s>" php-doc-mail-address) t)
 '(php-doc-license "The MIT License" t)
 '(php-doc-mail-address "your email address" t)
 '(php-doc-url "your url" t)
 '(phpdoc-author (format "your name <%s>" phpdoc-mail-address) t)
 '(phpdoc-mail-address "your email address" t)
 '(phpdoc-url "your url" t)
 '(safe-local-variable-values (quote ((sh-indent-comment . t) (encoding . utf-8)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diff-added ((t (:foreground "DarkGreen"))))
 '(diff-changed ((t (:foreground "MediumBlue"))))
 '(diff-context ((t (:foreground "Black"))))
 '(diff-file-header ((t (:foreground "Red" :background "White"))))
 '(diff-header ((t (:foreground "Red"))))
 '(diff-hunk-header ((t (:foreground "White" :background "Salmon"))))
 '(diff-index ((t (:foreground "Green"))))
 '(diff-nonexistent ((t (:foreground "DarkBlue"))))
 '(diff-removed ((t (:foreground "DarkMagenta")))))


(defun private-backup-command ()
  (interactive)
  (unless (executable-find "private-backup")
    (error "private-backup command not found. see http://..."))
    (case (call-process-shell-command (executable-find "private-backup") nil nil nil buffer-file-name)
      ((0) (message "OK! private-backup success."))
      (otherwise (message "NG. private-backup fail."))))

(global-set-key (kbd "<f12>") 'private-backup-command)

(put 'narrow-to-region 'disabled nil)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'cl)

;; todo
;; .emacs.d/elisp から削除する elisp
;; key-chord


(setq installing-package-list
  '(
alect-themes
awk-it
auto-complete
;; ac-js2
anzu
apache-mode
coffee-mode
coffee-fof
color-moccur
color-theme
css-mode
css-eldoc
csv-mode
dired+
eieio

fringe-helper
flycheck
flyspell
git-gutter
git-gutter-fringe
gtags
grep-a-lot
haml-mode
handlebars-mode

helm
helm-c-moccur
;; helm-dired-recent-dirs
;; helm-flymake
;; helm-git-grep
;; helm-ls-git
helm-descbinds
;; helm-gtags
;; helm-migemo
;; wgrep-helm
highlight   ;eval-sexp-fu.el で利用
;; indent-guide

key-chord
nginx-mode
python-mode
popwin
pos-tip
rvm
rbenv
revive
rhtml-mode
rspec-mode
rst
ruby-block
rinari
sass-mode
session
;; smartparens
sudo-ext
smarty-mode
textile-mode
undohist
uuid
wgrep
wgrep-ack
wdired
    ;; ここに使っているパッケージを書く。
    google-c-style
    ;; scala-mode
    markdown-mode
    open-junk-file
    rbenv
    rfringe
    rvm
    css-mode
    scss-mode
    smartrep
    haskell-mode
    mustache
    mustache-mode
    mustang-theme
    pandoc-mode
    point-undo
    php-mode
    quickrun
    yaml-mode
    ))


;; (package-install 'dayone)
;; (let ((not-installed (loop for x in installing-package-list
;;                             when (not (package-installed-p x))
;;                             collect x)))
;;   (when not-installed
;;     (package-refresh-contents)
;;     (dolist (pkg not-installed)
;;         (package-install pkg))))

;; el-get で管理しているパッケージ
;; M-x el-get-list-packages
;; インストールしているパッケージの一覧 /home/m/.emacs.d/el-get
;; smartchr
;; tree-mode
;; tsv-mode

;; http://qiita.com/catatsuy/items/c5fa34ead92d496b8a51
;; mac
;; (setq migemo-command "/usr/local/bin/cmigemo")
;; (setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")

;;
;; emacs 起動時は英数モードから始める
;(add-hook 'after-init-hook 'mac-change-language-to-us)
;; minibuffer 内は英数モードにする
;(add-hook 'minibuffer-setup-hook 'mac-change-language-to-us)
;; [migemo]isearch のとき IME を英数モードにする
;(add-hook 'isearch-mode-hook 'mac-change-language-to-us)


;; (when (and (executable-find "cmigemo")
;;            (require 'migemo nil t))
;; (when (require 'migemo nil t)
;;  (setq migemo-options '("-q" "--emacs"))

;;  (setq migemo-user-dictionary nil)
;;  (setq migemo-regex-dictionary nil)
;;  (setq migemo-coding-system 'utf-8-unix)
;;  (load-library "migemo")
;;  (migemo-init)
;;  )


(setq x-select-enable-clipboard nil)
(setq x-select-enable-primary t)
(setq select-active-regions t)
(setq mouse-drag-copy-region t)


(require 'migemo)

;;for mac
(setq migemo-command "/usr/local/bin/cmigemo")
(setq migemo-options '("-q" "--emacs"))
(setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")
(setq migemo-user-dictionary nil)
(setq migemo-coding-system 'utf-8-unix)
(setq migemo-regex-dictionary nil)
(load-library "migemo")
(migemo-init)
