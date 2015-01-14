;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

(setq scroll-margin 0)
(setq scroll-conservatively 100000)
(setq scroll-preserve-screen-position 1)

;(require 'smooth-scrolling)

;; http://emacs-fu.blogspot.com/2009/12/scrolling.html
;; http://adamspiers.org/computing/elisp/smooth-scrolling.el

;; Scrolling It's an integral part of just about any graphical user interface, including emacs. However, I always found that the default way scrolling works in emacs left something to be desired. It puts the scroll bar on the left (!), and when scrolling around, it does not scroll smoothly, but instead it seem to do so in bursts. But, this being emacs, we can change it!

;; First, the position of the scroll bar. Presumably for historical reasons, emacs puts the scroll bar on the left of the window, unlike most other programs. We can easily change that, by putting the following in .emacs (or ~/.emacs.d/init.el):

;; (set-scroll-bar-mode 'right)

;; Instead of right, you can also use left, or nil to hide the scroll bar completely. You can also do this through the menu (Options / Show/Hide / Scroll bar). Note that on X, when the cursor (point) reaches the end of the document, the slider on the scroll bar may not be at the bottom; I understand this is because of some disagreement between Emacs and the toolkit (GTK+ in this case).

;; Now, what about the other issue, the non-smoothness when scrolling with the cursor-keys or with C-n, C-p? Below are my settings for making scrolling a bit smoother, and the explanation. Of course, these are just my personal preferences.

;; (setq scroll-margin 0)
;; (setq scroll-conservatively 100000)
;; (setq scroll-preserve-screen-position 1)

;;     * The scroll-margin. This determines when scrolling should start; by setting it to 0, emacs will start to scroll whenever you are entering the top or bottom line of the window. You can also this to, say, 5 to let scrolling start whenever you're getting closer than 5 lines from top or bottom
;;     * Then, scroll-conservatively determines how far the cursor is allowed to be distanced from the center of the screen when scrolling start. The default sets this to 0, which means that whenever you start scrolling, the cursor jumps to the center of the screen. I find that quite annoying, so I set it to some big number (the 'effective maximum' for that is lines-in-window / 2, but you can put any bigger number there to avoid the jumpiness)
;;     * scroll-preserve-screen-position tries to maintain the current screen position when you scroll using Page-Up/Page-Down. I like that.

;; There are also the variables scroll-up-aggressively and scroll-down-aggressively. Normally, they determine how far emacs will scroll (up and down, respectively) when it does so. However, they don't make any difference with a big scroll-conservatively like I am using. Still, if you want to play with it, their values are fractions between 0.0 and 1.0 (inclusive); a value of 1 means that it will move a full screen when scrolling starts, a value of 0.0 causes a move of only one single line.

