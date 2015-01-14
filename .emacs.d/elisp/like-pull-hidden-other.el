;;; like-pull-hidden-other.el

;; Copyright (C) 2009  kitokitoki

;; Author: kitokitoki <morihenotegami@gmail.com>
;; Keywords: convenience
;; Prefix: lpho-

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

;;; Setting sample

;; (require 'like-pull-hidden-other)
;; (setq lpho-ignore-list  '("*ansi-term*" " *Minibuf-0*" " *Minibuf-1*"
;;                           "*Messages*" "*Moccur*" "*Help*"))
;; (global-set-key (kbd "M-h") 'lpho-switch-to-previous-buffer)

;; Change Log
;; 1.0.0: 新規作成

;;; Code:

(defvar lpho-ignore-list
  '("*Help*" "*Messages*")
  "移動候補にしたくないバッファのリスト")

(defun lpho-switch-to-previous-buffer () 
  "直前のバッファと行き来する" 
  (interactive) 
  (condition-case err
      (labels 
          ((_lpho-switch-to-previous-buffer (target) 
            (if (null (member (buffer-name (cadr target))
                              lpho-ignore-list)) 
                (switch-to-buffer (cadr target)) 
              (_lpho-switch-to-previous-buffer (cdr target))))) 
        (_lpho-switch-to-previous-buffer (buffer-list)))
    (error (message "error: %s" (error-message-string err)))))

(provide 'like-pull-hidden-other)

;;; like-pull-hidden-other.el ends here
