;;C-u C-x =で文字についての情報が詳しくみえる
(defun scroll-one-line-up ()
 "一回に一行のスクロールアップ"
 (interactive)
 (scroll-up 1))

(defun scroll-one-line-down ()
 "一回に一行のスクロールダウン"
 (interactive)
 (scroll-down 1))

(global-set-key (kbd "C-M-v") 'scroll-one-line-up)
(global-set-key (kbd "C-M-g") 'scroll-one-line-down)


;;;; 折り返し表示ON/OFF

(setq truncate-lines nil)            ;; 長い行の折り返し表示を nil:しない。 t:する。
(defun toggle-truncate-lines ()
 "折り返し表示をトグル動作します."
 (interactive)
 (if truncate-lines      (setq truncate-lines nil)
   (setq truncate-lines t))
 (recenter))
(global-set-key "\C-c\C-l" 'toggle-truncate-lines) ; 折り返し表示ON/OFF
;; (defalias 'tt 'truncate-lines)


(add-hook 'emacs-lisp-mode-hook
  (lambda()
    (define-key emacs-lisp-mode-map (kbd "C-j") 'eval-print-last-sexp)))

(add-hook 'lisp-interaction-mode-hook
  (lambda()
    (emacs-lisp-mode)))


;; 時間挿入
(defun put-times (&optional prefix)
  (interactive "P")
  (insert 
   (cond
    ((not prefix)
     (current-time-string))
    ((equal prefix '(4))
     (format-time-string "%Y%m%d"))
    (t
     (format-time-string "%Y%m%d%H%M")))))

(global-set-key "\C-ct" 'put-times)


;; http://emacsredux.com/blog/2013/03/28/google/
(defun google ()
  "Google the selected region if any, display a query prompt otherwise."
  (interactive)
  (browse-url
   (concat
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q="
    (url-hexify-string (if mark-active
         (buffer-substring (region-beginning) (region-end))
       (read-string "Google: "))))))

(global-set-key (kbd "C-c g") 'google)

;; http://emacsredux.com/blog/2013/03/27/copy-filename-to-the-clipboard/
(defun copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))

(global-set-key (kbd "C-M-9") 'copy-file-name-to-clipboard)

(defun uniq-region (begin end)
  ;; リージョンに対して"uniq"を実行
  (interactive "r")
  (call-process-region begin end "uniq" t t))

(defun sort-u-region (begin end)
  ;; リージョンに対して"sort -u"を実行
  (interactive "r")
  (call-process-region begin end "sort" t t nil "-u"))



;; バッファで日本語入力中でもミニバッファでは ASCII にする。
(mac-auto-ascii-mode 1)

; カーソルの色を日本語とASCIIで分ける
;; https://qiita.com/takaxp/items/a86ee2aacb27c7c3a902#%E3%83%A2%E3%83%BC%E3%83%89%E3%83%A9%E3%82%A4%E3%83%B3%E5%B7%A6%E7%AB%AF%E3%81%A7%E5%85%A5%E5%8A%9B%E3%82%BF%E3%82%A4%E3%83%97%E3%82%92%E7%A2%BA%E8%AA%8D%E3%81%A7%E3%81%8D%E3%81%AA%E3%81%84

(defvar my:cursor-color-ime-on "#FF9300")
(defvar my:cursor-color-ime-off "#91C3FF") ;; #FF9300, #999999, #749CCC
(defvar my:cursor-type-ime-on '(bar . 2)) ;; box
(defvar my:cursor-type-ime-off '(bar . 2))

(when (fboundp 'mac-input-source)
    (defun my:mac-keyboard-input-source ()
      (if (string-match "\\.Roman$" (mac-input-source))
          (progn
            (setq cursor-type my:cursor-type-ime-off)
            (add-to-list 'default-frame-alist
                         `(cursor-type . ,my:cursor-type-ime-off))
            (set-cursor-color my:cursor-color-ime-off))
        (progn
          (setq cursor-type my:cursor-type-ime-on)
          (add-to-list 'default-frame-alist
                       `(cursor-type . ,my:cursor-type-ime-on))
          (set-cursor-color my:cursor-color-ime-on)))))

(when (and (fboundp 'mac-auto-ascii-mode)
           (fboundp 'mac-input-source))
      ;; IME ON/OFF でカーソルの種別や色を替える
      (add-hook 'mac-selected-keyboard-input-source-change-hook
                'my:mac-keyboard-input-source)
      (my:mac-keyboard-input-source))

;; たまにカーソルの色が残ってしてしまう．
;; IME ON で英文字打ったあととに，色が変更されないことがある．禁断の対処方法．
(when (fboundp 'mac-input-source)
  (run-with-idle-timer 3 t 'my:mac-keyboard-input-source))




(require 'cl-lib)

(defvar my-killed-file-name-list nil)

(defun my-push-killed-file-name-list ()
  (when (buffer-file-name)
    (push (expand-file-name (buffer-file-name)) my-killed-file-name-list)))

(defun my-pop-killed-file-name-list ()
  (interactive)
  (unless (null my-killed-file-name-list)
    (find-file (pop my-killed-file-name-list))))

(add-hook 'kill-buffer-hook 'my-push-killed-file-name-list)

(defun my-kill-buffer ()
  (interactive)
  (kill-buffer (buffer-name)))

(global-set-key "\C-xk" 'my-kill-buffer)
(global-set-key "\C-x/" 'my-pop-killed-file-name-list)
