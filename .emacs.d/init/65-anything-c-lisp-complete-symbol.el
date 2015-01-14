;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; http://d.hatena.ne.jp/IMAKADO/20080326/1206613916
;; インターンされているシンボルすべてを対象に正規表現でざくざく検索できる
;;     * どんなhookがあるのか => hook$
;;     * とんなpredicateがあるのか => p$
;;     * map系の関数はどんなのがあるか => ^map
;; など検索目的にも使えます。
;; デフォルトアクションはinsertです。ほかにはdescribeするアクションもあります。


;;; anything-c-lisp-complete-symbol.el の設定
(require 'anything-c-lisp-complete-symbol)
(global-set-key (kbd "C-S-i") 'anything-lisp-complete-symbol)

