;;; ~/.dotfiles/src/.doom.d/languages.el -*- lexical-binding: t; -*-

;; GO
(add-hook 'go-mode-hook 'lsp-deferred)
(map! :mode go-mode :localleader :desc "GoTo definition" "g" 'go-guru-definition)

;; LSP
;; Ignore directories
;; (dolist (dir '(
;;                "[/\\\\]vendor$"
;;                ))
;;     (push dir 'lsp-file-watch-ignored))
