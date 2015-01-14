;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

(require 'markdown-mode)

(add-to-list 'auto-mode-alist '("\\.md" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown" . markdown-mode))



(make-variable-buffer-local 'my-outline-level)
;; (setq-default my-outline-level 1)

(defun my-global-cycle-md ()
  (interactive)
  (cond
   ((eq my-outline-level 1)
    (hide-sublevels 2)
    (setq my-outline-level 2))
   ((eq my-outline-level 2)
    (hide-sublevels 3)
    (setq my-outline-level 3))
   ((eq my-outline-level 3)
    (hide-sublevels 1)
    (setq my-outline-level 1))))

;; (global-set-key (kbd "C-o") 'my-global-cycle-md)



;; (setq markdown-regex-bold nil)
;; (setq markdown-regex-bold nil)

;; _sfd_ を強調表示しない
;; (setq-default markdown-regex-italic
;;   "\\(^\\|[^\\]\\)\\(\\([*]\\)\\([^ \\]\\3\\|[^ ]\\(.\\|\n[^\n]\\)*?[^\\ ]\\3\\)\\)")

;; (defconst markdown-regex-italic
;;   "\\(^\\|[^\\]\\)\\(\\([*]\\)\\([^ \\]\\3\\|[^ ]\\(.\\|\n[^\n]\\)*?[^\\ ]\\3\\)\\)"
;;   "Regular expression for matching italic text.")



(add-hook 'markdown-mode-hook
  (lambda()
    (define-key markdown-mode-map (kbd "C-i") 'markdown-cycle)
    (hide-sublevels 2)))
;; (setq auto-mode-alist
;;   (cons '("\\.src\\.txt" . markdown-mode) auto-mode-alist))

;; (setq auto-mode-alist
;;   (cons '("\\.md" . markdown-mode) auto-mode-alist))

;; (setq auto-mode-alist
;;   (cons '("\\.markdown" . markdown-mode) auto-mode-alist))

;;https://gist.github.com/738798
;; (autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)
;; (add-to-list 'auto-mode-alist '("\\.text" . markdown-mode))
;; (add-to-list 'auto-mode-alist '("\\.md" . markdown-mode))

;; ;; 日本語出力用
;; (add-hook 'markdown-mode-hook
;;           (lambda ()
;;             (make-local-variable coding-system-for-write)
;;             (setq coding-system-for-write 'utf-8)))
