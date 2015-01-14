(require 'anything-rdefs)

(global-set-key (kbd "C-@") 'anything-myrurema)
(add-hook 'ruby-mode-hook
          (lambda ()
            (define-key ruby-mode-map (kbd "C-@") 'anything-myrurema-and-rdefs)))



(defun anything-myrurema-and-rdefs (prefix)
  (interactive "p")
  (case prefix
    (1  (anything-myrurema))
    (4  (anything-rdefs))))
