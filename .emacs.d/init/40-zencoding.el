
(require 'zencoding-mode)
;; (require 'zencoding-trie)
(add-hook 'sgml-mode-hook 'zencoding-mode)

(if zencoding-mode-keymap
    nil
  (progn
    (setq zencoding-mode-keymap (make-sparse-keymap))
    (define-key zencoding-mode-keymap (kbd "C-o") 'zencoding-expand-line)
    (define-key zencoding-mode-keymap (kbd "C-c C-o") 'zencoding-expand-line)))

;; Basic Tags
;; a                    :<a></a>
;; a.x                  :<a class="x"></a>
;; a#q.x                :<a id="q" class="x"></a>
;; a#q.x.y.z            :<a id="q" class="x y z"></a>
;; Siblings
;; a+b                  :<a></a><b></b>
;; a.x+b                :<a class="x"></a><b></b>
;; a#q.x+b              :<a id="q" class="x"></a><b></b>
;; a#q.x.y.z+b#p.l.m.n  :<a id="q" class="x y z"></a><b id="p" class="l m n"></b>
;; Parent > child
;; a>b                  :<a><b></b></a>
;; a>b>c                :<a>< b><c></c></b></a>
;; a.x>b                :<a class="x"><b></b></a>
;; a#q.x>b              :<a id="q" class="x"><b></b></a>
;; a#q.x.y.z>b#p.l.m.n  :<a id="q" class="x y z"><b id="p" class="l m n"></b></a>
;; a>b+c                :<a><b></b><c></c></a>
;; a>b+c>d              :<a><b></b><c><d></d></c></a>
;; Multiplication
;; a*2                  :<a></a><a></a>
;; a*2+b*2              :<a></a><a></a><b></b><b></b>
;; a*2>b*2              :<a><b></b><b></b></a><a><b></b><b></b></a>
;; a>b*2                :<a><b></b><b></b></a>
;; a#q.x>b#q.x*2        :<a id="q" class="x"><b id="q" class="x"></b><b id="q" class="x"></b></a>
;; Properties
;; a x=y                :<a x="y"></a>
;; a#foo x=y m=l        :<a id="foo" x="y" m="l"></a>
;; a#foo.bar.mu x=y m=l :<a id="foo" class="bar mu" x="y" m="l"></a>
;; a x=y+b              :<a x="y"></a><b></b>
;; a x=y+b x=y          :<a x="y"></a><b x="y"></b>
;; a x=y>b x=y+c x=y    :<a x="y"><b x="y"></b><c x="y"></c></a>
;; Parentheses
;; (a>b)+c              :<a><b></b></a><c></c>
;; z+(a>b)+c+k          :<z></z><a><b></b></a><c></c><k></k>
;; (a>b)*2              :<a><b></b></a><a><b></b></a>
;; (a+b)*2              :<a></a><b></b><a></a><b></b>
