;;http://d.hatena.ne.jp/rubikitch/20090211/1234349678

(defun anything-compile-source--candidates-file (source)
  (if (assoc-default 'candidates-file source)
      `((init acf-init
              ,@(let ((orig-init (assoc-default 'init source)))
                  (cond ((null orig-init) nil)
                        ((functionp orig-init) (list orig-init))
                        (t orig-init))))
        (candidates-in-buffer)
        ,@source)
    source))

(add-to-list 'anything-compile-source-functions 'anything-compile-source--candidates-file)

(defun acf-init ()
  (destructuring-bind (file &optional updating)
      (anything-mklist (anything-attr 'candidates-file))
    (with-current-buffer (anything-candidate-buffer (find-file-noselect file))
      (when updating
        (buffer-disable-undo)
        (font-lock-mode -1)
        (auto-revert-mode 1)))))

(defvar anything-c-source-home-directory
  '((name . "Home directory")
    ;; /log/home.filelist にホームディレクトリのファイル名が1行につきひとつ格納されている
    (candidates-file "/log/home.filelist" updating)
    (requires-pattern . 5)
    (candidate-number-limit . 20)
    (type . file)))

(defvar anything-c-source-find-library
  '((name . "Elisp libraries")
    ;; これは全Emacs Lispファイル
    (candidates-file "/log/elisp.filelist" updating)
    (requires-pattern . 4)
    (type . file)
    (major-mode emacs-lisp-mode)))

(provide 'anything-candidates-file-plug-in)
