;;; $DOOMDIR/functions/reverse-region-horizontal.el -*- lexical-binding: t; -*-

(defun reverse-region-horizontal (beg end)
 "Reverse characters between BEG and END."
 (interactive "r")
 (let ((region (buffer-substring beg end)))
   (delete-region beg end)
   (insert (nreverse region))))
