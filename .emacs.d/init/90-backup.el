;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;;？？？バックアップファイルを作らない
;; 他のパラメータの設定がなんであれ、バックアップファイルは作らない
(setq backup-inhibited t)

;; ~付きバックアップファイル

(setq make-backup-files nil)  	 ;バックアップファイル（*~）を作らない

;;; 終了時にオートセーブファイルを消す
(setq delete-auto-save-files t)

;; #付きバックアップファイル
(setq make-backup-files nil); #filename というバックアップファイルを作らない
;(setq auto-save-timeout 30)   ; 自動保存する間隔。秒。
;(setq auto-save-interval 300) ; 300打鍵ごとに自動保存


; 番号つきバックアップファイル、世代バックアップファイル
(setq make-backup-files nil)       ; バックアップファイルを作成しない
;;; バックアップファイルの保存場所を指定。
(setq backup-directory-alist
      (cons (cons "\\.*$" (expand-file-name "~/.backup"))
            backup-directory-alist))

;; (setq version-control t)     ; Emacsが作るバックアップファイルをfilename~というのからfilename.~n~にすし、世代かんり。
;; (setq kept-new-versions 5)   ; 新しいものをいくつ残すか
;; (setq kept-old-versions 5)   ; 古いものをいくつ残すか
;; (setq delete-old-versions t) ; 確認せずに古いものを消す。
;; (setq vc-make-backup-files t) ; バージョン管理下のファイルもバックアップを作る。
;; (setq trim-versions-without-asking t); バックアップファイルを上書きするときに警告を出す



;; http://fun.poosan.net/sawa/index.php?UID=1176631703
;; バックアップファイルの名前を絶対パスっぽくする


;; デフォルトの Emacs は test~ ってな感じにチルダが付いた名前であちこちにバックアップファイルを作って鬱陶しい。backup-directory-alist で保存場所を指定するのもいいのですが、これだと元々のファイルがどこにあったか分からず不便。そこで

(setq backup-by-copying t)
(defadvice make-backup-file-name
  (around modify-file-name activate)
  (let ((backup-dir "~/backup")) ;; 保存ディレクトリ
    (setq backup-dir (expand-file-name backup-dir))
    (unless (file-exists-p backup-dir)(make-directory-internal backup-dir))
    (if (file-directory-p backup-dir)(let* ((file-path (expand-file-name file))
                                            (chars-alist '((?/ . (?#))(?# . (?# ?#))(?: . (?\;))(?\; . (?\; ?\;))))
                                            (mapchars(lambda (c) (or (cdr (assq c chars-alist)) (list c)))))
                                       (setq ad-return-value(concat backup-dir "/"(mapconcat 'char-to-string
                                                                                             (apply 'append (mapcar mapchars file-path)) "")))) ad-do-it)))

;; という設定を .emacs.el にするとファイル名を絶対パスっっぽい名前で(/の代わりに#)で ~/backup にバックアップします。
;; /home/sawa/file.txt → #home#sawa#file.txt
;; C:\doc\file.txt → c;#doc#file.txt
;; ちなみに /tmp 以下のファイルはバックアップしません。謎。
;; この elisp は大昔にMeadow掲示板で流れていた物です。
