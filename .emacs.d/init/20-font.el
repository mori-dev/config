;; Ricty
;; http://transitive.info/2011/05/04/ricty-font/
;; 横幅が 1:2 になるのは、12pt,13.5pt, 15pt,18pt 
(cond
 (window-system
  (set-default-font "ricty-13.5:spacing=0")
  (set-face-font 'variable-pitch "ricty-13.5:spacing=0")
  (set-fontset-font (frame-parameter nil 'font)
  		    'japanese-jisx0208
  		    '("ricty" . "unicode-bmp"))))
