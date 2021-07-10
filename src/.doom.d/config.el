;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; These are used for a number of things, particularly for GPG configuration,
;; some email clients, file templates and snippets.
(setq user-full-name "Max Audron"
      user-mail-address "audron@cocaine.farm")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "IBM Plex Mono" :size 17))

(after! ispell
  (setq ispell-dictionary "en_US,de_DE")
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "en_US,de_DE"))

;; Theme
(setq doom-theme 'doom-tomorrow-night)
(custom-set-faces
  '(default ((t (:background "#181818")))))

;; Fringe size
(fringe-mode 8)

;; Margins for windows
(setq-default left-margin-width 1)
(setq-default right-margin-width 1)

(use-package! evil-quickscope
  :config (global-evil-quickscope-always-mode 1))

(load! "~/.doom.d/modeline")

;; (setq display-line-numbers-type 'relative)
(setq display-line-numbers-type nil)
(setq rainbow-delimiters-mode 't)

;; Load external resources
(load! "~/.doom.d/languages")
(load! "~/.doom.d/keybinds")
(load! "~/.doom.d/org")
(load! "~/.doom.d/mu4e")
(load! "~/.doom.d/utils")

;; uploader
(use-package! emacs-upload
  :config
  (add-to-list 'emacs-upload/hosts '("c-v" . ("https://c-v.sh"    "file=@%s")))
  (emacs-upload/set-host "c-v"))

;; Coverlay coverage overlay
(setq coverlay:fringe 't)
(setq coverlay:fringe-position 'left-fringe)
(setq coverlay:fringe-symbol 'flycheck-fringe-bitmap-continuation)
(setq coverlay:tested-line-background-color "green")

(after! gcmh
  (setq gcmh-high-cons-threshold 33554432))

(after! company-mode (setq company-minimum-prefix-length 2
        company-idle-delay 0.0))


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
