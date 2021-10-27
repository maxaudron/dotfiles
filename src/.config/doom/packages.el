;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.

;; disable solair mode
(package! solaire-mode :disable t)

;; MODES
(package! gitlab-ci-mode)
(package! jsonnet-mode)
(package! ebuild-mode)
(package! meson-mode)
(package! ini-mode)

;; TOOLS
(package! string-inflection)
(package! evil-quickscope)
(package! emacs-upload
  :recipe (:repo "https://git.lain.church/zdm/emacs-upload"))
(package! coverlay
  :recipe (:repo "maxaudron/coverlay.el"))
(package! verb)

;; JIRA
(package! org-jira)
(package! ejira
  :recipe (:repo "https://github.com/nyyManni/ejira"))
