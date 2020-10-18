;;; doom-cocaine-night-theme.el -*- no-byte-compile: t; -*-
(require 'doom-themes)

;;; Code:
(defgroup doom-cocaine-night-theme nil
  "Options for doom-themes"
  :group 'doom-themes)

(defcustom doom-cocaine-night-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line. Can be an integer to determine the exact padding."
  :group 'doom-cocaine-night-theme
  :type '(choice integer boolean))

(def-doom-theme doom-cocaine-night
  "A theme based off of Chris Kempson's Cocaine Dark."

  ;; name        gui       256       16
  ((bg         '("#181818" nil       nil          ))
   (bg-alt     '("#181818" nil       nil          ))
   (base0      '("#181818" "black"   "black"      ))
   (base1      '("#242424" "#242424"              ))
   (base2      '("#333333" "#333333"              ))
   (base3      '("#464646" "#464646" "brightblack"))
   (base4      '("#626262" "#626262" "brightblack"))
   (base5      '("#7d7d7d" "#7d7d7d" "brightblack"))
   (base6      '("#979797" "#979797" "brightblack"))
   (base7      '("#d2d2d2" "#d2d2d2" "brightblack"))
   (base8      '("#f5f5f5" "#f5f5f5" "white"      ))
   (fg         '("#f5f5f5" "#f5f5f5" "white"))
   (fg-alt     (doom-darken fg 0.4))

   (grey       '("#626262" "#626262" "brightblack"))
   (red        '("#f24638" "#f24638" "red"))
   (orange     '("#EB9A4C" "#EB9A4C" "brightred"))
   (yellow     '("#eea967" "#eea967" "yellow"))
   (green      '("#5ec45c" "#5ec45c" "green"))
   (blue       '("#5793e0" "#5793e0" "brightblue"))
   (dark-blue  '("#1a4986" "#1a4986" "blue"))
   (teal       '("#008080" "#008080" "blue")) ; FIXME replace with real teal
   (magenta    '("#e8aafa" "#e8aafa" "magenta"))
   (violet     '("#d298e3" "#d298e3" "brightmagenta"))
   (cyan       '("#9ad9d0" "#9ad9d0" "cyan"))
   (dark-cyan  (doom-darken cyan 0.4))

   ;; face categories
   (highlight      orange)
   (vertical-bar   base1)
   (selection      base1)
   (builtin        blue)
   (comments       grey)
   (doc-comments   base4)
   (constants      orange)
   (functions      blue)
   (keywords       violet)
   (methods        blue)
   (operators      fg)
   (type           yellow)
   (strings        orange)
   (variables      cyan)
   (numbers        red)
   (region         selection)
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    fg-alt)
   (vc-added       green)
   (vc-deleted     red)

   ;; custom categories
   (modeline-bg     '("#101010" "black"   "black"      ))
   (modeline-bg-alt base1)
   (modeline-fg     base8)
   (modeline-fg-alt comments)
   (-modeline-pad
    (when doom-cocaine-night-padded-modeline
      (if (integerp doom-cocaine-night-padded-modeline)
          doom-cocaine-night-padded-modeline
        4))))

  ;; --- faces ------------------------------
  ((doom-modeline-buffer-path       :foreground orange :bold bold)
   (doom-modeline-buffer-major-mode :inherit 'doom-modeline-buffer-path)

   ((line-number &override) :foreground base4)
   ((line-number-current-line &override) :foreground orange)

   ;; rainbow-delimiters
   (rainbow-delimiters-depth-1-face :foreground violet)
   (rainbow-delimiters-depth-2-face :foreground blue)
   (rainbow-delimiters-depth-3-face :foreground orange)
   (rainbow-delimiters-depth-4-face :foreground green)
   (rainbow-delimiters-depth-5-face :foreground magenta)
   (rainbow-delimiters-depth-6-face :foreground yellow)
   (rainbow-delimiters-depth-7-face :foreground teal)

   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg))))

  ;; --- variables --------------------------
  ;; ()
  )

(provide 'doom-cocaine-night-theme)
;;; doom-cocaine-night-theme.el ends here
