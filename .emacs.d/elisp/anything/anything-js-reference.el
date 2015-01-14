;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; http://d.hatena.ne.jp/trotr/20080716#1216207618

(require 'anything)
(setq javascript-reference-base "http://developer.mozilla.org/ja/docs/Core_JavaScript_1.5_Reference:Global_Objects:")
(setq javascript-reference-htmls '(("DOM" "http://developer.mozilla.org/ja/docs/")))

;; (define-key js2-mode-map "\C-c\C-j" 'anything-js-insert)
;; (define-key js2-mode-map "\C-c\C-i" 'anything-js-reference)

;;==WORNINIG==
(unless (fboundp 'open-link)
  ;;example------
;;   (defun open-link (html)
;;     (shell-command (concat "firefox --new-tab \"" html "\"; wmctrl -a fire")))
  (error "open-link function is not defined!!"))

(unless (boundp 'anything-initial-input) (defvar anything-initial-input ""))

(unless (fboundp 'my-elisp-current-function)
  (defun my-elisp-current-function ()
    (save-excursion
      (let ((syntax "w_"))
	(skip-syntax-forward syntax)
	(let ((end (point)))
	  (skip-syntax-backward syntax)
	  (let ((start (point)))
	    (buffer-substring-no-properties start end)))))))
;;=================


(defun javascript-reference-get-url (str)
  (let* ((tag (car (split-string str ":" t)))
	 (url (cadr (assoc tag javascript-reference-htmls))))
    (concat (if url url javascript-reference-base ) str)))

;(javascript-reference-get-url "DOM:test.pest")	
;(javascript-reference-get-url "Number:toPrecision")
;(javascript-reference-get-url "Number")
;(javascript-reference-get-url "DOM:test")
;(last (split-string "DOM:test.hoge" "[:\.]"))

(setq anything-c-js-source
      '((name . "methods")
	(candidates . anything-js-methods-source)
	(action . (("View MDC" . (lambda (c)
				   (let ((url (javascript-reference-get-url c)))
					 (open-link url))))))))

(setq anything-c-js-insert-method-source
      '((name . "methods")
	(candidates . anything-js-methods-source)
	(action . (("Insert" . (lambda (c)
				 (delete-backward-char (length anything-initial-input))
				 (insert (car (last (split-string c "[:\.]"))))))
		   ("View MDC" . (lambda (c)
				   (let ((url (concat javascript-reference-base c)))
				     (open-link url))))))))

(setq anything-c-js-reserved-word-source
      '((name . "Reserved Word")
	(candidates . anything-js-reserved-words-source)
	(action . (("Insert" . (lambda (c)
				 (delete-backward-char (length anything-initial-input))
				 (insert c)))))))

(setq anything-c-js-class-source
      '((name . "Class")
	(candidates . anything-js-classes-source)
	(action . (("View MDC" . (lambda (c)
				   (let ((url (javascript-reference-get-url c)))
				     (open-link url))))))))

(defun anything-js-reference () (interactive)
  (let ((anything-sources  (list anything-c-js-class-source anything-c-js-source)))
    (anything)))

(defun anything-js-insert () (interactive)
  (let ((anything-sources (list anything-c-js-reserved-word-source anything-c-js-insert-method-source))
	(anything-initial-input (my-elisp-current-function)))
    (anything)))

(setq anything-js-classes-source  '("Array" "Boolean" "Date" "Error" "EvalError" "Function" "Math" "Number" "Object" "RangeError" "ReferenceError" "RegExp" "String" "SyntaxError" "TypeError" "URIError" "DOM:element" "DOM:window" "DOM:document" "DOM:event" "DOM:range" "DOM:selection" "DOM:form"))

(setq anything-js-pseudo-reserved-words-source '("const" "export" "import" "let" "for each"))

(setq anything-js-reserved-words-source (append anything-js-pseudo-reserved-words-source '("break" "case" "catch" "continue" "default" "delete" "do" "else" "finally" "for" "function" "if" "in" "instanceof" "new" "return" "switch" "this" "throw" "try" "typeof" "var" "void" "while" "with " "abstract" "boolean" "byte" "char" "class" "const" "debugger" "double" "enum" "export" "extends" "final" "float" "goto" "implements" "import" "int" "interface" "long" "native" "package" "private" "protected" "public" "short" "static" "super" "synchronized" "throws" "transient" "volatile")))

(setq anything-js-methods-source '("Array:prototype" "Array:constructor" "Array:index" "Array:input" "Array:length" "Array:pop" "Array:push" "Array:reverse" "Array:shift" "Array:sort" "Array:splice" "Array:unshift" "Array:concat" "Array:join" "Array:slice" "Array:toSource" "Array:toString" "Array:indexOf" "Array:lastIndexOf" "Array:filter" "Array:forEach" "Array:every" "Array:map" "Array:some" "Boolean:prototype" "Boolean:constructor" "Boolean:toSource" "Boolean:toString" "Boolean:valueOf" "Date:parse" "Date:prototype" "Date:now" "Date:UTC" "Date:getFullYear" "Date:setFullYear" "Date:getUTCFullYear" "Date:setUTCFullYear" "Date:constructor" "Date:getDate" "Date:getDay" "Date:getHours" "Date:getMilliseconds" "Date:getMinutes" "Date:getMonth" "Date:getSeconds" "Date:getTime" "Date:getTimezoneOffset" "Date:getUTCDate" "Date:getUTCDay" "Date:getUTCHours" "Date:getUTCMilliseconds" "Date:getUTCMinutes" "Date:getUTCMonth" "Date:getUTCSeconds" "Date:getYear" "Date:setDate" "Date:setHours" "Date:setMilliseconds" "Date:setMinutes" "Date:setMonth" "Date:setSeconds" "Date:setTime" "Date:setUTCDate" "Date:setUTCHours" "Date:setUTCMilliseconds" "Date:setUTCMinutes" "Date:setUTCMonth" "Date:setUTCSeconds" "Date:setYear" "Date:toDateString" "Date:toGMTString" "Date:toUTCString" "Date:toLocaleDateString" "Date:toLocaleFormat" "Date:toLocaleString" "Date:toLocaleTimeString" "Date:toSource" "Date:toString" "Date:toTimeString" "Date:valueOf" "Error:prototype" "Error:constructor" "Error:message" "Error:name" "Error:description&action=edit" "Error:number&action=edit" "Error:fileName&action=edit" "Error:lineNumber&action=edit" "Error:stack&action=edit" "Error:toSource" "Error:toString" "EvalError:prototype" "EvalError:constructor" "EvalError:name" "Function:prototype" "Function:caller" "Function:constructor" "Function:length" "Function:name" "Function:apply" "Function:call" "Function:toSource" "Function:toString" "Function:valueOf" "Function:arguments" "Function:arity" "Math:E" "Math:LN2" "Math:LN10" "Math:LOG2E" "Math:LOG10E" "Math:PI" "Math:SQRT1_2" "Math:SQRT2" "Math:abs" "Math:acos" "Math:asin" "Math:atan" "Math:atan2" "Math:ceil" "Math:cos" "Math:exp" "Math:floor" "Math:log" "Math:max" "Math:min" "Math:pow" "Math:random" "Math:round" "Math:sin" "Math:sqrt" "Math:tan" "Math:toSource&action=edit" "Number:MAX_VALUE" "Number:MIN_VALUE" "Number:NaN" "Number:NEGATIVE_INFINITY" "Number:POSITIVE_INFINITY" "Number:prototype" "Number:prototype&action=edit&section=1" "Number:constructor" "Number:prototype&action=edit&section=2" "Number:toExponential" "Number:toFixed" "Number:toLocaleString&action=edit" "Number:toPrecision" "Number:toSource" "Number:toString" "Number:valueOf" "Object:prototype" "Object:_defineGetter" "Object:_defineSetter" "Object:hasOwnProperty" "Object:isPrototypeOf" "Object:_lookupGetter" "Object:_lookupSetter" "Object:_noSuchMethod" "Object:propertyIsEnumerable" "Object:unwatch" "Object:watch" "Object:constructor" "Object:eval" "Object:_parent" "Object:_proto" "Object:toSource" "Object:toLocaleString" "Object:toString" "Object:valueOf" "RangeError:prototype" "ReferenceError:prototype" "ReferenceError:constructor" "ReferenceError:name" "RegExp:prototype" "RegExp:constructor" "RegExp:global" "RegExp:ignoreCase" "RegExp:lastIndex" "RegExp:multiline" "RegExp:source" "RegExp:exec" "RegExp:test" "RegExp:toSource" "RegExp:toString" "String:charAt" "String:localeCompare&action=edit" "String:prototype" "String:fromCharCode" "String:prototype&action=edit&section=1" "String:constructor" "String:length" "String:prototype&action=edit&section=2" "String:prototype&action=edit&section=3" "String:charCodeAt" "String:concat" "String:indexOf" "String:lastIndexOf" "String:match" "String:quote&action=edit" "String:replace" "String:search" "String:slice" "String:split" "String:substr" "String:substring" "String:toLocaleLowerCase&action=edit" "String:toLowerCase" "String:toLocaleUpperCase&action=edit" "String:toUpperCase" "String:toSource" "String:toString" "String:valueOf" "String:prototype&action=edit&section=4" "String:anchor" "String:big" "String:blink" "String:bold" "String:fixed" "String:fontcolor" "String:fontsize" "String:italics" "String:link" "String:small" "String:strike" "String:sub" "String:sup" "String:prototype&action=edit&section=5" "String:prototype&action=edit&section=6" "SyntaxError:prototype" "SyntaxError:constructor" "SyntaxError:name" "TypeError:prototype" "TypeError:constructor" "TypeError:name" "URIError:prototype" "URIError:constructor" "URIError:name" "DOM:element" "DOM:form" "DOM:element.attributes" "DOM:element.childNodes" "DOM:element.clientHeight" "DOM:element.clientLeft" "DOM:element.clientTop" "DOM:element.firstChild" "DOM:element.id" "DOM:element.innerHTML" "DOM:element.lang" "DOM:element.localName" "DOM:element.namespaceURI" "DOM:element.nextSibling" "DOM:element.nodeName" "DOM:element.nodeType" "DOM:element.ownerDocument" "DOM:document" "DOM:element.parentNode" "DOM:element.prefix" "DOM:element.previousSibling" "DOM:element.style" "DOM:element.tagName" "DOM:element.addEventListener" "DOM:event" "DOM:element.appendChild" "DOM:element.cloneNode" "DOM:element.dispatchEvent" "DOM:element.getAttribute" "DOM:element.getAttributeNS" "DOM:element.getAttributeNode" "DOM:element.getElementsByTagName" "DOM:element.getElementsByTagNameNS" "DOM:element.hasAttribute" "DOM:element.hasAttributeNS" "DOM:element.insertBefore" "DOM:element.removeAttribute" "DOM:element.removeAttributeNode" "DOM:element.removeEventListener" "DOM:element.scrollIntoView" "DOM:element.setAttribute" "DOM:element.setAttributeNS" "DOM:element.setAttributeNode" "DOM:element.oncopy" "DOM:element.oncut" "DOM:element.onpaste" "DOM:window" "DOM:window.resizeTo" "DOM:window.resizeBy" "DOM:window.applicationCache" "DOM:window.content" "DOM:window.closed" "DOM:window.controllers" "DOM:window.crypto" "DOM:window.defaultStatus" "DOM:window.showModalDialog" "DOM:window.directories" "DOM:window.document" "DOM:window.frameElement" "DOM:window.frames" "DOM:window.fullScreen" "DOM:Storage#globalStorage" "DOM:window.history" "DOM:window.innerHeight" "DOM:window.innerWidth" "DOM:window.length" "DOM:window.location" "DOM:window.locationbar" "DOM:window.menubar" "DOM:window.name" "DOM:window.navigator" "DOM:window.opener" "DOM:window.outerHeight" "DOM:window.outerWidth" "DOM:window.scrollX" "DOM:window.scrollY" "DOM:window.parent" "DOM:window.personalbar" "DOM:window.pkcs11" "DOM:window.screen" "DOM:window.screen.availTop" "DOM:window.screen.availLeft" "DOM:window.screen.availHeight" "DOM:window.screen.availWidth" "DOM:window.screen.colorDepth" "DOM:window.screen.height" "DOM:window.screen.left" "DOM:window.screen.pixelDepth" "DOM:window.screen.top" "DOM:window.screen.width" "DOM:window.screenX" "DOM:window.screenY" "DOM:window.scrollbars" "DOM:window.scrollMaxX" "DOM:window.scrollMaxY" "DOM:window.self" "DOM:Storage#sessionStorage" "DOM:window.sidebar" "DOM:window.status" "DOM:window.statusbar" "DOM:window.toolbar" "DOM:window.top" "DOM:window.window" "DOM:window.alert" "DOM:window.atob" "DOM:window.back" "DOM:window.blur" "DOM:window.btoa" "DOM:window.captureEvents" "DOM:window.clearInterval" "DOM:window.clearTimeout" "DOM:window.close" "DOM:window.confirm" "DOM:window.dump" "DOM:window.escape" "DOM:window.find" "DOM:window.focus" "DOM:window.forward" "DOM:window.getAttention" "DOM:window.getComputedStyle" "DOM:window.getSelection" "DOM:window.home" "DOM:window.moveBy" "DOM:window.moveTo" "DOM:window.open" "DOM:window.postMessage" "DOM:window.print" "DOM:window.prompt" "DOM:window.releaseEvents" "DOM:window.scroll" "DOM:window.scrollBy" "DOM:window.scrollByLines" "DOM:window.scrollByPages" "DOM:window.scrollTo" "DOM:window.setInterval" "DOM:window.setTimeout" "DOM:window.sizeToContent" "DOM:window.stop" "DOM:window.unescape" "DOM:window.updateCommands" "DOM:window.onabort" "DOM:window.onblur" "DOM:window.onchange" "DOM:window.onmouseup" "DOM:document.anchors" "DOM:document.documentElement" "DOM:document.documentURIObject" "DOM:document.firstChild" "DOM:document.forms" "DOM:document.links" "DOM:document.styleSheets" "DOM:document.URL" "DOM:document.close" "DOM:document.createElement" "DOM:document.createEvent" "DOM:document.elementFromPoint" "DOM:document.getElementById" "DOM:document.getElementsByName" "DOM:document.getElementsByTagName" "DOM:document.importNode" "DOM:document.open" "DOM:document.write" "DOM:document.writeln" "DOM:element#Event_Handlers" "DOM:event.altKey" "DOM:event.bubbles" "DOM:event.button" "DOM:event.cancelable" "DOM:event.initEvent" "DOM:event.stopPropagation" "DOM:event.preventDefault" "DOM:range" "DOM:range.collapsed" "DOM:selection" "DOM:form.elements" "DOM:form.length" "DOM:form.action" "DOM:form.method" "DOM:form.submit"))
(provide 'anything-js-reference)

