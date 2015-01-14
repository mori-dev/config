;;; anything-gist.el --- anything-sources and some utilities for gist.

;; Filename: auto-complete-acr.el
;; Description: Anything extension for gist
;; Author: myuhe <yuhei.maeda_at_gmail.com>
;; Maintainer: myuhe
;; Copyright (C)  2010, myuhe  , all rights reserved.
;; Created: 2009-04-13 
;; Version: 0.3
;; Keywords: convenience, anything, git, gist

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; It is necessary to Some Anything and gist.el Configurations 

;;; Installation:
;;
;; Put the gist.el to your
;; load-path.
;; Add to .emacs:
;; (require 'anything-gist)
;;

;;; Changelog:
;;  2010/10/03 add embed action
;;             change candidates order 


;;; Command:
;;  `anything-for-gist'

;;  Anything sources defined :
;; `anything-c-source-gist'     (list and edit gist)

;;; Code:
(require 'anything)
(require 'gist)
(eval-when-compile (require 'cl))

(defvar gist-alist nil)
(defvar gist-delay-time 3)

(defun anything-gist-list ()
  "Displays a list of all of the current user's gists"
  (message "Retrieving list of your gists...")
  (if (eq gist-alist nil)
      (github-with-auth-info login token
        (gist-request
         (format "http://gist.github.com/api/v1/xml/gists/%s" login)
         'anything-gist-list-callback)))
  (reverse gist-alist))

(defun anything-gist-list-callback (status)
  "Called when the list of gists has been retrieved. Parses the result
and displays the list."
  (goto-char (point-min))
  (search-forward "<?xml")
  (let ((gists (gist-xml-cleanup
                (xml-parse-region (match-beginning 0) (point-max)))))
    (kill-buffer (current-buffer))
    (mapc 'anything-gist-push (xml-node-children (car gists)))))

(defun anything-gist-push (gist)
  "Returns a list of the gist's attributes for display, given the xml list
for the gist."
  (push (concat (gist-child-text 'repo gist)
                " : " (car(xml-node-children
                           (car(xml-node-children
                                (car(xml-node-children
                                     (car(xml-node-children gist))))))))
                " : " (gist-child-text 'description gist)) gist-alist))

(defun anything-gist-wrap-push ()
  (interactive)
  "After-save-hook to 'git add' the modified file and schedule a commit and push in the idle loop."
  (shell-command (concat "cd " gist-tmp-dir " && git add -A"))
  (shell-command (concat "cd " gist-tmp-dir " && git commit -m 'Updated file.'"))
  (shell-command (concat "cd " gist-tmp-dir " && git push"))
  (shell-command (concat "rm -r " gist-tmp-dir ))
  (egist-mode)
  (setq gist-alist nil))

(defun find-file-save-hook (file)
  "Set up the autocommit save hook for the current file."
  (find-file file)
  (egist-mode))

(defun directory-walker (fn dir)
  (dolist (file (directory-files dir t nil))
    (cond ((and (file-directory-p file) (string-match "\\.\\.?$" file)))
          ((and (file-directory-p file) (string-match "\\.git$" file)))
          ((file-directory-p file)
           (directory-walker fn file))
          ((file-regular-p file)
           (funcall fn file))
          (t))))

(defun take-around ()
  (let ((lst nil)
        (n 3))
    (save-excursion
      (ignore-errors (previous-line))
      (while (> n 0)
        (push (cons (line-number-at-pos) (buffer-substring-no-properties (point-at-bol) (point-at-eol))) lst)
        (ignore-errors (next-line))
        (if (= (point) (point-max))
            (setq n 0)
          (decf n))))
    (apply #'concat (nreverse (mapcar #'(lambda (s) (concat (format "%5d: %s\n" (car s) (cdr s)))) lst)))))

(defun anything-gist-fetch (id)
  "Fetches a Gist and inserts it into a new buffer
If the Gist already exists in a buffer, switches to it"
  (let* ((gist-buffer-name (format "*gist %s*" id))
         (gist-buffer (get-buffer gist-buffer-name)))
    (if (bufferp gist-buffer)
        (switch-to-buffer-other-window gist-buffer)
      (progn
        (message "Fetching Gist %s..." id)
        (setq gist-buffer
              (shell-command (concat "wget -q http://gist.github.com/" id ".txt -O -")))
        (with-current-buffer gist-buffer
          (rename-buffer gist-buffer-name t)
          (goto-char (point-min))
          (search-forward-regexp "\n\n")
          (delete-region (point-min) (point))
          (set-buffer-modified-p nil))
        (switch-to-buffer gist-buffer)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;minor-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar egist-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-s") 'anything-gist-wrap-push)
    map)
  "Keymap for active region mode.")

(define-minor-mode egist-mode
  "edit gist mode."
  :global t
  :lighter " egist"
  :group 'egist
  :keymap egist-mode-map)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;anything-c-source-gist
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq anything-c-source-gist
      '((name . "gist")
        (init . (lambda ()
                  (condition-case nil
                      (make-directory gist-tmp-dir)
                    (error nil))))
        (candidates . anything-gist-list)
        (action
         ("view" . (lambda(obj-name)
                     (anything-gist-fetch (car (split-string obj-name " : " t)))))
         ("yank embed" . (lambda(obj-name)
                           (kill-new (concat "<script src=\"http://gist.github.com/" (car (split-string obj-name " : " t)) ".js?file=" (car(cdr (split-string obj-name " : " t))) "\"></script>"))))
         ("edit" . (lambda(obj-name)
                     (setq gist-tmp-dir (concat temporary-file-directory (car (split-string obj-name " : " t))))
                     (shell-command (concat "cd " temporary-file-directory " && git clone git@gist.github.com:" (car (split-string obj-name " : " t)) ".git"))
                     (directory-walker  #'find-file-save-hook gist-tmp-dir)))
         )))

(defcustom anything-for-gist-list '(anything-c-source-gist) 
  "Your prefered sources to gist."
  :type 'list
  :group 'anything-gist)

(defun anything-for-gist ()
  "Preconfigured `anything' for gist."
  (interactive)
  (setq gist-alist nil)
  (anything-gist-list)
  (run-at-time gist-delay-time nil (lambda() (anything-other-buffer anything-for-gist-list "*anything for gist*"))))

(provide 'anything-gist)
