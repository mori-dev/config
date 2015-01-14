;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; Prefix: ars-:

;; ■ できること
;; --
;; あれこれ
;;
;; cd ~
;; mkdir A
;; mkdir A/{AA,AB}
;; mkdir A/AA/{AAA,AAB,AAC}
;; mkdir A/AB/{ABA,ABB,ABC}
;; mkdir A/AA/AAA/{AAAA,AAAB}
;;
;; あれこれ
;; --

;; こういったバッファ/ファイルから，リージョン選択して C-u C-w することで，そのリージョンからなるシェルスクリプト（の雛形）を生成する。

;; ■ 設定例
;; このファイルをロードパスの通ったところに置き，dot.emacs に以下を追記する。
;; (require 'archive-region-to-shellscript)
;; (setq ars-directory-path "~/bin/")  ;スクリプトを置くディレクトリ
;; (setq ars-shebang-line "#!/bin/sh") ;シェバングの行

;; Code

(defvar ars-directory-path "~/bin/"
  "スクリプトを置くディレクトリ")
(defvar ars-shebang-line "#!/bin/sh"
  "シェバングの行")

(defun archive-region-to-shellscript (s e)
  "リージョンからシェルスクリプトを作成する"
  (interactive "r")
  (let ((str (buffer-substring-no-properties s e))
        (ars-filename (read-file-name
                            "file name: "
                            ars-directory-path)))
      (find-file  ars-filename)
      (goto-char (point-min))
      (insert (concat ars-shebang-line
                      "\n\n"
                      str))))

(defun ars-kill-region-or-archive-region (arg s e)
  "Extend `kill-region' (C-w) to have archive feature.
C-w: `kill-region' (normal C-w)
C-u C-w: `archive-region-to-shellscript' (copy text to new file) / also in kill-ring"
  (interactive "p\nr")
  (case arg
    (1  (kill-region s e))
    (4  (kill-new (buffer-substring s e)) (archive-region-to-shellscript s e))))

(substitute-key-definition 'kill-region 'ars-kill-region-or-archive-region global-map)

(provide 'archive-region-to-shellscript)
