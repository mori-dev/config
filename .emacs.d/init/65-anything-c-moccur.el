;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;;; anything-c-moccurの設定
(require 'anything-c-moccur)
(require 'anything-c-moccur-opt)

(global-set-key (kbd "C-M-s") 'anything-c-moccur-isearch-forward)
(global-set-key (kbd "C-M-r") 'anything-c-moccur-isearch-backward)


(setq anything-c-moccur-recenter-count 5); 移動後の recenter の値

(setq anything-c-moccur-anything-idle-delay 0.2) ;`anything-idle-delay'
(setq anything-c-moccur-higligt-info-line-flag t) ; `anything-c-moccur-dmoccur'などのコマンドでバッファの情報をハイライトする
(setq anything-c-moccur-enable-auto-look-flag t) ; 現在選択中の候補の位置を他のwindowに表示する
(setq anything-c-moccur-enable-initial-pattern t) ; `anything-c-moccur-occur-by-moccur'の起動時にポイントの位置の単語を初期パターンにする
(setq anything-c-moccur-push-mark-flag t); non-nilならコマンド起動時に現在のポイントにマークをセットする C-x C-x で戻れる。
;;; キーバインドの割当
(global-set-key (kbd "M-o") 'anything-c-moccur-occur-by-moccur) ;バッファ内検索
;(global-set-key (kbd "M-C-o") 'anything-c-moccur-dmoccur) ;ディレクトリ
(global-set-key (kbd "M-n") 'anything-c-moccur-buffer-list) ;開いているバッファ
(global-set-key (kbd "M-S-o") 'anything-c-moccur-opt-buffer-list) ;開いているバッファ

(define-key anything-c-moccur-anything-map (kbd "M-q")  'anything-c-moccur-query-replace-regexp)


;; (eval-after-load "init-keychord"
;;   '(progn
;;      (key-chord-define-global "SS" 'anything-c-moccur-isearch-forward)
;;      (key-chord-define-global "RR" 'anything-c-moccur-isearch-backward)))



(add-hook 'dired-mode-hook ;dired
          '(lambda ()
             (local-set-key (kbd "O") 'anything-c-moccur-dired-do-moccur-by-moccur)))


(defun anything-c-moccur-buffer-list-define-occur-command (initial)
  (lexical-let ((initial initial))
    (lambda () (interactive)
      (anything (list anything-c-source-moccur-buffer-list) initial))))

;;(global-set-key (kbd "M-h") (anything-c-moccur-buffer-list-define-occur-command "todo "))



(require 'cl)
(defvar anything-cycle-task-count 0)

(defun anything-cycle-task ()
  (interactive)
  (let ((los '("\\_<todo\\_>"
                "\\_<memo\\_>"
                "\\_<kludge\\_>"                  
                "\\_<fixme\\_>"
                "\\_<bug\\_>"                  
                "\\_<todo\\_>\\|\\_<memo\\_>\\|\\_<fixme\\_>\\|\\_<bug\\_>\\|\\_<kludge\\_>")))
    (if (eq this-command real-last-command)
        (incf anything-cycle-task-count)
      (setq anything-cycle-task-count 0))
    (when (>= anything-cycle-task-count (length los))
      (setq anything-cycle-task-count 0))
    (delete-minibuffer-contents)
    (let ((sep (nth anything-cycle-task-count los)))
      (insert sep))))

(define-key anything-c-moccur-anything-map (kbd "T") 'anything-cycle-task)
