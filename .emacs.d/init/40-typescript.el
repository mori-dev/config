;;;;

(require 'typescript)
(require 'tide)

(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))

(setq typescript-indent-level 2)

;; https://github.com/ananthakumaran/tide/issues/114#issuecomment-427169698
;; (setq tide-tsserver-executable "/Users/kazuhiko-mori/.nodenv/shims/tsserver")
(setq tide-tsserver-executable nil)
(setq tide-node-executable "/Users/kazuhiko-mori/.nodenv/shims/node")

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  ;; (flycheck-mode nil)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)
;; (add-hook 'before-save-hook 'tide-format-before-save)
(add-hook 'typescript-mode-hook #'setup-tide-mode)

(setq tide-format-options
      '(:insertSpaceAfterFunctionKeywordForAnonymousFunctions t
        :placeOpenBraceOnNewLineForFunctions nil
        :indentSize 2,
        :tabSize 2))

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
;; enable typescript-tslint checker
(flycheck-add-mode 'typescript-tslint 'web-mode)
