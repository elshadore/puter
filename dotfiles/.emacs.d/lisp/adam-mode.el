;;; package -- Summary
;;; Commentary:
;;; Code:

(require 'adam)
(require 'adam-window)

(defvar adam/auth-file "~/adam/root/auth.json")

(defvar adam/fuzzy-find-alist
  '((dired-mode . adam/find-file)
    (eshell-mode . adam/find-file)
    (ibuffer-mode . adam/switch-to-buffer)
    (t . adam/imenu)))

(defvar adam/fixup-list nil
  "Assocation list of projectile project types and functions to be run on `fixup'.")

(defun adam/lookup-auth (auth-sym)
  "Fetch a given auth string from the auth-file with a given symbol: AUTH-SYM."
  (cdr (assoc auth-sym (json-read-file adam/auth-file))))

(defun adam/fuzzy-find ()
  "Fuzzy find based on the contents of the current buffer."
  (interactive)
  (if-let ((a (assoc major-mode adam/fuzzy-find-alist)))
      (call-interactively (cdr a))
    (if-let ((b (assoc t adam/fuzzy-find-alist)))
        (call-interactively (cdr b))
      (error "no fallback value found"))))

(defun adam/add-fixup (project-type func)
  (push (cons project-type func) adam/fixup-list))

(defun adam/fixup ()
  (interactive)
  (if-let* ((proj-type (projectile-project-type))
            (fixup (assoc proj-type adam/fixup-list)))
      (progn
        (message "Fixup: %S" proj-type)
        (funcall (cdr fixup)))
    (message "No fixup available for project type: %S" proj-type)))

(define-minor-mode adam-mode
  "Adam global mode for Adam based sheringans!"
  1
  :global t
  :group 'adam
  :lighter " adam-mode"
  :keymap (let ((map (make-sparse-keymap))) map))

(provide 'adam-mode)
;;; adam-mode.el ends here
