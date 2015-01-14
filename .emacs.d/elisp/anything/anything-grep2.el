;;; Code:

(defvar anything-grep-version "$Id: anything-grep.el,v 1.20 2009/06/25 03:36:38 rubikitch Exp rubikitch $")
(require 'anything)
(require 'grep)

(defvar anything-grep-save-buffers-before-grep nil
  "Do `save-some-buffers' before performing `anything-grep'.")

(defvar anything-grep-goto-hook nil
  "List of functions to be called after `agrep-goto' opens file.")

;; (defvar anything-grep-find-file-function 'find-file
;;   "Function to visit a file with.
;; It takes one argument, a file name to visit.")

(defvar anything-grep-multiline t
  "If non-nil, use multi-line display. It is prettier.
Use anything.el v1.147 or newer.")

(defvar anything-grep-fontify-file-name t
  "If non-nil, fontify file name and line number of matches.")

(defvar anything-grep-alist
  '(("buffers" ("egrep -Hin %s $buffers" "/"))
    ("memo" ("ack-grep -af | xargs egrep -Hin %s" "~/memo"))
    ("PostgreSQL" ("egrep -Hin %s *.txt" "~/doc/postgresql-74/"))
    ("~/bin and ~/ruby"
     ("ack-grep -afG 'rb$' | xargs egrep -Hin %s" "~/ruby")
     ("ack-grep -af | xargs egrep -Hin %s" "~/bin")))
  "Mapping of location and command/pwd used by `anything-grep-by-name'.
The command is grep command line. Note that %s is replaced by query.
The command is typically \"ack-grep -af | xargs egrep -Hin %s\", which means
regexp/case-insensitive search for all files (including subdirectories)
except unneeded files.
The occurrence of $file in command is replaced with `buffer-file-name' of
all buffers.

The pwd is current directory to grep.

The format is:

  ((LOCATION1
     (COMMAND1-1 PWD1-1)
     (COMMAND1-2 PWD1-2)
     ...)
   (LOCATION2
     (COMMAND2-1 PWD2-1)
     (COMMAND2-2 PWD2-2)
     ...)
   ...)
")

(defvar anything-grep-filter-command nil
  "If non-nil, filter the result of grep command.

For example, normalizing many Japanese encodings to EUC-JP,
set this variable to \"ruby -rkconv -pe '$_.replace $_.toeuc'\".
The command is converting standard input to EUC-JP line by line. ")


;; (@* "core")
(defun anything-grep-base (sources)
  "Invoke `anything' for `anything-grep'."
  (and anything-grep-save-buffers-before-grep
       (save-some-buffers (not compilation-ask-about-save) nil))
  (let ((anything-quit-if-no-candidate (lambda () (message "No matches"))))
    (anything sources nil nil nil nil "*anything grep*")))

;; (anything (list (agrep-source "grep -Hin agrep anything-grep.el" default-directory) (agrep-source "grep -Hin pwd anything-grep.el" default-directory)))

(defun agrep-source (command pwd)
  "Anything Source of `anything-grep'."
  (append
;;   `((name . ,(format "%s [%s]" command pwd))
   `((name . "anything-grep")     
     (command . ,command)
     (pwd . ,pwd)
     (init . agrep-init)
     (candidates-in-buffer)
     (action . agrep-goto)
     (candidate-number-limit . 9999)
     (migemo)
     ;; to inherit faces
     (get-line . buffer-substring))
   (when anything-grep-multiline
     '((multiline)
       (real-to-display . agrep-real-to-display)))))

(defun agrep-init ()
  (agrep-create-buffer (anything-attr 'command)  (anything-attr 'pwd)))

(defun agrep-real-to-display (file-line-content)
  (and (string-match ":\\([0-9]+\\):" file-line-content)
       (format "%s:%s\n %s"
               (substring file-line-content 0 (match-beginning 0))
               (match-string 1 file-line-content)
               (substring file-line-content (match-end 0)))))

(defun agrep-do-grep (command pwd)
  "Insert result of COMMAND. The current directory is PWD.
GNU grep is expected for COMMAND. The grep result is colorized."
  (let ((process-environment process-environment))
    (when (eq grep-highlight-matches t)
      ;; Modify `process-environment' locally bound in `call-process-shell-command'.
      (setenv "GREP_OPTIONS" (concat (getenv "GREP_OPTIONS") " --color=always"))
      ;; for GNU grep 2.5.1
      (setenv "GREP_COLOR" "01;31")
      ;; for GNU grep 2.5.1-cvs
      (setenv "GREP_COLORS" "mt=01;31:fn=:ln=:bn=:se=:ml=:cx=:ne"))
    (call-process-shell-command (format "cd %s; %s" pwd command)
                                nil (current-buffer))))
(defun agrep-fontify ()
  "Fontify the result of `agrep-do-grep'."
  ;; Color matches.
  (goto-char 1)
  (while (re-search-forward "\\(\033\\[01;31m\\)\\(.*?\\)\\(\033\\[[0-9]*m\\)" nil t)
    (put-text-property (match-beginning 2) (match-end 2) 'face  grep-match-face)
    (replace-match "" t t nil 1)
    (replace-match "" t t nil 3))
  ;; Delete other escape sequences.
  (goto-char 1)
  (while (re-search-forward "\\(\033\\[[0-9;]*[mK]\\)" nil t)
    (replace-match "" t t nil 0))
  (when anything-grep-fontify-file-name
    (goto-char 1)
    (while (re-search-forward ":\\([0-9]+\\):" nil t)
      (put-text-property (point-at-bol) (match-beginning 0) 'face compilation-info-face)
      (put-text-property (match-beginning 1) (match-end 1) 'face compilation-line-face)
      (forward-line 1))))
;; (anything-grep "grep -n grep *.el" "~/emacs/init.d")

(defun agrep-create-buffer (command pwd)
  "Create candidate buffer for `anything-grep'.
Its contents is fontified grep result."
  (with-current-buffer (anything-candidate-buffer 'global)
    (setq default-directory pwd)
    (agrep-do-grep command pwd)
    (agrep-fontify)
    (current-buffer)))
;; (display-buffer (agrep-create-buffer "grep --color=always -Hin agrep anything-grep.el" default-directory))
;; (anything '(((name . "test") (init . (lambda () (anything-candidate-buffer (get-buffer " *anything grep:grep --color=always -Hin agrep anything-grep.el*")) )) (candidates-in-buffer) (get-line . buffer-substring))))

(defun agrep-goto  (file-line-content)
  "Visit the source for the grep result at point."
  (string-match ":\\([0-9]+\\):" file-line-content)
  (save-match-data
    (find-file
             (expand-file-name (substring file-line-content
                                          0 (match-beginning 0))
                               (anything-attr 'pwd))))
  (goto-line (string-to-number (match-string 1 file-line-content)))
  (run-hooks 'anything-grep-goto-hook))

;; (@* "simple grep interface")
(defun anything-grep (command pwd)
  "Run grep in `anything' buffer to narrow results.
It asks COMMAND for grep command line and PWD for current directory."
  (interactive
   (progn
     (grep-compute-defaults)
     (let ((default (grep-default-command)))
       (list (read-from-minibuffer "Run grep (like this): "
				   (if current-prefix-arg
				       default grep-command)
				   nil nil 'grep-history
				   (if current-prefix-arg nil default))
             (read-directory-name "Directory: " default-directory default-directory t)))))
  (anything-grep-base (list (agrep-source (agrep-preprocess-command command) pwd))))
;; (anything-grep "grep -Hin agrep anything-grep.el" default-directory)

(defun agrep-preprocess-command (command)
  (with-temp-buffer
    (insert command)
    (goto-char 1)
    (when (search-forward "$buffers" nil t)
      (delete-region (match-beginning 0) (match-end 0))
      (insert (mapconcat 'shell-quote-argument
                         (delq nil (mapcar 'buffer-file-name (buffer-list))) " ")))
    (when anything-grep-filter-command
      (goto-char (point-max))
      (insert "|" anything-grep-filter-command))
    (buffer-string)))

;; (@* "grep in predefined files")
(defvar agbn-last-name nil
  "The last used name by `anything-grep-by-name'.")

(defun aho (&optional name query)
  "Do `anything-grep' from predefined location.
It asks NAME for location name and QUERY."
  (interactive)
  (setq query (or query (read-string "Grep query: ")))
  (setq name "howm")
  (setq agbn-last-name name)
  (anything-aif (assoc-default name anything-grep-alist)
      (progn
        (grep-compute-defaults)
        (anything-grep-base
         (mapcar (lambda (args)
                   (destructuring-bind (cmd dir) args
                     (agrep-source (format (agrep-preprocess-command cmd)
                                           (shell-quote-argument query)) dir)))
                 it)))
    (error "no such name %s" name)))

(provide 'anything-grep2)

;; How to save (DO NOT REMOVE!!)
;; (emacswiki-post "anything-grep.el")
;;; anything-grep.el ends here

