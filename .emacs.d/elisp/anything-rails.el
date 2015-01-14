;;; anything-rails.el

;;; Commentary:

(require 'cl)
(require 'rx)
(require 'etags)


(require 'anything)
(require 'anything-match-plugin)
(require 'anything-project)
(require 'anything-grep)


(defconst ra:MODULES-DIR-NAME "modules")

;; (defconst ra:TEMPLATES-DIR-NAME "templates")
;; (defconst ra:APP-MODULE-ACTION-DIR-NAME "actions")

(defconst ra:APP-CONTROLLER-DIR-NAME "controllers")
(defconst ra:VIEW-DIR-NAME "views")

(defconst ra:VALIDATORS-DIR-NAME "validate")
(defconst ra:ACTIONS-CLASS-PHP "actions.class.php")
(defconst ra:ACTIONS-FILE-RULE "Action.class.php")
(defconst ra:TEST-BUFFER "*ra:test*")

;; コントローラモード、ビューモードの決定に使う
(defvar ra:mode-directory-rules
  `(
    (action ,(concat "app/" ra:APP-CONTROLLER-DIR-NAME))
    (template ,(concat "app/" ra:VIEW-DIR-NAME))
    ))



(defvar ra:primary-switch-fn 'ra-cmd:all-project-files
  "minor mode overide this")
(make-variable-buffer-local 'ra:primary-switch-fn)

(defvar ra:after-anything-project-action-hook nil
  "list of functions called after anything project(anything-rails-mode's `find-file').
Note,this variable MUST BE let bounded in command.
e.x,
 (let ((ra:after-anything-project-action-hook
        (list
         (lambda () (re-search-forward \"function_name\" nil t)))))
   (ra:anything-project candidates))")

(defcustom ra:anything-project-exclude-regexps nil
  "list of regexp or just regexp")

(defvar ra:previous-log-file nil)

(defvar ra:number-of-lines-shown-when-opening-log-file 200)

(defvar ra:candidate-number-limit 1000000
  "value of candidate-number-limit. Candidate-number-limit overrides
`anything-candidate-number-limit' only for this source.")

(defvar ra:persistent-action-buffer "*anything-rails*")

(defmacro* ra:with-root (&body body)
  (let ((root (gensym)))
    `(let ((,root (ra:get-project-root)))
       (when ,root
         (flet ((ra:get-project-root () ,root))
           ,@body)))))

(eval-when-compile
  (def-edebug-spec ra:with-root (&optional body)))

(defmacro* ra:with-root-default-directory (&body body)
  `(ra:with-root
    (let ((default-directory (ra:get-project-root)))
      (progn ,@body))))

(eval-when-compile
  (def-edebug-spec ra:with-root-default-directory (&optional body)))

(defun ra:project-absolute-path (file-name)
  (ra:with-root
   (cond
    ((file-name-absolute-p file-name)
     file-name)
    (t
     (let ((root-dir (ra:get-project-root)))
       (if root-dir
           (ra:catdir root-dir file-name)
         ""))))))

(defun ra:buffer-type ()
  (loop for (type re-or-fn) in ra:mode-directory-rules
        when (if (stringp re-or-fn)
                 (string-match re-or-fn (ra:current-directory))
               (funcall re-or-fn))
        do (return type)))

(defun ra:current-directory ()
  (file-name-directory
   (expand-file-name
    (or (buffer-file-name)
        default-directory))))

(defun ra:this-file-name ()
  (unless buffer-file-name
    (error "this buffer maybe not saved!!"))
  (file-name-nondirectory buffer-file-truename))

;;; LIB
(defconst ra:find-upper-directory-limit 10)

(defvar ra:root-detector-fn
  (lambda (current-directory)
    (assert (file-directory-p current-directory))
    (let ((files (directory-files current-directory)))
      (let ((rails-files '("app" "script" "public")))
        (every
         (lambda (file)
           (find file files :test 'string=))
         rails-files)))))

(defun ra:get-project-root ()
  (let ((cur-dir (ra:current-directory)))
    (ra:find-upper-directiory ra:root-detector-fn)))

(defun ra:find-upper-directiory (cond-fn)
  (assert (functionp cond-fn))
  (let ((cur-dir (ra:current-directory)))
    (loop with count = 0
        until (funcall cond-fn cur-dir)
        if (= count ra:find-upper-directory-limit)
        do (return nil)
        else
        do (progn (incf count)
                  (setq cur-dir (expand-file-name (concat cur-dir "../"))))
        finally return cur-dir)))

(defun ra:take-function-name ()
  (ignore-errors
    (save-excursion
      (forward-line 1)
      (let ((fname-re (rx bol
                          (* space)
                          "def"
                          (+ space)
                          (group
                           (+
                            (or (syntax word) (syntax symbol))))
                          (+ space)
                          )))
        (when (re-search-backward fname-re nil t)
          (match-string-no-properties 1))))))

;; (ra:take-off-execute "executeHoge")
;; "Hoge"
(defun ra:take-off-execute (s)
  (when (stringp s)
    (replace-regexp-in-string (rx bol "execute") "" s)))

;; (ra:take-off-action "hogeAction")
;; "hoge"
;; (defun ra:take-off-action (s)
;;   (when (stringp s)
;;     (let ((case-fold-search nil))
;;       (replace-regexp-in-string (rx "Action" eol) "" s))))

(defun ra:take-off-controller (s)
  (when (stringp s)
    (let ((case-fold-search nil))
      (replace-regexp-in-string (rx "Controller" eol) "" s))))

;; (ra:take-off-tail-capital "hogeActionHoge")
;; "hogeAction"
(defun ra:take-off-tail-capital (s)
  (let ((case-fold-search nil))
  (when (stringp s)
    (when (string-match (rx bol (group (+ print)) (regexp "\\(?:[A-Z][a-z]+\\)") eol) s)
      (match-string 1 s)))))

(defun ra:catdir (s1 s2)
  (let ((s1 (replace-regexp-in-string (rx "/" eol) "" s1))
        (s2 (replace-regexp-in-string (rx bol "/") "" s2)))
    (concat s1 "/" s2)))

(defvar ra:project-cache nil)

(defun* ra:project-files (&optional clear-cache (include-regexps '(".*")) (exclude-regexps ra:anything-project-exclude-regexps))
  (setq clear-cache (or clear-cache current-prefix-arg))
  (ra:with-root
   (let ((root-dir (ra:get-project-root))
         (ap:--cache ra:project-cache)) ;; use own cache
     (unless root-dir
       (error "this buffer is not rails project file"))
     (let ((ap:projects nil))
       (ap:add-project
        :name 'anything-rails
        :look-for ra:root-detector-fn
        :grep-extensions '("\\.rb"))
       (when clear-cache
         (setq ap:--cache
               (delete-if (lambda (ls) (equal root-dir ls))
                          ap:--cache
                          :key 'car)))
       (lexical-let ((root-dir root-dir))
         (setq ap:root-directory root-dir)
         (ap:cache-get-or-set
          root-dir
          (lambda ()
            (message "getting project files...")
            (let ((include-regexp include-regexps)
                  (exclude-regexp exclude-regexps))
              (let* ((files (ap:directory-files-recursively
                             include-regexp
                             root-dir
                             'identity
                             exclude-regexp)))
                files)))))))))

(defun ra:abs->relative (los)
  (assert (listp los))
  (mapcar 'file-relative-name los))

(defun ra:get-module-dir-or-root ()
  (let ((cur-dir (ra:current-directory)))
    (cond
     ((string-match (rx (group bol (* not-newline) "apps" (+ not-newline) "modules" (? "/")))
                    cur-dir)
      (match-string 1 cur-dir))
     (t
      (ra:get-project-root)))))

(defun ra:get-templates-directory ()
  (let ((templates-finder
         (lambda (cur-dir)
           (let ((template-dir (ra:catdir cur-dir (concat "/" ra:VIEW-DIR-NAME "/"))))
             (file-directory-p template-dir)))))
    (let ((ret (ra:find-upper-directiory templates-finder)))
      (when ret
        (list (ra:catdir ret ra:VIEW-DIR-NAME))))))

(defun ra:get-templates-file-by-action-name (action-name)
  "return list of templates or nil
Note, dont return just STRING even if find one template file."
  (let ((files (ra:get-templates-directory)))
    files))

(defcustom ra:quickly-find-file-when-candidates-length-is-1 t
  "if this variable is set to non-nil and candidates is just one,
find file quickly (dont use anything interface)")

(defun ra:anything-project-persistent-action (c)
  (let ((b (get-buffer-create ra:persistent-action-buffer)))
      (with-current-buffer b
        (erase-buffer)
        (insert-file-contents c)
        (goto-char (point-min)))
      (pop-to-buffer b))
  (ignore-errors (run-hooks 'ra:after-anything-project-action-hook)))

(defun ra:anything-project (--candidates &optional buffer-name)
  (cond
   ((and ra:quickly-find-file-when-candidates-length-is-1
         (= (length --candidates) 1))
    (ra:anything-project-find-file (first --candidates)))
   (t
    (let ((source
           `((name . ,(format "Project files. root: %s" (or (ra:get-project-root) "")))
             (init . (lambda ()
                       (with-current-buffer (anything-candidate-buffer 'local)
                         (insert (mapconcat 'identity --candidates "\n")))))
             (candidates-in-buffer)
             (candidate-number-limit . ,ra:candidate-number-limit)
             (action . (("Find file" . ra:anything-project-find-file)
                        ("Find file(s)" .
                          (lambda (candidate)
                            (dolist (i (anything-marked-candidates))
                              (ra:anything-project-find-file i))))))
             (persistent-action . (lambda (candidate)
                                    (ra:anything-project-persistent-action candidate)))
             (cleanup . (lambda ()
                          (if (get-buffer ra:persistent-action-buffer)
                              (kill-buffer ra:persistent-action-buffer)))))))
      (anything-other-buffer (list source) buffer-name)))))

(defun ra:anything-project-find-file (c)
  (find-file c)
  (ignore-errors (run-hooks 'ra:after-anything-project-action-hook)))

(defsubst ra:any-match (regexp-or-regexps file-name)
  (when regexp-or-regexps
    (let ((regexps (if (listp regexp-or-regexps) regexp-or-regexps (list regexp-or-regexps))))
      (some
       (lambda (re)
         (string-match re file-name))
       regexps))))

(defun* ra:directory-files-recursively (regexp &optional directory type (dir-filter-regexp nil) (exclude-regexps ra:anything-project-exclude-regexps))
  (let* ((directory (or directory default-directory))
         (predfunc (case type
                     (dir 'file-directory-p)
                     (file 'file-regular-p)
                     (otherwise 'identity)))
         (files (directory-files directory t "^[^.]" t))
         (files (mapcar 'ap:follow-symlink files))
         (files (remove-if (lambda (s) (string-match (rx bol (repeat 1 2 ".") eol) s)) files)))
    (loop for file in files
          when (and (funcall predfunc file)
                    (ap:any-match regexp (file-name-nondirectory file))
                    (not (ap:any-match exclude-regexps file)))
          collect file into ret
          when (and (file-directory-p file)
                    (not (ap:any-match dir-filter-regexp file)))
          nconc (ap:directory-files-recursively regexp file type dir-filter-regexp) into ret
          finally return  ret)))



;; (defun ra:get-module-directory ()
;;   "return string or nil"
;;   (let ((cur-dir (ra:current-directory)))
;;      (when (string-match (rx (group bol (* not-newline) "apps" (+ not-newline) "modules/" (+ (not (any "/"))) "/"))
;;                          cur-dir)
;;       (match-string 1 cur-dir))))



;; moduel が rails にない。
(defun ra:relative-files ()
  (let ((module-directory (ra:get-module-directory)))
    (cond
     ((and module-directory (file-directory-p module-directory))
      (ra:directory-files-recursively ".*" module-directory 'file-regular-p nil ra:anything-project-exclude-regexps))
     (t
      (ra:project-files)))))

(defun ra:matched-files (regexp)
    (let ((files (ra:project-files))
          (re (rx-to-string `(and  "/" ,regexp "/"))))
    (remove-if-not (lambda (s) (string-match re s))
                   files)))

(defun ra:get-log-directory ()
  (let ((root-dir (ra:get-project-root)))
  (when root-dir
    (let ((log-dir (ra:catdir root-dir "log/")))
      (when (and log-dir (file-accessible-directory-p log-dir))
        log-dir)))))

(defsubst ra:trim (s)
  "strip space and newline"
  (replace-regexp-in-string
   "[ \t\n]*$" "" (replace-regexp-in-string "^[ \t\n]*" "" s)))

(defun ra:command-infomation ()
  (let ((re (rx bol
                (group (+ not-newline))
                (group "ra-cmd:"
                       (+ not-newline)
                       eol))))
    (with-temp-buffer
      (goto-char (point-min))
      (insert (substitute-command-keys (format "\\{%s}" "ra:minor-mode-map")))
      (loop initially (goto-char (point-min))
            while (re-search-forward re nil t)
            collect (let* ((key (ra:trim (match-string 1)))
                           (command (ra:trim (match-string 2)))
                           (display key)
                           (real command))
                      `(,display . ,real))))))

(defun ra:remove-if-not-match (re los)
  (remove-if-not (lambda (s) (string-match re s)) los))


(defun ra:get-application-names ()
  (let ((app-name-re (rx "apps/" (group (+ (not (any "/")))) "/")))
    (loop for path in (ra:project-files)
          when (string-match app-name-re path)
          collect (match-string 1 path) into ret
          finally return (delete-dups ret))))


(defvar anything-c-source-anything-rails-el-command
  '((name . "anything-rails-el-comand")
    (candidates
     . (ra-cmd:all-project-files
        ra-cmd:relative-files
        ra-cmd:model-files
        ra-cmd:action-files
        ra-cmd:validator-files
        ra-cmd:template-files
        ra-cmd:helper-files
        ra-cmd:js-files
        ra-cmd:css-files
        ra-cmd:test-files
        ra-cmd:fixture-files
        ra-cmd:open-log-file
        ra-cmd:create-or-update-tags
        ra-cmd:update-caches
        ra-script:kill-process
        ra-script:output-mode))
    (type . command)))

(defun ra-cmd:anything-anything-rails-el-command ()
  (interactive)
  (anything (list anything-c-source-anything-rails-el-command) nil nil nil))

;;;; Commands
;; Prefix: ra-cmd:
(defun ra-cmd:all-project-files ()
  (interactive)
  (ra:anything-project (ra:project-files) "*ra-all-project-files*"))

(defun ra-cmd:primary-switch ()
  (interactive)
  (funcall ra:primary-switch-fn))

(defun ra-cmd:relative-files ()
  (interactive)
  (ra:anything-project (ra:relative-files)))

(defun ra-cmd:controller-files ()
  (interactive)
  (ra:anything-project (ra:matched-files "controllers") "*ra-controller-files*"))

(defun ra-cmd:model-files ()
  (interactive)
  (ra:anything-project (ra:matched-files "models") "*ra-model-files*"))

(defun ra-cmd:view-files ()
  (interactive)
  (ra:anything-project (ra:matched-files "views") "*ra-view-files*"))

;; (defun ra-cmd:validator-files ()
;;   (interactive)
;;   (ra:anything-project (ra:matched-files "validate") "*ra-validator-files*"))


;; (defun ra-cmd:helper-files ()
;;   (interactive)
;;   (ra:anything-project (ra:matched-files "helper") "*ra-helper-files*"))

;; (defun ra-cmd:js-files ()
;;   (interactive)
;;   (ra:anything-project (ra:matched-files "js") "*ra-js-files*"))

;; (defun ra-cmd:css-files ()
;;   (interactive)
;;   (ra:anything-project (ra:matched-files "css") "*ra-css-files*"))

;; (defun ra-cmd:test-files ()
;;   (interactive)
;;   (ra:anything-project (ra:matched-files "test") "*ra-test-files*"))

;; (defun ra-cmd:fixture-files ()
;;   (interactive)
;;   (ra:anything-project (ra:matched-files "fixtures") "*ra-fixture-files*"))

;; done!
(defun ra-cmd:open-log-file (log-file)
  (interactive
   (list
    (expand-file-name
    (read-file-name (format "Select log[default: %s]: " ra:previous-log-file)
                    (ra:get-log-directory)
                    ra:previous-log-file
                    t
                    ))))
  (find-file log-file)
  (goto-char (point-max))
  (auto-revert-tail-mode t))










(defun ra-cmd:update-caches ()
  (interactive)
  (setq ra:project-cache nil)
  (setq ra:tags-cache nil)
  (ra-cmd:create-or-update-tags))



(defun ra-cmd:all-project-files-resume ()
  (interactive)
  (anything-aif (get-buffer "*ra-all-project-files*")
    (anything-resume it)
    (ra-cmd:all-project-files)))

(defun ra-cmd:model-files-resume ()
  (interactive)
  (anything-aif (get-buffer "*ra-model-files*")
    (anything-resume it)
    (ra-cmd:model-files)))

(defun ra-cmd:action-files-resume ()
  (interactive)
  (anything-aif (get-buffer "*ra-action-files*")
    (anything-resume it)
    (ra-cmd:action-files)))

(defun ra-cmd:template-files-resume ()
  (interactive)
  (anything-aif (get-buffer "*ra-template-files*")
    (anything-resume it)
    (ra-cmd:template-files)))

(defun ra-cmd:helper-files-resume ()
  (interactive)
  (anything-aif (get-buffer "*ra-helper-files*")
    (anything-resume it)
    (ra-cmd:helper-files)))

(defun ra-cmd:js-files-resume ()
  (interactive)
  (anything-aif (get-buffer "*ra-js-files*")
    (anything-resume it)
    (ra-cmd:js-files)))

(defun ra-cmd:css-files-resume ()
  (interactive)
  (anything-aif (get-buffer "*ra-css-files*")
    (anything-resume it)
    (ra-cmd:css-files)))

(defun ra-cmd:test-files-resume ()
  (interactive)
  (anything-aif (get-buffer "*ra-test-files*")
    (anything-resume it)
    (ra-cmd:test-files)))

(defun ra-cmd:fixture-files-resume ()
  (interactive)
  (anything-aif (get-buffer "*ra-fixture-files*")
    (anything-resume it)
    (ra-cmd:fixture-files)))

;;;; Minor Mode

(defmacro ra:key-with-prefix (key-kbd-sym)
  (let ((key-str (symbol-value key-kbd-sym)))
    `(kbd ,(concat ra:minor-mode-prefix-key " " key-str))))

(defvar ra:minor-mode-map
  (make-sparse-keymap))

(define-minor-mode anything-rails-minor-mode
  "anything-rails minor mode"
  nil
  " anything-rails"
  ra:minor-mode-map)

(defun anything-rails-minor-mode-maybe ()
  (let ((root-dir (ra:get-project-root)))
    (if root-dir
        (anything-rails-minor-mode 1)
      (anything-rails-minor-mode 0))
    ;; specify minor mode on
    (when root-dir
      (let ((minor-mode-name (ra:get-specify-minor-mode-string)))
        (when minor-mode-name
          (funcall (intern minor-mode-name) t))))))

(defun ra:get-specify-minor-mode-string ()
  (let ((type (ra:buffer-type)))
    (when type
      (format "anything-rails-%s-minor-mode" type))))

(defcustom ra:minor-mode-prefix-key "C-c"
  "Key prefix for anything-rails minor mode."
  :group 'anything-rails)

(defun ra:define-key (key-kbd command)
  (assert (commandp command))
  (assert (stringp key-kbd))
  (define-key ra:minor-mode-map (ra:key-with-prefix key-kbd) command))


;;;; Action Minor Mode
;; Prefix: ra-action:
(defvar ra:action-minor-mode-map
  (make-sparse-keymap))

(define-minor-mode anything-rails-action-minor-mode
  "Anything-Rails Action Minor Mode"
  nil
  " RailsAction"
  ra:action-minor-mode-map
  ;; body
  (setq ra:primary-switch-fn 'ra-action:switch-to-template)
  )

;;todo
(defun ra-action:switch-to-template ()
  (interactive)
  (let ((template (ra-action:get-templates)))
    (when template
      (find-file template))))

;; (defun ra-action:switch-to-template ()
;;   (interactive)
;;   (let ((templates (ra-action:get-templates)))
;;     (cond
;;      (templates
;;       (ra:anything-project templates))
;;      (t
;;       (call-interactively 'ra-cmd:all-project-files)))))

;;そのアクションのクラス名を返す  CustomersControllerなど
(defun ra:take-class-name ()
  (save-excursion
    (goto-char (point-min))
    (let ((class-name-re (rx bol
                          (* space)
                          "class"
                          (+ space)
                          (group
                           (+
                            (or (syntax word) (syntax symbol))))
                          (or space eol))))
        (when (re-search-forward class-name-re nil t)
          (match-string-no-properties 1)))))


;;my
(defun ra:take-action-name ()
  (save-excursion
    (let (action)
      (goto-char (line-end-position))
      (if (search-backward-regexp "^[ ]*def \\([a-z0-9_]+\\)" nil t)
          (setq action (match-string-no-properties 1)))
      action)))

;;my
(defun ra:take-controller-name ()
  (save-excursion
    (let (controller)
      (goto-char (line-end-position))
      (if (search-backward-regexp "^[ ]*class \\([a-zA-Z0-9_:]+\\)[ ]+<" nil t)
          (setq controller (match-string-no-properties 1)))
      controller)))

(defun ra-action:get-templates ()
  (let ((action-name (ra:take-action-name))
        (controller-name (ra:take-off-controller (ra:take-controller-name))))
    (ra-action:get-templates-by-controller-name-and-action-name controller-name action-name)))

;;todo not complete
(defun ra-action:get-templates-by-controller-name-and-action-name (controller-name action-name)
    ;; (ra:get-templates-directory) が一つと仮定している。
    ;; (ra:get-templates-directory) は ("/opt/current-royal/app/views") を返す
    (concat (car (ra:get-templates-directory)) "/" (downcase controller-name) "/" action-name ".html.haml"))
    ;; (loop for dir in (ra:get-templates-directory)
    ;;       nconc (ra:directory-files-recursively
    ;;              (rx-to-string `(and ,action-name  ".html.haml"))
    ;;              dir))


















;;;; Template Minor Mode
;; Prefix: ra-template:
(defvar ra:template-minor-mode-map
  (make-sparse-keymap))

(define-minor-mode anything-rails-template-minor-mode
  "Anything-Rails Template Minor Mode"
  nil
  " sfTemplate"
  ra:template-minor-mode-map
  ;; body
  (setq ra:primary-switch-fn 'ra-template:switch-to-action)
  )

"03"
(defun ra-take-parent-directory-name (s)
  (file-name-nondirectory (directory-file-name (file-name-directory s))))


(defun ra-template:switch-to-action ()
  (interactive)
  (lexical-let* (
                 (file-name (concat (ra-take-parent-directory-name (buffer-file-name)) "_controller.rb"))
                 (action-name (file-name-sans-extension (file-name-sans-extension (ra:this-file-name))))
                 (file-full-path (concat (ra:get-project-root) "/app/controllers/" file-name))
                 (execute-re (rx-to-string
                                  `(and "def"
                                        (+ space)
                                        ,action-name
                                        )))
                 (class-re (rx-to-string `(and "class" (+ space) ,action-name "Controller"))))
          (find-file file-full-path)
          (goto-char (point-min))
          (or (re-search-forward execute-re nil t)
                      (re-search-forward class-re nil t))
          ))

        ;; (let ((ra:after-anything-project-action-hook
        ;;        (list
        ;;         (lambda ()
        ;;           (goto-char (point-min))
        ;;           (or (re-search-forward execute-re nil t)
        ;;               (re-search-forward class-re nil t))))))
        ;;   (ra:anything-project actions))))))

(defun ra-template:get-specify-actions (action-name)
  "return list of string(file name)"
  (ra-template:get-specify-actions-by-action-name action-name))

;; module が rails にない
;; voteSuccess.php -> user/actions/actions.class.php :: executeVote
;; or
;; voteSuccess.php -> user/actions/actions/voteAction.class.php
(defun ra-template:get-specify-actions-by-action-name (action-name)
  (let* ((module-directory (ra:get-module-directory))
         (actions-directory (ra:catdir module-directory "actions")))
    (assert (and actions-directory
                 (file-directory-p actions-directory)))
    (append (ra-template:get-specify-actions-actions-class action-name actions-directory)
            (ra-template:get-specify-actions-saparate-file action-name actions-directory)
            )))

(defun ra-template:get-specify-actions-actions-class (action-name actions-directory)
  "return list"
  (let ((file-path (ra:catdir actions-directory ra:ACTIONS-CLASS-PHP)))
    (when (and file-path (file-exists-p file-path) (file-readable-p file-path))
      (list file-path))))

(defun ra-template:get-specify-actions-saparate-file (action-name actions-directory)
  "return list"
  (let* ((file-name (concat action-name ra:ACTIONS-FILE-RULE))
         (file-path (ra:catdir actions-directory file-name)))
    (when (and file-path (file-exists-p file-path) (file-readable-p file-path))
      (list file-path))))








;;;; Script
;; Prefix: ra-script:

(defvar ra-script:buffer-name "*Anything-Rails Output*")
(defvar ra-script:history nil)

(defcustom ra-script:anything-rails-command nil
  "Anything-Rails command(full path).
IF this variable is nil, \"anything-rails\" command is searched in PATH")

(defun ra-script:anything-rails-command ()
  (cond
   ((and ra-script:anything-rails-command
         (file-executable-p ra-script:anything-rails-command))
    ra-script:anything-rails-command)
   (t
    (let ((command (executable-find "anything-rails")))
      (or command
          (error "anything-rails command is not in PATH"))))))

(defcustom ra-script:coding-system nil
  "this variable is bound to `coding-system-for-read' and `coding-system-for-write'
in `ra-script:start-process'.
IF nil, do nothing")

(defun ra-script:process-running-p ()
  (get-buffer-process ra-script:buffer-name))

(defun ra-script:kill-process ()
  (interactive)
  (let ((proc (ra-script:process-running-p)))
    (when proc
      (prog1 t
        (delete-process proc)
        (message "deleted process")))))

(defun ra-script:process-sentinel (proc message)
  (when (memq (process-status proc) '(exit signal))
    (let* ((status-msg (if (zerop (process-exit-status proc)) "successful" "failure"))
           (msg (format "%s was stopped (%s)."
                       (process-name proc)
                       status-msg)))
      (message (replace-regexp-in-string "\n" "" msg)))))

(defun ra-script:start-process (name buffer-name program &rest args)
  (let ((coding-system-for-read ra-script:coding-system)
        (coding-system-for-write ra-script:coding-system))
    (apply 'start-process-shell-command
           name
           buffer-name
           program
           args)))

(defun ra-script:initialize-output-mode ()
  (set (make-local-variable 'font-lock-keywords-only) t)
  (make-local-variable 'font-lock-defaults)
  (set (make-local-variable 'scroll-margin) 0)
  (set (make-local-variable 'scroll-preserve-screen-position) nil)
  (make-local-variable 'after-change-functions)
  (anything-rails-minor-mode t))

(defvar ra-script:output-mode-hook nil)
(define-derived-mode ra-script:output-mode fundamental-mode "sfOutput"
  "Major mode to anything-rails Script Output."
  (ra-script:initialize-output-mode)
  (buffer-disable-undo)
  (setq buffer-read-only t)
  (run-hooks 'ra-script:output-mode-hook))

(defun ra-script:setup-output-buffer (&optional major-mode)
  (with-current-buffer (get-buffer ra-script:buffer-name)
    (let ((buffer-read-only nil))
      (if (and major-mode (functionp major-mode))
          (apply major-mode (list))
        (ra-script:output-mode)))))

(defun ra-script:run (command &optional args major-mode)
  (assert (stringp command))
  (assert (listp args))
  (ra:with-root-default-directory
   (save-some-buffers)
   (cond
    ((ra-script:process-running-p)
     (message "anything-rails process already running"))
    (t
     (let ((proc (apply 'ra-script:start-process
                        ra-script:buffer-name;(mapconcat 'identity (cons command args) " ")
                        ra-script:buffer-name
                        command
                        args)))
       (ra-script:setup-output-buffer major-mode)
       (set-process-sentinel proc 'ra-script:process-sentinel)
       ;; return proc
       proc
       )))))

(defvar ra-script:command-list
  '("h" "cc""clear-cache" "init-app" "init-module" "init-project" "log-purge" "log-rotate" "plugin-install"
    "plugin-list" "plugin-uninstall" "plugin-upgrade" "clear-controllers" "sync" "disable" "enable" "freeze"
    "permissions, fix-perms" "unfreeze"  "propel-build-all" "propel-build-all-load" "propel-build-model" "propel-build-schema"
    "propel-build-sql" "propel-dump-data" "propel-load-data" "propel-generate-crud" "propel-init-admin" "propel-insert-sql"
    "propel-convert-yml-schema" "propel-convert-xml-schema" "test-all" "test-functional" "test-unit"))

;; ;;; clear-cache (cc)
;; (defvar ra-script:clear-cache-arg-candidates
;;   '("template" "config" "i18n"))


;; ;;;; Keybinds
(ra:define-key "C-p" 'ra-cmd:primary-switch)
(ra:define-key "<up>" 'ra-cmd:primary-switch)

;; (ra:define-key "C-n" 'ra-cmd:relative-files)
;; (ra:define-key "<down>" 'ra-cmd:relative-files)

;; (ra:define-key "C-c g m" 'ra-cmd:model-files)
;; (ra:define-key "C-c g a" 'ra-cmd:action-files)
;; (ra:define-key "C-c g h" 'ra-cmd:helper-files)
;; (ra:define-key "C-c g t" 'ra-cmd:template-files)
;; (ra:define-key "C-c g j" 'ra-cmd:js-files)
;; (ra:define-key "C-c g c" 'ra-cmd:css-files)
;; (ra:define-key "C-c g T" 'ra-cmd:test-files)
;; (ra:define-key "C-c g f" 'ra-cmd:fixture-files)

;; (ra:define-key "C-c l" 'ra-cmd:open-log-file)
;; (ra:define-key "C-c C-t" 'ra-cmd:create-or-update-tags)


;;; Install
(defun ra:find-file-hook ()
  (anything-rails-minor-mode-maybe))
;;; add hook to `find-file-hooks'
(add-hook  'find-file-hooks 'ra:find-file-hook)


(provide 'anything-rails)

;;;;;;;;;
;; (defun ra-action:switch-to-validator ()
;;   (interactive)
;;   (let ((validators (ra-action:get-validators)))
;;     (cond
;;      (validators
;;       (ra:anything-project validators))
;;      (t
;;       (call-interactively 'find-file)))))

;; (defun ra-action:get-validators ()
;;   (cond
;;    ;; actions/actions.class.php
;;    ((string= (ra:this-file-name) ra:ACTIONS-CLASS-PHP)
;;     (let ((action-name (ra:take-off-execute (ra:take-function-name))))
;;       (ra-action:get-validators-by-action-name action-name)))
;;    ;; fooAction.class.php case
;;    (t
;;     (let ((action-name (ra:take-off-action (ra:take-class-name))))
;;       (ra-action:get-validators-by-action-name action-name)
;;       ))))

;; (defun ra-action:get-validators-by-action-name (action-name)
;;   (when action-name
;;     (loop for dir in (ra:get-validators-directory)
;;           nconc (ra:directory-files-recursively
;;                  (rx-to-string `(and ,action-name ".yml"))
;;                  dir))))

;; (defun ra:get-validators-directory ()
;;   (let ((validators-finder
;;          (lambda (cur-dir)
;;            (let ((validator-dir (ra:catdir cur-dir (concat "/" ra:VALIDATORS-DIR-NAME "/"))))
;;              (file-directory-p validator-dir)))))
;;     (let ((ret (ra:find-upper-directiory validators-finder)))
;;       (when ret
;;         (list (ra:catdir ret ra:VALIDATORS-DIR-NAME))))))

;; (defun ra-validator:switch-to-action ()
;;   (interactive)
;;   (lexical-let* ((action-name (file-name-sans-extension (ra:this-file-name))))
;;     (when action-name
;;       (lexical-let* ((actions (ra-validator:get-specify-actions-by-action-name action-name))
;;                      (execute-re (rx-to-string
;;                                   `(and "public"
;;                                         (+ space)
;;                                         "function"
;;                                         (+ space)
;;                                         "execute"
;;                                         ,action-name
;;                                         "()")))
;;                      (class-re (rx-to-string `(and "class" (+ space) ,action-name "Action"))))
;;         (let ((ra:after-anything-project-action-hook
;;                (list
;;                 (lambda ()
;;                   (goto-char (point-min))
;;                   (or (re-search-forward execute-re nil t)
;;                       (re-search-forward class-re nil t))))))
;;           (ra:anything-project actions))))))

;; ;; vote.yml -> user/validate/voteAction.class.php
;; (defun ra-validator:get-specify-actions-by-action-name (action-name)
;;   (let* ((module-directory (ra:get-module-directory))
;;          (actions-directory (ra:catdir module-directory "actions")))
;;     (assert (and actions-directory
;;                  (file-directory-p actions-directory)))
;;     (append (ra-validator:get-specify-actions-actions-class action-name actions-directory)
;;             (ra-validator:get-specify-actions-saparate-file action-name actions-directory)
;;             )))

;; (defun ra-validator:get-specify-actions-actions-class (action-name actions-directory)
;;   "return list"
;;   (let ((file-path (ra:catdir actions-directory ra:ACTIONS-CLASS-PHP)))
;;     (when (and file-path (file-exists-p file-path) (file-readable-p file-path))
;;       (list file-path))))

;; (defun ra-validator:get-specify-actions-saparate-file (action-name actions-directory)
;;   "return list"
;;   (let* ((file-name (concat action-name ra:ACTIONS-FILE-RULE))
;;          (file-path (ra:catdir actions-directory file-name)))
;;     (when (and file-path (file-exists-p file-path) (file-readable-p file-path))
;;       (list file-path))))
