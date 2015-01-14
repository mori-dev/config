
(defvar anything-c-source-coding-system
  '((name . "文字コードと改行コード")
    (candidates . anything-coding-system-candidates)
    (action .
      (("指定した文字コード/改行コードを変えてバッファを読込みなおす" .
          (lambda (candidate)
            (revert-buffer-with-coding-system  candidate)))
      ("文字コード/改行コードを指定したものに変えてファイルに保存する" .
          (lambda (candidate)
            (set-buffer-file-coding-system  candidate)))
      ("ファイル名の文字コード設定を指定したものに変更する" .
          (lambda (candidate)
            (set-file-name-coding-system candidate)))))))

(defvar anything-coding-system-candidates
      '(("UTF-8  CRLF" . utf-8-dos)
        ("UTF-8  CR" . utf-8-mac)
        ("UTF-8  LF" . utf-8-unix)
        ("sjis   CRLF" . sjis) 
        ("sjis   CRLF" . sjis-dos)
        ("sjis   CR" . sjis-mac)
        ("sjis   LF" . sjis-unix)
        ("EUC-JP CRLF" . euc-jp-dos)
        ("EUC-JP CR" . euc-jp-mac)
        ("EUC-JP LF" . euc-jp-unix)))

(defun anything-coding-system ()
  (interactive)
  (anything-other-buffer
   '(anything-c-source-coding-system)
      "*anything-coding-system*"))

(provide 'anything-c-source-coding-system)
