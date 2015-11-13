(require 'web-mode)

;; (when (< emacs-major-version 24)
;;   (defalias 'prog-mode 'fundamental-mode))

;; ;;; 適用する拡張子
(add-to-list 'auto-mode-alist '("\\.ect$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.ejs$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?$"     . web-mode))

(setq web-mode-enable-current-element-highlight t)
;; ;;; インデント数
(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-sql-indent-offset 2)
  (setq web-mode-enable-auto-closing nil)
  (setq web-mode-enable-auto-pairing nil)
  (setq web-mode-enable-auto-opening nil)
  (setq web-mode-enable-auto-quoting nil)
  (define-key web-mode-map (kbd "C-;") 'web-mode-comment-or-uncomment)
  ;; 終了タグの自動補完をしない
  (setq web-mode-disable-auto-pairing t))


(add-hook 'web-mode-hook 'my-web-mode-hook)

;; (require 'smartchr)

;; (eval-after-load "web-mode"
;;   '(progn
;;      (define-key web-mode-map (kbd "<") (smartchr '("<" "<%" "<%=" "<%= `!!' %>" "<% `!!' %>" "<<")))
;;      (define-key web-mode-map (kbd ">") (smartchr '(">" "%>" ">>")))
;;      ))

;; (set-face-attribute 'web-mode-html-tag-face nil :foreground "Pink3")
