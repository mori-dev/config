;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*- 
(require 'anything-hatena-bookmark)

(setq anything-hatena-bookmark-samewindow t)

(defun hb ()
  (interactive)
  (anything-hatena-bookmark)
)
(defun hb-up ()
  (interactive) 
  (condition-case err
    (call-process "~/Dropbox/bin/anything-hatena-bookmark-get-dump" nil t t "kitokitoki")    
    (error (message "error: %s" (error-message-string err)))))

;; (setq anything-c-source-hatena-bookmark
;;   '((name . "Hatena::Bookmark")
;;     (init
;;      . (lambda ()
;;          (call-process-shell-command
;;           (concat "less -f " anything-hatena-bookmark-file)  nil (anything-candidate-buffer 'global))))
;;     (candidates-in-buffer)
;;     (candidate-number-limit . 9999)
;;     (requires-pattern . 3)    
;;     (migemo)
;;     (multiline)
;;     (action
;;      ("Browse URL" . (lambda (candidate)
;;                        (string-match "\\[href:\\(.+\\)\\]$" candidate)
;;                        (browse-url (match-string 1 candidate))))
;; ;;      ("Insert-hateda" . (lambda (candidate)
;; ;; ;                       (string-match "\\[href:\\(.+\\)\\]$" candidate)
;; ;;                        (string-match "\\(.+\\)\\[summary" candidate)
;; ;;                        (aa candidate)))
;;                        ;(insert (match-string 1 candidate))))
;;      ("Show URL" . (lambda (candidate)
;;                      (string-match "\\[href:\\(.+\\)\\]$" candidate)
;;                      (message (match-string 1 candidate))))
;;      ("Show Summary" . (lambda (candidate)
;;                          (string-match "\\[summary:\\(.+\\)\\]\\[" candidate)
;;                          (message (match-string 1 candidate)))))
;;      (volatile)
;; ))

;; (defun anything-hatena-bookmark ()
;;   "Search Hatena::Bookmark using `anything'."
;;   (interactive)
;;   (let ((anything-samewindow t))
;;     (unless (file-exists-p anything-hatena-bookmark-file)
;;       (anything-hatena-bookmark-get-dump))
;;     (anything
;;      '(anything-c-source-hatena-bookmark) nil "Find Bookmark: " nil nil)))



