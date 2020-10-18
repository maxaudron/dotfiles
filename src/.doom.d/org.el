;;; ~/.dotfiles/src/.doom.d/org.el -*- lexical-binding: t; -*-
;; ORG mode
(after! org
  (setq org-directory "~/org/")

  (setq org-log-done nil)
  (setq org-log-into-drawer t)

  (require 'org-attach)
  (setq org-link-abbrev-alist '(("att" . org-attach-expand-link)))

  (setq org-todo-keywords
    '((sequence "TODO(t!)" "DOING(o)" "WAIT(w!)" "REVIEW(r!)" "|" "DONE(d!)" "KILL(k!)")
      (sequence "REPORT(r!)" "BUG(b!)" "KNOWNCAUSE(k!)" "|" "FIXED(f!)")
      (sequence "|" "CANCELED(c!)"))))
