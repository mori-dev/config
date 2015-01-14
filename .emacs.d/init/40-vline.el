;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

(require 'vline)
;(vline-global-mode)

;; (add-hook 'emacs-lisp-mode-hook 'vline-mode)
;; (add-hook 'lisp-mode-hook       'vline-mode)
;; (add-hook 'perl-mode-hook       'vline-mode)
;; (add-hook 'sh-mode-hook         'vline-mode)
;; (add-hook 'php-mode-hook        'vline1)
;; (add-hook 'yaml-mode-hook       'vline-mode)
;; (add-hook 'php-mode-hook        'vline1)

;;memo
(set-face-background 'vline "gray12")
(global-set-key [f6] 'vline-mode)


;; フェイスがグローバルのためうまくいかない
;; (add-hook 'yaml-mode-hook '(lambda () (set-face-background 'vline "red")))
;; (defface vline1
;;   '((t (:background "blue")))
;;   "*A default face for vertical line highlighting."
;;   :group 'vline)
;; (defface vline2
;;   '((t (:background "red")))
;;   "*A default face for vertical line highlighting."
;;   :group 'vline)

;; (defun vline2 ()
;;   ""
;;   (vline-mode)
;;   (setq vline-face 'vline2))

(defun vline1 ()
  ""
  (interactive)
  (vline-mode)
  (setq vline-face 'vline1))

