;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; gtags

(when (locate-library "gtags")
  (require 'gtags))

(global-set-key "\C-ct" 'gtags-find-tag)     ;関数の定義元へ
;(global-set-key "\C-ct" 'gtags-find-tag-from-here)     ;関数の定義元へ
(global-set-key "\C-cr" 'gtags-find-rtag)    ;関数の参照先へ
;; (global-set-key (kbd "C-c C-r") 'gtags-find-rtag)    ;関数の参照先へ ;C-c C-r はリージョンの評価
(global-set-key "\C-cs" 'gtags-find-symbol)  ;変数の定義元/参照先へ
;(global-set-key "\C-cp" 'gtags-find-pattern) ;正規表現で検索
;(global-set-key "\C-cq" 'gtags-find-file)    ;ファイルにジャンプ
(global-set-key "\C-c1" 'gtags-pop-stack)    ;前のバッファに戻る
(global-set-key (kbd "C-c b") 'gtags-pop-stack)    ;前のバッファに戻る
(global-set-key (kbd "C-c C-b") 'gtags-pop-stack)    ;前のバッファに戻る

;Gtag-Selectバッファをutf-8で表示する
(add-hook 'gtags-select-mode-hook
          '(lambda ()
              (setq buffer-file-coding-system 'utf-8-unix)))

;(add-hook 'c-mode-common-hook '(lambda() (gtags-mode 1)))
;(add-hook 'php-mode-hook '(lambda () (gtags-mode 1)))
