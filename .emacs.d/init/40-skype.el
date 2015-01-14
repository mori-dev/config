;; ;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; (global-set-key (kbd "M-6") 'skype--anything-command)

;; (require 'skype)

;; (setq skype--emoticon-path "~/.emacs.d/elisp/skype/emoticons")
;; ;;a の代用
;; (define-key skype--chat-mode-map (kbd "C-c C-c") 'skype--chat-mode-message-command)

;; ;; (setq skype--my-user-handle "kmori000")
;; ;; (skype--init)

;; (set-face-foreground 'skype--face-my-time-field "coral")
;; (set-face-background 'skype--face-my-time-field "DimGray")
;; (set-face-underline-p 'skype--face-my-time-field nil)
;; (set-face-bold-p 'skype--face-my-time-field nil)
;; ;; skype--face-other-time-field
;; (set-face-foreground 'skype--face-other-time-field "coral")
;; (set-face-background 'skype--face-other-time-field "black")
;; (set-face-underline-p 'skype--face-other-time-field nil)
;; (set-face-bold-p 'skype--face-other-time-field nil)
;; ;; skype--face-user-field
;; (set-face-foreground 'skype--face-user-field "coral")
;; (set-face-background 'skype--face-user-field "black")
;; (set-face-underline-p 'skype--face-user-field nil)
;; (set-face-bold-p 'skype--face-user-field nil)
;; ;; skype--face-optional-field
;; (set-face-foreground 'skype--face-optional-field "coral")
;; (set-face-background 'skype--face-optional-field "black")
;; (set-face-underline-p 'skype--face-optional-field nil)
;; (set-face-bold-p 'skype--face-optional-field nil)
;; ;; skype--face-my-message
;; (set-face-foreground 'skype--face-my-message "tomato")
;; (set-face-background 'skype--face-my-message "black")
;; (set-face-underline-p 'skype--face-my-message t)
;; (set-face-bold-p 'skype--face-my-message t)
;; ;; skype--face-other-message
;; (set-face-foreground 'skype--face-other-message "Darkorange3")
;; (set-face-background 'skype--face-other-message "black")
;; (set-face-underline-p 'skype--face-other-message t)
;; (set-face-bold-p 'skype--face-other-message t)

;; (defun my-skype ()
;;   (interactive)
;;   (require 'skype)
;;   (setq skype--my-user-handle "mori_biz")
;;   (skype--init)
;;   ;(skype--open-all-users-buffer-command)
;;   )
;; (my-skype)

;; ;;上書き
;; ;; (defun skype--message (text)
;; ;;   (unless (active-minibuffer-window)
;; ;;     (message text)
;; ;;     (if (executable-find "notify-send")
;; ;; ;      (call-process-shell-command "notify-send" nil t 0 (concat text)))))
;; ;;       (call-process-shell-command "notify-send \"メッセージ到着！！！！！！\""))))
