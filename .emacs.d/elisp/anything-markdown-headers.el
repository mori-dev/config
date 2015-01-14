;;; anything-markdown-headers.el  --- utility for markdown mode

;; Copyright (C) 2012-2013 mori_dev

;; Author: mori_dev <mori.dev.asdf@gmail.com>
;; Keywords: anything, ruby
;; Prefix: am:

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

;;; Installation:

;; install requires libraries:
;; `anything.el'               http://www.emacswiki.org/emacs/anything.el
;; `anything-config.el'        http://www.emacswiki.org/emacs/anything-config.el
;; `anything-match-plugin.el'  http://www.emacswiki.org/emacs/anything-match-plugin.el

;;; Setting Sample
;;
;; (require 'anything-markdown-headers)
;; (add-hook 'markdown-mode-hook
;;           (lambda ()
;;             (define-key markdown-mode-map (kbd "C-@") 'anything-markdown-headers)))

(require 'cl)
(require 'anything-config)

(defvar am:recenter-height 5)
(defvar am:buffer "*markdown-headers*")
(defvar am:current-line-overlay (make-overlay (point) (point)))
(defvar am:enable-auto-look-flag t)
(defvar am:push-mark-flag t)

(defun am:substring-line-number (s)
  (when (string-match "\\([0-9]+\\)" s)
    (match-string 1 s)))

(defmacro am:aif (test-form then-form &optional else-form)
  `(let ((it ,test-form))
     (if it ,then-form ,else-form)))

(defmacro* am:awhen (test-form &body body)
  `(am:aif ,test-form
        (progn ,@body)))


(defvar anything-c-source-markdown-headers
  '((name . "markdown-headers")
    (init . anything-c-markdown-headers-init)
    (candidates-in-buffer)
    (action . anything-c-markdown-headers-action)
    (persistent-action . am:persistent-action)
    (cleanup . am:clean-up)))

(defun anything-markdown-headers ()
  (interactive)
  (let ((anything-display-function 'am:display-buffer)
         (anything-buffer am:buffer)
         (anything-map am:anything-map))
    (letf (((symbol-function 'anything-create-anything-buffer)
            (symbol-function 'am:anything-create-anything-buffer)))
      (anything anything-c-source-markdown-headers))))

(defun anything-c-markdown-headers-init ()
  (let ((file-path (buffer-file-name)))
    (with-current-buffer (anything-candidate-buffer 'global)
      (am:execute-markdown-headers file-path))))

(defun anything-c-markdown-headers-action (candidate)
  (am:awhen (am:substring-line-number candidate)
         (goto-line (string-to-number it))
         (recenter am:recenter-height)))

(defun am:clean-up ()
  (when (overlayp am:current-line-overlay)
    (delete-overlay am:current-line-overlay)))

(defun am:persistent-action (candidate)
  (am:awhen (am:substring-line-number candidate)
     (goto-line (string-to-number it))
     (recenter am:recenter-height)
     (when (overlayp am:current-line-overlay)
       (move-overlay am:current-line-overlay
                     (line-beginning-position)
                     (line-end-position)
                     (current-buffer))
       (overlay-put am:current-line-overlay 'face 'highlight))))

(defun am:anything-execute-persistent-action ()
  (when am:enable-auto-look-flag
    (unless (zerop (buffer-size (get-buffer (anything-buffer-get))))
      (anything-execute-persistent-action))))

(defvar am:anything-map
  (let ((map (copy-keymap anything-map)))
    (define-key map (kbd "C-n")  'am:next-line)
    (define-key map (kbd "C-p")  'am:previous-line)
    map))

(defun am:next-line ()
  (interactive)
  (anything-next-line)
  (am:anything-execute-persistent-action))

(defun am:previous-line ()
  (interactive)
  (anything-previous-line)
  (am:anything-execute-persistent-action))

(defun am:display-buffer (buf)
  (delete-other-windows)
  (split-window (selected-window) nil t)
  (pop-to-buffer buf))

(defun am:execute-markdown-headers (file-path)
  (interactive)
  (let (
        ;;todo 
        (command (concat "grep -n '^#' " file-path  " | sed -e 's/\\\(\[0-9\]*\\\):\\\(.*\\\)/\\1\\t\\2/g'"))
        ;; (command (concat "grep -n '^#\\\{1,2\\\}[^#]' " file-path  " | sed -e 's/\\\(\[0-9\]*\\\):\\\(.*\\\)/\\1\\t\\2/g'"))
        )
    (call-process-shell-command command nil t t)
    ))

(defun am:anything-create-anything-buffer (&optional test-mode)
  (with-current-buffer (get-buffer-create anything-buffer)
    (anything-log "kill local variables: %S" (buffer-local-variables))
    (kill-all-local-variables)
    (buffer-disable-undo)
    (erase-buffer)
    (when (require 'conf-mode nil t) (conf-mode))
    (when (fboundp 'linum-mode)
      (linum-mode -1))
    (set (make-local-variable 'inhibit-read-only) t)
    (set (make-local-variable 'anything-last-sources-local) anything-sources)
    (set (make-local-variable 'anything-follow-mode) nil)
    (set (make-local-variable 'anything-display-function) anything-display-function)
    (anything-log-eval anything-display-function anything-let-variables)
    (loop for (var . val) in anything-let-variables
          do (set (make-local-variable var) val))
    (setq cursor-type nil)
    (setq mode-name "Anything"))
  (anything-initialize-overlays anything-buffer)
  (get-buffer anything-buffer))

(provide 'anything-markdown-headers)
