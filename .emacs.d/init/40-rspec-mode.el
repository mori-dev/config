(require 'rspec-mode)

(add-hook 'ruby-mode-hook
          (lambda ()
            (when (and (not (null buffer-file-name)) (string-match "_spec.rb$" buffer-file-name))
              (rspec-mode 1))))
