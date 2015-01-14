;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; 変更があった部分をハイライトする
(global-highlight-changes-mode t)
(setq highlight-changes-visibility-initial-state nil)
;; モードラインに-Chgと表示しない だめ?
(setq highlight-changes-visible-string "")

(defalias 'c 'highlight-changes-visible-mode)
;; ;; 変更部分を可視化/不可視化のトグル
;; (global-set-key (kbd "H-v") 'highlight-changes-visible-mode)

;; ;; 変更部分を削除
;; (global-set-key (kbd "H-i") 'highlight-changes-remove-highlight)

;; ;;次の変更箇所移動
;; (global-set-key (kbd "H-n") 'highlight-changes-next-change)

;; ;;前の変更箇所に移動
;; (global-set-key (kbd "H-p") 'highlight-changes-previous-change)

;; Another interesting thing you can do is M-x highlight-compare-with-file.
;; The only remaining problem with highlight-changes-mode is that the default colors are, well, hideous. But of course, that can easily be fixed by changing the faces:

;; (set-face-foreground 'highlight-changes nil)
;; (set-face-background 'highlight-changes "#382f2f")
;; (set-face-foreground 'highlight-changes-delete nil)
;; (set-face-background 'highlight-changes-delete "#916868")

;; Or adding to your color-scheme:

;; (highlight-changes ((t (:foreground nil :background "#382f2f"))))
;; (highlight-changes-delete ((t (:foreground nil :background "#916868")))) 
