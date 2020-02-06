;;; ~/.dotfiles/src/.doom.d/org.el -*- lexical-binding: t; -*-
;; ORG mode
(setq org-directory "~/org/")

(setq org-log-done 'time)
(setq org-log-into-drawer t)

(setq org-todo-keywords
  '((sequence "TODO(t!)" "DOING(o)" "WAIT(w!)" "REVIEW(r!)" "|" "DONE(d!)" "KILL(k!)")
    (sequence "REPORT(r!)" "BUG(b!)" "KNOWNCAUSE(k!)" "|" "FIXED(f!)")
    (sequence "|" "CANCELED(c!)")))
