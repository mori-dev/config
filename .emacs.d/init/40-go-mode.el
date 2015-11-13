(add-hook 'go-mode-hook
  (lambda()
    (define-key go-mode-map "\C-c\C-j" 'godef-jump)
    (define-key go-mode-map "\C-cj" 'godef-jump)))

(setq gofmt-command "goimports")
(add-hook 'before-save-hook 'gofmt-before-save)


(require 'go-autocomplete)
(require 'auto-complete-config)
;; (define-key ac-mode-map (kbd "C-i") 'auto-complete)

(require 'go-eldoc)
(add-hook 'go-mode-hook 'go-eldoc-setup)

(require 'go-direx)
