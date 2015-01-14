;; ;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-
;; ;; http://note.golden-lucky.net/2010/06/emacs-emacs-22.html に機能追加

;; (make-face 'my-highlight-face)
;; (set-face-foreground 'my-highlight-face "black")
;; (set-face-background 'my-highlight-face "yellow")
;; (setq my-highlight-face 'my-highlight-face)

;; (defun my-keep-highlight-regexp (re)
;;   (interactive "sRegexp: \n")
;;   (setq my-highlight-keyword re)
;;   (my-keep-highlight-set-font-lock my-highlight-keyword))

;; (defun my-keep-highlight-symbole-at-point ()
;;   (interactive)
;;   (setq my-highlight-keyword (or (thing-at-point 'symbol) ""))
;;   (my-keep-highlight-set-font-lock my-highlight-keyword))

;; (defun my-keep-highlight-set-font-lock (re)
;;   (font-lock-add-keywords 'nil (list (list re 0 my-highlight-face t)))
;;   (font-lock-fontify-buffer))
 
;; (defun my-cancel-highlight-regexp ()
;;   (interactive)
;;   (font-lock-remove-keywords 'nil (list (list my-highlight-keyword 0 my-highlight-face t)))
;;   (font-lock-fontify-buffer))


;; (fset 'hl 'my-keep-highlight-regexp)
;; (global-set-key (kbd "M-9") 'my-keep-highlight-symbole-at-point)
;; (global-set-key (kbd "C-M-9") 'my-cancel-highlight-regexp)



;; ;; (defun keep-highlight-regexp (re)
;; ;;   (interactive "sRegexp: \n")
;; ;;   (make-face 'my-highlight-face)
;; ;;   (set-face-foreground 'my-highlight-face "black")
;; ;;   (set-face-background 'my-highlight-face "yellow")
;; ;;   (defvar my-highlight-face 'my-highlight-face)
;; ;;   (setq font-lock-set-defaults nil)
;; ;;   (font-lock-set-defaults)
;; ;;   (font-lock-add-keywords 'nil (list (list re 0 my-highlight-face t)))
;; ;;   (font-lock-fontify-buffer))

;; ;; (defun cancel-highlight-regexp ()
;; ;;   (interactive)
;; ;;  (setq font-lock-set-defaults nil)
;; ;;   (font-lock-set-defaults)
;; ;;   (font-lock-fontify-buffer))

;; ;; (global-set-key "\C-f" 'keep-highlight-regexp)
;; ;; (global-set-key "\C-d" 'cancel-highlight-regexp)