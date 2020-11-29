(require 'web-mode)

(defun web-mode-hook ()
  "Hooks for Web mode."
             ;; (setq web-mode-script-padding 2)
             ;; (setq web-mode-attr-indent-offset 2)
             ;; (setq web-mode-markup-indent-offset 2)
             ;; (setq web-mode-css-indent-offset 2)
             ;; (setq web-mode-code-indent-offset 2)
             ;; (setq web-mode-sql-indent-offset 2)
             ;; (setq indent-tabs-mode nil)
             ;; (setq tab-width 2)

 (setq web-mode-attr-indent-offset nil)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-sql-indent-offset 2)
  (setq indent-tabs-mode nil)
  (setq tab-width 2)

  (setq web-mode-comment-formats
   '(
     ("javascript" . "//")
     ("typescript" . "//")
     
     ))
  ;; (add-to-list 'web-mode-indentation-params '("lineup-args" . nil))
  ;; (add-to-list 'web-mode-indentation-params '("lineup-calls" . nil))
  ;; (add-to-list 'web-mode-indentation-params '("lineup-concats" . nil))
  ;; (add-to-list 'web-mode-indentation-params '("lineup-quotes" . nil))
  ;; (add-to-list 'web-mode-indentation-params '("lineup-ternary" . nil))
  ;; (add-to-list 'web-mode-indentation-params '("case-extra-offset" . nil))
             )

;; 色
(custom-set-faces
 '(web-mode-doctype-face           ((t (:foreground "#4A8ACA"))))
 '(web-mode-html-tag-face          ((t (:foreground "#4A8ACA"))))
 '(web-mode-html-tag-bracket-face  ((t (:foreground "#4A8ACA"))))
 '(web-mode-html-attr-name-face    ((t (:foreground "#87CEEB"))))
 '(web-mode-html-attr-equal-face   ((t (:foreground "#FFFFFF"))))
 '(web-mode-html-attr-value-face   ((t (:foreground "#D78181"))))
 '(web-mode-comment-face           ((t (:foreground "#587F35"))))
 '(web-mode-server-comment-face    ((t (:foreground "#587F35"))))

 '(web-mode-css-at-rule-face       ((t (:foreground "#DFCF44"))))
 '(web-mode-comment-face           ((t (:foreground "#587F35"))))
 '(web-mode-css-selector-face      ((t (:foreground "#DFCF44"))))
 '(web-mode-css-pseudo-class       ((t (:foreground "#DFCF44"))))
 '(web-mode-css-property-name-face ((t (:foreground "#87CEEB"))))
 '(web-mode-css-string-face        ((t (:foreground "#D78181"))))
 )

(add-hook 'web-mode-hook 'web-mode-hook)
