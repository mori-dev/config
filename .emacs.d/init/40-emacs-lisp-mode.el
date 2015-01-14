(add-hook
 'emacs-lisp-mode-hook
  (lambda()
    (define-key emacs-lisp-mode-map (kbd "C-j") 'eval-print-last-sexp)
    ))

(add-hook
 'lisp-interaction-mode-hook
  (lambda()
    (define-key lisp-interaction-mode-map (kbd "C-j") 'eval-print-last-sexp)
    ))
