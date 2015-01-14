;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-
(require 'anything-c-mx)
(setq anything-c-source-mx '((name             . "M-x")
                            (init             . anything-c-mx-candidates-init)
                            (candidates       . anything-c-mx-get-candidates)
                            (type             . command)
                            (requires-pattern . 2)
                            (match            . (identity))
                            (volatile)))
