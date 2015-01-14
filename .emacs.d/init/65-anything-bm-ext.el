;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; 選択した候補の位置にポイントを移動した後の recenter の引数
(setq anything-c-bm-count 5)

(defun anything-c-bm-goto-line (candidate)
  (goto-line (string-to-number candidate))
  (recenter anything-c-bm-count))

(defvar anything-c-source-bm
  '((name . "Visible Bookmarks")
    (init . (lambda ()
              ;(let ((bookmarks (bm-all-bookmarks)))
              (let ((bookmarks (bm-lists)))
                (setq anything-bm-marks
                      (delq nil
                            (mapcar (lambda (bm)
                                      (let ((start (overlay-start bm))
                                            (end (overlay-end bm)))
                                        (if (< (- end start) 2)
                                            nil
                                          (format "%7d: %s"
                                                  (line-number-at-pos start)
                                                  (buffer-substring start (1- end))))))
                                    (append (car bookmarks) (cdr bookmarks))))))))
    (candidates . (lambda ()
                    anything-bm-marks))
    (action . (("Goto line" . anything-c-bm-goto-line)))))

(defun anything-show-bm ()
  "Show `bm'."
  (interactive)
  (anything '(anything-c-source-bm anything-c-source-bm-ext) nil nil nil nil "*anything bm*"))




;; bm-ext.el からの情報源
;; http://d.hatena.ne.jp/grandVin/20080911/1221114327
(defvar anything-c-source-bm-ext
  '((name . "Visible Bookmarks AllBuffers")
    (init . anything-c-source-bm-ext-init)
    (candidates-in-buffer)
    (action . (("Goto line" . anything-c-source-bm-ext-action)))))

(defun anything-c-source-bm-ext-init ()
  (let* ((bookmarks (bm-all-bookmarks))
         (lines (mapconcat 'my-bm-format-line bookmarks "")))
    (if (null bookmarks)
        (message "No bookmarks.")
      (with-current-buffer (anything-candidate-buffer 'global)
        (insert lines)))))

(defun anything-c-source-bm-ext-action (candidate)
  (let* (
         (items (delete "" (split-string candidate " ")))
         (buffer-name (car items))
         (line-number (+ 1 (string-to-number (second items)))))
    (switch-to-buffer buffer-name)
    (goto-line line-number)
    (recenter anything-c-bm-count)))


;; bm-format-lineのオリジナルバージョン
;;  →annotationも表示させたいので
(defun my-bm-format-line (bm)
  (let ((buf (overlay-buffer bm)))
    (with-current-buffer buf
      (let ((string
             (format "%-30s %5s [%s] %s"
                     buf
                     (count-lines (point-min) (overlay-start bm))
                     (or (overlay-get bm 'annotation) "")
                     (buffer-substring (overlay-start bm) (overlay-end bm)))))
    (put-text-property 0 (length string) 'bm-buffer buf string)
    (put-text-property 0 (length string) 'bm-bookmark bm string)
    string))))

(defun anything-show-bm-ext ()
  "Show `bm-ext'."
  (interactive)
  (anything 'anything-c-source-bm-ext nil nil nil nil "*anything bm-ext*"))
;;(space-chord-define-global "b" 'anything-show-bm-ext)
