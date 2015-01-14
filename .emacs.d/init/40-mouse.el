;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;;;; マウスホイールのスクロールスピードを調節

(global-set-key [wheel-up] '(lambda () (interactive) (scroll-down 2)))
(global-set-key [wheel-down] '(lambda () (interactive) (scroll-up 2)))
(global-set-key [double-wheel-up] '(lambda () (interactive) (scroll-down 2)))
(global-set-key [double-wheel-down] '(lambda () (interactive) (scroll-up 2)))
(global-set-key [triple-wheel-up] '(lambda () (interactive) (scroll-down 3)))
(global-set-key [triple-wheel-down] '(lambda () (interactive) (scroll-up 3)))

;;;; マウス設定

(if window-system (progn
;; 右ボタンの割り当て(押しながらの操作)をはずす。
(global-unset-key [down-mouse-3])

;; マウスの右クリックメニューを出す(押して、離したときにだけメニューが出る)
(defun bingalls-edit-menu (event)
  (interactive "e")
  (popup-menu menu-bar-edit-menu))
(global-set-key [mouse-3] 'bingalls-edit-menu)))

