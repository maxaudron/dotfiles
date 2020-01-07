;;; ~/.dotfiles/src/.doom.d/keybinds.el -*- lexical-binding: t; -*-

;; Navigate windows
(map! :nvi "M-h" 'evil-window-left)
(map! :nvi "M-l" 'evil-window-right)
(map! :nvi "M-k" 'evil-window-up)
(map! :nvi "M-j" 'evil-window-down)

;; Split windows
(map! :leader "w |" 'evil-window-vsplit)
(map! :leader "w -" 'evil-window-split)

;; SPC e -*- Errors
(map! :leader :desc "Errors" "e")
(map! :leader :desc "List all Errors" "e l" 'flycheck-list-errors)
(map! :leader :desc "Next Error" "e n" 'flycheck-next-error)
(map! :leader :desc "Previous Error" "e p" 'flycheck-previous-error)
(map! :leader :desc "Explain Error" "e e" 'flycheck-explain-error-at-point)
(map! :leader :desc "Clear Errors in Buffer" "e C" 'flycheck-clear)
