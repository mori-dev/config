;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; C-r        isearch-backward
;; C-s        isearch-forward
;; C-M-r      isearch-backward-regexp
;; C-M-s      isearch-forward-regexp
;; M-s w      isearch-forward-word

(fset 'di 'diff-mode)
(fset 'di 'diff-mode)
(fset 'd  'delete-trailing-whitespace)

(fset 'mf 'my-get-filename)
(fset 'k 'key-chord-mode)

(fset 'sf 'search-forward)
(fset 'sfr 'search-forward-regexp)
(fset 'sb 'search-backward)
(fset 'sbr 'search-backward-regexp)

(fset 'wsf 'word-search-forward)
(fset 'wsb 'word-search-backward)
(fset 'rsf 're-search-forward)
(fset 'reb 're-search-backward)
;; 置換
(fset 'qr 'query-replace)         ;対話的置換
(fset 'qrr 'query-replace-regexp) ;正規表現を利用して対話的置換
(fset 'rs 'replace-string)        ;一括置換
(fset 'rr 'replace-regexp)        ;正規表現を利用して一括置換
(fset 'fl 'flush-lines)           ;指定した正規表現にマッチする、ポイント以降の行をすべて削除
(fset 'kl 'keep-lines-read-args)  ;指定した正規表現にマッチしない、ポイント以降の行をすべて削除


(fset 's 'slime)
;;(fset 'mr 'anything-mark-ring)
(fset 'e 'emacs-lisp-mode)
(fset 'tt 'toggle-truncate-lines)
(fset 'j 'js2-mode)
(fset 'h 'html-helper-mode)
(fset 'p 'php-mode)




(fset 'my-xml-pp 'sgml-pretty-print)

(fset 'dtw 'delete-trailing-whitespace) ;行末の半角スペースを取り除く;

(fset 'tak 'text-adjust-kutouten); 句読点を「, 」「. 」に置き換える.
(fset 'tas 'text-adjust-space)   ; 全角文字と半角文字の間に空白を入れる.
(fset 'ta 'text-adjust)
(fset 'dtw 'delete-trailing-whitespace)
