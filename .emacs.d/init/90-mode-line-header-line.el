;;モードライン の表示
;; Isearch は表示しなくてよい
(add-hook 'isearch-mode-hook
          '(lambda () (setcar (cdr (assq 'isearch-mode minor-mode-alist)) "")))
;; Texinfo も長い
(add-hook 'texinfo-mode-hook
          '(lambda ()
             (setq mode-name "Texi")))
;; scratch バッファの Lisp Interaction も長い
(add-hook 'lisp-interaction-mode-hook
          '(lambda ()
             (setq mode-name "Lisp-Int")))
;; Emacs-Lisp も長い
(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
             (setq mode-name "Elisp")))


;;タイトルバーに現在のファイル名を表示する
(setq frame-title-format (format "%%f - Emacs@%s" (system-name)))
(require 'vc)
;; auto-revert-check-vc-info
;; モードラインとヘッダラインのカスタマイズ
(require 'which-func)
(which-func-mode 1)
(delete (assoc 'which-func-mode mode-line-format) mode-line-format)

(let ((delimiter (propertize " | " 'face '(:foreground "DarkRed"))))
  ;; (setq default-mode-line-format
  ;;     (list ""
  ;;           skk-modeline-input-mode
  ;;           ;; "%e"
  ;;           mode-line-mule-info
  ;;           mode-line-client
  ;;           mode-line-modified
  ;;           mode-line-remote
  ;;           mode-line-frame-identification
  ;;           mode-line-buffer-identification
  ;;           mode-line-position
  ;;           (vc-mode vc-mode)
  ;;           fgit--mode-line-in-dired
  ;;           mode-line-modes
  ;;           ))

  
  ;; (setq default-mode-line-format
  ;;       (list ""
  ;;             delimiter
  ;;             'mode-line-modified         ;バッファが変更されたか
  ;;             delimiter
  ;;             '(-3 . "%P")                ;"%P"はバッファ全体でウィンドウの最下段より上にある部分が何パーセントあるか
  ;;             delimiter
  ;;             "Line %l"
  ;;             delimiter
  ;;             "%[("                       ;再帰編集の深さ
  ;;             "%n"                        ;ナローイングしているか
  ;;             'mode-name
  ;;             'minor-mode-alist
  ;;             'mode-line-process
  ;;             ")%] "))
  (setq default-header-line-format
        (list ""
              ;; '(which-func-mode ("" (propertize which-func-format'face '(:foreground "cyan"))))
              '(which-func-mode ("" which-func-format))
              delimiter
              "%14b" ; バッファ名の表示buffer-name `14' は表示する文字数の最大の指定
              delimiter
              ;; 'default-directory ;パスの表示
              'buffer-file-name
              ;; (file-name-directory (buffer-file-name))
              ;; (propertize (buffer-name (window-buffer)) 'face '(:foreground "cyan"))
              )))

(setq which-func-format
  `("["
    (:propertize which-func-current
         local-map ,which-func-keymap
         face which-func
         ;; 'face '(:foreground "cyan")
         ;;mouse-face highlight     ; currently not evaluated :-(
         help-echo "mouse-1: go to beginning, mouse-2: toggle rest visibility, mouse-3: go to end")
    "]"))

;; (setq-default header-line-format '(which-func-mode ("" which-func-format)))
;; frame-title-format も設定可能
