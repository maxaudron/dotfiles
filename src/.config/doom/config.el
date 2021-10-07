;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; set my identity
(setq user-full-name "Max Audron"
      user-mail-address "audron@cocaine.farm")


;;
;; Look

;; set theme and font
(setq doom-theme 'doom-one)
(setq doom-font (font-spec :family "IBM Plex Mono" :size 14))

;; set fringe to be 8px wide on both sides
(fringe-mode 8)

;; Margins for windows
(setq-default left-margin-width 1)
(setq-default right-margin-width 1)

;; disable line numbers
(setq display-line-numbers-type nil)


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

;;
;; Keybinds

;; Navigate windows
(map! :nvi "C-h" 'evil-window-left)
(map! :nvi "C-l" 'evil-window-right)
(map! :nvi "C-k" 'evil-window-up)
(map! :nvi "C-j" 'evil-window-down)

;; Split windows
(map! :leader "w |" 'evil-window-vsplit)
(map! :leader "w -" 'evil-window-split)


;;
;; Config imports

;; load config files
(load! "textmodification")
(load! "org")

;; load functions
(load! "functions/yaml-to-json")
(load! "functions/reverse-region-horizontal")

;; load secrets
(load! "secrets/forge")
(load! "secrets/mu4e")
