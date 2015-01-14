;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-
;;; anything-files-in-directory-x.el
;; prefix afid-
;; todo
;; candidate-transformer によるフェイスの変更

(defvar afid-persistent-action-buffer "*files-in-direcoty-x*")
(defvar afid-mode-name 'lisp-interaction-mode)

(defun afid-persistent-action (c)
  (let ((b (get-buffer-create afid-persistent-action-buffer)))
      (with-current-buffer b
        (erase-buffer)
        (insert-file-contents c)
        (goto-char (point-min)))
      (pop-to-buffer b)
      (funcall afid-mode-name)))

(setq anything-c-source-files-in-emacs/elisp-dir
  `((name . "~/.emacs.d/elisp")
    (candidates . (lambda () (afid-get-fullpass-by-dir-name "~/.emacs.d/elisp/")))
    ;;(candidate-transformer anything-c-highlight-files)
    (persistent-action .
      (lambda (candidate)
        (afid-persistent-action candidate)))
    (cleanup .
      (lambda ()
        (if (get-buffer afid-persistent-action-buffer)
        (kill-buffer afid-persistent-action-buffer))))
    (type . file)))

(setq anything-c-source-files-in-emacs/conf-dir
  `((name . "~/.emacs.d/conf")
    (candidates . (lambda () (afid-get-fullpass-by-dir-name "~/.emacs.d/conf/")))    
    ;(candidate-transformer anything-c-highlight-files)
    (persistent-action .
      (lambda (candidate)
        (afid-persistent-action candidate)))
    (cleanup .
      (lambda ()
        (if (get-buffer afid-persistent-action-buffer)
        (kill-buffer afid-persistent-action-buffer))))
    (type . file)))

(setq anything-c-source-files-in-emacs-dir
  `((name . "~/.emacs.d")
    (candidates . (lambda () (afid-get-fullpass-by-dir-name "~/.emacs.d/")))        
    ;(candidate-transformer anything-c-highlight-files)
    (persistent-action .
      (lambda (candidate)
        (afid-persistent-action candidate)))
    (cleanup .
      (lambda ()
        (if (get-buffer afid-persistent-action-buffer)
        (kill-buffer afid-persistent-action-buffer))))
    (type . file)))

(defun afid-get-fullpass-by-dir-name (dir)
  (loop for e in (directory-files dir)
        collect (expand-file-name e dir)))

(provide 'anything-files-in-directory-x)

;;; anything-files-in-directory-x.el ends here

