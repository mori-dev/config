;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; 参考 http://d.hatena.ne.jp/antipop/20080315/1205604544
;;      http://blog.clouder.jp/archives/001037.html
;;      http://d.hatena.ne.jp/gan2/20080402/1207135480
;; メモ
;;~/.emacs.d/elisp/yasnippet/text-mode/snippets/mysnippets に個人用ファイルを配置したした


(require 'yasnippet)
(yas/initialize)

;; (defun yas/load-all-directories ()
;;   (interactive)
;;   (yas/reload-all)
;;   (mapc 'yas/load-directory-1 my-snippet-directories))

;; (when (require 'yasnippet nil t)
;;   (setq yas/root-directory (expand-file-name "~/Dropbox/yasnippet/my-snippets"))
;;   (defvar my-snippet-directories
;;     (list (expand-file-name "~/Dropbox/yasnippet/my-snippets")))
;;   (yas/initialize)
;;   (yas/load-all-directories))

(yas/load-directory "~/Dropbox/yasnippet/")

(set-face-foreground 'yas/field-highlight-face "coral")
(set-face-background 'yas/field-highlight-face "black")
(set-face-underline-p 'yas/field-highlight-face t)

;;; yasnippet展開中はflymakeを無効にする
(defvar flymake-is-active-flag nil)
(defadvice yas/expand-snippet
  (before inhibit-flymake-syntax-checking-while-expanding-snippet activate)
  (setq flymake-is-active-flag
        (or flymake-is-active-flag
            (assoc-default 'flymake-mode (buffer-local-variables))))
  (when flymake-is-active-flag
    (flymake-mode-off)))
(add-hook 'yas/after-exit-snippet-hook
           (lambda ()
             (when flymake-is-active-flag
               (flymake-mode-on)
               (setq flymake-is-active-flag nil))))

;; トリガはSPC, 次の候補への移動はTAB
;(setq yas/trigger-key (kbd "SPC"))
;(setq yas/next-field-key (kbd "TAB"))
(setq yas/next-field-key nil)


;; コメントやリテラルではスニペットを展開しない
(setq yas/buffer-local-condition
      '(or (not (or (string= "font-lock-comment-face"
                             (get-char-property (point) 'face))
                    (string= "font-lock-string-face"
                             (get-char-property (point) 'face))))
           '(require-snippet-condition . force-in-comment)))

;; yasnippet の anything インターフェース anything-c-yasnippet
;; http://d.hatena.ne.jp/IMAKADO/20080324/1206370301
(require 'anything-c-yasnippet)
(setq anything-c-yas-space-match-any-greedy t) ;スペース区切りで絞り込めるようにする デフォルトは nil
;(global-set-key (kbd "C-c y") 'anything-c-yas-opt-complete) ;C-c yで起動
(setq anything-c-yas-snippets-dir-list nil)

(add-to-list 'anything-c-yas-snippets-dir-list "~/Dropbox/yasnippet/")
(add-to-list 'anything-c-yas-snippets-dir-list "~/Dropbox/yasnippet/my-snippets/css-mode/")
(add-to-list 'anything-c-yas-snippets-dir-list "~/Dropbox/yasnippet/my-snippets/html-mode/")
(add-to-list 'anything-c-yas-snippets-dir-list "~/Dropbox/yasnippet/my-snippets/javascript-mode/")
(add-to-list 'anything-c-yas-snippets-dir-list "~/Dropbox/yasnippet/my-snippets/js2-mode/")
(add-to-list 'anything-c-yas-snippets-dir-list "~/Dropbox/yasnippet/my-snippets/lisp-interaction-mode/")
(add-to-list 'anything-c-yas-snippets-dir-list "~/Dropbox/yasnippet/my-snippets/php-mode/")
(add-to-list 'anything-c-yas-snippets-dir-list "~/Dropbox/yasnippet/my-snippets/lisp-mode/")
(add-to-list 'anything-c-yas-snippets-dir-list "~/Dropbox/yasnippet/my-snippets/sh-mode/")
(add-to-list 'anything-c-yas-snippets-dir-list "~/Dropbox/yasnippet/my-snippets/emacs-lisp-mode/")
(add-to-list 'anything-c-yas-snippets-dir-list "~/Dropbox/yasnippet/my-snippets/ruby-mode/")
(add-to-list 'anything-c-yas-snippets-dir-list "~/Dropbox/yasnippet/my-snippets/sql-interactive-mode/")
(add-to-list 'anything-c-yas-snippets-dir-list "~/Dropbox/yasnippet/my-snippets/python-mode/")
(add-to-list 'anything-c-yas-snippets-dir-list "~/Dropbox/yasnippet/my-snippets/org-mode/")
(add-to-list 'anything-c-yas-snippets-dir-list "~/Dropbox/yasnippet/my-snippets/rhtml-mode/")
(add-to-list 'anything-c-yas-snippets-dir-list "~/Dropbox/yasnippet/my-snippets/howm-mode/")
(add-to-list 'anything-c-yas-snippets-dir-list "~/Dropbox/yasnippet/my-snippets/markdown-mode/")


(global-set-key (kbd "M-2") 'anything-c-yas-opt-complete)
