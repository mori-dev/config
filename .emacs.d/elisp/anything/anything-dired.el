
;;サイズ表示を 69913580 から 67M へ
(setq dired-listing-switches "-alh")

(defvar dired-various-sort-type
  '(("S" . "size")
    ("X" . "extension")
    ("v" . "version")
    ("t" . "date")
    (""  . "name")))

(defun dired-various-sort-change (sort-type-alist &optional prior-pair)
  (when (eq major-mode 'dired-mode)
    (let* (case-fold-search
           get-next
           (options
            (apply 'concat (mapcar (lambda (x) (car x)) sort-type-alist)))
           (opt-desc-pair
            (or prior-pair
                (catch 'found
                  (dolist (pair sort-type-alist)
                    (when get-next
                      (throw 'found pair))
                    (setq get-next (string-match (car pair) dired-actual-switches)))
                  (car sort-type-alist)))))
      (setq dired-actual-switches
            (concat "-l" (dired-replace-in-string (concat "[l" options "-]")
                                                  ""
                                                  dired-actual-switches)
                    (car opt-desc-pair)))
      (setq mode-name
            (concat "Dired by " (cdr opt-desc-pair)))
      (force-mode-line-update)
      (revert-buffer))))

(defun dired-various-sort-change-or-edit (&optional arg)
  "Hehe"
  (interactive "P")
  (when dired-sort-inhibit
    (error "Cannot sort this dired buffer"))
  (if arg
      (dired-sort-other
       (read-string "ls switches (must contain -l): " dired-actual-switches))
    (dired-various-sort-change dired-various-sort-type)))

(defvar anything-c-source-dired-various-sort
  '((name . "Dired various sort type")
    (candidates . (lambda ()
                    (mapcar (lambda (x)
                              (cons (concat (cdr x) " (" (car x) ")") x))
                            dired-various-sort-type)))
    (action . (("Set sort type" . (lambda (candidate)
                                    (dired-various-sort-change dired-various-sort-type candidate)))))
    ))



;; (defvar anything-dired-command-list
;;       '(
;;         ("Delete Marked files" . anything-delete-marked-files)
;;         ("Kill Marked buffers" . anything-kill-marked-buffers)
;;         ("Ediff Marked buffers" . anything-ediff-marked-buffers)
;;         ("Revert Marked buffers" . anything-revert-marked-buffers)))
        
;; (defvar anything-l-source-dired-commands
;;   '((name . "Dired コマンド")
;;     (candidates . anything-dired-command-list)    
;;     (type . sexp)))

;; (defun anything-dired-commands ()
;;   (interactive)
;;     (anything (list anything-l-source-dired-commands) nil nil nil))

;; (global-set-key (kbd "M-h") 'anything-dired-commands)

(add-hook 'dired-mode-hook
          '(lambda ()
             (define-key dired-mode-map "s" 'dired-various-sort-change-or-edit)
             (define-key dired-mode-map "c"
               '(lambda ()
                  (interactive)
                  (anything '(anything-c-source-dired-various-sort))))
             ))








;; !-dired-do-shell-command
;; #-dired-flag-auto-save-files
;; $-dired-hide-subdir
;; %-Prefix Command
;; &-dired-do-async-shell-command
;; *-Prefix Command
;; +-dired-create-directory
;; --negative-argument
;; .-dired-clean-directory
;; <-dired-prev-dirline
;; =-dired-diff
;; >-dired-next-dirline
;; ?-dired-summary
;; A-dired-do-search
;; B-dired-do-byte-compile
;; C-dired-do-copy
;; D-dired-do-delete
;; G-dired-do-chgrp
;; H-dired-do-hardlink
;; L-dired-do-load
;; M-dired-do-chmod
;; O-anything-c-moccur-dired-do-moccur-by-moccur
;; P-dired-do-print
;; Q-dired-do-query-replace-regexp
;; R-dired-do-rename
;; S-dired-do-symlink
;; T-dired-do-touch
;; U-dired-unmark-all-marks
;; W-woman-dired-find-file
;; X-dired-do-shell-command
;; Z-dired-do-compress
;; ^-dired-up-directory
;; a-dired-find-alternate-file
;; c-??
;; d-dired-flag-file-deletion
;; g-revert-buffer
;; h-describe-mode
;; i-dired-maybe-insert-subdir
;; j-dired-goto-file

(add-hook 'dired-mode-hook
          '(lambda ()
             (local-set-key "s"
                            '(lambda ()
                               (interactive)
                               (dired-various-sort dired-various-sort-type)))
             (local-set-key "c"
                            '(lambda ()
                               (interactive)
                               (anything
                                '(anything-c-source-dired-various-sort))))
             ))

(provide 'anything-dired)


