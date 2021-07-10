;;; utils.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 Max Audron
;;
;; Author: Max Audron <https://github.com/audron>
;; Maintainer: Max Audron <max.manz@mxmanz.de>
;; Created: March 26, 2021
;; Modified: March 26, 2021
;; Version: 0.0.1
;; Keywords: Symbol’s value as variable is void: finder-known-keywords
;; Homepage: https://github.com/audron/utils
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

(defun reverse-region-horizontal (beg end)
 "Reverse characters between BEG and END."
 (interactive "r")
 (let ((region (buffer-substring beg end)))
   (delete-region beg end)
   (insert (nreverse region))))

(provide 'utils)
;;; utils.el ends here
