;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

(defun my-git-project-p ()
  (string=
    (shell-command-to-string "git rev-parse --is-inside-work-tree")
   "true\n"))

(defun open-github-from-current ()
  (interactive)
  (cond ((and (my-git-project-p) (use-region-p))
         (shell-command
          (format "~/Dropbox/bin/open-github-from-file %s %d %d"
                  (file-name-nondirectory (buffer-file-name))
                  (line-number-at-pos (region-beginning))
                  (line-number-at-pos (region-end)))))
        ((git-project-p)
         (shell-command
          (format "~/Dropbox/bin/open-github-from-file %s %d"
                  (file-name-nondirectory (buffer-file-name))
                  (line-number-at-pos))))))
(defalias 'github-open-from-current 'open-github-from-current)


(defun my:sort-region (begin end)
  (interactive "r")
  (shell-command-on-region begin end "sort" nil t)
  (message "Sorted!"))


;; ファイルのあるディレクトリを起点に Nautilus を開く
;; kiwanamiさん作
(defun exec-filemanager ()
  (interactive)
  (call-process "nautilus" nil nil nil "--no-desktop" "-n"
                (or (file-name-directory buffer-file-name)
                    default-directory)))
(fset 'nau 'exec-filemanager)

;; http://qiita.com/items/2620874c802db60c99f9
(defun dired-open-nautilus ()
  (interactive)
  (call-process "nautilus" nil 0 nil (dired-current-directory)))
(defalias 'naud 'dired-open-nautilus)
(define-key dired-mode-map "e" 'dired-open-nautilus)



(defun my-downcase-region-or-word ()
  (interactive)
  (if (region-active-p)
      (downcase-region (region-beginning) (region-end))
    (downcase-word 1)))

(global-set-key (kbd "M-l") 'my-downcase-region-or-word)

(defun my-kill-backward-up-list (&optional arg)
  "Kill the form containing the current sexp, leaving the sexp itself.
A prefix argument ARG causes the relevant number of surrounding
forms to be removed."
  (interactive "*p")
  (search-backward "(")
  (let ((current-sexp (thing-at-point 'sexp)))
    (if current-sexp
    (save-excursion
      (backward-up-list arg)
      (kill-sexp)
      (insert current-sexp))
    (error "Not at a sexp"))))

;(global-set-key (kbd "C-M-9") 'my-kill-backward-up-list)

 (defun zenbu-f5 ()
   (interactive)
   (mapcar (lambda (buf)
             (ignore-errors
               (with-current-buffer buf
                 (revert-buffer nil t))))
           (mapcar 'buffer-name (buffer-list)))
   (message "終わった"))



(defun my-insert-super-pre-notation (lang)
  (interactive "slang:")
  (when (region-active-p)
    (save-excursion
      (save-restriction
        (narrow-to-region (region-beginning) (region-end))
        (goto-char (region-beginning))
        (insert (concat ">|" lang "|\n"))
        (goto-char (point-max))
        (insert "||<")))
    (forward-line 1)))

(eval-after-load "key-chord"
  '(key-chord-define-global "PP" 'my-insert-super-pre-notation))

;; todo
(defun meld-buffers (buffer-A buffer-B)
  "Run Meld on a pair of buffers, BUFFER-A and BUFFER-B."
  (interactive
   (list (read-buffer "Buffer A to compare: ")
         (read-buffer "Buffer B to compare: ")))
  ;; (unless (executable-find "meld")
  ;;   (error "meld not found"))
  (setq buffer-A (buffer-file-name (get-buffer buffer-A)))
  (setq buffer-B (buffer-file-name (get-buffer buffer-B)))
  (start-process-shell-command  "/usr/bin/opendiff" "*meld-tmp*" (format "/usr/bin/opendiff %s %s" buffer-A buffer-B)))
  ;; (start-process-shell-command  "meld" "*meld-tmp*" (format "meld %s %s" buffer-A buffer-B)))



(defalias 'meld 'meld-buffers)

(defun my-fill-whole-buffer ()
  (interactive)
  (save-excursion
    (mark-whole-buffer)
    (let ((fill-column 70))
      (fill-region (region-beginning) (region-end)))))

;; リージョンの行頭のスペースを削除
(defun my-delete-bol-space (from to)
  (interactive "r")
  (save-restriction
    (narrow-to-region from to)
    (goto-char (point-min))
    (while (not (eobp))
      (delete-horizontal-space)
      (next-line)
      (beginning-of-line))))

(defsubst js2-alpha-p (c)
  ;; Use 'Z' < 'a'
  (if (<= c ?Z)
      (<= ?A c)
    (and (<= ?a c)
         (<= c ?z))))

(defsubst js2-digit-p (c)
  (and (<= ?0 c) (<= c ?9)))

(defsubst js2-js-space-p (c)
  (if (<= c 127)
      (memq c '(#x20 #x9 #xC #xB))
    (or
     (eq c #xA0)
     ;; TODO:  change this nil to check for Unicode space character
     nil)))




(defun my-half-scroll-up ()
  (interactive)
  (scroll-up (/ (window-height) 2))
)
(defun my-half-scroll-down ()
  (interactive)
  (scroll-down (/ (window-height) 2))
)


;; (defun php-acrobatic-indent-taisaku ()
;;   (interactive)
;;   (if (eq last-command this-command)
;;         (indent-relative)
;;     (progn
;;         (delete-horizontal-space)
;;         (indent-relative))))

(defun php-acrobatic-indent-taisaku ()
  (interactive)
  (when (not (eq last-command this-command))
        (delete-horizontal-space))
      (indent-relative))

;(global-set-key (kbd "M-h") 'php-acrobatic-indent-taisaku)


(defun insert-line-number (beg end &optional start-line)
  "Insert line numbers into buffer."
  (interactive "r")
  (save-excursion
    (let ((max (count-lines beg end))
          (line (or start-line 1))
          (counter 1))
      (goto-char beg)
      (while (<= counter max)
        (insert (format "%0d " line))
        (beginning-of-line 2)
        (incf line)
        (incf counter)))))



(defun my-get-filename ()
  (interactive)
  (kill-new
    (buffer-file-name)))
;    (buffer-name (window-buffer))))
;    (expand-file-name (buffer-name (window-buffer)))))

(defun my-eval-last-sexp ()
  (interactive)
  (if (thing-at-point-looking-at "\(")
    (progn
      (save-excursion
        (forward-list)
        (eval-last-sexp nil)))
    (eval-last-sexp nil)))

(global-set-key (kbd "C-x C-e") 'my-eval-last-sexp)


;; 現在開いている html をブラウザで開く
(defun o ()
  (interactive)
  (browse-url (concat "file://" (buffer-file-name))))
;; (defun o ()
;;   (interactive)
;;   (if (equal "html"(file-name-extension (buffer-file-name)))
;;       (browse-url (concat "file://" (buffer-file-name)))
;;     (message "html ファイルではない")))


(defun my-transform-LCC-underscore (start end) 
  "" 
  (interactive "r") 
  (labels 
      ((LCC-underscore (start end s1 s2) 
                       (save-excursion 
                         (replace-regexp
                          s1
                          (query-replace-compile-replacement s2 t)
                          nil
                          (car (bounds-of-thing-at-point 'symbol)) 
                          (cdr (bounds-of-thing-at-point 'symbol)))))
       (strstr-at-point (s) 
                        (save-excursion 
                          (forward-symbol -1) 
                          (if (search-forward-regexp s (cdr (bounds-of-thing-at-point 'symbol)) t) 
                              t
                            nil))))
    (cond ((strstr-at-point "_") 
           (LCC-underscore start end "_\\([a-z]\\)" "\\,(upcase \\1)"))
          ((strstr-at-point "[a-z]+\\([A-Z]\\)") 
           (LCC-underscore start end "\\([A-Z]\\)" "_\\,(downcase \\1)")))))

(global-set-key (kbd "M-8") 'my-transform-LCC-underscore)


(defun my-kill-line()
  "C-u C-k でキルリングに入れない"
  (interactive)
  (if current-prefix-arg
      (delete-region (point) 
                     (save-excursion (end-of-line) (point)))
    (kill-line)))

(defun my-kill-or-delete-line ()
  "ポイントが空行ならキルリングに追加しない"
  (interactive)
  (if (and (bolp) (eolp))
      (my-delete-line)
    (my-kill-line)))

(defun my-delete-line (&optional arg)
  (interactive "P")
  (delete-region (point)
                 (progn
                   (if arg
                       (forward-visible-line (prefix-numeric-value arg))
                     (if (eobp)
                         (signal 'end-of-buffer nil))
                     (let ((end
                            (save-excursion
                              (end-of-visible-line) (point))))
                       (if (or (save-excursion
                                 (unless show-trailing-whitespace
                                   (skip-chars-forward " \t" end))
                                 (= (point) end))
                               (and kill-whole-line (bolp)))
                           (forward-visible-line 1)
                         (goto-char end))))
                   (point))))

(global-set-key (kbd "C-k") 'my-kill-or-delete-line)

;;(global-set-key (kbd "C-k") 'my-kill-line)








;;backward-symbol
(defun my-backward-symbol ()
  (interactive)
  (forward-symbol -1))

;;C-u C-x =で文字についての情報が詳しくみえる
(defun scroll-one-line-up ()
 "一回に一行のスクロールアップ"
 (interactive)
 (scroll-up 1))

(defun scroll-one-line-down ()
 "一回に一行のスクロールダウン"
 (interactive)
 (scroll-down 1))

(global-set-key (kbd "C-M-v") 'scroll-one-line-up)
(global-set-key (kbd "C-M-g") 'scroll-one-line-down)

;;全角スペースは半角スペースに置換する
(define-key global-map "　" " ")
;(define-key global-map "、" ",")
;(define-key global-map "。" ".")
;(global-unset-key "　")


;; (defun el-docstring-at-echo-erea ()
;;   "Show docstring at echo area"
;;   (interactive)
;;   (let ((d (thing-at-point 'symbol)))
;;     (setq a (documentation 'run-with-timer))
;;     ;(message "%s" (documentation (or (thing-at-point 'symbol) "")))
;; ;(message d)
;;     (message (documentation 'setq)
;;     ;(message "%s" (documentation d))
;;     )))

;(key-chord-define-global "YY" 'el-docstring-at-echo-erea)

;; (or (thing-at-point 'symbol) "")
;; (documentation (thing-at-point 'symbol))

(defun kill-buffer-if-exist (buf)
 "存在したバッファを削除したなら t, バッファが存在しなかったなら nil を返す"
 (if (get-buffer buf)
     (kill-buffer buf)))

;; (defun search-looking-back ()
;;   "looking-backってどんな関数かな"
;;   (interactive)
;;   (message "%s" (looking-back "hogefuga")))


;; (setq my-review-time '5)

;; (defun my-oops-trigger ()
;;   "オーバレイ表示関数を呼び出す"
;;   (and (looking-back "\\s-==\\s-")
;;       (my-mysterious-operator-check)))

;; (defun my-mysterious-operator-check()
;;   " == を利用するときは気を引き締める。オーバレイは見様見真似。"
;;   ;(let ((overlay (make-overlay (next-line-point) (next-line-point))))
;;   (let ((overlay (make-overlay (point) (point))))
;;     (overlay-put overlay 'before-string #("Oops!" 0 5 (face highlight)))
;;     (overlay-put overlay 'after-string nil)
;;     (sit-for my-review-time)
;;     (delete-overlay overlay)))

;; (defun next-line-point ()
;;   "pointの一行下の位置を取得。"
;;   ;(interactive)
;;   (save-excursion
;;     (forward-line 1)
;;     (point)))


;;;; 現在行の全角スペースを半角スペースに置換する
;; (defun my-zensp ()
;;   "行頭からポイントまでの全角スペースを半角スペースに置換する"
;;   (interactive)
;;   (let ((previous-point (point)))
;;   (save-excursion
;;     (move-beginning-of-line 1);行頭へ
;;     (while (re-search-forward "　" previous-point t)
;;       (replace-match " " nil nil)))))
;; (global-set-key [f10] 'my-zensp);日本語入力時に呼び出しやすくするにはファンクションキーが妥当

;; 任意のサイズのファイルをつくるときに利用する
;; insert-char
;; 同じ文字をたくさん入れたい時に使用できます。引数を二つ取り、最初の引数は文字コード、二つ目の引数は個数です。文字 `a'
;;を100個入れたい時は次のようにします。
;; (insert-char ?a 100)

(defun my-untabify (arg)
 ""
 (interactive "n1タブに対する半角スペースの数: ")
 (untabify (region-beginning) (region-end) arg))


;; リージョンを選択し C-u 2 C-x [TAB] で、indent-rigidly。
(defun my-indent-rigidly (arg)
 "indent-rigidly でインデント数を後から指定するラッパー関数"
 (interactive "nインデント数: ")
 (indent-rigidly (region-beginning) (region-end) arg))
(global-set-key [(control tab)] 'my-indent-rigidly)

;;ベンチマーク用関数
 ;;(benchmark-run 1000 (--spc2.*-loop "del o w"))
 ;;benchmark-run-compiled,benchmark,benchmark-1 など。

;; http://d.hatena.ne.jp/kazu-yamamoto/20080603/1212462940
;; (mapcar (function buffer-name) (buffer-list))
;; (mapcar #'buffer-name (buffer-list))


;;;; 行末のスペースを削除
;; -> delete-trailing-whitespace の再発明
;; (defun trim-buffer ()
;;   "Delete excess white space."
;;   (interactive)
;;   (save-excursion
;;     (goto-char (point-min))
;;     (while (re-search-forward "[ \t]+$" nil t)
;;       (replace-match "" nil nil))
;;        (goto-char (point-max))
;;     (delete-blank-lines)
;;      (mark-whole-buffer)
;;     (tabify (region-beginning) (region-end))))

;; (defun php-toggle-hideshow-function () "Toggle hideshow all."
;;   (interactive)
;;   (setq php-hs-hide (not php-hs-hide))
;;   (if php-hs-hide
;;       (save-excursion
;;      (goto-char (point-min))
;;      (hs-hide-level 2)
;;      (goto-char (point-max))
;;      (while
;;          (search-backward "/**")
;;        (hs-hide-block)))
;;     (hs-show-all)))

;; ;;;; 折り返し表示ON/OFF
;;設定済み。トグルのサンプル
;; (setq truncate-lines t)            ;; 長い行の折り返し表示を nil:しない。 t:する。
;; (defun toggle-truncate-lines ()
;;   "折り返し表示をトグル動作します."
;;   (interactive)
;;   (if truncate-lines      (setq truncate-lines nil)
;;     (setq truncate-lines t))
;;   (recenter))
;; (global-set-key "\C-c\C-l" 'toggle-truncate-lines) ; 折り返し表示ON/OFF

;; 各種検索（冗談）
;; (defun guguru (hoge)
;;     (interactive "s検索語:")
;;     (browse-url
;;      (concat "http://www.google.co.jp/search?q=" (url-hexify-string hoge))))
;;   (defun dinoru (hoge)
;;     (interactive "s検索語:")
;;     (browse-url
;;      (concat "http://openlab.dino.co.jp/search/" (url-hexify-string hoge))))
;;   (defun asial (hoge)
;;     (interactive "s検索語:")
;;     (browse-url
;;      (concat "http://blog.asial.co.jp/search.php?words="
;; (url-hexify-string hoge))))

;;;; フルスクリーンへの切り替え。トグル。
;;http://d.hatena.ne.jp/khiker/20090711
(defun my-fullscreen ()
 (interactive)
 (let ((fullscreen (frame-parameter (selected-frame) 'fullscreen)))
   (cond
    ((null fullscreen)
     (set-frame-parameter (selected-frame) 'fullscreen 'fullboth))
    (t
     (set-frame-parameter (selected-frame) 'fullscreen 'nil))))
 (redisplay))

(global-set-key [f11] 'my-fullscreen)

;;;; カーソル位置のフェースを調べる関数
(defun describe-face-at-point ()
 "Return face used at point."
 (interactive)
 (message "%s" (get-char-property (point) 'face)))


;;結果をオーバーレイで表示できたほうがいいかも。
;;wordだと-,_をデリミタとみなすみたい
(defun kill-new-things-at-point ()
 "現在のポイント位置のシンボルをkill-ringへ追加する"
 (interactive)
 (kill-new (thing-at-point 'symbol)))

;; アリエルエリアにkill-ringにいれたシンボルを光らせるところまでやっている人がいた。負けた。。
(defun my-thing-at-point (thing)
 (if (get thing 'thing-at-point)
     (funcall (get thing 'thing-at-point))
   (let ((bounds (bounds-of-thing-at-point thing)))
     (if bounds
         (let ((ov (make-overlay (car bounds) (cdr bounds))))
           (overlay-put ov 'face 'region)
           (sit-for 3)
           (delete-overlay ov)
           (buffer-substring (car bounds) (cdr bounds)))))))

;;(global-set-key (kbd "C-q w") (lambda () (interactive) (kill-new(my-thing-at-point 'symbol))))


(defvar ctl-q-map (make-keymap))  ;ctrl-q-map という変数を新たに定義
(define-key global-map (kbd "C-q") ctl-q-map) ;ctrl-q-map を Ctrl-q に割り当てる
;(define-key ctl-q-map (kbd "C-w") 'kill-new-things-at-point) ;C-q C-wでkill-new-things-at-pointを実行

(define-key ctl-q-map (kbd "C-w") (lambda () (interactive) (kill-new
(my-thing-at-point 'symbol))))
(define-key ctl-q-map (kbd "C-e") (lambda () (interactive) (kill-new
(my-thing-at-point 'word))))
(define-key ctl-q-map (kbd "C-r") (lambda () (interactive) (kill-new
(my-thing-at-point 'sexp))))
;(define-key ctl-q-map (kbd "C-b") 'your-favorite-funcb)
(define-key ctl-q-map (kbd "C-q") 'quoted-insert) ;元々の関数

;;;; 折り返し表示ON/OFF

(setq truncate-lines nil)            ;; 長い行の折り返し表示を nil:しない。 t:する。
(defun toggle-truncate-lines ()
 "折り返し表示をトグル動作します."
 (interactive)
 (if truncate-lines      (setq truncate-lines nil)
   (setq truncate-lines t))
 (recenter))
(global-set-key "\C-c\C-l" 'toggle-truncate-lines) ; 折り返し表示ON/OFF

;;文字の拡大縮小
(defun djcb-zoom (n)
 "with positive N, increase the font size, otherwise decrease it"
 (set-face-attribute 'default (selected-frame) :height
   (+ (face-attribute 'default :height) (* (if (> n 0) 1 -1) 10))))

(global-set-key (kbd "C-+")      '(lambda nil (interactive) (djcb-zoom 1)))
(global-set-key [C-kp-add]       '(lambda nil (interactive) (djcb-zoom 1)))
(global-set-key (kbd "C--")      '(lambda nil (interactive) (djcb-zoom -1)))
(global-set-key [C-kp-subtract]  '(lambda nil (interactive) (djcb-zoom -1)))

;; コメント行はスキップ
(setq parse-sexp-ignore-comments t)

;;今いる位置の関数の名前をモードラインに表示する。
(which-func-mode)


;; 削除

(defun delete-kugyo ()
 "空行を一括削除"
 (interactive)
 (save-excursion
   (goto-char (point-min))
   (flush-lines "^$")))

(defun my-delete-all-buffer-content ()
  "バッファの内容を全削除"
  (interactive)
  (goto-char (point-min))
  (flush-lines "\\.*"))

(defun my-delete-buffer-content-after-point ()
  "ポイントより後ろのバッファの内容を削除"
  (interactive)
  (save-excursion
    (newline)
    (flush-lines "\\.*")))

(defun delete-kugyo-region (start end)
 "リージョンの空行を一括削除"
 (interactive "r")
   (flush-lines "^$" start end))


;; http://ubulog.blogspot.com/2009/08/emacs.html
;; 起動するまでにかかった時間を表示。
(defun boot-time ()
  " 起動するまでにかかった時間を表示。"
  (interactive)
  (message "起動時間:%s秒"
           (- (car (cdr after-init-time)) (car (cdr before-init-time)))))

;; (defun toggle-truncate-lines ()
;;   (interactive)
;;   (setq truncate-lines (not truncate-lines)))

;; elisp 比較演算子
;/=,<,>,<=,>=
(defun my-minusp (n)
 "引数がマイナスなら t, それ以外なら nil を返す"
 (< n 0))
;;(my-minusp 3)

(defun backward-kill-symbol (arg)
 "Kill characters backward until encountering the beginning of a symbol.
With argument ARG, do this that many times."
 (interactive "p")
 (kill-symbol (- arg)))
(defun kill-symbol (arg)
 "Kill characters forward until encountering the end of a symbol.
With argument ARG, do this that many times."
 (interactive "p")
 (kill-region (point) (progn (forward-symbol arg) (point))))

;(global-set-key (kbd "M-/") 'backward-kill-symbol)
;(global-set-key (kbd "M-/") 'backward-kill-word)
;;(global-set-key (kbd "M-/") 'backward-delete-word) に変更

;; tree構造->平らにする
(defun my-flatten (lis)
  (cond ((atom lis) lis)
        ((listp (car lis))
         (append (flatten (car lis)) (flatten (cdr lis))))
        (t (append (list (car lis)) (flatten (cdr lis))))))


;; http://www.bookshelf.jp/soft/meadow_30.html#SEC401
(defun window-toggle-division ()
 "ウィンドウ 2 分割時に、縦分割<->横分割"
 (interactive)
 (unless (= (count-windows 1) 2)
   (error "ウィンドウが 2 分割されていません。"))
 (let (before-height (other-buf (window-buffer (next-window))))
   (setq before-height (window-height))
   (delete-other-windows)

   (if (= (window-height) before-height)
       (split-window-vertically)
     (split-window-horizontally))

   (switch-to-buffer-other-window other-buf)
   (other-window -1)))

;; (key-chord-define-global "wt" 'window-toggle-division)

;; thing-at-point でシンボルがとれればそれを引数とする
;; (defun anything-at-point (arg)
;;   (interactive "P")
;;   (if arg
;;       (anything nil (thing-at-point 'symbol))
;;     (anything)))

;; 2つのリストの差分を調査する。
;; (set-difference
;;   (list "a" "b" "c")
;;   (list "a" "b" "d")
;;   :test 'string=)


(defun wrap-by-double-quote ()
 "Insert a markup <b></b> around a region."
 (interactive)
 (save-excursion
   (goto-char (region-end))
   (insert "\"")
   (goto-char (region-beginning))
   (insert "\"")))

;; ;;string-match()は文字列におけるマッチ位置を返す
;; (if (string-match " " )
;;     (goto-char (region-end))
;;     (insert "\"")

;; (defun my-insert-double-quote ()
;;  "ポイントの前後の半角スペースの位置にダブルクオートを挿入する"
;;  (interactive)
;;  (save-excursion
;;    (search-forward " ")
;;    (backward-char 1)
;;    (insert "\"")
;;    (search-backward " ")
;;    (forward-char 1)
;;    (insert "\"")))

;; (global-set-key (kbd "C-2") 'my-insert-double-quote)

;; (defun my-insert-single-quote ()
;;  "ポイントの前後の半角スペースの位置にシングルクオートを挿入する"
;;  (interactive)
;;  (save-excursion
;;    (search-forward " ")
;;    (backward-char 1)
;;    (insert "\'")
;;    (search-backward " ")
;;    (forward-char 1)
;;    (insert "\'")))

;; (global-set-key (kbd "C-7") 'my-insert-single-quote)

;;ポイント位置の単語をマークする
(transient-mark-mode 1)
(defun select-word ()
"Select a word under cursor.
word here is considered any alphanumeric sequence with _ or -."
 (interactive)
 (let (b1 b2)
  (skip-chars-backward "-_A-Za-z0-9")
  (setq b1 (point))
  (skip-chars-forward "-_A-Za-z0-9")
  (setq b2 (point))
  (set-mark b1)))
;;置換
(defun replace-html-chars-region (start end)
 (interactive "r")
 (save-restriction
   (narrow-to-region start end)
   (goto-char (point-min))
   (while (search-forward "&" nil t) (replace-match "&amp;" nil t))))
;;削除
(defun delete-enclosed-text ()
 "Delete texts between any pair of delimiters."
 (interactive)
 (save-excursion
   (let (p1 p2)
     (skip-chars-backward "^(<[“") (setq p1 (point))
     (skip-chars-forward "^)>]”") (setq p2 (point))
     (delete-region p1 p2))))
;; 変数のデフォルト値を一時的に変更して関数を実行
(defun remove-line-breaks ()
 "Remove line endings in a paragraph."
 (interactive)
 (let ((fill-column (point-max)))
   (fill-paragraph nil)))

;; ファイルを開いたときに正規表現にマッチする行をハイライト
(defun highlite-it ()
 "Highlight certain lines..."
 (interactive)
 (if (equal "el" (file-name-extension (buffer-file-name)))
     (progn
       (highlight-lines-matching-regexp "ERROR:" 'hi-red-b)
       (highlight-lines-matching-regexp "not ok" 'hi-red-b)
       (highlight-lines-matching-regexp "NOTE:" 'hi-green-b))))

(add-hook 'find-file-hook 'highlite-it)

;;連番。これは便利。
;; ToDo 右寄せにフォーマット。リージョンに対しておこなう。
;; (defun insert-counter-column (n)
;;  "Insert a sequence of integers vertically.
;; Example:
;; do this 1 times
;; do this 2 times
;; do this 3 times
;; ...

;; If there are not enough existing lines after the cursor
;; when this function is called, it aborts at the last line.

;; See also: `kill-rectangle' and `string-rectangle'."
;;  (interactive "nEnter the max integer: ")
;;  (let ((i 1) colpos)
;;    (setq colpos (- (point) (point-at-bol)))
;;    (while (<= i n)
;;      (insert (number-to-string i))
;;      (next-line) (beginning-of-line) (forward-char colpos)

;;      (setq i (1+ i)))))

;; (fset 'my-insert-counter-column 'insert-counter-column)



(defun describe-hash (variable &optional buffer)
  "Display the full documentation of VARIABLE (a symbol).
Returns the documentation as a string, also.
If VARIABLE has a buffer-local value in BUFFER (default to the current buffer),
it is displayed along with the global value."
  (interactive
   (let ((v (variable-at-point))
         (enable-recursive-minibuffers t)
         val)
     (setq val (completing-read
                (if (and (symbolp v)
                         (hash-table-p (symbol-value v)))
                    (format
                     "Describe hash-map (default %s): " v)
                  "Describe hash-map: ")
                obarray
                (lambda (atom) (and (boundp atom)
                                    (hash-table-p (symbol-value atom))))
                t nil nil
                (if (hash-table-p v) (symbol-name v))))
     (list (if (equal val "")
               v (intern val)))))
  (with-output-to-temp-buffer (help-buffer)
    (maphash (lambda (key value)
               (pp key)
               (princ " => ")
               (pp value)
               (terpri))
             (symbol-value variable))))

;; 削除関数
;; (delete-region (point) (point-max))
;; (kill-region (point-min) (point-max)) 


;; (defun my-get-fullpass-by-dir-name (dir)
;;   "ディレクトリ名を渡すとフルパスで直下のファイル返す関数"
;;   (loop for e in (directory-files dir)
;;         collect (expand-file-name e dir)))
;; (my-get-fullpass-by-dir-name "~/.emacs.d/elisp/")

(defun rstrip (str) (replace-regexp-in-string "[ \t\n]*$" "" str))
(defun lstrip (str) (replace-regexp-in-string "^[ \t\n]*" "" str))
(defun strip (str) (lstrip (rstrip str)))

(defun my-trim (s)
  (replace-regexp-in-string
   "[ \t\n]+$" "" (replace-regexp-in-string "^[ \t\n]+" "" s)))

(defun html2md()
  (interactive)
  (when (get-buffer "*html2md*")
    (with-current-buffer (get-buffer "*html2md*")
      (erase-buffer)))
  (let ((str (buffer-substring-no-properties (point-min) (point-max)))
        (temp-file (make-temp-file "html2md--")))
     (with-temp-file temp-file (insert str))
  (call-process-shell-command
       (concat "pandoc " "-f html -t markdown " temp-file) nil "*html2md*" t)
  (switch-to-buffer "*html2md*")
  (markdown-mode)))
