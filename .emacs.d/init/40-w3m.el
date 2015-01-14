;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; w3m

 (autoload 'w3m "w3m"
   "Interface for w3m on Emacs." t)
 (autoload 'w3m-find-file "w3m"
   "Find a local file using emacs-w3m." t)
 (autoload 'w3m-search "w3m-search"
   "Search words using emacs-w3m." t)
 (autoload 'w3m-weather "w3m-weather"
   "Display a weather report." t)
 (autoload 'w3m-antenna "w3m-antenna"
   "Report changes of web sites." t)
 (autoload 'w3m-namazu "w3m-namazu"
   "Search files with Namazu." t)
 (autoload 'w3m-namazu "w3m-namazu"
   "Search files with Namazu." t)

;;初期表示
(setq w3m-home-page  "http://www.google.co.jp")

;;リンクに番号を表示する
(autoload 'w3m-link-numbering-mode "w3m-lnum" nil t)
(add-hook 'w3m-mode-hook 'w3m-link-numbering-mode)
 ;; (autoload 'w3m-lnum "w3m-lnum" nil t)

;;クッキーを有効にする
;(setq w3m-use-cookies t)

;;xx文字で折り返す
(setq w3m-fill-column 75)

;; デフォルトで使う検索エンジン
;;M-x w3m-searchで検索
(setq w3m-search-default-engine "google")
