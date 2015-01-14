
;; ;; rinari.rubyforge.org/index.html
;; ;; Interactively Do Things (highly recommended, but not strictly required)
;; (require 'ido)
;; (ido-mode t)

;; ;; Rinari
;; (add-to-list 'load-path "~/.emacs.d/elisp/rinari")


;; (setq rinari-jump-schema
;;  '((model
;;     "m"
;;     (("app/controllers/\\1_controller.rb#\\2$" . "app/models/\\1.rb#\\2")
;;      ("app/views/\\1/.*"                       . "app/models/\\1.rb")
;;      ("app/helpers/\\1_helper.rb"              . "app/models/\\1.rb")
;;      ("db/migrate/.*create_\\1.rb"             . "app/models/\\1.rb")
;;      ("spec/models/\\1_spec.rb"                . "app/models/\\1.rb")
;;      ("spec/controllers/\\1_controller_spec.rb". "app/models/\\1.rb")
;;      ("spec/views/\\1/.*"                      . "app/models/\\1.rb")
;;      ("spec/fixtures/\\1.yml"                  . "app/models/\\1.rb")
;;      ("test/functional/\\1_controller_test.rb" . "app/models/\\1.rb")
;;      ("test/unit/\\1_test.rb#test_\\2$"        . "app/models/\\1.rb#\\2")
;;      ("test/unit/\\1_test.rb"                  . "app/models/\\1.rb")
;;      ("test/fixtures/\\1.yml"                  . "app/models/\\1.rb")
;;      (t                                        . "app/models/"))
;;     (lambda (path)
;;       (rinari-generate "model"
;;                        (and (string-match ".*/\\(.+?\\)\.rb" path)
;;                             (match-string 1 path)))))
;;    (controller
;;     "c"
;;     (("app/models/\\1.rb"                      . "app/controllers/\\1_controller.rb")
;;      ("app/views/\\1/\\2\\..*"                 . "app/controllers/\\1_controller.rb#\\2")
;;      ("app/helpers/\\1_helper.rb"              . "app/controllers/\\1_controller.rb")
;;      ("db/migrate/.*create_\\1.rb"             . "app/controllers/\\1_controller.rb")
;;      ("spec/models/\\1_spec.rb"                . "app/controllers/\\1_controller.rb")
;;      ("spec/controllers/\\1_spec.rb"           . "app/controllers/\\1.rb")
;;      ("spec/views/\\1/\\2\\.*_spec.rb"         . "app/controllers/\\1_controller.rb#\\2")
;;      ("spec/fixtures/\\1.yml"                  . "app/controllers/\\1_controller.rb")
;;      ("test/functional/\\1_test.rb#test_\\2$"  . "app/controllers/\\1.rb#\\2")
;;      ("test/functional/\\1_test.rb"            . "app/controllers/\\1.rb")
;;      ("test/unit/\\1_test.rb#test_\\2$"        . "app/controllers/\\1_controller.rb#\\2")
;;      ("test/unit/\\1_test.rb"                  . "app/controllers/\\1_controller.rb")
;;      ("test/fixtures/\\1.yml"                  . "app/controllers/\\1_controller.rb")
;;      (t                                        . "app/controllers/"))
;;     (lambda (path)
;;       (rinari-generate "controller"
;;                        (and (string-match ".*/\\(.+?\\)_controller\.rb" path)
;;                             (match-string 1 path)))))
;;    (view
;;     "v"
;;     (("app/models/\\1.rb"                      . "app/views/\\1/.*")
;;      ((lambda () ;; find the controller/view
;;         (let* ((raw-file (and (buffer-file-name)
;;                               (file-name-nondirectory (buffer-file-name))))
;;                (file (and raw-file
;;                           (string-match "^\\(.*\\)_controller.rb" raw-file)
;;                           (match-string 1 raw-file))) ;; controller
;;                (raw-method (ruby-add-log-current-method))
;;                (method (and file raw-method ;; action
;;                             (string-match "#\\(.*\\)" raw-method)
;;                             (match-string 1 raw-method))))
;;           (when (and file method) (rinari-follow-controller-and-action file method))))
;;       . "app/views/\\1/\\2.*")
;;      ("app/controllers/\\1_controller.rb"      . "app/views/\\1/.*")
;;      ("app/helpers/\\1_helper.rb"              . "app/views/\\1/.*")
;;      ("db/migrate/.*create_\\1.rb"             . "app/views/\\1/.*")
;;      ("spec/models/\\1_spec.rb"                . "app/views/\\1/.*")
;;      ("spec/controllers/\\1_spec.rb"           . "app/views/\\1/.*")
;;      ("spec/views/\\1/\\2_spec.rb"             . "app/views/\\1/\\2.*")
;;      ("spec/fixtures/\\1.yml"                  . "app/views/\\1/.*")
;;      ("test/functional/\\1_controller_test.rb" . "app/views/\\1/.*")
;;      ("test/unit/\\1_test.rb#test_\\2$"        . "app/views/\\1/_?\\2.*")
;;      ("test/fixtures/\\1.yml"                  . "app/views/\\1/.*")
;;      (t                                        . "app/views/.*"))
;;     t)
;;    (test
;;     "t"
;;     (("app/models/\\1.rb#\\2$"                 . "test/unit/\\1_test.rb#test_\\2")
;;      ("app/controllers/\\1.rb#\\2$"            . "test/functional/\\1_test.rb#test_\\2")
;;      ("app/views/\\1/_?\\2\\..*"               . "test/functional/\\1_controller_test.rb#test_\\2")
;;      ("app/helpers/\\1_helper.rb"              . "test/functional/\\1_controller_test.rb")
;;      ("db/migrate/.*create_\\1.rb"             . "test/unit/\\1_test.rb")
;;      ("test/functional/\\1_controller_test.rb" . "test/unit/\\1_test.rb")
;;      ("test/unit/\\1_test.rb"                  . "test/functional/\\1_controller_test.rb")
;;      (t                                        . "test/.*"))
;;     t)
;;    (rspec
;;     "r"
;;     (("app/\\1\\.rb"                           . "spec/\\1_spec.rb")
;;      ("app/\\1$"                               . "spec/\\1_spec.rb")
;;      ("spec/views/\\1_spec.rb"                 . "app/views/\\1")
;;      ("spec/\\1_spec.rb"                       . "app/\\1.rb")
;;      (t                                        . "spec/.*"))
;;     t)
;;    (fixture
;;     "x"
;;     (("app/models/\\1.rb"                      . "test/fixtures/\\1.yml")
;;      ("app/controllers/\\1_controller.rb"      . "test/fixtures/\\1.yml")
;;      ("app/views/\\1/.*"                       . "test/fixtures/\\1.yml")
;;      ("app/helpers/\\1_helper.rb"              . "test/fixtures/\\1.yml")
;;      ("db/migrate/.*create_\\1.rb"             . "test/fixtures/\\1.yml")
;;      ("spec/models/\\1_spec.rb"                . "test/fixtures/\\1.yml")
;;      ("spec/controllers/\\1_controller_spec.rb". "test/fixtures/\\1.yml")
;;      ("spec/views/\\1/.*"                      . "test/fixtures/\\1.yml")
;;      ("test/functional/\\1_controller_test.rb" . "test/fixtures/\\1.yml")
;;      ("test/unit/\\1_test.rb"                  . "test/fixtures/\\1.yml")
;;      (t                                        . "test/fixtures/"))
;;     t)
;;    (rspec-fixture
;;     "z"
;;     (("app/models/\\1.rb"                      . "spec/fixtures/\\1.yml")
;;      ("app/controllers/\\1_controller.rb"      . "spec/fixtures/\\1.yml")
;;      ("app/views/\\1/.*"                       . "spec/fixtures/\\1.yml")
;;      ("app/helpers/\\1_helper.rb"              . "spec/fixtures/\\1.yml")
;;      ("db/migrate/.*create_\\1.rb"             . "spec/fixtures/\\1.yml")
;;      ("spec/models/\\1_spec.rb"                . "spec/fixtures/\\1.yml")
;;      ("spec/controllers/\\1_controller_spec.rb". "spec/fixtures/\\1.yml")
;;      ("spec/views/\\1/.*"                      . "spec/fixtures/\\1.yml")
;;      ("test/functional/\\1_controller_test.rb" . "spec/fixtures/\\1.yml")
;;      ("test/unit/\\1_test.rb"                  . "spec/fixtures/\\1.yml")
;;      (t                                        . "spec/fixtures/"))
;;     t)
;;    (helper
;;     "h"
;;     (("app/models/\\1.rb"                      . "app/helpers/\\1_helper.rb")
;;      ("app/controllers/\\1_controller.rb"      . "app/helpers/\\1_helper.rb")
;;      ("app/views/\\1/.*"                       . "app/helpers/\\1_helper.rb")
;;      ("app/helpers/\\1_helper.rb"              . "app/helpers/\\1_helper.rb")
;;      ("db/migrate/.*create_\\1.rb"             . "app/helpers/\\1_helper.rb")
;;      ("spec/models/\\1_spec.rb"                . "app/helpers/\\1_helper.rb")
;;      ("spec/controllers/\\1_spec.rb"           . "app/helpers/\\1_helper.rb")
;;      ("spec/views/\\1/.*"                      . "app/helpers/\\1_helper.rb")
;;      ("test/functional/\\1_controller_test.rb" . "app/helpers/\\1_helper.rb")
;;      ("test/unit/\\1_test.rb#test_\\2$"        . "app/helpers/\\1_helper.rb#\\2")
;;      ("test/unit/\\1_test.rb"                  . "app/helpers/\\1_helper.rb")
;;      (t                                        . "app/helpers/"))
;;     t)
;;    (migration
;;     "i"
;;     (("app/controllers/\\1_controller.rb"      . "db/migrate/.*create_\\1.rb")
;;      ("app/views/\\1/.*"                       . "db/migrate/.*create_\\1.rb")
;;      ("app/helpers/\\1_helper.rb"              . "db/migrate/.*create_\\1.rb")
;;      ("app/models/\\1.rb"                      . "db/migrate/.*create_\\1.rb")
;;      ("spec/models/\\1_spec.rb"                . "db/migrate/.*create_\\1.rb")
;;      ("spec/controllers/\\1_spec.rb"           . "db/migrate/.*create_\\1.rb")
;;      ("spec/views/\\1/.*"                      . "db/migrate/.*create_\\1.rb")
;;      ("test/functional/\\1_controller_test.rb" . "db/migrate/.*create_\\1.rb")
;;      ("test/unit/\\1_test.rb#test_\\2$"        . "db/migrate/.*create_\\1.rb#\\2")
;;      ("test/unit/\\1_test.rb"                  . "db/migrate/.*create_\\1.rb")
;;      (t                                        . "db/migrate/"))
;;     (lambda (path)
;;       (rinari-generate "migration"
;;                        (and (string-match ".*create_\\(.+?\\)\.rb" path)
;;                             (match-string 1 path)))))
;;    (cells
;;     "C"
;;     (("app/cells/\\1_cell.rb"                  . "app/cells/\\1/.*")
;;      ("app/cells/\\1/\\2.*"                    . "app/cells/\\1_cell.rb#\\2")
;;      (t                                        . "app/cells/"))
;;     (lambda (path)
;;       (rinari-generate "cells"
;;                        (and (string-match ".*/\\(.+?\\)_cell\.rb" path)
;;                             (match-string 1 path)))))
;;    (features "F" ((t . "features/.*feature")) nil)
;;    (steps "S" ((t . "features/step_definitions/.*")) nil)
;;    (environment "e" ((t . "config/environments/")) nil)
;;    (application "a" ((t . "config/application.rb")) nil)
;;    (configuration "n" ((t . "config/")) nil)
;;    (script "s" ((t . "script/")) nil)
;;    (lib "l" ((t . "lib/")) nil)
;;    (log "o" ((t . "log/")) nil)
;;    (worker "w" ((t . "lib/workers/")) nil)
;;    (public "p" ((t . "public/")) nil)
;;    (stylesheet "y" ((t . "public/stylesheets/.*")
;;                     (t . "app/assets/stylesheets/.*")) nil)
;;    (sass "Y" ((t . "public/stylesheets/sass/.*")
;;               (t . "app/stylesheets/.*")) nil)
;;    (javascript "j" ((t . "public/javascripts/.*")
;;                     (t . "app/assets/javascripts/.*")) nil)
;;    (plugin "u" ((t . "vendor/plugins/")) nil)
;;    (mailer "M" ((t . "app/mailers/")) nil)
;;    (file-in-project "f" ((t . ".*")) nil)
;;    (by-context
;;     ";"
;;     (((lambda () ;; Find-by-Context
;;         (let ((path (buffer-file-name)))
;;           (when (string-match ".*/\\(.+?\\)/\\(.+?\\)\\..*" path)
;;             (let ((cv (cons (match-string 1 path) (match-string 2 path))))
;;               (when (re-search-forward "<%=[ \n\r]*render(? *" nil t)
;;                 (setf cv (rinari-ruby-values-from-render (car cv) (cdr cv)))
;;                 (list (car cv) (cdr cv)))))))
;;       . "app/views/\\1/\\2.*")))))



;; (setq rinari-minor-mode-prefixes
;;   (list ";" "'" "c" "C-c"))

;; ;; (setq rinari-major-modes '(ruby-mode-hook yaml-mode-hook rhtml-mode-hook rspec-mode-hook))
;; ;; (setq rinari-major-modes '('ruby-mode-hook 'yaml-mode-hook 'rhtml-mode-hook 'rspec-mode-hook))

;; ;; (add-hook 'ruby-mode-hook
;; ;;   (lambda () (rinari-launch)))
;; ;; (add-hook 'rhtml-mode-hook
;; ;;   (lambda () (rinari-launch)))

;; (require 'rinari)

;; (add-hook 'ruby-mode-hook  'rinari-launch)
;; (add-hook 'rhtml-mode-hook 'rinari-launch)
;; (add-hook 'yaml-mode-hook  'rinari-launch)
;; (add-hook 'css-mode-hook   'rinari-launch)
;; (add-hook 'scss-mode-hook  'rinari-launch)
;; (add-hook 'scss-mode-hook  'rinari-launch)

;; ;; (setq rinari-major-modes (list 'ruby-mode-hook 'yaml-mode-hook 'rhtml-mode-hook
;; ;;                                'rspec-mode-hook))

;; ;; (rinari-launch-maybe)

;; ;; (setq rinari-major-modes (list 'ruby-mode-hook 'yaml-mode-hook 'rhtml-mode-hook
;; ;;                                'rspec-mode-hook))


;; ;; (global-rinari-mode)

;; ;; (require 'rhtml-mode)
;; ;; (add-hook 'rhtml-mode-hook
;; ;;   (lambda () (rinari-launch)))

;; (setq rinari-tags-file-name "TAGS")

;; ;; (setf
;; ;;  my-rinari-jump-schema
;; ;;  '((my-stylesheet "y" ((t . "app/assets/stylesheets/.*")) nil)
;; ;;    (my-javascript "j" ((t . "app/assets/javascripts/.*")) nil)
;; ;;    (my-backbone-application "a" ((t . "app/assets/javascripts/backbone/.*\\.js\\.coffee")) nil)
;; ;;    (my-backbone-template "t" ((t . "app/assets/javascripts/templates/.*")) nil)
;; ;;    (my-backbone-model "m" ((t . "app/assets/javascripts/backbone/models/.*")) nil)
;; ;;    (my-backbone-view "v" ((t . "app/assets/javascripts/backbone/views/.*")) nil)
;; ;;    (my-backbone-router "r" ((t . "app/assets/javascripts/backbone/routers/.*")) nil)

;; ;;    (my-fabrication "f" ((t . "spec/fabricators/.*")) nil)
;; ;;    (my-rspec
;; ;;     "t"
;; ;;     (("app/models/\\1.rb" . "spec/models/\\1_spec.rb")
;; ;;      ("app/controllers/\\1.rb" . "spec/controllers/\\1_spec.rb")
;; ;;      ("app/views/\\1\\..*" . "spec/views/\\1_spec.rb")
;; ;;      ("lib/\\1.rb" . "spec/libs/\\1_spec.rb")
;; ;;      ("db/migrate/.*_create_\\1.rb" . "spec/models/\\1_spec.rb")
;; ;;      ("config/routes.rb" . "spec/routing/.*\\.rb")
;; ;;      (t . "spec/.*\\.rb"))
;; ;;     t)
;; ;;    (my-decorator
;; ;;     "d"
;; ;;     (("app/models/\\1.rb" . "app/decorators/\\1_decorator.rb")
;; ;;      ("app/controllers/\\1.rb" . "app/decorators/\\1_decorator.rb")
;; ;;      ("app/views/\\1\\..*" . "app/decorators/\\1_decorator.rb")
;; ;;      ("db/migrate/.*_create_\\1.rb" . "app/decorators/\\1_decorator.rb")
;; ;;      (t . "app/decorators/.*\\.rb"))
;; ;;     t)

;; ;;    (my-request-rspec "r" ((t . "spec/requests/.*")) nil)
;; ;;    ))

;; ;; (rinari-apply-jump-schema my-rinari-jump-schema)

;; ;; (add-to-list 'auto-mode-alist '("\\.text\\.erb$" . rhtml-mode))
;; ;; (add-to-list 'auto-mode-alist '("\\.jst\\.eco$" . rhtml-mode))


;; (define-key rinari-minor-mode-map (kbd "C-c m") 'rinari-find-model)
;; (define-key rinari-minor-mode-map (kbd "C-c M") 'rinari-find-mailer)
;; (define-key rinari-minor-mode-map (kbd "C-c c") 'rinari-find-controller)
;; (define-key rinari-minor-mode-map (kbd "C-c o") 'rinari-find-configuration)
;; (define-key rinari-minor-mode-map (kbd "C-c a") 'rinari-find-application)
;; (define-key rinari-minor-mode-map (kbd "C-c e") 'rinari-find-environment)
;; (define-key rinari-minor-mode-map (kbd "C-c h") 'rinari-find-helper)
;; (define-key rinari-minor-mode-map (kbd "C-c v") 'rinari-find-view)
;; (define-key rinari-minor-mode-map (kbd "C-c i") 'rinari-find-migration)
;; (define-key rinari-minor-mode-map (kbd "C-c l") 'rinari-find-lib)
;; ;; (define-key rinari-minor-mode-map (kbd "C-c r") 'rinari-find-my-request-rspec)
;; ;; (define-key rinari-minor-mode-map (kbd "C-c t") 'rinari-find-my-rspec)
;; ;; (define-key rinari-minor-mode-map (kbd "C-c f") 'rinari-find-my-fabrication)
;; ;; (define-key rinari-minor-mode-map (kbd "C-c y") 'rinari-find-my-stylesheet)
;; ;; (define-key rinari-minor-mode-map (kbd "C-c d") 'rinari-find-my-decorator)
;; ;; (define-key rinari-minor-mode-map (kbd "C-c j") 'rinari-find-my-javascript)
;; ;; (define-key rinari-minor-mode-map (kbd "C-c C-c a") 'rinari-find-my-backbone-application)
;; ;; (define-key rinari-minor-mode-map (kbd "C-c C-c m") 'rinari-find-my-backbone-model)
;; ;; (define-key rinari-minor-mode-map (kbd "C-c C-c r") 'rinari-find-my-backbone-router)
;; ;; (define-key rinari-minor-mode-map (kbd "C-c C-c v") 'rinari-find-my-backbone-view)
;; ;; (define-key rinari-minor-mode-map (kbd "C-c C-c t") 'rinari-find-my-backbone-template)
;; ;; (define-key rinari-minor-mode-map (kbd "C-l x") 'rinari-extract-partial)
;; ;; (define-key rinari-minor-mode-map (kbd "C-l c") 'rinari-console)
;; ;; (define-key rinari-minor-mode-map (kbd "C-l s") 'rinari-web-server)
;; ;; (define-key rinari-minor-mode-map (kbd "C-l r") 'rinari-web-server-restart)
;; ;; (define-key rinari-minor-mode-map (kbd "C-l p") 'rinari-cap)

;; (defun my-find-gemfile ()
;;   (interactive)
;;   (find-file (concat (rinari-root) "Gemfile")))
;; (define-key rinari-minor-mode-map (kbd "C-c g") 'my-find-gemfile)
