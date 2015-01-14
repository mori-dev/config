
(require 'auto-install)

;; (setq auto-install-directory "~/.emacs.d/elisp/")
(setq auto-install-directory "~/.emacs.d/auto-install/")

;; 起動時に emacs-wiki のページ名を補完候補に加える
(auto-install-update-emacswiki-package-name t)
;; install-elisp.el互換モードにする
;;(auto-install-compatibility-setup)
;; ediff 関連のバッファを一つにまとめる
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
