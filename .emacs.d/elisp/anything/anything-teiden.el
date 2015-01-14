;;; anything-teiden.el

;; Copyright (C) 2011 kiwanami
;; GPL 3

;; thanks! > @fizsoft, Google, @sora_h

(require 'deferred)

(defvar anything-teiden-csv-cache nil)

(defun anything-teiden-candidates-d ()
  (lexical-let (buffer)
    (if anything-teiden-csv-cache
        (deferred:succeed anything-teiden-csv-cache)
      (deferred:$
        (deferred:process-shell-buffer
          "wget -q -O - 'http://webtool.fizsoft.net/tepco/list.txt'")
        (deferred:nextc it
          (lambda (buf)
            (setq buffer buf)
            (let (items last-pos)
              (with-current-buffer buf
                (goto-char (setq last-pos (point-min)))
                (while (re-search-forward "\n" nil t)
                  (let* ((line (buffer-substring last-pos (1- (point))))
                         (cols (split-string line ",")))
                    (push cols items)
                    (setq last-pos (point)))))
              (setq anything-teiden-csv-cache items)
              items)))
        (deferred:watch it
          (lambda (x) (when buffer (kill-buffer buffer))))))))

;; (deferred:pp (anything-teiden-candidates-d))

(defun anything-teiden-clear-cache ()
  (interactive)
  (setq anything-teiden-csv-cache nil))

(defun anything-teiden-transform (items)
  (loop for (addr num) in items
        collect
        (cons (format "グループ %s / %s" num addr)
              addr)))

(defun anything-teiden ()
  "住所からグループを検索。RETアクションでその停電情報MAPを開く。"
  (interactive)
  (deferred:$
    (anything-teiden-candidates-d)
    (deferred:nextc it
      (lambda (items)
        (let ((source
               `((name . "Teiden : 停電情報")
                 (candidates . ,(anything-teiden-transform items))
                 (action
                  ("Show Map" .
                   (lambda (x)
                     (browse-url (format "http://teidenjapan.appspot.com/#%s" x)))))
                 (candidate-number-limit . 200)
                 (migemo))))
          (anything source))))))

(provide 'anything-teiden)