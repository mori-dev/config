;; 使用法
;; $ emacs --script path/to/make-dummy-file.el ディレクトリ名 開始番号 終了番号
;; $ emacs --script path/to/make-dummy-file.el ~/tmp 1 3
;; $ ls ~/tmp
;; 001_dummy_data.txt  002_dummy_data.txt  003_dummy_data.txt
(require 'cl)
(with-temp-buffer
  (insert "dummy")
  (loop for i from (string-to-int (second argv)) to (string-to-int (third argv))
        do (write-region (point-min) (point-max) (format "%s/%03d_dummy_data.txt" (first argv) i))))
