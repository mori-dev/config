;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; anything 関連は init-anything.el で定義している
(require 'cl)
(require 'key-chord)
(setq key-chord-two-keys-delay 0.04)
;; (setq key-chord-two-keys-delay 0.1)
(key-chord-mode 1)
;; (key-chord-define-global "i9" 'shk-tabbar-next)
;; (key-chord-define-global "u8" 'shk-tabbar-prev)
(key-chord-define-global "0o" (lambda () (interactive) (goto-char (point-min))))
(key-chord-define-global "-p" (lambda () (interactive) (goto-char (point-max))))

;; (key-chord-define mozc-mode-map "8u" "hoge")
(key-chord-define-global "8u" "hoge")
;; (key-chord-define-global "9i" ")")

(key-chord-define-global "1\\" 'shell-pop)
;(key-chord-define-global "mp" 'memo-pop)
;; (key-chord-define-global "hs" 'my-toggle-hideshow-all)
(key-chord-define-global "qw" 'lpho-switch-to-previous-buffer)
(key-chord-define-global "-^" "->")
(key-chord-define-global "=~" "=>")
(key-chord-define-global "^\\" "<-")
;; (key-chord-define-global "wt" 'window-toggle-division)
(key-chord-define-global "\"\"" 'my-insert-double-quote)
(key-chord-define-global "\'\'" 'my-insert-single-quote)
(key-chord-define-global "CC" 'cc)
(key-chord-define-global "z[" 'my-insert-kakko)

(defun my-insert-kakko()
  (interactive)
  (insert "【】")
  (backward-char 1))

;(key-chord-define-global "qw" '(lambda () (interactive) (switch-to-buffer nil)))
(key-chord-define-global "9i" 'other-window)
(key-chord-define-global "3e" 'other-window)
;(key-chord-define-global "la" "lambda")

;(key-chord-define-global "3e" 'my-region-stirng-to-php)
;(key-chord-define-global "4r" 'var_dump-exitize)

(defun var_dump-exitize (start end)
  (interactive "r")
  (if mark-active
    (kill-new (concat "var_dump(" (buffer-substring start end) ");exit;"))
    (kill-new (concat "var_dump(" (ariel-thing-at-point 'symbol) ");exit;"))))

;; (defun var_dump-exitize (start end)
;;   (interactive "r")
;;   (if mark-active
;;     (progn
;;       (goto-char end)
;;       (insert ");exit;")
;;       (goto-char start)
;;       (insert "var_dump("))
;;     (kill-new
;;       (concat "var_dump(" (ariel-thing-at-point 'symbol) ");exit;"))))

;; (defun var_dump-exitize ()
;;   (interactive)
;;   (kill-new
;;    (concat "var_dump(" (ariel-thing-at-point 'symbol) ");exit;")))

(defun ariel-thing-at-point (thing)
 (if (get thing 'thing-at-point)
     (funcall (get thing 'thing-at-point))
   (let ((bounds (bounds-of-thing-at-point thing)))
     (if bounds
         (let ((ov (make-overlay (car bounds) (cdr bounds))))
           (overlay-put ov 'face 'region)
           (sit-for 3)
           (delete-overlay ov)
           (buffer-substring (car bounds) (cdr bounds)))))))

;; ;; 保存前後の差分を目立たせる
;; (global-highlight-changes-mode t)
;; (setq highlight-changes-visibility-initial-state nil); initially hide
;; ;; toggle visibility
;; (key-chord-define-global "hc" 'highlight-changes-visible-mode)
;;(global-set-key [f10] 'highlight-changes-visible-mode)

;; remove the change-highlight in region
;(global-set-key (kbd "S-<f8>")    'highlight-changes-remove-highlight)
;; alt-pgup/pgdown jump to the previous/next change
;; if you're not already using it for something else...
;(global-set-key (kbd "<M-prior>") 'highlight-changes-next-change)
;(global-set-key (kbd "<M-next>")  'highlight-changes-previous-change)

;;色の設定
;(set-face-foreground 'highlight-changes nil)
;(set-face-background 'highlight-changes "#382f2f")
;(set-face-foreground 'highlight-changes-delete nil)
;(set-face-background 'highlight-changes-delete "#916868")
;;以下の書き方でもOK
;;(highlight-changes ((t (:foreground nil :background "#382f2f"))))
;;(highlight-changes-delete ((t (:foreground nil :background "#916868"))))
(global-set-key '[C-right] 'highlight-changes-next-change)
(global-set-key '[C-left]  'highlight-changes-previous-change)

;(key-chord-define hs-minor-mode-map "hs"  'my-toggle-hideshow-all)


;(key-chord-define-global "de" 'anything-dabbrev-find-all-buffers)

;(key-chord-define-global "jj" 'shk-tabbar-next)
;; Examples:
;;
;;      (key-chord-define-global "''"     "`'\C-b")
;;      (key-chord-define-global ",,"     'indent-for-comment)
;;      (key-chord-define-global "qq"     "the ")
;;      (key-chord-define-global "QQ"     "The ")

;;

(defun my-fullscreen ()
  (interactive)
  (let ((fullscreen (frame-parameter (selected-frame) 'fullscreen)))
    (cond
     ((null fullscreen)
      (set-frame-parameter (selected-frame) 'fullscreen 'fullboth))
     (t
      (iconify-frame))))
                                        ;      (set-frame-parameter (selected-frame) 'fullscreen 'nil))))
  (redisplay))

;(key-chord-define-global "3e" 'my-fullscreen)


(setq lpho-ignore-list  '( "*ansi-term*" "*anything*" "*anything action*" " *Minibuf-0*" " *Minibuf-1*" "*Messages*" "*Moccur*" "*php-completion document*" "*Help*" "TAGS"))
(defun lpho-switch-to-previous-buffer ()
  "直前のバッファと行き来する"
  (interactive)
  (condition-case err
      (cl-labels
          ((_lpho-switch-to-previous-buffer (target)
            (if (null (member (buffer-name (cadr target))
                              lpho-ignore-list))
                (switch-to-buffer (cadr target))
              (_lpho-switch-to-previous-buffer (cdr target)))))
        (_lpho-switch-to-previous-buffer (buffer-list)))
    (error (message "error: %s" (error-message-string err)))))



(defun my-switch-to-scratch/current-buffer ()
  (interactive)
  (if (string-equal (buffer-name) "*scratch*")
     (switch-to-buffer (cadr (buffer-list)))
    (switch-to-buffer (get-buffer "*scratch*"))))

(key-chord-define-global "0-" 'my-switch-to-scratch/current-buffer)

;; /Users/mori/.emacs.d/init/70-auto-complete.el
(key-chord-define-global "ui" 'ac-complete-flow)
