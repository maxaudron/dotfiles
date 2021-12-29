;;; $DOOMDIR/org.el -*- lexical-binding: t; -*-

(after! org
  (setq org-directory "~/org/")

  (require 'org-attach)
  (setq org-link-abbrev-alist '(("att" . org-attach-expand-link)))

  (defun org-show-current-heading-tidily ()
    (interactive)
    "Show next entry, keeping other entries closed."
    (if (save-excursion (end-of-line) (outline-invisible-p))
        (progn (org-show-entry) (show-children))
      (outline-back-to-heading)
      (unless (and (bolp) (org-on-heading-p))
        (org-up-heading-safe)
        (hide-subtree)
        (error "Boundary reached"))
      (org-overview)
      (org-reveal t)
      (org-show-entry)
      (show-children)))

  (map! :localleader :map org-mode-map "c" 'org-show-current-heading-tidily)

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
