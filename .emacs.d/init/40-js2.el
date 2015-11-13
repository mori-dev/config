;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . js2-mode))

(add-to-list 'auto-mode-alist '("\\.jsx\\'" . js2-jsx-mode))
;(flycheck-add-mode 'javascript-eslint 'js2-jsx-mode)
(add-hook 'js2-jsx-mode-hook 'flycheck-mode)
;; (eval-after-load "js2"
;;   '(progn

(setq js2-strict-missing-semi-warning nil)  ;; missing ; after statement を抑止
(setq js2-basic-offset 2)        ;インデント幅を 2 にする
(setq js2-cleanup-whitespace nil) ;行末の空白を保存時に削除しない
;(setq js2-mirror-mode nil)        ;開き括弧の入力の際に、閉じ括弧を自動で入力しない
(setq js2-bounce-indent-flag nil) ;C-i (TAB) 時のインデント変更を抑止
(setq js2-bounce-indent-p t)
;インデントの際のカーソル移動を他の major-mode と揃える
(defun indent-and-back-to-indentation ()
  (interactive)
  (indent-for-tab-command)
  (let ((point-of-indentation
         (save-excursion (back-to-indentation) (point))))
    (skip-chars-forward "\s " point-of-indentation)))


(defun mdc-reference ()
  (interactive)
  (browse-url "https://developer.mozilla.org/ja/JavaScript/Reference"))

(defun mdc (word)
  (interactive "ssearch word: \n")
  (browse-url (format "https://developer.mozilla.org/en-US/search?q=%s" word)))

;;moozさん wiki
(setq js2-consistent-level-indent-inner-bracket-p t)
(setq js2-pretty-multiline-decl-indentation-p t)
