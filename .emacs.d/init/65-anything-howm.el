;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

(require 'anything-howm)

;; (setq anything-howm-recent-menu-number-limit 600)
;; (global-set-key (kbd "M-3") 'anything-howm-menu-command)
;; (global-set-key (kbd "C-2") 'anything-howm-menu-command)
;; (global-set-key (kbd "C-3") 'anything-howm-cached-howm-menu)
;; (setq anything-howm-data-directory "~/Dropbox/howm")

(setq ah:recent-menu-number-limit 1000)
(global-set-key (kbd "M-3") 'ah:menu-command)
(global-set-key (kbd "C-2") 'ah:menu-command)
;; (global-set-key (kbd "C-3") 'ah:menu-command)
(global-set-key (kbd "C-3") 'ah:cached-howm-menu)  ;; deferred 導入で不要になったはず
(setq ah:data-directory "~/Dropbox/howm")


;; 左右分割
(defadvice ah:display-buffer (around my-anything-default-display-buffer activate)
  (delete-other-windows)
  (split-window (selected-window) nil t)
  (pop-to-buffer buf))

;; (anything '(anything-c-source-howm-recent))
;; (anything '(anything-c-source-howm-menu))

;; (anything-other-buffer
;;      '(anything-c-source-howm-menu
;;        anything-c-source-howm-recent) "*how*")

;; (defvar my-ah:pre-candidate-buffer "*my-ah:pre-cancicate*")

;; (defun my-ah:make-candidate-buffer ()
;;   (interactive)
;;   (with-current-buffer (get-buffer-create my-ah:pre-candidate-buffer)
;;     (erase-buffer)
;;     (insert (mapconcat 'identity
;;                     (ah:get-recent-title-list
;;                      (howm-recent-menu ah:recent-menu-number-limit))
;;                     "\n"))))

;; (defadvice anything-c-howm-recent-init (around my-anything-c-howm-recent-init activate)
;;   (with-current-buffer (anything-candidate-buffer 'global)
;;     (if (get-buffer my-ah:pre-candidate-buffer)
;;         (my-ah:insert-candidate-buffer-contents)
;;       (progn
;;         (my-ah:make-candidate-buffer)
;;         (my-ah:insert-candidate-buffer-contents)))))

;; (defun my-ah:insert-candidate-buffer-contents ()
;;    (insert
;;     (with-current-buffer my-ah:pre-candidate-buffer
;;      (buffer-string))))

;; (defun my-ah:refresh-pre-candidate-buffer ()
;;   (interactive)
  
;;   (deferred:$
;;     (deferred:wait 3000)
;;     (deferred:next
;;       (lambda () (my-ah:make-candidate-buffer)))
;;     (deferred:nextc it
;;       (lambda () (message "fin")))

;;     ))


;; (run-with-idle-timer 3 t 'my-ah:refresh-pre-candidate-buffer)
;; (run-with-timer 3 3 'my-ah:refresh-pre-candidate-buffer)


;; 以下の二つの戻り値の形式は同じか?
;; (howm-list-recent 8)
;; (howm-list-all)
;; (howm-recent-menu 3)

;; howm-mode.elにキーバインドがある。
;;(defvar howm-default-key-table
    ;; ("a" howm-list-all t t)
    ;; ("g" howm-list-grep t t)
    ;; ("s" howm-list-grep-fixed t t)
    ;; ("l" howm-list-recent t t)
;;(howm-recent-menu 300) の300 のところを記事数にする

;; (defun howm-recent-menu (num &optional random)
;;   ;; Bug: (length howm-recent-menu) can be smaller than NUM
;;   ;; when empty files exist.
;;   (let* ((summarizer #'(lambda (file line content) content))
;;          ;; Unique name is needed for dynamic binding. Sigh...
;;          (h-r-m-evaluator (if random
;;                               (lambda (f) (number-to-string (random)))
;;                             (lambda (f) (howm-view-xtime f 'm))))
;;          (sorted (howm-sort (lambda (f) (funcall h-r-m-evaluator f))
;;                             #'howm-view-string>
;;                             (mapcar #'howm-item-name
;;                                     (howm-folder-items howm-directory t))))
;;          (files (howm-first-n sorted num))
;;          (items (howm-view-search-items (howm-menu-recent-regexp)
;;                                         files summarizer)))
;;     (howm-first-n items num)))



;; (defun howm-list-grep-fixed ()
;;   (interactive)
;;   (howm-set-command 'howm-list-grep-fixed)
;;   (howm-list-grep-general t))

;; (defun howm-list-grep-general (&optional completion-p)
;;   (let* ((regexp (if completion-p
;;                      (howm-completing-read-keyword)
;;                    (read-from-minibuffer "Search all (grep): "))))
;;     (when completion-p  ;; Goto link works only for fixed string at now.
;;       (howm-write-history regexp))
;;     (howm-search regexp completion-p)))

;; (defun howm-search (regexp fixed-p &optional emacs-regexp)
;;   (if (string= regexp "")
;;       (howm-list-all)
;;     (howm-message-time "search"
;;       (prog1
;;           (howm-call-view-search regexp fixed-p emacs-regexp)
;;         (howm-list-normalize (or emacs-regexp regexp))))))
