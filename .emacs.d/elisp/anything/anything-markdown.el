;;; anything-markdown.el

;; Copyright (C) 2009  kitokitoki

;; Author: kitokitoki <morihenotegami@gmail.com>
;; Keywords: anything, markdown-mode

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

;; (require 'anything-markdown)

;; (add-hook 'markdown-mode-hook
;;   (lambda()
;;     (define-key markdown-mode-map (kbd "C-]") 'anything-markdown-command)))

;; Change Log
;; 1.0.0: 新規作成

;;; Code:

(require 'anything)
(require 'markdown-mode)

(defvar anything-c-source-markdown-mode-command
  '((name . "markdown-mode-comand")
    (candidates . markdown-mode-command)
    (type . command)))

(defun anything-markdown-command ()
  (interactive)
  (anything (list anything-c-source-markdown-mode-command) nil nil nil))

(defvar markdown-mode-command
  '(markdown-blockquote-region
    markdown-check-refs
    markdown-cycle
    markdown-enter-key
    markdown-indent-line
    markdown-insert-blockquote
    markdown-insert-bold
    markdown-insert-code
    markdown-insert-header
    markdown-insert-header-1
    markdown-insert-header-2
    markdown-insert-header-3
    markdown-insert-header-4
    markdown-insert-header-5
    markdown-insert-header-6
    markdown-insert-hr
    markdown-insert-image
    markdown-insert-italic
    markdown-insert-link
    markdown-insert-pre
    markdown-insert-section
    markdown-insert-title
    markdown-insert-wiki-link
    markdown-mode
    markdown-mode-menu
    markdown-pre-region
    markdown-preview
    markdown-shifttab
    markdown-show-version))

(provide 'anything-markdown)
;; anything-markdown.el ends here
