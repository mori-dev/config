(require 'smartrep)
(eval-after-load "markdown-mode"
        '(progn
           (smartrep-define-key
            markdown-mode-map "C-c" '(("C-n" . (lambda () 
                                            (outline-next-visible-heading 1)))
                                 ("C-p" . (lambda ()
                                            (outline-previous-visible-heading 1)))))))
