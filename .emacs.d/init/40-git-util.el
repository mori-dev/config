(require 'cl)

(defmacro* with-temp-directory (dir &body body)
  `(with-temp-buffer
     (cd ,dir)
     ,@body))

(defmacro aif (test-form then-form &optional else-form)
  `(let ((it ,test-form))
     (if it ,then-form ,else-form)))

(defmacro* awhen (test-form &body body)
  `(aif ,test-form
        (progn ,@body)))

(defun find-file-upward (file-name &optional dir)
  (interactive)
  (let ((default-directory (file-name-as-directory (or dir default-directory))))
    (if (file-exists-p file-name)
        (expand-file-name file-name)
      (unless (string= "/" (directory-file-name default-directory))
        (find-file-upward file-name (expand-file-name ".." default-directory))))))

(defun git-repo-p ()
  (when (find-file-upward ".git") t))

(defun git-log-p-this-file ()
  (interactive)
  (let ((file (buffer-file-name)))
    (unless (git-repo-p) (error "git 管理下にありません"))
    (let ((dir (concat (find-file-upward ".git") "/../"))
          (buf "*git-log-p-this-file*"))
      (with-temp-directory dir
         (awhen (get-buffer buf)
                (with-current-buffer it (erase-buffer)))
         (call-process-shell-command (concat "git log -p -- " file) nil buf t))
      (switch-to-buffer buf)
      (diff-mode)
      (goto-char (point-min)))))

(defun my-git-diff-this-file ()
  (interactive)
  (let ((file (buffer-file-name)))
    (unless (git-repo-p) (error "git 管理下にありません"))
    (let ((dir (concat (find-file-upward ".git") "/../"))
          (buf "*git-diff*"))
      (with-temp-directory dir
         (awhen (get-buffer buf)
                (with-current-buffer it (erase-buffer)))
         (call-process-shell-command (concat "git diff " file) nil buf t))
      (switch-to-buffer buf)
      (diff-mode)
      (goto-char (point-min)))))

(defun my-git-blame-pr ()
  (interactive)
  (let ((file (buffer-file-name)))
    (unless (git-repo-p) (error "git 管理下ではありません"))
    (let ((dir (concat (find-file-upward ".git") "/../"))
          (buf "*git-blame-pr*"))
      (with-temp-directory dir
         (awhen (get-buffer buf)
                (with-current-buffer it (erase-buffer)))
         (call-process-shell-command (concat "git-blame-pr " file) nil buf t))
      (switch-to-buffer buf)
      (goto-char (point-min)))))

(defun my-git-checkout-this-file ()
  (interactive)
  (let ((file (buffer-file-name)))
    (unless (git-repo-p) (error "git 管理下にありません"))
    (let ((dir (concat (find-file-upward ".git") "/../")))
      (with-temp-directory dir
         (call-process-shell-command (concat "git checkout -- " file) nil nil t))
      (revert-buffer nil t)
      )))


(defun my-git-log-origin ()
  (interactive)
  (let ((file (buffer-file-name)))
    (unless (git-repo-p) (error "git 管理下にありません"))
    (let ((dir (concat (find-file-upward ".git") "/../"))
          (buf "*git fetch origin && git log origin*"))
      (with-temp-directory dir
         (awhen (get-buffer buf)
                (with-current-buffer it (erase-buffer)))
         (call-process-shell-command "git fetch origin && git log origin " nil buf t))
      (switch-to-buffer buf)
      (conf-mode)
      (goto-char (point-min)))))

(defun my-git-diff ()
  (interactive)
  (let ((file (buffer-file-name)))
    (unless (git-repo-p) (error "git 管理下にありません"))
    (let ((dir (concat (find-file-upward ".git") "/../"))
          (buf "*git diff*"))
      (with-temp-directory dir
         (awhen (get-buffer buf)
                (with-current-buffer it (erase-buffer)))
         (call-process-shell-command (concat "git diff ") nil buf t))
      (switch-to-buffer buf)
      (diff-mode)
      (goto-char (point-min)))))

(defun my-git-log-S-this-file ()
  (interactive)
  (let ((file (buffer-file-name))
        (word (read-from-minibuffer "search word:")))
    (unless (git-repo-p) (error "git 管理下にありません"))
    (let ((dir (concat (find-file-upward ".git") "/../"))
          (buf "*git log -S*"))
      (with-temp-directory dir
         (awhen (get-buffer buf)
                (with-current-buffer it (erase-buffer)))
         (call-process-shell-command (concat "git log -S'" word "' " file) nil buf t))
      (switch-to-buffer buf)
      ;; (diff-mode)
      (goto-char (point-min)))))

(defun my-git-log-S ()
  (interactive)
  (let ((word (read-from-minibuffer "search word:")))
    (unless (git-repo-p) (error "git 管理下にありません"))
    (let ((dir (concat (find-file-upward ".git") "/../"))
          (buf "*git log -S*"))
      (with-temp-directory dir
         (awhen (get-buffer buf)
                (with-current-buffer it (erase-buffer)))
         (call-process-shell-command (concat "git log -S'" word "'") nil buf t))
      (switch-to-buffer buf)
      (conf-mode)
      (vc-annotate-mode)
      (goto-char (point-min)))))

;; git log -S'ordered_market_apps' path/to/file

(defun my-git-show-this-word ()
  (interactive)
  (let ((word (or (thing-at-point 'word) "")))
    (unless (git-repo-p) (error "git 管理下にありません"))
    (let ((dir (concat (find-file-upward ".git") "/../"))
          (buf "*git show*"))
      (with-temp-directory dir
         (awhen (get-buffer buf)
                (with-current-buffer it (erase-buffer)))
         (call-process-shell-command (concat "git show " word) nil buf t))
      (switch-to-buffer buf)
      (diff-mode)
      (goto-char (point-min)))))

(defun my-git-show-pr-this-word ()
  (interactive)
  (let ((word (or (thing-at-point 'word) "")))
    (unless (git-repo-p) (error "git 管理下にありません"))
    (call-process-shell-command (concat "git openpr " word))))

(defalias 'gpr 'my-git-show-pr-this-word)

(defun my-git-cat-this-word ()
  (interactive)
  (let ((word (or (thing-at-point 'word) "")))
    (unless (git-repo-p) (error "git 管理下にありません"))
    (let ((dir (concat (find-file-upward ".git") "/../"))
          (buf "*git show*"))
      (with-temp-directory dir
         (awhen (get-buffer buf)
                (with-current-buffer it (erase-buffer)))
         (call-process-shell-command (concat "git show " word) nil buf t))
      (switch-to-buffer buf)
      (diff-mode)
      (goto-char (point-min)))))

;; (defun my-git-checkout-this-commit ()
;;   (interactive)
;;   (let ((word (or (thing-at-point 'word) "")))
;;     (unless (git-repo-p) (error "git 管理下にありません"))
;;     (let ((dir (concat (find-file-upward ".git") "/../"))
;;           (buf "*git show*"))
;;       (with-temp-directory dir
;;          (awhen (get-buffer buf)
;;                 (with-current-buffer it (erase-buffer)))
;;          (call-process-shell-command (concat "git checkout " word) nil buf t))
;;       (switch-to-buffer buf)
;;       (diff-mode)
;;       (goto-char (point-min)))))


(defalias 'glog 'git-log-p-this-file)
(defalias 'gdiff 'my-git-diff)
(defalias 'gdiff-this-file 'my-git-diff-this-file)
(defalias 'gco 'my-git-checkout-this-file)
;; (defalias 'gcc 'my-git-checkout-this-commit)

(defalias 'gr 'my-git-log-origin)

(defalias 'glogs 'my-git-log-S)
(defalias 'glogs-this-file 'my-git-log-S-this-file)
(defalias 'gshow 'my-git-show-this-word)
;; (defalias 'rt  'my-rake-spec)


;; http://handlename.hatenablog.jp/entry/2013/05/17/191259

(defun my:chomp (str)
  (replace-regexp-in-string "[\n\r]+$" "" str))

(defun my:git-project-p ()
  (string=
   (my:chomp
    (shell-command-to-string "git rev-parse --is-inside-work-tree"))
   "true"))

(defun my:tig-blame-current-file ()
  (interactive)
  (if (my:git-project-p)
        (progn
          (shell-command
           (format "tmux new-window 'cd %s; tig blame -- %s'"
                   (file-name-directory buffer-file-name)
                   (file-name-nondirectory buffer-file-name)))
          (shell-command (format "open -a iTerm")))))

(defun chomp (str)
  (replace-regexp-in-string "[\n\r]+$" "" str))

(global-set-key (kbd "C-c o b") 'my:tig-blame-current-file)


;; (defun git-project-p ()
;;   (string=
;;    (chomp
;;     (shell-command-to-string "git rev-parse --is-inside-work-tree"))
;;    "true"))

(defun my:git-project-p ()
  (string=
    (shell-command-to-string "git rev-parse --is-inside-work-tree")
   "true\n"))

(defun open-github-from-current ()
  (interactive)
  (cond ((and (my:git-project-p) (use-region-p))
         (shell-command
          (format "~/Dropbox/bin/open-github-from-file %s %d %d"
                  (file-name-nondirectory (buffer-file-name))
                  (line-number-at-pos (region-beginning))
                  (line-number-at-pos (region-end)))))
        ((git-project-p)
         (shell-command
          (format "~/Dropbox/bin/open-github-from-file %s %d"
                  (file-name-nondirectory (buffer-file-name))
                  (line-number-at-pos))))))
(defalias 'github-open-from-current 'open-github-from-current)
