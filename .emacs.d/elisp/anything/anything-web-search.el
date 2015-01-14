;;; anything-web-search.el

;; Copyright (C) 2009  kitokitoki

;; Version: 1.0.1
;; Author: kitokitoki  <morihenotegami@gmail.com>
;; Keywords: anything

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; Anything-web-search is a branch project of serch-web.el
;; search-web.el is written by Tomoya Otake
;; http://github.com/tomoya/search-web.el/tree/master

;; Change Log
;; 1.1.0: search-ring を選択候補に追加。
;;        指定した複数の検索エンジンの一括検索機能を persistent-action として実装。
;;        検索エンジンを追加
;;        リファクタリング (初期化処理の init 属性への移動, action候補の変数化など)
;; 1.0.1: action 一覧を変数化, その他微修正。
;; 1.0.0: 新規作成

;;; Code:

(require 'anything)

(defvar aws-search-ring-length 5)
(defvar aws-search-engine-group '("google" "wikipedia ja" "amazon"))

;; search-engines,aws-action-alist は当面 setq とします。
(setq search-engines
  '(
  ("sitepoint" . "http://reference.sitepoint.com/search?q=%s")
  ("google" . "http://www.google.com/search?q=%s")
  ("google ja" . "http://www.google.com/search?hl=ja&q=%s")
  ;; ("google en" . "http://www.google.com/search?hl=en&q=%s")
  ;; ("google en" . "http://www.google.com/search?hl=en&q=%s")
  ("lispdoc" . "http://lispdoc.com/?q=%s&search=Basic+search")                              ;new
  ("google code" . "http://www.google.com/codesearch?q=%s&hl=en&btnG=Search+Code")          ;new
  ;; ("codase" . "http://www.codase.com/search/smart?join=%s&scope=join join&lang=*&project=") ;new
  ;; ("jexamples" . "http://www.jexamples.com/fwd?action=srchRes&queryText=%s")                ;new
  ("codefetch php" . "http://www.codefetch.com/search?qy=%s&lang=php")                      ;new
  ;; ("codefetch perl" . "http://www.codefetch.com/search?qy=%s&lang=perl")                    ;new
  ("codefetch ruby" . "http://www.codefetch.com/search?qy=%s&lang=ruby")                    ;new
  ("codefetch python" . "http://www.codefetch.com/search?qy=%s&lang=python")                ;new
  ("codefetch javascript" . "http://www.codefetch.com/search?qy=%s&lang=javascript")        ;new
  ;; ("codefetch actionscript" . "http://www.codefetch.com/search?qy=%s&lang=actionscript")    ;new
  ;; ("codefetch c" . "http://www.codefetch.com/search?qy=%s&lang=c")                          ;new
  ;; ("codefetch c++" . "http://www.codefetch.com/search?qy=%s&lang=cplusplus")                ;new
  ;; ("codefetch html/css" . "http://www.codefetch.com/search?qy=%s&lang=html")                ;new
  ;; ("codefetch jsp/jstl/jsf" . "http://www.codefetch.com/search?qy=%s&lang=jsp")             ;new
  ;; ("codefetch apache" . "http://www.codefetch.com/search?qy=%s&lang=httpd")                 ;new
  ("codefetch sql" . "http://www.codefetch.com/search?qy=%s&lang=sql")                      ;new
  ("codefetch shell" . "http://www.codefetch.com/search?qy=%s&lang=sh")                     ;new
  ;; ("codefetch xml/schema" . "http://www.codefetch.com/search?qy=%s&lang=xmlschema")         ;new
  ;; ("codefetch xslt" . "http://www.codefetch.com/search?qy=%s&lang=xslt")                    ;new
  ;; ("kocers" . "http://www.koders.com/default.aspx?s=%s&submit=Search&la=*&li=*")            ;new
  ;; ("google maps" . "http://maps.google.co.jp/maps?hl=ja&q=%s")
  ;; ("youtube" . "http://www.youtube.com/results?search_type=&search_query=%s&aq=f")
  ;; ("twitter" . "http://search.twitter.com/search?q=%s")
  ;; ("goo" . "http://dictionary.goo.ne.jp/srch/all/%s/m0u/")
  ;; ("answers" . "http://www.answers.com/topic/%s")
  ;; ("emacswiki" . "http://www.google.com/cse?cx=004774160799092323420%%3A6-ff2s0o6yi&q=%s&sa=Search")
  ;; ("amazon" . "http://www.amazon.com/s/url=search-alias%%3Daps&field-keywords=%s")
  ;; ("amazon jp" . "http://www.amazon.co.jp/gp/search?index=blended&field-keywords=%s")
  ;; ("yahoo" . "http://search.yahoo.com/search?p=%s")
  ;; ("yahoo jp" . "http://search.yahoo.co.jp/search?p=%s")
  ;; ("wikipedia en" . "http://www.wikipedia.org/search-redirect.php?search=%s&language=en")
  ;; ("wikipedia ja" . "http://www.wikipedia.org/search-redirect.php?search=%s&language=ja"))
  ))
 ;;   "A list is search engines list. keys engines nick, and value is search engine query.
 ;; Search word %s. In formatting url-hexify. Use %% to put a single % into output.")

(setq aws-action-alist 
      '(
        ("Google" . (lambda (candidate) (aws-web-search "google" candidate)))
        ("lispdoc" . (lambda (candidate) (aws-web-search "lispdoc" candidate)))        
        ("google ja" . (lambda (candidate) (aws-web-search "google ja" candidate)))
        ;; ("google en" . (lambda (candidate) (aws-web-search "google en" candidate)))
        ;; ("google maps" . (lambda (candidate) (aws-web-search "google maps" candidate)))
        ("google code" . (lambda (candidate) (aws-web-search "google code" candidate)))
        ;; ("codase" . (lambda (candidate) (aws-web-search "codase" candidate)))
        ;; ("jexamples" . (lambda (candidate) (aws-web-search "jexamples" candidate)))
        ("codefetch php" . (lambda (candidate) (aws-web-search "codefetch php" candidate)))
        ;; ("codefetch perl" . (lambda (candidate) (aws-web-search "codefetch perl" candidate)))
        ;; ("codefetch ruby" . (lambda (candidate) (aws-web-search "codefetch ruby" candidate)))
        ("codefetch python" . (lambda (candidate) (aws-web-search "codefetch python" candidate)))
        ("codefetch javascript" . (lambda (candidate) (aws-web-search "codefetch javascript" candidate)))
        ;; ("codefetch actionscript" . (lambda (candidate) (aws-web-search "codefetch actionscript" candidate)))
        ("codefetch c" . (lambda (candidate) (aws-web-search "codefetch c" candidate)))
        ;; ("codefetch c++" . (lambda (candidate) (aws-web-search "codefetch c++" candidate)))
        ;; ("codefetch html/css" . (lambda (candidate) (aws-web-search "" candidate)))
        ;; ("codefetch jsp/jstl/jsf" . (lambda (candidate) (aws-web-search "codefetch jsp/jstl/jsf" candidate)))
        ;; ("codefetch apache" . (lambda (candidate) (aws-web-search "codefetch apache" candidate)))
        ;; ("codefetch sql" . (lambda (candidate) (aws-web-search "codefetch sql" candidate)))
        ("codefetch shell" . (lambda (candidate) (aws-web-search "codefetch shell" candidate)))
        ;; ("codefetch xml/schema" . (lambda (candidate) (aws-web-search "codefetch xml/schema" candidate)))
        ;; ("codefetch xslt" . (lambda (candidate) (aws-web-search "codefetch xslt" candidate)))
        ;; ("kocers" . (lambda (candidate) (aws-web-search "kocers" candidate)))
        ;; ("youtube" . (lambda (candidate) (aws-web-search "youtube" candidate)))
        ;; ("twitter" . (lambda (candidate) (aws-web-search "twitter" candidate)))
        ;; ("goo" . (lambda (candidate) (aws-web-search "goo" candidate)))
        ;; ("answers" .(lambda (candidate) (aws-web-search "answers" candidate)))
        ("emacswiki" . (lambda (candidate) (aws-web-search "emacswiki" candidate)))
        ("amazon" . (lambda (candidate) (aws-web-search "amazon" candidate)))
        ("amazon jp" . (lambda (candidate) (aws-web-search "amazon jp" candidate)))
        ("yahoo" . (lambda (candidate) (aws-web-search "yahoo" candidate)))
        ("yahoo jp" . (lambda (candidate) (aws-web-search "yahoo jp" candidate)))
        ("wikipedia en" . (lambda (candidate) (aws-web-search "wikipedia en" candidate)))
        ("wikipedia ja" . (lambda (candidate) (aws-web-search "wikipedia ja" candidate)))
        ("sitepoint" . (lambda (candidate) (aws-web-search "sitepoint" candidate)))))

(defvar anything-c-source-web-search
  `((init . aws-init)
    (name             . "Chose Search Word")
    (candidates       . aws-candidate-list)
    (action . ,aws-action-alist)
    (type             . command)
    (volatile)))

(defvar anything-c-source-aws-candidate-not-found
  `((init . aws-init)
    (name . "Create Search Word")
    (dummy)
    (action . ,aws-action-alist)
    (type . command)))

(defvar anything-c-source-aws-search-ring
  `((init . aws-init)
    (name             . "Chose Search Word (search-ring)")
    (candidates       . aws-search-ring-list)
    (action . ,aws-action-alist)
    (type             . command)
    (volatile)))

(defun aws-init ()
  (setq aws-region-string
        (if (and transient-mark-mode mark-active)
            (buffer-substring-no-properties
             (region-beginning) (region-end))))
  (setq aws-candidate-list nil)
  (add-to-list 'aws-candidate-list (thing-at-point 'word) t)
  (add-to-list 'aws-candidate-list (thing-at-point 'symbol) t)
  (and aws-region-string (add-to-list 'aws-candidate-list aws-region-string t))
  (setq aws-search-ring-list (aws-cut-search-ring aws-search-ring-length search-ring)))

(defun anything-web-search ()
  "anything-to-web-engine-function"
  (interactive)
  (anything (list anything-c-source-web-search
                  anything-c-source-aws-search-ring
                  anything-c-source-aws-candidate-not-found)
            nil nil nil nil "*web search*"))

(defun aws-web-search (engine word)
  (browse-url (format (cdr (assoc engine search-engines))
                      (url-hexify-string word))))

(defun aws-group-search (candidate lst)
  (while lst
    (if (null lst) nil
      (progn
        (aws-web-search (car lst)  candidate)
        (setq lst (cdr lst))))))

(defun aws-cut-search-ring (n lst)
  (if (or (>= 0 n) (null lst)) nil
    (cons (car lst)
          (aws-cut-search-ring (- n 1) (cdr lst)))))

(provide 'anything-web-search)
;;; anything-web-search.el ends here
