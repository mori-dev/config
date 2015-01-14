;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; http://www.emacswiki.org/emacs/ElispFormat



;; Command List

;;     * “elisp-format-region” 
;;     Format region or defun. 
;;     * “elisp-format-buffer” 
;;     Format buffer. 
;;     * “elisp-format-file” 
;;     Format file. 
;;     * “elisp-format-file-batch” 
;;     Format file with ‘batch’. 
;;     * “elisp-format-directory” 
;;     Format recursive elisp files under specify directory. 
;;     * “elisp-format-directory-batch” 
;;     Format recursive elisp files under specify directory, but with ‘batch’. 
;;     * “elisp-format-dired-mark-files” 
;;     Format dired marked files. 
;;     * “elisp-format-library” 
;;     Format library file.

;; Customize

;; All below option can customize by: M-x customize-group RET elisp-format RET
;;     * ‘elisp-format-batch-program’ 
;;     The program name for execute batch command.
;;     * “elisp-format-column” 
;;     The column number to truncate long line.
;;     * ‘elisp-format-indent-comment’ 
;;     Whether indent comment.
;;     * ‘elisp-format-dired-confirm’ 
;;     Whether confirmation is needed to format dired marked files.
;;     * ‘elisp-format-newline-keyword-addons-list’ 
;;     The list contain addons keywords for newline.
;;     * ‘elisp-format-newline-keyword-except-list’ 
;;     The list contain except keywords for newline.
;;     * ‘elisp-format-split-subexp-keyword-addons-list’ 
;;     The list contain addons keywords that will split it’s sub-expression.
;;     * ‘elisp-format-split-subexp-keyword-except-list’ 
;;     The list contain except keywords that will split it’s sub-expression.
;;     * ‘elisp-format-split-subexp-keyword-keep-alist’ 
;;     The alist contain keep keyword when split it’s sub-expression.
;; Tips
;;     * If current mark is active, command “elisp-format-region” will format region you select, otherwise it will format defun arond point.
;;     * If you want format many files, you can marked them in dired, and use command “elisp-format-dired” to format marked files in dired.
;;     * You can format speical file through command “elisp-format-file”.
;;     * By default, when you format huge file, it will hang emacs. So you can use command ‘elisp-format-file-batch’ make format process at background.
;;     * You also can use command ‘elisp-format-directory’ format all recursive elisp files in speical directory.
;;     * By default, when you use command ‘elisp-format-directory’ format too many elisp fiels, it will hang emacs. So you can use command ‘elisp-format-directory-batch’ make format process at background.
;;     * If you’re sure lazy, you can use command “elisp-format-library” format speical library and don’t need input long file path.


(require 'elisp-format)
