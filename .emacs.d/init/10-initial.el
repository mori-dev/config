(add-to-list 'exec-path (concat (getenv "HOME") "/Dropbox/bin"))
(add-to-list 'exec-path (concat (getenv "HOME") "/.cabal/bin"))

(add-hook 'emacs-lisp-mode-hook
  (lambda()
    (define-key emacs-lisp-mode-map (kbd "C-j") 'eval-print-last-sexp)))

(add-hook 'lisp-interaction-mode-hook
  (lambda()
    (emacs-lisp-mode)))

(add-hook 'after-revert-hook
          (lambda ()
            (when auto-revert-tail-mode (end-of-buffer))))
