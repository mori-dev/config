(require 'grep)
(require 'grep-edit)

(defadvice grep-edit-change-file (around inhibit-read-only activate)
  ""
  (let ((inhibit-read-only t))
    ad-do-it))
;; (progn (ad-disable-advice 'grep-edit-change-file 'around 'inhibit-read-only) (ad-update 'grep-edit-change-file)) 

(defun my-grep-edit-setup ()
  (define-key grep-mode-map '[up] nil)
  (define-key grep-mode-map "\C-c\C-c" 'grep-edit-finish-edit)
  (message (substitute-command-keys "\\[grep-edit-finish-edit] to apply changes."))
  (set (make-local-variable 'inhibit-read-only) t)
  )
(add-hook 'grep-setup-hook 'my-grep-edit-setup t)

;; ** rubikitch さんいわく..
;; buffer-read-onlyでハネられたら嫌なので置換時にinhibit-read-onlyをセットしておく。
;; そして、C-c C-cで編集終了したいからそう設定しておく。行へ飛ぶのはEnterで。
;; grepの結果から探索する目的にはそのうち公開予定のanything-grep.elを使っている。
;; anything.elだと絞り込みができるからね。*grep*バッファは専らgrep-edit.el専用となっている。
;; dmoccurやmoccur-edit等はあまり使わないな。せっかくgrepやgrep-editがあるんだからそっちのほうが速い。
