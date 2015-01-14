;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-
;; depends anything-grep
(defvar anything-c-source-eijiro
  '((name . "Eijiro")
    (query)
    (init . anything-eijiro-init)
    (candidates-in-buffer)
    (candidate-number-limit . 9999)
    (get-line . buffer-substring)
    (migemo)))

(defvar eijiro-command
  "egrep --color=always -ih %s eijiro75.euc otojiro.euc reiji75.euc ryaku75.euc | cut -c3-")
(defvar eijiro-directory "/home/dict")
(defun anything-eijiro-init ()
  (with-current-buffer
      (agrep-create-buffer
       (format eijiro-command (shell-quote-argument (anything-attr 'query)))
       eijiro-directory)
    (anything-eijiro-relocate)))

(defun anything-eijiro-relocate ()
  (goto-char 1)
  (insert "\n")
  (let ((s (make-marker))
        (e (make-marker))
        (pattern (concat "\n" (anything-attr 'query))))
    (when (search-forward pattern nil t)
      (set-marker s (point-at-bol))
      (goto-char (point-max))
      (search-backward pattern nil t)
      (forward-line 2)
      (set-marker e (point))
      (goto-char 2)
      (insert-buffer-substring (current-buffer) s e)
      (delete-region s e)
      (delete-region 1 2))))

(defun eijiro (query)
  (interactive "sEijiro: ")
  (let ((anything-input-idle-delay anything-idle-delay))
    (anything-attrset 'query query anything-c-source-eijiro)
    (anything 'anything-c-source-eijiro)))
(defun eijiro-at-point ()
  (interactive)
  (eijiro (word-at-point)))

(provide 'anything-eijiro)
