;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;カーソル位置を元にもどす
;http://d.hatena.ne.jp/rubikitch/20081230/pointundo

(require 'point-undo)
(define-key global-map [f7] 'point-undo)
(define-key global-map [S-f7] 'point-redo)

