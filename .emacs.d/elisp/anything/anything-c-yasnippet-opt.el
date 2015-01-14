;;; anything-c-yasnippet-opt.el --- anything-c-yasnippet.el optional utilities

;; Copyright (C) 2009  kitokitoki

;; Author: kitokitoki <morihenotegami@gmail.com>
;; Keywords: anything, yasnippet
;; Prefix: anything-c-yas-opt-

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

;; (require 'anything-c-yasnippet-opt)
;; (global-set-key (kbd "C-c y") 'anything-c-yas-opt-complete)

;; Change Log
;; 1.0.2: Create new snippet on region へアクセスしやすくした
;; 1.0.1: cleanup で persistent-action で用いたバッファを削除する処理を追加。
;; 1.0.0: 新規作成

;;; Commentary:

;; TODO documentation

;;; Code:

(require 'anything-c-yasnippet)

(defvar anything-c-yas-opt-persistent-buffer "*anything-yas-persistent-doc*")

(defun anything-c-yas-opt-complete ()
  "List of yasnippet snippets using `anything' interface."
  (interactive)
  (anything (list
             anything-c-source-yasnippet-opt-menu
             anything-c-source-yasnippet-opt)
             nil nil nil nil
             "*anything yasnippet*"))

(defvar anything-c-yas-opt-menu-list
      '(("Create new snippet on region"
         . "(anything-c-yas-create-new-snippet anything-c-yas-selected-text)")))

(defvar anything-c-source-yasnippet-opt-menu
  '((name . "menu")
    (candidates . anything-c-yas-opt-menu-list)
    (type . sexp)))

(defun anything-c-yas-opt-find-file-snippet-by-template-persistent (template)
  (let ((path (anything-c-yas-get-path-by-template template))
           (b (get-buffer-create anything-c-yas-opt-persistent-buffer)))
      (with-current-buffer b
        (erase-buffer)
        (insert-file-contents path)
        (goto-char (point-min)))
      (pop-to-buffer b)))



(defvar anything-c-source-yasnippet-opt
  `((name . "Yasnippet")
    (init . (lambda ()
              (setq anything-c-yas-cur-major-mode major-mode)
              (setq anything-c-yas-selected-text (if mark-active (buffer-substring-no-properties (region-beginning) (region-end)) ""))
              (multiple-value-setq
                  (anything-c-yas-initial-input anything-c-yas-point-start anything-c-yas-point-end) (anything-c-yas-get-cmp-context)) ;return values(str point point)
              (setq anything-c-yas-cur-snippets-alist (anything-c-yas-build-cur-snippets-alist))))
    (candidates . (anything-c-yas-get-candidates anything-c-yas-cur-snippets-alist))
    (candidate-transformer . (lambda (candidates)
                               (anything-c-yas-get-transformed-list anything-c-yas-cur-snippets-alist anything-c-yas-initial-input)))
    (action . (("Insert snippet" . (lambda (template)
                                     (yas/expand-snippet anything-c-yas-point-start anything-c-yas-point-end template)
                                     (when anything-c-yas-display-msg-after-complete
                                       (message "this snippet is bound to [ %s ]"
                                                (anything-c-yas-get-key-by-template template anything-c-yas-cur-snippets-alist)))))
               ("Open snippet file" . (lambda (template)
                                        (anything-c-yas-find-file-snippet-by-template template)))
               ("Open snippet file other window" . (lambda (template)
                                                     (anything-c-yas-find-file-snippet-by-template template t)))
               ("Create new snippet on region" . (lambda (template)
                                                   (anything-c-yas-create-new-snippet anything-c-yas-selected-text)))
               ("Reload All Snippts" . (lambda (template)
                                         (yas/reload-all)
                                         (message "Reload All Snippts done")))
               ("Rename snippet file" . (lambda (template)
                                       (let* ((path (or (anything-c-yas-get-path-by-template template) ""))
                                              (dir (file-name-directory path))
                                              (filename (file-name-nondirectory path))
                                              (rename-to (read-string (concat "rename [" filename "] to: "))))
                                         (rename-file path (concat dir rename-to))
                                         (yas/reload-all))))
               ("Delete snippet file" . (lambda (template)
                                          (let ((path (or (anything-c-yas-get-path-by-template template) "")))
                                            (when (y-or-n-p "really delete?")
                                              (delete-file path)
                                              (yas/reload-all)))))))
    (persistent-action . (lambda (template)
                           (anything-c-yas-opt-find-file-snippet-by-template-persistent template)))
    (match . (anything-c-yas-match))
    (cleanup . anything-c-yas-opt-delete-persistent-action-buffer)))

(defun anything-c-yas-opt-delete-persistent-action-buffer()
   (and (get-buffer anything-c-yas-opt-persistent-buffer)
        (kill-buffer (get-buffer anything-c-yas-opt-persistent-buffer))))

(provide 'anything-c-yasnippet-opt)
;; anything-c-yasnippet.el ends here
