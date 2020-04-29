;;; ~/.dotfiles/src/.doom.d/languages.el -*- lexical-binding: t; -*-

;; GO
(add-hook 'go-mode-hook 'lsp-deferred)
(map! :mode go-mode :localleader :desc "GoTo definition" "g" 'go-guru-definition)

;; LSP
;; Ignore directories
(defun lsp-extend-file-watch-ignored ()
  (setq lsp-file-watch-ignored
        (append '("[/\\\\]vendor"
                  "[/\\\\]build$")
                lsp-file-watch-ignored)))
(add-hook 'lsp-after-initialize-hook 'lsp-extend-file-watch-ignored)

;; Rust
(after! rustic
  (setq lsp-rust-server 'rust-analyzer)
  (setq rustic-lsp-server 'rust-analyzer))
