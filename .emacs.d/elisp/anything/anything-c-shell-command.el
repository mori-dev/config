;;; anything-c-shell-history.el --- shell history anything.el interface

;; Copyright (C) 2009  kitokitoki

;; Author: kitokitoki <morihenotegami@gmail.com>
;; Keywords: anything
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

;;; Commentary:
;;
;; This package use `anything' as a interface to execute shell command.
;;
;; You can make this package integrate with `anything',
;; just setup like below:
;;
;; (setq anything-sources
;;       (list
;;        anything-c-source-shell-command
;;        ))

;;; Installation:
;;
;; Put anything-c-shell-command.el to your load-path.
;; And the following to your startup file.
;;
;; (require 'anything-c-shell-command)
;;
;; No need more.

;;; Change log:
;;
;; 0.0.1
;;   * kitokitoki:
;;      * First released.

;;; Code:

(require 'anything)

(defvar anything-c-source-shell-command
  '((name . "Create Shell Command")
    (dummy)
    (action
     ("Execute" . (lambda (candidate)
                            (save-excursion
                              (message "wait....")
                              (call-process-shell-command candidate nil (get-buffer-create "*Shell Command*"))
                              (switch-to-buffer "*Shell Command*")
                              (message (delete-and-extract-region (point-min) (point-max)))
                              (set-buffer-modified-p (buffer-modified-p))
                              (kill-buffer "*Shell Command*"))))
     ("Execute and Insert" . (lambda (candidate)
                            (save-excursion
                              (call-process-shell-command candidate nil t)))))))

(provide 'anything-c-shell-command)
;; anything-c-shell-command.el ends here
