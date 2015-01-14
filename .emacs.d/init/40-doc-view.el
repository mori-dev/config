(require 'doc-view)


(add-hook 'doc-view-mode-hook
  (lambda()
    (define-key map (kbd "j") 'next-line)
    (define-key map (kbd "k") 'previous-line)
    (define-key map (kbd "^")               'doc-view-enlarge)
    (define-key map (kbd "\\")               'doc-view-shrink)
    
    (define-key map (kbd "C-9")         'doc-view-next-page)
    (define-key map (kbd "C-0")         'doc-view-previous-page)
    
    (define-key map (kbd "n")         'doc-view-next-page)
    (define-key map (kbd "p")         'doc-view-previous-page)
    (define-key map (kbd "<next>")    'forward-page)
    (define-key map (kbd "<prior>")   'backward-page)
    (define-key map [remap forward-page]  'doc-view-next-page)
    (define-key map [remap backward-page] 'doc-view-previous-page)
    (define-key map (kbd "SPC")       'doc-view-scroll-up-or-next-page)
    (define-key map (kbd "DEL")       'doc-view-scroll-down-or-previous-page)
    (define-key map (kbd "M-<")       'doc-view-first-page)
    (define-key map (kbd "M->")       'doc-view-last-page)
    (define-key map [remap goto-line] 'doc-view-goto-page)
    (define-key map (kbd "RET")       'image-next-line)
    ;; Zoom in/out.
    (define-key map "+"               'doc-view-enlarge)
    (define-key map "-"               'doc-view-shrink)
    ;; Killing the buffer (and the process)
    (define-key map (kbd "k")         'doc-view-kill-proc-and-buffer)
    (define-key map (kbd "K")         'doc-view-kill-proc)
    ;; Slicing the image
    (define-key map (kbd "s s")       'doc-view-set-slice)
    (define-key map (kbd "s m")       'doc-view-set-slice-using-mouse)
    (define-key map (kbd "s r")       'doc-view-reset-slice)
    ;; Searching
    (define-key map (kbd "C-s")       'doc-view-search)
    (define-key map (kbd "<find>")    'doc-view-search)
    (define-key map (kbd "C-r")       'doc-view-search-backward)
    ;; Show the tooltip
    (define-key map (kbd "C-t")       'doc-view-show-tooltip)
    ;; Toggle between text and image display or editing
    (define-key map (kbd "C-c C-c")   'doc-view-toggle-display)
    ;; Open a new buffer with doc's text contents
    (define-key map (kbd "C-c C-t")   'doc-view-open-text)
    ;; Reconvert the current document
    (define-key map (kbd "g")         'revert-buffer)
    (define-key map (kbd "r")         'revert-buffer)
    ))

;; 　内部的には「PDF/PS→PNG」または「DVI→PDF→PNG」というフローで進められるが、その処理系にはGhostscriptが利用されている。
;; PDFからPNGの変換はGhostscriptに依存するため、開けないPDFも少なくない。たとえば、パスワードで保護されたPDFは表示できない。暗号化されたPDFも不可だ。日本語フォントを含むDVIもサポートされないため、LaTeXの統合環境としては“もう一声”な状況となっている。

;; 　とはいえ、基本的なキー操作さえ覚えておけば、気軽に使えるPDFビューアとなりうることは確か。/Applications /Emacs.app/Contents/Resources/lisp/doc-view.el.gzに定義されたキーバインドのうち、主要なものを下表に抜粋したので参考にしてほしい。

;; n             'doc-view-next-page                      次のページ
;; p             'doc-view-previous-page                  前のページ
;; C-n           'doc-view-next-line-or-next-page         1行下方へスクロール
;; C-p           'doc-view-previous-line-or-previous-page 1行上方へスクロール
;; SPACE         'doc-view-scroll-up-or-next-page         下方スクロールまたは次のページ
;; DEL           'doc-view-scroll-down-or-previous-page   上方スクロールまたは前のページ
;; k             'doc-view-kill-proc-and-buffer           プロセスを終了しバッファを閉じる
;; g             'revert-buffer                           バッファを閉じる
;; +             'doc-view-enlarge                        拡大
;; -             'doc-view-shrink                         縮小
;; カーソルキー       -                                       上下左右方向へスクロール
