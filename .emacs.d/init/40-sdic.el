;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

(autoload 'sdic-describe-word "sdic" "英単語の意味を調べる" t nil)
(global-set-key "\C-cW" 'sdic-describe-word)
(autoload 'sdic-describe-word-at-point "sdic" "カーソルの位置の英単語の意味を調べる" t nil)
(global-set-key "\C-cW" 'sdic-describe-word-at-point)

(setq sdic-eiwa-dictionary-list
      '((sdicf-client "~/Dropbox/data/eijiro/eijirou.sdic")))
(setq sdic-waei-dictionary-list
      '((sdicf-client "~/Dropbox/data/eijiro/waeijirou.sdic")))
(setq sdic-default-coding-system 'utf-8-unix)
;(sdic-describe-word "acti")


(require 'sdic)
(defadvice sdic-display-buffer (around my-sdic-display-buffer activate)
;; (defun sdic-display-buffer (&optional start-point)
  ;; "検索結果表示バッファを表示する関数"
  (unwind-protect
    (let ((buf (set-buffer sdic-buffer-name))
          (p (or start-point (point))))
      (switch-to-buffer buf)
      (if (and sdic-warning-hidden-entry
               (> p (point-min)))
          (message "この前にもエントリがあります。"))
      (goto-char p))))

; 検索結果表示バッファで引いた単語をハイライト表示する
(defadvice sdic-search-eiwa-dictionary (after highlight-phrase (arg))
    (highlight-phrase arg "hi-yellow"))
(defadvice sdic-search-waei-dictionary (after highlight-phrase (arg))
    (highlight-phrase arg "hi-yellow"))

(ad-activate 'sdic-search-eiwa-dictionary)
(ad-activate 'sdic-search-waei-dictionary)
