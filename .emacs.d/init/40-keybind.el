; キーボードマクロ
(global-set-key (kbd "C-5") 'kmacro-call-macro)
(global-set-key (kbd "C->") 'kmacro-start-macro)
(global-set-key (kbd "C-<") 'kmacro-end-macro)


;; pointから行頭までを削除
(defun my-kill-line0 ()
  (interactive)
  (if (eq real-last-command this-command)
      (delete-backward-char 1)
    (kill-line 0)))

(global-set-key (kbd "C-c k") 'my-kill-line0)
(global-set-key (kbd "C-c C-k") 'my-kill-line0)


;; http://d.hatena.ne.jp/l1o0/20100201/1265030713
;; 行末に飛ぶ。連続で実行したときは、後ろについている空白とタブを削除
(defun my-end-of-line ()
  (interactive)
  (end-of-line)
  (if (eq real-last-command this-command)
      (delete-horizontal-space)))

(global-set-key "\C-e" 'my-end-of-line)

(defun my-move-beginning-of-line ()
  (interactive)
  (if (bolp)
      (back-to-indentation)
      (beginning-of-line)))

(global-set-key (kbd "C-a") 'my-move-beginning-of-line)


(defun forward-word+1 ()
  "forward-word で単語の先頭へ移動する"
  (interactive)
  (forward-to-word 1))

(defun my-forward-to-word (arg)
  (interactive "p")
  (or (re-search-forward (if (> arg 0) "\\(\\W\\b\\|.$\\)" "\\b\\W") nil t arg)
      (goto-char (if (> arg 0) (point-max) (point-min)))))

(global-set-key (kbd "C-M-f") 'my-forward-to-word)
(global-set-key (kbd "C-M-b") 'backward-word)
(global-set-key (kbd "C-M-w") 'kill-ring-save)

(defun my-thing-at-point (thing)
 (if (get thing 'thing-at-point)
     (funcall (get thing 'thing-at-point))
   (let ((bounds (bounds-of-thing-at-point thing)))
     (if bounds
         (let ((ov (make-overlay (car bounds) (cdr bounds))))
           (overlay-put ov 'face 'region)
           (sit-for 3)
           (delete-overlay ov)
           (buffer-substring (car bounds) (cdr bounds)))))))

;; ;; C-q のキーマップを作成
(defvar ctl-q-map (make-keymap))  ;ctrl-q-map という変数を新たに定義
(define-key global-map (kbd "C-q") ctl-q-map) ;ctrl-q-map を Ctrl-q に割り当てる
;; (define-key ctl-q-map (kbd "C-w") 'kill-new-things-at-point) ;C-q C-wでkill-new-things-at-pointを実行
(define-key ctl-q-map (kbd "C-w") (lambda () (interactive) (kill-new (my-thing-at-point 'symbol))))
(define-key ctl-q-map (kbd "C-e") (lambda () (interactive) (kill-new (my-thing-at-point 'word))))
(define-key ctl-q-map (kbd "C-r") (lambda () (interactive) (kill-new (my-thing-at-point 'sexp))))
(define-key ctl-q-map (kbd "C-p") 'helm-projectile-ag)
;; (define-key ctl-q-map (kbd "C-i") 'ac-complete-look)
(define-key ctl-q-map (kbd "C-j") 'delete-other-windows)
(define-key ctl-q-map (kbd "C-M-j") 'delete-other-frames)
;; (define-key ctl-q-map (kbd "C-g") 'vc-annotate)

(define-key ctl-q-map (kbd "C-l") (lambda () (interactive) (projectile-find-file)))

;(define-key ctl-q-map (kbd "C-b") 'your-favorite-funcb)
(define-key ctl-q-map (kbd "C-q") 'quoted-insert) ;元々の関数

;; ダブルクオート，クオートを入力しやすくする
(global-set-key (kbd "C-9") (defun my-insert-double-quote () (interactive) (insert "\"")))
(global-set-key (kbd "C-0") (defun my-insert-single-quote () (interactive) (insert "\'")))
(global-set-key (kbd "C-7") (defun my-insert-back-quote () (interactive) (insert "\`")))


