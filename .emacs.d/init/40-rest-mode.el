;; Emacs起動時にrst.elを読み込み
(require 'rst)
(require 'rst-goodies)

(defalias 'sc 'sphinx-compile)
(defalias 'so 'sphinx-browse)

;; 拡張子の*.rst, *.restのファイルをrst-modeで開く
(setq auto-mode-alist
      (append '(("\\.rst$" . rst-mode)
                ("\\.rest$" . rst-mode)) auto-mode-alist))

(add-hook 'rst-mode-hook
          (lambda ()
           (define-key rst-mode-map (kbd "C-@") 'anything-rst-toc-command)
           (define-key rst-mode-map (kbd "C-c C-t") 'anything-rst-toc-command)))

;; 背景が黒い場合はこうしないと見出しが見づらい
(setq frame-background-mode 'dark)

;; 全部スペースでインデント
(add-hook 'rst-mode-hook '(lambda() (setq indent-tabs-mode nil)))
