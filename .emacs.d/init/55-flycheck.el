(add-hook 'after-init-hook #'global-flycheck-mode)
(setq flycheck-coffeelintrc "~/.coffeelint.json")

;; (setq flycheck-checkers
;;   '(bash
;;     c/c++-clang
;;     c/c++-cppcheck
;;     coffee
;;     coffee-coffeelint
;;     css-csslint
;;     d-dmd
;;     elixir
;;     emacs-lisp
;;     emacs-lisp-checkdoc
;;     erlang
;;     go-gofmt
;;     go-build
;;     go-test
;;     haml
;;     haskell-hdevtools
;;     haskell-ghc
;;     haskell-hlint
;;     html-tidy
;;     javascript-jshint
;;     json-jsonlint
;;     less
;;     lua
;;     perl
;;     php
;;     php-phpcs
;;     puppet-parser
;;     puppet-lint
;;     python-flake8
;;     python-pylint
;;     rst
;;     ruby-rubocop
;;     ruby
;;     ruby-jruby
;;     rust
;;     sass
;;     scala
;;     ;; scss
;;     sh-dash
;;     sh-bash
;;     tex-chktex
;;     tex-lacheck
;;     xml-xmlstarlet
;;     xml-xmllint
;;     zsh))
;; ;; Python
;; (add-hook 'python-mode-hook 'flycheck-mode)

;; ;; Ruby
;; (add-hook 'ruby-mode-hook 'flycheck-mode)
