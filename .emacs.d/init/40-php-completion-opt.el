;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-


(add-hook  'php-mode-hook
           (lambda ()
             (require 'php-completion)
             (require 'php-completion-opt)
             (php-completion-mode t)
             ;(define-key php-mode-map (kbd "C-o") 'phpcmp-complete)
             (define-key php-mode-map (kbd "C-o") 'phpcmpopt-complete)
             ;; (when (require 'auto-complete nil t)
             ;;   (make-variable-buffer-local 'ac-sources)
             ;;   (add-to-list 'ac-sources 'ac-source-php-completion)
             ;;   (auto-complete-mode t))
             ))
;; key-chord で設定しているキーバインド
(eval-after-load "init-keychord"
  '(progn
     (key-chord-define-global "mp" 'phpcmpopt-manual-pop)
     ))

;;t なら垂直分割、nil なら水平分割
(setq phpcmpopt-horizontal-or-vertical-flag t)

;; space-chord で設定しているキーバインド
;; (eval-after-load "init-space-chord"
;;   '(progn
;;      ;(key-chord-define-global "sr" 'search-result-pop)
;;      ))

(setq phpcmp-lighter " PComp")
;(setq phpcmp-manual-url-format "http://jp2.php.net/manual-lookup.php?lang=fr&pattern=%s")
;phpcmp-showdoc-at-point
;(setq phpcmp-showtip-timeout )
(setq phpcmp-showtip-top-adjust -150)

(defun phpcmp-showdoc (sdc)
  (interactive "sSearchWord:")
    (phpcmp-showtip (phpcmp-get-document-string sdc)))

(abbrev-mode nil)


