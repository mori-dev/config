;;;; anything-rurema.el --- Look up Japanese Ruby Reference Manual with anything.el

;; Copyright (C) 2009  rubikitch

;; Author: rubikitch <rubikitch@ruby-lang.org>
;; Keywords: convenience, languages
;; URL: http://www.emacswiki.org/cgi-bin/wiki/download/anything-rurema.el

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; Rubyリファレンスマニュアル刷新計画(るりま)をanythingで検索します。
;;
;; (1) るりまのリポジトリをチェックアウトする。~/compile/rurema以下に展開するものとする。
;;     $ cd ~/compile; mkdir rurema; cd rurema
;;     $ svn co http://jp.rubyist.net/svn/rurema/doctree/trunk rubydoc
;; (2) http://www.rubyist.net/~rubikitch/archive/ar-index.rb から
;;     ダウンロードして、以下のコマンドでドキュメントのインデックスを作成する。
;;     Ruby 1.9必須！
;;     ~/compile/rurema/rubydoc/rurema.eというファイルが作成される。
;;     $ ruby1.9 ar-index.rb ~/compile/rurema/rubydoc rurema.e
;; (3) http://www.emacswiki.org/cgi-bin/wiki/download/auto-install.elをインストールする。
;; (4) auto-install.elの設定を加える。
;;      (require 'auto-install)
;;      (setq auto-install-directory "~/.emacs.d/auto-install/")
;;      (auto-install-update-emacswiki-package-name t)
;;      (auto-install-compatibility-setup)
;; (5) M-x auto-install-batch anything を実行して anything 一式をインストールする。
;; (6) anything-rurema.elの設定を加える。
;;      (require 'anything-rurema)
;;      (setq anything-rurema-index-file "~/compile/rurema/rubydoc/rurema.e")
;;
;; M-x anything-rurema でマニュアルを検索するためのプロンプトが出ます。
;; M-x anything-rurema-at-point でカーソル位置の単語をマニュアル検索します。
;;      
;;; Commands:
;;
;; Below are complete command list:
;;
;;  `anything-rurema'
;;    るりまを検索する。
;;  `anything-rurema-at-point'
;;    カーソル位置の単語をるりまで調べる。
;;
;;; Customizable Options:
;;
;; Below are customizable option list:
;;
;;  `anything-rurema-index-file'
;;    *るりまRDの目次ファイル。ドキュメントディレクトリに置く。
;;    default = "~/compile/rurema/rubydoc/rurema.e"

;;; Customize:
;;
;;
;; All of the above can customize by:
;;      M-x customize-group RET anything-rurema RET
;;


;;; Code:

(require 'anything-config)
(require 'anything-match-plugin)
(defvar anything-rurema-version "$Id: 50autoinsert.el,v 1.19 2009/09/15 10:29:59 rubikitch Exp rubikitch $")
(eval-when-compile (require 'cl))
(defgroup anything-rurema nil
  "anything-rurema"
  :group 'emacs)

(defcustom anything-rurema-index-file "~/Dropbox/data/rurema/rubydoc/rurema.e"
  "*るりまRDの目次ファイル。ドキュメントディレクトリに置く。"
  :type 'string  
  :group 'anything-rurema)

(defun find-rurema (&rest args)
  (apply 'ar/find-file
         (append (butlast args)
                 (list (expand-file-name
                        (car (last args))
                        (file-name-directory anything-rurema-index-file))))))

(defun ar/find-file (&rest args)
  (let ((pos-spec-list-reversed (butlast args 1))
        (filename (car (last args))))
    (find-file filename)
    (apply 'ar/goto-position (reverse pos-spec-list-reversed))
    (recenter 0)
    (cond
     ((require 'rd-mode  nil t)
      (rd-mode))
     (t
      (message "`rd-mode' is not installed. this command requires `rd-mode'")))))

;; (setq anything-rurema-document-directory "/log/compile/rurema/rubydoc/")
;; (find-rurema  "--- try_convert(obj) -> Array | nil" "== Class Methods" "= class Array < Object"  "refm/api/src/_builtin/Array")

;;; Borrowed from eev.el
(defun ar/goto-position (&optional pos-spec &rest rest)
  (when pos-spec
    (cond ((numberp pos-spec)
	   (goto-char (point-min))
	   (forward-line (1- pos-spec)))
	  ((stringp pos-spec)
	   (goto-char (save-excursion	          ; This used to be just:
			(goto-char (point-min))	  ; (goto-char (point-min))
			(search-forward pos-spec) ; (search-forward pos-spec)
			(point))))		  ;
	  (t (error "This is not a valid pos-spec: %S" pos-spec)))
    (if rest (ar/goto-rest rest))))

(defun ar/goto-rest (list)
  (cond ((null list))
	((stringp (car list))
	 (search-forward (car list))
	 (ar/goto-rest (cdr list)))
	((numberp (car list))
	 (forward-line (car list))
	 (ar/goto-rest (cdr list)))
	((consp (car list))
	 (eval (car list))
	 (ar/goto-rest (cdr list)))
	(t (error "Not a valid pos-spec item: %S" (car list)))))

(defvar anything-c-source-rurema
  `((name . "るりま")
    (candidates-file . ,anything-rurema-index-file)
    ;; (candidates-file . "~/Dropbox/data/rurema/rubydoc/rurema.e")    
    ;; (action ("Search" . find-rurema))
    (type . sexp)
    (migemo)
    (multiline)))
;; (anything 'anything-c-source-rurema)
;; (setq anything-c-source-rurema
;;   `((name . "るりま")
;;     (candidates-file-rurema . ,anything-rurema-index-file)
;;     ;; (candidate-transformer . (lambda (candidates) (cdr candidates)))
;;     ;; (candidates-file . "~/Dropbox/data/rurema/rubydoc/rurema.e")
;;     (type . sexp)
;;     (migemo)))

(defvar anything-c-source-bash-history
  `((name . ".bash_history")
    (init . (lambda ()
              (with-current-buffer (anything-candidate-buffer 'global)
                (insert-file-contents "~/.bash_history"))))
    (candidates-in-buffer)
    (candidate-number-limit . 99999)
    (action ("Insert" . insert))))



;; todo
;; (cdr '(find-rurema "--- to_io -> IO" "== Instance Methods" "= class Object" "refm/api/src/_builtin/Object"))
;; de seikei

(defun anything-rurema (&optional pattern)
  "るりまを検索する。"
  (interactive)
  (anything 'anything-c-source-rurema pattern nil nil nil "*rurema*"))

(defun anything-rurema-at-point ()
  "カーソル位置の単語をるりまで調べる。"
  (interactive)
  (anything-rurema (concat "---  " (thing-at-point 'symbol))))

(provide 'anything-rurema)

;; How to save (DO NOT REMOVE!!)
;; (emacswiki-post "anything-rurema.el")
;;; anything-rurema.el ends here
