
(global-set-key "\C-h" `delete-backward-char)

;;ウィンドウサイズ
(setq initial-frame-alist
      (append
       '((top    . 20)    ; フレームの Y 位置(ピクセル数)
         (left   . 45)    ; フレームの X 位置(ピクセル数)
         (width  . 185)    ; フレーム幅(文字数)
         (height . 70)   ; フレーム高(文字数)) initial-frame-alist))
         )))


(add-to-list 'load-path "~/.emacs.d/init")
(add-to-list 'load-path "~/.emacs.d/elisp")
(add-to-list 'load-path "~/.emacs.d/elisp/howm")
(add-to-list 'load-path "~/.emacs.d/elisp/anything")
(add-to-list 'load-path "~/.emacs.d/elisp/howm")
(setq load-path (nreverse load-path))

;; (if (version<= "26.0.50" emacs-version)
;;       (global-display-line-numbers-mode))

;;　行番号表示
(if (version<= "26.0.50" emacs-version)
    (progn
      (global-display-line-numbers-mode)
      (defun display-line-numbers-color-on-after-init (frame)
        "Hook function executed after FRAME is generated."
        (unless (display-graphic-p frame)
          (set-face-background
           'line-number
           (plist-get base16-solarized-dark-colors :base01))))
      (add-hook 'after-make-frame-functions
                (lambda (frame)
                  (display-line-numbers-color-on-after-init frame)))
      ))

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'package)

;;リポジトリにMarmaladeを追加
(add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tango-dark)))
 '(helm-source-names-using-follow (quote ("Recentf" "Buffers")))
 '(migemo-isearch-enable-p nil)
 '(package-selected-packages
   (quote
    (jump-dls howm helm-open-github helm-google helm-ag protobuf-mode golint go-mode helm-projectile projectile helm-migemo migemo zzz-to-char undo-tree magit-gh-pulls helm-swoop recentf-ext typescript-mode yaml-mode undohist sudo-ext session scss-mode sass-mode ruby-compilation ruby-block rspec-mode rhtml-mode rfringe python-mode prettier-js pos-tip popwin point-undo php-mode pandoc-mode nginx-mode mustache-mode markdown-mode magit let-alist key-chord js2-mode init-loader indent-guide highlight-cl highlight hide-lines helm-descbinds helm-c-moccur helm haskell-mode handlebars-mode grep-a-lot go-eldoc go-autocomplete git-timemachine git-gutter-fringe flycheck exec-path-from-shell electric-case dockerfile-mode dired-single dired+ csv-mode css-mode css-eldoc color-moccur anzu)))
 '(php-doc-author (format "your name <%s>" php-doc-mail-address))
 '(php-doc-license "The MIT License" t)
 '(php-doc-mail-address "your email address" t)
 '(php-doc-url "your url" t)
 '(phpdoc-author (format "your name <%s>" phpdoc-mail-address))
 '(phpdoc-mail-address "your email address" t)
 '(phpdoc-url "your url" t)
 '(safe-local-variable-values (quote ((sh-indent-comment . t) (encoding . utf-8)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(web-mode-comment-face ((t (:foreground "#587F35"))))
 '(web-mode-css-at-rule-face ((t (:foreground "#DFCF44"))))
 '(web-mode-css-property-name-face ((t (:foreground "#87CEEB"))))
 '(web-mode-css-pseudo-class ((t (:foreground "#DFCF44"))))
 '(web-mode-css-selector-face ((t (:foreground "#DFCF44"))))
 '(web-mode-css-string-face ((t (:foreground "#D78181"))))
 '(web-mode-doctype-face ((t (:foreground "#4A8ACA"))))
 '(web-mode-html-attr-equal-face ((t (:foreground "#FFFFFF"))))
 '(web-mode-html-attr-name-face ((t (:foreground "#87CEEB"))))
 '(web-mode-html-attr-value-face ((t (:foreground "#D78181"))))
 '(web-mode-html-tag-bracket-face ((t (:foreground "#4A8ACA"))))
 '(web-mode-html-tag-face ((t (:foreground "#4A8ACA"))))
 '(web-mode-server-comment-face ((t (:foreground "#587F35")))))

(setq x-select-enable-clipboard t)
;;; *.~ とかのバックアップファイルを作らない
(setq make-backup-files nil)
;;; .#* とかのバックアップファイルを作らない
(setq auto-save-default nil)


;; (global-whitespace-mode 1)


;; tmp ファイルをつくらないようにする
;; http://masutaka.net/chalow/2014-05-11-1.html
(setq create-lockfiles nil)
(setq auto-save-list-file-prefix nil)
(setq make-backup-files nil)


; ずれ確認用
; 0101010101010101010101010101010101010101
; ｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵ
					; あいうえおあいうえおあいうえおあいうえおあいうえお

; ずれ確認用
; 0101010101010101010101010101010101010101
; ｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵ
; あいうえおあいうえおあいうえおあいうえおあいうえお

(global-set-key (kbd "C-1") 'delete-other-windows)

(global-set-key (kbd "C-M-;") 'comment-dwim)
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)

(global-set-key (kbd "C-M-f") 'forward-word)

;; (define-key minibuffer-local-map (kbd "M-y") nil)
;; (define-key minibuffer-local-completion-map (kbd "M-y") nil)
;; (define-key minibuffer-local-map (kbd "M-y") 'anything-show-kill-ring)
;; (define-key minibuffer-local-completion-map (kbd "M-y") 'anything-show-kill-ring)
;;   (define-key minibuffer-local-completion-map "\C-n" 
;;     'next-history-element)
;;   (define-key minibuffer-local-completion-map "\C-p" 
;;     'previous-history-element)


;; (define-key minibuffer-local-map (kbd "C-h") 'delete-backward-char)
;; (define-key minibuffer-local-completion-map (kbd "C-h") 'delete-backward-char)
;; (define-key minibuffer-local-must-match-map (kbd "C-h") 'delete-backward-char)
;; (define-key minibuffer-local-isearch-map (kbd "C-h") 'delete-backward-char)

;; ミニバッファで　C-h
(defun minibuffer-delete-backward-char ()
  (local-set-key (kbd "C-h") 'delete-backward-char))
(add-hook 'minibuffer-setup-hook 'minibuffer-delete-backward-char)
(define-key isearch-mode-map (kbd "C-h") 'isearch-delete-char)


;; ;; C-q のキーマップを作成
(defvar ctl-q-map (make-keymap))  ;ctrl-q-map という変数を新たに定義

(define-key global-map (kbd "C-q") ctl-q-map) ;ctrl-q-map を Ctrl-q に割り当てる
;(define-key ctl-q-map (kbd "C-w") 'kill-new-things-at-point) ;C-q C-wでkill-new-things-at-pointを実行
;; (define-key ctl-q-map (kbd "C-w") (lambda () (interactive) (kill-new (my-thing-at-point 'symbol))))
;; (define-key ctl-q-map (kbd "C-e") (lambda () (interactive) (kill-new (my-thing-at-point 'word))))
;; (define-key ctl-q-map (kbd "C-r") (lambda () (interactive) (kill-new (my-thing-at-point 'sexp))))
;; (define-key ctl-q-map (kbd "C-i") 'ac-complete-look)
(define-key ctl-q-map (kbd "C-j") 'delete-other-windows)
(define-key ctl-q-map (kbd "C-M-j") 'delete-other-frames)
;; (define-key ctl-q-map (kbd "C-g") 'vc-annotate)

(defun delete-word (arg)
  "Delete characters forward until encountering the end of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (forward-word arg) (point))))

(defun backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-word (- arg)))

(global-set-key (kbd "M-/") 'backward-delete-word)


;(define-key ctl-q-map (kbd "C-b") 'your-favorite-funcb)
(define-key ctl-q-map (kbd "C-q") 'quoted-insert) ;元々の関数


;; 警告音もフラッシュも全て無効(警告音が完全に鳴らなくなるので注意)
(setq ring-bell-function 'ignore)
;;;


(setq x-select-enable-clipboard t)


(require 'init-loader)
(init-loader-load "~/.emacs.d/init")



(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(require 'ffap)

;; インデントでタブが挿入されるのを避ける
;; 4桁単位のタブは近代の登場で、中世まではタブは8桁が世界標準だった
;; ・8桁以下のインデントを実現するには、空白・タブを混在させることがファイルサイズを節約する上で有利だった
(setq-default indent-tabs-mode nil)

;; emacsclient 用
(server-start)
