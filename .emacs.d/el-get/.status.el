((el-get status "installed" recipe
		 (:name el-get :website "https://github.com/dimitri/el-get#readme" :description "Manage the external elisp bits and pieces you depend upon." :type github :branch "4.stable" :pkgname "dimitri/el-get" :features el-get :info "." :load "el-get.el"))
 (jump status "installed" recipe
	   (:name jump :auto-generated t :type emacswiki :description "interactive function that jump directly to the thing at point" :website "https://raw.github.com/emacsmirror/emacswiki.org/master/jump.el"))
 (skype status "installed" recipe
		(:name skype :description "Skype UI for emacs users." :type github :pkgname "buzztaiki/emacs-skype" :features skype))
 (sl status "installed" recipe
	 (:name sl :auto-generated t :type emacswiki :description "sl for emacs lisp" :website "https://raw.github.com/emacsmirror/emacswiki.org/master/sl.el"))
 (smartchr status "installed" recipe
		   (:type github :username "emacsmirror" :name smartchr :type emacsmirror :features smartchr :description "Emacs version of smartchr.vim"))
 (tree-mode status "installed" recipe
			(:name tree-mode :auto-generated t :type emacswiki :description "A mode to manage tree widgets" :website "https://raw.github.com/emacsmirror/emacswiki.org/master/tree-mode.el"))
 (tsv-mode status "installed" recipe
		   (:name tsv-mode :auto-generated t :type emacswiki :description "Major mode for edit table files" :website "https://raw.github.com/emacsmirror/emacswiki.org/master/tsv-mode.el")))
