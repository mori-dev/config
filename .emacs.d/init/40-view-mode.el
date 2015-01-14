;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-


;; (add-hook 'view-mode-hook
;;           (lambda ()
;;             (when (eql major-mode 'doc-view-mode)
;;               (define-key view-mode-map "-" nil)
;;               (define-key view-mode-map "n" nil)
;;               (define-key view-mode-map "p" nil)
;;               (define-key view-mode-map "j" 'next-line)
;;               (define-key view-mode-map "k" 'previous-line)
;;               )))

;; (setq view-mode-map
;;   (let ((map (make-sparse-keymap)))
;;     (define-key map "C" 'View-kill-and-leave)
;;     (define-key map "c" 'View-leave)
;;     (define-key map "Q" 'View-quit-all)
;;     (define-key map "E" 'View-exit-and-edit)
;;     ;; (define-key map "v" 'View-exit)
;;     (define-key map "e" 'View-exit)
;;     (define-key map "q" 'View-quit)
;;     ;; (define-key map "N" 'View-search-last-regexp-backward)
;;     ;; (define-key map "p" 'View-search-last-regexp-backward)
;;     ;; (define-key map "n" 'View-search-last-regexp-forward)
;;     ;; (define-key map "?" 'View-search-regexp-backward) ; Less does this.
;;     (define-key map "\\" 'View-search-regexp-backward)
;;     (define-key map "/" 'View-search-regexp-forward)
;;     (define-key map "r" 'isearch-backward)
;;     (define-key map "s" 'isearch-forward)
;;     (define-key map "m" 'point-to-register)
;;     (define-key map "'" 'register-to-point)
;;     (define-key map "x" 'exchange-point-and-mark)
;;     (define-key map "@" 'View-back-to-mark)
;;     (define-key map "." 'set-mark-command)
;;     (define-key map "%" 'View-goto-percent)
;;     ;; (define-key map "G" 'View-goto-line-last)
;;     (define-key map "g" 'View-goto-line)
;;     (define-key map "=" 'what-line)
;;     (define-key map "F" 'View-revert-buffer-scroll-page-forward)
;;     ;; (define-key map "k" 'View-scroll-line-backward)
;;     (define-key map "y" 'View-scroll-line-backward)
;;     ;; (define-key map "j" 'View-scroll-line-forward)
;;     (define-key map "\n" 'View-scroll-line-forward)
;;     (define-key map "\r" 'View-scroll-line-forward)
;;     (define-key map "u" 'View-scroll-half-page-backward)
;;     (define-key map "d" 'View-scroll-half-page-forward)
;;     (define-key map "z" 'View-scroll-page-forward-set-page-size)
;;     (define-key map "w" 'View-scroll-page-backward-set-page-size)
;;     ;; (define-key map "b" 'View-scroll-page-backward)
;;     (define-key map "\C-?" 'View-scroll-page-backward)
;;     ;; (define-key map "f" 'View-scroll-page-forward)
;;     (define-key map " " 'View-scroll-page-forward)
;;     (define-key map "o" 'View-scroll-to-buffer-end)
;;     (define-key map ">" 'end-of-buffer)
;;     (define-key map "<" 'beginning-of-buffer)
;;     ;; (define-key map "-" 'negative-argument)
;;     (define-key map "9" 'digit-argument)
;;     (define-key map "8" 'digit-argument)
;;     (define-key map "7" 'digit-argument)
;;     (define-key map "6" 'digit-argument)
;;     (define-key map "5" 'digit-argument)
;;     (define-key map "4" 'digit-argument)
;;     (define-key map "3" 'digit-argument)
;;     (define-key map "2" 'digit-argument)
;;     (define-key map "1" 'digit-argument)
;;     (define-key map "0" 'digit-argument)
;;     (define-key map "H" 'describe-mode)
;;     (define-key map "?" 'describe-mode)	; Maybe do as less instead? See above.
;;     (define-key map "h" 'describe-mode)
;;     map))

;; 一部rubikitchさんが公開されていた設定も拝借しています。さて、色々設定していますが、

;;     * ウィンドウの移動とかをctrlとかを押さずにいけるようなキーバインドを設定している
;;     * 特定のmodeでだけ、一定時間経過したら自動的にview-modeに以降する

;; というのが、自分で作成した部分です。色々無駄とか無駄とかイケてない部分がありすぎていやんなっちゃいますが、とりあえず利用できています。

;; この設定だと、同じモード間の移動だとs + h j k lでウィンドウ移動可能となっています。基本的にs + キーでウィンドウ操作をできるようにしています。

;; view-modeを活用するための設定
(setq view-read-only t)

(defvar pager-keybind
      `( ;; vi-like
        ("a" . ,(lambda () (interactive)
                  (let ((anything-c-moccur-enable-initial-pattern nil))
                    (anything-c-moccur-occur-by-moccur))))
        (";" . anything)
        ("h" . backward-word)
        ("l" . forward-word)
        ("j" . next-window-line)
        ("k" . previous-window-line)
        ("b" . scroll-down)
        (" " . scroll-up)
        ;; w3m-like
        ("m" . gene-word)
        ("i" . win-delete-current-window-and-squeeze)
        ("w" . forward-word)
        ("e" . backward-word)
        ("(" . point-undo)
        (")" . point-redo)
        ("J" . ,(lambda () (interactive) (scroll-up 1)))
        ("K" . ,(lambda () (interactive) (scroll-down 1)))
        ;; bm-easy
        ("." . bm-toggle)
        ("[" . bm-previous)
        ("]" . bm-next)
        ;; langhelp-like
        ("c" . scroll-other-window-down)
        ("v" . scroll-other-window)
        ))

(defun define-many-keys (keymap key-table &optional includes)
  (let (key cmd)
    (dolist (key-cmd key-table)
      (setq key (car key-cmd)
            cmd (cdr key-cmd))
      (if (or (not includes) (member key includes))
        (define-key keymap key cmd))))
  keymap)

(defun view-mode-hook0 ()
  (define-many-keys view-mode-map pager-keybind)
  (hl-line-mode 1)
;  (skk-mode 0)                          ; SKKを強制的に切る。
  (view-mode-set-window-controls "s")
  )
(add-hook 'view-mode-hook 'view-mode-hook0)

;; 書き込み不能なファイルはview-modeで開くように
(defadvice find-file
  (around find-file-switch-to-view-file (file &optional wild) activate)
  (if (and (not (file-writable-p file))
           (not (file-directory-p file)))
      (view-file file)
    ad-do-it))

;; 書き込み不能な場合はview-modeを抜けないように
(defvar view-mode-force-exit nil)
(defmacro do-not-exit-view-mode-unless-writable-advice (f)
  `(defadvice ,f (around do-not-exit-view-mode-unless-writable activate)
     (if (and (buffer-file-name)
              (not view-mode-force-exit)
              (not (file-writable-p (buffer-file-name))))
         (message "File is unwritable, so stay in view-mode.")
       (progn
         (hl-line-mode 0)
       ad-do-it))))

(do-not-exit-view-mode-unless-writable-advice view-mode-exit)
(do-not-exit-view-mode-unless-writable-advice view-mode-disable)

;; view-mode時に、手軽にウィンドウ移動、切替を行えるようにする。
(defvar view-mode-window-control-map nil)
(unless view-mode-window-control-map
  (setq view-mode-window-control-map (make-sparse-keymap))

  (define-key view-mode-window-control-map (kbd "l") 'windmove-right)
  (define-key view-mode-window-control-map (kbd "h") 'windmove-left)
  (define-key view-mode-window-control-map (kbd "k") 'windmove-down)
  (define-key view-mode-window-control-map (kbd "j") 'windmove-up)

  (define-key view-mode-window-control-map (kbd "d") 'delete-window)
  (define-key view-mode-window-control-map (kbd "wh") 'split-window-horizontally)
  (define-key view-mode-window-control-map (kbd "wv") 'split-window-vertically)
  (define-key view-mode-window-control-map (kbd "o") 'delete-other-windows)
)

(defvar view-mode-original-keybind nil)
(defun view-mode-set-window-controls (prefix-key)
  (unless view-mode-original-keybind
    (dolist (l (cdr view-mode-map))
      (if (equal ?s (car l))
          (setq view-mode-original-keybind (list prefix-key (cdr l))))))
  (define-key view-mode-map prefix-key view-mode-window-control-map))

(defun view-mode-unset-window-controls()
  (when view-mode-original-keybind
    (define-key view-mode-map (car view-mode-original-keybind)
      (cadr view-mode-original-keybind))
    (setq view-mode-original-keybind nil)))

(defvar view-mode-auto-change-alist '())
(defvar view-mode-auto-change-time 1.0)
(defvar view-mode-auto-change-timer nil)

(add-to-list 'view-mode-auto-change-alist "c++-mode")
(defun view-mode-set-auto-change-timer ()
  (unless view-mode-auto-change-timer
    (setq view-mode-auto-change-timer
          (run-with-idle-timer view-mode-auto-change-time t
                               '(lambda ()
                                  (if (find-if (lambda (x) (string= x major-mode)) view-mode-auto-change-alist)
                                      (view-mode)
                                    nil)))))
  )

(defun view-mode-cancel-auto-change-timer ()
  (when view-mode-auto-change-timer
    (cancel-timer view-mode-auto-change-timer)
    (setq view-mode-auto-change-timer nil))
  )

(defun view-mode-toggle-auto-change-timer ()
  (interactive)
  (if view-mode-auto-change-timer
      (view-mode-cancel-auto-change-timer)
    (view-mode-set-auto-change-timer))
  )

(define-key view-mode-map (kbd "t") 'view-mode-toggle-auto-change-timer)

;; view-modeを活用する設定 -- ここまで
