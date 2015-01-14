;;; anything-files-in-current-dir++.el

;; Copyright (C) 2009  kitokitoki

;; Author: kitokitoki <morihenotegami@gmail.com>
;; Keywords: convenience, anything

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

;; Change Log
;; 1.0.1: persistent-action で開くバッファのモードを指定する機能を追加
;;        変数 anything-files-in-current-dir++mode-name に クオートしてメジャーモード名を設定する
;; 1.0.0: 新規作成

;;; Code:

(defvar anything-files-in-current-dir++persistent-action-buffer "*files-in-current-dir++*")
(defvar anything-files-in-current-dir++mode-name 'php-mode)

(setq anything-c-source-files-in-current-dir++
  `((name . "Files from Current Directory")
    (init . (lambda ()
              (setq anything-c-default-directory
                    (expand-file-name default-directory))))
    (candidates . (lambda ()
                    (directory-files
                     anything-c-default-directory t)))
    (candidate-transformer anything-c-highlight-files)
    (persistent-action .
      (lambda (candidate)
        (anything-files-in-current-dir++-persistent-action candidate)))
    (cleanup .
      (lambda ()
        (if (get-buffer anything-files-in-current-dir++persistent-action-buffer)
        (kill-buffer anything-files-in-current-dir++persistent-action-buffer))))
    (volatile)
    (type . file)))

(defun anything-files-in-current-dir++-persistent-action (c)
  (let ((b (get-buffer-create anything-files-in-current-dir++persistent-action-buffer)))
      (with-current-buffer b
        (erase-buffer)
        (insert-file-contents c)
        (goto-char (point-min)))
      (pop-to-buffer b)
      (funcall anything-files-in-current-dir++mode-name)))

(provide 'anything-files-in-current-dir++)

;;; anything-flies-in-current-dir++.el ends here
