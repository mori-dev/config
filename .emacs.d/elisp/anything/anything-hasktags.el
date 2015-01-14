;;; anything-howm.el --- hasktags(ctags) anything.el interface

;; Copyright (C) 2011-2012 mori_dev

;; Author: mori_dev <mori.dev.asdf@gmail.com>
;; Keywords: anything, hasktags, haskell
;; Prefix: anything-hasktags-
;; Version: 0.0.1
;; Compatibility: GNU Emacs 23

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;
;; Features that might be required by this library:
;;
;; `anything'
;;

;;; This file is NOT part of GNU Emacs

;;; Reference
;; Some code referenced from anything-exuberant-ctags.el, anything-etags.el, anything-find-project-resources.el
;;
;; anything-exuberant-ctags.el
;; Author: Kenichirou Oyama <k1lowxb@gmail.com>
;;
;; anything-find-project-resources.el
;; Author: SAKURAI, Masashi <m.sakurai@kiwanami.net>
;;
;; anything-etags.el
;; Author: Kenichirou Oyama <k1lowxb@gmail.com>
;;         Andy Stewart <lazycat.manatee@gmail.com>
;;         rubikitch <rubikitch@ruby-lang.org>
;;         Thierry Volpiatto <thierry.volpiatto@gmail.com>

;;; Commentary:
;;
;; This package use `anything' as a interface to find tag with hasktags(ctags).
;;
;; Follow command is `anything' interface of find hasktags(ctags).
;;
;; `anything-hasktags-select'
;; `anything-hasktags-select-from-here'
;;
;;; Installation:
;;
;; Put anything-hasktags.el to your load-path.
;; The load-path is usually ~/elisp/.
;; It's set in your ~/.emacs like this:
;; (add-to-list 'load-path (expand-file-name "~/elisp"))
;;
;; And the following to your ~/.emacs startup file.
;;
;; (require 'anything-hasktags)
;;
;; It is good to use anything-match-plugin.el to narrow candidates.
;; http://www.emacswiki.org/cgi-bin/wiki/download/anything-match-plugin
;;
;; In your project root directory, do follow command to make tags file.
;;
;; find . -type f -name \*\.*hs | xargs hasktags -c
;;
;; No need more.

;;; Commands:
;;
;; Below are complete command list:
;;
;;  `anything-hasktags-select'
;;    Tag jump using `anything'.
;;  `anything-hasktags-select-from-here'
;;    Tag jump with current symbol using `anything'.
;;  `anything-hasktags-enable-cache'
;;    Enable use tag file in cache directory.
;;  `anything-hasktags-disable-cache'
;;    Disable use tag file in cache directory.
;;  `anything-hasktags-toggle-cache'
;;    Toggle tag file cache directory status.
;;
;;; Customizable Options:
;;
;; Below are customizable option list:
;;
;;  `anything-hasktags-tag-file-name'
;;    hasktags(ctags) tag file name.
;;    default = "tags"
;;  `anything-hasktags-enable-tag-file-dir-cache'
;;    Whether use hasktags(ctags) tag file in cache directory.
;;    default = nil
;;  `anything-hasktags-cache-tag-file-dir'
;;    The cache directory that storage hasktags(ctags) tag file.
;;    default = nil
;;  `anything-hasktags-tag-file-search-limit'
;;    The limit level of directory that search tag file.
;;    default = 10
;;  `anything-hasktags-line-length-limit'
;;    The limit level of line length.
;;    default = 400
;;  `anything-hasktags-line-format-func'
;;    The limit level of line length.
;;    default = (\` anything-hasktags-line-format)

;;; Require
(require 'anything)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Variable ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar anything-hasktags-tag-file-name "tags"
  "hasktags(ctags) tag file name.")

(defvar anything-hasktags-enable-tag-file-dir-cache nil
  "Whether use hasktags(ctags) tag file in cache directory.
If `non-nil', try to use `anything-hasktags-cache-tag-file-dir'.
Default is nil.")

(defvar anything-hasktags-cache-tag-file-dir nil
  "The cache directory that storage hasktags(ctags) tag file.
This value just use when you setup option
`anything-hasktags-enable-tag-file-dir-cache' with `non-nil'.
If is nil try to find tag file in current directory.
Default is nil.")

(defvar anything-hasktags-tag-file-search-limit 10
  "The limit level of directory that search tag file.
Don't search tag file deeply if outside this value.
This value only use when option
`anything-hasktags-tag-file-dir-cache' is nil.")

(defvar anything-hasktags-line-length-limit 400
  "The limit level of line length.
Don't search line longer if outside this value.")

(defvar anything-hasktags-line-format-func `anything-hasktags-line-format
  "The limit level of line length.
Don't search line longer if outside this value.")

(defvar anything-hasktags-tag-file-dir nil
  "hasktags(ctags) file directory.")

(defvar anything-hasktags-tag-buffer nil
  "hasktags(ctags) tag buffer.")

(defvar anything-hasktags-max-length 30
  "Max length for file path name.")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Interactive Functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun anything-hasktags-select (&optional symbol-name)
  "Tag jump using `anything'.
If SYMBOL-NAME is non-nil, jump tag position with SYMBOL-NAME."
  (interactive)
  (let* ((initial-pattern               ; string or nil
          (if symbol-name
              (concat "\\_<" (regexp-quote symbol-name) "\\_>"
                      (if (featurep 'anything-match-plugin) " "))))
         (anything-quit-if-no-candidate
          (lambda () (if symbol-name
                         (message "No TAGS file or containing `%s'" symbol-name)
                       (message "No TAGS file"))))
         (anything-execute-action-at-once-if-one t))
    (anything '(anything-c-source-hasktags-select)
              ;; Initialize input with current symbol
              initial-pattern "Find Tag: " nil)))

(defun anything-hasktags-select-from-here ()
  "Tag jump with current symbol using `anything'."
  (interactive)
  (anything-hasktags-select (thing-at-point 'symbol)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Utilities Functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun anything-hasktags-get-tag-file ()
  "Get hasktags(ctags) tag file."
  ;; Get tag file from `default-directory' or upper directory.
  (let ((current-dir (anything-hasktags-find-tag-file default-directory)))
    ;; Return nil if not find tag file.
    (when current-dir
      (setq anything-hasktags-tag-file-dir current-dir) ;set tag file directory
      (expand-file-name anything-hasktags-tag-file-name current-dir))))

(defun anything-hasktags-find-tag-file (current-dir)
  "Find tag file.
Try to find tag file in upper directory if haven't found in CURRENT-DIR."
  (flet ((file-exists? (dir)
           (let ((tag-path (expand-file-name anything-hasktags-tag-file-name dir)))
             (and (stringp tag-path)
                  (file-exists-p tag-path)
                  (file-readable-p tag-path)))))
    (loop with count = 0
       until (file-exists? current-dir)
       ;; Return nil if outside the value of
       ;; `anything-hasktags-tag-file-search-limit'.
       if (= count anything-hasktags-tag-file-search-limit)
       do (return nil)
       ;; Or search upper directories.
       else
       do (incf count)
         (setq current-dir (expand-file-name (concat current-dir "../")))
       finally return current-dir)))

(defun anything-hasktags-create-buffer ()
  "Create buffer from tag file."
  (anything-aif (anything-hasktags-get-tag-file)
      (with-current-buffer (anything-candidate-buffer 'global)
        (insert-file-contents it))
    (message "Can't find tag file: %s" it)))

(defun anything-hasktags-find-tag (candidate)
  "Find tag that match CANDIDATE from `anything-hasktags-tag-buffer'.
And switch buffer and jump tag position.."
  (destructuring-bind (word file line) (split-string candidate "\t")
      (setq line (string-to-int line))
      (find-file file)
      (goto-line line)))

(defun anything-hasktags-goto-location (candidate)
  (anything-hasktags-find-tag candidate)
  (when (and anything-in-persistent-action
             (fboundp 'anything-match-line-color-current-line))
    (anything-match-line-color-current-line)))

(defun anything-source-hasktags-header-name (x)
  (concat "hasktags(ctags) in "
          (with-current-buffer anything-current-buffer
            (anything-hasktags-get-tag-file))))

(defvar anything-c-source-hasktags-select
  '((name . "hasktags")
    (header-name . anything-source-hasktags-header-name)
    (init . anything-hasktags-create-buffer)
    (candidates-in-buffer)
    (action ("Goto the location" . anything-hasktags-goto-location))
    (candidate-number-limit . 999999)
    ))

(provide 'anything-hasktags)
;;; anything-hasktags.el ends here