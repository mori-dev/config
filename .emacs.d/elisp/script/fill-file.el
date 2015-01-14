;; 使用法
;; $ emacs --script path/to/fill-file.el ファイル名 改行するカラム
(setq fill-column (string-to-int (cadr argv)))
(find-file (car argv))
(fill-region (point-min) (point-max))
(save-buffer)
