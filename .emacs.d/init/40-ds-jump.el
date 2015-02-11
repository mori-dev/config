;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-
(require 'ds-jump)

(add-hook
 'emacs-lisp-mode-hook
  (lambda()
    (define-key emacs-lisp-mode-map (kbd "C-c j") 'ds-jump-symbol-at-point)
    (define-key emacs-lisp-mode-map (kbd "C-c C-j") 'ds-jump-symbol-at-point)
    (define-key emacs-lisp-mode-map (kbd "C-c b") 'ds-jump-back)
    (define-key emacs-lisp-mode-map (kbd "C-c C-b") 'ds-jump-back)))

(add-hook
 'lisp-interaction-mode-hook
  (lambda()
    (define-key lisp-interaction-mode-map (kbd "C-c j") 'ds-jump-symbol-at-point)
    (define-key lisp-interaction-mode-map (kbd "C-c C-j") 'ds-jump-symbol-at-point)
    (define-key lisp-interaction-mode-map (kbd "C-c b") 'ds-jump-back)
    (define-key lisp-interaction-mode-map (kbd "C-c C-b") 'ds-jump-back)))
