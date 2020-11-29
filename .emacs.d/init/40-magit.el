
;; TODO
;; pr https://github.com/sigma/magit-gh-pulls

(require 'magit)

(defalias 'mst 'magit-status)
(setq magit-auto-revert-mode nil)
(setq magit-last-seen-setup-instructions "1.4.0")

;; (add-hook 'magit-mode-hook
;;   (lambda()
;;     (define-key magit-mode-map (kbd "j") 'next-line)
;;     (define-key magit-mode-map (kbd "k") 'previous-line)
;;     (define-key magit-mode-map (kbd "/") 'isearch-forward)
;;     (define-key magit-mode-map (kbd "?") 'isearch-backward)
;;     ))


;; ;;https://github.com/nex3/dotfiles/raw/master/elisp/magithub.el
;; ;; (require 'magithub)

;; ;;https://github.com/nex3/dotfiles/raw/master/elisp/my-magit.el

;; ; This file contains my own Magit rebindings and tweaks.
;; ;; It obviously depends heavily on Magit itself.
;; ;; It's loaded automatically once Magit is.

;; (require 'magit)
;; (require 'cl)

;; ;; (defalias 'l 'magit-log) ;; move to 90-last-setting.el

;; (defun my-magit-status-buffer ()
;;   "Return the Magit status buffer for this perspective.
;; Return nil if there is no such buffer.  If there are more than
;; one Magit status buffers active, this returns an arbitrary one."
;;   (dolist (buffer (persp-buffers persp-curr))
;;     (when (and (buffer-name buffer)
;;                (string-match "^\*magit: " (buffer-name buffer)))
;;       (return-from nil buffer))))

;; ;;;###autoload
;; (defun my-magit-status (dir)
;;   "Like `magit-status', but use this perspective's Magit buffer if possible.
;; DIR is the Git-managed directory for which to set up the Magit buffer.

;; When called interactively, use `my-magit-status-buffer' to find
;; the correct status buffer.  Fall back on the default directory or
;; simply prompting the user."
;;   (interactive (list
;;                 (let ((buffer (my-magit-status-buffer)))
;;                   (or (if buffer (buffer-local-value 'default-directory buffer))
;;                       (unless (string-match "^\\*scratch\\*" (buffer-name))
;;                         (magit-get-top-dir default-directory))
;;                       (magit-read-top-dir (and (consp current-prefix-arg)
;;                                                (> (car current-prefix-arg) 4)))))))
;;   (magit-status dir))

;; ;;;###autoload
;; (defun my-magithub-clone (username repo &optional srcp)
;;   "Clone GitHub repo USERNAME/REPO.
;; The clone is placed in ~/code, or with SRCP in ~/src.

;; Creates and switches to a new perspective named like the repo.

;; Interactively, prompts for the repo name, and by default creates
;; the repo in ~/code. With a prefix argument, creates the repo in
;; ~/src."
;;   (interactive
;;    (destructuring-bind (username . repo) (magithub-read-repo)
;;      (list username repo current-prefix-arg)))
;;   ;; The trailing slash is necessary for Magit to be able to figure out
;;   ;; that this is actually a directory, not a file
;;   (let ((dir (concat (getenv "HOME") "/" (if srcp "src" "code") "/" repo "/")))
;;     (magit-run-git "clone" (concat "http://github.com/" username "/" repo ".git") dir)
;;     (persp-switch repo)
;;     (magit-status dir)))

;; (define-key magit-mode-map (kbd "M-I") 'magit-goto-next-section)
;; (define-key magit-mode-map (kbd "M-O") 'magit-goto-previous-section)


;; ;; 色変更
;; (set-face-foreground 'magit-diff-add "#b9ca4a") ; 追加した部分を緑に
;; (set-face-foreground 'magit-diff-del "#d54e53")  ; 削除した 部分を赤に
;; (set-face-background 'magit-item-highlight "#000000") ; 選択項目ハイライトがうっとうしいので背景色と同化


;; ;;(require 'magit-svn)
;; ;; (require 'magit-topgit)

;;     ;; * TAB: セクションの表示を切り替える
;;     ;; * M-1, M-2, M-3, M-4: セクション表示の切り替え
;;     ;; * Section: Untracked file
;;     ;;       o s: ファイルをステージに追加する(git add)
;;     ;;       o i: .gitignoreにファイルを追加する
;;     ;;       o C-u i: ignoreファイルを指定する
;;     ;;       o I: .git/info/excludeにファイルを追加する
;;     ;;       o k: ファイルを削除する*1

;;     ;; * Section: Unstaged Changing / Staged Changing
;;     ;;       o s: ファイルをステージに追加する(git add)
;;     ;;       o S: 全ファイルをステージに追加する
;;     ;;       o u: ファイルをステージから降ろす
;;     ;;       o U: 全ファイルをステージから降ろす
;;     ;;       o k: 変更を取り消す
;;     ;;       o c: コミットログを書く
;;     ;;       o C: コミットログをチェンジログ形式で書く？
;;     ;;       o C-c C-c: コミットする(git commit)
;;     ;;       o C-c C-a: コミットをやり直す(git commit --amend)

;;     ;; * Log
;;     ;;       o l: ログ一覧を表示する(git log)
;;     ;;       o L: 詳細ログの一覧を表示する(git log --stat)
;;     ;;       o ログを選択して RET: ログの詳細を表示する(git log -p)
;;     ;;       o a: コミットを今のブランチに適用する(git cherry-pick & NOT commit)
;;     ;;       o A: コミットを今のブランチに適用し、コミットする(git cheery-pick & git commit)
;;     ;;       o v: コミットを取り消す(git revert)
;;     ;;       o C-w: コミットのsha1ハッシュをコピーする
;;     ;;       o =: 今のコミットとの差分を表示する
;;     ;;       o .: コミットをマークする

;;     ;; * h or H: 今のHEADまでのログを表示する
;;     ;; * d: ワーキングコピーからあるコミットまでの差分を表示する(git diff)
;;     ;; * D: 2つのコミットの差分を表示する
;;     ;; * t or T: タグを作成する(git tag)
;;     ;; * x: コミットを取り消す(git reset --soft)
;;     ;; * X: コミットと変更を取り消す(git reset --hard)

;;     ;; * Stash
;;     ;;       o z: stashを作成する(git stash)
;;     ;;       o a: stashを適用する(git stash apply)
;;     ;;       o A: stashをpopする(git stash pop)
;;     ;;       o k: stashをdropする(git stash drop)

;;     ;; * b: ブランチを切り替える(git checkout)
;;     ;; * B: 新規ブランチを作成して切り替える(git checkout -b)
;;     ;; * w: wazzup?
;;     ;; * m or M: マージを行う
;;     ;;       o X: 手動マージを中止する
;;     ;;       o e: resolved conflict?
;;     ;; * R: rebase
;;     ;; * P: push (default remote, current branch)
;;     ;; * f: git remote update
;;     ;; * F: pull
;;     ;; * git svn
;;     ;;       o N c: git svn commit
;;     ;;       o N r: git svn rebase

;; ;; git amend

;; ;;   magitの画面から c を押すとコミットメッセージのバッファが表示されますが、そこでC-c C-aを押すと
;; ;;   amend状態になって、直前のコミットに差分を追加できます

;; ;; Untrackのファイルも含めてすべてaddする
;; ;;   magitのSキーだけだと、Untrackのファイルはaddされないのですが、C-u S とすると全て(Untrackも含む)のファイルが
;; ;;   addされます

;; ;; 指定のコミットからのログを見る

;; ;;   magitのlキーだけだと、現在いるブランチのログを出力します。しかし、これからマージするブランチと現在のブランチの
;; ;;   間のログを見ようと思ったときには、C-u lを使うとよいです。どこからどこまでということを聞いてきてくれるので、
;; ;;   それを入力するだけで、欲しいログを閲覧できます。
