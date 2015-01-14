;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

(require 'cl)
(require 'imenu)
(require 'imenu+)
(require 'which-func)

(add-hook 'after-save-hook 'which-func-update)
(set-face-foreground 'which-func "white")


;;今いる位置の関数の名前をモードラインに表示する。
(require 'which-func)
(which-func-mode 1)
;; 関数名はヘッダーラインに表示する
(delete (assoc 'which-func-mode mode-line-format) mode-line-format)
(setq-default header-line-format '(which-func-mode ("" which-func-format)))


(defun rst-imenu-create-index ()
  (let (index)
    (goto-char (point-min))
    (while (re-search-forward "\\(^.\\S-\\(.+\\)\\|^\\s-\\s-\\S-\\(.*\\)\\)" (point-max) t)
      (push (cons (match-string 1) (match-beginning 1)) index))
    (nreverse index)))
               
(defun yaml-imenu-create-index ()
  (let (index)
    (goto-char (point-min))
    (while (re-search-forward "\\((.*\\)\\)====" (point-max) t)
      (push (cons (match-string 1) (match-beginning 1)) index))
    (nreverse index)))

(add-hook 'rst-mode-hook (lambda () (setq imenu-create-index-function 'rst-imenu-create-index)))
(setq which-func-modes (append which-func-modes '(rst-mode)))



; yaml-mode と javascript-mode でも which-func を使う
;; (setq which-func-modes
;;   (append which-func-modes
;;     '(emacs-lisp-mode
;;       lisp-interaction-mode
;;       lisp-mode
;;       yaml-mode
;;       javascript-mode
;;       php-mode
;;       python-mode
;;       )))
;; (which-func-mode t)

;; (add-hook 'yaml-mode-hook (lambda () (setq imenu-create-index-function 'yaml-imenu-create-index)))
;(setq which-func-modes (append which-func-modes '(yaml-mode)))


;; infoの設定
(defvar info-imenu-generic-expression
  '((nil "^\\* \\(\\(\\w* ?\\)*\\):" 1)))
(add-hook
 'Info-mode-hook
 '(lambda()
    (setq imenu-generic-expression
          info-imenu-generic-expression)
    (setq imenu-auto-rescan t)))

;; imenuの設定
(setq imenu-auto-rescan-maxout 300000)  ; imenu resca

;;emacs-lisp-mode
;; ((nil "^\\s-*(def\\(un\\|subst\\|macro\\|advice\\)\
;; \\s-+\\([-A-Za-z0-9+]+\\)" 2)
;;  ("*Vars*" "^\\s-*(def\\(var\\|const\\)\
;; \\s-+\\([-A-Za-z0-9+]+\\)" 2)
;;  ("*Types*"
;;   "^\\s-*\
;; (def\\(type\\|struct\\|class\\|ine-condition\\)\
;; \\s-+\\([-A-Za-z0-9+]+\\)" 2))

;;;; elisp 用
;; (defun elisp-imenu-create-index ()
;;   (let (index)
;;     (goto-char (point-min))
;;     (while (re-search-forward "^;;;;\\(.+\\)" (point-max) t)
;;       (push (cons (match-string 1) (match-beginning 1)) index))
;;     (nreverse index)))

;; (defun elisp-imenu-create-index ()
;;   (let (index)
;;     (save-excursion
;;       (goto-char (point-min))
;;       (loop always (re-search-forward "^;;;;\\(.+\\)" nil t)
;;             do (push (cons (match-string 1) (match-beginning 1)) index)))
;;        (nreverse index)))

;collectとinitially

;; (defun elisp-imenu-create-index ()
;;   (save-excursion
;;     (loop initially (goto-char (point-min))
;;           while (re-search-forward "^;;;;\\(.+\\)" nil t)
;;           with index = nil
;;           collect (push (cons (match-string 1) (match-beginning 1)) index)
;;           finally return (nreverse index))))



(setq which-func-modes (append which-func-modes '(emacs-lisp-mode)))

;(add-hook 'emacs-lisp-mode-hook (lambda () (setq imenu-create-index-function 'elisp-imenu-create-index)))
;; (setq which-func-modes (append which-func-modes '(emacs-lisp-mode)))
