(require 'anything-books)


;; pdf は emacs で開く
;; (defadvice abks:open-file (around my-abks:open-file activate)
;;   (if (require 'doc-view  nil t)
;;       (find-file (ad-get-arg 0))
;;     ad-do-it))

(defadvice abks:preview-init-preview-window (around my-abks:preview-init-preview-window activate)
  (setq abks:preview-window (get-buffer-window))
  (set-window-buffer
       abks:preview-window
       (abks:preview-buffer-init "No Image...")))

;; PDFファイルのあるディレクトリ（★必須）
;; (setq abks:books-dir "~/data/sd/pdf/2009/08")
(setq abks:books-dir "~/Dropbox/books")
;; (setq abks:books-dir "/home/me/.emacs.d.bk/elisp/slime/doc")
;; (setq abks:open-command "acroread") ; LinuxのAdobeReaderを使う (default)

(if (eq system-type 'darwin)
    (progn
      (setq abks:cache-pixel "600")
      (setq abks:mkcover-cmd '("qlmanage" "-t" pdf "-s" size "-o" dir))
      (setq abks:mkcover-image-ext ".png")
      (setq abks:open-command "open"))
  (setq abks:open-command "gnome-open"))

;; for evince setting (default)
(setq abks:cache-pixel "600")
(setq abks:mkcover-cmd-pdf-postfix nil)
;; (setq abks:mkcover-cmd '("evince-thumbnailer" "-s" size pdf jpeg))

;; for ImageMagick and GhostScript setting
;; (setq abks:cache-pixel "600x600")
;; (setq abks:mkcover-cmd-pdf-postfix "[0]")
;; (setq abks:mkcover-cmd '("convert" "-resize" size pdf jpeg))

(global-set-key (kbd "M-8") 'anything-books-command)
(defalias 'book 'anything-books-command)


(setq abks:cmd-copy "cp") ; ファイルコピーのコマンド
(setq abks:copy-by-command t) ; nilにするとEmacsの機能でコピーする（Windowsはnilがいいかも）
(setq abks:preview-temp-dir "/tmp") ; 作業ディレクトリ

(defalias 'book 'anything-books-command)


(eval-after-load "howm"
  '(progn

     (defvar abks:howm-title-format   '("BOOK " title))
     (defvar abks:howm-content-format '(">>>" file))

     (defun abks:howm-open (file)
       (let* ((data `((title . ,(abks:file-to-title file)) (file . ,file)))
              (howm-title (apply 'concat (abks:list-template abks:howm-title-format data)))
              (howm-content (apply 'concat (abks:list-template abks:howm-content-format data)))
              (howm-items (howm-folder-grep howm-directory (regexp-quote howm-title))))
         (cond
          ((null howm-items) ; create
           (howm-create-file-with-title howm-title nil nil nil howm-content))
          ((eql 1 (length howm-items)) ; open
           (howm-view-open-item (car howm-items)))
          (t ; list
           (howm-view-summary "Anything Books" howm-items)))))

     ;; register howm action
     (setq anything-books-actions 
           (append anything-books-actions
                   '(("Open a howm item" . (lambda (f) (abks:howm-open f))))))
     ))
