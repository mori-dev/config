
(setq-default ispell-program-name "aspell")
(setq-default ispell-extra-args '("--reverse"))
;; (setq ispell-personal-dictionary "~/MyEmacs/Configure-File/Ispell/personal-dictionary")
(setq ispell-silently-savep t)
(setq ispell-dictionary "english")


(require 'flyspell)


(defun flyspell-correct-word-popup-el ()
  "Pop up a menu of possible corrections for misspelled word before point."
  (interactive)
  ;; use the correct dictionary
  (flyspell-accept-buffer-local-defs)
  (let ((cursor-location (point))
    (word (flyspell-get-word nil)))
    (if (consp word)
    (let ((start (car (cdr word)))
          (end (car (cdr (cdr word))))
          (word (car word))
          poss ispell-filter)
      ;; now check spelling of word.
      (ispell-send-string "%\n")    ;put in verbose mode
      (ispell-send-string (concat "^" word "\n"))
      ;; wait until ispell has processed word
      (while (progn
           (accept-process-output ispell-process)
           (not (string= "" (car ispell-filter)))))
      ;; Remove leading empty element
      (setq ispell-filter (cdr ispell-filter))
      ;; ispell process should return something after word is sent.
      ;; Tag word as valid (i.e., skip) otherwise
      (or ispell-filter
          (setq ispell-filter '(*)))
      (if (consp ispell-filter)
          (setq poss (ispell-parse-output (car ispell-filter))))
      (cond
       ((or (eq poss t) (stringp poss))
        ;; don't correct word
        t)
       ((null poss)
        ;; ispell error
        (error "Ispell: error in Ispell process"))
       (t
        ;; The word is incorrect, we have to propose a replacement.
        (flyspell-do-correct (popup-menu* (car (cddr poss)) :scroll-bar t :margin t)
                 poss word cursor-location start end cursor-location)))
      (ispell-pdict-save t)))))

;; 修正したい単語の上にカーソルをもっていき, C-M-return を押すことで候補を選択

(add-hook 'flyspell-mode-hook
          (lambda ()
            ;;(define-key flyspell-mode-map [f12] 'flyspell-correct-word-popup-el)
            ))

;; flyspell-mode を自動的に開始させたいファイルを指定 (お好みでアンコメントするなり, 変更するなり)

(add-to-list 'auto-mode-alist '("\\.txt" . flyspell-mode))
;; (add-to-list 'auto-mode-alist '("\\.howm" . flyspell-mode))
;; (add-to-list 'auto-mode-alist '("\\.org" . flyspell-mode))
;(add-to-list 'auto-mode-alist '("\\.yaml" . flyspell-mode))
;(add-to-list 'auto-mode-alist '("\\.yml" . flyspell-mode))
;(add-to-list 'auto-mode-alist '("\\.ini" . flyspell-mode))
;(add-to-list 'auto-mode-alist '("\\.tex" . flyspell-mode))
;(add-to-list 'auto-mode-alist '("\\.properties" . flyspell-mode))
(add-to-list 'auto-mode-alist '("\\.dtd" . flyspell-mode))

;; (add-to-list 'auto-mode-alist '("\\.php" . flyspell-prog-mode))
;; (add-to-list 'auto-mode-alist '("\\.rb" . flyspell-prog-mode))
;; (add-to-list 'auto-mode-alist '("\\.py" . flyspell-prog-mode))



;; 6. スペル・チェック

;; Emacs には ispell というスペル・チェッカーを呼び出す機能がある。よく使う ispell コマンドは以下の 3 つ。

;; M-$ (ispell-word)
;;     カーソル下のワードのスペル・チェックを行なう。
;; M-x ispell-region
;;     リージョンに対してスペル・チェックを行なう。
;; M-x ispell-comments-and-strings
;;     コメントと文字列だけを対象にスペル・チェックを行なう。
