;; ;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; ;; flymake
;; ;; 参考URL
;; ;; http://www.emacswiki.org/cgi-bin/wiki/FlyMake
;; ;; http://homepage.mac.com/naoki.koguro/prog/codecheck/index-j.html
;; ;; php, javascript ;http://openlab.dino.co.jp/2008/08/05/223548324.html
;; ;; gauche http://d.hatena.ne.jp/higepon/20080309/1205043148
;; ;; ruby ;http://d.hatena.ne.jp/gan2/20080702/1214972962
;; (when (and (require 'flymake nil t))
;;   ;; (set-face-background 'flymake-errline "red4")
;;   ;; (set-face-foreground 'flymake-errline "white")
;;   ;; (set-face-background 'flymake-warnline "dark slate blue")
;;   ;; (set-face-foreground 'flymake-warnline "white")

;;   (set-face-background 'flymake-errline nil)
;;   (set-face-foreground 'flymake-errline nil)
;;   (set-face-background 'flymake-warnline nil)
;;   (set-face-foreground 'flymake-warnline nil)



;;   (defadvice flymake-display-warning (around my-flymake-display-warning activate)
;;     (message warning))

;;   ;; (global-set-key "\C-cd" 'flymake-display-err-menu-for-current-line)

;;   ;; エラーをミニバッファに表示
;;   (defun flymake-display-err-minibuf ()
;;     "Displays the error/warning for the current line in the minibuffer"
;;     (interactive)
;;     (let* ((line-no             (flymake-current-line-no))
;;            (line-err-info-list  (nth 0 (flymake-find-err-info flymake-err-info line-no)))
;;            (count               (length line-err-info-list)))
;;       (while (> count 0)
;;         (when line-err-info-list
;;           (let* ((file       (flymake-ler-file (nth (1- count) line-err-info-list)))
;;                  (full-file  (flymake-ler-full-file (nth (1- count) line-err-info-list)))
;;                  (text (flymake-ler-text (nth (1- count) line-err-info-list)))
;;                  (line       (flymake-ler-line (nth (1- count) line-err-info-list))))
;;             (message "[%s] %s" line text)))
;;         (setq count (1- count)))))

;;   ;; (global-set-key "\C-cd" 'flymake-display-err-minibuf)
;;   (global-set-key "\C-cd" 'flymake-display-err-menu-for-current-line)


;;   ;; flymakeのsyntax-checkが異常終了しても無視するようにする
;;   (defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
;;     (setq flymake-check-was-interrupted t))
;;   (ad-activate 'flymake-post-syntax-check)


;;   ;; ;;;; html用
;;   ;; ;; http://www.w3.org/People/asada/tidy/
;;   ;; (defun flymake-html-init ()
;;   ;;   (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;   ;;                      'flymake-create-temp-inplace))
;;   ;;          (local-file (file-relative-name
;;   ;;                       temp-file
;;   ;;                       (file-name-directory buffer-file-name))))
;;   ;;     (list "tidy" (list local-file))))

;;   ;; (add-to-list 'flymake-allowed-file-name-masks
;;   ;;              '("\\.html$\\|\\.ctp" flymake-html-init))

;;   ;; (add-to-list 'flymake-err-line-patterns
;;   ;;              '("line \\([0-9]+\\) column \\([0-9]+\\) - \\(Warning\\|Error\\): \\(.*\\)"
;;   ;;                nil 1 2 4))
;;   ;; ;;(add-hook 'nxml-mode-hook 'flymake-mode)

;;   )
