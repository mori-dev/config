;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

(require 'ruby-mode)
;; encodingを自動挿入しないようにする
(defun ruby-mode-set-encoding () nil)

(defalias 'r 'indent-region)
(defalias 'rubyf 'indent-region)

(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))

(setq ruby-indent-level 2)
(setq ruby-indent-tabs-mode nil)
(setq ruby-deep-indent-paren-style nil)


;; ;; # -*- coding: utf-8 -*- の自動挿入を抑止
(defun ruby-mode-hook-init ()
  "encodingを自動挿入しないようにする"
  (remove-hook 'before-save-hook 'ruby-mode-set-encoding))
;; (add-hook 'ruby-mode-hook 'ruby-mode-hook-init)

(add-hook 'ruby-mode-hook
  (lambda ()
    (remove-hook 'before-save-hook 'ruby-mode-set-encoding)
    (modify-syntax-entry ?@ "_" ruby-mode-syntax-table)
    (modify-syntax-entry ?: "_" ruby-mode-syntax-table)
    (modify-syntax-entry ?! "_" ruby-mode-syntax-table)
    ))

(defun ruby-custom ()
  "ruby-mode-hook"
 (set (make-local-variable 'tab-width) 2))

(add-hook 'ruby-mode-hook
  '(lambda() (ruby-custom)))




;;rubydb3x.el のロード
(autoload 'rubydb "rubydb3x" "ruby debug t")
;; (install-elisp "http://svn.ruby-lang.org/repos/ruby/trunk/misc/rubydb3x.el")
;; (require 'rubydb)

(defalias 'ruby 'ruby-mode)

(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.js\\.rjs$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.xml\\.builder$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.builder$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.jbuilder$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Guardfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile.lock" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile.lock" . ruby-mode))
(add-to-list 'auto-mode-alist '(".railsrc" . ruby-mode))
(add-to-list 'auto-mode-alist '(".pryrc" . ruby-mode))
(add-to-list 'auto-mode-alist '(".gemspec" . ruby-mode))
(add-to-list 'auto-mode-alist '(".thinreports" . ruby-mode))


;; (add-to-list 'auto-mode-alist '("^Capfile$" . ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))






(defadvice inf-ruby-keys (around my-inf-ruby-keys activate)
  (define-key ruby-mode-map "\M-\C-x" 'ruby-send-definition)
;  (define-key ruby-mode-map "\C-x\C-e" 'ruby-send-last-sexp)
  (define-key ruby-mode-map "\C-c\C-b" 'ruby-send-block)
  (define-key ruby-mode-map "\C-c\M-b" 'ruby-send-block-and-go)
  (define-key ruby-mode-map "\C-c\C-x" 'ruby-send-definition)
  (define-key ruby-mode-map "\C-c\M-x" 'ruby-send-definition-and-go)
  ;; (define-key ruby-mode-map "\C-c\C-r" 'ruby-send-region)
  (define-key ruby-mode-map "\C-c\M-r" 'ruby-send-region-and-go)
  (define-key ruby-mode-map "\C-c\C-z" 'switch-to-ruby)
  (define-key ruby-mode-map "\C-c\C-l" 'ruby-load-file)
  (define-key ruby-mode-map "\C-c\C-s" 'run-ruby)
  (define-key ruby-mode-map (kbd "M-C-f") nil)
  
  (define-key ruby-mode-map (kbd "C-m") 'reindent-then-newline-and-indent)

)

(add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.cgi$" . ruby-mode))


(defun find-rubylib (name)
  (interactive "sRuby library name: ")
  (find-file (ffap-ruby-mode name)))

(require 'ffap)
(add-to-list 'ffap-alist '(ruby-mode . ffap-ruby-mode))

;; require 'xxx' 上で C-x C-f すれば、該当ライブラリを開ける
(defun ffap-ruby-mode (name)
  (shell-command-to-string
   (format "ruby -e 'require %%[rubygems];require %%[devel/which];require %%[%s];
print(which_library(%%[%s]))'" name name)))


(defun my-ruby-eval-region ()
  (interactive)
  (when (region-active-p)
    (let ((region-str (buffer-substring-no-properties (region-beginning) (region-end)))
          (result-buf "*ruby*")
          (temp-file (make-temp-file "my-ruby-eval-region-")))
      (with-temp-file temp-file
        (insert (concat "require \"pp\"" "\n" region-str)))
      (shell-command (concat "ruby " temp-file) result-buf)
      (view-buffer-other-window result-buf t
                                (lambda (buf)
                                  (kill-buffer-and-window)
                                  (delete-file temp-file))))))

(defun my-ruby-backward-up-list ()
  "インデントの深さを基準に駆け上がる"
  (interactive)
  (if (not (eq this-command last-command))
      (back-to-indentation)
    (unless (bolp)
      (let (cn)
        (back-to-indentation)
        (backward-char)
          (while (looking-at " ")
            (setq cn (current-column))
            (previous-line 1)
            (move-to-column cn)))
        (back-to-indentation))))

(defun my-ruby-down-list ()
  "一つ下の行のインデントが現在より深い場合は移動する"
  (interactive)
  (if (not (eq this-command last-command))
      (back-to-indentation)
    (let (cn ncn)
      (save-excursion
        (back-to-indentation)
        (setq cn (current-column))
        (next-line 1)
        (back-to-indentation)
        (setq ncn (current-column)))
      (while (< cn ncn)
        (next-line 1)
        (back-to-indentation)
        (setq cn (current-column))))))

(add-hook 'ruby-mode-hook
  (lambda()
    (define-key ruby-mode-map (kbd "C-M-u") 'my-ruby-backward-up-list)
    (define-key ruby-mode-map (kbd "C-M-d") 'my-ruby-down-list)
    (define-key ruby-mode-map (kbd "C-m") 'reindent-then-newline-and-indent)
    (define-key ruby-mode-map (kbd "M-C-f") nil)
   ))


(setq rurema-search-candidate '("hoge" "fuga"))

;; C-M-n, C-M-p を (),{},[] に対応させる
(defadvice ruby-end-of-block (around my-ruby-end-of-block activate)
  (interactive)
  (if (thing-at-point-looking-at "\(\\|\{\\|\\[")
    (forward-list)
    ad-do-it))

;; C-M-n, C-M-p を (),{},[] に対応させる
(defadvice ruby-beginning-of-block (around my-ruby-beginning-of-block activate)
  (interactive)
  (if (thing-at-point-looking-at "\)\\|\}\\|\\]")
    (backward-list)
    ad-do-it))


(setq anything-refe-index-file-path "~/Dropbox/data/rubyrefm/bitclust/refe.index")
(setq anything-refe-private-dict-path "~/Dropbox/data/rubyrefm/mydict")

;; マニュアル検索
(defvar anything-c-source-refe
      `((name . "refe")
        (candidates-file . ,anything-refe-index-file-path)
        (action ("Insert" . anything-refe-action))))

(defvar anything-c-source-create-refe-item
  '((name . "Create Item")
    (dummy)
    (action . anything-c-source-create-refe-item-action)))

(defun anything-c-source-create-refe-item-action (word)
  (find-file (concat anything-refe-private-dict-path "/" word))
  (with-temp-buffer
    (insert word)
    (let ((buf-str (concat "\n" (buffer-substring-no-properties (point-min) (point-max)))))
      (with-temp-buffer
        (insert buf-str)
        (append-to-file (point-min) (point-max) anything-refe-index-file-path)))))

(defun anything-refe-action (word)
  (if (member word (directory-files anything-refe-private-dict-path))
      (anything-refe-find-file-action word)
    (anything-refe-create-file-action word)))

(defun anything-refe-find-file-action (word)
 (find-file (concat anything-refe-private-dict-path "/" word)))

(defun anything-refe-create-file-action (word)
  (let ((file-path (concat anything-refe-private-dict-path "/" word)))
    (with-temp-buffer
      (call-process "refe" nil t t word)
      (write-region (point-min) (point-max) file-path))
    (find-file file-path)))

(defun anything-refe ()
  (interactive)
  (anything (list anything-c-source-refe anything-c-source-create-refe-item)))


;;old
;; (defun anything-refe-action (word)
;;   (let ((buf-name (concat "*refe:" word "*"))
;;         ;;(coding-system-for-read 'utf-8)
;;         )
;;     (with-current-buffer (get-buffer-create buf-name)
;;       (call-process "refe" nil t t word)
;;       ;; (diff-mode)
;;       (goto-char (point-min))
;;       (my-view-buffer-other-window buf-name t
;;                                 (lambda (dummy)
;;                                   (kill-buffer-and-window))))))

;; (defun anything-refe ()
;;   (interactive)
;;   (anything (list anything-c-source-refe anything-c-source-create-refe-item)))

;; view-buffer-other-window の switch-to-buffer-other-window を switch-to-buffer にしたもの
(defun my-view-buffer-other-window (buffer &optional not-return exit-action)
  (let* ((win               ; This window will be selected by
      (get-lru-window))         ; switch-to-buffer-other-window below.
     (return-to
      (and (not not-return)
           (cons (selected-window)
             (if (eq win (selected-window))
             t          ; Has to make new window.
               (list
            (window-buffer win)     ; Other windows old buffer.
            (window-start win)
            (window-point win)))))))
    (switch-to-buffer buffer) ;変更
    (view-mode-enter (and return-to (cons (selected-window) return-to))
             exit-action)))


(require 'simple)

(add-hook 'ruby-mode-hook
  (lambda()
    (define-key ruby-mode-map (kbd "C-c C-r") 'my-ruby-eval-region)
    (define-key ruby-mode-map [f1] 'anything-refe)
    ;; (gtags-mode 1)
    ;; (setq gtags-symbol-regexp "[A-Za-z_:][A-Za-z0-9_#.:?]*")
    ;; (define-key ruby-mode-map "\e." 'gtags-find-tag)
    ;; (define-key ruby-mode-map "\e," 'gtags-find-with-grep)
    ;; (define-key ruby-mode-map "\e:" 'gtags-find-symbol)
    ;; (define-key ruby-mode-map "\e_" 'gtags-find-rtag))
    ))


;; http://d.hatena.ne.jp/authorNari/20090523/1243051306
;; todo gem install rcodetools
(require 'rcodetools)
(setq rct-find-tag-if-available nil)
(defun ruby-mode-hook-rcodetools ()
  (define-key ruby-mode-map "\M-\C-i" 'rct-complete-symbol)
  (define-key ruby-mode-map "\C-c\C-t" 'ruby-toggle-buffer)
  (define-key ruby-mode-map "\C-c\C-d" 'xmp)
  (define-key ruby-mode-map "\C-c\C-f" 'rct-ri))
(add-hook 'ruby-mode-hook 'ruby-mode-hook-rcodetools)

;; (require 'anything-rcodetools)
;; (setq rct-get-all-methods-command "PAGER=cat fri -l")
;; See docs
;; (define-key anything-map [(control ?;)] 'anything-execute-persistent-action)

(require 'align)

(add-to-list 'align-rules-list
             '(ruby-comma-delimiter
               (regexp . ",\\(\\s-*\\)[^# \t\n]")
               (repeat . t)
               (modes  . '(ruby-mode))))
(add-to-list 'align-rules-list
             '(ruby-hash-literal
               (regexp . "\\(\\s-*\\)=>\\s-*[^# \t\n]")
               (repeat . t)
               (modes  . '(ruby-mode))))
(add-to-list 'align-rules-list
             '(ruby-assignment-literal
               (regexp . "\\(\\s-*\\)=\\s-*[^# \t\n]")
               (repeat . t)
               (modes  . '(ruby-mode))))
(add-to-list 'align-rules-list          ;TODO add to rcodetools.el
             '(ruby-xmpfilter-mark
               (regexp . "\\(\\s-*\\)# => [^#\t\n]")
               (repeat . nil)
               (modes  . '(ruby-mode))))


(defun gemref ()
  "編集中のファイルのプロジェクトで使われているGem情報を表示する"
  (interactive)
  (let* ((command "gemref")
         (buffer "*gemref*"))
    (when (get-buffer buffer)
      (kill-buffer buffer))
    (get-buffer-create buffer)
    (with-temp-directory (gemref-top-dir "Gemfile")
                         (call-process command nil buffer nil))
    (switch-to-buffer buffer)))

(defun gemref-top-dir (name &optional dir)
  (interactive)
  (let ((default-directory (file-name-as-directory (or dir default-directory))))
    (if (file-exists-p name)
        (file-name-directory (expand-file-name name))
      (unless (string= "/" (directory-file-name default-directory))
        (gemref-top-dir name (expand-file-name ".." default-directory))))))

(defmacro* with-temp-directory (dir &body body)
  `(with-temp-buffer
     (cd ,dir)
     ,@body))

(defun rubygems-search ()
  (interactive)
  (let ((word (read-from-minibuffer "search gem:")))
    (browse-url (format "https://rubygems.org/search?query=%s" word))))

(defalias 'ruby-gems-search 'rubygems-search)
