;; (princ "hoge")
;; (princ (pwd))

;; (pwd)
;; (unless (string= "/" (directory-file-name default-directory))

;; emacs --script ~/.emacs.d/elisp/script/symfony-command.el

;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-
;; 使用法
;; $ emacs --script path/to/make-dummy-file.el ディレクトリ名 開始番号 終了番号
;; $ emacs --script path/to/make-dummy-file.el ~/tmp 1 3
;; $ ls ~/tmp
;; 001_dummy_data.txt  002_dummy_data.txt  003_dummy_data.txt
;; (defun get-stdin-buffer ()
;;   (let ((buf-name "*stdin*"))
;;     (or (get-buffer buf-name) ; バッファがすでに存在する場合はそのまま返す
;;         (let ((buffer (generate-new-buffer buf-name))) ; なければバッファを作成して
;;           (with-current-buffer buffer ; そのバッファを一時的にカレントバッファにする
;;             (condition-case nil ; EOFに達したときに発生するエラーを抑制するためのおまじない
;;                 (let (line)
;;                   (while (setq line (read-line)) ; 一行読み出して
;;                     (insert line "\n"))) ; その一行をカレントバッファに挿入する
;;               (error nil)))
;;           buffer))))                    ; 作成したバッファを返す
;; (set-buffer (get-stdin-buffer)) ; 標準入力バッファをカレントバッファにして
;; (occur (nth 0 command-line-args-left)) ; occur関数を実行する
;; (set-buffer "*Occur*") ; *Occur*バッファをカレントバッファにして
;; (forward-line 1)
;; (princ (buffer-substring (point) (point-max))) ; 標準出力に出力する 

;; while [ 1 ]; do
;;     if [ -f 'symfony' ]; then
;;         symfony $*
;;         exit $?
;;     fi

;;     cd ..
;;     if [ "$PWD" = "/" ]; then
;;         echo 'cannot find symfony project directory'
;;         exit 1
;;     fi
;; done


;; (defun cc ()
;;   "プロジェクトのトップディレクトリ以下なら symfony cc"
;;   (interactive)
;;   (labels 
;;     ((find-file-upward (name &optional dir)
;;       (let ((default-directory (file-name-as-directory (or dir default-directory)))) 
;;         (if (file-exists-p name) (expand-file-name name)
;;           (unless (string= "/" (directory-file-name default-directory))
;;             (find-file-upward name (expand-file-name ".." default-directory)))))))
;;   (with-temp-buffer
;;     (and (find-file-upward "symfony")
;;       (when (= (call-process (find-file-upward "symfony")  nil t t "cc") 0)
;;         (message "%s" (buffer-string)))))))


;; (file-name-nondirectory buffer-file-name)
;; "2010-03-03-172401.howm"

;; (buffer-file-name)
;; "/home/mrkz/Dropbox/howm/2010/03/2010-03-03-172401.howm"
;; buffer-file-name
;; "/home/mrkz/Dropbox/howm/2010/03/2010-03-03-172401.howm"
;; (file-name-sans-extension
;;            (file-name-nondirectory (buffer-file-name)))
;; "2010-03-03-172401"
;; (or (file-name-extension (buffer-file-name)) "")
;; "howm"
;; (directory-file-name "/home/mrkz/Dropbox/howm/2010/03/")
;; "/home/mrkz/Dropbox/howm/2010/03"
;; (directory-file-name "/home/mrkz/Dropbox/howm/2010/03/2010-03-03-172401.howm")
;; "/home/mrkz/Dropbox/howm/2010/03/2010-03-03-172401.howm"

;; (file-name-as-directory "/home/mrkz/Dropbox/howm/2010/03/2010-03-03-172401.howm")
;; "/home/mrkz/Dropbox/howm/2010/03/2010-03-03-172401.howm/"

;; (file-name-directory "/home/mrkz/Dropbox/howm/2010/03/2010-03-03-172401.howm")
;; "/home/mrkz/Dropbox/howm/2010/03/"
;; (file-name-directory (buffer-file-name))
;; "/home/mrkz/Dropbox/howm/2010/03/"
