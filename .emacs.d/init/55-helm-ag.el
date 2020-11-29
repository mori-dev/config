(require 'helm-ag)

;; -nを消すとサブディレクトリも再帰的に検索
;; (setq helm-ag-base-command "ag --nocolor --nogroup -n")
(setq helm-ag-base-command "ag --nocolor --nogroup")


(global-set-key (kbd "C-c C-a C-g") 'helm-ag)
;; 40-keybind.el
;; (define-key ctl-q-map (kbd "C-p") 'helm-projectile-ag)
