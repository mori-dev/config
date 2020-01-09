
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
;; (add-to-list 'load-path "~/.emacs.d/elisp/php")
(add-to-list 'load-path "~/.emacs.d/elisp/sdic")
(add-to-list 'load-path "~/.emacs.d/elisp/yasnippet")
(add-to-list 'load-path "~/.emacs.d/elisp/mylib")
(add-to-list 'load-path "~/.emacs.d/elisp/anything")
(add-to-list 'load-path "~/.emacs.d/elisp/emacs-deferred")

(setq load-path (nreverse load-path))


(require 'package)
;; インストールは x-install-package.el で管理している
;;インストールするディレクトリを指定
(setq package-user-dir (concat user-emacs-directory "vendor/elpa"))
;;リポジトリにMarmaladeを追加
(add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
;;インストールしたパッケージにロードパスを通してロードする
(package-initialize)

(require 'init-loader)
(init-loader-load "~/.emacs.d/init")


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tango-dark)))
 '(migemo-isearch-enable-p nil)
 '(package-selected-packages
   (quote
    (yaml-mode undohist sudo-ext session scss-mode sass-mode ruby-compilation ruby-block rspec-mode rhtml-mode rfringe python-mode prettier-js pos-tip popwin point-undo php-mode pandoc-mode nginx-mode mustache-mode markdown-mode magit let-alist key-chord jump js2-mode init-loader indent-guide highlight-cl highlight hide-lines helm-descbinds helm-c-moccur helm haskell-mode handlebars-mode grep-a-lot go-eldoc go-autocomplete git-timemachine git-gutter-fringe flycheck exec-path-from-shell electric-case dockerfile-mode dired-single dired+ csv-mode css-mode css-eldoc color-moccur anzu)))
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

(require 'exec-path-from-shell)
(let ((envs '("PATH" "GOPATH")))
  (exec-path-from-shell-copy-envs envs))

;; ubuntu 用
(when (not (equal system-type 'darwin))
  (setq x-select-enable-clipboard t)
  (set-fontset-font t
                    'japanese-jisx0208
                    (font-spec :family "Noto Sans Mono CJK JP" :size 28)))
