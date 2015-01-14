;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; 参考 URL http://d.hatena.ne.jp/rubikitch/20090121/1232468026

(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.txt\\'" . org-mode))

;; 2.3 Visibility cycling（2.3 表示の切り替え）
;; TAB	サブツリーの表示の状態を切り替えます。
;; S-TABまたはC-u TAB	グローバルサイクル：バッファ全体の状態を変更する
;;     ,-> 概観表示 ->内容表示 -> 全部表示L --.
;;     '---------------------------------'
;; C-c C-a org-attach	全てを表示
;; C-c C-r org-reveal	現在の項目や、下の見出しや上の階層を表示して、その場所での文脈を表示します。
;; C-c C-n outline-next-visible-heading	次の見出しへ
;; C-c C-p outline-previous-visible-heading 	前の見出しへ
;; C-c C-f outline-forward-same-level	次の同一階層の見出しへ
;; C-c C-b outline-backward-same-level	前の同一階層の見出しへ
;; C-c C-u outline-up-heading	ひとつ上の階層の見出しに戻る
;; C-c C-j org-goto	その時点でのアウトラインの表示・非表示の状況を維持しながら

;; (suppress-keymap org-goto-map)
;;デフォルトのキーバインドを無効にする。
(add-hook 'org-mode-hook
  (lambda()
    (setq org-goto-map (make-keymap))
    (setq org-agenda-mode-map (make-keymap))
    (setq org-cdlatex-mode-map (make-keymap))
    (setq org-exit-edit-mode-map (make-keymap))
    (setq org-goto-local-auto-isearch-map (make-keymap))
    (setq org-mode-map (make-keymap))
    (setq org-mouse-map (make-keymap))
    (setq orgstruct-mode-map (make-keymap))
    (setq my-org-mode-map (make-keymap))
    (use-local-map my-org-mode-map)
    (define-key my-org-mode-map (kbd "TAB") 'org-cycle)
    (define-key my-org-mode-map (kbd "C-c C-a") 'org-attach) ; 全てを表示
    (define-key my-org-mode-map (kbd "C-c C-r") 'org-reveal) ; 現在の項目や、下の見出しや上の階層を表示して、その場所での文脈を表示
    (define-key my-org-mode-map (kbd "C-c C-n") 'outline-next-visible-heading) ; 次の見出しへ
    (define-key my-org-mode-map (kbd "C-c C-p") 'outline-previous-visible-heading) ; 前の見出しへ
    (define-key my-org-mode-map (kbd "C-c C-f") 'outline-forward-same-level) ; 次の同一階層の見出しへ
    (define-key my-org-mode-map (kbd "C-c C-b") 'outline-backward-same-level) ; 前の同一階層の見出しへ
    (define-key my-org-mode-map (kbd "C-c C-u") 'outline-up-heading) ; ひとつ上の階層の見出しに戻る
    (define-key my-org-mode-map (kbd "C-c C-j") 'org-goto)
; その時点でのアウトラインの表示・非表示の状況を維持しながらその時点でのアウトラインの表示・非表示の状況を維持しながら別の場所に移動します。
; 一時的なバッファで文書の構造を表示し、＜TAB＞を押すことで（その項目の）表示・非表示を切り替えて、目的の行を探します。
;そして＜RET＞を押すことでカーソルはオリジナルのバッファの選択した位置へ移動し、
;（それ以外の場所の表示・非表示の状況は維持しながら）移動した場所の見出しは表示された状態になります。
    ;; <M-return>	org-meta-return
    (define-key my-org-mode-map (kbd "<M-return>") 'org-meta-return)
    ;; (define-key my-org-mode-map (kbd "M-\+") 'org-metaright)
    ;; (define-key my-org-mode-map (kbd "M--") 'org-metaleft)
;; <M-left>  	org-metaleft
;; <M-return>	org-meta-return
;; <M-right> 	org-metaright
    
    ;; (define-key my-org-mode-map (kbd "") ')
    ;; (define-key my-org-mode-map (kbd "") ')    
    ;; (define-key my-org-mode-map (kbd "") ')
    ;; (define-key my-org-mode-map (kbd "") ')
	)
  )




;; Major Mode Bindings:
;; C-c       	Prefix Command
;; C-j       	org-return-indent
;; C-k       	org-kill-line
;; RET       	org-return
;; C-y       	org-yank
;; ESC       	Prefix Command
;; [         	??
;; |         	org-force-self-insert
;; C-#       	org-table-rotate-recalc-marks
;; C-'       	org-cycle-agenda-files
;; <C-S-left>	org-shiftcontrolleft
;; <C-S-return>	org-insert-todo-heading-respect-content
;; <C-S-right>	org-shiftcontrolright
;; <M-S-down>	org-shiftmetadown
;; <M-S-left>	org-shiftmetaleft
;; <M-S-return>	org-insert-todo-heading
;; <M-S-right>	org-shiftmetaright
;; <M-S-up>  	org-shiftmetaup
;; <M-down>  	org-metadown
;; <M-left>  	org-metaleft
;; <M-return>	org-meta-return
;; <M-right> 	org-metaright
;; <M-tab>   	org-complete
;; <M-up>    	org-metaup
;; <S-down>  	org-shiftdown
;; <S-iso-lefttab>	org-shifttab
;; <S-left>  	org-shiftleft
;; <S-return>	org-table-copy-down
;; <S-right> 	org-shiftright
;; <S-tab>   	org-shifttab
;; <S-up>    	org-shiftup
;; <backtab> 	org-shifttab
;; <remap>   	Prefix Command
;; <tab>     	org-cycle
;; <remap> <delete-backward-char>	org-delete-backward-char
;; <remap> <delete-char>	org-delete-char
;; <remap> <self-insert-command>	org-self-insert-command
;; M-TAB     	org-complete
;; M-RET     	org-insert-heading
;; C-c C-a   	org-attach
;; C-c C-b   	outline-backward-same-level
;; C-c C-c   	org-ctrl-c-ctrl-c
;; C-c C-d   	org-deadline
;; C-c C-e   	org-export
;; C-c C-f   	outline-forward-same-level
;; C-c TAB   	show-children
;; C-c C-j   	org-goto
;; C-c C-l   	org-insert-link
;; C-c RET   	org-ctrl-c-ret
;; C-c C-n   	outline-next-visible-heading




;; 別の場所に移動します。
;; 一時的なバッファで文書の構造を表示し、
;; ＜TAB＞を押すことで（その項目の）表示・非表示を切り替えて、
;; 目的の行を探します。
;; そして＜RET＞を押すことでカーソルはオリジナルのバッファの
;; 選択した位置へ移動し、（それ以外の場所の表示・非表示の状況は維持しながら）
;; 移動した場所の見出しは表示された状態になります。

;;デフォルトのキーバインドを無効にする。
;; (add-hook 'org-mode-hook
;;   (lambda()
;;     (setq org-goto-map (make-keymap))
;;     (setq org-agenda-mode-map (make-keymap))
;;     (setq org-cdlatex-mode-map (make-keymap))
;;     (setq org-exit-edit-mode-map (make-keymap))
;;     (setq org-goto-local-auto-isearch-map (make-keymap))
;;     (setq org-mode-map (make-keymap))
;;     (setq org-mouse-map (make-keymap))
;;     (setq orgstruct-mode-map (make-keymap))
;;     (setq my-org-mode-map (make-keymap))
;;     (use-local-map my-org-mode-map)
;;     (define-key my-org-mode-map (kbd "TAB") 'org-cycle)
;; ))

;; (setq org-startup-truncated nil)
;; (setq org-return-follows-link t)
;; (add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(org-remember-insinuate)
(setq org-directory "~/Dropbox/memo")
(setq org-default-notes-file (expand-file-name "memo.org" org-directory))

(setq org-remember-templates
      '(("Dino" ?d "** %?\n    %i\n   %a\n   %t" "~/Dropbox/memo/dino.org" "Inbox")
        ("Note" ?n "** %?\n    %i\n   %a\n   %t" nil "Inbox")
        ("Todo" ?t "** TODO %?\n   %i\n   %a\n   %t" nil "Inbox")
        ;; ("Idea" ?i "** %?\n   %i\n   %a\n   %t" nil "New Ideas")
        ))

(eval-after-load "key-chord"
  '(progn
     (key-chord-define-global "39" 'org-remember)))



;; ;; コードリーディング用

;; (defvar org-code-reading-software-name nil)
;; ;; ~/memo/code-reading.org に記録する
;; (defvar org-code-reading-file "code-reading.org")
;; (defun org-code-reading-read-software-name ()
;;   (set (make-local-variable 'org-code-reading-software-name)
;;        (read-string "Code Reading Software: "
;;                     (or org-code-reading-software-name
;;                         (file-name-nondirectory
;;                          (buffer-file-name))))))

;; (defun org-code-reading-get-prefix (lang)
;;   (concat "[" lang "]"
;;           "[" (org-code-reading-read-software-name) "]"))
;; (defun org-remember-code-reading ()
;;   (interactive)
;;   (let* ((prefix (org-code-reading-get-prefix (substring (symbol-name major-mode) 0 -5)))
;;          (org-remember-templates
;;           `(("CodeReading" ?r "** %(identity prefix)%?\n   \n   %a\n   %t"
;;              ,org-code-reading-file "Memo"))))
;;     (org-remember)))
