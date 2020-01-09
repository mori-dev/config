(add-to-list 'exec-path (concat (getenv "HOME") "/Dropbox/bin"))
(add-to-list 'exec-path (concat (getenv "HOME") "/.cabal/bin"))


;; emacs でビープ音を鳴らさない
(setq ring-bell-function 'ignore)
;; emacs とブラウザなどでクリップボードを共有する
(setq x-select-enable-clipboard t)
;; (setq x-select-enable-clipboard nil)
;; (setq x-select-enable-primary t)
;; (setq select-active-regions t)
;; (setq mouse-drag-copy-region t)

;;; 行末の空白を表示
(global-whitespace-mode 1)
(setq-default show-trailing-whitespace t)
(set-face-background 'trailing-whitespace nil)
(set-face-underline 'trailing-whitespace "Knobcolor")

;; 文字コード
(set-default-coding-systems 'utf-8-unix)
(prefer-coding-system 'utf-8-unix)

;; tmp ファイルをつくらないようにする
;; http://masutaka.net/chalow/2014-05-11-1.html
(setq create-lockfiles nil)
(setq auto-save-list-file-prefix nil)
(setq make-backup-files nil)

; キーボードマクロ
(global-set-key (kbd "C-5") 'kmacro-call-macro)
(global-set-key (kbd "C->") 'kmacro-start-macro)
(global-set-key (kbd "C-<") 'kmacro-end-macro)

; ずれ確認用
; 0101010101010101010101010101010101010101
; ｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵ
; あいうえおあいうえおあいうえおあいうえおあいうえお


;; ;; 行末の空白と末尾改行を削除
;; ;; for whitespace-mode
;; (require 'whitespace)
;; ;; see whitespace.el for more details
;; (setq whitespace-style '(face tabs tab-mark spaces space-mark))
;; (setq whitespace-display-mappings
;;       '((space-mark ?\u3000 [?\u25a1])
;;         ;; WARNING: the mapping below has a problem.
;;         ;; When a TAB occupies exactly one column, it will display the
;;         ;; character ?\xBB at that column followed by a TAB which goes to
;;         ;; the next TAB column.
;;         ;; If this is a problem for you, please, comment the line below.
;;         (tab-mark ?\t [?\xBB ?\t] [?\\ ?\t])))
;; (setq whitespace-space-regexp "\\(\u3000+\\)")
;; (set-face-foreground 'whitespace-tab "#444")
;; (set-face-background 'whitespace-tab 'nil)
;; (set-face-underline  'whitespace-tab 'nil)
;; (set-face-foreground 'whitespace-space "#7cfc00")
;; (set-face-background 'whitespace-space 'nil)
;; (set-face-bold-p 'whitespace-space t)
;; (global-whitespace-mode 1)
;; (global-set-key (kbd "C-x w") 'global-whitespace-mode)



(add-hook 'emacs-lisp-mode-hook
  (lambda()
    (define-key emacs-lisp-mode-map (kbd "C-j") 'eval-print-last-sexp)))

(add-hook 'lisp-interaction-mode-hook
  (lambda()
    (emacs-lisp-mode)))

(add-hook 'after-revert-hook
          (lambda ()
            (when auto-revert-tail-mode (end-of-buffer))))


(require 'cl)
