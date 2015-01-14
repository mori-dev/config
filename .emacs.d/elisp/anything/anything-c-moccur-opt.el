;;; anything-c-moccur-opt.el --- anything-c-moccur.el optional utilities

;; Copyright (C) 2009  kitokitoki

;; Author: kitokitoki <morihenotegami@gmail.com>
;; Keywords: anything, yasnippet
;; Prefix: anything-c-moccur-opt-

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

;;; Setting Sample

;; (require 'anything-c-moccur-opt)
;; (setq anything-c-moccur-enable-initial-pattern t)
;; (global-set-key (kbd "M-n") 'anything-c-moccur-opt-buffer-list)

;;; Commentary:

;; TODO documentation

;;; Code:

(require 'anything-c-moccur)

(defun anything-c-moccur-opt-buffer-list ()
  (interactive)
  (anything-c-moccur-with-anything-env (list anything-c-source-moccur-buffer-list)
    (anything nil
              (if anything-c-moccur-enable-initial-pattern
                  (regexp-quote (or (thing-at-point 'symbol) ""))
                ""))))

(provide 'anything-c-moccur-opt)
;; anything-c-moccur-opt.el ends here
