;;; ~/.dotfiles/src/.doom.d/keybinds.el -*- lexical-binding: t; -*-
;;; Code:

;; MISC
(map! :leader :desc "Upload to pastebin" "y" 'emacs-upload)

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

;; SPC t -*- Text modification
(map! :leader :desc "Text Modificaton" "t")
(map! :leader :desc "Refill Mode" "t r" 'refill-mode)
(map! :leader :desc "Justify" "t j")
(map! :leader :desc "Justify Full" "t j f" 'set-justification-full)
(map! :leader :desc "Justify Left" "t j l" 'set-justification-left)
(map! :leader :desc "Justify Right" "t j r" 'set-justification-right)
(map! :leader :desc "Justify None" "t j n" 'set-justification-none)
(map! :leader :desc "Justify Center" "t j c" 'set-justification-center)
(map! :leader :desc "Align" "t a")
(defun align-spaces ()
  "Align region by spaces"
  (interactive)
  (align-regexp (region-beginning) (region-end) "\\(\\s-*\\)\\s-"))
(map! :leader :desc "align on space" "t a SPC" 'align-spaces)
(map! :leader :desc "Insert Lorem Ipsum paragraph" "t l p" 'lorem-ipsum-insert-paragraphs)
(map! :leader :desc "Insert Lorem Ipsum sentence" "t l s" 'lorem-ipsum-insert-sentences)
(map! :leader :desc "Insert Lorem Ipsum paragraph" "t l l" 'lorem-ipsum-insert-list)

(map! :leader :desc "Set case styles" "t i")
(map! :leader :desc "Toggle" "t i i" 'string-inflection-toggle)
(map! :leader :desc "Set CamelCase" "t i C" 'string-inflection-camelcase)
(map! :leader :desc "Set lowerCamelCase" "t i c" 'string-inflection-lower-camelcase)
(map! :leader :desc "Set snake_case" "t i s" 'string-inflection-underscore)
(map! :leader :desc "Set kebab-case" "t i k" 'string-inflection-kebab-case)
(map! :leader :desc "Set CamelCase" "t i C" 'string-inflection-camelcase)

;; ORG Mode bable
(map! :map org-mode-map
      :localleader
      (:prefix ("b" . "babel")
       "r" #'org-babel-execute-maybe))


(provide 'keybinds)
;;; keybinds.el ends here
