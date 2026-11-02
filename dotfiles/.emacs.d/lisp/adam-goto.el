;;; package --- Summary -*- lexical-binding: nil -*-
;;; Commentary:
;;; Code:

(defun adam/goto-init-file ()
  "Open init file."
  (interactive)
  (find-file user-init-file))

(defun adam/goto-homepage ()
  "Find main EMACS page."
  (interactive)
  (find-file "~/adam/HOMEPAGE.md"))

(defun adam/goto-todos ()
  "Find the misc todos page."
  (interactive)
  (find-file "~/adam/castle/todo.md"))

(defun adam/goto-castle ()
  "Find the castle directory."
  (interactive)
  (find-file "~/adam/castle/"))

(defun adam/goto-dailies ()
  "Find the dailies page."
  (interactive)
  (find-file "~/adam/castle/dailies.md"))

(defun adam/goto-philosophy ()
  "Find philosophy page."
  (interactive)
  (find-file "~/adam/castle/philosophy.md"))

(provide 'adam-goto)
;;; adam-goto.el ends here
