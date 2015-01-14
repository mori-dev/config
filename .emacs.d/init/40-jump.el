;; ;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-
;; (require 'jump)

;; (add-hook
;;  'emacs-lisp-mode-hook
;;   (lambda()
;;     (define-key emacs-lisp-mode-map (kbd "C-c j") 'jump-symbol-at-point)    
;;     (define-key emacs-lisp-mode-map (kbd "C-c C-j") 'jump-symbol-at-point)
;;     (define-key emacs-lisp-mode-map (kbd "C-c b") 'jump-back)
;;     (define-key emacs-lisp-mode-map (kbd "C-c C-b") 'jump-back)))

;; (add-hook
;;  'lisp-interaction-mode-hook
;;   (lambda()
;;     (define-key lisp-interaction-mode-map (kbd "C-c j") 'jump-symbol-at-point)        
;;     (define-key lisp-interaction-mode-map (kbd "C-c C-j") 'jump-symbol-at-point)
;;     (define-key lisp-interaction-mode-map (kbd "C-c b") 'jump-back)
;;     (define-key lisp-interaction-mode-map (kbd "C-c C-b") 'jump-back)))

;; ;; (add-hook
;; ;;  'lisp-mode-hookp
;; ;;   (lambda()
;; ;;     (define-key lisp-mode-map (kbd "C-c j") 'jump-symbol-at-point)
;; ;;     (define-key lisp-mode-map (kbd "C-c C-j") 'jump-symbol-at-point)    
;; ;;     (define-key lisp-mode-map (kbd "C-c b") 'jump-back)
;; ;;     (define-key lisp-mode-map (kbd "C-c C-b") 'jump-back)))
