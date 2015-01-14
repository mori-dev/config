;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-
(require 'macro-expand-commands)


(define-key emacs-lisp-mode-map (kbd "C-M-S-e") 'macro-expand-cl-sexp)
;; (define-key emacs-lisp-mode-map (kbd "M-h") 'macro-expand-cl-sexp)
(define-key emacs-lisp-mode-map (kbd "M-e") 'macro-expand-sexp)
(define-key emacs-lisp-mode-map (kbd "C-M-S-b") 'macro-expand-byte-code)

;(pop '("a" "b" "c"))
