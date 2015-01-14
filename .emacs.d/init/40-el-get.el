(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")

(el-get 'sync)
;; (el-get 'sync (mapcar 'el-get-source-name el-get-sources))

;; http://shishithefool.blogspot.jp/2012/04/el-get-emacs.html
;; (setq el-get-sources
;;       '(
;;         (:name ruby-mode-trunk-head
;;                :type http
;;                :description "Major mode for editing Ruby files. (trunk-head)"
;;                :url "http://bugs.ruby-lang.org/projects/ruby-trunk/repository/raw/misc/ruby-mode.el")
;;         (:name php-mode-github
;;                :type github
;;                :website "https://github.com/ejmr/php-mode"
;;                :description "Major mode for editing PHP files. (on Github based on SourceForge version))"
;;                :pkgname "ejmr/php-mode")
;;         (:name multi-web-mode
;;                :type git
;;                :website "https://github.com/fgallina/multi-web-mode"
;;                :description "Multi Web Mode is a minor mode wich makes web editing in Emacs much easier."
;;                :url "git://github.com/fgallina/multi-web-mode.git")))
