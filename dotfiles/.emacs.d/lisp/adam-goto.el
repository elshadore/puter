(defun adam/goto-init-file ()
  "Open init file."
  (interactive)
  (find-file user-init-file))

(defun adam/goto-homepage ()
  "Find main EMACS page."
  (interactive)
  (find-file "~/adam/HOMEPAGE.md"))

(defun adam/goto-current-project ()
  "Find the current project."
  (interactive)
  (find-file "~/adam/castle/current-project.md"))

(defun adam/goto-misc-todos ()
  "Find the misc todos page."
  (interactive)
  (find-file "~/adam/castle/misc.md"))

(defun adam/goto-castle ()
  "Find the misc todos page."
  (interactive)
  (find-file "~/adam/castle/"))

(defun adam/goto-philosophy ()
  "Find philosophy page."
  (interactive)
  (find-file "~/adam/castle/philsophy.md"))

(provide 'adam-goto)
