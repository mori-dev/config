;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-
;; bm.elからの情報源

;; (defvar anything-c-source-bm
;;   '((name . "Visible Bookmarks")
;;     (init . (lambda ()
;;               ;(let ((bookmarks (bm-all-bookmarks)))
;;               (let ((bookmarks (bm-lists)))
;;                 (setq anything-bm-marks
;;                       (delq nil
;;                             (mapcar (lambda (bm)
;;                                       (let ((start (overlay-start bm))
;;                                             (end (overlay-end bm)))
;;                                         (if (< (- end start) 2)
;;                                             nil
;;                                           (format "%7d: %s"
;;                                                   (line-number-at-pos start)
;;                                                   (buffer-substring start (1- end))))))
;;                                     (append (car bookmarks) (cdr bookmarks))))))))
;;     (candidates . (lambda ()
;;                     anything-bm-marks))
;;     (action . (("Goto line" . (lambda (candidate)
;;                                 (goto-line (string-to-number candidate))))))))



;; ;; 選択した候補の位置にポイントを移動した後の recenter の引数
;; (setq anything-c-bm-count 5)

;; (defun anything-c-bm-goto-line (candidate)
;;   (goto-line (string-to-number candidate))
;;   (recenter anything-c-bm-count))

;; (defvar anything-c-source-bm
;;   '((name . "Visible Bookmarks")
;;     (init . (lambda ()
;;               ;(let ((bookmarks (bm-all-bookmarks)))
;;               (let ((bookmarks (bm-lists)))
;;                 (setq anything-bm-marks
;;                       (delq nil
;;                             (mapcar (lambda (bm)
;;                                       (let ((start (overlay-start bm))
;;                                             (end (overlay-end bm)))
;;                                         (if (< (- end start) 2)
;;                                             nil
;;                                           (format "%7d: %s"
;;                                                   (line-number-at-pos start)
;;                                                   (buffer-substring start (1- end))))))
;;                                     (append (car bookmarks) (cdr bookmarks))))))))
;;     (candidates . (lambda ()
;;                     anything-bm-marks))
;;     (action . (("Goto line" . anything-c-bm-goto-line)))))

;; (defun anything-show-bm ()
;;   "Show `bm'."
;;   (interactive)
;;   (anything 'anything-c-source-bm nil nil nil nil "*anything bm*"))


