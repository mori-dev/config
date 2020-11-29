(require 'jump-dls)
(add-hook
 'emacs-lisp-mode-hook
 '(lambda()
    (define-key emacs-lisp-mode-map "\C-cj" 'jump-symbol-at-point)
    (define-key emacs-lisp-mode-map "\C-cb" 'jump-back)))
