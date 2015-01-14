;;; uniquify_with_project_name.el

;; Copyright (C) 2010-2011 mori_dev

;; Author: mori_dev <mori.dev.asdf@gmail.com>
;; Keywords: uniquify, buffer
;; Prefix: uwpn-

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

;; 注意1: (require 'uniquify_with_project_name) より上に書くこと
;; 注意2: プロジェクトのトップディレクトリへのパスは絶対パスで書き、最後にスラッシュを付けないこと
;; (setq uwpn-project-root-alist
;;       '(("/path/to/project_a" . "プロジェクトA")
;;         ("/path/to/project_b" . "プロジェクトB")
;;         ;; ("" . "")
;;         ))
;; 
;; (require 'uniquify_with_project_name)

;;; Code:

(require 'uniquify)

(defvar uwpn-project-root-alist nil
  "(require 'uniquify_with_project_name) より上で、プロジェクトトップディレクトリ
への絶対パスとプロジェクト名からなる連想リストを設定する必要がある点に注意。Setting Sample 参照。")

(dolist (elt uwpn-project-root-alist)
  (setf (car (assoc (car elt) uwpn-project-root-alist))
        (concat "^" (car (assoc (car elt) uwpn-project-root-alist)))))

;; オーバーライド
(defun uniquify-get-proposed-name (base dirname &optional depth)
  (let ((tmp-dirname dirname))
    (with-no-warnings
      (unless depth (setq depth uniquify-min-dir-content))
      (assert (equal (directory-file-name dirname) dirname)) ;No trailing slash.

      ;; Distinguish directories by adding extra separator.
      (if (and uniquify-trailing-separator-p
               (file-directory-p (expand-file-name base dirname))
               (not (string-equal base "")))
          (cond ((eq uniquify-buffer-name-style 'forward)
                 (setq base (file-name-as-directory base)))
                ;; (setq base (concat base "/")))
                ((eq uniquify-buffer-name-style 'reverse)
                 (setq base (concat (or uniquify-separator "\\") base)))))

      (let ((extra-string nil)
            (n depth))
        (while (and (> n 0) dirname)
          (let ((file (file-name-nondirectory dirname)))
            (when (setq dirname (file-name-directory dirname))
              (setq dirname (directory-file-name dirname)))
            (setq n (1- n))
            (push (if (zerop (length file)) ;nil or "".
                      (prog1 (or (file-remote-p dirname) "")
                        (setq dirname nil)) ;Could be `dirname' iso "".
                    file)
                  extra-string)))
        (when (zerop n)
          (if (and dirname extra-string
                   (equal dirname (file-name-directory dirname)))
              ;; We're just before the root.  Let's add the leading / already.
              ;; With "/a/b"+"/c/d/b" this leads to "/a/b" and "d/b" but with
              ;; "/a/b"+"/c/a/b" this leads to "/a/b" and "a/b".
              (push "" extra-string))
          (setq uniquify-possibly-resolvable t))

        (let ((tmp-buf (cond
                        ((null extra-string) base)
                        ((string-equal base "") ;Happens for dired buffers on the root directory.
                         (mapconcat 'identity extra-string "/"))
                        ((eq uniquify-buffer-name-style 'reverse)
                         (mapconcat 'identity
                                    (cons base (nreverse extra-string))
                                    (or uniquify-separator "\\")))
                        ((eq uniquify-buffer-name-style 'forward)
                         (mapconcat 'identity (nconc extra-string (list base))
                                    "/"))
                        ((eq uniquify-buffer-name-style 'post-forward)
                         (concat base (or uniquify-separator "|")
                                 (mapconcat 'identity extra-string "/")))
                        ((eq uniquify-buffer-name-style 'post-forward-angle-brackets)
                         (concat base "<" (mapconcat 'identity extra-string "/")
                                 ">"))
                        (t (error "Bad value for uniquify-buffer-name-style: %s"
                                  uniquify-buffer-name-style)))))

          (if (string= tmp-buf base)
              base
            (uwpn-aif (uwpn-get-project-name tmp-dirname)
                 (concat it ":" tmp-buf)
                 tmp-buf)))))))

(defun uwpn-get-project-name (dir)
  (cdr (assoc (loop for i in (mapcar 'car uwpn-project-root-alist)
                    when (string-match i dir)
                    return i)
              uwpn-project-root-alist)))

(defmacro uwpn-aif (test-form then-form &rest else-forms)
  (declare (indent 2)
           (debug (form form &rest form)))
  "Anaphoric if. Temporary variable `it' is the result of test-form."
  `(let ((it ,test-form))
     (if it ,then-form ,@else-forms)))

(provide 'uniquify_with_project_name)
