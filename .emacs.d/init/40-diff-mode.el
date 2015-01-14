(require 'diff-mode)

;; diff-goto-source のキー割り当てを削除
(easy-mmode-defmap diff-mode-shared-map
  '(;; From Pavel Machek's patch-mode.
    ("n" . diff-hunk-next)
    ("N" . diff-file-next)
    ("p" . diff-hunk-prev)
    ("P" . diff-file-prev)
    ("\t" . diff-hunk-next)
    ([backtab] . diff-hunk-prev)
    ("k" . diff-hunk-kill)
    ("K" . diff-file-kill)
    ;; From compilation-minor-mode.
    ("}" . diff-file-next)
    ("{" . diff-file-prev)
    ("\C-m" . diff-goto-source)
    ([mouse-2] . diff-goto-source)
    ;;M-o が奪われる
    ;; ("o" . diff-goto-source)		;other-window
    ("g" . revert-buffer)
    ("q" . quit-window))
  "Basic keymap for `diff-mode', bound to various prefix keys.")