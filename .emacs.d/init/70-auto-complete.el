;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

(defalias 'ac 'auto-complete-mode)
(defalias 'a 'auto-complete-mode)


;; ;; js2-mode
;; (defun my-ac-js2-mode ()
;;   (setq ac-sources '(ac-source-words-in-same-mode-buffers ac-source-dictionary ac-source-etags)))
;; (add-hook 'js2-mode-hook 'my-ac-js2-mode)

;; (defun my-js2-init ()
;;   (when (member (file-name-extension buffer-file-name) '("js"))
;;     (auto-complete-mode t)
;;     (setq ac-sources '(ac-source-words-in-same-mode-buffers ac-source-dictionary ac-source-gtags))))

;; (add-hook 'find-file-hook 'my-js2-init)








;; (make-variable-buffer-local 'ac-etags-candidates)
;; (ac-define-source etags
;;   '((init . ac-etags-init)
;;     (candidates . ac-etags-candidates)
;;     (candidate-face . ac-etags-candidate-face)
;;     (selection-face . ac-etags-selection-face)
;;     (symbol . "t")))

;; (defun ac-etags-init ()
;;   (let ((tags-file (ac-etags-find-tags-file)))
;;     (when (ac-etags-file-valid-p tags-file)
;;       (ac-etags-visit-tags-table-buffer tags-file)
;;       ;; (setq ac-etags-candidates (ac-etags-make-candidates)))))
;;       (setq-default ac-etags-candidates (ac-etags-make-candidates)))))

;; ;; these functions are copied from anything-yaetags.el
;; ;;   http://www.emacswiki.org/cgi-bin/wiki/anything-yaetags.el

;; (defun ac-etags-find-tags-file (&optional dir)
;;   "Find TAGS file from DIR upward to upper directories.
;; Return file path, when TAGS file is found."
;;   (setq dir (file-name-as-directory (or dir default-directory)))
;;   (let ((name anything-yaetags-tags-file-name))
;;     (cond
;;      ((string= dir (directory-file-name dir))
;;       nil)
;;      ((file-exists-p (expand-file-name name dir))
;;       (file-truename (expand-file-name name dir)))
;;      (t
;;       (anything-yaetags-find-tags-file (expand-file-name ".." dir))))))

;; (defun ac-etags-file-valid-p (tags-file)
;;   "Return non-nil if TAGS-FILE is valid."
;;   (and tags-file
;;        (file-exists-p tags-file)
;;        (file-regular-p tags-file)))

;; (defun ac-etags-visit-tags-table-buffer (tags-file)
;;   "Visit tags buffer, but disable user prompting."
;;   (let ((tags-add-tables t)
;;      (tags-revert-without-query t)
;;      (large-file-warning-threshold nil))
;;     (visit-tags-table-buffer tags-file)))

;; (defun ac-etags-make-candidates ()
;;   "Make tag candidates from current TAGS buffer.
;; We don't use `etags-tags-completion-table', because this function is faster than `etags-tags-completion-table'."
;;   (save-excursion
;;     (let ((tab (make-hash-table :test 'equal :size 511)))
;;       (let ((reporter
;;           (make-progress-reporter
;;            (format "Making candidates for %s..." buffer-file-name)
;;            (point-min) (point-max))))
;;      (goto-char (point-min))
;;      (while (re-search-forward "\^?\\(.+\\)\^a" nil t)
;;        (puthash (match-string-no-properties 1) t tab)
;;        (progress-reporter-update reporter (point)))
;;       (let ((msg (format "Sorting candidates for %s..." buffer-file-name))
;;          list)
;;      (message "%s" msg)
;;      (maphash (lambda (key value) (push key list))
;;           tab)
;;      (prog1
;;          (sort list
;;            (lambda (a b)
;;              (let ((cmp (compare-strings a 0 nil b 0 nil t)))
;;                (if (eq cmp t)
;;                (string< a b)
;;              (< cmp 0)))))
;;        (message "%sdone" msg)))))))

;; (defun ac-etags-visit-tags-table  (tags-file &optional rebuild-p)
;;   "Make tag candidates from current TAGS buffer.
;; We don't use `etags-tags-completion-table', because this function is faster than `etags-tags-completion-table'."
;;   (save-excursion
;;     (let ((tab (make-hash-table :test 'equal :size 511)))
;;       (let ((reporter
;;           (make-progress-reporter
;;            (format "Making candidates for %s..." buffer-file-name)
;;            (point-min) (point-max))))
;;      (goto-char (point-min))
;;      (while (re-search-forward "\^?\\(.+\\)\^a" nil t)
;;        (puthash (match-string-no-properties 1) t tab)
;;        (progress-reporter-update reporter (point)))
;;       (let ((msg (format "Sorting candidates for %s..." buffer-file-name))
;;          list)
;;      (message "%s" msg)
;;      (maphash (lambda (key value) (push key list))
;;           tab)
;;      (prog1
;;          (sort list
;;            (lambda (a b)
;;              (let ((cmp (compare-strings a 0 nil b 0 nil t)))
;;                (if (eq cmp t)
;;                (string< a b)
;;              (< cmp 0)))))
;;        (message "%sdone" msg)))))))


(ac-define-source etags
  '((init . ac-etags-init)
    (candidates . ac-etags-candidates)
    (candidate-face . ac-etags-candidate-face)
    (selection-face . ac-etags-selection-face)
    (cache)
    (requires . 1)
    (symbol . "t")))

(defun ac-etags-init ()
         ;; (setq tags-file-name "/home/me/d/dev/django/ajax/ajax_sample/TAGS"))
         (setq tags-file-name (ac-etags-find-tags-file)))

(defun ac-etags-candidates ()
  (all-completions ac-target (tags-completion-table)))

(defun ac-etags-find-tags-file ()
  "Find TAGS file from DIR upward to upper directories.
Return file path, when TAGS file is found."
  (let ((name "TAGS")
        (dir (file-name-as-directory default-directory)))
    (cond
     ((string= dir (directory-file-name dir))
      nil)
     ((file-exists-p (expand-file-name name dir))
      (file-truename (expand-file-name name dir)))
     (t
      (ac-etags-find-tags-file (expand-file-name ".." dir))))))

(setq auto-complete-dict-path "~/Dropbox/data/ac-dict/")
(setq ac-dictionary-directories '("~/Dropbox/data/ac-dict"))
;; (add-to-list 'ac-dictionary-directories "~/.emacs.d/elisp/auto-complete/dict")


(require 'auto-complete-config)
(ac-config-default)
;; 全てのバッファの`ac-sources`の末尾に辞書情報源を追加
(defun ac-common-setup ()
  (setq ac-sources (append ac-sources '(ac-source-dictionary))))

;; (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)

(eval-after-load "key-chord"
  '(progn
     (key-chord-define-global "jk" 'auto-complete) ;曖昧マッチ
     ))

;; popup-isearch は，C-s

;; 辞書の設定
;; M-x ac-clear-dictionary-cache
(fset 'ac-cc 'ac-clear-dictionary-cache)
(setq ac-user-dictionary-files "~/.emacs.d/elisp/auto-complete/auto-complete.dict")

(setq ac-auto-start 3)

;; 0.6秒後に自動で表示
(setq ac-auto-show-menu 0.6)

;; ac-menu-mapは補完メニューが表示されているときに利用されるキーマップで、ac-use-menu-mapがtのときに有効になります。
(setq ac-use-menu-map t)
(define-key ac-menu-map "\C-n" 'ac-next)
(define-key ac-menu-map "\C-p" 'ac-previous)

;; 20行分表示
(setq ac-menu-height 20)


;; 大文字・小文字を区別しない
(setq ac-ignore-case t)

(add-to-list 'ac-modes 'yaml-mode)
(add-to-list 'ac-modes 'coffee-mode)
(add-to-list 'ac-modes 'scss-mode)

;; C-c /でファイル名補完
(global-set-key (kbd "C-c /") 'ac-complete-filename)
(global-set-key (kbd "M-\\") 'ac-complete-filename)

;; リージョンを開いているバッファのメジャーモードの辞書へ追加する
(defvar auto-complete-dict-path "~/.emacs.d/elisp/auto-complete/dict/")

(defun append-region-to-auto-complete-dict ()
  (interactive)
  (let ((auto-complete-dict-path+major-mode (concat auto-complete-dict-path (prin1-to-string major-mode)))
        (buf-str (concat "\n" (buffer-substring-no-properties (region-beginning) (region-end)))))
    (with-temp-buffer
      (insert buf-str)
      (append-to-file (point-min) (point-max) auto-complete-dict-path+major-mode))))

(global-set-key (kbd "M-7") 'append-region-to-auto-complete-dict)

;; php-mode
(defun my-ac-php-mode ()
  (setq ac-sources '(ac-source-words-in-same-mode-buffers ac-source-dictionary ac-source-gtags)))
(add-hook 'php-mode-hook 'my-ac-php-mode)


(add-hook 'auto-complete-mode-hook 'ac-common-setup)
;; rhtml-mode
;; (defun my-ac-rhtml-mode ()
;;   (auto-complete-mode t)
;;   (setq ac-sources '(ac-source-words-in-same-mode-buffers ac-source-dictionary ac-source-gtags)))
;; (add-hook 'rhtml-mode-hook 'my-ac-rhtml-mode)

(defun my-rhtml-init ()
  (when (member (file-name-extension buffer-file-name) '("erb" "rhtml"))
    (auto-complete-mode t)
    (setq ac-sources '(ac-source-words-in-same-mode-buffers ac-source-dictionary ac-source-gtags))))

(add-hook 'find-file-hook 'my-rhtml-init)



(defface ac-etags-candidate-face
  '((t (:background "gainsboro" :foreground "deep sky blue")))
  "Face for etags candidate")

(defface ac-etags-selection-face
  '((t (:background "deep sky blue" :foreground "white")))
  "Face for the etags selected candidate.")

;; (defun ac-source-etags-init ()
;;   (unless tags-file-name
;;          ;; (setq tags-file-name "/home/mrkz/d/dev/django/ajax/ajax_sample/TAGS"))
;;          (setq tags-file-name (anything-yaetags-find-tags-file)))
;;   )

;; (setq ac-source-etags
;;       '((candidates . (lambda ()
;;                         (all-completions ac-target (tags-completion-table))))
;;         (candidate-face . ac-etags-candidate-face)
;;         (selection-face . ac-etags-selection-face)
;;         (requires . 1)))

;; (setq ac-source-etags
;;   '((init . ac-source-etags-init)
;;     (candidates . (lambda ()
;;          (all-completions ac-target (tags-completion-table))))
;;     (candidate-face . ac-etags-candidate-face)
;;     (selection-face . ac-etags-selection-face)
;;     (requires . 1)))

;; python-mode

(defface ac-etags-candidate-face
  '((t (:background "lightgray" :foreground "navy")))
  "Face for etags candidate"
  :group 'auto-complete)

(defface ac-etags-selection-face
  '((t (:background "navy" :foreground "white")))
  "Face for the etags selected candidate."
  :group 'auto-complete)

;; (setq ac-source-etags
;;       '((init . ac-source-etags-init)
;;         (candidates . ac-source-etags-candidates)
;;         (cache)
;;         (symbol . "t")
;;         (requires . 1)))

(ac-define-source etags
  '((init . ac-etags-init)
    (candidates . ac-etags-candidates)
    (candidate-face . ac-etags-candidate-face)
    (selection-face . ac-etags-selection-face)
    (cache)
    (requires . 1)
    (symbol . "t")))

(defun ac-etags-init ()
         ;; (setq tags-file-name "/home/mrkz/d/dev/django/ajax/ajax_sample/TAGS"))
         (make-variable-buffer-local 'tags-file-name)
         (setq-default tags-file-name (ac-etags-find-tags-file)))

(defun ac-etags-candidates ()
  (unless tags-file-name
    (setq tags-file-name (ac-etags-find-tags-file)))
  (all-completions ac-target (tags-completion-table)))

(defun ac-etags-find-tags-file ()
  "Find TAGS file from DIR upward to upper directories.
Return file path, when TAGS file is found."
  (let ((name "TAGS")
        (dir (file-name-as-directory default-directory)))
    (cond
     ((string= dir (directory-file-name dir))
      nil)
     ((file-exists-p (expand-file-name name dir))
      (file-truename (expand-file-name name dir)))
     (t
      (ac-etags-find-tags-file (expand-file-name ".." dir))))))

(defun my-ac-python-mode ()
  (setq ac-sources '(ac-source-words-in-same-mode-buffers ac-source-dictionary))
  ;; (setq ac-sources '(ac-source-etags))
  )
(add-hook 'python-mode-hook 'my-ac-python-mode)
(add-hook 'django-mode-hook 'my-ac-python-mode)






;; org-mode;
(defun my-ac-org-mode ()
  (setq ac-sources '(ac-source-filename ac-source-words-in-same-mode-buffers ac-source-dictionary)))
(add-hook 'org-mode-hook 'my-ac-org-mode)



;; 特定の単語を入力したら補完を自動的に中止する
(add-hook 'php-mode-hook
          (lambda ()
            (make-local-variable 'ac-auto-start)
            ;; (make-variable-buffer-local 'ac-auto-start)
            (setq ac-auto-start 3)
            (make-local-variable 'ac-ignores)
            ;; (make-variable-buffer-local 'ac-ignores)
            (add-to-list 'ac-ignores "<?php")
            ))

;; (add-hook 'php-mode-hook
;;           (make-variable-buffer-local ac-auto-start)
;;           (setq ac-auto-start 4)
;;           )

(define-key ac-mode-map (kbd "C-c h") 'ac-last-quick-help)
(define-key ac-mode-map (kbd "C-c H") 'ac-last-help)



;; 参考URL

;; (require 'auto-complete)
;; (require 'auto-complete-config)
;; ;(require 'popup)
;; (ac-config-default)
;; ;; クイックヘルプ
;; (setq ac-use-quick-help t)
;; (setq ac-quick-help-delay 1)

;; ;(require 'pos-tip)

;; (global-auto-complete-mode t)

;; (setq ac-modes
;;   '(inferior-gauche-mode
;;     lisp-mode
;;     wl-draft-mode
;;    ;slime-mode
;;     slime-repl-mode
;;     scheme-mode
;;     gauche-mode
;;     emacs-lisp-mode
;;     lisp-interaction-mode
;;     c-mode cc-mode c++-mode java-mode
;;     perl-mode cperl-mode python-mode ruby-mode
;;     ecmascript-mode javascript-mode js2-mode php-mode css-mode
;;     makefile-mode sh-mode fortran-mode f90-mode ada-mode
;;     xml-mode sgml-mode))

;; ;(setq ac-auto-start nil);; 自動的に開始しない
;; ;(ac-set-trigger-key "TAB") ;; コンテキストに応じてTABで補完

;; ;; auto-complete利用時にcandidateに日本語が含まれないようにする。
;; ;; (require 'cl)
;; ;; (defadvice ac-candidate-words-in-buffer (after remove-word-contain-japanese activate)
;; ;;   (let ((contain-japanese (lambda (s) (string-match (rx (category japanese)) s))))
;; ;;     (setq ad-return-value
;; ;;           (remove-if contain-japanese ad-return-value))))


;; (setq-default ac-sources '(ac-source-words-in-same-mode-buffers))


;; (remove-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)
;; (add-hook 'emacs-lisp-mode-hook
;;           (lambda ()
;;             (setq ac-sources
;;                   '(ac-source-features
;;                     ac-source-functions
;;                     ;ac-source-yasnippet
;;                     ac-source-variables
;;                     ac-source-symbols))))



;; (add-hook 'emacs-lisp-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-symbols)))
;; (add-hook 'auto-complete-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-filename)))

;; ;; 色の設定
;; (set-face-background 'ac-candidate-face "lightgray")
;; (set-face-underline 'ac-candidate-face "darkgray")
;; (set-face-background 'ac-selection-face "steelblue")

;; (define-key ac-completing-map "\C-n" 'ac-next)
;; (define-key ac-completing-map "\C-p" 'ac-previous)
;; (define-key ac-completing-map "\r" 'ac-complete)

;; (setq ac-auto-start 3)
;; (setq ac-dwim t)

;; (push 'ac-source-filename ac-sources)

;; (setq ac-gtags-modes
;;   '(c-mode cc-mode c++-mode java-mode php-mode))


;; (setq ac-candidate-limit 50)
;; (setq ac-menu-height 50)
;; (setq ac-candidates-cache t)
;; (setq ac-limit 4)

;; ;(add-hook  'js2-mode-hook
;; ;           (lambda ()
;; ;             (when (require 'auto-complete nil t)
;; ;               (make-variable-buffer-local 'ac-sources)
;; ;               (setq ac-sources '(;ac-source-words-in-all-buffer
;; ;                                  ac-source-words-in-same-mode-buffers
;; ;                                  ac-source-js
;; ;                                  ))
;; ;               (auto-complete-mode t))))

;; ;; (add-hook 'js2-mode-hook
;; ;;           (lambda ()
;; ;;             (make-local-variable 'ac-sources)
;; ;;             (setq ac-sources (append ac-sources '(ac-source-javascript)))))

;; ;; scheme-mode-hook
;; (setq my-ac-source-scheme
;;  '((candidates
;;     . (lambda ()
;;         (require 'scheme-complete)
;;         (all-completions ac-target (car (scheme-current-env)))))))

;; (add-hook 'inferior-gauche-mode-hook
;;          '(lambda ()
;;             (make-local-variable 'ac-sources)
;;             (setq ac-sources (append ac-sources '(my-ac-source-scheme)))))

;; (add-hook 'gauche-mode-hook
;;          '(lambda ()
;;             (make-local-variable 'ac-sources)
;;             (setq ac-sources (append ac-sources '(my-ac-source-scheme)))))

;; (add-hook 'scheme-mode-hook
;;          '(lambda ()
;;             (make-local-variable 'ac-sources)
;;             (setq ac-sources (append ac-sources '(my-ac-source-scheme)))))


;; ac-modes

(add-to-list 'ac-modes 'lisp-mode)



;; ;; 虎の巻

;; ;; Git によるインストール

;; ;; git clone git://github.com/m2ym..../auto-complete.git
;; ;; cd auto-complete
;; ;; git checkout v1.0
;; ;; emacs -L . -batch -f batch-byte-compile *.el
;; ;; cp *.el{,c} ~/.emacs.d

;; ;; ** ac-expand
;; ;;  共通部分展開、補完/次候補選択という３つの動作を必要に応じて行う
;; ;; 最初のac-expand で共通部分展開、以降が補完/次候補選択.
;; ;; 次候補選択では、選択された候補がすでに展開されている場合は次の候補を選択して展開します。つまり連続してタブを押すことで、次々と候補を選択していくことができます。
;; ;; ac-dwim が t でなおかつ候補が１つの場合、ac-expand は選択された候補を補完して補完を終了します。
;; ;; ** ac-complete
;; ;; ac-completeは選択された候補を展開して補完（アクション）を実行します。ac-expand との違いは、共通部分展開がないこと、即座に補完が終了することです。
;; ;; アクションは来月解説するとのこと.

;; ;;
;; ;; ac-sources はバッファローカル変数.
;; ;; 共通の設定は、setq-default で行う。
;; ;; 個別の設定例
;; ;; (add-hook 'ruby-mode-hook
;; ;;           (lambda ()
;; ;;             (add-to-list 'ac-sources 'ac-source-abbrev)))
(add-hook 'ruby-mode-hook
          (lambda ()
            (setq-default ac-sources
                          '(ac-source-abbrev
                            ac-source-dictionary
                            ac-source-words-in-same-mode-buffers
                            ac-source-gtags))))

;; (add-hook 'coffee-mode-hook
;;           (lambda ()
;;             (when (member (file-name-extension buffer-file-name) '("coffee"))
;;               (auto-complete-mode t)
;;               (setq ac-sources '(ac-source-words-in-same-mode-buffers ac-source-dictionary ac-source-gtags)))))
            



;; ;; ファイル名補完の情報源ではオムニ補完という機構を利用している.
;; ;; オムニ補完とは、「書式/構文を解析することにより実現する賢い補完機能」
;; ;;
;; ;; ac-source-filename をできるだけ ac-sources の先頭に持ってくる設定
;; ;; (add-hook 'auto-complete-mode-hook
;; ;;           (lambda ()
;; ;;             (add-to-list 'ac-sources 'ac-source-filename)))

;; ;; ac-dwim
;; ;; -一つしか候補がない場合にTAB (ac-expand)すると補完を完了する (ac-complete)
;; ;; -次候補/前候補を選んだ後にTAB (ac-expand) すると補完を完了する (ac-complete)
;; ;; -補完後にメニューを自動的に非表示にする

;; ;; (defvar ac-source-sample
;; ;;   '((init . 初期化式)
;; ;;     (candidates . 候補生成式)
;; ;;     (action . 候補選択時アクション)
;; ;;     (prefix . 補完開始条件)
;; ;;     (cache)))

;; ;; 行単位で単語が定義された辞書ファイルを読み込む
;; (defun load-dictionary (file)
;;   (let (dict)
;;     (with-temp-buffer
;;       (insert-file-contents file)
;;       (goto-char (point-min))
;;       (while (not (eobp))
;;         (push (buffer-substring
;;                (line-beginning-position)
;;                (line-end-position))
;;               dict)
;;         (forward-line 1)))
;;     (nreverse dict)))

;; ;(defvar my-dict (load-dictionary "~/.emacs.d/elisp/auto-complete10/dict/javascript+DOM"))

;; ;; (defvar ac-source-my-dict
;; ;;   '((candidate . my-dict)))

;; ;; 辞書を情報源の定義に読み込む
;; ;; (defvar ac-source-my-dict
;; ;;   '((candidates . (list "aa" "bb"))))


(require 'auto-complete-config)

;; (define-key ctl-q-map (kbd "C-i") 'ac-complete-look)

(defun my-ac-look ()
  "look コマンドの出力をリストで返す"
  (interactive)
  (unless (executable-find "look")
    (error "look コマンドがありません"))
  (let ((search-word (thing-at-point 'word)))
    (with-temp-buffer
      (call-process-shell-command "look" nil t 0 search-word)
      (split-string-and-unquote (buffer-string) "\n"))))

(defun ac-complete-look ()
  (interactive)
  (let ((ac-menu-height 50)
        (ac-candidate-limit t))

  (auto-complete '(ac-source-look))))
(global-set-key (kbd "C-o") 'ac-complete-look)

(defvar ac-source-look
  '((candidates . my-ac-look)
    (requires . 2)))  ;; 2文字以上ある場合にのみ対応させる

;;(global-set-key (kbd "M-e") 'ac-complete-look)
;;C-q C-q に割り当てた
;;(define-key ctl-q-map (kbd "C-i") 'ac-complete-look)


;; (setq ac-source-dictionary
;; '((candidates . ac-dictionary-candidates)
;;   (match . substring)
;;   (symbol . "d")))


(require 'auto-complete-config)

(defun my-ac-look ()
  "look コマンドの出力をリストで返す"
  (interactive)
  (unless (executable-find "look")
    (error "look コマンドがありません"))
  (let ((search-word (thing-at-point 'word)))
    (with-temp-buffer
      (call-process-shell-command "look" nil t 0 search-word)
      (split-string-and-unquote (buffer-string) "\n"))))

(defun ac-complete-look ()
  (interactive)
  (let ((ac-menu-height 50)
        (ac-candidate-limit t))
  (auto-complete '(ac-source-look))))

;; 表示数制限を変更しない場合
;;(defun ac-complete-look ()
;;  (interactive)
;;  (auto-complete '(ac-source-look)))

(defvar ac-source-look
  '((candidates . my-ac-look)
    (requires . 2)))  ;; 2文字以上ある場合にのみ対応させる

;; キーは好きなのを割り当てて下さい
;; (global-set-key (kbd "M-h") 'ac-complete-look)
(when (require 'key-chord nil t)
  (key-chord-define-global "dn" 'ac-complete-look))
