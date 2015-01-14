
(require 'open-junk-file)

(setq open-junk-file-find-file-function 'find-file)
(global-set-key [(meta f11)] 'open-junk-file)
