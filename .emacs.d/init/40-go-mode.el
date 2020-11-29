(require 'go-mode)

(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))

(add-hook 'go-mode-hook
  (lambda()
    (define-key go-mode-map "\C-c\C-j" 'godef-jump)
    (define-key go-mode-map "\C-cj" 'godef-jump)
    (define-key go-mode-map "\M-." 'godef-jump)))

(setq gofmt-command "goimports")
(add-hook 'before-save-hook 'gofmt-before-save)

;; https://github.com/golang/lint
;; (add-to-list 'load-path (concat (getenv "GOPATH")  "/src/golang.org/x/lint/misc/emacs/"))
;; ~/go/src/golang.org/x/lint/misc/emacs/golint.el
;; (add-to-list 'load-path (concat (getenv "GOPATH")  "/Users/kazuhiko-mori/go/src/golang.org/x/lint/misc/emacs/"))
;; でエラーになるので
;; ~/.emacs/elisp/go-lint.el にコピーした

(require 'golint)

(require 'go-eldoc)
(add-hook 'go-mode-hook 'go-eldoc-setup)


