;;; emacs-upload.el --- Upload regions, buffers, and files to various hosts. -*- lexical-binding: t; -*-

;;; emacs-upload - Upload the region, buffer, or file to various hosts
;;; Copyright (C) <2019,2020> <zdm@cock.li>

;;; This program is free software: you can redistribute it and/or
;;; modify it under the terms of the GNU Affero General Public License
;;; v3.0 as published by the Free Software Foundation.

;;; This program is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
;;; Affero General Public License for more details.

;;; You should have received a copy of the GNU Affero General Public License
;;; along with this program. If not, see <https://www.gnu.org/licenses/>.

;;; Dependencies: cURL, cl, json

;;; _Usage_
;;; 
;;; Place emacs-upload.el in your `load-path' and load the package:
;;; 
;;;      (require 'emacs-upload)
;;; 
;;; Bind the interactive function `emacs-upload' to some key:
;;;
;;;     (global-set-key (kbd "C-c e") 'emacs-upload)
;;; 
;;; Alternatively, with `use-package' you can easily bind and set a default host.
;;;
;;;     (use-package emacs-upload 
;;;     :demand t
;;;     :bind                   
;;;     ("C-c e" . emacs-upload)
;;;     :config
;;;     (emacs-upload/set-host "ix"))

;;; `emacs-upload/set-host' is also an interactive command, so you can
;;; change your host on the fly.

;;; To upload the region, simply select the region and call emacs-upload. To
;;; upload the whole buffer, have no region selected and call emacs-upload. For
;;; a file, use the universal argument `C-u' before calling emacs-upload.

(require 'cl)
(require 'json)

(defcustom emacs-upload/host '("https://c-v.sh" "file=@%s")
  "Current host to upload to.")

(defcustom emacs-upload/hosts '(("w1r3" . ("https://w1r3.net"  "upload=@%s"))
				("ix" . ("http://ix.io"      "f:1=@%s"))
				("0x0" . ("https://0x0.st"    "file=@%s"))
				("c-v" . ("https://c-v.sh"    "file=@%s"))
				("sprunge" . ("http://sprunge.us" "sprunge=@%s"))
				("youdieifyou.work" . ("http://youdieifyou.work/upload.php" "files[]=@%s"))
				("catbox" . ("https://catbox.moe/user/api.php" "reqtype=fileupload" "fileToUpload=@%s"))
				("fiery" . ("https://safe.fiery.me/api/upload" "files[]=@%s"))
				("dmca.gripe" . ("https://dmca.gripe/api/upload" "files[]=@%s")))
  "List of hosts you can set emacs-upload/host to.")

(defun emacs-upload/buffer-list ()
  "Return a list consisting of the minimum and maximum point values."
  (list (point-min) (point-max)))

(defun emacs-upload/region-list ()
  "Return a list consisting of the beginning and end of the active region."
  (list (region-beginning) (region-end)))

(defun emacs-upload/make-temp-file (file-name)
  "Return a string of a temporarily created file with the suffix
either being the filename's extension, if it exists, or `.txt'
for buffers not associated with a file."
  (make-temp-file "emacs-upload" nil (if file-name (file-name-extension file-name t)
				       ".txt")))

(defun emacs-upload/write-content-to-file (content file)
  "Write content to file, content being a list of the beginning
and ending points."
  (apply 'write-region (append content (list file))))

(defun emacs-upload/list-curl-forms (file)
  "Generate a list of curl forms"
  (if (cddr emacs-upload/host)
      (let* ((forms (mapcan (lambda (form) (list "-F" form)) (rest emacs-upload/host)))
	     (file-form  (car (last forms))))
	(append (butlast forms)
		(list (format file-form file) (first emacs-upload/host))))
    (list "-F" (format (second emacs-upload/host) file) (first emacs-upload/host))))

(defun emacs-upload/start-curl-process (file)
  "Start curl process"
  (apply 'start-process "emacs-upload" nil "curl" (emacs-upload/list-curl-forms file)))

(defun emacs-upload/pomf-parse (json)
  "Parse json and return a URL string or nil if an error occurred"
  (let* ((pretty-json (json-read-from-string json))
	 (success (equal (cdr (assoc 'success pretty-json)) t)))
    (if success (cdr (assoc 'url (aref (cdr (cadr pretty-json)) 0)))
      (let ((inhibit-message t))
	(mapc (lambda (desc)
		(message "%s: %s" (car desc) (cdr desc)))
	      pretty-json)
	nil))))

(defun emacs-upload/filter (process output)
  "Determine whether or not the output is json, either parsing
the json or simply stripping the newlines from output and killing
that."
  (if (string-match "{" output)
      (let ((result (emacs-upload/pomf-parse output)))
	(if result (message "File uploaded at %s and saved to your kill-ring."
			    (kill-new result))
	  (message "Error while uploading file. See *Messages* buffer for more information.")))
    (if (string-match "http" output)
	(message "File uploaded at %s and saved to your kill ring."
		 (kill-new (replace-regexp-in-string "\n$" "" output)))
      (progn
	(let ((inhibit-message t))
	  (message output)
	  nil)
	(message "Error while uploading file. See *Messages* buffer for more information")))))

;;;###autoload
(defun emacs-upload/set-host (host)
  "Set host. Call this interactively or as function from your
init to set a default from the list of available hosts, such
as: (emacs-upload/set-host \"ix\")"
  (interactive
   (list (completing-read "Set the host: " (mapcar 'first emacs-upload/hosts)
			  nil t)))
  (setq emacs-upload/host (cdr (assoc host emacs-upload/hosts)))
  (message "emacs-upload/host is now set to %s" host))

;;;###autoload
(defun emacs-upload (&optional arg)
  "Upload the region if selected, the buffer if it is not, or if
called with ARG (C-u) select a file."
  (interactive "P")
  (if (executable-find "curl")
      (let ((file nil))
	(cond ((and (not arg) (region-active-p))
	       (setq file (emacs-upload/make-temp-file nil))
	       (emacs-upload/write-content-to-file (emacs-upload/region-list) file))
	      (arg (setq file (read-file-name "File to upload: ")))
	      (t (setq file (emacs-upload/make-temp-file nil))
		 (emacs-upload/write-content-to-file (emacs-upload/buffer-list) file)))
	(message "Uploading...")
	(set-process-filter (emacs-upload/start-curl-process file) 'emacs-upload/filter))
    (message "cURL not found")))

(provide 'emacs-upload)

;;; emacs-upload.el ends here
