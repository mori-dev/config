;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; ;; 優先させる設定
(tool-bar-mode -1)

;;行末のスペースを目立たせる。
(setq show-trailing-whitespace t)
;;タイトルバーに現在のファイル名を表示する
(setq frame-title-format (format "%%f - Emacs@%s" (system-name)))
;;メニューバーの表示
(menu-bar-mode nil)
;カレント行の色を変える
(global-hl-line-mode 1)
(put 'set-goal-column 'disabled nil)


;; ファイル名で探す
(defalias 'find-by-file-name 'find-name-dired)

;; *Help* バッファを同一ウィンドウで開く
(add-to-list 'same-window-buffer-names "*Help*")

;;http://d.hatena.ne.jp/sonota88/20110224/1298557375
(defun count-lines-and-chars ()
  (if mark-active
      (format "%d lines,%d chars "
              (count-lines (region-beginning) (region-end))
              (- (region-end) (region-beginning)))
      ;;(count-lines-region (region-beginning) (region-end)) ;; これだとエコーエリアがチラつく
    ""))

(add-to-list 'default-mode-line-format
             '(:eval (count-lines-and-chars)))


(defadvice save-buffers-kill-terminal (before my-save-buffers-kill-terminal activate)
  (when (process-list)
    (dolist (p (process-list))
      (set-process-query-on-exit-flag p nil))))



;; 全角スペースとタブを目立たせる
(setq whitespace-style
      '(tabs tab-mark spaces space-mark))
(setq whitespace-space-regexp "\\(\x3000+\\)")
(setq whitespace-display-mappings
      '((space-mark ?\x3000 [?\□])
        (tab-mark   ?\t   [?\xBB ?\t])
        ))
(require 'whitespace)
(global-whitespace-mode 1)
(set-face-foreground 'whitespace-space "LightSlateGray")
(set-face-background 'whitespace-space "DarkSlateGray")
(set-face-foreground 'whitespace-tab "LightSlateGray")
(set-face-background 'whitespace-tab "DarkSlateGray")

;; C-x C-x でリージョンを目立たせない
;; (defadvice exchange-point-and-mark (after my-exchange-point-and-mark activate)
;;   (unless (interactive-p)
;;     (if (and (transient-mark-mode mark-active)
;;              (keyboard-quit)))))

;; sub-processを立ち上げる場合の検索パス
;; start-process などで利用
(add-to-list 'exec-path (concat (getenv "HOME") "/Dropbox/bin"))
(add-to-list 'exec-path (concat (getenv "HOME") "/bin"))
;;なお shell-file-name は利用しているシェル

(defadvice save-buffers-kill-terminal (before my-save-buffers-kill-terminal activate)
  (when (process-list)
    (dolist (p (process-list))
      (set-process-query-on-exit-flag p nil))))


;;ウィンドウサイズ
(setq initial-frame-alist
      (append
       '((top    . 22)    ; フレームの Y 位置(ピクセル数)
         (left   . 45)    ; フレームの X 位置(ピクセル数)
         (width  . 130)    ; フレーム幅(文字数)
         (height . 40)   ; フレーム高(文字数)) initial-frame-alist))
         )))



;;paren.el
;;括弧
(show-paren-mode t)
(setq show-paren-overlay nil)


(setq show-paren-style 'expression) ; カッコ全体をハイライト
;(setq show-paren-style 'parenthesis) ;; 対応括弧のみをハイライト (デフォルト)
;(setq show-paren-style 'mixed)       ;; 対応括弧が画面外の場合、その間をハイライト

;; show-paren-mode (括弧対応の強調)の背景色
(set-face-background 'show-paren-match-face "Orangered4")
(set-face-background 'show-paren-mismatch-face  "tomato")
;(set-face-background 'show-paren-match-face "plum2")

;; M-: で標準の括弧対応機能が表示されてしまうので消しておく
;(setq blink-matching-paren nil)
(setq parse-sexp-ignore-comments t)  ; コメント内のカッコは無視。

;(set-face-background 'show-paren-match-face "#aaaaaa")
;(set-face-background 'show-paren-match-face "red4")
;(set-face-attribute 'show-paren-match-face nil
;        :weight 'bold :underline nil :overline nil :slant 'normal)
;(set-face-foreground 'show-paren-mismatch-face "red")
;(set-face-attribute 'show-paren-mismatch-face nil
;                    :weight 'bold :underline t :overline nil :slant 'normal)

;;;; 文字コード
(set-language-environment "Japanese")

;;開く場合に優先する文字コード
(prefer-coding-system 'utf-8-unix)
;;デフォルトで使用する文字コード
(set-default-coding-systems 'utf-8)
;(setq default-buffer-file-coding-system 'utf-8)
;;ターミナルの文字コード
(set-terminal-coding-system 'utf-8)
;;ファイル名の文字コード
(setq file-name-coding-system 'utf-8)

;;キーボードから入力される文字コード
;;(set-keyboard-coding-system 'utf-8)
;; (modify-coding-system-alist 'file "\\.php\\'" 'utf-8)
;; (modify-coding-system-alist 'file "\\.ini\\'" 'utf-8)
;; (modify-coding-system-alist 'file "\\.tpl\\'" 'utf-8)
;; (modify-coding-system-alist 'file "\\.inc\\'" 'utf-8)

;;開く場合に優先する文字コード
(prefer-coding-system 'utf-8-unix)

;;デフォルトで使用する文字コード
(set-default-coding-systems 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

;; (add-hook 'csv-mode-hook
;;           (lambda()
;;             (setq default-buffer-file-coding-system 'sjis-win)))

;;ターミナルの文字コード
(set-terminal-coding-system 'utf-8)
;;ファイル名の文字コード
;(setq file-name-coding-system 'utf-8)

;;キーボードから入力される文字コード
(set-keyboard-coding-system 'utf-8)

;; UTF-8 ではないのに <meta ....  charset=UTF-8" /> と書いてあるファイルの文字化け対策。
(setq auto-coding-functions nil)

;;;; タブ幅の設定
;デフォルトは 8
;; ;;タブ幅を 4 に設定
;; (setq-default tab-width 4)
;; ;;タブ幅の倍数を設定
;; (setq tab-stop-list
;;   '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
;;タブではなくスペースを使う
(setq-default indent-tabs-mode nil)
(setq indent-line-function 'indent-relative-maybe)

;;;; 検索・置換

(setq search-highlight t) ; 検索時にヒットした文字をハイライト
(setq query-replace-highlight t) ; 置換時にヒットした文字をハイライト

;; fill-columnの値で自動改行させない
(setq text-mode-hook 'turn-off-auto-fill)
(setq howm-mode-hook 'turn-off-auto-fill)



;;;; 行番号 カラム番号

(line-number-mode 1)
(column-number-mode 1)

;;;; M-gで行移動
;(line-number-mode t)
(global-set-key "\M-g" 'goto-line)

;;;; スクロール設定
;;http://exlight.net/devel/emacs/scroll/index.html
;; (setq scroll-conservatively 1)
;; (setq scroll-margin 0)
;; (setq scroll-step 1)

;; http://www.bookshelf.jp/soft/meadow_31.html#SEC429
(defun sane-next-line (arg)
  "Goto next line by ARG steps with scrolling sanely if needed."
  (interactive "p")
  ;;(let ((newpt (save-excursion (line-move arg) (point))))
  (let ((newpt (save-excursion (next-line arg) (point))))
    (while (null (pos-visible-in-window-p newpt))
      (if (< arg 0) (scroll-down 1) (scroll-up 1)))
    (goto-char newpt)
    (setq this-command 'next-line)
    ()))

(defun sane-previous-line (arg)
  "Goto previous line by ARG steps with scrolling back sanely if needed."
  (interactive "p")
  (sane-next-line (- arg))
  (setq this-command 'previous-line)
  ())

(defun sane-newline (arg)
  "Put newline\(s\) by ARG with scrolling sanely if needed."
  (interactive "p")
  (let ((newpt (save-excursion (newline arg) (indent-according-to-mode) (point))))
    (while (null (pos-visible-in-window-p newpt)) (scroll-up 1))
    (goto-char newpt)
    (setq this-command 'newline)
    ()))

;(global-set-key [up] 'sane-previous-line)
;(global-set-key [down] 'sane-next-line)
;(global-set-key "\C-m" 'sane-newline)
;(define-key global-map "\C-n" 'sane-next-line)
;(define-key global-map "\C-p" 'sane-previous-line)

;;;; ファンクションキーを活用

;;(global-set-key [f1] 'eval-current-buffer)
;;(global-set-key [f2] 'lisp-complete-symbol)
;; (global-set-key [f6] 'eval-expression)
;; (global-set-key [f8] 'other-frame)
;; (global-set-key [f9] 'other-window)
;; (global-set-key [f10] 'enlarge-window-horizontally)
;; (global-set-key [f11] 'enlarge-window)
;; (global-set-key [f12] 'delete-window)

;;;; フレーム操作のショートカットC-x 5 2

;; (global-set-key "\M-2" 'make-frame)
;(global-set-key "\M-0" 'delete-frame)

;;; マニュアルの文字化け対策
;(defadvice man (around man-pages-ja activate)
;  (let ((locale-coding-system 'japanese-iso-8bit))
;    ad-do-it))


;;;; Cx-k で yes-no 確認を省略する。バッファを元に戻す。
;やりとりを省略してバッファを消去
;; (global-set-key "\C-xk" '(lambda() (interactive)(kill-buffer (buffer-name))))
;; (global-set-key "\C-x/" 'find-killed-file)

;; (defvar killed-file-name nil)
;; (add-hook 'kill-buffer-hook
;;       (lambda ()
;;         (when (buffer-file-name)
;;           (setq killed-file-name (expand-file-name (buffer-file-name))))))
;; (defun find-killed-file ()
;;   (interactive)
;;   (when killed-file-name
;;     (find-file killed-file-name)
;;     (setq killed-file-name nil)))

(require 'cl)

(defvar my-killed-file-name-list nil)

(defun my-push-killed-file-name-list ()
  (when (buffer-file-name)
    (push (expand-file-name (buffer-file-name)) my-killed-file-name-list)))

(defun my-pop-killed-file-name-list ()
  (interactive)
  (unless (null my-killed-file-name-list)
    (find-file (pop my-killed-file-name-list))))

(add-hook 'kill-buffer-hook 'my-push-killed-file-name-list)

(defun my-kill-buffer ()
  (interactive)
  (kill-buffer (buffer-name)))


(global-set-key "\C-xk" 'my-kill-buffer)
(global-set-key "\C-x/" 'my-pop-killed-file-name-list)



;; 大文字小文字の区別をしない
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

;;;; shell-modeで上下でヒストリ補完
;; C-p/C-nでヒストリを辿る (デフォルトでもM-p, M-nで出来る)
(add-hook 'shell-mode-hook
   (function (lambda ()
      (define-key shell-mode-map [up] 'comint-previous-input)
      (define-key shell-mode-map [down] 'comint-next-input)
      (define-key shell-mode-map "\C-p" 'comint-previous-input)
      (define-key shell-mode-map "\C-n" 'comint-next-input))))


;; kill-ring に同じ内容の文字列を複数入れない
;; kill-ring-save 等した時にその内容が既に kill-ring にある場合、その文字列が kill-ring の先頭に 1 つにまとめられます
(defadvice kill-new (before ys:no-kill-new-duplicates activate)
  (setq kill-ring (delete (ad-get-arg 0) kill-ring)))

;;C-gを押したときに現在の入力がヒストリーに記録されるようになる。間違ってC-gを押してしまった場合は、再び同じコマンドを起動してM-pで前の入力を呼び戻せる
(defadvice abort-recursive-edit (before minibuffer-save activate)
  (when (eq (selected-window) (active-minibuffer-window))
    (add-to-history minibuffer-history-variable (minibuffer-contents))))

;; skeleton での minibuffer 入力時に C-h を help にしない
(defadvice skeleton-read (around unbind-c-h activate compile)
  (let ((help-char ?\M-?))
    ad-do-it))

;undo回数を10倍に変更
;; (setq undo-limit 100000)
;; (setq undo-strong-limit 130000)

;; 新規作成したファイルを未編集でも保存できるようにする
;; http://stackoverflow.com/questions/2592095/how-do-i-create-an-empty-file-in-emacs
(add-hook 'find-file-hooks 'assume-new-is-modified)
(defun assume-new-is-modified ()
  (when (not (file-exists-p (buffer-file-name)))
    (set-buffer-modified-p t)))


;; 連続する文末の空行を削除
(add-hook 'before-save-hook
          (lambda ()
            (save-excursion
              (goto-char (point-max))
              (delete-blank-lines))))


;;;; Misc
(defalias 'del 'delete-trailing-whitespace)
(defalias 'd 'delete-trailing-whitespace)
(defalias 'l 'magit-log)


(auto-compression-mode t) ; gzファイルも編集できるようにする
(setq-default show-trailing-whitespace t) ;行末の空白を表示
(setq eval-expression-print-length nil)  ; evalした結果を全部表示
(setq-default line-spacing 0.1) ;; 行間設定 整数で指定するとピクセル数で、少数で指定すると行の高さに対して相対値で設定される
(setq show-trailing-whitespace t) ;;行末のスペースを目立たせる。
(global-font-lock-mode t)          ;.wlなどの1行目を解釈して色をつける
(setq inhibit-startup-message t)   ;起動時のメッセージを消す
(auto-compression-mode t)          ;圧縮されたファイルも編集＆日本語infoの文字化け防止
(fset 'yes-or-no-p 'y-or-n-p)      ;"yes or no"を"y or n"にする
(setq browse-url-browser-function 'browse-url-firefox) ;デフォルトのブラウザ設定
(auto-image-file-mode)             ;画像を表示
;;(pc-selection-mode)                ; shiftと→でリージョン選択など、MS-Windowsライクなキーバインドの設定
(global-set-key (kbd "C-x C-b") 'buffer-menu); C-x C-b でバッファリストを開く時にウィンドウを分割しない
(setq-default case-fold-search t)  ;検索に大文字・小文字の区別しない
;;javascript-generic-mode が起動してしまうのでコメント化
;(require 'generic-x)              ; generic-mode ini,rcファイルなどの設定ファイル用
;; (setq default-major-mode 'emacs-lisp-mode);C-x b で存在しないバッファを開き、elispを学ぶ
;(add-to-list 'auto-mode-alist (cons "\\.txt\\'" 'outline-mode));.txtファイルはoutline-mode で開く
(setq next-line-add-newlines nil)  ; カーソルキーで新しい行を作る
;(global-set-key "\C-x\C-i" 'indent-region);選択部分を一気にインデント
(transient-mark-mode 1)            ; リージョンを色付きにする

(blink-cursor-mode -1)            ;カーソルを点滅させない
(setq resize-mini-windows t)       ; 必要に応じてミニバッファサイズを変更
(delete-selection-mode 1)          ; BS で選択範囲を消す
;; スクリプトを保存するとき()ファイルの先頭に #! が含まれているとき)，自動的に chmod +x を行う
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)
(setq ring-bell-function 'ignore)  ;ビープ音と画面フラッシュを抑制
(setq x-select-enable-clipboard t) ; kill-ringとクリップボードを同一に扱う
(setq initial-scratch-message nil) ;スクラッチバッファのメッセージを表示しない。
(ffap-bindings)                    ; URL を C-x C-f で開ける
;;ffap に奪われるのでここで設定。 変数 ffap-bindings を設定するほうが賢い。
(global-set-key (kbd "C-x C-d") 'dired)

(setq minibuffer-message-timeout 10) ;
(show-paren-mode 1) ;対応する括弧を光らせる

;; ツールバー(アイコン)の表示
(tool-bar-mode -1)
;; メニューバーの表示
(menu-bar-mode -1)

;カレント行の色を変える
(global-hl-line-mode 1)
;(set-face-background 'hl-line " #303030")

;;開いているファイルが他のソフトによって更新されたときに自動的に再読み込み
(global-auto-revert-mode)
