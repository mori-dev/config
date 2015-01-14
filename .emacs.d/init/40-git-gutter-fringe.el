(require 'git-gutter-fringe)

;; (set-face-foreground 'git-gutter-fr:modified "yellow")
;; (set-face-foreground 'git-gutter-fr:added    "blue")
;; (set-face-foreground 'git-gutter-fr:deleted  "white")


;; Please adjust fringe width if your own sign is too big.
;; (setq-default left-fringe-width  15)
(setq-default right-fringe-width 20)

;; (fringe-helper-define 'git-gutter-fr:added nil
;;   ".XXXXXX."
;;   "XX....XX"
;;   "X......X"
;;   "X......X"
;;   "XXXXXXXX"
;;   "XXXXXXXX"
;;   "X......X"
;;   "X......X")

;; (fringe-helper-define 'git-gutter-fr:deleted nil
;;   "XXXXXX.."
;;   "XX....X."
;;   "XX.....X"
;;   "XX.....X"
;;   "XX.....X"
;;   "XX.....X"
;;   "XX....X."
;;   "XXXXXX..")

;; (fringe-helper-define 'git-gutter-fr:modified nil
;;   "XXXXXXXX"
;;   "X..XX..X"
;;   "X..XX..X"
;;   "X..XX..X"
;;   "X..XX..X"
;;   "X..XX..X"
;;   "X..XX..X"
;;   "X..XX..X")

;; You can change position of fringe, left or right. Default is left.

(setq git-gutter-fr:side 'right-fringe)

(add-hook 'ruby-mode-hook
  (lambda ()
    (git-gutter-mode t)
    ))

(add-hook 'rhtml-mode-hook
  (lambda ()
    (git-gutter-mode t)
    ))
(add-hook 'coffee-mode-hook
  (lambda ()
    (git-gutter-mode t)
    ))

(add-hook 'css-mode-hook
  (lambda ()
    (git-gutter-mode t)
    ))
