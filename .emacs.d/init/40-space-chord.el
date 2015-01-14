;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-


(require 'space-chord)
;; (space-chord-define-global "f" 'find-file)
;; (space-chord-define-global "p" (lambda () (interactive) (goto-char (point-min))))
;; (space-chord-define-global "n" (lambda () (interactive) (goto-char (point-max))))
;; (space-chord-define-global "b" 'anything-show-bm-ext)
;; (space-chord-define-global "3" 'elisp-format-region)
(setq space-chord-delay 0.1)


(space-chord-define-global "p" 'anything-project)
