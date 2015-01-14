;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; http://www.bookshelf.jp/soft/meadow_50.html#SEC745

;; M-x moccur : ファイルバッファのみを検索 (正規表現)
;; C-u M-x moccur : すべてのバッファを検索 (正規表現)
;; M-x dmoccur : 指定したディレクトリ下のファイルを検索 (正規表現)
;; C-u M-x dmoccur : あらかじめ指定しておいたディレクトリ下のファイルを検索できる (正規表現)
;; M-x moccur-grep : grep のようにファイルを検索 (正規表現)
;; M-x moccur-grep-find : grep+find のようにファイルを検索 (正規表現)
;; M-x search-buffers : すべてのバッファを全文検索．
;; M-x grep-buffers : 開いているファイルを対象に grep ．
;; バッファリストで M-x Buffer-menu-moccur : m でマークをつけたバッファのみを対象に検索
;; dired で M-x dired-do-moccur : m でマークをつけたファイルのみを対象に検索
;; moccur の結果でs:一致したバッファのみで再検索
;; moccur の結果でu:一つ前の条件で検索
;; qで終了
;; (setq moccur-split-word t)で複数語が可能
;; sで更に絞込み


(require 'color-moccur)
(setq *moccur-buffer-name-exclusion-list*
      '("\.svn" "\.git" ".+TAGS.+" "*Completions*" "GPATH" "*Messages*" "GRTAGS" "GSYMS" "GTAGS"))

(add-to-list 'dmoccur-exclusion-mask "\.git")
(add-to-list 'dmoccur-exclusion-mask "\.svn")
(add-to-list 'dmoccur-exclusion-mask "\.hg")
(add-to-list 'dmoccur-exclusion-mask "GPATH")
(add-to-list 'dmoccur-exclusion-mask "GRTAGS")
(add-to-list 'dmoccur-exclusion-mask "GSYMS")
(add-to-list 'dmoccur-exclusion-mask "GTAGS")




(global-set-key "\C-cm" 'moccur)
;; (global-set-key "\C-cg" 'moccur-grep)
;; (global-set-key "\C-cf" 'moccur-grep-find)
(global-set-key "\C-cB" 'grep-buffers)
;; 複数の検索語や、特定のフェイスのみマッチ等の機能を有効にする
;; 詳細は http://www.bookshelf.jp/soft/meadow_50.html#SEC751
(setq moccur-split-word t)
