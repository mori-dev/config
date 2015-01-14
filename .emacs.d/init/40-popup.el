;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

(require 'popup)

(setq my-date-format-list
     '("%m-%d" "%m-%d(%a)"
       "%Y/%m/%d" "%Y-%m-%d"
       "%m/%d" "%m/%d(%a)" "%y-%m-%d(%a)"))

(defun kyou () 
  (interactive)
  (insert
   (replace-regexp-in-string "\\\\" ""
     (popup-menu
       (mapcar 'format-time-string my-date-format-list)))))

;(global-set-key (kbd "M-h") 'kyou)



;; (defun ns-popup-dictionary ()
;;    "マウスカーソルの単語を Mac の辞書でひく"
;;    (interactive)
;;    (let ((symbol (thing-at-point 'symbol))
;;   	 dict)
;;   (with-temp-buffer
;;     (call-process "phpman" nil t t symbol)
;;     (setq dict (buffer-string)))
;;   (popup-tip dict :height 300)))
;; var_dump
;; echo
;; (popup-tip "Hello world!" :height 300)
;; (popup-tip "First line\nSecond line\nThird line")


;;   (with-temp-buffer
;;     (call-process "~/bin/sf.php" nil t t "cc")
;;     (message "%s" (buffer-string))))



;; (define-key global-map (kbd "M-h") 'ns-popup-dictionary)
;; (popup-menu '(Foo Bar Baz) :scroll-bar t :margin t)

