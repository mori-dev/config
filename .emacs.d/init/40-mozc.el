

;; /usr/share/emacs/site-lisp/emacs-mozc/mozc.el

(require 'mozc)
;; or (load-file "/path/to/mozc.el")
(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")
(setq mozc-candidate-style 'overlay)

(require 'key-chord)
(key-chord-define mozc-mode-map "aa" "aa")


;; http://mozc.googlecode.com/svn/trunk/src/unix/emacs/mozc.el
;; (setq mozc-keymap-kana mozc-keymap-kana-106jp)


;; (require 'mozc)
;; (require 'ccc)

;; (require 'key-chord)
;; (key-chord-define mozc-mode-map "aa" "aa")

(add-hook 'mozc-mode-hook
  (lambda()
    (define-key mozc-mode-map (kbd "C-a") 'my-move-beginning-of-line)
    (define-key mozc-mode-map (kbd "C-e") 'my-end-of-line)
    ))


;; (set-language-environment "japanese")
;; (setq default-input-method "japanese-mozc")
;; (global-set-key (kbd "<zenkaku-hankaku>") 'toggle-input-method)


(setq mozc-color "blue")

(defun mozc-change-cursor-color ()
  (if mozc-mode
      (set-buffer-local-cursor-color mozc-color)
    (set-buffer-local-cursor-color nil)))

(defadvice toggle-input-method (around toggle-input-method-around activate)
  (let ((input-method-function-save input-method-function))
    ad-do-it
    (setq input-method-function input-method-function-save)))

;; (if (featurep 'key-chord)
;;     (defadvice toggle-input-method (after my-toggle-input-method activate)
;;       ;; (key-chord-mode 0)
;;       ;; (key-chord-mode 1)
;;       (mozc-change-cursor-color)
;;       ))

;; 辞書登録 GUI の起動 M-x mozc-dict
(defun mozc-dict ()
  (interactive)
  (unless (executable-find "/usr/lib/mozc/mozc_tool")
    (error "mozc_tool not found"))
  (start-process  "mozc_dictionary_tool" nil "/usr/lib/mozc/mozc_tool" "--mode=dictionary_tool"))

;; 全角半角キー対応のために上書き
(defsubst mozc-session-sendkey (key-list)
  "Send a key event to the helper process and return the resulting protobuf.
The resulting protocol buffer, which is represented as alist, is
mozc::commands::Output in C++.  Return nil on error.

KEY-LIST is a list of key code(97 = ?a) and/or key symbols('space, 'shift,
'meta and so on)."
  (when (equal '(zenkaku-hankaku) key-list) ; 全角半角だった場合は強引に C-\ だったことにする
    (setq key-list '(110 control)))         ; (110 control) は C-\ に対応しているはず
  (when (mozc-session-create)
    (apply 'mozc-session-execute-command 'SendKey key-list)))

;; (defsubst mozc-session-sendkey (key-list)
;;   "Send a key event to the helper process and return the resulting protobuf.
;; The resulting protocol buffer, which is represented as alist, is
;; mozc::commands::Output in C++.  Return nil on error.

;; KEY-LIST is a list of key code(97 = ?a) and/or key symbols('space, 'shift,
;; 'meta and so on)."
;;   ;; (when (equal '(zenkaku-hankaku) key-list) ; ; 全角半角だった場合は強引に C-\ だったことにする
;;   ;;   (setq key-list '(110 control)))         ;
;;   ;; (when (equal '(12288) key-list)
;;   ;;   (setq key-list '(32)))
;;   ;; (when (equal '(98 control) key-list)
;;   ;;   (setq key-list '(left shift)))
;;   ;; (when (equal '(102 control) key-list)
;;   ;;   (setq key-list '(right shift)))
;;   ;; (when (equal '(space control) key-list)
;;   ;;   (setq key-list '(space shift)))
;;   (when (mozc-session-create)
;;     (apply 'mozc-session-execute-command 'SendKey key-list)))


;; (popup-menu '(Foo Bar Baz))
;; (popup-menu '(Foo Bar Baz) :scroll-bar t :margin t)
;; (require 'popup.el)

;; popup.el
;;候補一つに対する様々な属性をもったリスト。candidate がいろいろ
;; value が 候補の文字列。
;; (defun mozc-cand-echo-area-make-contents (candidates)
;;   "Make a list of candidates as an echo area message.
;; CANDIDATES must be the candidates field in a response protobuf.
;; Return a string formatted to suit for the echo area."
;;   (let ((focused-index (mozc-protobuf-get candidates 'focused-index))
;;         (size (mozc-protobuf-get candidates 'size))
;;         (index-visible (mozc-protobuf-get candidates 'footer 'index-visible)))
;;     (apply
;;      'concat
;;      ;; Show "focused-index/#total-candidates".
;;      (when (and index-visible focused-index size)
;;        (propertize
;;         (format "%d/%d" (1+ focused-index) size)
;;         'face 'mozc-cand-echo-area-stats-face))
;;      ;; Show each candidate.
;;      (mapcar
;;       (lambda (candidate)
;;         (let ((shortcut (mozc-protobuf-get candidate 'annotation 'shortcut))
;;               (value (mozc-protobuf-get candidate 'value))
;;               (desc (mozc-protobuf-get candidate 'annotation 'description))
;;               (index (mozc-protobuf-get candidate 'index)))
;;           (concat
;;            " "
;;            (propertize  ; shortcut
;;             (if shortcut
;;                 (format "%s." shortcut)
;;               (format "%d." (1+ index)))
;;             'face 'mozc-cand-echo-area-shortcut-face)
;;            " "
;;            (propertize value  ; candidate
;;                        'face (if (eq index focused-index)
;;                                  'mozc-cand-echo-area-focused-face
;;                                'mozc-cand-echo-area-candidate-face))
;;            (when desc " ")
;;            (when desc
;;              (propertize (format "(%s)" desc)
;;                          'face 'mozc-cand-echo-area-annotation-face)))))
;;       (mozc-protobuf-get candidates 'candidate)))))




;; popup

;; (setq debug-on-error t)

;; (defvar popup-mozc-candidate nil)
;; (defvar popup-mozc-instance nil)

;; (defsubst popup-mozc (candidates)
;;   (interactive)
;;   (setq popup-mozc-candidate nil)

;;   (mapcar
;;     (lambda (candidate)
;;       (let ((value (mozc-protobuf-get candidate 'value))
;;             (index (mozc-protobuf-get candidate 'index)))
;;         (incf index)

;;         ;;todo あとで
;;         (unless (null index)
;;           (when (>= index 10)
;;             (decf index 9)))

;;         (push (format "%s:%s" index value) popup-mozc-candidate)
;;         ))
;;     (mozc-protobuf-get candidates 'candidate))

;;   (setq popup-mozc-candidate (nreverse popup-mozc-candidate))

;;   (setq popup-mozc-focused-index (mozc-protobuf-get candidates 'focused-index))
;;   (unless (null popup-mozc-focused-index)

;;     ;;todo あとで
;;     (when (>= popup-mozc-focused-index 10)
;;       (decf popup-mozc-focused-index 9)))

;;   ;; (message (prin1-to-string popup-mozc-focused-index))

;;   ;; (popup-mozc-clear)
;;   (popup-mozc-popup popup-mozc-candidate popup-mozc-focused-index)
;; )



;; (defun popup-mozc-popup (lst pfindex)
;;      (unless (and popup-mozc-instance (popup-p popup-mozc-instance))
;;        (setq popup-mozc-instance
;;              (popup-create (point)                      ; pos
;;                            (popup-preferred-width lst)  ; width
;;                            10                           ; height
;;                            :around t
;;                            :face 'popup-menu-face
;;                            :selection-face 'popup-menu-selection-face
;;                            :scroll-bar t
;;                            )))
;;     (unwind-protect
;;       (progn
;;         (unless (null pfindex)
;;            (popup-set-list popup-mozc-instance lst)
;;            (popup-draw popup-mozc-instance)
;;            (popup-select popup-mozc-instance pfindex)
;;         ))
;; ))


;; (defun popup-mozc-clear ()
;;   (interactive)
;;     (unwind-protect
;;       (progn
;;   (when (and popup-mozc-instance (popup-p popup-mozc-instance))
;;     (popup-delete popup-mozc-instance))
;;   (setq popup-mozc-instance nil))
;; ))


;; ;;以下は上書き
;; (defsubst mozc-candidate-update (candidates)
;;   "Update the candidate window.
;; CANDIDATES must be the candidates field in a response protobuf."
;;   (unwind-protect
;;     (progn

;;   (unless mozc-candidate-in-session-flag
;;     (mozc-candidate-init))
;;   (popup-mozc-clear)
;;   (popup-mozc candidates)
;;   ;; toremove
;;   ;; (mozc-cand-echo-area-update candidates)
;;   )
;; ))

;; (defun mozc-handle-event (event)
;;   "Pass all key inputs to Mozc server and render the resulting response.
;; If Mozc server didn't consume a key event, try to process the key event
;; without Mozc finding another command bound to the key sequence.

;; EVENT is the last input event, which is usually passed by the command loop."
;;   (interactive  (list last-command-event))
;;     (unwind-protect
;;       (progn

;;   (cond
;;    ;; Keyboard event
;;    ((or (integerp event) (symbolp event))
;;     (let ((output (mozc-session-sendkey
;;                    (mozc-key-event-to-key-and-modifiers event))))
;;       (cond
;;        ((null output)  ; Error occurred.
;;         (mozc-clean-up-session)  ; Discard the current session.
;;         (mozc-abort)
;;         (error "Connection error"))

;;        ;; Mozc server consumed the key event.
;;        ((mozc-protobuf-get output 'consumed)
;;         (let ((result (mozc-protobuf-get output 'result))
;;               (preedit (mozc-protobuf-get output 'preedit))
;;               (candidates (mozc-protobuf-get output 'candidates)))

;;           (if (not (or result preedit))
;;               (mozc-clean-up-changes-on-buffer)  ; nothing to show
;;             (when result  ; Insert the result first.

;;               (mozc-clean-up-changes-on-buffer)
;;               (unless (eq (mozc-protobuf-get result 'type) 'string)
;;                 (error "Unknown result type"))
;;               (insert (mozc-protobuf-get result 'value)))

;;             ;; add 候補オーバイの削除
;;             (popup-mozc-clear)

;;             (if preedit                 ; Update the preedit.
;;                 (mozc-preedit-update preedit)
;;               (mozc-preedit-clear))
;;             (if candidates              ; Update the candidate window.
;;                 (mozc-candidate-update candidates)
;;               (mozc-candidate-clear))))
;;        )

;;        (t  ; Mozc server didn't consume the key event.
;;         (mozc-clean-up-changes-on-buffer)
;;         ;; Process the key event as if Mozc didn't hook the key event.
;;         (mozc-fall-back-on-default-binding event)))))

;;    ;; Other events
;;    (t
;;     ;; Fall back on a default binding.
;;     ;; Leave the current preedit and candidate window as it is.
;;     (mozc-fall-back-on-default-binding event))))

;; ))
