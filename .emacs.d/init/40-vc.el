;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; C-x v g が便利。

;; ;; 注釈の使いどころ
;; 時系列を追ってソースを探検するときにつかう。
;; 注釈とは、ソースの各行を最後に更新した人とそのリビジョンを表示する機能
;; 注釈の表示は、C-x v g (vc-annotate)
;; リビジョンを選んで注釈を表示するには、C-u C-x v g または履歴表示機能
;; 注釈バッファでの操作
;; j 該当行のリビジョンの注釈を表示
;; a 該当行の一つ前のリビジョンの注釈を表示
;; w 作業コピーのリビジョンの注釈を表示
;; n 今見ている次のリビジョンの注釈を表示
;; p 今見ている前のリビジョンの注釈を表示
;; d 該当行の差分を表示 (ファイル単位)
;; D 該当行の差分を表示 (チェンジセット単位) 
;; f 該当行のリビジョンの取り出し
;; l 該当行の履歴を表示

;; 怪しいコードを見つけたら、C-x v g で注釈を表示し、怪しいコードの該当行に移動して、j や a でその修正が入った時点にジャンプする。
;; そこから、n や p でその前後のリビジョンの修正を見ていくと時系列でコードに入った修正を見ていくことができる。
;; おかしなリビジョンを見つけたら差分や履歴を表示して周辺情報を得るとよい。


;; ;;履歴の表示
;; 履歴の表示 C-x v l
;; 履歴バッファでのコマンドはカーソルがあるリビジョンに対して行われる。
;; ただし、差分表示は、リージョン選択後 d や D を行うと、選択したリビジョン間の差分が表示される
;; 特定のリビジョンの差分を表示したい場合は、 C-u C-x v = 便利。



;; ;; 履歴バッファでの操作
;; n,tab 次のメッセージ
;; p,S-tab 前のメッセージ
;; f 該当リビジョンの取り出し
;; d 差分の表示 (ファイル単位)
;; D 差分の表示 (チェンジセット単位)
;; a 該当リビジョン注釈を表示


;; 保存時にVCの更新がもたつくので(setq vc-handled-backends nil)にした。これつかってる人いるのか？

;;;; avoid "Symbolic link to SVN-controlled source file; follow link? (yes or no)"
(setq vc-follow-symlinks t)

;; 履歴表示機能のキーバインドを "C-x v" 系に変更
(add-hook 'log-view-mode-hook
          (lambda ()
            (local-set-key (kbd "RET") 'log-view-find-revision)
            (local-set-key (kbd "C-c C-c") 'log-view-find-revision)
            (local-set-key (kbd "=") 'log-view-diff)
            (local-set-key (kbd "g") 'log-view-annotate-version)))


;; 履歴の表示で Ediff サポート機能の追加
(add-hook 'log-view-mode-hook
          (lambda ()
            (local-set-key (kbd "e") 'log-view-ediff)))

(defun log-view-ediff (beg end &optional startup-hooks)
  (interactive
   (list (if mark-active (region-beginning) (point))
         (if mark-active (region-end) (point))))
  (let ((fr (log-view-current-tag beg))
        (to (log-view-current-tag end)))
    (when (string-equal fr to)
      (save-excursion
        (goto-char end)
        (log-view-msg-next)
        (setq to (log-view-current-tag))))
    (require 'ediff-vers)
    (ediff-vc-internal fr to startup-hooks)))

(defun log-view-ediff-setup ()
  (set (make-local-variable 'ediff-keep-tmp-versions) t))

(defvar log-view-ediff-window-configuration nil)

(defun log-view-ediff-before-setup ()
  (setq log-view-ediff-window-configuration
        (if (eq this-command 'log-view-ediff)
            (current-window-configuration)
          nil)))

(defun log-view-ediff-cleanup ()
  (when log-view-ediff-window-configuration
    (ignore-errors
      (set-window-configuration log-view-ediff-window-configuration)))
  (setq log-view-ediff-window-configuration nil))

(require 'ediff-init)
(add-hook 'ediff-mode-hook 'log-view-ediff-setup)
(add-hook 'ediff-before-setup-hook 'log-view-ediff-before-setup)
;; add it after ediff-cleanup-mess
(add-hook 'ediff-quit-hook 'log-view-ediff-cleanup t)


;; (custom-set-faces
;;  '(diff-added ((t (:foreground "Green"))) 'now)
;;  '(diff-removed ((t (:foreground "Red"))) 'now)
;;  )


;; C-x v g で画面分割しない

(defadvice vc-annotate (around my-vc-annotate activate)
;; (defun vc-annotate (file rev &optional display-mode buf move-point-to)
  (interactive
   (save-current-buffer
     (vc-ensure-vc-buffer)
     (list buffer-file-name
	   (let ((def (vc-working-revision buffer-file-name)))
	     (if (null current-prefix-arg) def
	       (read-string
		(format "Annotate from revision (default %s): " def)
		nil nil def)))
	   (if (null current-prefix-arg)
	       vc-annotate-display-mode
	     (float (string-to-number
		     (read-string "Annotate span days (default 20): "
				  nil nil "20")))))))
  (vc-ensure-vc-buffer)
  (setq vc-annotate-display-mode display-mode) ;Not sure why.  --Stef
  (let* ((temp-buffer-name (format "*Annotate %s (rev %s)*" (buffer-name) rev))
         (temp-buffer-show-function 'vc-annotate-display-select)
         ;; If BUF is specified, we presume the caller maintains current line,
         ;; so we don't need to do it here.  This implementation may give
         ;; strange results occasionally in the case of REV != WORKFILE-REV.
         (current-line (or move-point-to (unless buf
					   (save-restriction
					     (widen)
					     (line-number-at-pos))))))
    (message "Annotating...")
    ;; If BUF is specified it tells in which buffer we should put the
    ;; annotations.  This is used when switching annotations to another
    ;; revision, so we should update the buffer's name.
    (when buf (with-current-buffer buf
		(rename-buffer temp-buffer-name t)
		;; In case it had to be uniquified.
		(setq temp-buffer-name (buffer-name))))
    (with-output-to-temp-buffer temp-buffer-name
      (let ((backend (vc-backend file)))
        (vc-call-backend backend 'annotate-command file
                         
                         (switch-to-buffer temp-buffer-name) rev)
                         ;; (get-buffer temp-buffer-name) rev)        
        ;; we must setup the mode first, and then set our local
        ;; variables before the show-function is called at the exit of
        ;; with-output-to-temp-buffer
        (with-current-buffer temp-buffer-name
          (unless (equal major-mode 'vc-annotate-mode)
            (vc-annotate-mode))
          (set (make-local-variable 'vc-annotate-backend) backend)
          (set (make-local-variable 'vc-annotate-parent-file) file)
          (set (make-local-variable 'vc-annotate-parent-rev) rev)
          (set (make-local-variable 'vc-annotate-parent-display-mode)
               display-mode))))

    (with-current-buffer temp-buffer-name
      (vc-exec-after
       `(progn
          ;; Ideally, we'd rather not move point if the user has already
          ;; moved it elsewhere, but really point here is not the position
          ;; of the user's cursor :-(
          (when ,current-line           ;(and (bobp))
            (goto-line ,current-line)
            (setq vc-sentinel-movepoint (point)))
          (unless (active-minibuffer-window)
            (message "Annotating... done")))))))


(defun vc-annotate-goto-line ()
  (interactive)
  (unless (eq major-mode 'vc-annotate-mode)
    (error "vc-annotate-goto-line must be used on a VC-Annotate buffer"))
  (let* ((name (buffer-name))
         (base (and (string-match "Annotate \\(.*\\) (rev" name)
                    (match-string 1 name)))
         (line (save-restriction
                 (widen)
                 (line-number-at-pos))))
    (with-current-buffer (get-buffer base)
      ;; (pop-to-buffer (current-buffer)) 
      (switch-to-buffer (current-buffer)) ;ウィンドウ分割が嫌なので s/pop-to-buffer/switch-to-buffer/ しました
      (save-restriction
        (widen)
        (goto-char (point-min))
        (forward-line (1- line))
        (recenter)))))

(add-hook 'vc-annotate-mode-hook
          (lambda ()
            (define-key vc-annotate-mode-map (kbd "RET") 'vc-annotate-goto-line)))
