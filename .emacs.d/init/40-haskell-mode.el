
(require 'haskell-mode)

(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))
(add-to-list 'auto-mode-alist '("\\.lhs$" . literate-haskell-mode))
(add-to-list 'interpreter-mode-alist '("runghc" . haskell-mode))
(add-to-list 'interpreter-mode-alist '("runhaskell" . haskell-mode))



(add-hook 'haskell-mode-hook 'font-lock-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
(global-set-key [(control meta down-mouse-3)] 'imenu)
(add-hook 'haskell-mode-hook 'imenu-add-menubar-index)

;; コマンド版 hoogle を使う
;; (setq haskell-hoogle-command "hoogle")

;; ghc-mod
(require 'ghc nil t)

;; (autoload 'ghc-init "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init)))



(defvar anything-c-source-files-in-cabal-dir
  '((name . "Cabal Packages")
    (candidates . (lambda ()
                    (with-current-buffer anything-current-buffer
                      (directory-files "~/.cabal/packages/hackage.haskell.org/" t))))
    (type . file)))

(defun anything-cabal ()
  (interactive)
  (anything '(anything-c-source-files-in-cabal-dir)))

(defalias 'cabal 'anything-cabal)


;; (require 'haskell-cabal)
(add-to-list 'auto-mode-alist '("\\.cabal\\'" . conf-mode))