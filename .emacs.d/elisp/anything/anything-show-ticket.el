;;; anything-show-ticket.el

;; Copyright (C) 2009,2010  kitokitoki
;; Author: kitokitoki

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

;; Setting
;; (setq ast-bts-address
;;   '(("DemoProject" . "https://my.redmine.jp/demo/issues/show/%s")
;;     ("Meadow" . "http://www.meadowy.org/meadow/ticket/%s")
;;     ("OpenPne" . "http://redmine.openpne.jp/issues/%s")))
;; (require 'anything-show-ticket)
;; (setq anything-sources
;;       (list anything-c-source-buffers
;;             anything-c-source-show-ticket
;;               ...
;;             ))
;; (global-set-key (kbd "M-5") 'anything-show-ticket)

(require 'cl)

(defvar ast-bts-address
  '(("DummyProject" . "http://path/to/ticket/number/%s")))

(setq ast-action-alist
  (loop for project-name in (mapcar 'car ast-bts-address)
        collect (apply #'cons
                  (cons project-name `((lambda (candidate) (ast-show-ticket ,project-name candidate)))))))

(defun ast-show-ticket (project word)
  (browse-url (format (cdr (assoc project ast-bts-address))
                      (url-hexify-string word))))

(defvar anything-c-source-show-ticket
  `((name . "チケット番号")
    (dummy)
    (action . ,ast-action-alist)))

(defun anything-show-ticket ()
  "anything-to-web-engine-function"
  (interactive)
  (anything (list anything-c-source-show-ticket)
            nil nil nil nil "*show ticket*"))

(provide 'anything-show-ticket)
;;; anything-show-ticket.el ends here
