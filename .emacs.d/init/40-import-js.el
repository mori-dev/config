(require 'import-js)

(defun my-get-top-dir (name &optional dir)
  (interactive)
  (let ((default-directory (file-name-as-directory (or dir default-directory))))
    (if (file-exists-p name)
        (file-name-directory (expand-file-name name))
      (unless (string= "/" (directory-file-name default-directory))
        (my-get-top-dir name (expand-file-name ".." default-directory))))))

;; (setq import-js-project-root (my-get-top-dir ".git"))
(setq import-js-project-root "/Users/mori/www/now/packages/now_mobile")

;; (define-prefix-command 'my-keymap)
;; (global-set-key (kbd "s-a") 'my-keymap)
;; (define-key my-keymap (kbd "a u") 'import-js-import)
