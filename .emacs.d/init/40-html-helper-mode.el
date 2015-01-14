;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; html-helper-mode の設定

;; (add-hook 'html-helper-load-hook '(lambda () (require 'html-font)))
;; (autoload 'html-helper-mode "html-helper-mode" "Yay HTML" t)
;; (setq auto-mode-alist
;;       (append '(("\\.html$" . html-helper-mode)
;;                 ("\\.shtml$" . html-helper-mode)
;;                 ("\\.html$" . html-helper-mode)
;;                 ("\\.shtml$" . html-helper-mode)
;;                 ) auto-mode-alist))

;; (add-hook 'html-helper-mode-hook
;;   (lambda ()
;;     (global-set-key "\M-w" 'tempo-complete-tag)
;;     (define-key html-helper-mode-map (kbd "C-M-f") nil)
;;     ))

(setq auto-mode-alist
      (append '(("\\.html$" . sgml-mode)
                ("\\.shtml$" . html-helper-mode)
                ("\\.html$" . html-helper-mode)
                ("\\.shtml$" . html-helper-mode)
                ) auto-mode-alist))
