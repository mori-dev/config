;; (setq installing-package-list
;;   '(
;; alect-themes
;; awk-it
;; auto-complete
;; ;; ac-js2
;; anzu
;; apache-mode
;; coffee-mode
;; coffee-fof
;; color-moccur
;; color-theme
;; css-mode
;; css-eldoc
;; csv-mode
;; dired+
;; eieio

;; fringe-helper
;; flycheck
;; flyspell
;; git-gutter
;; git-gutter-fringe
;; gtags
;; grep-a-lot
;; haml-mode
;; handlebars-mode

;; helm
;; helm-c-moccur
;; ;; helm-dired-recent-dirs
;; ;; helm-flymake
;; ;; helm-git-grep
;; ;; helm-ls-git
;; helm-descbinds
;; ;; helm-gtags
;; ;; helm-migemo
;; ;; wgrep-helm
;; highlight   ;eval-sexp-fu.el で利用
;; ;; indent-guide

;; key-chord
;; nginx-mode
;; python-mode
;; popwin
;; pos-tip
;; rvm
;; rbenv
;; revive
;; rhtml-mode
;; rspec-mode
;; rst
;; ruby-block
;; rinari
;; sass-mode
;; session
;; ;; smartparens
;; sudo-ext
;; smarty-mode
;; textile-mode
;; undohist
;; uuid
;; wgrep
;; wgrep-ack
;; wdired
;;     ;; ここに使っているパッケージを書く。
;;     google-c-style
;;     ;; scala-mode
;;     markdown-mode
;;     open-junk-file
;;     rbenv
;;     rfringe
;;     rvm
;;     css-mode
;;     scss-mode
;;     smartrep
;;     haskell-mode
;;     mustache
;;     mustache-mode
;;     mustang-theme
;;     pandoc-mode
;;     point-undo
;;     php-mode
;;     quickrun
;;     yaml-mode
;;     ))

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
