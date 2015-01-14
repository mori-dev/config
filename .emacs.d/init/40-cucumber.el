
(setq feature-default-language "ja")
(setq feature-default-i18n-file "~/.emacs.d/elisp/cucumber/i18n.yml")

(require 'feature-mode)
(add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))


(defconst feature-font-lock-keywords
  '((feature      (0 font-lock-keyword-face)
                  (".*" nil nil (0 font-lock-type-face t)))
    (background . (0 font-lock-keyword-face))
    (scenario     (0 font-lock-keyword-face)
                  (".*" nil nil (0 font-lock-function-name-face t)))
    (scenario_outline
                  (0 font-lock-keyword-face)
                  (".*" nil nil (0 font-lock-function-name-face t)))
    (given      . font-lock-keyword-face)
    (when       . font-lock-keyword-face)
    (then       . font-lock-keyword-face)
    (but        . font-lock-keyword-face)
    (and        . font-lock-keyword-face)
    ;; ("\\(＃\\|’\\|”\\|“\\|；\\|：\\|／\\|＼\\|｜\\|＠\\|＋\\|＊\\|＜\\|＞\\|＄\\|％\\|＆\\|．\\|，\\|＝\\|〜\\|─\\|−\\|ー\\|？\\|！\\)"  1 font-lock-warning-face)
    ("\\(＃\\|’\\|”\\|“\\|；\\|：\\|／\\|＼\\|｜\\|＠\\|＋\\|＊\\|＜\\|＞\\|＄\\|％\\|＆\\|．\\|，\\|＝\\|〜\\|？\\|！\\)"  1 font-lock-warning-face)
    (examples   . font-lock-keyword-face)
    ("^ *@.*"   . font-lock-preprocessor-face)
    ("^ *#.*"     0 font-lock-comment-face t)))
