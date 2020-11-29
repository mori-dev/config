(add-to-list 'exec-path (concat (getenv "HOME") "/Dropbox/bin"))
(add-to-list 'exec-path (concat (getenv "HOME") "/bin"))

;; kill-ring に同じ内容の文字列を複数入れない
;; kill-ring-save 等した時にその内容が既に kill-ring にある場合、その文字列が kill-ring の先頭に 1 つにまとめられます
(defadvice kill-new (before ys:no-kill-new-duplicates activate)
  (setq kill-ring (delete (ad-get-arg 0) kill-ring)))

(fset 'yes-or-no-p 'y-or-n-p)      ;"yes or no"を"y or n"にする

(setq inhibit-startup-message t)   ;起動時のメッセージを消す
(global-set-key (kbd "C-x C-b") 'buffer-menu); C-x C-b でバッファリストを開く時にウィンドウを分割しない
(setq-default case-fold-search t)  ;検索に大文字・小文字の区別しない
(blink-cursor-mode -1)            ;カーソルを点滅させない

;; スクリプトを保存するとき()ファイルの先頭に #! が含まれているとき)，自動的に chmod +x を行う
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

(ffap-bindings)                    ; URL を C-x C-f で開ける
;;ffap に奪われるのでここで設定。 変数 ffap-bindings を設定するほうが賢い。
(global-set-key (kbd "C-x C-d") 'dired)


;;開いているファイルが他のソフトによって更新されたときに自動的に再読み込み
(global-auto-revert-mode)

(setq default-tab-width 2)

(tool-bar-mode -1)
(menu-bar-mode nil)

;;タイトルバーに現在のファイル名を表示する
(setq frame-title-format (format "%%f - Emacs@%s" (system-name)))

;; 全角スペースは半角スペースに置換する
(define-key global-map "　" " ")
