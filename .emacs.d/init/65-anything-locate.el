;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

(require 'anything-locate)
(require 'locate)

;; M-x locate で $HOME 以下を locate する
;; Project top 以下で M-x plocate する

;; locate db のファイル名
(defvar locate-db-name "locate.db")
;; locate コマンド
(setq locate-command "/usr/bin/locate.findutils")

;; locate コマンドラインを作る為の共通関数
(defun locate-make-command-line (search-string dbpath &rest opts)
  (append
   ;; 大文字小文字を無視するように設定
   (list locate-command "-i")
   (when (and dbpath (file-exists-p dbpath))
     (list "-d" dbpath))
   opts
   (list search-string)))

;; home 以下のファイルを探す為の locate コマンドライン
(defun home-locate-make-command-line (search-string &optional &rest opts)
  (apply 'locate-make-command-line
         search-string
         ;; home 直下の locate.db を使うように指定
         (expand-file-name locate-db-name "~")
         opts))
;; 標準の locate で home 以下を探すように設定する。
(setq locate-make-command-line 'home-locate-make-command-line)



;;  『元記事は、name がフルパスだから問題ないんでしょうね。
;; →(setq locate-command "/usr/bin/locate.findutils")

;; file-exists-p() は引数がフルパスでない場合は、default-directory で探します。
;; let で default-directory を括るか、name をフルパスで指定してあげれば良いと思います。
;; 動く
;; (defun find-file-upward (name &optional dir)
;;   (let ((default-directory (file-name-as-directory (or dir default-directory))))
;;     (if (file-exists-p name)
;;         (expand-file-name name)
;;       (if (string= "/" (directory-file-name default-directory))
;;           nil
;;         (find-file-upward name (expand-file-name ".." default-directory))))))

;; (defun find-file-upward (name &optional dir)
;;   (let ((default-directory (file-name-as-directory (or dir default-directory))))
;;     (if (file-exists-p name) (expand-file-name name)
;;       (if (string= "/" (directory-file-name default-directory)) nil
;;         (find-file-upward name (expand-file-name ".." default-directory))))))
(defun find-file-upward (name &optional dir)
  (let ((default-directory (file-name-as-directory (or dir default-directory))))
    (if (file-exists-p name) (expand-file-name name)
      (unless (string= "/" (directory-file-name default-directory))
        (find-file-upward name (expand-file-name ".." default-directory))))))


;; 指定したファイルを dir を起点に探す為の関数
;; (defun find-file-upward (name &optional dir)

;;   (setq dir (file-name-as-directory (or dir default-directory)))
;;   ;(setq dir (file-name-as-directory default-directory))
;; (insert dir)

;;   (cond
;;    ((string= dir (directory-file-name dir)) ;;終了条件 / まできた。
;;     nil)
;; ;   ((file-exists-p "locate.db")
;;    ((file-exists-p "actions.class.php")
;;     (message "message")
;;     ;(expand-file-name name dir))
;;     (expand-file-name "locate.db" dir))
;;    (t
;;     (find-file-upward name (expand-file-name ".." dir)))))



;; プロジェクト毎の locate db を使った locate コマンドライン
(defun plocate-make-command-line (search-string &optional &rest opts)
  (apply 'locate-make-command-line
         search-string
         ;(expand-file-name locate-db-name "/opt/ntv4/src/integrated")
         (find-file-upward locate-db-name)
         opts))


;; プロジェクト毎の locate db を使った locate コマンド
(defun plocate (search-string &optional arg)
  (interactive
   (list
    (locate-prompt-for-search-string)
    current-prefix-arg))
  (let ((locate-make-command-line 'plocate-make-command-line))
    (locate search-string nil arg)))

;; 以下はanything から利用するための設定

;; symfony cc メモ
;;(call-process (find-file-upward "symfony" "/opt/scoo/src/apps")  nil t t "cc")


;; (defun cc ()
;;   "プロジェクトのトップディレクトリ以下なら symfony cc"
;;   (interactive)
;;   (with-temp-buffer
;;     (let ((ret (call-process (find-file-upward "symfony")  nil t t "cc")))
;;       (when (or (and (numberp ret) (/= ret 0))
;;                 (and (stringp ret) (not (string-equal ret ""))))
;;         (message "%s" (buffer-string))))))


(defun lpho-switch-to-previous-buffer ()
  "直前のバッファと行き来する"
  (interactive)
  (condition-case err
      (labels
          ((_lpho-switch-to-previous-buffer (target)
            (if (null (member (buffer-name (cadr target))
                              lpho-ignore-list))
                (switch-to-buffer (cadr target))
              (_lpho-switch-to-previous-buffer (cdr target)))))
        (_lpho-switch-to-previous-buffer (buffer-list)))
    (error (message "error: %s" (error-message-string err)))))

(defun symfony-cc ()
  "プロジェクトのトップディレクトリ以下なら symfony cc"
  (interactive)
  (labels
    ((find-file-upward (name &optional dir)
      (let ((default-directory (file-name-as-directory (or dir default-directory))))
        (if (file-exists-p name) (expand-file-name name)
          (unless (string= "/" (directory-file-name default-directory))
            (find-file-upward name (expand-file-name ".." default-directory)))))))
  (with-temp-buffer
    (and (find-file-upward "symfony")
      (when (= (call-process (find-file-upward "symfony")  nil t t "cc") 0)
        (message "%s" (buffer-string)))))))




(defvar anything-c-source-home-locate
  '((name . "Home Locate")
    (candidate . (lambda ()
                   (apply 'start-process "anything-home-locate-process" nil
                      (home-locate-make-command-line anything-pattern "-r"))))
    (type . file)
    (requires-pattern . 3)
    (delayed)))

(defvar anything-c-source-plocate 
  '((name . "Project Locate")
     (candidate
      . (lambda ()
         (let ((default-directory (with-current-buffer anything-current-buffer default-directory)))
           (apply 'start-process "anything-plocate-process" nil 
             (plocate-make-command-line anything-pattern "-r")))))
   (type . file)
   (requires-pattern . 3)
   (delayed)))


(defun anything-locate ()
  "locate"
  (interactive)
  (anything (list
             anything-c-source-plocate
             anything-c-source-home-locate
             )
            nil nil nil nil "*locate*"))
