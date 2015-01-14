;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; http://www11.atwiki.jp/s-irie/pages/18.html


(require 'redo+)
;; アンドゥ時に過去のアンドゥがリドゥされないように設定する
(setq undo-no-redo t)

(define-key global-map [?\C-.] 'redo)


