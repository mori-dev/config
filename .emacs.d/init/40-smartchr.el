(require 'smartchr)

;; (eval-after-load "org-mode"
;; (eval-after-load "40-org"
;;   '(progn
;;      (define-key my-org-mode-map (kbd ">") (smartchr '(">" ">>" ">|ruby|" ">|lisp|" ">|javascript|" ">|sh|" ">|`!!'|")))
;;      (define-key my-org-mode-map (kbd "<") (smartchr '("<" "||<" "<<" )))
;;   ))


;; cua-mode とかぶる

;;"FF" 対策はこうもできる(利用者向け一般論です、この場合は候補にでるとうざいかも)。(global-set-key (kbd "F") (smartchr '("F" "$" "$_" "$_->" "@$" "FF")))
;(key-chord-define-global "11" (smartchr '("!" "!!"  "!!!!" "11")))
;; (global-set-key (kbd "=") (smartchr '("=" " = " " == " " === " "=> ")))
;(global-set-key (kbd "1") (smartchr '("1" "!!"  "!!!!")))
;; (global-set-key (kbd "{") (smartchr '("{ `!!' }" "{")))
;; (global-set-key (kbd ">") (smartchr '(">" " => " " => '`!!''" " => \"`!!'\"")))
;; (global-set-key (kbd "F") (smartchr '("F" "$" "FF")))
;; (global-set-key (kbd "H") (smartchr '("H" "~/" "HH")))


;; (global-set-key (kbd "^") (smartchr '("^" "lambda" "^^")))
;; (global-set-key (kbd "L") (smartchr '("L" "(lambda (" "lambda" "LL")))

;; (global-set-key (kbd "J") (smartchr '("J" "\"" "JJ")))
;; (global-set-key (kbd "K") (smartchr '("K" "\'" "KK")))
(global-set-key (kbd "R") (smartchr '("R" " rubikitch さん" " id:rubikitch ")))
;; (global-set-key (kbd "G") (smartchr '("G" " g000001 さん" " id:g000001 ")))

;; (global-set-key (kbd "[") (smartchr '("[" "[質問] " "[確認] " "[報告] " "[連絡] " "[[")))
;; (global-set-key (kbd "T") (smartchr '("T" "竹腰さん" "TT")))


;; (global-set-key (kbd "S") (smartchr '("S" "<strong>" "</strong>")))

;; (define-key minibuffer-local-map (kbd "^") (smartchr '("~/" "~/Dropbox/" "^")))

;; (eval-after-load "skk-mode"
;;   '(progn
;;      (define-key skk-j-mode-map (kbd "「") (smartchr '("「" "「`!!'」" "「「")))
;;   ))

;; hatena diary
;; (global-set-key (kbd ">") (smartchr '(">" ">>" ">|ruby|" ">|lisp|" ">|javascript|" ">|sh|" ">|`!!'|")))
;; (global-set-key (kbd "<") (smartchr '("<" "||<" "<<" )))


(eval-after-load "ruby-mode"
  '(progn
     (define-key ruby-mode-map (kbd "{") (smartchr '("{" "do |`!!'| end" "{|`!!'| }" "{{")))
     (define-key ruby-mode-map (kbd "#") (smartchr '("#" "##" "#{`!!'}")))
     ;;%{}はダブルクオートを使った文字列リテラルと機能は同じ。文字列内の " をバックスラッシュでエスケープしなくても良いところが便利
     (define-key ruby-mode-map (kbd "%") (smartchr '("%" "%%" "%{`!!'}")))
     (define-key ruby-mode-map (kbd "A") (smartchr '("A" "&" "&block" "&&" "AA")))
     (define-key ruby-mode-map (kbd "F") (smartchr '("F" "$" "FF")))
     (define-key ruby-mode-map (kbd "W") (smartchr '("W" "%w[`!!']" "WW" )))
  ))

(eval-after-load "rhtml-mode"
  '(progn
     (define-key rhtml-mode-map (kbd "<") (smartchr '("<" "<%" "<%=" "<%= `!!' %>" "<% `!!' %>" "<<")))
     (define-key rhtml-mode-map (kbd ">") (smartchr '(">" "%>" ">>")))
     ))


(eval-after-load "php-mode"
  '(progn
     (define-key php-mode-map (kbd "-") (smartchr '("-" "_" "--")))
     (define-key php-mode-map (kbd "(") (smartchr '("(" "{`!!'}" "[`!!']" "((")))
     (define-key php-mode-map (kbd ")") (smartchr '(")" "}" "]" "))")))
     (define-key php-mode-map (kbd "P") (smartchr '("P" "PP" "<?php `!!' ?>")))
     (define-key php-mode-map (kbd "F") (smartchr '("F" "$" "FF")))
     (define-key php-mode-map (kbd "V") (smartchr '("V" "var_dump(`!!');exit;" "VV")))
  ))


(eval-after-load "emacs-lisp-mode"
  '(progn
     (define-key emacs-lisp-mode-map (kbd "-") (smartchr '("-" "_" "--")))
     (define-key emacs-lisp-mode-map (kbd "J") (smartchr '("J" "JJ" ";;=> " "JJJ")))
     (define-key emacs-lisp-mode-map (kbd "&") (smartchr '("&" "&key " "&optional " "&body " "&rest " "&aux " "&&")))
     (define-key emacs-lisp-mode-map (kbd "A") (smartchr '("A" "&" "&key " "&optional " "&body " "&rest " "&&")))
  ))

(add-hook 'org-mode-hook
  (lambda()
    ;; (define-key org-mode-map (kbd "M-RET") nil)
    (define-key org-mode-map (kbd "[") (smartchr '("[" "[`!!'] " "[emacs] " "[python] ""[js] " "[jquery] "  "[[")))
    ))

(add-hook 'slime-mode-hook
   (lambda ()
     (define-key slime-mode-map (kbd "#") (smartchr '("#" "#'" "##")))
     (define-key slime-repl-mode-map (kbd "#") (smartchr '("#" "#'" "##")))
     (define-key slime-mode-map (kbd "&") (smartchr '("&" "&key " "&optional " "&body " "&rest " "&aux " "&&")))
     (define-key slime-repl-mode-map (kbd "&") (smartchr '("&" "&key " "&optional " "&body " "&rest " "&aux " "&&")))       ))

(add-hook 'slime-repl-mode-hook
   (lambda ()
     (define-key slime-mode-map (kbd "#") (smartchr '("#" "#'" "##")))
     (define-key slime-repl-mode-map (kbd "#") (smartchr '("#" "#'" "##")))
     (define-key slime-mode-map (kbd "&") (smartchr '("&" "&key " "&optional " "&body " "&rest " "&aux " "&&")))
     (define-key slime-repl-mode-map (kbd "&") (smartchr '("&" "&key " "&optional " "&body " "&rest " "&aux " "&&")))       ))


(eval-after-load "js2"
  '(define-key js2-mode-map (kbd "-") (smartchr '("-" "_" "--"))))

(eval-after-load "haml-mode"
  '(progn
       (define-key haml-mode-map (kbd "J") (smartchr '("J" "%" "JJ")))
     ))


;(global-set-key (kbd "\"") (smartchr '("\"" my-insert-double-quote)))

(defun ik:insert-eol (s)
  (interactive)
  (lexical-let ((s s))
    (smartchr-make-struct
     :insert-fn (lambda ()
                  (save-excursion
                    (goto-char (point-at-eol))
                    (when (not (string= (char-to-string (preceding-char)) s))
                      (insert s))))
     :cleanup-fn (lambda ()
                   (save-excursion
                     (goto-char (point-at-eol))
                     (delete-backward-char (length s)))))))

(defun ik:insert-semicolon-eol ()
  (ik:insert-eol ";"))

;; (global-set-key (kbd ";")
;;                   (smartchr '(";" ik:insert-semicolon-eol)))


;;(define-key php-mode-map  (kbd "P") (smartchr '("P" "<?php `!!' ?>")))

;; さて、皆さんはプログラム中に = を書くとき、両端にスペースを入れているでしょうか？私は、入れています。入れないより入れた方が、プログラムがずっと読みやすくなるからです。ですが、前後にスペースを入れない時と比べて、2回タイプ数が増えてしまうという問題があります。

;; そういった問題を解決する smartchr.el というemacs拡張をリリースしました。

;; smartchr.elを使う事で、連続して起動した時に指定した文字列を順番に入力するコマンドを簡単に定義する事ができます。 http://github.com/imakado/emacs-smartchrからダウンロードする事ができます。

;; load-path の通ったディレクトリに配置して、 (require 'smartchr) すると使えるようになります。

;; smartchr.elは、Kana Natsunoさんによって書かれた同名のvim scriptのemacsバージョンです。 K1Lowさんからアイデアをもらって原型ができたのは1年も前でしたが、最近やっとリリースできました。オリジナルを書いたkana氏、emacs版のアイデアを下さったK1Low氏の両名に感謝します。

;; このエントリーで定義するコマンドのデモスクリーンキャストを撮影しましたので、併せてご覧下さい。

;; smartchr.el from imakado on Vimeo.
;; 使ってみよう!!

;; それでは、実際に使ってみましょう。習うより慣れろというやつですね。

;; "=" を一回押すと " = " を入力、続けてもう一度押すと " == " を入力、さらに押すとそのままの "=" を入力するコマンドを定義してみます。コマンドの定義には smartchr 関数を使用します。引数には、入力する文字列のリストを渡します。すると、起動するたびに引数に渡した文字列を順番に入力するコマンドを返すので、そのコマンドをキーバインドに割り当てます。具体的には、以下のようなコードになります。

;; (global-set-key (kbd "=") (smartchr '(" = " " == "  "=")))

;; さらに、引数の文字列中の `!!' がカーソルの位置に置き換わるので、以下のような定義も可能です。

;; (global-set-key (kbd "{") (smartchr '("{ `!!' }" "{")))

;; 上の定義は、"{" を一回押すと カーソルの前後に "{ " と " }" を入力、続けてもう一度押すと単純に "{" を入力するコマンドを定義します。この機能は本家にはありませんが、便利だったので実装しました。
;; ノンフィクション! 変態設定大公開!!

;; 実例として自分の設定を書いて置きます。

;; (global-set-key (kbd ">") (smartchr '(">" " => " " => '`!!''" " => \"`!!'\"")))

;; この定義は">"を押すたびに、 > => => '' => "" を入力します。一般的なプログラム言語で、hashを定義するとき等に重宝しています。

;; (global-set-key (kbd "F") (smartchr '("F" "$" "$_" "$_->" "@$")))

;; このコマンドは Shift+f を押すたびに $ $_ $_-> 等のperlとは切っても切れない記号を入力します。これにより、左手の人差し指をホームポジションから動かす事無く "$" を打つ事ができるようになります。もう遥か彼方にある Shift+4 を押す必要はありません!! "FF"が入力できなくなってしまうという弊害がありますが、"FF"なんて文字は滅多に打つ事はないので問題ないでしょう。どうしても入力する必要がある時は、F -> C-g -> F とでも打てば良いのです。

;; 最後に、perlプログラミングで便利に使っている定義をいくつか紹介します。

;; (define-key cperl-mode-map (kbd "M") (smartchr '("M" "my $`!!' = " "my ($self, $`!!') = @_;" "my @`!!' = ")))

;; これは変数定義を便利にします。Shift+m を連打するだけで、変数定義が可能になります!

;; (defun perl-smartchr:sub ()
;;   ""
;;   "sub `!!' {
;;     my ($self) = @_;

;; }")

;; (define-key cperl-mode-map (kbd "S") (smartchr '("S" perl-smartchr:sub "sub { `!!' }")))

;; これは、関数定義を楽にしてくれるコマンドです。このように、引数に文字列を返す関数を渡す事も可能です。複数行に渡る文字列を使いたい時に重宝します。 perl-smartchr:subの二行目の空文字列が必須な事にご注意ください。これが無いと"sub..."の文字列がドキュメントとして扱われてしまいます。この辺になると無理やり感がいなめない・・・いや、否めなヶ崎なので yasnippet.el を使う事も検討するのが良いかもしれません。

;; (defun ik:insert-eol (s)
;;   (interactive)
;;   (lexical-let ((s s))
;;     (smartchr-make-struct
;;      :insert-fn (lambda ()
;;                   (save-excursion
;;                     (goto-char (point-at-eol))
;;                     (when (not (string= (char-to-string (preceding-char)) s))
;;                       (insert s))))
;;      :cleanup-fn (lambda ()
;;                    (save-excursion
;;                      (goto-char (point-at-eol))
;;                      (delete-backward-char (length s)))))))

;; (defun ik:insert-semicolon-eol ()
;;   (ik:insert-eol ";"))

;; (global-set-key (kbd "j")
;;                   (smartchr '("j" ik:insert-semicolon-eol)))

;; 最後は、少し内部の実装に踏み込んだ定義方法です。上の定義のように、smartchr 関数の引数には、smartchr-make-struct という関数が返す構造体を渡す事も可能です。(内部的にも、引数の文字列をパースしてからこの関数を使って構造体を作っています) smartchr-make-struct 関数の使い方は簡単です。:insert-fn キーワード引数に入力する動作をする関数、 :cleanup-fn キーワード引数に :insert-fnで渡した関数が行った動作を取り消す関数を渡すと、構造体を返します。この返り値は smartchr関数の引数に使う事ができます。この方法で定義すると柔軟にコマンドを定義する事が可能になります。

;; このコマンドは、j を二回押すと、現在業の最後に";"を挿入します。社内1の変態キーバインディストを自称する私らしいコマンドだと自負しております。

;; まだまだありますが、納まりがつかなくなってしまうので、今回はこの辺で。
;; あとがき

;; さて、駆け足で smartchr.el を説明してきましたが、いかがだったでしょうか。

;; 工夫次第でいくらでも便利なコマンドを簡単に定義できると思うので、興味のある方は是非試してみてください!!!11

;; 実装に関しては closure を効果的に活用したコードになっていて(closureと言ってもプログラミング言語の事ではないですよ!)、本質的な部分は50行くらいで実装されています。ソースはIMAKADOのgithubで公開されているので、興味があったらforkしてhackしてみてください!!

;; このsmartchr.elを使った一行のコマンド定義が、あなたの生産性を上げる大きな一行になったら、とても嬉しいです!!


;;for smarty
(global-set-key (kbd "{") (smartchr '("{" "{$`!!'}" "{{")))











(defvar my-smartchr-minor-mode nil)
;; (setq my-smartchr-minor-mode nil)
(defun my-smartchr-minor-mode ()
  "指定した smartchr.el のキーバインドの有効/無効を切り替えるマイナーモード"
  (interactive)
  (setq my-smartchr-minor-mode (not my-smartchr-minor-mode))
  (cond (my-smartchr-minor-mode
         (global-set-key (kbd "F") 'self-insert-command)
         (global-set-key (kbd ">") 'self-insert-command)
         ;; (global-set-key (kbd "=") 'self-insert-command)
        )
        (t
         (global-set-key (kbd "F") (smartchr '("F" "$" "FF")))
         (global-set-key (kbd ">") (smartchr '(">" ">>"  ">|`!!'|")))
         ;; (global-set-key (kbd "=") (smartchr '("=" " = " " == " " === " "=> ")))         
         )))

(defadvice cua--deactivate-rectangle (before my-cua--deactivate-rectangle ())
  (my-smartchr-minor-mode))
(defadvice cua--activate-rectangle (before my-cua--activate-rectangle ())
  (my-smartchr-minor-mode))
