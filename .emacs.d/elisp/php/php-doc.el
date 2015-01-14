;;; php-doc.el --- Insert PHPDoc style comment easily

;; 1. insert function document by pressing Ctrl + c, i
;; 2. insert @tag easily by pressing @ in comment line
;;
;; (custom-set-variables
;;  '(php-doc-mail-address "your email address")
;;  '(php-doc-author (format "your name <%s>" php-doc-mail-address))
;;  '(php-doc-url "your url"))
;; (add-hook 'js2-mode-hook
;;           '(lambda ()
;;              (local-set-key "\C-ci" 'php-doc-insert-function-doc)
;;              (local-set-key "@" 'php-doc-insert-tag)
;;              ))
;;
;; If you want to see the tag description, just input the next command
;;   M-x php-doc-describe-tag


;; Variables
(defvar php-doc-mail-address ""
  "Author's E-mail address.")
(defvar php-doc-author ""
  "Author of the source code.")
(defvar php-doc-license ""
  "License of the source code.")
(defvar php-doc-url ""
  "Author's Home page URL.")

(defvar php-doc-all-tag-alist
  '(("augments" . "Indicate this class uses another class as its \"base.\"")
    ("author" . "Indicate the author of the code being documented.")
    ("argument" . "Deprecated synonym for @param.")
    ("throws" . "Describe the exception that a function might throw.")
    ("type" . "Describe the expected type of a variable's value or the value returned by a function.")
    ("version" . "Indicate the release version of this code."))
  "PHPDoc tag list
This list contains tag name and its description")

(defvar php-doc-file-doc-lines
  '(php-doc-top-line
    " * @fileOverview\n"
    " * @name %F\n"
    " * @author %a\n"
    " * @license %l\n"
    php-doc-bottom-line)
  "PHPDoc style file document format.
When the `php-doc-insert-file-doc' is called,
each lines in a list will be formatted by `php-doc-format-string'
and inserted to the top of current buffer.")

(defvar php-doc-format-string-alist
  '(("%F" . (buffer-name))                  ;file name
    ("%P" . (buffer-file-name))             ;file path
    ("%a" . php-doc-author)                 ;author name
    ("%l" . php-doc-license)
    ("%d" . (current-time-string))          ;current date
    ("%p" . php-doc-current-parameter-name) ;parameter name
    ("%f" . php-doc-current-function-name)) ;function name
  "Format and value pair
Format will be replaced its value in `php-doc-format-string'")

(defvar php-doc-top-line "/**\n"
  "top line of the php-doc style comment.")

(defvar php-doc-description-line" * \n"
  "description line.")

(defvar php-doc-bottom-line " */\n"
  "bottom line.")

;; formats for function-doc
(defvar php-doc-parameter-line " * @param %p\n"
  "parameter line.
 %p will be replaced with the parameter name.")

(defvar php-doc-return-line " * @returns \n"
  "return line.")

(defvar php-doc-throw-line " * @throws \n"
  "bottom line.")

;; ========== Regular expresisons ==========

(defvar php-doc-return-regexp "return "
  "regular expression of return
When the function body contains this pattern,
php-doc-return-line will be inserted")

(defvar php-doc-throw-regexp "throw"
  "regular expression of throw
When the function body contains this pattern,
php-doc-throw-line will be inserted")

(defvar php-doc-document-regexp "^\[  \]*\\*[^//]"
  "regular expression of PHPDoc comment
When the string ahead of current point matches this pattarn,
php-doc regards current state as in PHPDoc style comment")

;;; Main codes:

;; from smart-compile.el
(defun php-doc-format-string (arg)
  "Format given string and return its result

%F => file name
%P => file path
%a => author name
%d => current date
%p => parameter name
%f => function name"
  (let ((rlist php-doc-format-string-alist)
        (case-fold-search nil))
    (while rlist
      (while (string-match (caar rlist) arg)
        (setq arg
              (replace-match
               (eval (cdar rlist)) t nil arg)))
      (setq rlist (cdr rlist))))
  arg)

(defun php-doc-tail (list)
  "Return the last cons cell of the list"
  (if (cdr list)
      (php-doc-tail (cdr list))
    (car list)))

(defun php-doc-pick-symbol-name (str)
  "Pick up symbol-name from str"
  (php-doc-tail (delete "" (split-string str "[^a-zA-Z0-9_$]"))))

(defun php-doc-block-has-regexp (begin end regexp)
  "Return t when regexp matched the current buffer string between begin-end"
  (save-excursion
    (goto-char begin)
    (and t
         (re-search-forward regexp end t 1))))

(defun php-doc-insert-file-doc ()
  "Insert specified-style comment top of the file"
  (interactive)
  (goto-char (point-min))
  (dolist (line-format php-doc-file-doc-lines)
    (insert (php-doc-format-string (eval line-format)))))

(defun php-doc-insert-function-doc ()
  "Insert PHPDoc style comment of the function
The comment style can be custimized via `customize-group php-doc'"
  (interactive)
  ;; prevent odd behaviour of beginning-of-defun
  ;; when user call this command in the certain comment,
  ;; the cursor skip the current function and go to the
  ;; outside block
  (end-of-line)
  (while (or (php-doc-in-comment-p (point))
             (php-doc-blank-line-p (point)))
    (forward-line -1)
    (end-of-line))
  (end-of-line)
  (beginning-of-defun)
  ;; Parse function info
  (let ((params '())
  (document-list '())
  (head-of-func (point))
  from
  to
  begin
  end)
    (save-excursion
      (setq from
      (search-forward "(" nil t))
      (setq to
      (1- (search-forward ")" nil t)))
      ;; Now we got the string between ()
      (when (> to from)
  (dolist (param-block
     (split-string (buffer-substring-no-properties from to) ","))
    (add-to-list 'params (php-doc-pick-symbol-name param-block) t)))
      ;; begin-end contains whole function body
      (setq begin (search-forward "{" nil t))
      (setq end (scan-lists (1- begin) 1 0)))
    ;; put document string into document-list
    (add-to-list 'document-list
     (php-doc-format-string php-doc-top-line) t)
    (add-to-list 'document-list
     (php-doc-format-string php-doc-description-line) t)
    ;; params
    (dolist (param params)
      (setq php-doc-current-parameter-name param)
      (add-to-list 'document-list
       (php-doc-format-string php-doc-parameter-line) t))
    ;; return / throw
    (when (php-doc-block-has-regexp begin end
           php-doc-return-regexp)
      (add-to-list 'document-list
       (php-doc-format-string php-doc-return-line) t))
    (when (php-doc-block-has-regexp begin end
           php-doc-throw-regexp)
      (add-to-list 'document-list
       (php-doc-format-string php-doc-throw-line) t))
    ;; end
    (add-to-list 'document-list
     (php-doc-format-string php-doc-bottom-line) t)
    ;; Insert the document
    (beginning-of-line)
    (setq from (point))                 ; for indentation
    (dolist (document document-list)
      (insert document))
    ;; Indent
    (indent-region from (point))))

;; http://www.emacswiki.org/emacs/UseIswitchBuffer
(defun php-doc-icompleting-read (prompt collection)
  (let ((iswitchb-make-buflist-hook
   (lambda ()
     (setq iswitchb-temp-buflist collection))))
    (iswitchb-read-buffer prompt nil nil)))

;;ToDo 使える
(defun php-doc-make-tag-list ()
  (let ((taglist '()))
    (dolist (tagpair php-doc-all-tag-alist)
      (add-to-list 'taglist (car tagpair)))
    (reverse taglist)))

(defun php-doc-blank-line-p (p)
  "Return t when the line at the current point is blank line"
  (save-excursion (eql (progn (beginning-of-line) (point))
           (progn (end-of-line) (point)))))

(defun php-doc-in-comment-p (p)
  "Return t when the point p is in the comment"
  (save-excursion
    (let (begin end)
      (beginning-of-line)
      (setq begin (point))
      (end-of-line)
      (setq end (point))
      (or (php-doc-block-has-regexp begin end "//")
          (php-doc-block-has-regexp begin end "/\\*")))))

(defun php-doc-in-document-p (p)
  "Return t when the point p is in PHPDoc document"
  ;; Method 1 :: just search for the PHPDoc
  (save-excursion
    (goto-char p)
    (and (search-backward "/**" nil t)
   (not (search-forward "*/" p t)))))

(defun php-doc-insert-tag ()
  "Insert a PHPDoc tag interactively."
  (interactive)
  (insert "@")
  (when (php-doc-in-document-p (point))
    (let (
    (tag (completing-read "Tag: " (php-doc-make-tag-list)
        nil nil nil nil nil)))
      (unless (string-equal tag "")
  (insert tag " ")))))

(defun php-doc-describe-tag ()
  "Describe the PHPDoc tag"
  (interactive)
  (let (
  (tag (completing-read "Tag: " (php-doc-make-tag-list)
            nil t (word-at-point) nil nil))
  (temp-buffer-show-hook '(lambda ()
          (fill-region 0 (buffer-size))
          (fit-window-to-buffer))))
    (unless (string-equal tag "")
      (with-output-to-temp-buffer "PHPDocTagDescription"
  (princ (format "@%s\n\n%s"
           tag
           (cdr (assoc tag php-doc-all-tag-alist))))))))

(defun php-doc-describe-tag-echo-erea ()
  "Describe the JsDoc tag"
  (interactive)
  (let ((tag (completing-read "Tag: " (php-doc-make-tag-list) nil t (word-at-point) nil nil)))
    (unless (string-equal tag "")
        (message "@%s\n\n%s" tag (cdr (assoc tag php-doc-all-tag-alist))))))

(provide 'php-doc)
