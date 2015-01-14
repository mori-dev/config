
;; cd ~/d/data/rurema
;; ruby1.9 ar-index.rb ~/Dropbox/data/rurema/rubydoc 

(require 'anything-rurema)
(setq anything-rurema-index-file "~/Dropbox/data/rurema/rubydoc/rurema.e")

(add-hook 'ruby-mode-hook
  (lambda()
    ;; (define-key ruby-mode-map [f1] 'anything-rurema-at-point)
    ))
