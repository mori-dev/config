
;; 準備
;; rvm 1.9.1
;; gem install rcodetools
;; rvm 1.8.7
;; gem install rcodetools

(require 'rcodetools)
(setq rct-find-tag-if-available nil)

(defun make-ruby-scratch-buffer ()
  (with-current-buffer (get-buffer-create "*ruby scratch*")
    (ruby-mode)
    (current-buffer)))

(defun ruby-scratch ()
  (interactive)
  (switch-to-buffer (make-ruby-scratch-buffer)))

(global-set-key [(meta f12)] 'ruby-scratch)

(defun ruby-mode-hook-rcodetools ()
  (define-key ruby-mode-map "\M-\C-i" 'rct-complete-symbol)
  (define-key ruby-mode-map "\C-c\C-t" 'ruby-toggle-buffer)
  (define-key ruby-mode-map "\C-c\C-d" 'xmp)
  (define-key ruby-mode-map "\C-c\C-f" 'rct-ri))

(add-hook 'ruby-mode-hook 'ruby-mode-hook-rcodetools)


;; この種のフィルタがEmacs で使えると大変便利です．まず，M-x ruby-scratch を実行し，
;; *rubyscratch* バッファを出します．次にリスト10 を貼り付けます．その後C-c C-d を押
;; します．すると，リスト11のように結果が出ます（図6）．嬉しいことにポイントの画面上の位置はその
;; ままです．“#=>” マークは M-; M-; （comment-dwimを2回） で付けられます．外す場合
;; はC-u M-;を実行します．

;; xmpfilter は，式の値以外にも Test::Unit や，RSpec の assertion を生成で
;; きます．どれを生成するかは Emacs がファイルの内容に応じて決定します．

;; irb よりも優れた xmpfilter

;; このようにxmpfilterはRubyの機能の実験には打って付けのツールです．rubyist にとって
;; 実験と言えば即座にirbを思い浮かべるでしょう．xmpfilterは，irbよりも次のような点で優
;; れています．


;; - 1 行単位ではなくてスクリプト全体を実行
;; - 一度に複数個所の実行結果を得ることが可能
;; - スクリプトを変更したらすべての実行結果を再計算
;; - xmpfilter の出力もRuby スクリプト

;; irb を1 次元（1 行）とするとxmpfilter は2 次元（複数行）です．irbの場合，条件
;; を変えて再計算するときは，再びすべての行を入力しなければなりません．xmpfilter の場
;; 合は，変更したときに一瞬ですべての結果がわかります．

;; 最後の「出力もRubyスクリプト」という点は意外に重要です．xmpfilter は，元々
;; Mauricio Fernandez 氏がメーリングリストの投稿をわかりやすくするために開発しました．
;; よって xmpfilter を使わずに Ruby 式の実行結果を記録するには，irb のログを貼り
;; 付けたり，スクリプトと実行結果を別々に書かなければなりませんでした．
;; 前者の場合は，irb の入力部分を切り出してからスクリプトにする必要があります．一方後者
;; の場合は，式とそれに対応する結果を探す必要があります．xmpfilter はその面倒から解
;; 放してくれます注4．



;; ruby-toggle-file

;; ruby-toggle-file は，RubyGems や Rails の慣例に従ったテストスクリプトと実装
;; スクリプトの対応物を出力するスクリプトです．たとえば，テストスクリプトからは実装スクリプト，実
;; 装スクリプトからはテストスクリプトを返します．

;; ディレクトリ構成

;; setup.rbやRubyGemsは，図7 のようなディレクトリ構成でパッケージングします．
;; ruby-toggle-file は，このディレクトリ構成に則って実装スクリプトとテストスクリプトの対
;; 応を取ります．

;; package root
;;   test テストスクリプト
;;   bin 実行可能スクリプト
;;   lib ライブラリ（実装スクリプト）


;; テスト⇔実装の素早い切り替え

;; テスト駆動開発では，ひんぱんにテストスクリプトと実装スクリプトを切り換えます．その際，バッファ
;; 名を入力して切り換えるのは面倒です．効率良くテスト駆動開発をするには，切り換えの手間
;; は最小限である必要があります．Emacsでは，C-c C-tを押すと切り換えることができます．
;; 対応するファイルが存在しない場合は，新規にバッファを作成します．

;; テスト駆動補完

;; 前述したようにrct-completeによる補完には，カバレッジ問題と副作用問題があります．し
;; かし，この欠点はテストメソッドで実装メソッドを呼ぶことで解決します．副作用のあるメソッドのテ
;; ストは副作用の後片付けをするためです．テスト駆動開発の手順でテストメソッドを書いたとき，
;; C-c C-t で実装スクリプトへ切り換え，実装スクリプトを書いてみましょう．そこで補完してみる
;; と，補完できているはずです（図8 ～ 10）．テスト駆動開発では，テスト→実装へ切り換える直
;; 前に実装メソッドに対応するテストメソッドを書いています．実は実装スクリプトのバッファで
;; M-Tab を押した時点で，テストスクリプトのファイル名と行番号を rct-complete に渡して
;; います．よってテストメソッド経由で補完ができるのです．逆に言うと，実装スクリプトで補完するに
;; は，対応するテストメソッドにポイントを置く必要があります．この補完方法はテスト駆動開発との
;; 親和性がとても高く，筆者は「テスト駆動補完」と呼んでいます．
