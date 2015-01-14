
(require 'anything-markdown-headers)
(add-hook 'markdown-mode-hook
          (lambda ()
            (define-key markdown-mode-map (kbd "C-@") 'anything-markdown-headers)))
