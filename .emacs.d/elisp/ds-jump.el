;; http://www.emacswiki.org/emacs/jump-dls.el と
;; https://github.com/eschulte/jump.el/blob/master/jump.el との衝突を避けるため、
;; 前者のプレフィックスを ds-jump- に変更した
;;
;;; ds-jump.el --- Jump to definition of symbol using various methods

;; Copyright (C) 2007,2008,2009  David Shilvock

;; Author: David Shilvock <davels@telus.net>
;; Version: 0.4
;; Keywords: tools

;; $Id: jump.el 188 2009-02-28 21:21:53Z dave $

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; Provides a command to jump to the source of the symbol at point using a
;; number of possible methods, such as semantic, tags, etc.  A stack of
;; jump points is maintained so it is possible to make several jumps then
;; progressively jump back to point where each jump was made from.
;;
;; `ds-jump-jumpers' defines the list of jump functions and the order they will be
;; tried in.  If `ds-jump-symbol-at-point' succeeds, you can immediately call it
;; again and the jump will continue with the next untried function.  You can
;; also use `ds-jump-clear-stack' to clear the current jump stack.
;;
;; BASIC SETUP
;;
;; (require 'jump)
;; (global-set-key [f4] 'ds-jump-symbol-at-point)
;; (global-set-key [(shift f4)] 'ds-jump-back)

;;; Code:

(require 'imenu)
(require 'etags)

(defvar ds-jump-jumpers
  '(("lisp-find" ds-jump-lisp-symbol)
    ("semantic" ds-jump-semantic)
    ("imenu" ds-jump-imenu)
    ("global" ds-jump-global)
    ("tags" ds-jump-tags)
    ("ffap" ds-jump-ffap))
  "List of functions tried by `ds-jump-symbol-at-point'.
Each function is tried in turn, until one returns non-nil.  Jump functions are
  called with point on the current symbol and are also passed the symbol as a
  string (for convenience).  They should select the buffer containing the
  symbol, move point there and return non-nil.  If they can not find the symbol,
  return nil.  Functions can also return 'stop to indicate an immediate stop to
  further searching.")

(defvar ds-jump-silent nil
  "Non-nil says to suppress any status or error messages.")

(defvar ds-jump-stack nil
  "Stack of jump positions.")

;; -----------------------------------------------
;; jump interface
;; -----------------------------------------------

(defvar ds-jump--last-symbol nil)
(defvar ds-jump--jumpers-pos nil)

(defun ds-jump-get-symbol-at-point ()
  (let ((sym (funcall (or find-tag-default-function
                          (get major-mode 'find-tag-default-function)
                          'find-tag-default))))
    ;; remove any text properties
    (if sym
        (set-text-properties 0 (length sym) nil sym))
    sym))

(defun ds-jump--to-marker (mark &optional nodelete)
  (switch-to-buffer (marker-buffer mark))
  (goto-char (marker-position mark))
  (unless nodelete
    (set-marker mark nil nil)))
  
(defun ds-jump--symbol (sym pos)
  (let (jumper jumped)
    (while (and (not jumped)
                (setq jumper (nth pos ds-jump-jumpers))
                (setq pos (1+ pos)))                
      (setq jumped (funcall (cadr jumper) sym)))
    (when (and jumped (not (eq jumped 'stop)))
      ;; successful jump
      (or ds-jump-silent (message "Jumped: %s" (car jumper)))
      pos)))

;;;###autoload
(defun ds-jump-symbol-at-point (&optional ask)
  "Go to the definition of the symbol at point.
If this was the `last-command', then continue previous search by trying
additional jump methods."
  (interactive "P")
  (let (sym pos iscontinue target)
    (save-excursion
      (if (eq last-command 'ds-jump-symbol-at-point)               
          ;; continue previous jump
          (progn
            (or ds-jump--jumpers-pos
                (error "No other jump methods"))
            ;; first jump back to start point
            (ds-jump--to-marker (car ds-jump-stack) t)
            (setq iscontinue t
                  sym ds-jump--last-symbol
                  pos ds-jump--jumpers-pos))
        ;; new jump
        (setq sym (or (ds-jump-get-symbol-at-point)
                      (error "No symbol found at point"))
              pos 0))
      ;; try to jump
      (unless (setq ds-jump--last-symbol sym
                    ds-jump--jumpers-pos (ds-jump--symbol sym pos))
        (error "No jump method found for '%s'" sym))
      (setq target (point-marker)))
    ;; push current position on stack and jump
    (when target
      (unless iscontinue
        (setq ds-jump-stack (cons (point-marker) ds-jump-stack)))
      (ds-jump--to-marker target))))
    
;;;###autoload
(defun ds-jump-back ()
  "Return back to position before the last jump."
  (interactive)
  (if (null ds-jump-stack)
      (error "No previous jump"))
  (let ((mark (car ds-jump-stack)))
    ;; Pop the stack
    (setq ds-jump-stack (cdr ds-jump-stack))
    (ds-jump--to-marker mark))
  (or ds-jump-silent
      (message "Jumped back (%d)" (length ds-jump-stack))))

;;;###autoload
(defun ds-jump-clear-stack ()
  "Clear the jump stack."
  (interactive)
  (setq ds-jump-stack nil)
  (or ds-jump-silent
      (message "Jump stack cleared")))


;; -----------------------------------------------
;; jumpers
;; -----------------------------------------------

;; ds-jump-lisp-symbol

(defun ds-jump-lisp--find (interned)
  (or
   (and (fboundp interned)
        (find-function-do-it interned nil 'switch-to-buffer))
   (and (boundp interned)
        (find-function-do-it interned 'defvar 'switch-to-buffer))))

(defun ds-jump-lisp-symbol (sym)
  (and (or (memq major-mode '(emacs-lisp-mode debugger-mode lisp-interaction-mode))
           (member (buffer-name) '("*Messages*" "*Help*" "*scratch*")))
       (fboundp 'find-function-do-it)
       (intern-soft sym)
       ;; NOTE: find-function always returns nil
       (let ((orig-buf (window-buffer))
             (orig-point (point))
             (interned (intern sym)))
         (condition-case err
             (progn
               ;; only browse into C source if directory is already defined
               (if find-function-C-source-directory
                   (ds-jump-lisp--find interned)
                 (flet ((find-function-C-source (fun-or-var file type)
                                                (error "Don't browse C source")))
                   (ds-jump-lisp--find interned)))
               (not (and (eq (point) orig-point)
                         (eq (window-buffer) orig-buf))))
           ;;(error (message "%s" (cadr err))
           ;;       'stop)
           (error (or (string-match "^Don't browse C source" (cadr err))
                      ds-jump-silent
                      (message "ds-jump-lisp-symbol error: %s" (cadr err)))
                  nil)))))

;; ds-jump-semantic

(defun ds-jump-semantic (sym)
  (if (fboundp 'semantic-ia-fast-jump)
      (condition-case err
          (progn (semantic-ia-fast-jump (point))
                 t)                                 
        (error (or (and (stringp (cadr err))
                        (string-match "^Could not find suitable jump point for "
                                      (cadr err)))
                   ds-jump-silent
                   (message "ds-jump-semantic error: %s" (cadr err)))
               nil))))

;; ds-jump-imenu

(defvar ds-jump-imenu-limit-to-major-mode t
  "If non-nil ds-jump-imenu will limit search to buffers of same major mode.")

(defvar ds-jump-imenu--seen-it nil)

(defun ds-jump-imenu-in-alist (str alist)
  "Check whether the string STR is contained in multi-level ALIST."
  (let (elt head tail res prob-res (initial alist))
    (while alist
      (setq elt (car alist)
            alist (cdr alist)
            head (car elt)
            tail (cdr elt))
      (if head
          (if (string= str head)
              (setq alist nil
                    res tail)
            (and (listp tail)
                 ;; ignore cc-mode Includes in imenu
                 (not (string= head "Includes"))
                 ;; Avoid recursion
                 (setq prob-res (or (if (memq tail ds-jump-imenu--seen-it)
                                        nil
                                      (setq ds-jump-imenu--seen-it 
                                            (cons tail ds-jump-imenu--seen-it))
                                      (ds-jump-imenu-in-alist str tail))
                                    prob-res)))
            (or prob-res 
                (if (string-match (concat "\\<" (regexp-quote str) "\\>") head)
                    (setq prob-res tail))))))
    (or res prob-res)))

(defun ds-jump-imenu-search-buffer (str)
  "Check whether the string STR is known to `imenu'."
  (let (ds-jump-imenu--seen-it
        pos)
    (setq pos (and (boundp 'imenu--index-alist)
                   imenu--index-alist
                   (ds-jump-imenu-in-alist str imenu--index-alist)))
    ;; imenu can have overlays & vectors as well has positions (see semantic)
    (if (vectorp pos)
        (setq pos (elt pos 1)))
    (if (overlayp pos)
        (setq pos (overlay-start pos)))
    pos))

(defun ds-jump-imenu-search-all-buffers (sym)
  (let ((blist (buffer-list))
        (initial-buffer (current-buffer))
        (mm (and ds-jump-imenu-limit-to-major-mode major-mode))
        buffer
        pos)
    (save-excursion
      (while (and (not pos) blist)
        (setq buffer (car blist)
              blist (cdr blist))
        (set-buffer buffer)
        (if (or (eq buffer initial-buffer) (null mm) (eq mm major-mode))
            (setq pos (ds-jump-imenu-search-buffer sym)))))
    (if pos (list buffer pos))))
    
(defun ds-jump-imenu (sym)
  (let ((buf-pos (ds-jump-imenu-search-all-buffers sym))
        (pop-up-windows nil))
    (when buf-pos
      (pop-to-buffer (car buf-pos))
      (goto-char (cadr buf-pos))
      t)))

;; ds-jump-global

(defun ds-jump-global (sym)
  (condition-case err
      (cond ((and (boundp 'gtags-mode) gtags-mode)
             (let (flag)
               (if (gtags-is-function)
                   (if (gtags-is-definition) (setq flag "r") (setq flag ""))
                 (setq flag "s"))
               (gtags-push-context)
               (gtags-goto-tag sym flag))
             t)
            ((and (boundp 'xgtags-mode) xgtags-mode)
             (let ((orig-buf (window-buffer))
                   (orig-point (point))
                   (xgtags-goto-tag 'always)
                   (option (cond ((not (xgtags--function-p)) 'symbol)
                                       ((xgtags--definition-p) 'reference)
                                       (t nil))))
               (xgtags--goto-tag sym option)
               (or (not (and (eq (point) orig-point)
                             (eq (window-buffer) orig-buf)))
                   ;; guess for option is sometimes wrong
                   ;; - so try again if 'symbol failed
                   (when (eq option 'symbol)
                     (xgtags--goto-tag sym)
                     (not (and (eq (point) orig-point)
                               (eq (window-buffer) orig-buf))))))))
    (error (or ds-jump-silent
               (message "ds-jump-global error: %s" (cadr err)))
           nil)))

;; ds-jump-tags

(defun ds-jump-tags (sym)
  ;; only if the tags file is already defined.
  ;; we don't want a "visit tags file" prompt.
  (if (or tags-file-name tags-table-list)
      (condition-case err
          (progn (find-tag sym) t)
        (error (or ds-jump-silent
                   (string-match "^No tags containing " (cadr err))
                   (message "ds-jump-tags error: %s" (cadr err)))
               nil))))

;; ds-jump-ffap

(defun ds-jump-ffap (sym)
  (let ((thing (ffap-guesser)))
    (when  thing 
      (ffap thing)
      t)))


(provide 'ds-jump)
;;; jump.el ends here
