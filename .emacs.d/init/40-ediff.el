;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; ediff-revision         ; Ediff で差分を表示
;; ediff-files            ;ファイル同士の差分
;; ediff-buffers          ;バッファ同士の差分
;; ediff-regions-wordwise ;リージョン同士の差分 (UIが分かりにくいそうです)
;; ediff-directories      ;ディレクトリ同士の差分

;; Ediff Control Panel を同じフレームに表示する
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
;; 差分を横に分割して表示する
(setq ediff-split-window-function 'split-window-horizontally)
;; 余計なバッファを（確認して）削除する
(setq ediff-keep-variants nil)



;;; ediffを1ウィンドウで実行
;; (setq ediff-window-setup-function 'ediff-setup-windows-plain)
;; ;;; diffのオプション
;; (setq diff-switches '("-u" "-p" "-N"))

;; (setq diff-default-read-only nil)

    ;; ("n" . diff-hunk-next)
    ;; ("N" . diff-file-next)
    ;; ("p" . diff-hunk-prev)
    ;; ("P" . diff-file-prev)

;; diff-mode-shared-map

(add-hook 'diff-mode-hook
  (lambda()
;;     (define-key diff-mode-map (kbd "j") 'diff-hunk-next)
;;     (define-key diff-mode-map (kbd "k") 'diff-hunk-prev)
    ;;diff-hunk-kill
    ;; (define-key diff-mode-shared-map (kbd "k") nil)
    ;; ;; (define-key diff-mode-shared-map (kbd "M-k") 'diff-hunk-kill)
    ;; ;; (define-key diff-mode-map (kbd "M-k") 'diff-hunk-kill)
    ;; (define-key diff-mode-shared-map (kbd "k") 'diff-hunk-kill)
    ;; ;;diff-file-kill    
    ;; (define-key diff-mode-shared-map (kbd "K") nil)
    ;; (define-key diff-mode-shared-map (kbd "K") 'diff-file-kill)
    ;; (define-key diff-mode-shared-map (kbd "M-k") 'diff-hunk-kill)
    ;; (define-key diff-mode-shared-map (kbd "C-M-k") 'diff-file-kill)
    (define-key diff-mode-map (kbd "C-M-n") 'diff-file-next)
    (define-key diff-mode-map (kbd "C-M-p") 'diff-file-prev)
    (define-key diff-mode-map (kbd "M-k") 'diff-hunk-kill)
    (define-key diff-mode-map (kbd "C-M-k") 'diff-file-kill)
    ;; (define-key diff-mode-map (kbd "J") 'diff-file-next)
    ;; (define-key diff-mode-map (kbd "K") 'diff-file-prev)
))



;; M-k       	diff-hunk-kill
;; M-K       	diff-file-kill

(defcustom diff-jump-to-old-file nil
  "Non-nil means `diff-goto-source' jumps to the old file.
Else, it jumps to the new file."
  :type 'boolean
  :group 'diff-mode)

(defvar diff-outline-regexp
  "\\([*+][*+][*+] [^0-9]\\|@@ ...\\|\\*\\*\\* [0-9].\\|--- [0-9]..\\)")
;; These are not perfect.  They would be better done separately for
;; context diffs and unidiffs.
(set (make-local-variable 'paragraph-start)
       (concat "@@ "			; unidiff hunk
	       "\\|\\*\\*\\* "		; context diff hunk or file start
	       "\\|--- [^\t]+\t"))	; context or unidiff file
					; start (first or second line)
  (set (make-local-variable 'paragraph-separate) paragraph-start)
  (set (make-local-variable 'page-delimiter) "--- [^\t]+\t")

;;;; diff-mode の色設定

(add-hook 'diff-mode-hook
          (lambda ()
            (set-face-foreground 'diff-context-face "grey50")
            (set-face-background 'diff-header-face "black")
            (set-face-underline-p 'diff-header-face t)
            ;; (set-face-foreground 'diff-file-header-face "light goldenrod")
            (set-face-foreground 'diff-file-header-face "MediumSeaGreen")
            (set-face-background 'diff-file-header-face "black")
            ;; (set-face-foreground 'diff-index-face "thistle")
            (set-face-foreground 'diff-index-face "MediumSeaGreen")
            (set-face-background 'diff-index-face "black")
            (set-face-foreground 'diff-hunk-header-face "plum")
            (set-face-background 'diff-hunk-header-face"black")
            (set-face-foreground 'diff-removed-face "pink")
            (set-face-background 'diff-removed-face "gray5")
            (set-face-foreground 'diff-added-face "light green")
            (set-face-foreground 'diff-added-face "white")
            (set-face-background 'diff-added-face "SaddleBrown")
            (set-face-foreground 'diff-changed-face "DeepSkyBlue1")))

;; (set-face-foreground 'diff-header-face "") 
;; (set-face-background 'diff-header-face "")
;; (set-face-underline-p 'diff-header-face nil)
;; (set-face-bold-p 'diff-header-face nil)
;; (set-face-foreground 'diff-file-header-face "") 
;; (set-face-background 'diff-file-header-face "") 
;; (set-face-underline-p 'diff-file-header-face nil)
;; (set-face-bold-p 'diff-file-header-face nil)
;; (set-face-foreground 'diff-index-face "")
;; (set-face-background 'diff-index-face "")
;; (set-face-underline-p 'diff-index-face nil)
;; (set-face-bold-p 'diff-index-face nil)
;; (set-face-foreground 'diff-hunk-header-face "")
;; (set-face-background 'diff-hunk-header-face "")
;; (set-face-underline-p 'diff-hunk-header-face
;; (set-face-bold-p 'diff-hunk-header-face
;; (set-face-foreground 'diff-removed-face "")
;; (set-face-background 'diff-removed-face "")
;; (set-face-underline-p 'diff-removed-face nil)
;; (set-face-bold-p 'diff-removed-face nil)
;; (set-face-foreground 'diff-added-face "")
;; (set-face-background 'diff-added-face "")
;; (set-face-underline-p 'diff-added-face nil)
;; (set-face-bold-p 'diff-added-face nil)
;; (set-face-foreground 'diff-changed-face "red")
;; (set-face-background 'diff-changed-face "red")
;; (set-face-underline-p 'diff-changed-face nil)
;; (set-face-bold-p 'diff-changed-face nil)
;; (set-face-foreground 'diff-indicator-removed-face "")
;; (set-face-background 'diff-indicator-removed-face "")
;; (set-face-underline-p 'diff-indicator-removed-face nil)
;; (set-face-bold-p 'diff-indicator-removed-face nil)
;; (set-face-foreground 'diff-indicator-added-face "")
;; (set-face-background 'diff-indicator-added-face "")
;; (set-face-underline-p 'diff-indicator-added-face nil)
;; (set-face-bold-p 'diff-indicator-added-face nil)
;; (set-face-foreground 'diff-indicator-changed-face "")
;; (set-face-background 'diff-indicator-changed-face "")
;; (set-face-underline-p 'diff-indicator-changed-face nil)
;; (set-face-bold-p 'diff-indicator-changed-face nil)
;; (set-face-foreground 'diff-function-face "red")
;; (set-face-background 'diff-function-face "gray1")
;; (set-face-underline-p 'diff-function-face nil)
;; (set-face-bold-p 'diff-function-face nil)
;; (set-face-foreground 'diff-context-face "grey50")
;; (set-face-background 'diff-context-face "")
;; (set-face-underline-p 'diff-context-face nil)
;; (set-face-bold-p 'diff-context-face nil)
;; (set-face-foreground 'diff-nonexistent-face "red")
;; (set-face-background 'diff-nonexistent-face "red")
;; (set-face-underline-p 'diff-nonexistent-face nil)
;; (set-face-bold-p 'diff-nonexistent-face nil)
;; (set-face-foreground 'diff-refine-change-face "")
;; (set-face-background 'diff-refine-change-face "")
;; (set-face-underline-p 'diff-refine-change-face nil)
;; (set-face-bold-p 'diff-refine-change-face nil)


;; (set-face-foreground 'skype--face-my-time-field "coral") 
;; (set-face-background 'skype--face-my-time-field "DimGray") 
;; (set-face-underline-p 'skype--face-my-time-field nil) 
;; (set-face-bold-p 'skype--face-my-time-field nil)
