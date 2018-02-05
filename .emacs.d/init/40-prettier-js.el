;; https://github.com/prettier/prettier-emacs
(require 'prettier-js)

;; (add-hook 'javascript-mode-hook 'prettier-js-mode)
(add-hook 'js-mode-hook 'prettier-js-mode)

(add-hook 'web-mode-hook 'prettier-js-mode)

(setq prettier-js-args '(
  "--trailing-comma" "none"
  "--semi" "false"
  "--single-quote" "true"
))
