;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

(global-set-key (kbd "C-1") 'delete-other-windows)
(global-set-key (kbd "C-M-;") 'comment-dwim)
(global-set-key (kbd "C-t") 'scroll-down)
(global-set-key (kbd "C-M-f") 'forward-word)
(global-set-key (kbd "M-f") 'my-forward-to-word)
(global-set-key (kbd "M-<f12>") 'my-fullscreen)
(global-set-key (kbd "<f11>") nil)


(defun zwei-backward-up-list (&optional arg)
  "Move up one level of list structure, backward.
Also, if called inside of a string, moves back up out of that string."
  (interactive "^p")
  (up-list-or-string (- (or arg 1))))

(defun up-list-or-string (&optional arg)
  (interactive "^p")
  (or arg (setq arg 1))
  (let ((inc (if (> arg 0) 1 -1))
        (in-string-p (in-string-p)))
    (cond (in-string-p
            (search-backward (char-to-string in-string-p))
            (setq arg (- arg inc))
            nil)
          ('T (while (/= arg 0)
                (goto-char (or (scan-lists (point) inc 1) (buffer-end arg)))
                (setq arg (- arg inc)))))))

(define-key global-map [(control meta ?u)] 'zwei-backward-up-list)

(defun down-list-or-string (&optional arg)
  (interactive "^p")
  (or arg (setq arg 1))
  (let ((inc (if (> arg 0) 1 -1))
        (in-string-p (in-string-p)))
    (cond (in-string-p
           (search-forward (char-to-string in-string-p))
           (setq arg (- arg inc))
           nil)
          ('T (while (/= arg 0)
                (goto-char (or (scan-lists (point) inc -1) (buffer-end arg)))
                (setq arg (- arg inc)))))))

(global-set-key (kbd "C-M-d") 'down-list-or-string)


;(global-set-key "\C-x:" 'uncomment-region)が空いている。

(defun my-format-paren ()
  (interactive)
  (if (thing-at-point-looking-at "(")
      (save-excursion
        (mark-sexp)
        (replace-regexp "[ \n]*)" ")" nil (region-beginning) (region-end)))))

(defadvice indent-pp-sexp (before my-indent-pp-sexp activate)
  (my-format-paren))

(global-set-key (kbd "C-c C-M-q") 'my-format-paren)

;; (global-set-key (kbd "＊") (lambda () (insert "*") ))
;; (global-set-key (kbd "3") (kbd "4"))

;; ダブルクオート，クオートを入力しやすくする

(global-set-key (kbd "C-9") (defun my-insert-double-quote () (interactive) (insert "\"")))
(global-set-key (kbd "C-0") (defun my-insert-single-quote () (interactive) (insert "\'")))
(global-set-key (kbd "C-7") (defun my-insert-back-quote () (interactive) (insert "\`")))
;; (global-set-key (kbd "C-6") (defun my-insert-back-quote () (interactive) (insert "&")))
;; (global-set-key (kbd "C-@") (defun my-insert-_ () (interactive) (insert "_")))
;; (global-set-key (kbd "C-4") (defun my-insert-back-quote () (interactive) (insert "$")))
;; (global-set-key (kbd "C-:") (defun my-insert-back-quote () (interactive) (insert "_")))

(global-set-key (kbd "C-x C-h") 'mark-whole-buffer)

(global-set-key (kbd "C-M-/") 'redo)
(global-set-key (kbd "C-?") 'redo)

(defun delete-word (arg)
  "Delete characters forward until encountering the end of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (forward-word arg) (point))))

(defun backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-word (- arg)))

(global-set-key (kbd "M-/") 'backward-delete-word)

(defun my-increase-tab-width ()
  (interactive)
  (setq tab-width (+ tab-width 1)))

(defun my-decrease-tab-width ()
  (interactive)
  (when (< 1 tab-width)
    (setq tab-width (- tab-width  ))))

(global-set-key (kbd "S-<right>") 'my-increase-tab-width)
(global-set-key (kbd "S-<left>") 'my-decrease-tab-width)


;; RET時にインデントする
;; (define-key map "\r" 'ac-complete)
;; (define-key lisp-interaction-mode-map (kbd "RET") 'newline-and-indent)
;; (define-key emacs-lisp-mode-map (kbd "RET") 'newline-and-indent)
;; (define-key lisp-mode-map (kbd "RET") 'newline-and-indent)
;; (global-set-key (kbd "RET") 'newline)
;(global-set-key [f5] 'recenter)
;(global-set-key [f5] 'revert-buffer)
(global-set-key [f12] 'delete-other-windows) ;selected-window 以外を削除. C-x 0 delete-window
;; (global-set-key [(meta f2)] 'newline)

;; M-m の逆
(global-set-key (kbd "C-M-m") (lambda () (interactive) (skip-syntax-backward " ")))

;; (global-set-key (kbd "C-M-v") '(lambda () (interactive) (scroll-other-window -1)))
;; (global-set-key (kbd "C-M-V") '(lambda () (interactive) (scroll-other-window -1)))

;; (global-set-key [(control tab)] 'shk-tabbar-next)
;; (global-set-key [(control shift tab)] 'shk-tabbar-prev)

;;ファイルの先頭/末尾へ移動する
;; (global-set-key (kbd "C-<") 'beginning-of-buffer-mark)
;; (global-set-key (kbd "C->") 'end-of-buffer-mark)
;;(global-set-key (kbd "M-,") 'beginning-of-buffer-mark)
;;(global-set-key (kbd "M-.") 'end-of-buffer-mark)
;;(global-set-key (kbd "C-M-,") 'beginning-of-buffer-mark)
;;(global-set-key (kbd "C-M-.") 'end-of-buffer-mark)

;C-return を return とみなす
(global-set-key (kbd "<C-return>") (kbd "<return>"))
(global-set-key (kbd "RET") 'newline-and-indent)

;; 誤操作対策
(global-set-key (kbd "C-8") "(")
;(global-set-key [left] ")")

;; (defun php-indent-formater ()
;;   (interactive)
;;   (delete-horizontal-space)
;;   (indent-relative))

;; (global-set-key (kbd "C-c C-k") 'php-indent-formater)
;; pointから行頭までを削除

(defun my-kill-line0 ()
  (interactive)
  (if (eq real-last-command this-command)
      (delete-backward-char 1)
    (kill-line 0)))

(global-set-key (kbd "C-c k") 'my-kill-line0)
(global-set-key (kbd "C-c C-k") 'my-kill-line0)

(global-set-key (kbd "C-c C-l") (lambda () (interactive) (setq truncate-lines (not truncate-lines))))
;; comment/uncomment-regeon
;;(setq truncate-lines (not truncate-lines)) (setq truncate-lines (not truncate-lines)) (setq truncate-lines (not truncate-lines)) (setq truncate-lines (not truncate-lines)) 

;; http://d.hatena.ne.jp/l1o0/20100201/1265030713
;; 行末に飛ぶ。連続で実行したときは、後ろについている空白とタブを削除
(defun my-end-of-line ()
  (interactive)
  (end-of-line)
  (if (eq real-last-command this-command)
      (delete-horizontal-space)))

(global-set-key "\C-e" 'my-end-of-line)


;(global-set-key "\C-x;" 'comment-region)
;(global-set-key "\C-x:" 'uncomment-region)
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "C-S-n") (lambda () (interactive) (next-line 3)))
(global-set-key (kbd "C-S-p") (lambda () (interactive) (next-line -3)))
(global-set-key (kbd "C-M-f") 'forward-word)
(global-set-key (kbd "C-M-b") 'backward-word)
(global-set-key (kbd "C-M-l") 'backward-kill-sexp)
(global-set-key (kbd "C-M-w") 'kill-ring-save)
(global-set-key (kbd "M-f") 'forward-word)
(global-set-key (kbd "M-b") 'backward-word)
;; (global-set-key (kbd "M-f") 'forward-sexp)
;; (global-set-key (kbd "M-b") 'backward-sexp)
(global-set-key (kbd "M-SPC") 'mark-sexp)
;; (global-set-key (kbd "M-h") 'mark-defun)
(global-set-key (kbd "C-M-h") 'mark-paragraph)
(global-set-key (kbd "C-h") 'delete-backward-char)

(define-key global-map (kbd "C-S-h") 'my-delete-backward-char*2)

(defun my-delete-backward-char*2()
  (interactive)
  (delete-backward-char 2))

(define-key isearch-mode-map "\C-h" 'isearch-delete-char) ; migemo 利用時もミニバッファでC-hでBS
(define-key isearch-mode-map "\C-h" 'delete-backward-char)
;(define-key global-map "\C-x\C-h" 'help-command) ; C-h に割り当てられている関数を変更



(defun my-move-beginning-of-line ()
  (interactive)
  (if (bolp)
      (back-to-indentation)
      (beginning-of-line)))

(global-set-key (kbd "C-a") 'my-move-beginning-of-line)

;; (defun forward-word+1 ()
;;   "forward-word で単語の先頭へ移動する"
;;   (interactive)
;;   (forward-word)
;;   (forward-char))

;;http://stackoverflow.com/questions/1771102/changing-emacs-forward-word-behaviour
(require 'misc)


(defun forward-word+1 ()
  "forward-word で単語の先頭へ移動する"
  (interactive)
  (forward-to-word 1))

(defun my-forward-to-word (arg)
  (interactive "p")
  (or (re-search-forward (if (> arg 0) "\\(\\W\\b\\|.$\\)" "\\b\\W") nil t arg)
      (goto-char (if (> arg 0) (point-max) (point-min)))))

(global-set-key (kbd "C-M-f") 'my-forward-to-word)

;; (defun forward-to-word (arg)
;;   "Move forward until encountering the beginning of a word
;; With argument, do this that many times."
;;   (interactive "p")
;;   (or (re-search-forward (if (> arg 0) "\\(\\W\\b\\)\\|\\(.$\\)" "\\b\\W") nil t arg)
;;       (goto-char (if (> arg 0) (point-max) (point-min)))))

;; (defun forward-to-word (arg)
;;   "Move forward until encountering the beginning of a word.
;; With argument, do this that many times."
;;   (interactive "p")
;;   (or (re-search-forward (if (> arg 0) "\\W\\b" "\\b\\W") nil t arg)
;;       (goto-char (if (> arg 0) (point-max) (point-min)))))
;(global-set-key (kbd "C-M-f") 'forward-word+1)

;;M-fはforward-wordのままにするなら、次のようにも書けます。
;(global-set-key (kbd "C-M-f") (kbd "M-f C-f"))

;; (defun kill-word+1 ()
;;   "kill-word で単語の先頭へ移動する"
;;   (interactive)
;;   (kill-word 1)
;;   ;; (delete-char 1)
;;   )
;;   sdaf
;; (global-set-key (kbd "M-d") 'kill-word+1)
;; (global-set-key (kbd "C-M-d") 'kill-word+1)


;; (global-set-key [\C-home] 'beginning-of-buffer)
;; (global-set-key [\C-end] 'end-of-buffer)

(defun my-pp-macroexpand-last-sexp ()
  (interactive)
  (if (thing-at-point-looking-at "\(")
      (save-excursion
        (forward-list)
        (pp-macroexpand-last-sexp nil))
    (pp-macroexpand-last-sexp nil)))

(add-hook 'lisp-interaction-mode-hook
          (lambda() (define-key lisp-interaction-mode-map (kbd "C-c RET") 'my-pp-macroexpand-last-sexp)))
(add-hook 'emacs-lisp-mode-hook
          (lambda() (define-key emacs-lisp-mode-map (kbd "C-c RET") 'my-pp-macroexpand-last-sexp)))


;; http://d.hatena.ne.jp/buzztaiki/20071117/1195293715
;; C-xC-eでdefvar, defcustomの値を設定しなおす
(defun eval-last-sexp-force (eval-last-sexp-arg-internal)
  "Do `eval-last-sexp', but force bound variable to symbol, if
previous form is `defvar' or `defcustom'."
  (interactive "P")
  (save-excursion
    (with-syntax-table emacs-lisp-mode-syntax-table
      (backward-sexp 1)
      (let ((form (read (current-buffer))))
	(when (and (memq (car form) '(defvar defcustom)))
	  (makunbound (cadr form))))))
  (eval-last-sexp eval-last-sexp-arg-internal))

;;(global-set-key "\C-x\C-e" 'eval-last-sexp-force)

(defun my-eval-last-sexp-force ()
  (interactive)
  (if (thing-at-point-looking-at "\(")
    (progn
      (save-excursion
        (forward-list)
        ;; (eval-last-sexp nil)))
        (eval-last-sexp-force nil)))        
    (eval-last-sexp nil)))

(global-set-key (kbd "C-x C-e") 'my-eval-last-sexp-force)

;; tab で補完
(define-key read-expression-map (kbd "TAB") 'lisp-complete-symbol)


;(show-paren-mode t) 
;(minibuffer-electric-default-mode &optional arg
;; template
;(global-unset-key (kbd "<f8>"))
;; (global-set-key (kbd "<f2>")   'cmd)   ; F2 key
;; (global-set-key (kbd "<kp-2>") 'cmd)   ; the “2” key on the number keypad
;; (global-set-key [?\S-\ ] 'toggle-input-method) ;Shift+Space
;; (global-set-key (kbd "<insert>") 'cmd) ; the Ins key
;; (global-set-key (kbd "<delete>") 'cmd) ; the Del key
;; (global-set-key (kbd "<home>") 'cmd)
;; (global-set-key (kbd "<end>") 'cmd)
;; (global-set-key (kbd "<next>") 'cmd)   ; page down key
;; (global-set-key (kbd "<prior>") 'cmd)  ; page up key
;; (global-set-key (kbd "<left>") 'cmd)   ; ←
;; (global-set-key (kbd "<right>") 'cmd)  ; →
;; (global-set-key (kbd "<up>") 'cmd)     ; ↑
;; (global-set-key (kbd "<down>") 'cmd)   ; ↓
;; (global-set-key (kbd "RET") 'cmd) ; the Enter/Return key
;; (global-set-key (kbd "SPC") 'cmd) ; the Space bar key

;; (global-set-key (kbd "M-<f2>") 'cmd) ; Meta+F2
;; (global-set-key (kbd "C-<f2>") 'cmd)  ; Ctrl+F2
;; (global-set-key (kbd "S-<f2>") 'cmd)  ; Shift+F2

;; (global-set-key (kbd "M-<up>") 'cmd)  ; Meta+↑
;; (global-set-key (kbd "C-<up>") 'cmd)  ; Ctrl+↑
;; (global-set-key (kbd "S-<up>") 'cmd)  ; Shift+↑
;; (global-set-key (kbd "M-A") 'cmd) ; Meta+Shift+a
;; (global-set-key (kbd "C-A") 'cmd) ; Ctrl+Shift+a
;; (global-set-key (kbd "C-M-a") 'cmd) ; Ctrl+Meta+a
;; (global-set-key (kbd "M-@") 'cmd)       ; Meta+Shift+2 or Meta+@
;; (global-set-key (kbd "C-@") 'cmd)       ; Ctrl+Shift+2 or Ctrl+@
;; (global-set-key (kbd "C-M-2") 'cmd)     ; Ctrl+Meta+2

;; (global-set-key (kbd "C-S-<kp-2>") 'cmd); Ctrl+Shift+“numberic pad 2”
;; (global-set-key (kbd "C-:") 'cmd) ; Ctrl+Shift+; or Ctrl+:
;; (global-set-key (kbd "C-\"") 'cmd) ; Ctrl+Shift+' or Ctrl+"
;; ; note: the question mark “?” cannot be used in shortcut.
;; (global-set-key (kbd "M-S-<f1>") 'cmd)   ; Meta+Shift+F1
;; (global-set-key (kbd "C-S-<kp-2>") 'cmd) ; Ctrl+Shift+“numberic pad 2”
;; (global-set-key (kbd "C-M-<up>") 'cmd)   ; Ctrl+Meta+↑

;; (global-set-key (kbd "C-M-S-a") 'cmd)   ; Ctrl+Meta+Shift+a
;; (global-set-key (kbd "C-M-!") 'cmd)     ; Ctrl+Meta+Shift+1 or Ctrl+Meta+!
;; (global-set-key (kbd "C-M-\"") 'cmd)    ; Ctrl+Meta+Shift+' or Ctrl+Meta+"
;; (global-set-key (kbd "C-M-S-<up>") 'cmd); Ctrl+Meta+Shift+↑

;; (global-set-key (kbd "C-c a") 'cmd)  ; Ctrl+c a
;; (global-set-key (kbd "C-c SPC") 'cmd)  ; Ctrl+c Space
;; (global-set-key (kbd "C-c <f2>") 'cmd)   ; Ctrl+c f2
;; (global-set-key (kbd "C-c <up>") 'cmd)   ; Ctrl+c ↑

;; (global-set-key (kbd "C-c C-c <up>") 'cmd); Ctrl+c Ctrl+c ↑

;; (global-set-key (kbd "2") 'cmd)
;; (global-set-key (kbd "a") 'cmd)
;; (global-set-key (kbd "é") 'cmd)
;; (global-set-key (kbd "α") 'cmd)
;; (global-set-key (kbd "π") 'cmd)
;; (global-set-key (kbd "(") 'cmd)
;; (global-set-key (kbd "你") 'cmd)

;; How to unset a keybinding?

;; (global-unset-key (kbd "C-_"))

;; (add-hook 'html-mode-hook
;;  (lambda ()
;;  (define-key html-mode-map (kbd "C-c w") 'bold-word)
;;  (define-key html-mode-map (kbd "C-c b") 'blue-word)
;;  (define-key html-mode-map (kbd "C-c p") 'insert-p)
;;  (define-key html-mode-map (kbd "M-4") 'tag-image)
;;  (define-key html-mode-map (kbd "M-5") 'wrap-url)
;;  )
;; )

;; (global-set-key (kbd "M-i a") "α")
;; (global-set-key (kbd "M-i b") "β")
;; (global-set-key (kbd "M-i t") "θ")
;; (global-set-key (kbd "<kp-6>") "→")

;; ;; type parens in pairs with Hyper and right hands's home-row
;; (global-set-key (kbd "H-j") (lambda () (interactive) (insert "{}") (backward-char 1)))
;; (global-set-key (kbd "H-k") (lambda () (interactive) (insert "()") (backward-char 1)))
;; (global-set-key (kbd "H-l") (lambda () (interactive) (insert "[]") (backward-char 1)))

;; (add-hook 'echo-area-clear-hook '(lambda () (interactive) (kill-new (current-message))))
;; (defun hoge ()
;;   ""
;;   (interactive)
;;   (kill-new (current-message))
;; )
;; (global-set-key [f5] 'hoge)
;;            (message (current-message))  ; Show tool-tip through keystrokes echoed so far
;; echo-area-clear-hook
;; (global-set-key [S-f1] 'na-run-term-or-rename)
;; (global-set-key [M-f1] 'na-run-lisp)

;;(global-set-key [?\C-,] 'delete-rectangle)
(define-key minibuffer-local-map (kbd "M-y") nil)
(define-key minibuffer-local-completion-map (kbd "M-y") nil)
(define-key minibuffer-local-map (kbd "M-y") 'anything-show-kill-ring)
(define-key minibuffer-local-completion-map (kbd "M-y") 'anything-show-kill-ring)
  (define-key minibuffer-local-completion-map "\C-n" 
    'next-history-element)
  (define-key minibuffer-local-completion-map "\C-p" 
    'previous-history-element)
(define-key minibuffer-local-map (kbd "C-h") 'delete-backward-char)
(define-key minibuffer-local-completion-map (kbd "C-h") 'delete-backward-char)
(define-key minibuffer-local-must-match-map (kbd "C-h") 'delete-backward-char)

(define-key minibuffer-local-isearch-map (kbd "C-h") 'delete-backward-char)

;; minibuffer-local-completion-map
;; minibuffer-local-filename-completion-map
;; minibuffer-local-filename-must-match-map
;; minibuffer-local-isearch-map
;; minibuffer-local-map
;; minibuffer-local-must-match-filename-map
;; minibuffer-local-must-match-map
;; minibuffer-local-ns-map
;; minibuffer-local-shell-command-map
;; bookmark-minibuffer-read-name-map
;; wl-address-minibuffer-local-map

(global-set-key "\M-j" 'other-window)
(global-set-key "\M-k" (lambda () (interactive) (other-window -1)))

(defun open-junk-file ()
  (interactive)
  (let* ((file (expand-file-name
                (format-time-string
                 "%Y/%m/%Y-%m-%d-%H%M%S." (current-time))
                "~/memo/junk/"))
         (dir (file-name-directory file)))
    (make-directory dir t)
    (find-file-other-window (read-string "Junk Code: " file))))


(defun my-thing-at-point (thing)
 (if (get thing 'thing-at-point)
     (funcall (get thing 'thing-at-point))
   (let ((bounds (bounds-of-thing-at-point thing)))
     (if bounds
         (let ((ov (make-overlay (car bounds) (cdr bounds))))
           (overlay-put ov 'face 'region)
           (sit-for 3)
           (delete-overlay ov)
           (buffer-substring (car bounds) (cdr bounds)))))))

;; ;; C-q のキーマップを作成
(defvar ctl-q-map (make-keymap))  ;ctrl-q-map という変数を新たに定義
(define-key global-map (kbd "C-q") ctl-q-map) ;ctrl-q-map を Ctrl-q に割り当てる
;(define-key ctl-q-map (kbd "C-w") 'kill-new-things-at-point) ;C-q C-wでkill-new-things-at-pointを実行
(define-key ctl-q-map (kbd "C-w") (lambda () (interactive) (kill-new (my-thing-at-point 'symbol))))
(define-key ctl-q-map (kbd "C-e") (lambda () (interactive) (kill-new (my-thing-at-point 'word))))
(define-key ctl-q-map (kbd "C-r") (lambda () (interactive) (kill-new (my-thing-at-point 'sexp))))
(define-key ctl-q-map (kbd "C-i") 'ac-complete-look)
(define-key ctl-q-map (kbd "C-j") 'delete-other-windows)
(define-key ctl-q-map (kbd "C-j") 'delete-other-windows)
(define-key ctl-q-map (kbd "C-M-j") 'delete-other-frames)
(define-key ctl-q-map (kbd "C-g") 'vc-annotate)

;(define-key ctl-q-map (kbd "C-b") 'your-favorite-funcb)
(define-key ctl-q-map (kbd "C-q") 'quoted-insert) ;元々の関数
;; outdent.el
;; (require 'outdent)
;; (define-key ctl-q-map (kbd "C-h") 'outdent-hide-current-subtree)
;; (define-key ctl-q-map (kbd "C-i") 'outdent-show-children)
;; (define-key ctl-q-map (kbd "I") 'outdent-show-all)
;; (define-key py-mode-map (kbd "C-c C-S-r") 'py-execute-buffer)

;; Shift + Tab
;; (global-set-key [backtab] 'backtab)
