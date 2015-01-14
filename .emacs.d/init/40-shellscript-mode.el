(add-hook 'sh-mode-hook
          '(lambda ()
             (define-key sh-mode-map "\C-m" 'reindent-then-newline-and-indent)))