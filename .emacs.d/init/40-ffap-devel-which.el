;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; devel/which
;; http://raa.ruby-lang.org/list.rhtml?name=devel-which
;; ~/Dropbox/tools/devel-which に置いた

;; rvm 1.8.7
;; ruby ~/Dropbox/tools/devel-which/install.rb
;; cp ~/.rvm/rubies/ruby-1.8.7-p302/lib/ruby/1.8/ftools.rb ~/.rvm/rubies/ruby-1.9.1-p378/lib/ruby/1.9.1/ftools.rb
;; rvm 1.9.1
;; ruby ~/Dropbox/tools/devel-which/install.rb
;; rm ~/.rvm/rubies/ruby-1.9.1-p378/lib/ruby/1.9.1/ftools.rb

(defun ffap-ruby-mode (name)
  (shell-command-to-string
   (format "ruby -e 'require %%[rubygems];require %%[devel/which];require %%[%s];
print (which_library (%%[%%s]))'" name name)))

(defun find-ruby-lib (name)
  (interactive "sRuby library name: ")
  (find-file (ffap-ruby-mode name)))

;ffap
(require 'ffap)
(add-to-list 'ffap-alist '(ruby-mode . ffap-ruby-mode))
