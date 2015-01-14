;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

(autoload 'tsv-mode "tsv-mode" "A mode to edit table like file" t)
(autoload 'tsv-normal-mode "tsv-mode" "A minor mode to edit table like file" t)



;; Key bindings

;;;; Navigate:
  ;; TAB             tsv-next-field
  ;; <backtab>       tsv-prev-field
  ;; C-v             tsv-scroll-up
  ;; M-v             tsv-scroll-down
  ;; j               next-line
  ;; k               previous-line

;; Copy and paste:

;; C-k             tsv-kill-line
;; C-w             tsv-kill-region
;; C-y             tsv-yank
;; M-w             tsv-kill-ring-save
;; w               tsv-copy-field-at-point

;; Column operation:

;; <               tsv-narrow-column
;; >               tsv-widen-column
;; C-c C-<         tsv-narrow-to-min
;; C-c C->         tsv-widen-to-max
;; C-c C-n         tsv-set-column-width
;; C-c C-w         tsv-set-all-column-width
;; H               tsv-hide-column
;; S               tsv-show-column
;; C-c C-s         tsv-sort-column
;; C-c C-l         tsv-sort-lines-region

;; Other:

;; RET             tsv-edit-field-at-point
;; s               tsv-show-field-at-point
;; Q               tsv-exit
;; C-c C-e         tsv-normal-mode
;; C-c C-u         tsv-revert-with-separator
;; C-x n n         tsv-narrow-to-region
;; C-x n w         tsv-widen

;; There is a minor mode tsv-normal-mode. There is only some key binds for this minor mode:

;; C-a             tsv-normal-beginning-of-field/line
;; C-e             tsv-normal-end-of-field/line
;; TAB             tsv-normal-next-field
;; <backtab>       tsv-normal-prev-field
;; C-v             tsv-scroll-up
;; M-v             tsv-scroll-down
;; C-c C-c         Quit tsv-normal-mode



;;; Commentary:

;; This mode is not stable. Do backup file if you visit important data.

;; Put this file into your load-path and the following into your ~/.emacs:
;; (add-to-list 'load-path "/path/to/lib")
;; (autoload 'tsv-mode "tsv-mode" "A mode to edit table like file" t)
;; (autoload 'tsv-normal-mode "tsv-mode" "A minor mode to edit table like file" t)

;; TODO:
;; 1. add some column command, such as move, add, delete.
;; 2. enable undo
;; 3. enable formula (this may need more time)

