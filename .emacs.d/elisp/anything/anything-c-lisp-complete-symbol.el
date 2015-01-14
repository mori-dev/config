;;; anything-c-lisp-complete-symbol.el ---  lisp-complete-symbol for anything -*- coding: utf-8; mode: emacs-lisp; -*-

;; Author: Kenji Imakado <ken.imakaado@gmail.com>
;; Version: 0.1
;; Keywords: anything emacs-lisp

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary

;; lisp-complete-symbol with anything interface

;; setting sample
;; (define-key 'lisp-mode-map (kbd "C-M-i") 'anything-lisp-complete-symbol)
;; or
;; add to your anything-sources

;; type C-M-i complete lisp symbol
;; when before symbol started is `(' complete from only function symbol
;; otherwise from all typeof symbol

;; when anything-lisp-complete-symbol called with prefix arg (in case this sample, type: C-u C-M-i)
;; complete from all typeof symbol.

(require 'anything)

(defun anything-lisp-complete-symbol (&optional all)
  (interactive "P")
  (let ((anything-sources (list anything-c-source-lisp-complete-symbol))
        (anything-c-lisp-complete-symbol-all-type all))
    (anything)))

(defvar anything-c-lisp-complete-symbol-candidates nil)
(defvar anything-c-source-lisp-complete-symbol
  `((name . "Complete Symbol")
    (init . (lambda ()
              (setq anything-c-lisp-complete-symbol-candidates
                    (anything-c-lisp-complete-symbol-get-cands))))
    (candidates . anything-c-lisp-complete-symbol-candidates)
    (action . (("Insert" . (lambda (candidate)
                             (delete-backward-char (length anything-c-lisp-complete-symbol-initial-input))
                             (insert candidate)))
               ("Describe symbol" . (lambda (candidate)
                                      (let* ((sym (intern-soft candidate))
                                             (describe-fn (if (fboundp sym)
                                                              'describe-function
                                                            'describe-variable)))
                                        (funcall describe-fn sym))))))))

(defvar anything-c-lisp-complete-symbol-all-type nil)
(defvar anything-c-lisp-complete-symbol-initial-input nil)
(defun anything-c-lisp-complete-symbol-get-cands ()
  (multiple-value-setq
      (anything-c-lisp-complete-symbol-initial-input beg end type)
      (anything-c-lisp-complete-symbol-get-cmp-context))
  (cond
   ((and (eq type 'function)
         (not anything-c-lisp-complete-symbol-all-type))
    (all-completions anything-c-lisp-complete-symbol-initial-input obarray 'functionp))
   (t
    (all-completions anything-c-lisp-complete-symbol-initial-input obarray))))

(defun anything-c-lisp-complete-symbol-get-cmp-context ()
  (let ((start (point))
        (end (point))
        (syntax "w_")
        (type nil))
    (condition-case nil
        (save-excursion
          (skip-syntax-backward syntax)
          (setq start (point))
          (when (eq (preceding-char) (string-to-char "("))
            (setq type 'function))
          (values (buffer-substring-no-properties start end) start end type))
      (error (values "" (point) (point) nil)))))

(provide 'anything-c-lisp-complete-symbol)
;;; anything-c-lisp-complete-symbol.el ends here