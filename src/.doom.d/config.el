;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!


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
(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 13))

;; Config
(setq doom-theme 'doom-tomorrow-night)
(setq org-directory "~/org/")
(setq display-line-numbers-type 'relative)

;; Modeline
(setq doom-modeline-buffer-file-name-style 'file-name)
(setq doom-modeline-icon t)
(setq doom-modeline-buffer-state-icon t)
(setq doom-modeline-buffer-modification-icon nil)
(setq doom-modeline-enable-word-count t)

(global-hl-line-mode nil)

(setenv "SSH_AUTH_SOCK" "/run/user/1000/gnupg/S.gpg-agent.ssh")

(setq epg-gpg-program "gpg2")
(setq epa-pinentry-mode 'loopback)

;; Load external resources
(load! "~/.doom.d/keybinds")
(load! "~/.doom.d/languages")
(load! "~/.doom.d/mu4e")

;; (after! tramp
;;   (setq 'tramp-default-remote-shell "/bin/sh")
;;   (add-to-list 'tramp-connection-properties
;;               (list (regexp-quote "/ssh:testcenter02:/srv/maximilan.manz")
;;                     "remote-shell" "/bin/bash"))
;;   (add-to-list 'tramp-connection-properties
;;               (list (regexp-quote "/ssh:testcenter02:/srv/maximilan.manz")
;;                     "remote-shell-login" '("-"))))

(setq explicit-shell-file-name "/bin/sh")

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
