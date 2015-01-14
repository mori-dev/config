
(add-to-list 'auto-mode-alist '("\\.[Cc][Ss][Vv]\\'" . csv-mode))
(autoload 'csv-mode "csv-mode"
  "Major mode for editing comma-separated value files." t)

(defun cvs-mode-file-dos2unix ()
  (interactive)
  (let ((f-name (expand-file-name (cvs-fileinfo->full-path (cvs-mode-marked nil nil :one t)))))
    (message "dos2unix %s" f-name)
    (shell-command-to-string (format "dos2unix %s" f-name))
    (message "dos2unix %s ... done" f-name)))