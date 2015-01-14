;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-
(require 'cl)




;;リスト内の変数を全てgensymに束縛する
;; (defmacro with-redraw ((var objs) &body body)
;;   (with-gensyms (gob x0 y0 x1 y1)
;;         ...))
(defmacro* with-gensyms (syms &body body)
  `(let ,(mapcar #'(lambda (s)
                     `(,s (gensym)))
                 syms)
     ,@body))

;;(allf "foo" a b c d e)
;; a ;;=> "foo"
;; b ;;=> "foo"
;; c ;;=> "foo"
(defmacro allf (val &rest args)
  (with-gensyms (gval)
    `(let ((,gval ,val))
       (setf ,@(mapcan #'(lambda (a) (list a gval))
                        args)))))

;;(nilf a b c)
(defmacro nilf (&rest args) `(allf nil ,@args))

;;(tf a b c)
(defmacro tf (&rest args) `(allf t ,@args))


(defun complement (fn)
  (lexical-let ((fn fn))
    (lambda (&rest args) (not (apply fn args)))))

(remove-if (complement 'oddp) '(1 2 3 4 5 6))
;;=>(1 3 5)



;; アナフォリックマクロ

(defmacro aif (test-form then-form &optional else-form)
  `(let ((it ,test-form))
     (if it ,then-form ,else-form)))

(defmacro* awhen (test-form &body body)
  `(aif ,test-form
        (progn ,@body)))

(defmacro awhile (expr &body body)
  `(do ((it ,expr ,expr))
     ((not it))
     ,@body))

(defmacro aand (&rest args)
  (cond ((null args) t)
        ((null (cdr args)) (car args))
        (t `(aif ,(car args) (aand ,@(cdr args))))))

(defmacro acond (&rest clauses)
  (if (null clauses)
      nil
      (let ((cl1 (car clauses))
            (sym (gensym)))
        `(let ((,sym ,(car cl1)))
           (if ,sym
               (let ((it ,sym)) ,@(cdr cl1))
               (acond ,@(cdr clauses)))))))



;; (acond
;;  ( (処理1))
;;  (条件2 (処理2))
;;  (t     (処理3)))











(provide 'my-el-cl)
