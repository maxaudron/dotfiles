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
;; (after! rustic
;;   (setq lsp-rust-analyzer-server-command
;;         '("rustup run nightly rust-analyzer")))
;; (after! rustic
;;   (setq lsp-rust-analyzer-server-command
;;         '("~/.rustup/toolchains/nightly-2021-01-07-x86_64-unknown-linux-gnu/bin/rust-analyzer")))

;; jsonnet
(add-hook! jsonnet-mode-hook
  (setq jsonnet-library-search-directories
        (append `(,(concat (projectile-project-root) "lib")
                  ,(concat (projectile-project-root) "vendor")
                  ,(concat (projectile-project-root) "deploy/lib")
                  ,(concat (projectile-project-root) "deploy/vendor"))
                jsonnet-library-search-directories)))

;; Python
(after! lsp-python-ms
  (setq lsp-python-ms-extra-paths
        (append '("/home/audron/.local/lib")
                lsp-python-ms-extra-paths)))

;; Containerfile
(add-to-list 'auto-mode-alist '("Containerfile\\'" . dockerfile-mode))

;; Git
(with-eval-after-load 'git-timemachine
  (evil-make-overriding-map git-timemachine-mode-map 'normal)
  ;; force update evil keymaps after git-timemachine-mode loaded
  (add-hook 'git-timemachine-mode-hook #'evil-normalize-keymaps))

(use-package! gitlab-ci-mode-flycheck
  :after flycheck gitlab-ci-mode
  :init
  (gitlab-ci-mode-flycheck-enable))

;; jsonnet
(defun yaml-to-json ()
  "Replace the selected yaml with it's json representation."
  (interactive)
  (shell-command-on-region
   (region-beginning) (region-end)
   "yq e -j -" nil 't)
  (json-reformat-region
   (region-beginning) (region-end)))
