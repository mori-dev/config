;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

    ;; (define-key map "\C-c\C-a" #'js2-mode-show-all)
    ;; (define-key map "\C-c\C-f" #'js2-mode-toggle-hide-functions)
    ;; (define-key map "\C-c\C-t" #'js2-mode-toggle-hide-comments)
    ;; (define-key map "\C-c\C-o" #'js2-mode-toggle-element)


;; 参考URL
;; http://8-p.info/emacs-javascript.html
;; http://www.jaco-bass.com/blog/2009/06/environment-of-javascript-and-actionscript-made-from-emacs/
(require 'js2-mode)
;; (autoload 'js2-mode "js2" nil t)

;; (eval-after-load "js2"

;; '(progn

;;    ))


(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(when (load "js2" t)
  (setq js2-strict-missing-semi-warning nil)  ;; missing ; after statement を抑止
  (setq js2-basic-offset  2)        ;インデント幅を 2 にする
  (setq js2-cleanup-whitespace nil) ;行末の空白を保存時に削除しない
  ;(setq js2-mirror-mode nil)        ;開き括弧の入力の際に、閉じ括弧を自動で入力しない
  (setq js2-bounce-indent-flag nil) ;C-i (TAB) 時のインデント変更を抑止

;;http://stackoverflow.com/questions/2370028/emacs-js2-mode-disable-indenting-completely
;;var foo = jQuery('#mycontainer ul li').each(function(el){
;;                                           var bar = el.html();
;; ではなく，
;; var foo = jQuery('#mycontainer ul li').each(function(el){
;;     var bar = el.html();
;; js2-mode supports "bounce" indenting; you can press tab multiple times to choose different likely indenting levels, so you might be able to get the effect you want that way:
  (setq js2-bounce-indent-p t)

  ;インデントの際のカーソル移動を他の major-mode と揃える
  (defun indent-and-back-to-indentation ()
    (interactive)
    (indent-for-tab-command)
    (let ((point-of-indentation
           (save-excursion (back-to-indentation) (point))))
      (skip-chars-forward "\s " point-of-indentation)))

  ;; キーバインドを追加
  (define-key js2-mode-map "\C-i" 'indent-and-back-to-indentation)
  (define-key js2-mode-map (kbd "C-c C-r") 'my-js-eval-region)

  ;; 不要なキーバインドを無効化
  (define-key js2-mode-map (kbd "C-c f") nil)
  (define-key js2-mode-map "\C-m" nil)
  (define-key js2-mode-map (kbd "C-c f") nil)
  (define-key js2-mode-map (kbd "C-e") nil)
  )


;; カスタマイズ項目
(setq js2-strict-trailing-comma-warning nil)
;;
(setq js2-mode-map
  (let ((map (make-sparse-keymap))
        keys)
    (define-key map [mouse-1] #'js2-mode-show-node)
    (define-key map "\C-m" #'js2-enter-key)
    ;; (when js2-rebind-eol-bol-keys
    ;;   (define-key map "\C-a" #'js2-beginning-of-line)
    ;;   (define-key map "\C-e" #'js2-end-of-line))
    (define-key map "\C-c\C-e" #'js2-mode-hide-element)
    (define-key map "\C-c\C-s" #'js2-mode-show-element)
    (define-key map "\C-c\C-a" #'js2-mode-show-all)
    (define-key map "\C-c\C-f" #'js2-mode-toggle-hide-functions)
    (define-key map "\C-c\C-t" #'js2-mode-toggle-hide-comments)
    (define-key map "\C-c\C-o" #'js2-mode-toggle-element)
    (define-key map "\C-c\C-w" #'js2-mode-toggle-warnings-and-errors)
    (define-key map "\C-c\C-w" #'js2-mode-toggle-warnings-and-errors)


    (define-key map (kbd "C-c C-'") #'js2-next-error)
    ;; also define user's preference for next-error, if available
    (if (setq keys (where-is-internal #'next-error))
        (define-key map (car keys) #'js2-next-error))
    (define-key map (or (car (where-is-internal #'mark-defun))
                        (kbd "M-C-h"))
      #'js2-mark-defun)
    (define-key map (or (car (where-is-internal #'narrow-to-defun))
                        (kbd "C-x nd"))
      #'js2-narrow-to-defun)
    (define-key map [down-mouse-3] #'js2-mouse-3)
    ;; (when js2-auto-indent-flag
    ;;   (mapc (lambda (key)
    ;;           (define-key map key #'js2-insert-and-indent))
    ;;         js2-electric-keys))

    (define-key map [menu-bar javascript]
      (cons "JavaScript" (make-sparse-keymap "JavaScript")))

    (define-key map [menu-bar javascript customize-js2-mode]
      '(menu-item "Customize js2-mode" js2-mode-customize
                  :help "Customize the behavior of this mode"))

    (define-key map [menu-bar javascript js2-force-refresh]
      '(menu-item "Force buffer refresh" js2-mode-reset
                  :help "Re-parse the buffer from scratch"))

    (define-key map [menu-bar javascript separator-2]
      '("--"))

    (define-key map [menu-bar javascript next-error]
      '(menu-item "Next warning or error" js2-next-error
                  :enabled (and js2-mode-ast
                                (or (js2-ast-root-errors js2-mode-ast)
                                    (js2-ast-root-warnings js2-mode-ast)))
                  :help "Move to next warning or error"))

    (define-key map [menu-bar javascript display-errors]
      '(menu-item "Show errors and warnings" js2-mode-display-warnings-and-errors
                  :visible (not js2-mode-show-parse-errors)
                  :help "Turn on display of warnings and errors"))

    (define-key map [menu-bar javascript hide-errors]
      '(menu-item "Hide errors and warnings" js2-mode-hide-warnings-and-errors
                  :visible js2-mode-show-parse-errors
                  :help "Turn off display of warnings and errors"))

    (define-key map [menu-bar javascript separator-1]
      '("--"))

    (define-key map [menu-bar javascript js2-toggle-function]
      '(menu-item "Show/collapse element" js2-mode-toggle-element
                  :help "Hide or show function body or comment"))

    (define-key map [menu-bar javascript show-comments]
      '(menu-item "Show block comments" js2-mode-toggle-hide-comments
                  :visible js2-mode-comments-hidden
                  :help "Expand all hidden block comments"))

    (define-key map [menu-bar javascript hide-comments]
      '(menu-item "Hide block comments" js2-mode-toggle-hide-comments
                  :visible (not js2-mode-comments-hidden)
                  :help "Show block comments as /*...*/"))

    (define-key map [menu-bar javascript show-all-functions]
      '(menu-item "Show function bodies" js2-mode-toggle-hide-functions
                  :visible js2-mode-functions-hidden
                  :help "Expand all hidden function bodies"))

    (define-key map [menu-bar javascript hide-all-functions]
      '(menu-item "Hide function bodies" js2-mode-toggle-hide-functions
                  :visible (not js2-mode-functions-hidden)
                  :help "Show {...} for all top-level function bodies"))

    map))



;;;;
;;
;; リージョンの javascript を実行する
;;
;; sudo apt-get install -y rhino
;;
;; var a
;; a = 1 + 3;
;; print(a);
;;
(defun my-js-eval-region ()
  (interactive)
  (unless (executable-find "rhino")
    (error "rhino not found"))
  (when (region-active-p)
    (let ((region-str (buffer-substring-no-properties (region-beginning) (region-end)))
          (result-buf "*js*")
          (temp-file (make-temp-file "my-js-eval-region-")))
      (with-temp-file temp-file
        (insert region-str))
      (shell-command (concat "rhino " temp-file) result-buf)
      (view-buffer-other-window result-buf t
                                (lambda (buf)
                                  (kill-buffer-and-window)
                                  (delete-file temp-file))))))


(defun ecma ()
  (interactive)
  (browse-url "http://www2u.biglobe.ne.jp/~oz-07ams/prog/ecma262r3/"))


(defun mdc-reference ()
  (interactive)
  (browse-url "https://developer.mozilla.org/ja/JavaScript/Reference"))

(defun mdc (word)
  (interactive "ssearch word: \n")
  (browse-url (format "https://developer.mozilla.org/en-US/search?q=%s" word)))



;;moozさん wiki
(setq js2-consistent-level-indent-inner-bracket-p t)
(setq js2-pretty-multiline-decl-indentation-p t)
