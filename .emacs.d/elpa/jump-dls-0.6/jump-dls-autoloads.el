;;; jump-dls-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "jump-dls" "jump-dls.el" (0 0 0 0))
;;; Generated autoloads from jump-dls.el

(autoload 'jump-symbol-at-point "jump-dls" "\
Go to the definition of the symbol at point.
If this was the `last-command', then continue previous search by trying
additional jump methods.

\(fn &optional ASK)" t nil)

(autoload 'jump-back "jump-dls" "\
Return back to position before the last jump.

\(fn)" t nil)

(autoload 'jump-clear-stack "jump-dls" "\
Clear the jump stack.

\(fn)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "jump-dls" '("jump-" "imenu-rescan")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; jump-dls-autoloads.el ends here
