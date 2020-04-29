;;; cocaine-theme.el --- Cocaine Theme

;; Copyright 2015-present, All rights reserved
;;
;; Code licensed under the MIT license

;; Author: film42
;; Version: 1.7.0
;; Package-Requires: ((emacs "24.3"))
;; URL: https://github.com/cocaine/emacs

;;; Commentary:

;; A dark color theme available for a number of editors.

;;; Code:
(require 'cl-lib)
(deftheme cocaine)


;;;; Configuration options:

(defgroup cocaine nil
  "Cocaine theme options.

The theme has to be reloaded after changing anything in this group."
  :group 'faces)

(defcustom cocaine-enlarge-headings t
  "Use different font sizes for some headings and titles."
  :type 'boolean
  :group 'cocaine)

(defcustom cocaine-height-title-1 1.3
  "Font size 100%."
  :type 'number
  :group 'cocaine)

(defcustom cocaine-height-title-2 1.1
  "Font size 110%."
  :type 'number
  :group 'cocaine)

(defcustom cocaine-height-title-3 1.0
  "Font size 130%."
  :type 'number
  :group 'cocaine)

(defcustom cocaine-height-doc-title 1.44
  "Font size 144%."
  :type 'number
  :group 'cocaine)

(defcustom cocaine-alternate-mode-line-and-minibuffer nil
  "Use less bold and pink in the minibuffer."
  :type 'boolean
  :group 'cocaine)

(defvar cocaine-use-24-bit-colors-on-256-colors-terms nil
  "Use true colors even on terminals announcing less capabilities.

Beware the use of this variable.  Using it may lead to unwanted
behavior, the most common one being an ugly blue background on
terminals, which don't understand 24 bit colors.  To avoid this
blue background, when using this variable, one can try to add the
following lines in their config file after having load the
Cocaine theme:

    (unless (display-graphic-p)
      (set-face-background 'default \"black\" nil))

There is a lot of discussion behind the 256 colors theme (see URL
`https://github.com/cocaine/emacs/pull/57').  Please take time to
read it before opening a new issue about your will.")


;;;; Theme definition:

;; Assigment form: VARIABLE COLOR [256-COLOR [TTY-COLOR]]
(let ((colors '(;; Upstream theme color
                (cocaine-bg      "#282a36" "unspecified-bg" "unspecified-bg") ; official background
                (cocaine-fg      "#f8f8f2" "#ffffff" "brightwhite") ; official foreground
                (cocaine-current "#44475a" "#303030" "brightblack") ; official current-line/selection
                (cocaine-comment "#6272a4" "#5f5faf" "blue")        ; official comment
                (cocaine-cyan    "#8be9fd" "#87d7ff" "brightcyan")  ; official cyan
                (cocaine-green   "#50fa7b" "#5fff87" "green")       ; official green
                (cocaine-orange  "#ffb86c" "#ffaf5f" "brightred")   ; official orange
                (cocaine-pink    "#ff79c6" "#ff87d7" "magenta")     ; official pink
                (cocaine-purple  "#bd93f9" "#af87ff" "brightmagenta") ; official purple
                (cocaine-red     "#ff5555" "#ff8787" "red")         ; official red
                (cocaine-yellow  "#f1fa8c" "#ffff87" "yellow")      ; official yellow
                ;; Other colors
                (bg2             "#373844" "#121212" "brightblack")
                (bg3             "#464752" "#262626" "brightblack")
                (bg4             "#565761" "#444444" "brightblack")
                (fg2             "#e2e2dc" "#e4e4e4" "brightwhite")
                (fg3             "#ccccc7" "#c6c6c6" "white")
                (fg4             "#b6b6b2" "#b2b2b2" "white")
                (other-blue      "#0189cc" "#0087ff" "brightblue")))
      (faces '(;; default
               (cursor :background ,fg3)
               (completions-first-difference :foreground ,cocaine-pink :weight bold)
               (default :background ,cocaine-bg :foreground ,cocaine-fg)
               (default-italic :slant italic)
               (ffap :foreground ,fg4)
               (fringe :background ,cocaine-bg :foreground ,fg4)
               (highlight :foreground ,fg3 :background ,bg3)
               (hl-line :background ,cocaine-current :extend t)
               (info-quoted-name :foreground ,cocaine-orange)
               (info-string :foreground ,cocaine-yellow)
               (lazy-highlight :foreground ,fg2 :background ,bg2)
               (link :foreground ,cocaine-cyan :underline t)
               (linum :slant italic :foreground ,bg4 :background ,cocaine-bg)
               (line-number :slant italic :foreground ,bg4 :background ,cocaine-bg)
               (match :background ,cocaine-yellow :foreground ,cocaine-bg)
               (minibuffer-prompt
                ,@(if cocaine-alternate-mode-line-and-minibuffer
                      (list :weight 'normal :foreground cocaine-fg)
                    (list :weight 'bold :foreground cocaine-pink)))
               (read-multiple-choice-face :inherit completions-first-difference)
               (region :inherit match :extend t)
               (trailing-whitespace :foreground "unspecified-fg" :background ,cocaine-orange)
               (vertical-border :foreground ,bg2)
               (success :foreground ,cocaine-green)
               (warning :foreground ,cocaine-orange)
               (error :foreground ,cocaine-red)
               (header-line :background ,cocaine-bg)
               ;; syntax
               (font-lock-builtin-face :foreground ,cocaine-orange)
               (font-lock-comment-face :foreground ,cocaine-comment)
               (font-lock-comment-delimiter-face :foreground ,cocaine-comment)
               (font-lock-constant-face :foreground ,cocaine-cyan)
               (font-lock-doc-face :foreground ,cocaine-comment)
               (font-lock-function-name-face :foreground ,cocaine-green :weight bold)
               (font-lock-keyword-face :weight bold :foreground ,cocaine-pink)
               (font-lock-negation-char-face :foreground ,cocaine-cyan)
               (font-lock-preprocessor-face :foreground ,cocaine-orange)
               (font-lock-reference-face :foreground ,cocaine-cyan)
               (font-lock-regexp-grouping-backslash :foreground ,cocaine-cyan)
               (font-lock-regexp-grouping-construct :foreground ,cocaine-purple)
               (font-lock-string-face :foreground ,cocaine-yellow)
               (font-lock-type-face :foreground ,cocaine-purple)
               (font-lock-variable-name-face :foreground ,cocaine-fg
                                             :weight bold)
               (font-lock-warning-face :foreground ,cocaine-orange :background ,bg2)
               ;; auto-complete
               (ac-completion-face :underline t :foreground ,cocaine-pink)
               ;; company
               (company-echo-common :foreground ,cocaine-bg :background ,cocaine-fg)
               (company-preview :background ,cocaine-bg :foreground ,other-blue)
               (company-preview-common :foreground ,bg2 :foreground ,fg3)
               (company-preview-search :foreground ,cocaine-purple :background ,cocaine-bg)
               (company-scrollbar-bg :background ,bg3)
               (company-scrollbar-fg :foreground ,cocaine-pink)
               (company-template-field :inherit match)
               (company-tooltip :foreground ,fg2 :background ,cocaine-bg :weight bold)
               (company-tooltip-annotation :foreground ,cocaine-cyan)
               (company-tooltip-common :foreground ,fg3)
               (company-tooltip-common-selection :foreground ,cocaine-yellow)
               (company-tooltip-mouse :inherit highlight)
               (company-tooltip-selection :background ,bg3 :foreground ,fg3)
               ;; diff-hl
               (diff-hl-change :foreground ,cocaine-orange :background ,cocaine-orange)
               (diff-hl-delete :foreground ,cocaine-red :background ,cocaine-red)
               (diff-hl-insert :foreground ,cocaine-green :background ,cocaine-green)
               ;; dired
               (dired-directory :foreground ,cocaine-green :weight normal)
               (dired-flagged :foreground ,cocaine-pink)
               (dired-header :foreground ,fg3 :background ,cocaine-bg)
               (dired-ignored :inherit shadow)
               (dired-mark :foreground ,cocaine-fg :weight bold)
               (dired-marked :foreground ,cocaine-orange :weight bold)
               (dired-perm-write :foreground ,fg3 :underline t)
               (dired-symlink :foreground ,cocaine-yellow :weight normal :slant italic)
               (dired-warning :foreground ,cocaine-orange :underline t)
               (diredp-compressed-file-name :foreground ,fg3)
               (diredp-compressed-file-suffix :foreground ,fg4)
               (diredp-date-time :foreground ,cocaine-fg)
               (diredp-deletion-file-name :foreground ,cocaine-pink :background ,cocaine-current)
               (diredp-deletion :foreground ,cocaine-pink :weight bold)
               (diredp-dir-heading :foreground ,fg2 :background ,bg4)
               (diredp-dir-name :inherit dired-directory)
               (diredp-dir-priv :inherit dired-directory)
               (diredp-executable-tag :foreground ,cocaine-orange)
               (diredp-file-name :foreground ,cocaine-fg)
               (diredp-file-suffix :foreground ,fg4)
               (diredp-flag-mark-line :foreground ,fg2 :slant italic :background ,cocaine-current)
               (diredp-flag-mark :foreground ,fg2 :weight bold :background ,cocaine-current)
               (diredp-ignored-file-name :foreground ,cocaine-fg)
               (diredp-mode-line-flagged :foreground ,cocaine-orange)
               (diredp-mode-line-marked :foreground ,cocaine-orange)
               (diredp-no-priv :foreground ,cocaine-fg)
               (diredp-number :foreground ,cocaine-cyan)
               (diredp-other-priv :foreground ,cocaine-orange)
               (diredp-rare-priv :foreground ,cocaine-orange)
               (diredp-read-priv :foreground ,cocaine-purple)
               (diredp-write-priv :foreground ,cocaine-pink)
               (diredp-exec-priv :foreground ,cocaine-yellow)
               (diredp-symlink :foreground ,cocaine-orange)
               (diredp-link-priv :foreground ,cocaine-orange)
               (diredp-autofile-name :foreground ,cocaine-yellow)
               (diredp-tagged-autofile-name :foreground ,cocaine-yellow)
               ;; enh-ruby
               (enh-ruby-heredoc-delimiter-face :foreground ,cocaine-yellow)
               (enh-ruby-op-face :foreground ,cocaine-pink)
               (enh-ruby-regexp-delimiter-face :foreground ,cocaine-yellow)
               (enh-ruby-string-delimiter-face :foreground ,cocaine-yellow)
               ;; flyspell
               (flyspell-duplicate :underline (:style wave :color ,cocaine-orange))
               (flyspell-incorrect :underline (:style wave :color ,cocaine-red))
               ;; font-latex
               (font-latex-bold-face :foreground ,cocaine-purple)
               (font-latex-italic-face :foreground ,cocaine-pink :slant italic)
               (font-latex-match-reference-keywords :foreground ,cocaine-cyan)
               (font-latex-match-variable-keywords :foreground ,cocaine-fg)
               (font-latex-string-face :foreground ,cocaine-yellow)
               ;; gnus-group
               (gnus-group-mail-1 :foreground ,cocaine-pink :weight bold)
               (gnus-group-mail-1-empty :inherit gnus-group-mail-1 :weight normal)
               (gnus-group-mail-2 :foreground ,cocaine-cyan :weight bold)
               (gnus-group-mail-2-empty :inherit gnus-group-mail-2 :weight normal)
               (gnus-group-mail-3 :foreground ,cocaine-comment :weight bold)
               (gnus-group-mail-3-empty :inherit gnus-group-mail-3 :weight normal)
               (gnus-group-mail-low :foreground ,cocaine-current :weight bold)
               (gnus-group-mail-low-empty :inherit gnus-group-mail-low :weight normal)
               (gnus-group-news-1 :foreground ,cocaine-pink :weight bold)
               (gnus-group-news-1-empty :inherit gnus-group-news-1 :weight normal)
               (gnus-group-news-2 :foreground ,cocaine-cyan :weight bold)
               (gnus-group-news-2-empty :inherit gnus-group-news-2 :weight normal)
               (gnus-group-news-3 :foreground ,cocaine-comment :weight bold)
               (gnus-group-news-3-empty :inherit gnus-group-news-3 :weight normal)
               (gnus-group-news-4 :inherit gnus-group-news-low)
               (gnus-group-news-4-empty :inherit gnus-group-news-low-empty)
               (gnus-group-news-5 :inherit gnus-group-news-low)
               (gnus-group-news-5-empty :inherit gnus-group-news-low-empty)
               (gnus-group-news-6 :inherit gnus-group-news-low)
               (gnus-group-news-6-empty :inherit gnus-group-news-low-empty)
               (gnus-group-news-low :foreground ,cocaine-current :weight bold)
               (gnus-group-news-low-empty :inherit gnus-group-news-low :weight normal)
               (gnus-header-content :foreground ,cocaine-pink)
               (gnus-header-from :foreground ,cocaine-fg)
               (gnus-header-name :foreground ,cocaine-purple)
               (gnus-header-subject :foreground ,cocaine-green :weight bold)
               (gnus-summary-markup-face :foreground ,cocaine-cyan)
               (gnus-summary-high-unread :foreground ,cocaine-pink :weight bold)
               (gnus-summary-high-read :inherit gnus-summary-high-unread :weight normal)
               (gnus-summary-high-ancient :inherit gnus-summary-high-read)
               (gnus-summary-high-ticked :inherit gnus-summary-high-read :underline t)
               (gnus-summary-normal-unread :foreground ,other-blue :weight bold)
               (gnus-summary-normal-read :foreground ,cocaine-comment :weight normal)
               (gnus-summary-normal-ancient :inherit gnus-summary-normal-read :weight light)
               (gnus-summary-normal-ticked :foreground ,cocaine-pink :weight bold)
               (gnus-summary-low-unread :foreground ,cocaine-comment :weight bold)
               (gnus-summary-low-read :inherit gnus-summary-low-unread :weight normal)
               (gnus-summary-low-ancient :inherit gnus-summary-low-read)
               (gnus-summary-low-ticked :inherit gnus-summary-low-read :underline t)
               (gnus-summary-selected :inverse-video t)
               ;; haskell-mode
               (haskell-operator-face :foreground ,cocaine-pink)
               (haskell-constructor-face :foreground ,cocaine-purple)
               ;; helm
               (helm-bookmark-w3m :foreground ,cocaine-purple)
               (helm-buffer-not-saved :foreground ,cocaine-purple :background ,cocaine-bg)
               (helm-buffer-process :foreground ,cocaine-orange :background ,cocaine-bg)
               (helm-buffer-saved-out :foreground ,cocaine-fg :background ,cocaine-bg)
               (helm-buffer-size :foreground ,cocaine-fg :background ,cocaine-bg)
               (helm-candidate-number :foreground ,cocaine-bg :background ,cocaine-fg)
               (helm-ff-directory :foreground ,cocaine-green :background ,cocaine-bg :weight bold)
               (helm-ff-dotted-directory :foreground ,cocaine-green :background ,cocaine-bg :weight normal)
               (helm-ff-executable :foreground ,other-blue :background ,cocaine-bg :weight normal)
               (helm-ff-file :foreground ,cocaine-fg :background ,cocaine-bg :weight normal)
               (helm-ff-invalid-symlink :foreground ,cocaine-pink :background ,cocaine-bg :weight bold)
               (helm-ff-prefix :foreground ,cocaine-bg :background ,cocaine-pink :weight normal)
               (helm-ff-symlink :foreground ,cocaine-pink :background ,cocaine-bg :weight bold)
               (helm-grep-cmd-line :foreground ,cocaine-fg :background ,cocaine-bg)
               (helm-grep-file :foreground ,cocaine-fg :background ,cocaine-bg)
               (helm-grep-finish :foreground ,fg2 :background ,cocaine-bg)
               (helm-grep-lineno :foreground ,cocaine-fg :background ,cocaine-bg)
               (helm-grep-match :foreground "unspecified-fg" :background "unspecified-bg" :inherit helm-match)
               (helm-grep-running :foreground ,cocaine-green :background ,cocaine-bg)
               (helm-header :foreground ,fg2 :background ,cocaine-bg :underline nil :box nil)
               (helm-moccur-buffer :foreground ,cocaine-green :background ,cocaine-bg)
               (helm-selection :background ,bg2 :underline nil)
               (helm-selection-line :background ,bg2)
               (helm-separator :foreground ,cocaine-purple :background ,cocaine-bg)
               (helm-source-go-package-godoc-description :foreground ,cocaine-yellow)
               (helm-source-header :foreground ,cocaine-pink :background ,cocaine-bg :underline nil :weight bold)
               (helm-time-zone-current :foreground ,cocaine-orange :background ,cocaine-bg)
               (helm-time-zone-home :foreground ,cocaine-purple :background ,cocaine-bg)
               (helm-visible-mark :foreground ,cocaine-bg :background ,bg3)
               ;; highlight-indentation minor mode
               (highlight-indentation-face :background ,bg2)
               ;; icicle
               (icicle-whitespace-highlight :background ,cocaine-fg)
               (icicle-special-candidate :foreground ,fg2)
               (icicle-extra-candidate :foreground ,fg2)
               (icicle-search-main-regexp-others :foreground ,cocaine-fg)
               (icicle-search-current-input :foreground ,cocaine-pink)
               (icicle-search-context-level-8 :foreground ,cocaine-orange)
               (icicle-search-context-level-7 :foreground ,cocaine-orange)
               (icicle-search-context-level-6 :foreground ,cocaine-orange)
               (icicle-search-context-level-5 :foreground ,cocaine-orange)
               (icicle-search-context-level-4 :foreground ,cocaine-orange)
               (icicle-search-context-level-3 :foreground ,cocaine-orange)
               (icicle-search-context-level-2 :foreground ,cocaine-orange)
               (icicle-search-context-level-1 :foreground ,cocaine-orange)
               (icicle-search-main-regexp-current :foreground ,cocaine-fg)
               (icicle-saved-candidate :foreground ,cocaine-fg)
               (icicle-proxy-candidate :foreground ,cocaine-fg)
               (icicle-mustmatch-completion :foreground ,cocaine-purple)
               (icicle-multi-command-completion :foreground ,fg2 :background ,bg2)
               (icicle-msg-emphasis :foreground ,cocaine-green)
               (icicle-mode-line-help :foreground ,fg4)
               (icicle-match-highlight-minibuffer :foreground ,cocaine-orange)
               (icicle-match-highlight-Completions :foreground ,cocaine-green)
               (icicle-key-complete-menu-local :foreground ,cocaine-fg)
               (icicle-key-complete-menu :foreground ,cocaine-fg)
               (icicle-input-completion-fail-lax :foreground ,cocaine-pink)
               (icicle-input-completion-fail :foreground ,cocaine-pink)
               (icicle-historical-candidate-other :foreground ,cocaine-fg)
               (icicle-historical-candidate :foreground ,cocaine-fg)
               (icicle-current-candidate-highlight :foreground ,cocaine-orange :background ,bg3)
               (icicle-Completions-instruction-2 :foreground ,fg4)
               (icicle-Completions-instruction-1 :foreground ,fg4)
               (icicle-completion :foreground ,cocaine-fg)
               (icicle-complete-input :foreground ,cocaine-orange)
               (icicle-common-match-highlight-Completions :foreground ,cocaine-purple)
               (icicle-candidate-part :foreground ,cocaine-fg)
               (icicle-annotation :foreground ,fg4)
               ;; icomplete
               (icompletep-determined :foreground ,cocaine-orange)
               ;; ido
               (ido-first-match
                ,@(if cocaine-alternate-mode-line-and-minibuffer
                      (list :weight 'normal :foreground cocaine-green)
                    (list :weight 'bold :foreground cocaine-pink)))
               (ido-only-match :foreground ,cocaine-orange)
               (ido-subdir :foreground ,cocaine-yellow)
               (ido-virtual :foreground ,cocaine-cyan)
               (ido-incomplete-regexp :inherit font-lock-warning-face)
               (ido-indicator :foreground ,cocaine-fg :background ,cocaine-pink)
               ;; isearch
               (isearch :inherit match :weight bold)
               (isearch-fail :foreground ,cocaine-bg :background ,cocaine-orange)
               ;; jde-java
               (jde-java-font-lock-constant-face :foreground ,cocaine-cyan)
               (jde-java-font-lock-modifier-face :foreground ,cocaine-pink)
               (jde-java-font-lock-number-face :foreground ,cocaine-fg)
               (jde-java-font-lock-package-face :foreground ,cocaine-fg)
               (jde-java-font-lock-private-face :foreground ,cocaine-pink)
               (jde-java-font-lock-public-face :foreground ,cocaine-pink)
               ;; js2-mode
               (js2-external-variable :foreground ,cocaine-purple)
               (js2-function-param :foreground ,cocaine-cyan)
               (js2-jsdoc-html-tag-delimiter :foreground ,cocaine-yellow)
               (js2-jsdoc-html-tag-name :foreground ,other-blue)
               (js2-jsdoc-value :foreground ,cocaine-yellow)
               (js2-private-function-call :foreground ,cocaine-cyan)
               (js2-private-member :foreground ,fg3)
               ;; js3-mode
               (js3-error-face :underline ,cocaine-orange)
               (js3-external-variable-face :foreground ,cocaine-fg)
               (js3-function-param-face :foreground ,cocaine-pink)
               (js3-instance-member-face :foreground ,cocaine-cyan)
               (js3-jsdoc-tag-face :foreground ,cocaine-pink)
               (js3-warning-face :underline ,cocaine-pink)
               ;; magit
               (magit-branch-local :foreground ,cocaine-cyan)
               (magit-branch-remote :foreground ,cocaine-green)
               (magit-tag :foreground ,cocaine-orange)
               (magit-section-heading :foreground ,cocaine-pink :weight bold)
               (magit-section-highlight :background ,bg3 :extend t)
               (magit-diff-context-highlight :background ,bg3
                                             :foreground ,fg3
                                             :extend t)
               (magit-diff-revision-summary :foreground ,cocaine-orange
                                            :background ,cocaine-bg
                                            :weight bold)
               (magit-diff-revision-summary-highlight :foreground ,cocaine-orange
                                                      :background ,bg3
                                                      :weight bold
                                                      :extend t)
               ;; the four following lines are just a patch of the
               ;; upstream color to add the extend keyword.
               (magit-diff-added :background "#335533"
                                 :foreground "#ddffdd"
                                 :extend t)
               (magit-diff-added-highlight :background "#336633"
                                           :foreground "#cceecc"
                                           :extend t)
               (magit-diff-removed :background "#553333"
                                   :foreground "#ffdddd"
                                   :extend t)
               (magit-diff-removed-highlight :background "#663333"
                                             :foreground "#eecccc"
                                             :extend t)
               (magit-diff-file-heading :foreground ,cocaine-fg)
               (magit-diff-file-heading-highlight :inherit magit-section-highlight)
               (magit-diffstat-added :foreground ,cocaine-green)
               (magit-diffstat-removed :foreground ,cocaine-red)
               (magit-hash :foreground ,fg2)
               (magit-hunk-heading :background ,bg3)
               (magit-hunk-heading-highlight :background ,bg3)
               (magit-item-highlight :background ,bg3)
               (magit-log-author :foreground ,fg3)
               (magit-process-ng :foreground ,cocaine-orange :weight bold)
               (magit-process-ok :foreground ,cocaine-green :weight bold)
               ;; markdown
               (markdown-blockquote-face :foreground ,cocaine-orange)
               (markdown-code-face :foreground ,cocaine-orange)
               (markdown-footnote-face :foreground ,other-blue)
               (markdown-header-face :weight normal)
               (markdown-header-face-1
                :inherit bold :foreground ,cocaine-pink
                ,@(when cocaine-enlarge-headings
                    (list :height cocaine-height-title-1)))
               (markdown-header-face-2
                :inherit bold :foreground ,cocaine-purple
                ,@(when cocaine-enlarge-headings
                    (list :height cocaine-height-title-2)))
               (markdown-header-face-3
                :foreground ,cocaine-green
                ,@(when cocaine-enlarge-headings
                    (list :height cocaine-height-title-3)))
               (markdown-header-face-4 :foreground ,cocaine-yellow)
               (markdown-header-face-5 :foreground ,cocaine-cyan)
               (markdown-header-face-6 :foreground ,cocaine-orange)
               (markdown-header-face-7 :foreground ,other-blue)
               (markdown-header-face-8 :foreground ,cocaine-fg)
               (markdown-inline-code-face :foreground ,cocaine-yellow)
               (markdown-plain-url-face :inherit link)
               (markdown-pre-face :foreground ,cocaine-orange)
               (markdown-table-face :foreground ,cocaine-purple)
               ;; message
               (message-mml :foreground ,cocaine-green :weight normal)
               (message-header-xheader :foreground ,cocaine-cyan :weight normal)
               ;; mode-line
               (mode-line :background ,cocaine-current
                          :box ,cocaine-current :inverse-video nil
                          ,@(if cocaine-alternate-mode-line-and-minibuffer
                                (list :foreground fg3)
                              (list :foreground "unspecified-fg")))
               (mode-line-inactive
                :inverse-video nil
                ,@(if cocaine-alternate-mode-line-and-minibuffer
                      (list :foreground cocaine-comment :background cocaine-bg
                            :box cocaine-bg)
                    (list :foreground cocaine-fg :background bg2 :box bg2)))
               ;; mu4e
               (mu4e-unread-face :foreground ,cocaine-pink :weight normal)
               (mu4e-view-url-number-face :foreground ,cocaine-purple)
               (mu4e-highlight-face :background ,cocaine-bg
                                    :foreground ,cocaine-yellow
                                    :extend t)
               (mu4e-header-highlight-face :background ,cocaine-current
                                           :foreground ,cocaine-fg
                                           :underline nil :weight bold
                                           :extend t)
               (mu4e-header-key-face :inherit message-mml)
               (mu4e-header-marks-face :foreground ,cocaine-purple)
               (mu4e-cited-1-face :foreground ,cocaine-purple)
               (mu4e-cited-2-face :foreground ,cocaine-orange)
               (mu4e-cited-3-face :foreground ,cocaine-comment)
               (mu4e-cited-4-face :foreground ,fg2)
               (mu4e-cited-5-face :foreground ,fg3)
               ;; org
               (org-agenda-date :foreground ,cocaine-cyan :underline nil)
               (org-agenda-dimmed-todo-face :foreground ,cocaine-comment)
               (org-agenda-done :foreground ,cocaine-green)
               (org-agenda-structure :foreground ,cocaine-purple)
               (org-block :foreground ,cocaine-orange)
               (org-code :foreground ,cocaine-yellow)
               (org-column :background ,bg4)
               (org-column-title :inherit org-column :weight bold :underline t)
               (org-date :foreground ,cocaine-cyan :underline t)
               (org-document-info :foreground ,other-blue)
               (org-document-info-keyword :foreground ,cocaine-comment)
               (org-document-title :weight bold :foreground ,cocaine-orange
                                   ,@(when cocaine-enlarge-headings
                                       (list :height cocaine-height-doc-title)))
               (org-done :foreground ,cocaine-green)
               (org-ellipsis :foreground ,cocaine-comment)
               (org-footnote :foreground ,other-blue)
               (org-formula :foreground ,cocaine-pink)
               (org-headline-done :foreground ,cocaine-comment
                                  :weight normal :strike-through t)
               (org-hide :foreground ,cocaine-bg :background ,cocaine-bg)
               (org-level-1 :inherit bold :foreground ,cocaine-pink
                            ,@(when cocaine-enlarge-headings
                                (list :height cocaine-height-title-1)))
               (org-level-2 :inherit bold :foreground ,cocaine-purple
                            ,@(when cocaine-enlarge-headings
                                (list :height cocaine-height-title-2)))
               (org-level-3 :weight normal :foreground ,cocaine-green
                            ,@(when cocaine-enlarge-headings
                                (list :height cocaine-height-title-3)))
               (org-level-4 :weight normal :foreground ,cocaine-yellow)
               (org-level-5 :weight normal :foreground ,cocaine-cyan)
               (org-level-6 :weight normal :foreground ,cocaine-orange)
               (org-level-7 :weight normal :foreground ,other-blue)
               (org-level-8 :weight normal :foreground ,cocaine-fg)
               (org-link :foreground ,cocaine-cyan :underline t)
               (org-priority :foreground ,cocaine-cyan)
               (org-scheduled :foreground ,cocaine-green)
               (org-scheduled-previously :foreground ,cocaine-yellow)
               (org-scheduled-today :foreground ,cocaine-green)
               (org-sexp-date :foreground ,fg4)
               (org-special-keyword :foreground ,cocaine-yellow)
               (org-table :foreground ,cocaine-purple)
               (org-tag :foreground ,cocaine-pink :weight bold :background ,bg2)
               (org-todo :foreground ,cocaine-orange :weight bold :background ,bg2)
               (org-upcoming-deadline :foreground ,cocaine-yellow)
               (org-warning :weight bold :foreground ,cocaine-pink)
               ;; outline
               (outline-1 :foreground ,cocaine-pink)
               (outline-2 :foreground ,cocaine-purple)
               (outline-3 :foreground ,cocaine-green)
               (outline-4 :foreground ,cocaine-yellow)
               (outline-5 :foreground ,cocaine-cyan)
               (outline-6 :foreground ,cocaine-orange)
               ;; powerline
               (powerline-evil-base-face :foreground ,bg2)
               (powerline-evil-emacs-face :inherit powerline-evil-base-face :background ,cocaine-yellow)
               (powerline-evil-insert-face :inherit powerline-evil-base-face :background ,cocaine-cyan)
               (powerline-evil-motion-face :inherit powerline-evil-base-face :background ,cocaine-purple)
               (powerline-evil-normal-face :inherit powerline-evil-base-face :background ,cocaine-green)
               (powerline-evil-operator-face :inherit powerline-evil-base-face :background ,cocaine-pink)
               (powerline-evil-replace-face :inherit powerline-evil-base-face :background ,cocaine-red)
               (powerline-evil-visual-face :inherit powerline-evil-base-face :background ,cocaine-orange)
               ;; rainbow-delimiters
               (rainbow-delimiters-depth-1-face :foreground ,cocaine-fg)
               (rainbow-delimiters-depth-2-face :foreground ,cocaine-cyan)
               (rainbow-delimiters-depth-3-face :foreground ,cocaine-purple)
               (rainbow-delimiters-depth-4-face :foreground ,cocaine-pink)
               (rainbow-delimiters-depth-5-face :foreground ,cocaine-orange)
               (rainbow-delimiters-depth-6-face :foreground ,cocaine-green)
               (rainbow-delimiters-depth-7-face :foreground ,cocaine-yellow)
               (rainbow-delimiters-depth-8-face :foreground ,other-blue)
               (rainbow-delimiters-unmatched-face :foreground ,cocaine-orange)
               ;; rpm-spec
               (rpm-spec-dir-face :foreground ,cocaine-green)
               (rpm-spec-doc-face :foreground ,cocaine-pink)
               (rpm-spec-ghost-face :foreground ,cocaine-purple)
               (rpm-spec-macro-face :foreground ,cocaine-yellow)
               (rpm-spec-obsolete-tag-face :inherit font-lock-warning-face)
               (rpm-spec-package-face :foreground ,cocaine-purple)
               (rpm-spec-section-face :foreground ,cocaine-yellow)
               (rpm-spec-tag-face :foreground ,cocaine-cyan)
               (rpm-spec-var-face :foreground ,cocaine-orange)
               ;; show-paren
               (show-paren-match-face :background unspecified
                                      :foreground ,cocaine-cyan
                                      :weight bold)
               (show-paren-match :background unspecified
                                 :foreground ,cocaine-cyan
                                 :weight bold)
               (show-paren-match-expression :inherit match)
               (show-paren-mismatch :inherit font-lock-warning-face)
               ;; slime
               (slime-repl-inputed-output-face :foreground ,cocaine-purple)
               ;; spam
               (spam :inherit gnus-summary-normal-read :foreground ,cocaine-orange
                     :strike-through t :slant oblique)
               ;; tab-bar & tab-line (since Emacs 27.1)
               (tab-bar :foreground ,cocaine-purple :background ,cocaine-current
                        :inherit variable-pitch)
               (tab-bar-tab :foreground ,cocaine-pink :background ,cocaine-bg
                            :box (:line-width 2 :color ,cocaine-bg :style nil))
               (tab-bar-tab-inactive :foreground ,cocaine-purple :background ,bg2
                                     :box (:line-width 2 :color ,bg2 :style nil))
               (tab-line :foreground ,cocaine-purple :background ,cocaine-current
                         :height 0.9 :inherit variable-pitch)
               (tab-line-tab :foreground ,cocaine-pink :background ,cocaine-bg
                             :box (:line-width 2 :color ,cocaine-bg :style nil))
               (tab-line-tab-inactive :foreground ,cocaine-purple :background ,bg2
                                      :box (:line-width 2 :color ,bg2 :style nil))
               (tab-line-tab-current :inherit tab-line-tab)
               (tab-line-close-highlight :foreground ,cocaine-red)
               ;; term
               (term :foreground ,cocaine-fg :background ,cocaine-bg)
               (term-color-black :foreground ,cocaine-bg :background ,cocaine-bg)
               (term-color-blue :foreground ,cocaine-purple :background ,cocaine-purple)
               (term-color-cyan :foreground ,cocaine-cyan :background ,cocaine-cyan)
               (term-color-green :foreground ,cocaine-green :background ,cocaine-green)
               (term-color-magenta :foreground ,cocaine-pink :background ,cocaine-pink)
               (term-color-red :foreground ,cocaine-red :background ,cocaine-red)
               (term-color-white :foreground ,cocaine-fg :background ,cocaine-fg)
               (term-color-yellow :foreground ,cocaine-yellow :background ,cocaine-yellow)
               ;; undo-tree
               (undo-tree-visualizer-current-face :foreground ,cocaine-orange)
               (undo-tree-visualizer-default-face :foreground ,fg2)
               (undo-tree-visualizer-register-face :foreground ,cocaine-purple)
               (undo-tree-visualizer-unmodified-face :foreground ,cocaine-fg)
               ;; web-mode
               (web-mode-builtin-face :inherit ,font-lock-builtin-face)
               (web-mode-comment-face :inherit ,font-lock-comment-face)
               (web-mode-constant-face :inherit ,font-lock-constant-face)
               (web-mode-doctype-face :inherit ,font-lock-comment-face)
               (web-mode-function-name-face :inherit ,font-lock-function-name-face)
               (web-mode-html-attr-name-face :foreground ,cocaine-purple)
               (web-mode-html-attr-value-face :foreground ,cocaine-green)
               (web-mode-html-tag-face :foreground ,cocaine-pink :weight bold)
               (web-mode-keyword-face :foreground ,cocaine-pink)
               (web-mode-string-face :foreground ,cocaine-yellow)
               (web-mode-type-face :inherit ,font-lock-type-face)
               (web-mode-warning-face :inherit ,font-lock-warning-face)
               ;; which-func
               (which-func :inherit ,font-lock-function-name-face)
               ;; whitespace
               (whitespace-big-indent :background ,cocaine-red :foreground ,cocaine-red)
               (whitespace-empty :background ,cocaine-orange :foreground ,cocaine-red)
               (whitespace-hspace :background ,bg3 :foreground ,cocaine-comment)
               (whitespace-indentation :background ,cocaine-orange :foreground ,cocaine-red)
               (whitespace-line :background ,cocaine-bg :foreground ,cocaine-pink)
               (whitespace-newline :foreground ,cocaine-comment)
               (whitespace-space :background ,cocaine-bg :foreground ,cocaine-comment)
               (whitespace-space-after-tab :background ,cocaine-orange :foreground ,cocaine-red)
               (whitespace-space-before-tab :background ,cocaine-orange :foreground ,cocaine-red)
               (whitespace-tab :background ,bg2 :foreground ,cocaine-comment)
               (whitespace-trailing :inherit trailing-whitespace)
               ;; yard-mode
               (yard-tag-face :inherit ,font-lock-builtin-face)
               (yard-directive-face :inherit ,font-lock-builtin-face))))

  (apply #'custom-theme-set-faces
         'cocaine
         (let ((color-names (mapcar #'car colors))
               (graphic-colors (mapcar #'cadr colors))
               (term-colors (mapcar #'car (mapcar #'cddr colors)))
               (tty-colors (mapcar #'car (mapcar #'last colors)))
               (expand-for-kind
                (lambda (kind spec)
                  (when (and (string= (symbol-name kind) "term-colors")
                             cocaine-use-24-bit-colors-on-256-colors-terms)
                    (setq kind 'graphic-colors))
                  (cl-progv color-names (symbol-value kind)
                    (eval `(backquote ,spec))))))
           (cl-loop for (face . spec) in faces
                    collect `(,face
                              ((((min-colors 16777216)) ; fully graphical envs
                                ,(funcall expand-for-kind 'graphic-colors spec))
                               (((min-colors 256))      ; terminal withs 256 colors
                                ,(funcall expand-for-kind 'term-colors spec))
                               (t                       ; should be only tty-like envs
                                ,(funcall expand-for-kind 'tty-colors spec))))))))


;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'cocaine)

;; Local Variables:
;; no-byte-compile: t
;; indent-tabs-mode: nil
;; End:

;;; cocaine-theme.el ends here
