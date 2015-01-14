;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-


;; キーバインド
;; L 履歴
;; f 進む
;; b 戻る
;; t その info の トップへ移動
;; d 全 info の目次(dir)へ移動

(add-hook 'Info-mode-hook
  (lambda ()
     (define-key Info-mode-map "e" 'yafastnav-info-jump-to-current-screen)))


(eval-after-load "info" '(require 'info+))
(eval-after-load "info"
  '(progn
     (define-key Info-mode-map "f" 'Info-history-forward)
     (define-key Info-mode-map "b" 'Info-history-back)
  ))

(defadvice info (around my-info activate)
  (interactive (list
                (if (and current-prefix-arg (not (numberp current-prefix-arg)))
                    (read-file-name "Info file name: " nil nil t))
                (if (numberp current-prefix-arg)
                    (format "*info*<%s>" current-prefix-arg))))
  (switch-to-buffer (or buffer "*info*"))
  (if (and buffer (not (eq major-mode 'Info-mode)))
      (Info-mode))
  (if file-or-node
      (Info-goto-node
       (if (and (stringp file-or-node) (string-match "(.*)" file-or-node))
           file-or-node
         (concat "(" file-or-node ")")))
    (if (and (zerop (buffer-size))
	     (null Info-history))
	(Info-directory))))

;; info バッファを開くときにウィンドウ分割しない
(defadvice Info-find-node (around my-Info-find-node activate)
  (info-initialize)
  (setq filename (Info-find-file filename))
  ;; Go into Info buffer.
  (or (eq major-mode 'Info-mode) (switch-to-buffer "*info*"))
  ;; Record the node we are leaving, if we were in one.
  (and (not no-going-back)
       Info-current-file
       (push (list Info-current-file Info-current-node (point))
             Info-history))
  (Info-find-node-2 filename nodename no-going-back))


(setq anything-c-source-info-cl-ja
  '((info-index . "cl-j")))
(defvar anything-c-source-info-hustler-ja
  '((info-index . "hustler")))
(setq anything-c-source-info-slime-ja
  '((info-index . "slime")))

(defun anything-info-ja-at-point ()
  "Preconfigured `anything' for searching info at point."
  (interactive)
  (anything '(
              anything-c-source-info-slime-ja
              anything-c-source-info-cl-ja
              ;; anything-c-source-info-hustler-ja
              )
            (thing-at-point 'symbol) nil nil nil "*anything info*"))
;; (add-to-list 'load-path "~/.emacs.d/info")
;; (add-to-list 'load-path "~/.emacs.d/info/python-info")
;; (add-to-list 'load-path "~/.emacs.d/info/python-info")
(require 'info)


(add-to-list 'Info-default-directory-list "~/.emacs.d/info/")
(add-to-list 'Info-default-directory-list "~/.emacs.d/info/python-info/")
(add-to-list 'Info-default-directory-list "~/.emacs.d/info/emacs-info/")
(add-to-list 'Info-default-directory-list "~/.emacs.d/info/r5rs/")

(require 'anything nil t)
(require 'python-mode nil t)

(defvar anything-c-source-info-python-lib-ja
  '((info-index . "python-lib-jp.info")))
(defvar anything-c-source-info-python-ref-ja
  '((info-index . "python-ref-jp.info")))
(defvar anything-c-source-info-python-api-ja
  '((info-index . "python-api-jp.info")))
(defvar anything-c-source-info-python-ext-ja
  '((info-index . "python-ext-jp.info")))
(defvar anything-c-source-info-python-tut-ja
  '((info-index . "python-tut-jp.info")))
(defvar anything-c-source-info-python-dist-ja
  '((info-index . "python-dist-jp.info")))

(defun anything-info-python-at-point ()
  "Preconfigured `anything' for searching info at point."
  (interactive)
  (anything '(anything-c-source-info-python-lib-ja
              anything-c-source-info-python-ref-ja
              anything-c-source-info-python-api-ja
              anything-c-source-info-python-ext-ja
              anything-c-source-info-python-tut-ja
              anything-c-source-info-python-dist-ja)
            (thing-at-point 'symbol) nil nil nil "*anything info*"))

(add-hook 'python-mode-hook
  (lambda()
    (define-key py-mode-map [f1] 'anything-info-python-at-point)))

(defun anything-info-bash-at-point ()
  "Preconfigured `anything' for searching info at point."
  (interactive)
  (anything '(anything-c-source-info-bash)
            (thing-at-point 'symbol) nil nil nil "*anything info*"))

(add-hook 'sh-mode-hook
  (lambda()
    (define-key sh-mode-map [f1] 'anything-info-bash-at-point)))
