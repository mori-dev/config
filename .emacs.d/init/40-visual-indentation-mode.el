(require 'visual-indentation-mode)

(defface visual-indentation-dark-face
  '((((background light)) (:background "#DFDFDF"))
    (((background dark))  (:background "#101010")))
  "Face for highlighting even indents."
  :group 'visual-indentation-mode)



(add-hook 'ruby-mode-hook 'visual-indentation-mode)
(add-hook 'coffee-mode-hook 'visual-indentation-mode)
(add-hook 'yaml-mode-hook 'visual-indentation-mode)
(add-hook 'css-mode-hook 'visual-indentation-mode)
(add-hook 'js2-mode-hook 'visual-indentation-mode)
(add-hook 'rhtml-mode-hook 'visual-indentation-mode)
