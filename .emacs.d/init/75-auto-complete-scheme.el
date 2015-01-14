;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; 参考URL

(add-to-list 'ac-modes 'inferior-gauche-mode)

(defvar ac-source-gauche-file-symbols
  '((candidates
     . (lambda ()
   (all-completions ac-target ac-source-gauche-file-symbols-cache)
   ))))
(defvar ac-source-gauche-file-symbols-cache nil)
(defun ac-source-gauche-collect-file-symbols ()
  (interactive)
  (if (not (eq 0 (shell-command "gosh -b" nil)))
      nil
    (setq ac-source-gauche-file-symbols-cache
    (delete "" (split-string (shell-command-to-string
          (format "gosh -b -e'(letrec ((car-of-car (lambda (x) (if (pair? x) (car-of-car (car x)) x)))) (with-input-from-file \"%s\" (lambda () (let loop((sexp (read))) (if (eof-object? sexp) #f (begin (cond ((not (pair? sexp)) #f) ((or (eq? (quote define) (car sexp)) (eq? (quote define-syntax) (car sexp)) (eq? (quote define-macro) (car sexp)) (eq? (quote define-class) (car sexp))) (print (car-of-car (cadr sexp))))) (loop (read))))))))'" (buffer-file-name))) "\n")))))

;(add-hook 'gauche-mode-hook
(add-hook 'inferior-gauche-mode-hook
    (lambda ()
      (make-local-variable 'ac-sources)
      (make-local-variable 'ac-source-gauche-file-symbols-cache)
      (make-local-variable 'after-save-hook)
      (add-to-list 'ac-sources 'ac-source-gauche-file-symbols)
      (add-hook 'after-save-hook
          'ac-source-gauche-collect-file-symbols)
      (ac-source-gauche-collect-file-symbols)))

;;次の式が空になる。
;; (letrec ((car-of-car
;;           (lambda (x)
;;             (if (pair? x)
;;               (car-of-car (car x))
;;               x))))
;;   (with-input-from-file \"%s\"
;;     (lambda ()
;;       (let loop
;;           ((sexp (read)))
;;         (if (eof-object? sexp)
;;           #f
;;           (begin
;;             (cond ((not (pair? sexp)) #f)
;;                   ((or
;;                     (eq? (quote define)
;;                          (car sexp))
;;                     (eq? (quote define-syntax)
;;                          (car sexp))
;;                     (eq? (quote define-macro)
;;                          (car sexp))
;;                     (eq? (quote define-class)
;;                          (car sexp)))
;;                    (print (car-of-car (cadr sexp)))))
;;             (loop (read))))))))
