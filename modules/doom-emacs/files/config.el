;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; set my identity
(setq user-full-name "Max Audron"
      user-mail-address "audron@cocaine.farm")

;;
;; Look

;; set theme and font
(setq doom-theme 'doom-tomorrow-night)
(custom-set-faces
  '(default ((t (:background "#181818")))))

(setq doom-font (font-spec :family "IBM Plex Mono" :size 17))

;; set fringe to be 8px wide on both sides
(fringe-mode 8)

;; Margins for windows
(setq-default left-margin-width 1)
(setq-default right-margin-width 1)

;; disable line numbers
(setq display-line-numbers-type nil)

;; Disable solair mode
(after! solaire-mode
  (solaire-global-mode -1))


;;
;; Package Config

;; turn quickscope on everywhere
(use-package! evil-quickscope
  :config (global-evil-quickscope-always-mode 1))

;; configure pastebin uploader
(map! :leader :desc "Upload to pastebin" "y" 'emacs-upload)
(use-package! emacs-upload
  :config
  (add-to-list 'emacs-upload/hosts '("c-v" . ("https://c-v.sh"    "file=@%s")))
  (emacs-upload/set-host "c-v"))

;; configure coverlay for showing test coverage
(setq coverlay:fringe 't)
(setq coverlay:fringe-position 'left-fringe)
(setq coverlay:fringe-symbol 'flycheck-fringe-bitmap-continuation)
(setq coverlay:tested-line-background-color "green")

;; add gitlab-ci-mode flycheck hook
(use-package! gitlab-ci-mode-flycheck
  :after flycheck gitlab-ci-mode
  :init
  (gitlab-ci-mode-flycheck-enable))

(after! lsp-ui
  (setq lsp-ui-doc-enable nil))

;;
;; Keybinds

;; Navigate windows
(map! :nvi "C-h" 'evil-window-left)
(map! :nvi "C-l" 'evil-window-right)
(map! :nvi "C-k" 'evil-window-up)
(map! :nvi "C-j" 'evil-window-down)
(map! :leader "w s" 'ace-swap-window)

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

;;
;; Config imports

;; load config files
(load! "config/textmodification")
(load! "config/org")

;; load functions
(load! "functions/yaml-to-json")
(load! "functions/reverse-region-horizontal")
(load! "functions/nix-update")

;; load modes
(load! "modes/jinja2")

;; load secrets
(load! "secrets/forge")
(load! "secrets/mu4e")
(load! "secrets/grip")

(after! rustic
  (setq lsp-rust-analyzer-diagnostics-disabled ["unresolved-proc-macro"])
  (setq lsp-rust-all-features nil))

(defvar auto-minor-mode-alist ()
  "Alist of filename patterns vs correpsonding minor mode functions, see `auto-mode-alist'
All elements of this alist are checked, meaning you can enable multiple minor modes for the same regexp.")

(defun enable-minor-mode-based-on-extension ()
  "Check file name against `auto-minor-mode-alist' to enable minor modes
the checking happens for all pairs in auto-minor-mode-alist"
  (when buffer-file-name
    (let ((name (file-name-sans-versions buffer-file-name))
          (remote-id (file-remote-p buffer-file-name))
          (case-fold-search auto-mode-case-fold)
          (alist auto-minor-mode-alist))
      ;; Remove remote file name identification.
      (when (and (stringp remote-id)
                 (string-match-p (regexp-quote remote-id) name))
        (setq name (substring name (match-end 0))))
      (while (and alist (caar alist) (cdar alist))
        (if (string-match-p (caar alist) name)
            (funcall (cdar alist) 1))
        (setq alist (cdr alist))))))

(add-hook 'find-file-hook #'enable-minor-mode-based-on-extension)

(add-to-list 'auto-minor-mode-alist '("\\.j2\\'" . jinja2-mode))

;; fix home and end keys on mac
(global-set-key (kbd "<home>") 'move-beginning-of-line)
(global-set-key (kbd "<end>") 'move-end-of-line)
