;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-


;; todo
;; k1lowさんのをみる
;; ~/.emacs.d/elisp/historyf.el

;; dired フォルダを開く時, 新しいバッファを作成しない

;; (defvar my-dired-previous-buffer nil)

;; (defadvice dired-find-file (around kill-dired-buffer activate)
;;   (let ((prev-buf (current-buffer)))
;;     ad-do-it
;;     (when (and (eq major-mode 'dired-mode)
;;                (not (equal (buffer-name my-dired-previous-buffer) "*Find*")))
;;       (kill-buffer prev-buf))))

;; (defadvice dired-up-directory (around kill-up-dired-buffer activate)
;;   (let ((prev-buf (current-buffer)))
;;     ad-do-it
;;     (when (eq major-mode 'dired-mode)
;;       (kill-buffer prev-buf))))


;;------------------------------------------------------
;; sort(dired の並び替えパターンを増やす)
;;------------------------------------------------------

(add-hook 'dired-load-hook
          (lambda ()
            (require 'sorter)))


;;------------------------------------------------------
;; ディレクトリを上に表示する http://www.emacswiki.org/emacs-en/DiredSortDirectoriesFirst
;;------------------------------------------------------

(defun sof/dired-sort ()
  "Dired sort hook to list directories first."
  (save-excursion
   (let (buffer-read-only)
     (forward-line 2) ;; beyond dir. header  
     (sort-regexp-fields t "^.*$" "[ ]*." (point) (point-max))))
  (and (featurep 'xemacs)
       (fboundp 'dired-insert-set-properties)
       (dired-insert-set-properties (point-min) (point-max)))
  (set-buffer-modified-p nil))

 (add-hook 'dired-after-readin-hook 'sof/dired-sort)

(defun mydired-sort ()
  "Sort dired listings with directories first."
  (save-excursion
    (let (buffer-read-only)
      (forward-line 2) ;; beyond dir. header 
      (sort-regexp-fields t "^.*$" "[ ]*." (point) (point-max)))
    (set-buffer-modified-p nil)))

(defadvice dired-readin
  (after dired-after-updating-hook first () activate)
  "Sort dired listings with directories first before adding marks."
  (mydired-sort))


;;------------------------------------------------------
;; フェイスの追加
;;------------------------------------------------------

(defface diredp-file-name
  '((t (:foreground "DeepSkyBlue")))
  "*Face used for file names (without suffixes) in dired buffers."
  :group 'Dired-Plus :group 'font-lock-highlighting-faces)
(defvar diredp-file-name 'diredp-file-name)

(setq dired-font-lock-keywords
  (list
   ;;
   ;; Dired marks.
   (list dired-re-mark '(0 dired-mark-face))
   ;;
   ;; We make heavy use of MATCH-ANCHORED, since the regexps don't identify the
   ;; file name itself.  We search for Dired defined regexps, and then use the
   ;; Dired defined function `dired-move-to-filename' before searching for the
   ;; simple regexp ".+".  It is that regexp which matches the file name.
   ;;
   ;; Marked files.
   (list (concat "^[" (char-to-string dired-marker-char) "]")
         '(".+" (dired-move-to-filename) nil (0 dired-marked-face)))
   ;;
   ;; Flagged files.
   (list (concat "^[" (char-to-string dired-del-marker) "]")
         '(".+" (dired-move-to-filename) nil (0 dired-flagged-face)))
   ;; People who are paranoid about security would consider this more
   ;; important than other things such as whether it is a directory.
   ;; But we don't want to encourage paranoia, so our default
   ;; should be what's most useful for non-paranoids. -- rms.
  ;;
  ;; Files that are group or world writable.
  ;; (list (concat dired-re-maybe-mark dired-re-inode-size
  ;;   	 "\\([-d]\\(....w....\\|.......w.\\)\\)")
  ;;    '(1 dired-warning-face)
  ;;    '(".+" (dired-move-to-filename) nil (0 dired-warning-face)))
   ;; However, we don't need to highlight the file name, only the
   ;; permissions, to win generally.  -- fx.
   ;; Fixme: we could also put text properties on the permission
   ;; fields with keymaps to frob the permissions, somewhat a la XEmacs.
   (list (concat dired-re-maybe-mark dired-re-inode-size
		 "[-d]....\\(w\\)....")	; group writable
	 '(1 dired-perm-write-face))
   (list (concat dired-re-maybe-mark dired-re-inode-size
		 "[-d].......\\(w\\).")	; world writable
	 '(1 dired-perm-write-face))
   ;;
   ;; Subdirectories.
   (list dired-re-dir
	 '(".+" (dired-move-to-filename) nil (0 dired-directory-face)))
   ;;
   ;; Symbolic links.
   (list dired-re-sym
	 '(".+" (dired-move-to-filename) nil (0 dired-symlink-face)))
   ;;
   ;; Files suffixed with `completion-ignored-extensions'.
   '(eval .
     ;; It is quicker to first find just an extension, then go back to the
     ;; start of that file name.  So we do this complex MATCH-ANCHORED form.
     (list (concat "\\(" (regexp-opt completion-ignored-extensions) "\\|#\\)$")
	   '(".+" (dired-move-to-filename) nil (0 dired-ignored-face))))
   ;;
   ;; Files suffixed with `completion-ignored-extensions'
   ;; plus a character put in by -F.
   '(eval .
     (list (concat "\\(" (regexp-opt completion-ignored-extensions)
		   "\\|#\\)[*=|]$")
	   '(".+" (progn
		    (end-of-line)
		    ;; If the last character is not part of the filename,
		    ;; move back to the start of the filename
		    ;; so it can be fontified.
		    ;; Otherwise, leave point at the end of the line;
		    ;; that way, nothing is fontified.
		    (unless (get-text-property (1- (point)) 'mouse-face)
		      (dired-move-to-filename)))
	     nil (0 dired-ignored-face))))
   ;;
   ;; Explicitly put the default face on file names ending in a colon to
   ;; avoid fontifying them as directory header.
   (list (concat dired-re-maybe-mark dired-re-inode-size dired-re-perms ".*:$")
	 '(".+" (dired-move-to-filename) nil (0 'default)))
   ;;
   ;; Directory headers.
   (list dired-subdir-regexp '(1 dired-header-face))

   ;; dired+ を参考にファイル用のフェイスを作成
   (list dired-move-to-filename-regexp
            (list "\\(.+\\)$" nil nil (list 0 diredp-file-name 'keep t)))
))

;; (require 'dired+)

;; (set-face-foreground 'diredp-compressed-file-suffix nil)
;; (set-face-background 'diredp-compressed-file-suffix nil)
;; (set-face-foreground 'diredp-date-time nil)
;; (set-face-background 'diredp-date-time nil)
;; (set-face-foreground 'diredp-deletion nil)
;; (set-face-background 'diredp-deletion nil)
;; (set-face-foreground 'diredp-deletion-file-name nil)
;; (set-face-background 'diredp-deletion-file-name nil)
;; (set-face-foreground 'diredp-dir-heading nil)
;; (set-face-background 'diredp-dir-heading nil)
;; (set-face-foreground 'diredp-dir-priv "Goldenrod")
;; (set-face-background 'diredp-dir-priv nil)
;; (set-face-foreground 'diredp-display-msg nil)
;; (set-face-background 'diredp-display-msg nil)
;; (set-face-foreground 'diredp-exec-priv "DeepSkyBlue")
;; (set-face-background 'diredp-exec-priv nil)
;; (set-face-foreground 'diredp-executable-tag nil)
;; (set-face-background 'diredp-executable-tag nil)
;; (set-face-foreground 'diredp-file-name "DeepSkyBlue")
;; (set-face-background 'diredp-file-name nil)
;; (set-face-foreground 'diredp-file-suffix "DeepSkyBlue")
;; (set-face-background 'diredp-file-suffix nil)
;; (set-face-foreground 'diredp-flag-mark nil)
;; (set-face-background 'diredp-flag-mark nil)
;; (set-face-foreground 'diredp-flag-mark-line nil)
;; (set-face-background 'diredp-flag-mark-line nil)
;; (set-face-foreground 'diredp-ignored-file-name "Gray")
;; (set-face-background 'diredp-ignored-file-name nil)
;; (set-face-foreground 'diredp-inode+size nil)
;; (set-face-background 'diredp-inode+size nil)
;; (set-face-foreground 'diredp-link-priv "DeepSkyBlue")
;; (set-face-background 'diredp-link-priv nil)
;; (set-face-foreground 'diredp-no-priv "Gray")
;; (set-face-background 'diredp-no-priv nil)
;; (set-face-foreground 'diredp-other-priv nil)
;; (set-face-background 'diredp-other-priv nil)
;; (set-face-foreground 'diredp-rare-priv nil)
;; (set-face-background 'diredp-rare-priv nil)
;; (set-face-foreground 'diredp-read-priv "Salmon")
;; (set-face-background 'diredp-read-priv nil)
;; (set-face-foreground 'diredp-symlink "Tan")
;; (set-face-background 'diredp-symlink nil)
;; (set-face-foreground 'diredp-write-priv "DarkGoldenrod")
;; (set-face-background 'diredp-write-priv nil)

;;------------------------------------------------------
;; Hit a Hint yafastnav-for-dired
;;------------------------------------------------------

(require 'yafastnav-for-dired)

(add-hook 'dired-mode-hook
  (lambda ()
     (define-key dired-mode-map "e" 'yafastnav-dired-jump-to-current-screen)))

;;e を外した
(setq yafastnav-dired-shortcut-keys
     '(
       ?a ?s ?d ?f ?g ?h ?k ?l
       ?q ?w ?r ?t ?y ?u ?i ?o ?p
       ?z ?x ?c ?v ?b ?n ?m
       ?1 ?2 ?3 ?4 ?5 ?6 ?7 ?8 ?9 ?0
       ?, ?. ?: ?- ?^ ?;
       ?A ?S ?D ?F ?G ?H ?K ?L
       ?Q ?W ?E ?R ?T ?Y ?U ?I ?O ?P
       ?Z ?X ?C ?V ?B ?N ?M
       ?< ?> ?@ ?\* ?\[ ?\]
       ?\\ ?\  ?' ?( ?) ?=
       ?~ ?| ?{ ?} ?\_
       ?! ?\" ?# ?$ ?% ?&
       ))


;;------------------------------------------------------
;; 自作
;;------------------------------------------------------

;;dotファイルをデフォルトで非表示にする
;; . でトグルで表示/非表示を切り替える
(defvar my-dired-ls-al-flag nil)

(defadvice dired (after my-dired activate)
  (dired-sort-other "-l")
  (setq my-dired-ls-al-flag t))

(defadvice dired-up-directory (after my-dired-up-directory activate)
  (dired-sort-other "-l")
  (setq my-dired-ls-al-flag t))

(defadvice dired-find-file (after my-dired-find-file activate)
  (dired-sort-other "-l")
  (setq my-dired-ls-al-flag t))

(defun my-dired-toggle-ls-al ()
  (interactive)
  (if my-dired-ls-al-flag
      (progn
        (dired-sort-other "-al")
        (setq my-dired-ls-al-flag nil))
    (dired-sort-other "-l")
    (goto-char (point-min))
    (setq my-dired-ls-al-flag t)))

(add-hook 'dired-mode-hook
          (lambda ()
            (define-key dired-mode-map (kbd ".") 'my-dired-toggle-ls-al)))


;; dired バッファがあればそれを表示する

(defun my-dired ()
  (interactive)
  (if (and dired-buffers
           (buffer-live-p (cdar dired-buffers)))
      (switch-to-buffer (cdar dired-buffers))
    (dired-at-point)))


;; (global-set-key (kbd "C-c C-d") 'my-dired)
(global-set-key (kbd "C-c d") 'my-dired)
;; (global-set-key (kbd "C-x C-d") 'my-dired)
;; (global-set-key (kbd "C-x d") 'my-dired)

(add-hook 'dired-mode-hook          
  (lambda()
    (define-key dired-mode-map (kbd "u") 'dired-up-directory)
    (define-key dired-mode-map (kbd "j") 'dired-next-line)
    (define-key dired-mode-map (kbd "k") 'dired-previous-line)
    (define-key dired-mode-map (kbd "U") 'dired-unmark)
    (define-key dired-mode-map (kbd "f") 'my-dired-history-forward)
    (define-key dired-mode-map (kbd "b") 'my-dired-history-back)
    ;; (define-key dired-mode-map (kbd "") ')
    ))



(defun dired-gnome-open (&optional arg)
  "In Dired, visit the file or directory named on this line."
  (interactive)
  (let ((process-connection-type nil))  
    (start-process-shell-command  "gnome-open" "*gnome-open-tmp*" (format "gnome-open %s" (dired-get-file-for-visit)))))

;; http://d.hatena.ne.jp/mooz/20100915/p1
(defun open-file-dwim (filename)
  "Open file dwim"
  (let* ((winp (string-equal window-system "w32"))
         (opener (if (file-directory-p filename)
                     (if winp '("explorer.exe") '("gnome-open"))
                   (if winp '("fiber.exe") '("gnome-open"))))
         (fn (replace-regexp-in-string "/$" "" filename))
         (args (append opener (list (if winp
                                        (replace-regexp-in-string "/" (rx "\\") fn)
                                      fn))))
         (process-connection-type nil))
    (apply 'start-process "open-file-dwim" nil args)))

;; カーソル下のファイルやディレクトリを関連付けられたプログラムで開く
(defun dired-open-dwim ()
  "Open file under the cursor"
  (interactive)
  (open-file-dwim (dired-get-filename)))

;; 現在のディレクトリを関連付けられたプログラムで開く
(defun dired-open-here ()
  "Open current directory"
  (interactive)
  (open-file-dwim (expand-file-name dired-directory)))

;; キーバインド
(add-hook 'dired-mode-hook
          (lambda ()
            (define-key dired-mode-map (kbd "o") 'dired-open-dwim)
           ))

;; (defvar dired-dd-b3-keymap
(setq dired-dd-b3-keymap  
;;(defconst dired-dd-b3-keymap
  '(keymap
    (goo "gnome-open" (nil) dired-gnome-open arg)
    (get-term "Launch a Terminal" (nil)
	      dired-dd-exec-async-shell-command
	      dired-dd-terminal-command nil)
    (separator-mymap "--" (nil))
    (copy "Copy" (nil) dired-do-copy arg)
    (copyrecursive "Copy Recursive" (nil) dired-dd-do-copy-recursive arg)
    (move "Move" (nil) dired-do-rename arg)
    (separator-mymap "--" (nil))
    (up-tree "Up Tree" (nil) dired-up-directory arg)
    (newdir "New directory" (nil) dired-create-directory
	    (read-file-name "Create directory: "
			    (dired-current-directory)))
    (separator-mymap "--" (nil))
    (delete "Delete" (nil) dired-do-delete arg)
    (flagged-delete "Delete Flagged" (nil) dired-do-flagged-delete)
    ;; Sat Apr  7 16:36:48 2001, `dired-dd-shell-rm-R' deprecated.
    ;; (rm-R "Delete Recursive" (nil) dired-dd-shell-rm-R fn-list)
    (rm-R "Delete Recursive" (nil) dired-dd-delete-recursive fn-list)
    (separator-mymap "--" (nil))
    ;; shortname -> dired-get-marked-files
    ;; This entry is now used from M-double-down-mouse-1
    (shellcmd "Execute Command On" (nil) dired-do-shell-command
	      (dired-read-shell-command
	       (concat "! on " "%s: ") current-prefix-arg
	       ;;shortnames
	       (dired-get-marked-files t arg)
	       ) arg)
;;;	   (shellcmd "Execute Command On" (nil) dired-do-shell-command
;;;		     (dired-read-shell-command
;;;		      (concat "! on " "%s: ") current-prefix-arg
;;;		      (dired-dd-get-marked-files t current-prefix-arg)) arg)
    (separator-mymap "--" (nil))
    (file-strip "File, Strip"
		(nil)
		keymap
		(file "File" (nil)
		      progn (dired-dd-shell-command "file" shortnames))
		(strip "strip -v" (nil)
		       progn (dired-dd-shell-command "strip -v" shortnames)
		       (revert-buffer))
		"File, Strip")
    (separator-mymap "--" (nil))
    (arc "Tar, Zip"
	 (nil)
	 keymap
	 (zvtf "tar zvtf" (nil) dired-dd-do-tar-zvtf shortnames)
	 (zvxf "tar zvxf" (nil)
	       progn (dired-dd-do-tar-zvxf shortnames)
	       (revert-buffer))
	 (separator-mymap "--" (nil))
	 (gzip "gzip -9" (nil)
	       progn (dired-dd-shell-command "gzip" shortnames)
	       (revert-buffer))
	 (gunzip "gunzip" (nil) 
		 progn (dired-dd-shell-command "gunzip" shortnames)
		 (revert-buffer))
	 (separator-mymap "--" (nil))
	 (unzip-l "unzip -l" (nil) 
		progn (dired-dd-do-unzip-l shortnames)
		(revert-buffer))
	 (unzip "unzip" (nil) 
		progn (dired-dd-do-unzip shortnames)
		(revert-buffer))
	 (lha-v "lha v"  (nil)  dired-dd-do-lha-v shortnames)
	 (lha-x "lha x" (nil) 
		progn (dired-dd-do-lha-x shortnames) (revert-buffer))
	 "Tar, Zips")
;;; Maybe handy, but the menu looks ugly Thu Apr 20 13:01:18 2000
;;;    (separator-mymap "--" (nil))
;;;    (html "Open local HTML" (nil) dired-dd-w3-open-local shortnames)
    (separator-mymap "--" (nil))
    (doc "Man, Info, HTML"
	 (nil)
	 keymap
	 (mandoc "groff -mandoc" (nil) dired-dd-do-mandoc shortnames)
	 (w3openlocal "w3-open-local" (nil) dired-dd-w3-open-local shortnames)
	 ;; Pass `shortnames' and it expands to URL.
	 (w3mopenlocal "w3m-open-local" (nil) dired-dd-w3m-open-local shortnames)
	 ;; Just open cursor (pointer) is on.  No multiple file handling.
	 (info "Read This Info" (nil)  call-interactively 'dired-info)
	 "Man, Info, HTML")
    (separator-mymap "--" (nil))
    (link "Link"
	  (nil)
	  keymap
	  (symlink "Symlink" (nil) dired-do-symlink arg)
	  (hardlink "Hardlink" (nil) dired-do-hardlink arg)
	  (relsymlink "Relative Symlink" (nil) dired-do-relsymlink arg)
	  "Link")
    ;;	(separator-mymap "--" (nil))
    (perm "Permission"
	  (nil)
	  keymap
	  (chmod "Change File Mode" (nil) dired-do-chmod arg)
	  (chgrp "Change File Group" (nil) dired-do-chgrp arg)
	  (chown "Change File Owner" (nil) dired-do-chownrp arg)
	  "Permission")
    (separator-mymap "--" (nil))
    (file "File Open"
	  (nil)
	  keymap
	  (open "Open" (nil) . find-file)
	  (view "View" (nil) dired-view-file)
	  (o-other-win
	   "Open Other Window" (nil) . find-file-other-window)
	  (o-other-frame
	   "Open Other Frame" (nil) . find-file-other-frame)
	  (o-multi-win "Open Multi Window" (nil)
		       dired-do-find-marked-files arg)
	  "File Open")
    (separator-mymap "--" (nil))
;;; (elisp "Elisp"
;;;   (nil)
;;;	 keymap
    (load "Load Into Emacs" (nil) dired-do-load arg)
    (bytecompile "Byte Compile" (nil) dired-do-byte-compile arg)
    (byte-recompile-dir
     "Byte Recompile Dir"
     (nil)  . dired-dd-byte-recompile-directory)
;;;		  "Elisp")
    (separator-mymap "--" (nil))
    (mark "Mark"
	  (nil)
	  keymap
	  (xsel "X-select" (nil) dired-copy-filename-as-kill nil)
	  (xsel-full "X-select Full" (nil)
		     dired-copy-filename-as-kill 0)
	  (toggle-sort "Toggle Sorting" (nil)
		       dired-sort-toggle-or-edit arg)
	  (mark-all
	   "Mark All" (nil)
	   save-excursion (dired-mark-subdir-files) (revert-buffer))
	  (umark-all
	   "Unmark All" (nil) progn (dired-unmark-all-marks)
	   (revert-buffer))
	  "Mark Ops")
    (separator-mymap "--" (nil))
    ;; Promote up from submenu, Sun Jan 11 13:13:05 1998
    ;;	   (system "File System Stat"
    ;;		   (nil)
    ;;		   keymap
    (du "Disk Usage (du)" (nil) dired-dd-shell-du shortnames)
    (df "Disk Free (df)" (nil)  dired-dd-shell-df)
    ;;		   "System")
    ;;	   (separator-mymap "--" (nil))
    ;;	   (cancel "Cancel" (nil) . cancel)
    (separator-mymap "--" (nil))
    (refresh "Refresh Listing" (nil) revert-buffer arg)
    (separator-mymap "--" (nil))
    (quit "Bury Buffer" (nil)  bury-buffer)
    (separator-mymap "--" (nil))
    (version "About dired-dd" (nil) dired-dd-version nil)
    ))


;;------------------------------------------------------
;; 作成中
;;------------------------------------------------------

;; back - forward

;; (defvar my-dired-previous-buffer nil)
(defvar my-dired-history nil)
(defvar my-dired-forward-history nil)

(defun my-clear-dired-history ()
  (interactive)
  (setq my-dired-history nil))


(defadvice dired-find-file (around kill-dired-buffer activate)
  (let ((prev-buf (current-buffer)))
    ad-do-it
    (when (and (eq major-mode 'dired-mode)
               (not (equal (buffer-name prev-buf) "*Find*")))
      (push default-directory my-dired-history)
      ;; (push prev-buf my-dired-history)
      (kill-buffer prev-buf))))
;; (setq my-dired-history nil)

(defadvice dired-up-directory (around kill-up-dired-buffer activate)
  (let ((prev-buf (current-buffer)))
    ad-do-it
    (when (eq major-mode 'dired-mode)
      ;; (push prev-buf my-dired-history)
      (push default-directory my-dired-history)
      (kill-buffer prev-buf))))

(defun my-dired-history-back ()
  (interactive)
  (let ((prev-buf (current-buffer)))
    (when (eq major-mode 'dired-mode)
      (unless (eq this-command real-last-command)
        (pop my-dired-history))
      (dired (pop my-dired-history))
      (push default-directory my-dired-forward-history)
      (kill-buffer prev-buf))))

(defun my-dired-history-forward ()
  (interactive)
  (let ((prev-buf (current-buffer)))
    (when (eq major-mode 'dired-mode)  
      (dired (pop my-dired-forward-history))
      (push default-directory my-dired-history)
      (kill-buffer prev-buf))))



;; diredで"V"を入力するとそのディレクトリで使っているバージョン管理システム用のモードを起動します。

(defun dired-vc-status (&rest args)
  (interactive)
  (cond ((file-exists-p (concat (dired-current-directory) ".svn"))
         (svn-status (dired-current-directory)))
        ((file-exists-p (concat (dired-current-directory) ".git"))
         (magit-status (dired-current-directory)))
        (t
         (message "version controlled?"))))

(define-key dired-mode-map "V" 'dired-vc-status)


;; (defvar my-dired-history nil)

;; (defun my-push-dired-history ()
;;   (when (buffer-file-name)
;;     (push (expand-file-name (buffer-file-name)) my-dired-history)))

;; (defun my-pop-dired-history ()
;;   (interactive)
;;   (unless (null my-dired-history)
;;     (find-file (pop my-dired-history))))

;; (add-hook 'kill-buffer-hook 'my-push-dired-history)

;; (defun my-kill-buffer ()
;;   (interactive)
;;   (kill-buffer (buffer-name)))





;; 最低限コマンド：
;; C-x d 	スタート。「C-x d ~/*txt」などで絞込み。
;; n, p 	↑↓
;; RET, e, f 	開く。
;; ^ 	cd ..
;; d 	削除マークを付ける。
;; x 	削除マークが付いたのを実際に削除。
;; R 	mv
;; C 	cp
;; s 	ソート。または「C-u s -lSr」など。

;; 便利かもしれないコマンド：
;; D 	rm
;; + 	mkdir
;; Z 	gzip
;; g 	ディレクトリ内容再読み込み。
;; i 	サブディレクトリの内容を表示。$ で表示トグル。
;; m 	マークする。ディレクトリのとこにつけると全ファイルに。
;; u 	マークをはずず。
;; t 	マークの反転。
;; A 	マークしたファイルを検索。M-, で次のマッチ箇所へ。
;; Q 	マークしたファイルに対して、query-replace-regex。
;; = 	diff
;; M-= 	「*~」とdiff。
;; ~ 	「*~」に削除マーク。
;; % d regexp 	ファイル名にマッチしたら削除マーク


;; wdired (dired のバッファを編集)

(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

;; http://dev.ariel-networks.com/wp/documents/aritcles/emacs/part11
;; C-x d 普通のdiredバッファを開く
;; C-x C-q バッファ内のファイル名を編集できるようになる
;; 編集を終えたら C-c C-c で変更が反映される
;; C-c ESC で取り消す
;; qr を使おう！
