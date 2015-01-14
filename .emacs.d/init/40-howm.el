;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-


(require 'howm)

;; デフォルトの拡張子を md にする
(setq howm-file-name-format "%Y/%m/%Y-%m-%d-%H%M%S.md")


;; (setq howm-directory "/home/m/Dropbox/howm/")
;; (setq howm-directory "/home/m/Dropbox/howm/")

(setq howm-directory "~/Dropbox/howm/")

;http://ubulog.blogspot.com/2008/10/emacs_16.html
(setq auto-save-file-name-transforms
      `((".*/Dropbox/.*" ,temporary-file-directory t)))

(defun howm-full-path-directory ()
  (expand-file-name howm-directory))
(howm-full-path-directory)

(setq howm-full-path-directory (expand-file-name howm-directory))


;; >>> を廃止
(setq howm-keyword-header "")
;; <<< を廃止
(setq howm-ref-header "")

;; *.md だけ検索する
;; (setq howm-view-grep-option "-Hnr --exclude-dir=_darcs --include=*.howm")
(setq howm-view-grep-option "-Hnr --exclude-dir=_darcs --include=*.md")

;; 検索に grep を使う 高速化 => ubuntu11.04 で一覧が取得できなくなったので nil にした
(setq howm-view-use-grep nil)
;; (setq howm-view-grep-command "c:/cygwin/bin/grep")


;; (setq howm-default-key-table
;;       '(
;;         ;; ("key"  func list-mode-p global-p)
;;         ("r" howm-initialize-buffer)         
;;         ("l" howm-list-recent t t)
;;         ("a" howm-list-all t t)
;;         ("g" howm-list-grep t t)
;;         ("m" howm-list-migemo t t)
;;         ("t" howm-list-todo t t)
;;         ("y" howm-list-schedule t t)
;;         ("c" howm-create t t)
;;         ("," howm-menu t t)
;;         ("d" howm-dup)                       
;;         ("i" howm-insert-keyword)
;;         ("D" howm-insert-date)                       
;;         ("K" howm-keyword-to-kill-ring t t)        
;;         ("n" action-lock-goto-next-link)            
;;         ("p" action-lock-goto-previous-link)        
;;         ("Q" howm-kill-all t t)
;;         ))

;; org-mode memo
;; C-c C-n	次の見出しへ
;; C-c C-p	前の見出しへ
;; C-c C-f	次の同一階層の見出しへ
;; C-c C-b	前の同一階層の見出しへ
;; C-c C-u	ひとつ上の階層の見出しに戻る
;; C-c C-j	その時点でのアウトラインの表示・非表示の状況を維持しながら
;; 別の場所に移動します。
;; 一時的なバッファで文書の構造を表示し、
;; ＜TAB＞を押すことで（その項目の）表示・非表示を切り替えて、
;; 目的の行を探します。
;; そして＜RET＞を押すことでカーソルはオリジナルのバッファの
;; 選択した位置へ移動し、（それ以外の場所の表示・非表示の状況は維持しながら）
;; 移動した場所の見出しは表示された状態になります。

;; howm
;;------------------------------------------------------

(require 'org)
;(add-hook 'org-mode-hook 'howm-mode)
(add-hook 'org-mode-hook
  (lambda() (howm-mode t)))

(add-hook 'markdown-mode-hook
  (lambda() (howm-mode t)))

;; (add-to-list 'auto-mode-alist '("\\.howm$" . org-mode))

;; (expand-file-name file howm-directory)




(add-hook 'markdown-mode-hook
  (lambda() (howm-mode)))



(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))

;;w
(defun my-howm-list-grep-fixed (dir)
  (interactive "DInput Directory:")
  (let ((howm-directory dir))
    (howm-list-grep t)))

;; バッファの内容が空ならファイルも削除
(if (not (memq 'delete-file-if-no-contents after-save-hook))
    (setq after-save-hook
      (cons 'delete-file-if-no-contents after-save-hook)))

(defun delete-file-if-no-contents ()
  (when (and
         (buffer-file-name (current-buffer))
         (= (point-min) (point-max)))
    (when (y-or-n-p "Delete file and kill buffer?")
      (delete-file
       (buffer-file-name (current-buffer)))
      (kill-buffer (current-buffer)))))

;; 日付に曜日を入れて [2007-04-16 Mon] のようにする.
;; howm のロードより前に書くこと.
;; test070413 で少しだけテスト.
;; リマインダなどが正常に機能するか自信ないので, 気をつけてお試しください.
;; (setq howm-date-format '"%Y-%m-%d %a")
;; (setq howm-reminder-regexp-grep-format
;;   "\\[[1-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9][^]]*\\]%s")
;; (setq howm-reminder-regexp-format
;;   "\\(\\[\\([1-2][0-9][0-9][0-9]\\)-\\([0-1][0-9]\\)-\\([0-3][0-9]\\)[^]]*\\]\\)\\(\\(%s\\)\\([0-9]*\\)\\)")
;; (setq howm-reminder-today-format "[%Y-%m-%d") ;; 正規表現でなく固定文字列検索
;; (setq howm-highlight-date-regexp-format "%Y-%m-%d")


;(setq howm-content-from-region t) 

;; (setq auto-mode-alist
;;       (append '(("\\.howm$" . howm-mode)) auto-mode-alist))

;(setq howm-view-title-header "*") ;; ← howm のロードより前に書くこと

;; 保存前にバッファのスキャンをしているため、自動保存をしていると、遅くて使えない。オフになるようにした方がいい。
;; あるいはhowm側をオフにする。
(setq howm-menu-refresh-after-save nil) ;; メニューを自動更新しない 
(setq howm-refresh-after-save nil) ;; 下線を引き直さない 

;; キー割当の重複を避ける (お好みで)
;(setq howm-prefix "\C-z") ;; howm のキーを「C-c , □」から「C-z □」に変更


(defun delete-howm-file ()
  (interactive)
  (let (filename year month pnt)
    (setq pnt (point))
    (beginning-of-line)
    (re-search-forward "\\(\\([0-9]+\\)-\\([0-9]+\\).*howm\\)" nil t)
    (setq filename (buffer-substring (match-beginning 1) (match-end 1)))
    (setq year (buffer-substring (match-beginning 2) (match-end 2)))
    (setq month (buffer-substring (match-beginning 3) (match-end 3)))
    (when (y-or-n-p "Delete this file? ")
      (delete-file (concat howm-directory year "/" month "/" filename))
      (message "Delete!")
      (howm-list-all)
      (goto-char pnt)
      )
    )
  )

(add-hook 'howm-mode-hook
  (lambda()
    (define-key howm-view-summary-mode-map "d" 'delete-howm-file)))


;(require 'howm-mode)
(setq howm-menu-lang 'ja)

;; メモ新規作成時に ">>> 直前バッファ名" というリンクを作らない
(setq howm-template
      (concat howm-view-title-header " %title%cursor\n%date\n\n"))

;; 一覧バッファと内容バッファを左右に並べる 
(setq howm-view-split-horizontally t)

;; 締切!は60日ぐらい先まで見たいのですが、
;; (setq howm-todo-priority-deadline-laziness 60) ;; ! は 60 日前から浮上 

;; [2006-10-25 12:50]ではなく[2006-10-25]にする
;; (setq howm-template-date-format "[%Y-%m-%d]") 




(global-set-key "\C-c,," 'howm-menu)

(mapc (lambda (f)
        (autoload f "howm-mode" "Hitori Otegaru Wiki Modoki" t))
      '(howm-menu howm-list-all howm-list-recent howm-list-grep
                  howm-create howm-keyword-to-kill-ring))

;(add-hook 'howm-mode-on-hook 'auto-fill-mode)
(setq howm-view-grep-parse-line
"^\\(\\([a-zA-Z]:/\\)?[^:]*\\.howm\\):\\([0-9]*\\):\\(.*\\)$")

(setq howm-view-grep-parse-line
"^\\(\\([a-zA-Z]:/\\)?[^:]*\\.md\\):\\([0-9]*\\):\\(.*\\)$")

(setq howm-excluded-file-regexp
      "/\\.#\\|[~#]$\\|\\.bak$\\|/CVS/\\|\\.doc$\\|\\.pdf$\\|\\.ppt$\\|\\.xls$")
                                        ;face の設定
(set-face-foreground 'howm-view-hilit-face "firebrick")
(set-face-foreground 'howm-view-name-face "black")
(set-face-background 'howm-view-name-face "gainsboro")

(set-face-background 'howm-reminder-today-face "black")
(set-face-foreground 'howm-reminder-today-face "cyan")

;「最近のメモ」を表示する個数
(setq howm-menu-recent-num 900)
;(setq howm-list-recent-days 7)

;; ソート順
;; (setq howm-list-normalizer 'howm-view-sort-by-reverse-date)

;; スクラップ機能
;; リージョンで範囲を選択し，C-csとすると howm のメモを作成 ソースや navi2ch や mailなど。
(defun mmemo-howm-scrap (&optional arg)
  (interactive "P")
  (let (category
        memo-text str
        (cbuf (current-buffer))
        (via (cond
              ((string= 'w3m-mode major-mode)
               w3m-current-url
               ))))
    (cond
     (mark-active
      (setq str (buffer-substring (region-beginning) (region-end)))
      (setq category (read-from-minibuffer "input title : "
                                           "スクラップ"))
      (howm-create-file-with-title category nil nil nil "")
      (goto-char (point-max))
      (save-excursion
        (insert str)
        (if via
            (insert (concat "\nvia " via)))
        ))
     (t
      (message "メモを取る範囲をリージョンで選択してください")))))

;; (global-set-key "\C-cs" 'mmemo-howm-scrap)

;; いちいち消すのも面倒なので
;; 内容が 0 ならファイルごと削除する
;; (if (not (memq 'delete-file-if-no-contents after-save-hook))
;;     (setq after-save-hook
;;           (cons 'delete-file-if-no-contents after-save-hook)))
;; (defun delete-file-if-no-contents ()
;;   (when (and
;;          (buffer-file-name (current-buffer))
;;          (string-match "\\.howm" (buffer-file-name (current-buffer)))
;;          (= (point-min) (point-max)))
;;     (delete-file
;;      (buffer-file-name (current-buffer)))))


 ;; メニューを自動更新しない
(setq howm-menu-refresh-after-save nil)
;; 下線を引き直さない
(setq howm-refresh-after-save nil)



(eval-after-load "calendar"
  '(progn
     (define-key calendar-mode-map
       "\C-m" 'my-insert-day)
     (defun my-insert-day ()
       (interactive)
       (let ((day nil)
             (calendar-date-display-form
         '("[" year "-" (format "%02d" (string-to-int month))
           "-" (format "%02d" (string-to-int day)) "]")))
         (setq day (calendar-date-string
                    (calendar-cursor-to-date t)))
         (exit-calendar)
         (insert day)))))


;; M-x calendar しといて M-x howm-from-calendar
;;         → その日付を検索
(defun howm-from-calendar ()
  (interactive)
  (require 'howm-mode)
  (let* ((mdy (calendar-cursor-to-date t))
         (m (car mdy))
         (d (second mdy))
         (y (third mdy))
         (key (format-time-string
               howm-date-format
               (encode-time 0 0 0 d m y))))
    (howm-keyword-search key)))

;;カレンダーの上で d を押すと grep
(add-hook 'initial-calendar-window-hook
          '(lambda ()
             (local-set-key
              "d" 'howm-from-calendar)))

;(setq howm-process-coding-system 'utf-8-unix) 

;; (defun my-howm-decide-major-mode ()
;;   ""
;;   (let ((case-fold-search t))
;;     (save-excursion
;;       (goto-char (point-min))
;;       (when (string-match "\\[php\\]\\[sample\\]" (thing-at-point 'line)) ;正規表現頑張れ
;;         (php-mode) ;; ここは他には (hoge-mode t) というパターンもある
;;       ))))

;; (add-hook 'howm-mode-on-hook (lambda() (my-howm-decide-major-mode)))

;; (setq howm-view-summary-name "*howmS*")
;; (setq howm-view-contents-name "*howmC*") 

;; -*- Coding: utf-8-unix; buffer-read-only: t -*-
;; とかできたのか


;; outline-mode のように階層ごとに色をつけたい - 2ch3:185

;; → ずばり outline-mode と併用しては? (howm は minor-mode です)

;; ;; *.howm を outline-mode に
;; (add-to-list 'auto-mode-alist '("\\.howm$" . outline-mode))

;; "="で始まる行をoutlineの最上位にしたい

;; (add-hook 'howm-mode-hook
;;           (function
;;            (lambda ()
;;              (progn
;;                (setq outline-heading-alist
;;                      '(("=" . 1) ("*" . 2) ("**" . 3)
;;                        ("***" . 4) ("****" . 5)))
;;                (setq outline-regexp
;;                      (concat "[*=]+")
;;                      )))))




;; (add-hook 'howm-mode-hook
;;   '(lambda()
;;    (multi-install-chunk-finder "^>|lisp|$" "^||<$" 'emacs-lisp-mode)))    
