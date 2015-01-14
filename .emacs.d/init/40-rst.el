;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;;http://docutils.sourceforge.net/docs/user/emacs.html

;; セクションタイトル
;;     * C-c C-a または C-=
;; セクション移動と選択
;;     * C-c C-p 前のセクションへ
;;     * C-c C-n 次のセクションへ
;;     * C-c C-m セクションの選択
;; テキストブロックの水平移動
;;     * C-c C-l 選択範囲を左に移動
;;     * C-c C-r 選択範囲を右に移動
;; リスト
;;     * C-c C-e 選択範囲を番号付きリストに
;;     * C-c C-b 選択範囲を記号付きリストに
;;     * C-c C-w 選択範囲のリスト記号をインデントの深さによって揃える
;; ラインブロック
;;     * C-c C-d 選択範囲をラインブロックに
;; コメント
;;     * C-c C-c 選択範囲をコメントに
;; コンバート
;;     * C-c 1 出力ファイルを指定してコンパイルする
;;     * C-c 5 S5スライドにコンバートしてブラウザで表示する
;; 見出し一覧表示
;;     * C-c C-t


(require 'rst)

(set-face-foreground 'rst-level-1-face "Salmon")
(set-face-background 'rst-level-1-face "black")
(set-face-bold-p 'rst-level-1-face t)
(set-face-underline-p 'rst-level-1-face t)
(set-face-foreground 'rst-level-2-face "Salmon")
(set-face-background 'rst-level-2-face "black")
(set-face-bold-p 'rst-level-2-face t)
(set-face-foreground 'rst-level-3-face "white")
(set-face-background 'rst-level-3-face "black")
(set-face-bold-p 'rst-level-3-face t)
(set-face-foreground 'rst-level-4-face "white")
(set-face-background 'rst-level-4-face "black")
(set-face-foreground 'rst-level-5-face "white")
(set-face-background 'rst-level-5-face "black")
(set-face-foreground 'rst-level-6-face "white")
(set-face-background 'rst-level-6-face "black")

(setq frame-background-mode 'dark)
;; http://docutils.sourceforge.net/
(setq auto-mode-alist
      (append '(
                ;; ("\\.txt$" . rst-mode)
                ("\\.rst$" . rst-mode)
                ("\\.rest$" . rst-mode)) auto-mode-alist))

;; (setq auto-mode-alist
;;       (append '(
;;                 ;; ("\\.txt$" . rst-mode)
;;                 ("\\.rst$" . rst-mode)
;;                 ) auto-mode-alist))

(add-hook 'rst-mode-hook
              (lambda ()
                (setq rst-slides-program "open -a Firefox")
                ))


;; rst2html.pyにオプションつけるときは
;; rst-mode-hookに追加するといいかも

;; (add-hook 'rst-mode-hook
;;               (lambda ()
;;                  (setcdr (assq 'html rst-compile-toolsets)
;;                          '("rst2html.py" ".html"
;;                            "--stylesheet=\"default.css\" --link-stylesheet"))))

(setq rst-compile-toolsets
  '((html . ("rst2html" ".html" nil))
    (latex . ("rst2latex" ".tex" nil))
    (newlatex . ("rst2newlatex" ".tex" nil))
    (pseudoxml . ("rst2pseudoxml" ".xml" nil))
    (xml . ("rst2xml" ".xml" nil)))
)