;;; $DOOMDIR/org.el -*- lexical-binding: t; -*-

(after! org
  (setq org-directory "~/org/")

  (require 'org-attach)
  (setq org-link-abbrev-alist '(("att" . org-attach-expand-link)))

  ;; PlantUML
  (setq org-plantuml-jar-path
    (expand-file-name "/usr/share/plantuml/lib/plantuml.jar"))

  (add-to-list
    'org-src-lang-modes '("plantuml" . plantuml))

  ;; Latex export code highlighting
  (setq org-latex-listings 'minted
        org-latex-packages-alist '(("" "minted"))
        org-latex-minted-options '(("breaklines" "true")
                                   ("breakanywhere" "true"))
        org-latex-pdf-process
          '("latexmk -pdflatex='xelatex --shell-escape' -pdf %f"
            "latexmk -pdflatex='xelatex --shell-escape' -pdf %f")))
