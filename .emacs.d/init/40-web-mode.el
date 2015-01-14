;; (require 'web-mode)

;; (when (< emacs-major-version 24)
;;   (defalias 'prog-mode 'fundamental-mode))

;; ;;; 適用する拡張子
;; (add-to-list 'auto-mode-alist '("\\.erb$"       . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.html?$"     . web-mode))


;; ;;; インデント数
;; (defun my-web-mode-hook ()
;;   "Hooks for Web mode."
;;   (setq web-mode-html-offset   2)
;;   (setq web-mode-css-offset    2)
;;   (setq web-mode-script-offset 2)
;;   (setq web-mode-php-offset    2)
;;   (setq web-mode-java-offset   2)
;;   (setq web-mode-asp-offset    2))

;; (add-hook 'web-mode-hook 'my-web-mode-hook)

;; (require 'smartchr)

;; (eval-after-load "web-mode"
;;   '(progn
;;      (define-key web-mode-map (kbd "<") (smartchr '("<" "<%" "<%=" "<%= `!!' %>" "<% `!!' %>" "<<")))
;;      (define-key web-mode-map (kbd ">") (smartchr '(">" "%>" ">>")))
;;      ))

;; (set-face-attribute 'web-mode-html-tag-face nil :foreground "Pink3")
