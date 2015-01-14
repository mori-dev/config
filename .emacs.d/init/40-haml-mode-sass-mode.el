
(require 'haml-mode)
(add-to-list 'auto-mode-alist '("\\.haml$" . haml-mode))
(require 'sass-mode)
(add-to-list 'auto-mode-alist '("\\.sass$" . sass-mode))

(add-hook 'haml-mode-hook
  (lambda()
    (define-key haml-mode-map "\C-c\C-k" 'my-kill-line0)))


(require 'auto-complete nil t)


;;; auto-complete

;; haml-mode-hook だとファイルオープン時に auto-complete-mode にならない
(defun my-ac-haml-mode ()
  (when (string-equal (file-name-extension buffer-file-name) "haml")
    (auto-complete-mode t)
    (setq ac-sources '(ac-source-words-in-same-mode-buffers ac-source-dictionary))))

(add-hook 'find-file-hook 'my-ac-haml-mode)

(defun my-ac-sass-mode ()
  (when (string-equal (file-name-extension buffer-file-name) "sass")
    (auto-complete-mode t)
    (setq ac-sources '(ac-source-words-in-same-mode-buffers ac-source-dictionary))))

(add-hook 'find-file-hook 'my-ac-sass-mode)


(defun hamllint-thisfile ()
  (interactive)
  (compile (format "haml -c %s" (buffer-file-name))))

(defun sasslint-thisfile ()
  (interactive)
  (compile (format "sass -c %s" (buffer-file-name))))

(add-hook 'haml-mode-hook
  (lambda()
    (define-key haml-mode-map (kbd "<M-f5>") 'hamllint-thisfile)))

(add-hook 'sass-mode-hook
  (lambda()
    (define-key sass-mode-map (kbd "<M-f5>") 'sasslint-thisfile)))

;;flymake
(require 'flymake)

(defun flymake-haml-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "haml" (list "-c" local-file))))

(push '(".+\\.haml$" flymake-haml-init) flymake-allowed-file-name-masks)

(add-to-list 'flymake-err-line-patterns '("Syntax error on line \\([0-9]+\\): \\(.*\\)" 1 2 nil 1))




(defun flymake-sass-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "sass" (list "-c" local-file))))
(push '(".+\\.sass$" flymake-sass-init) flymake-allowed-file-name-masks)





(defun my-sass-to-css (begin end)
  "リージョンの Sass が生成する CSS を確認する"
  (interactive "r")
  (let* ((text (buffer-substring-no-properties begin end))
         (command (format "ruby -rubygems -e \"require 'sass'; puts Sass::Engine.new('%s').render\"" text))
         (buffer "*css*"))
    (when (get-buffer buffer)
      (kill-buffer buffer))
    (get-buffer-create buffer)
    (call-process-shell-command command nil buffer t)
    (view-buffer-other-window buffer t (lambda (dummy) (kill-buffer-and-window)))))

(defalias 'sass 'my-sass-to-css-region)
(defun my-sass-to-css-region ()
  (interactive)
  (when (region-active-p)
    (let ((region-str (buffer-substring-no-properties (region-beginning) (region-end)))
          (result-buf "*css*")
          (temp-file (make-temp-file "my-sass-to-css-region-")))
      (with-temp-file temp-file
        (insert region-str))
      (shell-command (concat "sass " temp-file " -t expanded") result-buf)
      (view-buffer-other-window result-buf t
                                (lambda (buf)
                                  (kill-buffer-and-window)
                                  (delete-file temp-file))))))

(defalias 'haml 'my-haml-to-html4-region)
(defun my-haml-to-html4-region ()
  (interactive)
  (when (region-active-p)
    (let ((region-str (buffer-substring-no-properties (region-beginning) (region-end)))
          (result-buf "*html*")
          (temp-file (make-temp-file "my-haml-to-html-region-")))
      (with-temp-file temp-file
        (insert region-str))
      (shell-command (concat "haml --trace " temp-file " -f html4") result-buf)
      (view-buffer-other-window result-buf t
                                (lambda (buf)
                                  (kill-buffer-and-window)
                                  (delete-file temp-file))))))



(defun my-html-to-haml-region ()
  (interactive)
  (when (region-active-p)
    (let ((region-str (buffer-substring-no-properties (region-beginning) (region-end)))
          (result-buf "*haml*")
          (temp-file (make-temp-file "my-html-to-haml-region-")))
      (with-temp-file temp-file
        (insert region-str))
      (shell-command (concat "html2haml " temp-file) result-buf)
      (view-buffer-other-window result-buf t
                                (lambda (buf)
                                  (kill-buffer-and-window)
                                  (delete-file temp-file))))))

(defun my-css-to-sass-region ()
  (interactive)
  (when (region-active-p)
    (let ((region-str (buffer-substring-no-properties (region-beginning) (region-end)))
          (result-buf "*sass*")
          (temp-file (make-temp-file "my-css-to-sass-region-")))
      (with-temp-file temp-file
        (insert region-str))
      (shell-command (concat "sass-convert " temp-file) result-buf)
      (view-buffer-other-window result-buf t
                                (lambda (buf)
                                  (kill-buffer-and-window)
                                  (delete-file temp-file))))))