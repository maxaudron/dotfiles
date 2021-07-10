;;; ~/.dotfiles/src/.doom.d/org.el -*- lexical-binding: t; -*-
;; ORG mode
(after! org
  (setq org-directory "~/org/")

  (setq org-log-done nil)
  (setq org-log-into-drawer t)

  (require 'org-attach)
  (setq org-link-abbrev-alist '(("att" . org-attach-expand-link)))

  (setq org-plantuml-jar-path
    (expand-file-name "/usr/share/plantuml/lib/plantuml.jar"))

  (add-to-list
    'org-src-lang-modes '("plantuml" . plantuml))

  (setq org-latex-listings 'minted
        org-latex-packages-alist '(("" "minted"))
        org-latex-minted-options '(("breaklines" "true")
                                   ("breakanywhere" "true"))
        org-latex-pdf-process
          '("latexmk -pdflatex='xelatex --shell-escape' -pdf %f"
            "latexmk -pdflatex='xelatex --shell-escape' -pdf %f"))

  (setq org-todo-keywords
    '((sequence "TODO(t!)" "DOING(o)" "WAIT(w!)" "REVIEW(r!)" "|" "DONE(d!)" "KILL(k!)")
      (sequence "REPORT(r!)" "BUG(b!)" "KNOWNCAUSE(k!)" "|" "FIXED(f!)")
      (sequence "|" "CANCELED(c!)"))))
