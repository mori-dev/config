;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

; カーソル移動設定

;カーソル移動を論理行ではなく、物理行（見たまま）単位で移動する
(require 'physical-line)
(setq-default physical-line-mode t)
;; dired-mode は論理行移動のままにする
(setq physical-line-ignoring-mode-list '(dired-mode))