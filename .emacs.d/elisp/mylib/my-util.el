;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

(eval-when-compile (require 'cl))

;; (global-set-key (kbd "C-:") 'my-inner-trim)
;; "a     b" -> "ab"
(defun my-inner-trim ()
  (interactive)
  (skip-syntax-backward " " (line-beginning-position))
  (set-mark (point))
  (skip-syntax-forward " " (line-end-position))
  (delete-region (mark) (point)))

(defun my-file-name (arg)
  (interactive "p")
  (insert (file-name-nondirectory buffer-file-name)))

(defun my-insert-zenkaku-space ()
  (interactive)
  (insert "　"))

(defalias 'z 'my-insert-zenkaku-space)

(defalias 'p 'prin1-to-string)


(defun svn-status-remove-control-M ()
  "Remove ^M at end of line in the whole buffer."
  (interactive)
  (let ((buffer-read-only nil))
    (save-match-data
      (save-excursion
        (goto-char (point-min))
        (while (re-search-forward "\r$" (point-max) t)
          (replace-match "" nil nil))))))

(defalias 'delete-M 'svn-status-remove-control-M)

(defun xsteve-remove-control-M ()
  "Remove ^M at end of line in the whole buffer."
  (interactive)
  (save-match-data
    (save-excursion
      (let ((remove-count 0))
        (goto-char (point-min))
        (while (re-search-forward (concat (char-to-string 13) "$") (point-max) t)
          (setq remove-count (+ remove-count 1))
          (replace-match "" nil nil))
        (message (format "%d ^M removed from buffer." remove-count))))))

(defun ubuntup ()
  (and (executable-find "lsb_release")
       (string= (car (split-string (shell-command-to-string "lsb_release -ds"))) "Ubuntu")))

(defun sudo-open ()
  "Open the current open file via tramp and the /su:: or /sudo:: protocol"
  (interactive)
  (let ((running-ubuntu
         (and (executable-find "lsb_release")
              (string= (car (split-string (shell-command-to-string "lsb_release -ds"))) "Ubuntu"))))
    (find-file (concat (if running-ubuntu "/sudo::" "/su::") (buffer-file-name)))))



(defun my-html-format-region (begin end)
  "リージョンの HTML を整形する"
  (interactive "r")
  (unless (executable-find "hamcutlet.rb")
    (error "hamcutlet.rb 利用できません"))
  (let ((text (buffer-substring-no-properties begin end)))
    (delete-region begin end)
    (call-process "hamcutlet.rb" nil t 0 text)))



(defalias 'htmlf 'my-html-format-region)
;; (global-set-key (kbd "M-i") 'my-html-format-region)

;; http://d.hatena.ne.jp/kitokitoki/20101126/p2
(defun my-js-format-region (begin end)
  "リージョンの javascript を整形"
  (interactive "r")
  (if (executable-find "beautify_js")
      ;; (call-process-region begin end "beautify_js" t t nil "-i 4")
      (call-process-region begin end "emacs-beautify_js" t t nil "-i 4")
    (message "beautify_js が実行できません")))

(defalias 'jsf 'my-js-format-region)


(defun byte-compile-this-file ()
  (interactive)
  (byte-compile-file (buffer-file-name)))
(defalias 'bt 'byte-compile-this-file)

;; (defun rurema-search ()
;;   (interactive)
;;   (let ((word (completing-read "search word:" rurema-search-candidate)))
;;     (browse-url (format "http://rurema.clear-code.com/query:%s/" word))))

;; (setq rurema-search-candidate '("hoge" "fuga"))

(defun rurema-search ()
  (interactive)
  (let ((word (read-from-minibuffer "search word:")))
    (browse-url (format "http://rurema.clear-code.com/query:%s/" word))))

(defadvice rgrep (before my-rgrep activate)
  "*grep*バッファがあれば、それを削除するか確認する"
  (when (get-buffer "*grep*")
    (when (y-or-n-p "現在の *grep* を削除しますか")
      (kill-buffer (get-buffer "*grep*")))))

;;左右分割
(defun my-pop-to-buffer-horizontally (buffer-or-name)
  (let ((split-width-threshold 1))
    (pop-to-buffer buffer-or-name)))
;;(my-pop-to-buffer-horizontally "*Messages*")

(defun sqlf (start end)
  "リージョンのSQLを整形する"
  (interactive "r")
  (let ((case-fold-search t))
    (let* ((s (buffer-substring-no-properties start end))
           (s (replace-regexp-in-string "\\(select \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(update \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(insert into \\)\\(fuga\\)\\(fuga\\)" "\n\\2\n  " s))
           (s (replace-regexp-in-string "\\(delete from \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(create table \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(alter table \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(drop constraint \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(from \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(exists \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(where \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(values \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(order by \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(group by \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(having \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(left join \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(left outer join )\\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(right join \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(right outer join \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(inner join \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(cross join \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(union join \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(and \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(or \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(any \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(on update restrict \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(on update cascade \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(on update set null \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(on update no action \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(on delete restrict \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(on delete cascade \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(on delete set null \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(on delete no action \\)" "\n\\1\n  " s))
           (s (replace-regexp-in-string "\\(,\\)" "\\1\n  " s)))
    (save-excursion
      (insert s)))))

(defun insert-pwd ()
  ;; カレントディレクトリをバッファに挿入
  (interactive)
  (call-process "pwd" nil t)
)
(defun uniq-region (begin end)
  ;; リージョンに対して"uniq"を実行
  (interactive "r")
  (call-process-region begin end "uniq" t t))

(defun sort-u-region (begin end)
  ;; リージョンに対して"sort -u"を実行
  (interactive "r")
  (call-process-region begin end "sort" t t nil "-u"))

(defun numbering-region (begin end)
  ;; リージョンに対してナンバリング
  (interactive "r")
  (call-process-region begin end "nl" t t ))


;; '(a b c d) とあって c が与えられたとき、その直前の (a b) が欲しい
(eval-when-compile (require 'cl))

(defun find-before (val list)
 (subseq list 0 (position val list)))

(defun my-hoge1 (val lst)
  (let ((ret nil))
    (catch 'found
      (while lst
        (if (equal val (car lst))
            (throw 'found t)
          (setq ret (append ret (list (car lst))))
          (setq lst (cdr lst)))))
    ret))

(defun my-hoge2 (val lst ret)
  (if (equal val (car lst))
      ret
    (setq ret (append ret (list (car lst))))
    (my-hoge2 val (cdr lst) ret)))

;; テストコード
;; (expectations
;;    (desc "'(a b c d) とあってcが与えられたとき、その直前の(a b)が欲しい")
;;    (expect '(1 2)
;;      (my-hoge1 3 '(1 2 3 4)))
;;    (expect '(1 2)
;;      (my-hoge2 3 '(1 2 3 4) nil)))

(defun my-skip-whitespace ()
  "Move forward until non-whitespace is reached."
  (while (looking-at "[ \t]")
    (forward-char)))


(defun kill-buffer-if-exist (buf)
 "存在したバッファを削除したなら t, バッファが存在しなかったなら nil を返す"
 (when (buffer-live-p buf)
   (kill-buffer buf)))


(defun my-japan-color()
  (interactive)
  (browse-url "http://2xup.org/repos/"))


(defun my-get-num ()
  (interactive)
    (re-search-forward "\\([1-9]+\\)" nil t)
    (buffer-substring-no-properties (match-beginning 0) (match-end 1)))

(defun my-get-num-in-str (str)
  (interactive)
  (with-temp-buffer
    (insert str)
    (goto-char (point-min))
    (get-num)))

(defun my-eval-string (str)
  (eval (with-temp-buffer
          (insert str)
          (read (buffer-string)))))


;; はコピペできないので、C-q M で入力して下さい
(defun my-delete-M (start end)
  (interactive "r")
  (save-restriction
    (narrow-to-region start end)
    (goto-char (point-min))
    (while (re-search-forward "$" nil t) (replace-match "" nil t))))

;; 実行例
;; (eval-string "(message \"hoge\")") => hoge
;; ちなみに，S式を文字列に変換するにはformatを使うとよい．
;; (format "%S" '(message "hoge")) =>  "(message \"hoge\")"


(defmacro* with-temp-directory (dir &body body)
  `(with-temp-buffer
     (cd ,dir)
     ,@body))

;; (my-get-filename (list "/opt/jobeet/web/css" "~/hoge/"))
;; ;=>
;; ("/home/mrkz/hoge/fuga1/piyo/bb.php" "/home/mrkz/hoge/fuga1/aa.txt" "/home/mrkz/hoge/fufsddgae.el" 
;; "/home/mrkz/hoge/fuga.txt" "/opt/jobeet/web/css/admin.css" "/opt/jobeet/web/css/job.css"
;;  "/opt/jobeet/web/css/jobs.css" "/opt/jobeet/web/css/main.css")

;(my-get-filename (list "~/Dropbox/howm/"))
(defun my-get-filename (file-list)
    (loop for x in file-list
          with path-list = nil
          when (file-directory-p x)
            for path-list =
              (append
                (my-get-filename
                 (remove-if
                  (lambda(y) (string-match "\\.$\\|\\.svn" y))
                  (directory-files x t)))
                path-list)
          else
            collect x into path-list            
          end
          finally return path-list))
;; (anything
;;  `(((name . "grep-test")
;;     (grep-candidates . ,(my-get-filename (list "~/Dropbox/howm/")))
;;     (header-name . (lambda (x) (concat x ": " anything-pattern)))
;;     (candidate-number-limit . ,anything-hatena-bookmark-candidate-number-limit)
;;     (action . message))))

(defun dirs-children (dirs &optional exclude)
  (let ((exclude* (or exclude (mapconcat 'identity '("\\.\\{1,2\\}$" "\\.git$" "\\.svn$") "\\|"))))
    (nreverse
     (reduce 
      #'(lambda (acc file)
          (cond ((and exclude* (string-match exclude* file)) acc)
                ((file-directory-p file)
                  (let ((children (directory-files file t)))
                    (cons* (dirs-children children exclude*) acc)))
                (t (cons file acc))))
     dirs :initial-value nil))))

(defun cons* (xs ys)
  (reduce #'(lambda (acc x) (cons x acc))  xs :initial-value ys))

;;reverse-append
(dirs-children (list "/opt/jobeet/web/css" "~/hoge/"))

;cons*という名前はだめかも。(cons* 1 2 '(3)) => '(1 2 3)という感じだし。無難に reverse-append とかに名前を変えておくべきかも。

(defun catdir (s1 s2)
  (let ((s1 (replace-regexp-in-string (rx "/" eol) "" s1))
        (s2 (replace-regexp-in-string (rx bol "/") "" s2)))
    (concat s1 "/" s2)))
;;(catdir "ee" "rr")

(defun my-shell-command-maybe (exe &optional paramstr)
  "(my-shell-command-maybe "ls" "-l -a")"
  (if (executable-find exe)
    (shell-command (concat exe " " paramstr))
    (error (concat "'" exe "' not found"))))
;    (message (concat "'" exe "' not found"))))


;;; For compatibility
(unless (fboundp 'region-active-p)
  (defun region-active-p ()
    (and transient-mark-mode mark-active)))



;;cheack-filesがtarget-filesに含まれているか
(defun fukusu-file-gaaruka (target-files cheack-files)
  (interactive)
    (every
     (lambda (file)
       (find file
             target-files
             :test 'string=))
     cheack-files))

;; (fukusu-file-gaaruka '("symfony" "apps" "config") '("symfony" "apps" "config"))
;; (fukusu-file-gaaruka '("symfony" "apps" "config") '("symfony" "apps" "a"))

;;
(defun my-take (n lst)
  (interactive)
  (if (or (>= 0 n) (null lst)) nil
    (cons (car lst)
          (my-take (- n 1) (cdr lst)))))
;;(take 3 '(a b c d e f))

(defun take (n l)
  (cond ((< n 0) (error "index negative"))
        ((= n 0) ())
        ((null l) (error "index too large"))
        (t (cons (car l) (take (- n 1) (cdr l))))))



(defun my-flatten (lis)
  (interactive)
  (cond ((atom lis) lis)
        ((listp (car lis))
         (append (my-flatten (car lis)) (my-flatten (cdr lis))))
        (t (append (list (car lis)) (my-flatten (cdr lis))))))

;;(my-flatten '(a b c ((d) e) f))


(defun my-get-fullpass-by-dir-name (dir)
  "ディレクトリ名を渡すとフルパスで直下のファイル返す関数"
  (loop for e in (directory-files dir)
        collect (expand-file-name e dir)))
;(my-get-fullpass-by-dir-name "~/.emacs.d/elisp/")

(defun my-rstrip (str)
  (replace-regexp-in-string "[ \t\n]*$" "" str))

(defun my-lstrip (str)
  (replace-regexp-in-string "^[ \t\n]*" "" str))

(defun my-strip (str)
  (my-lstrip (my-rstrip str)))

(defun my-trim (s)
  (replace-regexp-in-string
   "[ \t\n]+$" "" (replace-regexp-in-string "^[ \t\n]+" "" s)))


;;引数で指定したバッファを表示しているウィンドウへ移動
;;(my-select-window "*scratch*")
(defun my-select-window (buffer)
  (condition-case err
    (select-window (car (get-buffer-window-list buffer)))      
    (error (message "error: %s" (error-message-string err)))))


;; (my--message "hoge")
;; (defun my-message (text)
;;   (unless (active-minibuffer-window)
;;     (message text)))

;; 制御文字をふつうの文字^Hなどに置き換える
(defun cat-v-region (begin end)
  " リージョンに対して cat -v を実行"
  (interactive "r")
  (shell-command-on-region begin end "cat -v" t))


(defun xor (arg1 arg2)
  (not (eq arg1 arg2)))

(defun fact (n)
  (if (zerop n)
      1
      (* n (fact(- n 1)))))

(defun my-get-face-documentation ()
  "ポイント位置のフェイスの説明をエコーエリアに表示する"  
  (interactive)
  (message (face-documentation (get-text-property (point) 'face))))

(defun my-get-face-name ()
  "ポイント位置のフェイス名をエコーエリアに表示する"
  (interactive)
  (message (prin1-to-string (get-text-property (point) 'face))))

;; http://d.hatena.ne.jp/rubikitch/20100211/hatebu
(defun start-process-to-variable (variable command &rest args)
  "コマンドの実行結果を変数に格納する。(非同期)"
  (lexical-let ((variable variable)
                (buf (get-buffer-create " start-process-to-variable")))
    (set-process-sentinel
     (apply 'start-process "start-process-to-variable" buf command args)
     (lambda (&rest ignore)
       (with-current-buffer buf
         (set variable (buffer-substring 1 (1- (point-max))))
         (erase-buffer))))))
;; (start-process-to-variable 'var "pwd")
;; var
;=> "/home/me"


;;http://nullprogram.com/blog/2010/05/11/ ネタ
;; (defun uuid-create ()
;;   "Return a newly generated UUID. This uses a simple hashing of variable data."
;;   (let ((s (md5 (format "%s%s%s%s%s%s%s%s%s%s"
;;                         (user-uid)
;;                         (emacs-pid)
;;                         (system-name)
;;                         (user-full-name)
;;                         user-mail-address
;;                         (current-time)
;;                         (emacs-uptime)
;;                         (garbage-collect)
;;                         (random)
;;                         (recent-keys)))))
;;     (format "%s-%s-3%s-%s-%s"
;;             (substring s 0 8)
;;             (substring s 8 12)
;;             (substring s 13 16)
;;             (substring s 16 20)
;;             (substring s 20 32))))

;; (defun uuid-insert ()
;;   "Inserts a new UUID at the point."
;;   (interactive)
;;   (insert (uuid-create)))


;; http://nullprogram.com/blog/2010/09/30/
(defun find-all-files (dir)
  "Open all files and sub-directories below the given directory."
  (interactive "DBase directory: ")
  (let* ((list (directory-files dir t "^[^.]"))
         (files (remove-if 'file-directory-p list))
         (dirs (remove-if-not 'file-directory-p list)))
    (dolist (file files)
      (find-file-noselect file))
    (dolist (dir dirs)
      (find-file-noselect dir)
      (find-all-files dir))))


;; http://stackoverflow.com/questions/384284/can-i-rename-an-open-file-in-emacs
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive
   (progn
     (when (not (buffer-file-name))
       (error "Buffer '%s' is not visiting a file!" (buffer-name)))
     (list (read-file-name (format "Rename %s to: " (file-name-nondirectory
                                                     (buffer-file-name)))))))
  (when (equal new-name "")
    (error "Aborted rename"))
  (setq new-name (if (file-directory-p new-name)
                     (expand-file-name (file-name-nondirectory
                                        (buffer-file-name))
                                       new-name)
                   (expand-file-name new-name)))
  ;; If the file isn't saved yet, skip the file rename, but still update the
  ;; buffer name and visited file.
  (if (file-exists-p (buffer-file-name))
      (rename-file (buffer-file-name) new-name 1))
  (let ((was-modified (buffer-modified-p)))
    ;; This also renames the buffer, and works with uniquify
    (set-visited-file-name new-name)
    (if was-modified
        (save-buffer)
      ;; Clear buffer-modified flag caused by set-visited-file-name
      (set-buffer-modified-p nil))
    (message "Renamed to %s." new-name)))


;; http://emacsredux.com/blog/2013/03/28/google/
(defun google ()
  "Google the selected region if any, display a query prompt otherwise."
  (interactive)
  (browse-url
   (concat
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q="
    (url-hexify-string (if mark-active
         (buffer-substring (region-beginning) (region-end))
       (read-string "Google: "))))))

(global-set-key (kbd "C-c g") 'google)

;; http://emacsredux.com/blog/2013/03/27/copy-filename-to-the-clipboard/
(defun copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))

(global-set-key (kbd "C-M-9") 'copy-file-name-to-clipboard)
(global-set-key (kbd "C-M-0") 'copy-file-name-to-clipboard)

(defun my-base64-decode ()
  (interactive)
  (base64-decode-region (region-beginning) (region-end))
  (decode-coding-region (region-beginning) (region-end) 'utf-8))

(defalias 'd 'delete-matching-lines)
(put 'downcase-region 'disabled nil)

(defun private-backup-command ()
  (interactive)
  (unless (executable-find "private-backup")
    (error "private-backup command not found. see http://..."))
    (case (call-process-shell-command (executable-find "private-backup") nil nil nil buffer-file-name)
      ((0) (message "OK! private-backup success."))
      (otherwise (message "NG. private-backup fail."))))

(global-set-key (kbd "<f12>") 'private-backup-command)

(provide 'my-util)
