;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; yaml-mode の設定

;;C-iを何度かタイプすることで、インデントの位置を調節することができる。

(defun my-yaml-backward-up-list ()
  "インデントの深さを基準に駆け上がる"
  (interactive)
  (if (not (eq this-command last-command))
      (back-to-indentation)
    (unless (bolp)
      (let (cn)
        (back-to-indentation)  
        (backward-char)
          (while (looking-at " ")
            (setq cn (current-column))
            (previous-line 1)
            (move-to-column cn)))
        (back-to-indentation))))

(defun my-yaml-down-list ()
  "一つ下の行のインデントが現在より深い場合は移動する"
  (interactive)
  (if (not (eq this-command last-command))
      (back-to-indentation)
    (let (cn ncn)
      (save-excursion
        (back-to-indentation)
        (setq cn (current-column))
        (next-line 1)
        (back-to-indentation)
        (setq ncn (current-column)))
      (while (< cn ncn)
        (next-line 1)
        (back-to-indentation)
        (setq cn (current-column))))))

(add-hook 'yaml-mode-hook
  (lambda()
    (define-key yaml-mode-map (kbd "C-M-u") 'my-yaml-backward-up-list)
    (define-key yaml-mode-map (kbd "C-M-d") 'my-yaml-down-list)))

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.ya?ml$" . yaml-mode))
(add-hook 'yaml-mode-hook
          '(lambda ()
             (define-key yaml-mode-map "\C-m" 'newline-and-indent)))
