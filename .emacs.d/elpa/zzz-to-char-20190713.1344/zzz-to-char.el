;;; zzz-to-char.el --- Fancy version of `zap-to-char' command -*- lexical-binding: t; -*-
;;
;; Copyright © 2015–present Mark Karpov <markkarpov92@gmail.com>
;;
;; Author: Mark Karpov <markkarpov92@gmail.com>
;; URL: https://github.com/mrkkrp/zzz-to-char
;; Package-Version: 20190713.1344
;; Package-Commit: b0a50b8cb6925c3184405f81be9ef9be9da69f09
;; Version: 0.1.3
;; Package-Requires: ((emacs "24.4") (cl-lib "0.5")(avy "0.3.0"))
;; Keywords: convenience
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software: you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by the
;; Free Software Foundation, either version 3 of the License, or (at your
;; option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
;; Public License for more details.
;;
;; You should have received a copy of the GNU General Public License along
;; with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package provides two new commands: `zzz-to-char' and
;; `zzz-up-to-char' which work like built-ins `zap-to-char' and
;; `zap-up-to-char', but allow you quickly select exact character you want
;; to “zzz” to.
;;
;; The commands are minimalistic and often work like built-in ones when
;; there is only one occurrence of target character (except they
;; automatically work in backward direction too). You can also specify how
;; many characters to scan from each side of point, see `zzz-to-char-reach'.

;;; Code:

(require 'avy)
(require 'cl-lib)

(defgroup zzz-to-char nil
  "Fancy version of `zap-to-char' command."
  :group  'convenience
  :tag    "Zzz to Char"
  :prefix "zzz-to-char-"
  :link   '(url-link :tag "GitHub" "https://github.com/mrkkrp/zzz-to-char"))

(defcustom zzz-to-char-reach 80
  "Number of characters to scan on each side of the point."
  :tag "How many characters to scan"
  :type 'integer)

(defun zzz-to-char--base (char n-shift)
  "Kill text between the point and character CHAR.

Boundary of text to kill that doesn't coincide with point
position can be shifted with help of N-SHIFT argument.

This is an internal function, see also `zzz-to-char' and
`zzz-up-to-char'."
  (let ((p (point))
        (avy-all-windows nil))
    (avy-with zzz-to-char
      (avy-jump
       (if (= 13 char)
           "\n"
         (regexp-quote (string char)))
       :window-flip nil
       :beg (max (- p zzz-to-char-reach)
                 (point-min))
       :end (min (+ p zzz-to-char-reach)
                 (point-max))))
    (let ((n (point)))
      (when (/= n p)
        (cl-destructuring-bind (beg . end)
            (if (> n p)
                (cons p (- (1+ n) n-shift))
              (cons (+ n n-shift) p))
          (goto-char end)
          (kill-region beg end))))))

;;;###autoload
(defun zzz-to-char (char)
  "Kill text between the point and the character CHAR.

This command is similar to `zap-to-char', it kills target
character too."
  (interactive (list (read-char "Zzz to: " t)))
  (zzz-to-char--base char 0))

;;;###autoload
(defun zzz-up-to-char (char)
  "Kill text between the point and the character CHAR.

This command is similar to `zap-up-to-char', it doesn't kill
target character."
  (interactive (list (read-char "Zzz up to: " t)))
  (zzz-to-char--base char 1))

(provide 'zzz-to-char)

;;; zzz-to-char.el ends here
