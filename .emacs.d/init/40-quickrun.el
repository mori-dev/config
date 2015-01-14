(require 'quickrun)

(quickrun-add-command "coffee-compile"
                      '((:command . "coffee")
                        (:exec . "%c --compile --print %s")
                        (:outputter . (lambda () (javascript-generic-mode))))
                      :default "coffee")
;; javascript-generic-modeのため
(require 'generic-x)
