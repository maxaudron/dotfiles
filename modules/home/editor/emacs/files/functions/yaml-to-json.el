;;; $DOOMDIR/functions/yaml-to-json.el -*- lexical-binding: t; -*-
;; Convert a section of yaml to json using yq
(defun yaml-to-json ()
  "Replace the selected yaml with it's json representation."
  (interactive)
  (shell-command-on-region
   (region-beginning) (region-end)
   "yq e -j -" nil 't)
  (json-reformat-region
   (region-beginning) (region-end)))
