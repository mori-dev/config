;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; 作成中

;; (defvar sdic-candidate-file "~/.emacs.d/sdic-candidate-file.txt")
(setq sdic-candidate-file "~/Dropbox/data/sdic-candidate-file.txt")

(defun anything-c-source-sdic-init ()
  (unless (file-exists-p sdic-candidate-file)
    (anything-sdic-update-sdic-candidate-file)))

(defun anything-sdic-update-sdic-candidate-file ()
  (interactive)
  (with-temp-buffer
    (let ((sort-fold-case t))
      (insert
       (mapconcat
        'car
        (sdic-search-multi-dictionaries sdic-eiwa-symbol-list "") "\n"))
      (sort-lines nil (point-min) (point-max))
      (write-file sdic-candidate-file))))

;; (defvar anything-c-source-sdic
(setq anything-c-source-sdic
  '((init . anything-c-source-sdic-init)
    (name . "sdic candidate")
    (candidate-number-limit . 10000)
    (grep-candidates . sdic-candidate-file)
    (action 
       ("show" . anything-c-sdic-action))
    ;; (persistent-action . anything-c-sdic-persistent-action)
    ;; (persistent-action . anything-c-sdic-action)
    (requires-pattern . 2)))

(defun anything-c-sdic-action (candidate)
  (let ((buffer (get-buffer-create sdic-buffer-name))
        (pop-up-windows nil))
    (with-current-buffer buffer
      (sdic-mode)
      (setq buffer-read-only nil)
      (erase-buffer)
      (funcall (if (string-match "\\cj" candidate)
                   'sdic-search-waei-dictionary
                 'sdic-search-eiwa-dictionary)
               candidate)
      (setq buffer-read-only t)
      (set-buffer-modified-p nil))
    (pop-to-buffer buffer)
    (goto-char (point-min))
    (re-search-forward (concat "^" candidate))
    ;; (re-search-forward candidate)
    (move-beginning-of-line 1)
    (recenter 0)
    ))
    

(defun anything-sdic ()
  (interactive)
    (anything 'anything-c-source-sdic))

;; キーバインド
(eval-after-load "init-keychord"
  '(progn
     (key-chord-define-global "EE" 'anything-sdic)))


;; 先行実装 (コメントは作者のもの)

;;http://www.teu.ac.jp/linux/tuigwaa/pub/Member/06/mayotako
;;anything-sourcesの末尾に記述推奨
;;actionは未実装．もっとうまい実装あるよなぁ，と思いつつ動けばOKな感じで．
;; (setq anything-c-source-sdic
;;   '((name . "sdic")
;;     (init . (lambda() nil))
;;     (candidates . (lambda ()
;;                     (let ((result
;;                            (flet ((message (n) n)) ;;sdicのメッセージを非表示
;;                              (sdic-describe-word anything-pattern))))
;;                       (prog1
;;                           (when result
;;                             (with-current-buffer "*sdic*"
;;                               (split-string (buffer-string) "\n" t)))
;;                         (set-buffer "*anything*"))) ;;こんな実装で本当にいいのか
;;                     ))
;;     (requires-pattern . 3)
;;     (volatile)))
