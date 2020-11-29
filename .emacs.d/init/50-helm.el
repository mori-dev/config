;;

(require 'helm-config)

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     nil ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)

(define-key global-map (kbd "M-y") 'helm-show-kill-ring)
(define-key global-map (kbd "M-x")     'helm-M-x)
(define-key global-map (kbd "M-r")     'helm-resume)
(define-key global-map (kbd "C-c i")   'helm-imenu)

;; minibuffer で C-k を押すと先頭から削除されるし kill ring にも追加されない件の対応
;; Emulate `kill-line' in helm minibuffer
(setq helm-delete-minibuffer-contents-from-point t)
(defadvice helm-delete-minibuffer-contents (before emulate-kill-line activate)
  "Emulate `kill-line' in helm minibuffer"
  (kill-new (buffer-substring (point) (field-end))))

(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-l") 'helm-mini)

(setq helm-display-function 'my-helm-display-buffer)

(defun my-helm-display-buffer (buf &optional resume)
      (delete-other-windows)
      ;; (split-window (selected-window) nil 'above)
      (split-window-right)
      (windmove-right)
      ;; (split-window-horizontally)
      ;; (pop-to-buffer buf))
      ;; (switch-to-buffer helm-current-buffer))
      (switch-to-buffer buf))

(require 'recentf-ext)

(recentf-mode 1)
(setq recentf-max-saved-items 100)
(setq recentf-save-file "~/.emacs.d/recentf")
(setq recentf-exclude '("/recentf" "COMMIT_EDITMSG" "/.?TAGS" "^/sudo:" "/\\.emacs\\.d/games/*-scores" "/\\.emacs\\.d/\\.cask/"))
(setq recentf-auto-cleanup 'never) ;; 存在しないファイルは消さない
;; 30秒に一度自動保存。この設定によってEmacs終了時以外にも履歴ファイルを保存してくれるようになる。
(setq recentf-auto-save-timer (run-with-idle-timer 30 t 'recentf-save-list))

(setq helm-mini-default-sources
      '(helm-source-buffers-list
        helm-source-recentf
	))

(setq helm-for-files-preferred-list
      '(helm-source-buffers-list
        ;; helm-source-recentf
        ;; helm-source-bookmarks
        helm-source-file-cache
        ;; helm-source-files-in-current-dir
        ;; helm-source-bookmark-set
	))
(define-key global-map (kbd "C-x C-r") 'helm-recentf)

(define-key global-map (kbd "M-o") 'helm-occur)



(helm-mode 1)

;; アクション選択ではなくタブ保管にする
;; For find-file etc.
(define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)
;; For helm-find-files etc.
(define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
;; helm-find-files でタブを 2 回押すと新しいファイル用のバッファが作成される件の対策
(defadvice helm-ff-kill-or-find-buffer-fname (around execute-only-if-exist activate)
  "Execute command only if CANDIDATE exists"
  (when (file-exists-p candidate)
    ad-do-it))

;; 候補のフィルタリングのロジック https://abicky.net/2014/01/04/170448/
(defadvice helm-ff-transform-fname-for-completion (around my-transform activate)
  "Transform the pattern to reflect my intention"
  (let* ((pattern (ad-get-arg 0))
         (input-pattern (file-name-nondirectory pattern))
         (dirname (file-name-directory pattern)))
    (setq input-pattern (replace-regexp-in-string "\\." "\\\\." input-pattern))
    (setq ad-return-value
          (concat dirname
                  (if (string-match "^\\^" input-pattern)
                      ;; '^' is a pattern for basename
                      ;; and not required because the directory name is prepended
                      (substring input-pattern 1)
                    (concat ".*" input-pattern))))))

(require 'helm-swoop)
(setq helm-swoop-split-direction 'split-window-horizontally)
(setq helm-swoop-move-to-line-cycle t)
(setq helm-swoop-use-line-number-face t)

(define-key global-map (kbd "M-n") 'helm-multi-swoop-all)

;;; FIXME: 効いていない
;; (require 'helm-migemo)
;; ;;; この修正が必要
;; (with-eval-after-load "helm-migemo"
;;   (defun helm-compile-source--candidates-in-buffer (source)
;;     (helm-aif (assoc 'candidates-in-buffer source)
;;         (append source
;;                 `((candidates
;;                    . ,(or (cdr it)
;;                           (lambda ()
;;                             ;; Do not use `source' because other plugins
;;                             ;; (such as helm-migemo) may change it
;;                             (helm-candidates-in-buffer (helm-get-current-source)))))
;;                   (volatile) (match identity)))
;;       source))
;;   ;; [2015-09-06 Sun]helm-match-plugin -> helm-multi-match変更の煽りを受けて
;;   (defalias 'helm-mp-3-get-patterns 'helm-mm-3-get-patterns)
;;   (defalias 'helm-mp-3-search-base 'helm-mm-3-search-base))

;; (require 'helm-projectile)
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)

;; (helm-projectile-on) Symbol’s value as variable is void: helm-compile-source-functions


;; (setq helm-locate-command
;;       "glocate %s %s"
;;       helm-locate-create-db-command
;;       "gupdatedb --output='%s' --localpaths='%s'")

;; (setq helm-locate-project-list
;;       (list "/Users/xcy/.emacs.d/"))

; helm-buffers-list のバッファ名の領域を広くとる
; C-] で詳細表示できる
(setq helm-buffer-details-flag nil)


;; プレビュー
;; off のときは　C-j (helm-execute-persistent-action)
;; (setq helm-follow-mode 1)
(setq helm-follow-mode-persistent t)

;; (add-to-list 'helm-completing-read-handlers-alist '(find-file . nil))
;; (add-to-list 'helm-completing-read-handlers-alist '(dired . nil))
;; (add-to-list 'helm-completing-read-handlers-alist '(howm-list-grep-fixed . nil))
