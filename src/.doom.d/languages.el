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
  (setq rustic-lsp-server 'rust-analyzer)
  (setq lsp-ui-doc-enable 'nil)
  (setq lsp-ui-doc-position 'top)
  (setq lsp-ui-doc-use-webkit 'nil))

(after! lsp-python-ms
  (setq lsp-python-ms-extra-paths
        (append '("/home/audron/.local/lib")
                lsp-python-ms-extra-paths)))

(add-to-list 'auto-mode-alist '("Containerfile\\'" . dockerfile-mode))

(with-eval-after-load 'git-timemachine
  (evil-make-overriding-map git-timemachine-mode-map 'normal)
  ;; force update evil keymaps after git-timemachine-mode loaded
  (add-hook 'git-timemachine-mode-hook #'evil-normalize-keymaps))

(setq coverlay:tested-line-background-color "green")
