;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-


;; eshell の起動
(add-hook 'after-init-hook
          (lambda()
            (eshell)
            (switch-to-buffer "*scratch*")))

;; (defun my-toggle-term ()
;;   "eshell と直前のバッファを行き来する"
;;   (interactive)
;;   (let ((ignore-list '("*Help*" "*Minibuf-1*" "*Messages*"
;;                        "*terminal<1>*" "*terminal<2>*" "*terminal<3>*")))
;;     (labels
;;         ((_my-toggle-term (target)
;;            (if (null (member (buffer-name (second target)) ignore-list))
;;                (if (equal "*eshell*" (buffer-name (window-buffer)))
;;                    (switch-to-buffer (second target))
;;                  (switch-to-buffer "*eshell*"))
;;              (_my-toggle-term (cdr target)))))
;;       (_my-toggle-term (buffer-list)))))

(defun my-toggle-term ()
  "eshell と直前のバッファを行き来する。C-u 付きで呼ぶと 今いるバッファと同じディレクトリに cd する"
  (interactive)
  (let ((ignore-list '("*Help*" "*Minibuf-1*" "*Messages*"
                       "*terminal<1>*" "*terminal<2>*" "*terminal<3>*"))
        (dir default-directory))
    (labels
        ((_my-toggle-term (target)
           (if (null (member (buffer-name (second target)) ignore-list))
               (if (equal "*eshell*" (buffer-name (window-buffer)))
                   (switch-to-buffer (second target))
                 (switch-to-buffer "*eshell*")
                 (when current-prefix-arg
                   (cd dir)
                   (eshell-interactive-print (concat "cd " dir "\n"))
                   (eshell-emit-prompt)))
             (_my-toggle-term (cdr target)))))
      (_my-toggle-term (buffer-list)))))

(global-set-key (kbd "<C-M-return>") 'my-toggle-term)

;;http://oldtype.sumibi.org/show-page/kiyoka.2011_02_22#10
;; (defun eshell-cd-default-directory ()
;;   (interactive)
;;   (let ((dir default-directory))
;;     (eshell)
;;     (cd dir)
;;     (eshell-interactive-print (concat "cd " dir "\n"))
;;     (eshell-emit-prompt)))
;;;(global-set-key "\C-cd" 'eshell-cd-default-directory)

(defun my-eshell-kill-line0 ()
  "bash の C-u 相当"
  (interactive)
  (save-restriction
    (narrow-to-region (point) (eshell-bol))
    (kill-line 1)))

(require 'anything)

(setq anything-c-source-bash-history
  `((name . ".bash_history")
    (init . (lambda ()
              (with-current-buffer (anything-candidate-buffer 'global)
                (insert-file-contents "~/.bash_history"))))
    (candidates-in-buffer)
    (candidate-number-limit . 99999)
    (action ("Insert" . insert))))

(defun anything-bash-history-for-eshell ()
  (interactive)
  (anything 'anything-c-source-bash-history))

(add-hook 'eshell-mode-hook
  (lambda()
    (define-key eshell-mode-map (kbd "C-c k") 'my-eshell-kill-line0)
    (define-key eshell-mode-map (kbd "C-c C-k") 'my-eshell-kill-line0)
    (define-key eshell-mode-map (kbd "C-o") 'anything-bash-history-for-eshell)))


;; eshell での補完に auto-complete.el を使う
(require 'pcomplete)

;; (add-to-list 'ac-modes 'eshell-mode)

;; (defun ac-eshell-mode ()
;;   (setq ac-sources
;;         '(ac-source-pcomplete
;;           ac-source-words-in-buffer
;;           ac-source-dictionary)))
(require 'auto-complete)
(ac-define-source pcomplete
  '((candidates . pcomplete-completions)))

(add-hook 'eshell-mode-hook
          (lambda ()
            ;; (my-ac-eshell-mode)
            (define-key eshell-mode-map (kbd "C-i") 'my-ac-eshell-complete)))

;; ac-complete-my-pcomplete を利用しないのは、他の情報源と合わせるため
(defun my-ac-eshell-complete ()
  (interactive)
  (let (
        ;; (ac-menu-height 50)
        ;; (ac-candidate-limit t)
        )
    (auto-complete '(ac-source-pcomplete ac-source-words-in-buffer ac-source-filename))))


;; RET, C-m で ac-complete ができないのでその対策->うまくいってない.C-m は OK
;; (makunbound 'my-eshell-keybind-minor-mode)
;; (define-minor-mode my-eshell-keybind-minor-mode
;;   "RET で ac-complete"            ;説明文字列
;;   nil                             ;デフォルトで無効にする
;;   ""                              ;モードラインに表示しない
;;   `(("\r" . ac-complete)
;;     (,(kbd "C-m") . ac-complete)
;;     ))

;; (add-hook 'eshell-mode-hook
;;   (lambda()
;;     (my-eshell-keybind-minor-mode t)))






;; ;;以下はカスタマイザで設定した
;; '(eshell-ask-to-save-history (quote always));確認なしでヒストリ保存
;; '(eshell-cmpl-cycle-completions t);補完時にサイクルする
;; '(eshell-cmpl-cycle-cutoff-length 5);補完候補がこの数値以下だとサイクルせずに候補表示
;; '(eshell-hist-ignoredups t);履歴で重複を無視してくれるっぽいけど上手く動いてない
;; '(eshell-history-file-name "~/.bash_history");バッシュと履歴共有してるのが原因かなぁ 

;;; From: http://www.emacswiki.org/cgi-bin/wiki.pl/EshellEnhancedLS
(eval-after-load "em-ls"
  '(progn
     ;; (defun ted-eshell-ls-find-file-at-point (point)
     ;;          "RET on Eshell's `ls' output to open files."
     ;;          (interactive "d")
     ;;          (find-file (buffer-substring-no-properties
     ;;                      (previous-single-property-change point 'help-echo)
     ;;                      (next-single-property-change point 'help-echo))))
     (defun pat-eshell-ls-find-file-at-mouse-click (event)
       "Middle click on Eshell's `ls' output to open files.
 From Patrick Anderson via the wiki."
       (interactive "e")
       (ted-eshell-ls-find-file-at-point (posn-point (event-end event))))
     (defun ted-eshell-ls-find-file ()
       (interactive)
       (let ((fname (buffer-substring-no-properties
                     (previous-single-property-change (point) 'help-echo)
                     (next-single-property-change (point) 'help-echo))))
         ;; Remove any leading whitespace, including newline that might
         ;; be fetched by buffer-substring-no-properties
         (setq fname (replace-regexp-in-string "^[ \t\n]*" "" fname))
         ;; Same for trailing whitespace and newline
         (setq fname (replace-regexp-in-string "[ \t\n]*$" "" fname))
         (cond
          ((equal "" fname)
           (message "No file name found at point"))
          (fname
           (find-file fname)))))
     (let ((map (make-sparse-keymap)))
       ;;          (define-key map (kbd "RET")      'ted-eshell-ls-find-file-at-point)
       ;;          (define-key map (kbd "<return>") 'ted-eshell-ls-find-file-at-point)
       (define-key map (kbd "RET")      'ted-eshell-ls-find-file)
       (define-key map (kbd "<return>") 'ted-eshell-ls-find-file)
       (define-key map (kbd "<mouse-2>") 'pat-eshell-ls-find-file-at-mouse-click)
       (defvar ted-eshell-ls-keymap map))
     (defadvice eshell-ls-decorated-name (after ted-electrify-ls activate)
       "Eshell's `ls' now lets you click or RET on file names to open them."
       (add-text-properties 0 (length ad-return-value)
                            (list 'help-echo "RET, mouse-2: visit this file"
                                  'mouse-face 'highlight
                                  'keymap ted-eshell-ls-keymap)
                            ad-return-value)
       ad-return-value)))
