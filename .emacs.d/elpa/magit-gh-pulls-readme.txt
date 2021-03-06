This is a Magit extension for manipulating GitHub pull requests

No configuration is needed in the repository if any of your remotes contain a
URL to Github's remote repository. If for some reason you don't have any
Github remotes in your config, you can specify username and repository
explicitly:

$ git config magit.gh-pulls-repo <user>/<repo> # your github repository

Add these lines to your init.el:

(require 'magit-gh-pulls)
(add-hook 'magit-mode-hook 'turn-on-magit-gh-pulls)

These are the bindings for pull requests, defined in magit-gh-pulls-mode-map:
# g --- refreshes the list of pull requests
# f --- fetches the commits associated with the pull request at point
# b --- helps you creating a topic branch from a review request
# m --- merges the PR on top of the current branch
# c --- creates a PR from the current branch
# o --- opens a pull request on GitHub in your default browser

Then, you can do whatever you want with the commit objects associated with
the pull request (merge, cherry-pick, diff, ...)

When you create a new pull request, you can enable -w option to automatically
open it on GitHub in your default browser.
