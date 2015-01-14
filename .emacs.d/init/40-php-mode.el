;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; php-mode
(defalias 'php 'php-mode)

;C-c C-q でインデントしなおす
(require 'php-mode)


(push '("#.*" . font-lock-comment-face) php-font-lock-keywords-3)

(setq php-mode-force-pear nil)

(add-hook 'php-mode-hook
  (lambda ()
    (setq indent-tabs-mode nil)
    (setq tab-width 4)
    (c-set-offset 'case-label '+) 
    (setq c-basic-offset 4)       ;インデントレベルについていくつのカラムを使用するか。デフォルトは4
    (c-set-offset 'case-label '+) ;switch のcase でインデントする。
    (c-set-offset 'arglist-close 'c-lineup-arglist-operators)
    (c-set-offset 'arglist-intro '+)
    (c-set-offset 'arglist-cont-nonempty 'c-lineup-math)
    ))


(add-hook 'php-mode-hook
  (lambda()
    ;(global-set-key (kbd "RET") 'newline-and-indent)
    (define-key php-mode-map (kbd "C-M-k") 'kill-php)
    (define-key php-mode-map (kbd "C-c C-b") nil)
    (define-key c-mode-base-map "\C-c\C-b" nil)
    ;(define-key php-mode-map (kbd "RET") (kbd "C-m"))
    (define-key php-mode-map (kbd "C-]") 'sf-cmd:anything-symfony-el-command)
    (define-key php-mode-map (kbd "C-M-a") 'my-php-beginning-of-defun)
    (define-key php-mode-map (kbd "C-c C-r") 'my-php-eval-region)
    (define-key php-mode-map (kbd "<M-f5>") 'phplint-thisfile)
    ))

(defun my-php-beginning-of-defun ()
  "lisp-interaction-mode の C-M-a (beginning-of-defun) ような移動をする"
  (interactive)
  (re-search-backward "\\(function\\|class\\)" nil t)
  (re-search-forward "{" nil t)
  (backward-char))

(defun my-php-down-list ()
  "lisp-interaction-mode の C-M-d (down-list) ような移動をする"
  (interactive)
  (re-search-forward "{" nil t))

(defun cc ()
  "プロジェクトのトップディレクトリ以下なら symfony cc"
  (interactive)
  (labels 
      ((find-file-upward (name &optional dir)
                         (let ((default-directory (file-name-as-directory (or dir default-directory)))) 
                           (if (file-exists-p name) (expand-file-name name)
                             (unless (string= "/" (directory-file-name default-directory))
                               (find-file-upward name (expand-file-name ".." default-directory)))))))
    (with-temp-buffer
      (and (find-file-upward "symfony")
           (when (= (call-process (find-file-upward "symfony")  nil t t "cc") 0)
             (message "%s" (buffer-string)))))))

;; (defun cc ()
;;   "プロジェクトのトップディレクトリ以下なら symfony cc"
;;   (interactive)
;;   (let ((wb (get-buffer-create " *work*"))
;;         (cb (current-buffer)))
;;     (unwind-protect (progn
;;                       (switch-to-buffer wb)
;;                       (call-process "~/bin/sf.php" nil t t "cc"))
;;       (kill-buffer (current-buffer))
;;       (switch-to-buffer cb))))

;; (defun cc ()
;;   "プロジェクトのトップディレクトリ以下なら symfony cc"
;;   (interactive)
;;   (with-temp-buffer
;;     (call-process "~/bin/sf.php" nil t t "cc")
;;     (message "%s" (buffer-string))))

;; (defun cc ()
;;   "プロジェクトのトップディレクトリ以下なら symfony cc"
;;   (interactive)
;;   (with-temp-buffer
;;     (let ((ret (call-process "~/bin/symfony-command.sh" nil t t "cc")))
;;       (when (or (and (numberp ret) (/= ret 0))
;;                 (and (stringp ret) (not (string-equal ret ""))))
;;         (message "%s" (buffer-string))))))

;; (defun cc ()
;;   "プロジェクトのトップディレクトリ以下なら symfony cc"
;;   (interactive)
;;   (with-temp-buffer
;;     (when (= (call-process "~/bin/sf.php" nil t t "cc") 0)
;;       (message "%s" (buffer-string)))))


;; (load-library "hideshow")
;; (when (featurep 'hideshow)
;;   (hs-hide-level 2)
;;   (add-to-list
;;    'hs-special-modes-alist
;;    '(php-mode "{" "}" "/[*/]" nil hs-c-like-adjust-block-beginning))
;; ;  (define-key php-mode-map '[(control c)(h)] 'php-toggle-hideshow-function)
;;   (add-hook 'php-mode-hook
;; 	    (lambda () (hs-minor-mode 1))))

;; (defvar php-hs-hide nil "Current state of hideshow for toggling all.")
;; (defun php-toggle-hideshow-function () "Toggle hideshow all."
;;   (interactive)
;;   (setq php-hs-hide (not php-hs-hide))
;;   (if php-hs-hide
;;       (save-excursion
;; 	(goto-char (point-min))
;; 	(hs-hide-level 2)
;; 	(goto-char (point-max))
;; 	(while
;; 	    (search-backward "/**")
;; 	  (hs-hide-block)))
;;     (hs-show-all)))

;; http://blog.symfony.jp/2008/03/05/156
;; (load-library "hideshow")
;; (when (featurep 'hideshow)
;;   (hs-hide-level 2)
;;   (add-to-list
;;    'hs-special-modes-alist
;;    '(php-mode "{" "}" "/[*/]" nil hs-c-like-adjust-block-beginning))
;;   (define-key php-mode-map '[(control c)(h)] 'php-toggle-hideshow-function)
;;   (add-hook 'php-mode-hook
;; 	    (lambda () (hs-minor-mode 1))))
 
;; (defvar php-hs-hide nil "Current state of hideshow for toggling all.")
;; (defun php-toggle-hideshow-function () "Toggle hideshow all."
;;   (interactive)
;;   (setq php-hs-hide (not php-hs-hide))
;;   (if php-hs-hide
;;       (save-excursion
;; 	(goto-char (point-min))
;; 	(hs-hide-level 2)
;; 	(goto-char (point-max))
;; 	(while
;; 	    (search-backward "/**")
;; 	  (hs-hide-block)))
;;     (hs-show-all)))

;; php-mode 時にスペース押下で2スペース移動し、Shift+スペースで1スペース移動する設定
;; (add-hook 'php-mode-hook
;;   (lambda()
;;     (define-key php-mode-map (kbd "SPC") (lambda () (interactive) (insert "  ")))
;;     (define-key php-mode-map (kbd "S-SPC") (lambda () (interactive) (insert " ")))))


(defun my-php-eval-region ()
  (interactive)
  (when (region-active-p)
    (let ((region-str (buffer-substring-no-properties (region-beginning) (region-end)))
          (result-buf "*php*")
          (temp-file (make-temp-file "my-php-eval-region-")))
      (with-temp-file temp-file
        (insert "<?php \n" region-str))
      (shell-command (concat "php " temp-file) result-buf)
      (view-buffer-other-window result-buf t
                                (lambda (buf)
                                  (kill-buffer-and-window)
                                  (delete-file temp-file))))))



(require 'php-completion nil t)

;; ポイント位置のシンボルを PHP Manual で検索した結果をバッファに表示する。
;; php-completion.el, w3m が必要。
(defun phpman-at-point ()
  (interactive)
  (let* ((str-po (or (thing-at-point 'symbol) ""))
         (str-man (phpcmp-get-document-string str-po)))
    (switch-to-buffer (get-buffer-create "*php-manual*"))
    (erase-buffer)
    (insert str-man))
    (goto-char (point-min)))

;; 調べたい関数上で f1 押下することで実行
(add-hook 'php-mode-hook
  (lambda()
    (define-key php-mode-map [f1] 'phpman-at-point)))

(defun phpman (w)
  (interactive "sSearchWord: ")
  (let* ((str-man (phpcmp-get-document-string w)))
    (switch-to-buffer (get-buffer-create "*php-manual*"))
    (erase-buffer)
    (insert str-man))
    (goto-char (point-min)))


(defun phplint-thisfile ()
  (interactive)
  (compile (format "php -l %s" (buffer-file-name))))
