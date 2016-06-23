;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-


;; 現在行の行番号を目立たせる
;; (require 'hlinum)

;; (defface linum-highlight-face
;;     '((t (:inherit default :foreground "black"
;;           :background "gray")))
;;   "Face for highlighting current line"
;;   :group 'linum)

(require 'linum)

(global-set-key [f9] 'linum-mode)

(defadvice vc-annotate (after my-vc-annotate activate)
  (linum-on))

;; メージャーモード/マイナーモードでの指定
(setq my-linum-hook-name '(emacs-lisp-mode-hook slime-mode-hook sh-mode-hook text-mode-hook
                           php-mode-hook python-mode-hook ruby-mode-hook haskell-mode-hook
                           css-mode-hook yaml-mode-hook org-mode-hook nginx-mode
                           howm-mode-hook js2-mode-hook javascript-mode-hook
                           smarty-mode-hook html-helper-mode-hook html-mode-hook coffee-mode-hook
                           markdown-mode-hook haml-mode-hook typescript-mode go-mode-hook))
;; ファイル名での判定
(setq my-linum-file '("hosts" "my_site" "sudo:my_site" "nginx.conf"))
;; 拡張子での判定
(setq my-linum-file-extension
      '("conf" "bat" "rhtml" "erb" "rst"
        "txt" "hs" "md" "mkd" "markdown"
        "haml" "ejs" "ts" "go" "js" "jsx"))

;; メージャーモード/マイナーモードでの指定
(defvar my-linum-hook-name nil)
(mapc (lambda (hook-name)
          (add-hook hook-name (lambda () (linum-on))))
       my-linum-hook-name)

;; ファイル名での判定
(defvar my-linum-file nil)
(defun my-linum-file-name ()
  (when (member (buffer-name) my-linum-file)
                (linum-mode t)))
(add-hook 'find-file-hook 'my-linum-file-name)

;; 拡張子での判定
(defvar my-linum-file-extension nil)
(defun my-linum-file-extension ()
  (when (member (file-name-extension (buffer-file-name)) my-linum-file-extension)
                (linum-mode t)))
(add-hook 'find-file-hook 'my-linum-file-extension)

;;defface linum
;; (global-linum-mode t) に例外処理を追加
;;
;; (defun linum-on ()
;;   (unless (minibufferp)
;;     (linum-mode 1)))

;; (add-hook 'lisp-interaction-mode-hook (lambda () (linum-mode t)))
;; (add-hook 'emacs-lisp-mode-hook (lambda () (linum-mode t)))
;; (add-hook 'slime-mode-hook (lambda () (linum-mode t)))
;; (add-hook 'emacs-lisp-mode-hook (lambda () (linum-mode t)))
;; (add-hook 'text-mode-hook (lambda () (linum-mode t)))
;; (add-hook 'php-mode-hook (lambda () (linum-mode t)))
;; (add-hook 'python-mode-hook (lambda () (linum-mode t)))
;; (add-hook 'ruby-mode-hook (lambda () (linum-mode t)))
;; (add-hook 'css-mode-hook (lambda () (linum-mode t)))
;; (add-hook 'yaml-mode-hook (lambda () (linum-mode t)))
;; (add-hook 'org-mode-hook (lambda () (linum-mode t)))
;; (add-hook 'howm-mode-hook (lambda () (linum-mode t)))
;; (add-hook 'javascript-mode-hook (lambda () (linum-mode t)))
;; (add-hook 'smarty-mode-hook (lambda () (linum-mode t)))
;; (add-hook 'html-helper-mode-hook (lambda () (linum-mode t)))
;; (add-hook 'js2-mode-hook (lambda () (linum-mode t)))
