;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

(require 'cua-base)
(cua-mode t)
(setq cua-enable-cua-keys nil)

;; | キーバインド | 説明
;; | M-b          | 矩形をスペースで埋める
;; | M-f          | 矩形を入力された1文字で埋める
;; | M-i          | 矩形の各行の数値をインクリメントする
;; | M-k          | 矩形をキルする
;; | M-n          | 矩形の各行にインクリメントされた数値をフォーマットして挿入する
;; | M-r          | 矩形を置換する
;; | M-t          | 矩形を入力された文字列で埋める
;; | M-|          | 矩形を入力としてシェルコマンドを実行する。引数が指定されている場合はシェルコマンドの結果が矩形に埋まる
;; | M-/          | 矩形の正規表現にマッチする行をハイライト

;; どのコマンドも便利なのですが、この中では特にM-nが便利だと思います。M-nを使えば矩形内に特定のフォーマットに従って連番をふることができます。例えば0から+1していく連番をふる場合はM-n 0 RET 1 RET %d RETですし、0から+1していく16進数の連番はM-n 0 RET 1 RET %x RETです。

;; 例えばfoo1からfoo9という名前を一覧するケースを考えてみましょう。まずC-u 10 RETして10個の改行を挿入します。次に最初の行でC-RETして最後の行までカーソルを移動します。

;; そしてM-nします。最初に開始値1を入力します。次にインクリメント値1を入力します。最後にフォーマットを入力します。ここではfoo%dと入力します。このフォーマットはformat関数で使えるものである必要があります。次に示すのがその結果です。

;; これが矩形選択内で使えるので、例えばデータを作る場合などで重宝すると思います。

(defadvice cua-sequence-rectangle (around my-cua-sequence-rectangle activate)
;;(defun cua-sequence-rectangle (first incr format)
  "Resequence each line of CUA rectangle starting from FIRST.
The numbers are formatted according to the FORMAT string."
  (interactive
   (list (if current-prefix-arg
             (prefix-numeric-value current-prefix-arg)
           (string-to-number
            (read-string "Start value: (0) " nil nil "0")))
         (string-to-number
          (read-string "Increment: (1) " nil nil "1"))
         (read-string (concat "Format: (" cua--rectangle-seq-format ") "))))
  (if (= (length format) 0)
      (setq format cua--rectangle-seq-format)
    (setq cua--rectangle-seq-format format))
  (cua--rectangle-operation 'clear nil t 1 nil
     '(lambda (s e l r)
         (kill-region s e)
         (insert (format format first))
         (yank)
         (setq first (+ first incr)))))