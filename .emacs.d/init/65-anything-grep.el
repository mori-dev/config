;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;;http://d.hatena.ne.jp/rubikitch/20090106/anythinggrep
;; anythingバッファでRET押下で改行してしまう。
;(require 'anything-grep)
(require 'anything-grep2)

(defalias 'agrep 'anything-grep)
;; もうひとつ用意しているコマンドは M-x anything-grep-by-name だ。これはクエリと場所を入力することで検索を行う。場所と対応するコマンドは anything-grep-alist という変数で設定する。コードを見るとわかるように複数のディレクトリを串刺し検索できるぞ。

;; ack-grep -C10 -w symfony ~/Dropbox/howm
;; ack-grep -C10 -w foo ./.emacs.d/conf
;;"ack -afG '(tt2|tt|yaml|yml|p[lm])$' | xargs egrep -Hin %s")
(setq anything-grep-alist
    ;; 全バッファのファイル名においてegrepをかける。moccurの代わり。
  '(
    ("howm" ("egrep -Hin %s $buffers" "~/Dropbox/howm"))
    ;; ;; ~/memo 以下から再帰的にegrepをかける。不要なファイルは除かれる。
    ("howm" ("ack-grep -af | xargs egrep -Hin %s" "~/Dropbox/howm")) ;;ack-grep 文字化け
    ;; ~/doc/postgresql-74 から *.txt に対してegrepをかける。
    ;; ("PostgreSQL" ("egrep -Hin %s *.txt" "~/doc/postgresql-74/"))
    ;; ;; ~/ruby以下の全Rubyスクリプトと~/bin以下のファイルをまとめて検索する。
    ;; ("~/bin and ~/ruby"
    ;;  ("ack-grep -afG 'rb$' | xargs egrep -Hin %s" "~/ruby")
    ;;  ("ack-grep -af | xargs egrep -Hin %s" "~/bin"))

    ))

;; マッチした行に色をつける
(defun anything-persistent-highlight-point (start &optional end buf face rec)
  (goto-char start)
  (when (overlayp anything-c-persistent-highlight-overlay)
    (move-overlay anything-c-persistent-highlight-overlay
                  start
                  (or end (line-end-position))
                  buf))
  (overlay-put anything-c-persistent-highlight-overlay 'face (or face 'highlight))
  (when rec
    (recenter)))

;; (setq anything-cleanup-hook nil);;debug
;; (add-hook 'anything-cleanup-hook
;;           (lambda ()
;;             (when (overlayp anything-c-persistent-highlight-overlay)
;;               (delete-overlay anything-c-persistent-highlight-overlay))))


;; (defun anything-c-moccur-clean-up ()
;;   (setq anything-c-moccur-anything-invoking-flag nil)
;;   (when (overlayp anything-c-moccur-current-line-overlay)
;;     (delete-overlay anything-c-moccur-current-line-overlay)))

;; (setq anything-grep-goto-hook
;;       (lambda ()
;;         (when anything-in-persistent-action
;;           (anything-persistent-highlight-point (point-at-bol) (point-at-eol)))))
;; を(cleanup . anything-c-moccur-clean-up)とつかう。
;;;;
;;M-x anything-grep-by-name だ。これはクエリと場所を入力することで検索を行う。場所と対応するコマンドは anything-grep-alist という変数で設定する。コードを見るとわかるように複数のディレクトリを串刺し検索できるぞ。
;; (setq anything-grep-alist
;;     ;; 全バッファのファイル名においてegrepをかける。moccurの代わり。
;;   '(("buffers" ("egrep -Hin %s $buffers" "/"))
;;     ;; ~/memo 以下から再帰的にegrepをかける。不要なファイルは除かれる。
;;     ("memo" ("ack-grep -af | xargs egrep -Hin %s" "~/memo"))
;;     ;; ~/doc/postgresql-74 から *.txt に対してegrepをかける。
;;     ("PostgreSQL" ("egrep -Hin %s *.txt" "~/doc/postgresql-74/"))
;;     ;; ~/ruby以下の全Rubyスクリプトと~/bin以下のファイルをまとめて検索する。
;;     ("~/bin and ~/ruby"
;;      ("ack-grep -afG 'rb$' | xargs egrep -Hin %s" "~/ruby")
;;      ("ack-grep -af | xargs egrep -Hin %s" "~/bin"))))








;;document
;; grepの結果をanything.elのインターフェースで絞り込める anything-grep.el をリリースした。

;; M-x install-elisp http://www.emacswiki.org/cgi-bin/wiki/download/anything-grep.el
;; M-x grep の代わりに M-x anything-grep を使えばよい。ちゃんとマッチした部分に色がつくぞ。スクリーンショットをどうぞ。通常のM-x grep同様、grep以外のコマンドでも使える。
;; M-x grep との違いはgrepのコマンドラインを入力した後にディレクトリも聞いてくること。だからどこどこのディレクトリにある文字列を検索したいなんて場合は重宝する。
;; マッチした行に色をつけるには、以下の設定を。via persistent-actionを自動的に実行し、任意の箇所をハイライト - asdf

;; (defun anything-persistent-highlight-point (start &optional end buf face rec)
;;   (goto-char start)
;;   (when (overlayp anything-c-persistent-highlight-overlay)
;;     (move-overlay anything-c-persistent-highlight-overlay
;;                   start
;;                   (or end (line-end-position))
;;                   buf))
;;   (overlay-put anything-c-persistent-highlight-overlay 'face (or face 'highlight))
;;   (when rec
;;     (recenter)))

;; (add-hook 'anything-cleanup-hook
;;           (lambda ()
;;             (when (overlayp anything-c-persistent-highlight-overlay)
;;               (delete-overlay anything-c-persistent-highlight-overlay))))

;; (setq anything-grep-goto-hook
;;       (lambda ()
;;         (when anything-in-persistent-action
;;           (anything-persistent-highlight-point (point-at-bol) (point-at-eol)))))

;; もうひとつ用意しているコマンドは M-x anything-grep-by-name だ。これはクエリと場所を入力することで検索を行う。場所と対応するコマンドは anything-grep-alist という変数で設定する。コードを見るとわかるように複数のディレクトリを串刺し検索できるぞ。

;; (setq anything-grep-alist
;;     ;; 全バッファのファイル名においてegrepをかける。moccurの代わり。
;;   '(("buffers" ("egrep -Hin %s $buffers" "/"))
;;     ;; ~/memo 以下から再帰的にegrepをかける。不要なファイルは除かれる。
;;     ("memo" ("ack-grep -af | xargs egrep -Hin %s" "~/memo"))
;;     ;; ~/doc/postgresql-74 から *.txt に対してegrepをかける。
;;     ("PostgreSQL" ("egrep -Hin %s *.txt" "~/doc/postgresql-74/"))
;;     ;; ~/ruby以下の全Rubyスクリプトと~/bin以下のファイルをまとめて検索する。
;;     ("~/bin and ~/ruby"
;;      ("ack-grep -afG 'rb$' | xargs egrep -Hin %s" "~/ruby")
;;      ("ack-grep -af | xargs egrep -Hin %s" "~/bin"))))

;; 「$buffers」という変数は特別なもので、全バッファのbuffer-file-nameを集めたものに置換される。この用途には moccur や anything-c-moccur-dmoccur があるのだが、馬鹿でかいバッファや大量のバッファが存在していると遅くなるのでegrepで検索してしまおうというもの。餅は餅屋といったところで、速度はGNU grepにはかなわない。

;; ack-grepというコマンドはgrepの置き換えを狙ったPerlスクリプトで、.svn等検索不要なファイルを予め除いてくれる機能がある。ディストリビューションによるとackコマンドだったりするがDebian GNU/Linuxだとack-grepになっている。嬉しいことに、不要なファイルを除いたファイルリストを得る機能もついている。純粋な検索速度はやはりGNU grepにはかなわないので、今回はこの機能とGNU grepを併用する。ack -- better than grep, a power search tool for programmersからどうぞ。

;; grepは同期プロセスなので、grep実行中は待たされる。しかし、一度OSのキャッシュに入ってしまえば100MBのテキストであってもコンマ数秒以内で済むから非同期化はしない予定だ。気になるならば、予め「find DIR -type f | xargs cat > /dev/null」とかでキャッシュに入れておくとよい。

;; anything-grepの検索結果を再び見たければ M-x anything-resume ね。他のanythingを実行したならば、C-u M-x anything-resume でok。
