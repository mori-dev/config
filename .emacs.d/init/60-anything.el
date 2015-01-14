;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; anything-follow-mode: automatical execution of persistent-action (C-c C-f)
;;   C-c C-k: `anything-kill-selection-and-quit'

;; anything
(require 'anything)
(require 'anything-config)
(require 'anything-match-plugin)

(setq candidate-number-limit 10000)
;; anything 起動中に anything を実行するのを防ぐ。
(define-key anything-map (kbd "C-l") 'abort-recursive-edit)

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward)

(eval-after-load "anything"
  '(define-key anything-map (kbd "C-h") 'delete-backward-char))

;; 縦分割に変更
(defun anything-default-display-buffer (buf)
  (if anything-samewindow
      (switch-to-buffer buf)
    (progn
      (delete-other-windows)
      (split-window (selected-window) nil t)
      ;(split-window-horizontally)
      (pop-to-buffer buf))))

;; anyting-c-source-buffer+ の非表示リストの変更
;; (setq anything-c-boring-buffer-regexp
;; "\\(\\` \\)\\|\\*anything\\|\\*Echo Area\\|\\*Minibuf\\|\\*WoMan-Log\\*\\|\\*Completions\\|TAGS\\|\\Map_Sym\\|\\.howm-keys\\|\\.bm-repository\\|\\.revive.el\\|\\.ipa")

(setq anything-c-boring-buffer-regexp
  (rx (or (group bos  " ")
       ;; anything-buffer
       "*anything"
       ;; echo area
       " *Echo Area"
       " *Minibuf"
       "*WoMan-Log*"
       "*Completions"
       "TAGS"
       "Map_Sym"
       ".howm-keys"
       ".bm-repository"
       ".revive.el"
       ".ipa")))

;; anything-c-source-files-in-current-dir+ 用

;; test
;; (set-face-foreground 'anything-file-name "dark salmon")
;; (set-face-foreground 'anything-dir-priv "LightCyan4")
;; (set-face-background 'anything-dir-priv "Black")
;; (set-face-underline 'anything-dir-priv "light slate gray")


;;;; パラメータの設定
(setq anything-scroll-amount 1)                ; スクロールをなめらかに -> 効いていない
(setq kill-ring-max 80)                        ;kill-ringの最大値。デフォルトは30
(setq anything-kill-ring-threshold 4)          ;kill-ring に追加する長さの最小値.defaultは10
(setq anything-gtags-enable-initial-pattern t) ;thing-at-point する
(setq truncate-partial-width-windows nil)      ;t なら縦分割で anything を起動している場合の改行を防ぐ
;; "Maximum number of candidates stored for a source."
;; (setq anything-c-adaptive-history-file "~/anything-c-adaptive-history")
;; (setq anything-c-adaptive-history-length 50)
;; ;;;; anything-sources の設定

(setq anything-sources nil)   ; anything-sources の初期化

;; ;;必須の情報源

(add-to-list 'anything-sources 'anything-c-source-buffers+-howm-title t)

;; (setq anything-sources nil)
;; (add-to-list 'anything-sources 'anything-c-source-buffers t)


;; (add-to-list 'anything-sources 'anything-c-source-buffers+ t)
;; ;;(add-to-list 'anything-sources 'anything-c-source-file-name-history t)
(add-to-list 'anything-sources 'anything-c-source-recentf t)
;; (add-to-list 'anything-sources 'anything-c-source-files-in-current-dir++ t)
;; ;(add-to-list 'anything-sources 'nym:anything-find-file t)
(add-to-list 'anything-sources 'anything-c-source-mx t)
(add-to-list 'anything-sources 'anything-c-source-files-in-current-dir+ t)



;;;; キーバインドの設定

(global-set-key (kbd "C-l") 'anything)
(global-set-key (kbd "M-y") 'anything-show-kill-ring)

;(global-set-key (kbd "C-s") 'anything-c-moccur-isearch-forward) ;isearch-forward の替わり
;(global-set-key (kbd "C-r") 'anything-c-moccur-isearch-backward) ;isearch-backward の替わり
;; (global-set-key "\C-xr" 'anything-resume)
(define-key anything-map (kbd "C-M-n") 'anything-next-source) ;情報元ごとの次へ
(define-key anything-map (kbd "C-M-p") 'anything-previous-source) ;情報元ごとの前へ
(define-key anything-map (kbd "C-r") 'anything-execute-persistent-action)
(define-key anything-map (kbd "C-M-d") 'anything-execute-persistent-action-2)
;(define-key anything-map (kbd "C-M-c") 'anything-follow-mode)

;; key-chord で設定しているキーバインド
(eval-after-load "key-chord"
  '(progn
     (key-chord-define-global "db" 'describe-bindings)
     (key-chord-define-global "r4" 'anything-resume)
     ;(key-chord-define-global "de" 'anything-dabbrev-expand)
     (key-chord-define-global "jk" 'ac-complete-with-anything)
     ;(key-chord-define-global "PP" 'anything-project)
     ;(key-chord-define-global "SS" 'anything-c-moccur-isearch-forward)
     ;(key-chord-define-global "RR" 'anything-c-moccur-isearch-backward)))
     ;(key-chord-define-global "9i" 'anything-gtags-yaetags)
     ))

;; ;;試用
;; (defun anything-etags-and-gtags-select ()
;;   "Tag jump using etags, gtags and `anything'."
;;   (interactive)
;;   (let* ((initial-pattern (regexp-quote (or (thing-at-point 'symbol) ""))))
;;     (anything (list anything-c-source-gtags-select
;;                      anything-c-source-etags-select)
;;               (if anything-gtags-enable-initial-pattern initial-pattern)
;;               ;(if (or anything-etags-enable-initial-pattern anything-gtags-enable-initial-pattern) initial-pattern)
;;              "Find Tag: " nil)))


;; ;; t は無限
;; (setq history-length t)
;; ;; (defvar anyting-c-source-file-name-history+-length 300)
;; ;; (defvar anything-c-source-file-name-history+-persistent-buffer "*anything-file-history+*")

;; ;; (setq anything-c-source-file-name-history+
;; ;;   '((name . "File Name History+")
;; ;;     (candidates . (lambda ()
;; ;;                     (anything-c-source-cut-file-name-history+
;; ;;                      anyting-c-source-file-name-history+-length
;; ;;                      file-name-history)))
;; ;;     (match anything-c-match-on-file-name
;; ;;            anything-c-match-on-directory-name)
;; ;;     (type . file)
;; ;;     (candidate-number-limit . 9999)
;; ;;     (persistent-action . (lambda (candidate)
;; ;;                            (anything-c-source-file-name-history+-persistent-action
;; ;;                             candidate)))))

;; ;; (defun anything-c-source-file-name-history+-persistent-action (candidate)
;; ;;   (let ((b (get-buffer-create anything-c-source-file-name-history+-persistent-buffer)))
;; ;;       (with-current-buffer b
;; ;;         (erase-buffer)
;; ;;         (insert-file-contents candidate)
;; ;;         (goto-char (point-min)))
;; ;;       (pop-to-buffer b)))

;; ;; (defun anything-c-source-cut-file-name-history+ (n lst)
;; ;;   (if (or (>= 0 n) (null lst)) nil
;; ;;     (cons (car lst)
;; ;;           (anything-c-source-cut-file-name-history+ (- n 1) (cdr lst)))))


;; ;(add-to-list 'anything-sources 'anything-c-source-gtags-select t)
;; ;(add-to-list 'anything-sources 'anything-c-source-yaetags-select t)
;; ;(add-to-list 'anything-sources 'anything-etags-c-source-etags-select t)
;; ;(add-to-list 'anything-sources 'anything-c-source-etags-select t)
;; ;(add-to-list 'anything-sources 'anything-c-source-imenu t)
;; ;(add-to-list 'anything-sources 'anything-c-source-imenu-history t)

;; ;; 割と使う情報源
;; ;; (add-to-list 'anything-sources 'anything-c-source-emacs-functions-with-abbrevs t)
;; ;; (add-to-list 'anything-sources 'anything-c-source-emacs-commands t)
;; ;; (add-to-list 'anything-sources 'anything-c-source-emacs-variables t)
;; ;(add-to-list 'anything-sources 'anything-c-source-lisp-complete-symbol t)
;; ;(add-to-list 'anything-sources 'anything-c-source-locate t)
;; ;(add-to-list 'anything-sources 'anything-c-source-shell-history t)

;; ;; ユーティリティ情報源

;; ;(add-to-list 'anything-sources 'anything-c-source-man-pages t)
;; (add-to-list 'anything-sources 'anything-c-source-goto-line t)
;; ;; (add-to-list 'anything-sources 'anything-c-source-shell-history t)
;; ;; (add-to-list 'anything-sources 'anything-c-source-shell-command t)
;; ;; (add-to-list 'anything-sources 'anything-c-source-projects-history t)
;; ;; (add-to-list 'anything-sources 'anything-c-source-buffer-not-found t)

;; ;; (add-to-list 'anything-sources 'anything-c-source-files-in-emacs-dir t)
;; ;; (add-to-list 'anything-sources 'anything-c-source-files-in-emacs/conf-dir t)
;; ;; (add-to-list 'anything-sources 'anything-c-source-files-in-emacs/elisp-dir t)

;; ;; (defun anything-xfonts ()
;; ;;   "Show `xfonts'."
;; ;;   (interactive)
;; ;;   (anything (list anything-c-source-xfonts) nil nil nil nil "*xfonts*"))

;; ;; (defun anything-commands-and-options-in-file ()
;; ;;   "Show `commands-and-options-in-file'."
;; ;;   (interactive)
;; ;;   (anything (list anything-c-source-commands-and-options-in-file) nil nil nil nil "*commands-and-options-in-file*"))

;; (defvar anything-c-source-goto-line
;;   '((name . "Goto line")
;;     (dummy)
;;     (action . (lambda (c)
;;                 (goto-line (string-to-number c))))))


;; ;; (requires-pattern . 3) を削除
(defun anything-face ()
  "Show `imenu-history'."
  (interactive)
  (anything 'anything-c-source-customize-face nil nil nil nil "*anything face*"))

(setq anything-c-source-customize-face
  '((name . "Customize Face")
    (init . (lambda ()
              (unless (anything-candidate-buffer)
                (save-window-excursion (list-faces-display))
                (anything-candidate-buffer (get-buffer "*Faces*")))))
    (candidates-in-buffer)
    (get-line . buffer-substring)
    (action . (lambda (line)
                (customize-face (intern (car (split-string line))))))))

;; (defun anything-mark-ring ()
;;   "Show `mark-ring'."
;;   (interactive)
;;   (if (mark)
;;     (anything '(anything-c-source-global-mark-ring anything-c-source-mark-ring) nil nil nil nil "*anything mark-ring*"))
;;   (message "mark が一つもセットされていません"))

;; (defun anything-mark-ring ()
;;   "Show `mark-ring'."
;;   (interactive)
;;   (if (mark)
;;     (anything (list
;;                anything-c-source-mark-ring
;;                anything-c-source-global-mark-ring
;;                )
;;                nil nil nil nil "*anything mark-ring*"))
;;   (message "mark が一つもセットされていません"))

;; (global-set-key (kbd "M-\-") 'anything-mark-ring)

;; (defun anything-register ()
;;   "Show `register'."
;;   (interactive)
;;   (anything 'anything-c-source-register nil nil nil nil "*anything register*"))

;; ;; (anything 'anything-c-source-register)

(defun anything-elisp-infomation ()
  "elisp の関数、コマンド、変数のソース"
  (interactive)
  (anything (list
             anything-c-source-emacs-functions
             ;; anything-c-source-emacs-functions-with-abbrevs
             ;; anything-c-source-emacs-commands
             anything-c-source-emacs-variables
             )
            nil nil nil nil "*elisp-info*"))



(global-set-key (kbd "M-1") 'anything-elisp-infomation)

;; gtags-yaetags
;; (defun anything-gtags-yaetags ()
;;   "gtags,etags"
;;   (interactive)
;;   (anything (list
;;              anything-c-source-gtags-select
;;              anything-c-source-yaetags-select
;;              )
;;             (regexp-quote (or (thing-at-point 'symbol) ""))
;;             "pattern:"
;;             nil nil "*gtags-yaetag*"))
;; (defun anything-gtags-yaetags ()
;;   "gtags,etags"
;;   (interactive)
;;   (anything (list
;;              anything-c-source-gtags-select
;;              anything-c-source-yaetags-select
;;              ;; anything-c-source-yaetags-select2
;;              )
;;             (regexp-quote (or (thing-at-point 'symbol) ""))
;;             "pattern:"
;;             nil nil "*gtags-yaetag*"))


(defun anything-gtags-yaetags ()
  "gtags,etags"
  (interactive)
  (anything (list
             ;; anything-c-source-gtags-select
             anything-c-source-yaetags-select
             anything-c-source-yaetags-select2
             )
            (regexp-quote (or (thing-at-point 'symbol) ""))
            "pattern:"
            nil nil "*gtags-yaetag*"))


(if (eq system-type 'darwin)
    (defun anything-gtags-yaetags ()
      "gtags,etags"
      (interactive)
      (anything (list
                 anything-c-source-gtags-select
                 anything-c-source-yaetags-select
                 anything-c-source-yaetags-select2)
                (regexp-quote (or (thing-at-point 'symbol) ""))
                "pattern:"
                nil nil "*gtags-yaetag*"))
  (defun anything-gtags-yaetags ()
    "anything command for GNU GLOBAL and Exuberant Ctags"
    (interactive)
    (anything :sources '(anything-c-source-gtags-select anything-c-source-yaetags-select)
              :input   (regexp-quote (or (thing-at-point 'symbol) ""))
              :prompt  "pattern:"
              :buffer  "*gtags-yaetag*")))



(defun anything-gtags-yaetags ()
  "gtags,etags"
  (interactive)
  (anything (list
             ;; anything-c-source-gtags-select
             anything-c-source-yaetags-select
             anything-c-source-yaetags-select2
             )
            (regexp-quote (or (thing-at-point 'symbol) ""))
            "pattern:"
            nil nil "*gtags-yaetag*"))


;(global-set-key (kbd "C-:") 'anything-gtags-yaetags)
(global-set-key (kbd "C-c j ") 'anything-gtags-yaetags)
(global-set-key (kbd "C-c C-j ") 'anything-gtags-yaetags)


;; bm
(defun anything-bm+bm-ext-plus ()
  (interactive)
  (anything (list
             anything-c-source-bm
             anything-c-source-bm-ext
             anything-c-source-bm-plus)
            nil
            nil
            nil nil "*bm*"))

(global-set-key (kbd "M-^") 'anything-bm+bm-ext-plus)

;(add-to-list 'anything-sources 'anything-c-source-bm-ext t)

;; (setq emacs-function-file "~/.emacs.d/.emacs-function")

;; (setq anything-c-source-emacs-functions
;;   '((init . anything-c-source-emacs-functions-init)
;;     (name . "Emacs Functions")
;;     (grep-candidates . emacs-function-file)
;;     (type . function)
;;     (requires-pattern . 2)))
;; ;; (anything 'anything-c-source-emacs-functions)

;; (defun anything-c-source-emacs-functions-init ()
;;   (unless (file-exists-p emacs-function-file)
;;     (my-update-emacs-function-file)))

;; (defun my-update-emacs-function-file ()
;;   "自作関数がふえてきたときなんかは手動でも実行する"
;;   (interactive)
;;   (with-temp-buffer
;;     (let ((sort-fold-case t))
;;       (mapatoms (lambda (s) (when (functionp s) (insert (symbol-name s) "\n"))))
;;       (sort-lines nil (point-min) (point-max))
;;       (write-file emacs-function-file))))

(define-key anything-map (kbd "D") 'ik:anything-cycle-pattern)

(defvar ik:anything-cycle-pattern-count 0)
(defun ik:anything-cycle-pattern ()
  (interactive)
  (unless (string= "" anything-pattern)
    (let* ((los '(("\\<" "\\>")
                  "\\<"
                  "\\>"
                  ("\\_<" "\\_>")
                  "\\_<"
                  "\\_>"
                  nil))
           (cleanup-re (rx (or "\\<"
                               "\\>"
                               "\\_<"
                               "\\_>"))))
      (if (eq this-command real-last-command)
          (incf ik:anything-cycle-pattern-count)
        (setq ik:anything-cycle-pattern-count 0))
      (when (>= ik:anything-cycle-pattern-count (length los))
        (setq ik:anything-cycle-pattern-count 0))
      (when (eq this-command real-last-command)
        (save-excursion
          (loop while (re-search-backward cleanup-re nil t)
                do (replace-match ""))))
      (let ((sep (nth ik:anything-cycle-pattern-count los)))
        (etypecase sep
          (cons (save-excursion (backward-sexp) (insert (car sep)))
                (insert (second sep)))
          (string (cond
                   ((string-match "\\\\_?<" sep)
                    (save-excursion (backward-sexp) (insert sep)))
                   (t
                    (insert sep))))
          (null 'do-nothing))))))

;; ;;;; memo
;; (defun anything-mx ()
;;   "Preconfigured `anything' for `mx'."
;;   (interactive)
;;   (anything 'anything-c-source-mx nil nil nil nil "*anything mx*"))




;; ;; るびきちさん[emacs][anything]anything.elの情報源を選択する（改訂版）
;; (defvar anything-call-source-buffer "*anything source select*")
;; (defvar anything-c-source-call-source
;;   `((name . "Call anything source")
;;     (candidate-number-limit . 9999)
;;     (candidates
;;      . (lambda ()
;;          (loop for vname in (all-completions "anything-c-source-" obarray)
;;                for var = (intern vname)
;;                for name = (ignore-errors (assoc-default 'name (symbol-value var)))
;;                if name collect (cons (format "%s (%s)" name vname) var))))
;;     (action . (("Invoke anything with selected source" .
;;                 (lambda (candidate)
;;                   (anything candidate nil nil nil nil
;;                             anything-call-source-buffer)))
;;                ("Describe variable" . describe-variable)))
;;     (persistent-action . describe-variable)))

;; (defun anything-call-source ()
;;   "Call anything source."
;;   (interactive)
;;   (anything 'anything-c-source-call-source nil nil nil nil
;;             anything-call-source-buffer))

;; (global-set-key (kbd "M-<f12>") 'anything-call-source)

;; ;; (defun anything-symfony-el-command ()
;; ;;   (interactive)
;; ;;   (anything (list anything-c-source-symfony-el-command) nil nil nil))



;; ;(require 'info)
;; ;; Info-Gauche
;; (defvar anything-c-info-gauche-fn nil)

;; (setq anything-c-source-info-gauche
;;   `((name . "Info Gauche")
;;     (init . (lambda ()
;;               (save-window-excursion
;;                 (unless anything-c-info-gauche-fn
;;                   (with-temp-buffer
;;                     (Info-find-node "gauche-refe" "Function and Syntax Index")
;;                     (setq anything-c-info-gauche-fn (split-string (buffer-string) "\n"))
;;                     (Info-exit))))))
;;     (candidates . (lambda ()
;;                     (loop for i in anything-c-info-gauche-fn
;;                           if (string-match "^* " i)
;;                           collect (match-string 0 i))))
;;     (action . (lambda (candidate)
;;                 (Info-find-node "gauche-refe" "Function and Syntax Index")
;;                 (Info-index (replace-regexp-in-string "* " "" candidate))))
;;     (volatile)
;;     (requires-pattern . 2)))

;; ;; (anything 'anything-c-source-info-gauche)
;; ;; (setq anything-c-info-gauche-fn nil)
;; ;; (Info-find-node "cl" "Function Index")
;; ;; (Info-find-node "gauche-refe" "Function and Syntax Index")
;; ;; (Info-find-node "gauche-refe" "Index")
;; ;; (Info-find-node "cl" "Index")


;; (defun anything-hoge ()
;;   "Show `gauche-info'."
;;   (interactive)
;;   (anything (list anything-c-source-simple-call-tree-callers-functions) nil nil nil nil "*ho*"))

;; (defun anything-show-gauche-info-only ()
;;   "Show `gauche-info'."
;;   (interactive)
;;   (anything (list anything-c-source-info-gauche) nil nil nil nil "*gauche info*"))

;; (add-hook 'inferior-gauche-mode-hook
;;   (lambda()
;;     (define-key inferior-gauche-mode-map (kbd "M-<f12>") 'anything-show-gauche-info-only)))

;; (add-hook 'scheme-mode-hook
;;   (lambda()
;;     (define-key scheme-mode-map (kbd "M-<f11>") 'anything-show-gauche-info-only)))

;; (global-set-key (kbd "M-h") 'anything-show-gauche-info-only)


;; (defvar anything-c-source-buffers+
;;   '((name . "Buffers")
;;     (candidates . anything-c-buffer-list)
;;     (type . buffer)
;;     (candidate-transformer anything-c-skip-current-buffer
;;                            anything-c-highlight-buffers
;;                            anything-c-skip-boring-buffers)
;;     (persistent-action . anything-c-buffers+-persistent-action)))




;; (defvar anything-c-source-key-chord-describe
;;   `((name . "key-chord describe bindings")
;;     (action . (("Call Interactively" . (lambda (c)
;;                                          (call-interactively (intern c))))
;;                ("Add to kill-ring" . kill-new)))
;;     (init . (lambda ()
;;               (with-current-buffer (anything-candidate-buffer 'global)
;;                 (save-selected-window
;;                   (call-interactively 'key-chord-describe))
;;                   ;(call-interactively 'list-colors-display))
;;               (let ((los (with-current-buffer "*Help*"
;;                              (loop initially (goto-char (point-min))
;;                                    while (re-search-forward (rx "<key-chord>"
;;                                                                 (1+ space)
;;                                                                 (group
;;                                                                  (* not-newline))) nil t)
;;                                    unless (save-excursion (progn (beginning-of-line)
;;                                                       (re-search-forward "Prefix Command" nil t)))
;;                                    collect (match-string-no-properties 1)))))
;;                   (insert (mapconcat 'identity los "\n"))))))
;;     (display-to-real . (lambda (line)
;;                          ;; (rx bol (= 3 not-newline) (+ space) (group (+ print)))
;;                          (when (string-match "\\(?:^.\\{3\\}[[:space:]]+\\([[:print:]]+\\)\\)"
;;                                              line)
;;                            (match-string 1 line))))
;;     (candidates-in-buffer)))

;; (defun anything-c-key-chord-describe ()
;;   (interactive)
;;   (anything '(anything-c-source-key-chord-describe)))

;; ;(key-chord-define-global "kc" 'anything-c-key-chord-describe)

;; ruby -rubygems -e 'puts Dir["{#{Gem::SourceIndex.installed_spec_directories.join(",")}}/*.gemspec"].collect {|s| File.basename(s).gsub(/.gemspec$/, "")}'

;; (defvar anything-gem-open-ruby-command "ruby -rubygems -e 'puts Dir[\"{#{Gem::SourceIndex.installed_spec_directories.join(\",\")}}/*.gemspec\"].collect {|s| File.basename(s).gsub(/\.gemspec$/, \"\")}'")
(defvar anything-gem-open-ruby-command "ruby -rubygems -e 'puts Dir[\"{#{Gem::Specification.dirs.join(\",\")}}/*.gemspec\"].collect {|s| File.basename(s).gsub(/\.gemspec$/, \"\")}'")

(defvar anything-c-source-gem-open
  '((name . "gem open")
    (init . (lambda ()
              (let ((buffer (anything-candidate-buffer 'global)))
                (with-current-buffer buffer
                  (call-process-shell-command anything-gem-open-ruby-command  nil buffer)
                  (sort-lines nil (point-min) (point-max))))))
    (candidates-in-buffer)
    (candidate-number-limit . 99999)
    (action ("Open" . anything-c-source-gem-open-action))))

(defun anything-c-source-gem-open-action (candidate)
  (unless (executable-find "return_gemfile_path.rb")
    (error "return_gemfile_path.rb を利用できません"))
  (find-file (with-temp-buffer ;正常系のみ
               (call-process "return_gemfile_path.rb" nil t 0 candidate)
               (delete-backward-char 1)
               (buffer-string))))

(defun anything-gem-open ()
  (interactive)
  (anything anything-c-source-gem-open))

(defalias 'gem 'anything-gem-open)




(defun anything-c-sources-git-project-for (pwd)
  (loop for elt in
        '(("Modified files (%s)" . "--modified")
          ("Untracked files (%s)" . "--others --exclude-standard")
          ("All controlled files in this project (%s)" . ""))
        collect
        `((name . ,(format (car elt) pwd))
          (init . (lambda ()
                    (unless (and ,(string= (cdr elt) "") ;update candidate buffer every time except for that of all project files
                                 (anything-candidate-buffer))
                      (with-current-buffer
                          (anything-candidate-buffer 'global)
                        (insert
                         (shell-command-to-string
                          ,(format "git ls-files $(git rev-parse --show-cdup) %s"
                                   (cdr elt))))))))
          (candidates-in-buffer)
          (candidate-number-limit . 10000000)
          (type . file))))

(defun anything-git-project ()
  (interactive)
  (let* ((pwd (shell-command-to-string "echo -n `pwd`"))
         (sources (anything-c-sources-git-project-for pwd)))
    (anything-other-buffer sources
     (format "*Anything git project in %s*" pwd))))

;;(define-key global-map (kbd "C-q") ctl-q-map)     
(define-key ctl-q-map (kbd "C-l") ''anything-git-project)

(defun anything-c-sources-git-project-for (pwd)
  (loop for elt in
        '(("Modified files (%s)" . "--modified")
          ("Untracked files (%s)" . "--others --exclude-standard")
          ("All controlled files in this project (%s)" . ""))
        collect
        `((name . ,(format (car elt) pwd))
          (init . (lambda ()
                    (unless (and ,(string= (cdr elt) "") ;update candidate buffer every time except for that of all project files
                                 (anything-candidate-buffer))
                      (with-current-buffer
                          (anything-candidate-buffer 'global)
                        (insert
                         (shell-command-to-string
                          ,(format "git ls-files $(git rev-parse --show-cdup) %s"
                                   (cdr elt))))))))
          (candidates-in-buffer)
          (candidate-number-limit . 10000000)
          (type . file))))

(defun anything-git-project ()
  (interactive)
  (let* ((pwd (shell-command-to-string "echo -n `pwd`"))
         (sources (anything-c-sources-git-project-for pwd)))
    (anything-other-buffer sources
     (format "*Anything git project in %s*" pwd))))

;;(define-key global-map (kbd "C-q") ctl-q-map)     
(define-key ctl-q-map (kbd "C-l") 'anything-git-project)




(defun anything-colors ()
  (interactive)
  (let ((anything-samewindow t))
    (anything '(anything-c-source-colors)) "*anything colors*"))


(setq anything-c-source-colors
  '((name . "Colors")
    (init . (lambda () (unless (anything-candidate-buffer)
                         (save-window-excursion (list-colors-display))
                         (anything-candidate-buffer (get-buffer "*Colors*")))))
    (candidates-in-buffer)
    (get-line . buffer-substring)
    (limit . 99999)

    (action
     ("Copy Name" . (lambda (candidate)
                      (kill-new (anything-c-colors-get-name candidate))))
     ("Copy RGB" . (lambda (candidate)
                     (kill-new (anything-c-colors-get-rgb candidate))))
     ("Insert Name" . (lambda (candidate)
                        (with-current-buffer anything-current-buffer
                          (insert (anything-c-colors-get-name candidate)))))
     ("Insert RGB" . (lambda (candidate)
                       (with-current-buffer anything-current-buffer
                         (insert (anything-c-colors-get-rgb candidate))))))))
;; ;;;; face の設定

;; (set-face-foreground 'anything-visible-mark "WhiteSmoke")
;; (set-face-background 'anything-visible-mark "Sienna")
;; ;; anything-c-source-buffers+ 用。font-lock-type-face から変更


;; (setq anything-c-buffers-face2 'anything-file-name)

;; (defface my-anyting-candidate-face
;;   '((t (:underline t :bold t)))
;;   "ほげほげのためのフェイス"
;;   :group 'anything)

;; (setq anything-show-completion-face 'my-anyting-candidate-face)
