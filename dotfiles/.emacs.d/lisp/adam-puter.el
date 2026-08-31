(defun adam/puter-linkup ()
  "Linked Up! Sneed it or Keep it?"
  (interactive)
  (shell-command "puter-linkup")
  (message "Linked Up! Sneed it or Keep it?"))

(defun adam/puter-xsettings ()
  "Apply XSettings"
  (interactive)
  (shell-command "puter-xsettings")
  (message "XSettings Applied!"))

(defun adam/puter-spawn-app ()
  "Spawn a Linux App."
  (interactive)
  (call-interactively #'counsel-linux-app))

(defun adam/puter-is-wayland? ()
  "Is the current desktop a Wayland session?"
  (when (getenv "WAYLAND_DISPLAY") t))

(defun adam/puter-is-xwindows? ()
  "Is the current desktop a XWindows session?"
  (eq (window-system) 'x))

(provide 'adam-puter)
