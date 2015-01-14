;; 使用法
;; $ emacs --script path/to/make-dummy-file.el ディレクトリ名 開始番号 終了番号
;; $ emacs --script path/to/make-dummy-file.el ~/tmp 1 3
;; $ ls ~/tmp
;; 001_dummy_data.txt  002_dummy_data.txt  003_dummy_data.txt
(defun get-stdin-buffer ()
  (let ((buf-name "*stdin*"))
    (or (get-buffer buf-name) ; バッファがすでに存在する場合はそのまま返す
        (let ((buffer (generate-new-buffer buf-name))) ; なければバッファを作成して
          (with-current-buffer buffer ; そのバッファを一時的にカレントバッファにする
            (condition-case nil ; EOFに達したときに発生するエラーを抑制するためのおまじない
                (let (line)
                  (while (setq line (read-line)) ; 一行読み出して
                    (insert line "\n"))) ; その一行をカレントバッファに挿入する
              (error nil)))
          buffer))))                    ; 作成したバッファを返す
(set-buffer (get-stdin-buffer)) ; 標準入力バッファをカレントバッファにして
(occur (nth 0 command-line-args-left)) ; occur関数を実行する
(set-buffer "*Occur*") ; *Occur*バッファをカレントバッファにして
(forward-line 1)
(princ (buffer-substring (point) (point-max))) ; 標準出力に出力する 


