



;; Warning: `mapcar' called for effect; use `mapc' or `dolist' instead を防ぐ
(setq byte-compile-warnings '(free-vars unresolved
                              callargs redefine
                              obsolete noruntime cl-functions
                              interactive-only make-local))

(setq initial-major-mode 'emacs-lisp-mode)

(add-to-list 'load-path "~/.emacs.d/elisp")
(add-to-list 'load-path "~/.emacs.d/init")
(add-to-list 'load-path "~/.emacs.d/elisp/dired-extension")
(add-to-list 'load-path "~/.emacs.d/elisp/howm")
(add-to-list 'load-path "~/.emacs.d/elisp/ruby")
(add-to-list 'load-path "~/.emacs.d/elisp/php")
(add-to-list 'load-path "~/.emacs.d/elisp/sdic")
(add-to-list 'load-path "~/.emacs.d/elisp/yasnippet")
(add-to-list 'load-path "~/.emacs.d/elisp/mylib")
(add-to-list 'load-path "~/.emacs.d/elisp/anything")
(add-to-list 'load-path "~/.emacs.d/elisp/emacs-deferred")

(setq load-path (nreverse load-path))


(require 'package)

;;インストールするディレクトリを指定
(setq package-user-dir (concat user-emacs-directory "vendor/elpa"))
;;リポジトリにMarmaladeを追加
(add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

;;インストールしたパッケージにロードパスを通してロードする
(package-initialize)

(require 'init-loader)
(init-loader-load "~/.emacs.d/init")

;; 文字コード
(set-default-coding-systems 'utf-8-unix)
(prefer-coding-system 'utf-8-unix)


;;; 行末の空白を表示
(setq-default show-trailing-whitespace t)
(set-face-background 'trailing-whitespace nil)
(set-face-underline 'trailing-whitespace "Knobcolor")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tango-dark)))
 ;; '(js2-bounce-indent-p nil t)
 '(migemo-isearch-enable-p nil)
 '(php-doc-author (format "your name <%s>" php-doc-mail-address))
 '(php-doc-license "The MIT License" t)
 '(php-doc-mail-address "your email address" t)
 '(php-doc-url "your url" t)
 '(phpdoc-author (format "your name <%s>" phpdoc-mail-address))
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
 '(diff-removed ((t (:foreground "DarkMagenta"))))
 '(whitespace-empty ((t (:background "gray26" :foreground "firebrick"))))
 '(whitespace-indentation ((t (:background "gray32" :foreground "firebrick"))))
 '(whitespace-space ((((class color) (background dark)) (:background "red" :foreground "white")) (((class color) (background light)) (:background "yellow" :foreground "black")) (t (:inverse-video t))))
 '(whitespace-tab ((t (:background "gray15" :foreground "gray26" :underline t)))))

(set-face-attribute 'whitespace-tab nil
                    :background "gray15"
                    :foreground "gray25"
                    :underline t)

(global-whitespace-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'cl)

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

;; (package-install 'web-mode)
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

(setq x-select-enable-clipboard nil)
(setq x-select-enable-primary t)
(setq select-active-regions t)
(setq mouse-drag-copy-region t)

;; (require 'migemo)

;; ;;for mac
;; (setq migemo-command "/usr/local/bin/cmigemo")
;; (setq migemo-options '("-q" "--emacs"))
;; (setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")
;; (setq migemo-user-dictionary nil)
;; (setq migemo-coding-system 'utf-8-unix)
;; (setq migemo-regex-dictionary nil)
;; (load-library "migemo")
;; (migemo-init)


;; tmp ファイルをつくらないようにする
;; http://masutaka.net/chalow/2014-05-11-1.html
(setq create-lockfiles nil)
(setq auto-save-list-file-prefix nil)
(setq make-backup-files nil)


;; for whitespace-mode
(require 'whitespace)
;; see whitespace.el for more details
(setq whitespace-style '(face tabs tab-mark spaces space-mark))
(setq whitespace-display-mappings
      '((space-mark ?\u3000 [?\u25a1])
        ;; WARNING: the mapping below has a problem.
        ;; When a TAB occupies exactly one column, it will display the
        ;; character ?\xBB at that column followed by a TAB which goes to
        ;; the next TAB column.
        ;; If this is a problem for you, please, comment the line below.
        (tab-mark ?\t [?\xBB ?\t] [?\\ ?\t])))
(setq whitespace-space-regexp "\\(\u3000+\\)")
(set-face-foreground 'whitespace-tab "#444")
(set-face-background 'whitespace-tab 'nil)
(set-face-underline  'whitespace-tab 'nil)
(set-face-foreground 'whitespace-space "#7cfc00")
(set-face-background 'whitespace-space 'nil)
(set-face-bold-p 'whitespace-space t)
(global-whitespace-mode 1)
(global-set-key (kbd "C-x w") 'global-whitespace-mode)

(require 'exec-path-from-shell)
(let ((envs '("PATH" "GOPATH")))
  (exec-path-from-shell-copy-envs envs))

(global-set-key (kbd "C-5") 'kmacro-call-macro)
(global-set-key (kbd "C-]") 'kmacro-start-macro)
(global-set-key (kbd "C-M-]") 'kmacro-end-macro)
