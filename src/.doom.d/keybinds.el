;;; ~/.dotfiles/src/.doom.d/keybinds.el -*- lexical-binding: t; -*-
;;; Code:

;; Navigate windows
(map! :nvi "C-h" 'evil-window-left)
(map! :nvi "C-l" 'evil-window-right)
(map! :nvi "C-k" 'evil-window-up)
(map! :nvi "C-j" 'evil-window-down)

;; Split windows
(map! :leader "w |" 'evil-window-vsplit)
(map! :leader "w -" 'evil-window-split)

;; ORG MODE
(defun open-org-index ()
  "Open 'org-mode' index."
  (interactive)
  (find-file (concat org-directory "index.org")))
(map! :leader :desc "Open org-mode index" "o o" 'open-org-index)

(defun open-org-project ()
  "Open 'org-mode' project file."
  (interactive)
  (find-file (concat org-directory (concat "projects/" (concat (projectile-project-name) ".org")))))
(map! :leader :desc "Open org-mode project file" "p o" 'open-org-project)

;; SPC e -*- Errors
(map! :leader :desc "Errors" "e")
(map! :leader :desc "List all Errors" "e l" 'flycheck-list-errors)
(map! :leader :desc "Next Error" "e n" 'flycheck-next-error)
(map! :leader :desc "Previous Error" "e p" 'flycheck-previous-error)
(map! :leader :desc "Explain Error" "e e" 'flycheck-explain-error-at-point)
(map! :leader :desc "Clear Errors in Buffer" "e C" 'flycheck-clear)

(provide 'keybinds)
;;; keybinds.el ends here
