(require 'handlebars-mode)
(add-hook 'handlebars-mode-hook
  (lambda ()
    (set (make-local-variable 'comment-start) "<!-- ")
    (set (make-local-variable 'comment-end) " -->")
    ))
