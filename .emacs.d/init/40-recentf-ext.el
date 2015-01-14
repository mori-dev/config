;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

(require 'recentf-ext)
(setq recentf-max-saved-items 700)



(when (require 'recentf nil t)
  (setq recentf-max-saved-items 2000)
  (setq recentf-exclude '(".recentf"))
  (setq recentf-auto-cleanup 1000)
  (setq recentf-auto-save-timer
        (run-with-idle-timer 1000 t 'recentf-save-list))
  (recentf-mode 1))
