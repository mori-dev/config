
(autoload 'scheme-smart-complete "scheme-complete" nil t)
(eval-after-load 'scheme
  '(progn (define-key scheme-mode-map "\t" 'scheme-complete-or-indent)))
(autoload 'scheme-get-current-symbol-info "scheme-complete" nil t)
(add-hook 'scheme-mode-hook
  (lambda ()
    (make-local-variable 'eldoc-documentation-function)
    (setq eldoc-documentation-function 'scheme-get-current-symbol-info)
    (eldoc-mode t)
    (setq lisp-indent-function 'scheme-smart-indent-function)))
;(define-key scheme-mode-map '[(control tab)] 'scheme-smart-complete)

