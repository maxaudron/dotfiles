;;; $DOOMDIR/textmodification.el -*- lexical-binding: t; -*-

;; SPC t -*- Text modification
(map! :leader :desc "Text Modification" "t")

;; toggle refill mode
(map! :leader :desc "Refill Mode" "t r" 'refill-mode)

;; Set justification for refill mode
(map! :leader :desc "Justify" "t j")
(map! :leader :desc "Justify Full" "t j f" 'set-justification-full)
(map! :leader :desc "Justify Left" "t j l" 'set-justification-left)
(map! :leader :desc "Justify Right" "t j r" 'set-justification-right)
(map! :leader :desc "Justify None" "t j n" 'set-justification-none)
(map! :leader :desc "Justify Center" "t j c" 'set-justification-center)

;; Align text
(defun align-spaces ()
  "Align region by spaces"
  (interactive)
  (align-regexp (region-beginning) (region-end) "\\(\\s-*\\)\\s-"))

(map! :leader :desc "Align" "t a")
(map! :leader :desc "align on space" "t a SPC" 'align-spaces)

;; lorem ipsum
(map! :leader :desc "Insert Lorem Ipsum paragraph"
      "t l p" 'lorem-ipsum-insert-paragraphs)
(map! :leader :desc "Insert Lorem Ipsum sentence"
      "t l s" 'lorem-ipsum-insert-sentences)
(map! :leader :desc "Insert Lorem Ipsum paragraph"
      "t l l" 'lorem-ipsum-insert-list)

;; Modifies casing of text
(map! :leader :desc "Set case styles" "t i")
(map! :leader :desc "Toggle" "t i i" 'string-inflection-toggle)
(map! :leader :desc "Set CamelCase" "t i C" 'string-inflection-camelcase)
(map! :leader :desc "Set lowerCamelCase" "t i c" 'string-inflection-lower-camelcase)
(map! :leader :desc "Set snake_case" "t i s" 'string-inflection-underscore)
(map! :leader :desc "Set kebab-case" "t i k" 'string-inflection-kebab-case)
