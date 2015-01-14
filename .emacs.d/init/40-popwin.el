
(require 'popwin)

(setq special-display-function 'popwin:special-display-popup-window)
(setq special-display-buffer-names '("*magit-commit*" "*magit-branches*"))
;; (setq popwin:special-display-config '(("*magit-commit*" :height 25)))

;; (push '(direx:direx-mode :position left :width 25 :dedicated t)
;;       popwin:special-display-config)


;;(setq display-buffer-function 'popwin:display-buffer)

;; (setq popwin:special-display-config nil)

;; (push '("*css*" :height 20) popwin:special-display-config)

;; (defun my-sass-to-css (begin end)
;;   "リージョンの Sass が生成する CSS を確認する"
;;   (interactive "r")
;;   (let* ((text (buffer-substring-no-properties begin end))
;;          (command (format "ruby -rubygems -e \"require 'sass'; puts Sass::Engine.new('%s').render\"" text))
;;          (buffer "*css*"))
;;     (when (get-buffer buffer)
;;       (kill-buffer buffer))
;;     (get-buffer-create buffer)
;;     (push '("*css*" :height 20) popwin:special-display-config)
;;     (call-process-shell-command command nil buffer t)
;;     (view-buffer-other-window buffer t (lambda (dummy) (kill-buffer-and-window)))))



;; (push '(dired-mode :position top) popwin:special-display-config)
