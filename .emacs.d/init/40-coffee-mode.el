(require 'coffee-mode)

;; https://github.com/yasuyk/coffee-fof
(require 'coffee-fof) ;; Not necessary if using ELPA package
(coffee-fof-setup)


(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
(add-to-list 'auto-mode-alist '("Cakefile" . coffee-mode))

;; (add-hook 'coffee-mode-hook
;;           (lambda ()
;;             (when (member (file-name-extension buffer-file-name) '("coffee"))
;;               (auto-complete-mode t)
;;               (setq ac-sources '(ac-source-words-in-same-mode-buffers ac-source-dictionary ac-source-gtags)))))

(defun coffee-custom ()
  "coffee-mode-hook"
 (set (make-local-variable 'tab-width) 2))

(add-hook 'coffee-mode-hook
  '(lambda() (coffee-custom)))

(define-key coffee-mode-map (kbd "M-r") 'coffee-compile-buffer)


(defun coffee-open-reference ()
  "Open browser to CoffeeScript reference."
  (interactive)
  (browse-url "http://jashkenas.github.com/coffee-script/"))

(defun coffee-open-node-reference ()
  "Open browser to node.js documentation."
  (interactive)
  (browse-url "http://nodejs.org/docs/"))

(defun coffee-open-github ()
  "Open browser to `coffee-mode' project on GithHub."
  (interactive)
  (browse-url "http://github.com/defunkt/coffee-mode"))
