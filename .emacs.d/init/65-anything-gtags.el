;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;;; anything-gtags の設定
(require 'anything-gtags)
(setq anything-gtags-classify 1)

(require 'anything-gtags)





(defmacro my-let-env (environments &rest body)
  `(let ((process-environment process-environment))
     ,@(mapcar (lambda (env) `(setenv ,@env)) environments)
     (progn ,@body)))

(defun anything-c-source-gtags-select-with-root (name gtagsroot)
  (lexical-let ((gtagsroot (expand-file-name gtagsroot)))
    `((name . ,name)
      (init
       . ,(lambda ()
            (my-let-env
             (("GTAGSROOT" gtagsroot))
             (call-process-shell-command
              "global -c" nil (anything-candidate-buffer 'global)))))
      (candidates-in-buffer)
      (candidate-number-limit . 99999)
      (action
       ("Goto the location"
        . ,(lambda (candidate)
             (my-let-env
              (("GTAGSROOT" gtagsroot))
              (gtags-push-context)
              (gtags-goto-tag candidate ""))))
       ("Goto the location (other-window)"
        . ,(lambda (candidate)
             (my-let-env
              (("GTAGSROOT" gtagsroot))
              (gtags-push-context)
              (gtags-goto-tag candidate "" t))))
       ("Move to the referenced point"
        . ,(lambda (candidate)
             (my-let-env
              (("GTAGSROOT" gtagsroot))
              (gtags-push-context)
              (gtags-goto-tag candidate "r"))))))))


(defvar anything-c-source-gtags-select-with-home-perl-lib
  (anything-c-source-gtags-select-with-root "rails" "~/.rvm/gems/ruby-1.9.1-p378/gems/rails-2.3.2"))

(defun my-anything-gtags-select ()
  (interactive)
  (anything-other-buffer
     '(anything-c-source-gtags-select
       anything-c-source-gtags-select-with-home-perl-lib)
     "*anything gtags*"))
