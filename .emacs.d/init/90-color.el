;; ;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; ;; (cond
;; ;;  ((eq window-system nil) (set-background-color "red"))
;; ;;  ((eq window-system 'x) (set-background-color "darkgreen"))
;; ;;  (t (set-background-color "gray15"))
;; ;;   )

;; ;; 文字色
;; (add-to-list 'default-frame-alist '(foreground-color . "gray95"))
;; ;; 背景色
;; (add-to-list 'default-frame-alist '(background-color . "black"))
;; ;; カーソルの色
;; (add-to-list 'default-frame-alist '(cursor-color . "SkyBlue4"))
;; ;; マウスポインタの色
;; (add-to-list 'default-frame-alist '(mouse-color . "SkyBlue4"))
;; ;; モードラインの文字の色
;; (set-face-foreground 'modeline "gray70")
;; ;; モードラインの背景色
;;                                         ;  (set-face-background 'modeline "MidnightBlue")
;;                                         ;  (set-face-background 'modeline "Steelblue4")
;; (set-face-background 'modeline "gray15")
;; ;; モードライン（アクティブでないバッファ）の文字色
;; (set-face-foreground 'mode-line-inactive "gray50")
;; ;; モードライン（アクティブでないバッファ）の背景色
;; (set-face-background 'mode-line-inactive "black")
;; ;; 選択中のリージョンの色
;; (set-face-background 'region "chocolate")
;; ;; 文字列の色
;; (set-face-foreground 'font-lock-string-face  "pink2")
;; ;; キーワードの色
;; (set-face-foreground 'font-lock-keyword-face "medium slate blue")
;; ;; 関数名の色
;; (set-face-foreground 'font-lock-function-name-face "light steel blue")
;; ;; コメントの色
;; (set-face-foreground 'font-lock-comment-face "light slate gray")
;; ;; コロンで始まる変数？
;; (set-face-foreground 'font-lock-builtin-face "steel blue")
;; ;; フリンジ領域(折り返しのライン) ;; foreground
;; (set-face-foreground 'fringe "gray3")
;; ;; フリンジ領域(折り返しのライン) ;; background
;; (set-face-background 'fringe "red")
;; (set-face-background 'fringe "gray3")
;; ;フリンジ領域(折り返しのライン)を背景色と同色にする
;; ;(set-face-background 'fringe (face-background 'default))
;; ;(set-face-foreground 'font-lock-variable-name-face "orange2")
;; ;(set-face-foreground 'font-lock-constant-face "orange2")
;; (set-face-foreground 'font-lock-warning-face "red4")
;; ;;検索でマッチした部分
;; (set-face-background 'match "brown")
;; ;;ハイライト(マウスでアクティブにしている部分,anythingの選択行, yank した領域)
;; (set-face-background 'highlight "brown")
;; ;;カレント行
;; (global-hl-line-mode 1)
;; (set-face-background 'hl-line "gray8")

;; ;; http://homepage1.nifty.com/blankspace/emacs/color.html
;; ;; "tty" はコンソール、"x" は X Window System、"w32" は Windows です。
;; (defface my-warnig-face1
;;   '((((type x))
;;      (:background "Salmon4"
;;                   :foreground "black"))
;;     (((type tty))
;;      (:background "blue"
;;                   :foreground "black"))
;;     (((type w32))
;;      (:background "green"
;;                   :foreground "black"))
;;     (t (:background "red"
;;                     :foreground "black")))
;;   nil)

;; (defface my-warnig-face2
;;   '((((type x))
;;      (:underline "Firebrick3"))
;;     (((type tty))
;;      (:underline "Firebrick3"))
;;     (((type w32))
;;      (:underline "Firebrick3"))
;;     (t (:underline "Firebrick3")))
;;   nil)

;; (setq my-warnig-face1 'my-warnig-face1)
;; (setq my-warnig-face2 'my-warnig-face2)

;; ;; (defadvice font-lock-mode (before my-warning-font-lock-mode ())
;; ;;   (font-lock-add-keywords
;; ;;    major-mode
;; ;;    '(("　" 0 my-warnig-face1 append)
;; ;;      ("＃" 0 my-warnig-face1 append)
;; ;;      ("’" 0 my-warnig-face1 append)
;; ;;      ("”" 0 my-warnig-face1 append)
;; ;;      ("；" 0 my-warnig-face2 append)
;; ;;      ("：" 0 my-warnig-face2 append)
;; ;;      ("／" 0 my-warnig-face2 append)
;; ;;      ("＼" 0 my-warnig-face2 append)
;; ;;      ("｜" 0 my-warnig-face1 append)
;; ;;      ("＠" 0 my-warnig-face1 append)
;; ;;      ("＋" 0 my-warnig-face1 append)
;; ;;      ("＊" 0 my-warnig-face1 append)
;; ;;      ("＠" 0 my-warnig-face1 append)
;; ;;      ("＜" 0 my-warnig-face2 append)
;; ;;      ("＞" 0 my-warnig-face2 append)
;; ;;      ("[｛｝]" 0 my-warnig-face2 append)
;; ;;      ("[（）]" 0 my-warnig-face2 append)
;; ;;      ("＄" 0 my-warnig-face1 append)
;; ;;      ("％" 0 my-warnig-face1 append)
;; ;;      ("＆" 0 my-warnig-face1 append)
;; ;;      ("．" 0 my-warnig-face2 append)
;; ;;      ("，" 0 my-warnig-face2 append)
;; ;;      ("＝" 0 my-warnig-face1 append)
;; ;;      ("～" 0 my-warnig-face2 append)
;; ;;      ("─" 0 my-warnig-face2 append)
;; ;;      ("－" 0 my-warnig-face2 append)
;; ;;                                         ;     ("ー" 0 my-warnig-face2 append)
;; ;;      ("｜" 0 my-warnig-face1 append)
;; ;;      ("＠" 0 my-warnig-face1 append)
;; ;;      ("？" 0 my-warnig-face2 append)
;; ;;      ("！" 0 my-warnig-face2 append)
;; ;;      ("\t" 0 my-warnig-face2 append)
;; ;;      ;; ("\\.\\.\\." 0 my-warnig-face2 append)
;; ;;      )))

;; ;; (ad-enable-advice 'font-lock-mode 'before 'my-warning-font-lock-mode)
;; ;; (ad-activate 'font-lock-mode)

;;                                         ;(font-lock-add-keywords 'yaml-mode '(("\\(＃\\)" 1 font-lock-warning-face t)));

;; ;;* Buffer list * の色を変更
;; ;; http://www.emacswiki.org/emacs/BufferMenuHighlighting
;; (setq buffer-menu-buffer-font-lock-keywords
;;       '(("^....[*]Man .*Man.*"   . font-lock-variable-name-face) ;Man page
;;         (".*Dired.*"             . font-lock-comment-face)       ; Dired
;;         ("^....[*]shell.*"       . font-lock-preprocessor-face)  ; shell buff
;;         (".*[*]scratch[*].*"     . font-lock-function-name-face) ; scratch buffer
;;         ("^....[*].*"            . font-lock-string-face)        ; "*" named buffers
;;         ("^..[*].*"              . font-lock-constant-face)      ; Modified
;;         ("^.[%].*"               . font-lock-keyword-face)))    ; Read only

;; (defun buffer-menu-custom-font-lock  ()
;;   (let ((font-lock-unfontify-region-function
;;          (lambda (start end)
;;            (remove-text-properties start end '(font-lock-face nil)))))
;;     (font-lock-unfontify-buffer)
;;     (set (make-local-variable 'font-lock-defaults)
;;          '(buffer-menu-buffer-font-lock-keywords t))
;;     (font-lock-fontify-buffer)))

;; (add-hook 'buffer-menu-mode-hook 'buffer-menu-custom-font-lock)

;;                                         ; http://www.emacswiki.org/emacs/HexColour
;; (defvar hexcolour-keywords
;;   '(("#[abcdef[:digit:]]\\{6\\}"
;;      (0 (put-text-property (match-beginning 0)
;;                            (match-end 0)
;;                            'face (list :background
;;                                        (match-string-no-properties 0)))))))

;; (defun hexcolour-add-to-font-lock ()
;;   (font-lock-add-keywords nil hexcolour-keywords))

;; (add-hook 'php-mode-hook '(lambda () (hexcolour-add-to-font-lock)))
;; (add-hook 'html-helper-mode-hook '(lambda () (hexcolour-add-to-font-lock)))
