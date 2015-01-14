(require 'anything-match-plugin)
(require 'cl)

(defvar amp-glob-rules
  '( ;; escape
    ("\\\\\\(.\\)" . (lambda () (match-string 1)))
    ;; "[a-z]"
    ("\\[[^\\]+\\]" . (lambda () (match-string 0)))
    ;; "{txt,c,h}"
    ("{\\([^}]+\\)}" . (lambda ()
                         (format
                          "\\(%s\\)"
                          (replace-regexp-in-string
                           "," "\\|" (match-string 1) nil t))))
    ("\\?" . ".")
    ("\\*\\*" . ".*")
    ("\\*" . "[^/\n]*")
    ("\\$" . "$"))
  "Rule alist of glob to regexp.")

(define-minor-mode amp-glob-mode
  "Toggle Anything match plug-in Glob Mode.
In `amp-glob-mode', pattern is considered to glob instead of regexp."
  :global t)

(defun amp-glob-to-regexp-1 (rules)
  (loop for (regexp . replacer) in rules
        if (looking-at regexp)
        return
        (save-excursion
          (save-match-data
            (cond
             ((functionp replacer) (funcall replacer))
             ((stringp replacer) replacer)
             (t (assert nil nil "replacer must be function or string")))))
        finally return (and (looking-at ".")
                            (regexp-quote (match-string 0)))))
  

(defun* amp-glob-to-regexp (pattern &optional (rules amp-glob-rules))
  (with-temp-buffer
    (insert pattern)
    (goto-char (point-min))
    (while (not (eobp))
      (let ((rep (amp-glob-to-regexp-1 rules)))
        (delete-region (match-beginning 0) (match-end 0))
        (insert rep)))
    (buffer-string)))

(defadvice amp-mp-make-regexps
  (after amp-glob (pattern) activate)
  "In `amp-glob-mode', use glob instead of regexp."
  (when amp-glob-mode
    (setq ad-return-value
          (mapcar 'amp-glob-to-regexp ad-return-value))))

(dont-compile
  (defmacro amp-glob-test:with (str &rest body)
    (declare (indent 1))
    `(with-temp-buffer
       (insert ,str)
       (goto-char (point-min))
       ,@body)))

(dont-compile
  (when (fboundp 'expectations)
    (expectations
      (desc "amp-glob-to-regexp-1")
      (expect "h"
        (amp-glob-test:with "hoge"
                            (amp-glob-to-regexp-1 nil)))
      (expect "\\."
        (amp-glob-test:with ".hoge"
                            (amp-glob-to-regexp-1 nil)))
      (expect "fu"
        (amp-glob-test:with "hoge"
                            (amp-glob-to-regexp-1 '(("ho" . "fu")))))
      (expect "[99]"
        (amp-glob-test:with "99hoge"
                            (amp-glob-to-regexp-1
                             '(("[0-9]+" . (lambda () (format "[%s]" (match-string 0))))))))
      (expect "9"
        (amp-glob-test:with "99hoge"
                            (amp-glob-to-regexp-1
                             '(("[a-z]+" . (lambda () (format "[%s]" (match-string 0))))))))
      (expect (error)
        (amp-glob-test:with "hoge"
                            (amp-glob-to-regexp-1
                             '(("[a-z]+" . 1)))))
      (desc "amp-glob-to-rep")
      (expect "hoge"
        (amp-glob-to-regexp "hoge" nil))
      (expect "hoge.*fuga"
        (amp-glob-to-regexp
         "hoge*fuga"
         '(("\\*" . ".*"))))
      (expect "[^/]*hoge.*fuga"
        (amp-glob-to-regexp
         "*hoge**fuga"
         '(("\\*\\*" . ".*")
           ("\\*" . "[^/]*")))))))

(provide 'amp-glob)