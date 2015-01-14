;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-
(require 'anything)
(require 'bm)
(require 'bm-ext)

(defvar anything-bm-plus-item-separator "\0")

;; buffer ... ファイルを読み込んでいない時は nil
(defun anything-bm-plus-item-line (filename buffer line-number annotation text)
  (format "%s%s%s%s%s%s%5d%s%s%s%s" ;; kind, file-name, buffer-name, line-number, annotation, text
          (if buffer "buffer" "file")  anything-bm-plus-item-separator
          filename   anything-bm-plus-item-separator
          (or buffer "")  anything-bm-plus-item-separator
          line-number  anything-bm-plus-item-separator
          annotation  anything-bm-plus-item-separator
          text))

;;
(defun anything-bm-plus-item-lines-for-file (filename bookmarks expect-buffer-size)
  (let ( (item-lines '())
         (start)
         (end)
         (annotation)
         (line-number)
         )
      (save-excursion
        (with-output-to-temp-buffer " *anything-c-source-bm-plus*"
          (set-buffer standard-output)
          (insert-file filename)
          (while bookmarks
            (goto-char (point-min))
            (let* ((bookmark (car bookmarks))
                   (is-buffer-size-match (equal (point-max) expect-buffer-size))
                   (start (if is-buffer-size-match
                              (cdr (assoc 'position bookmark))
                            (bm-get-position-from-context bookmark)))
                   (end)
                   (line-number (line-number-at-pos start))
                   (annotation (or (cdr (assoc 'annotation bookmark)) "" ))
                   )
              (if start  ;; start == nil is conflict data
                  (progn
                    (goto-char start)
                    (setq end (point-at-eol))
                    
                    (setq line (anything-bm-plus-item-line filename
                                                nil ; buffer
                                                line-number
                                                annotation
                                                (if (< (- end start) 1) ;; text ;;
                                                    "\n"
                                                  (buffer-substring start (1+ end)))))
                    (setq item-lines (cons line item-lines)))))
            (setq bookmarks (cdr bookmarks)))))
      item-lines))

;;
(defun anything-bm-plus-opened-files ()
  (delq nil (mapcar #'(lambda (buf)
                        (with-current-buffer buf
                          (let ((file-name (buffer-file-name)))
                            (if file-name
                                (cons (expand-file-name file-name) buf)
                              nil))))
                    (buffer-list))))

(defun anything-bm-plus-format-line (bm)
  (let ((buf (overlay-buffer bm)))
    (with-current-buffer buf
      (anything-bm-plus-item-line (expand-file-name (buffer-file-name))
                       buf
                       (line-number-at-pos (overlay-start bm))
                       (or (overlay-get bm 'annotation) "")
                       (buffer-substring (overlay-start bm) (overlay-end bm))))))

(defun anything-bm-plus-insert-opened-bookmark-items ()
  (let* ((bookmarks (bm-all-bookmarks))
         (lines (mapconcat 'anything-bm-plus-format-line bookmarks "")))
    (if (null bookmarks)
        (message "No bookmarks.")
      (insert lines))))

(defun anything-c-source-bm-plus-init ()
    (with-current-buffer (anything-candidate-buffer 'global)
      (anything-bm-plus-insert-opened-bookmark-items)
      
      (let ((items bm-repository)
            (opend-files (anything-bm-plus-opened-files))
            )
        (while items
          (let* (
                 (filename (expand-file-name (car (car items))))
                 (buffer-data (assoc filename bm-repository))
                 (expect-buffer-size (cdr (assoc 'size buffer-data)))
                 (bookmarks (cdr (assoc 'bookmarks buffer-data)))
                 (item-lines)
                 (buf (cdr (assoc filename opend-files)))
                 )
            (if buf
                nil 
              (setq item-lines (anything-bm-plus-item-lines-for-file filename bookmarks expect-buffer-size)))
            
            (while item-lines
              (insert (car item-lines))
              (setq item-lines (cdr item-lines)))
            )
          (setq items (cdr items))))))


(defun anything-c-source-bm-plus-action (candidate)
  (let* ((kind (cdr (assoc 'kind candidate)))
         (buffername (cdr (assoc 'buffername candidate)))
         (filename (cdr (assoc 'filename candidate)))
         (line-number (cdr (assoc 'line-number candidate))))
    (if (string= kind "buffer")
        (switch-to-buffer buffername)
      (find-file filename))
    (goto-line line-number)))

;;
(defun anything-c-source-bm-plus-transformer (candidates)
  (mapcar #'(lambda (candidate)
              (let* ((items (split-string candidate anything-bm-plus-item-separator))
                     (kind (car items))
                     (annotation-len-max 80)
                     (annotation (fifth items))
                     (annotation (if (<= (length annotation) annotation-len-max)
                                     annotation
                                   (substring annotation 0 annotation-len-max)))
                     (buffername (third items))
                     (buffername (if (= 0 (length buffername))
                                     "none"
                                   buffername))
                     (buffername (concat "*" (concat buffername "*")))
                     )
                (cons (if (string= kind "buffer")
                          (progn
                            (format "%-30s %s [%s] %s"
                                    buffername
                                    (fourth items) ;; line number
                                    annotation 
                                    (sixth items)) ;; text
                            )
                        (format "%-30s %s [%s] %s"
                                (file-name-nondirectory (second items))
                                (fourth items) ;; line number
                                annotation 
                                (sixth items)) ;; text
                        )
                      (list (cons 'kind kind)
                            (cons 'filename (second items))
                            (cons 'buffername (third items))
                            (cons 'line-number (string-to-number (fourth items)))))))
          candidates))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
(defvar anything-c-source-bm-plus
  '((name . "Visible Bookmarks Plus")
    (init . anything-c-source-bm-plus-init)
    (candidates-in-buffer)
    (candidate-transformer . anything-c-source-bm-plus-transformer)
    (action . (("Goto line" . anything-c-source-bm-plus-action)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
(defun anything-bm-select ()
  (interactive)
  (anything '(anything-c-source-bm
              anything-c-source-bm-ext
              anything-c-source-bm-plus
              )))

(provide 'anything-bm-plus)

