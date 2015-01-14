

;; (require 'rvm)
;; (rvm-use-default)
;; (rvm-activate-corresponding-ruby)
;; ;; rvm-use のやりとりがたるいので決め打ちで実行
;; (defun r18 ()
;;   (interactive)
;;   (let* ((ruby-info (rvm/info "ruby-1.8.7-p352"))
;;          (new-ruby-binary (cdr (assoc "ruby" ruby-info)))
;;          (new-ruby-gemhome (cdr (assoc "GEM_HOME" ruby-info))))
;;     (rvm--set-ruby (file-name-directory new-ruby-binary))
;;     (rvm--set-gemhome new-ruby-gemhome "global"))
;;   (message (concat "Ruby: 1.8.7" " Gemset: global")))

;; (defun r19 ()
;;   (interactive)
;;   (let* ((ruby-info (rvm/info "ruby-1.9.3p194"))
;;          (new-ruby-binary (cdr (assoc "ruby" ruby-info)))
;;          (new-ruby-gemhome (cdr (assoc "GEM_HOME" ruby-info))))
;;     (rvm--set-ruby (file-name-directory new-ruby-binary))
;;     (rvm--set-gemhome new-ruby-gemhome "global"))
;;   (message (concat "Ruby: 1.9.2" " Gemset: global")))
