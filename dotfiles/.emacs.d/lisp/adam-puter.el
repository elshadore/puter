;;; package --- Summary -*- lexical-binding: nil -*-
;;; Commentary:
;;; Code:

(defun adam/puter-linkup ()
  "Linked Up! Sneed it or Keep it?"
  (interactive)
  (start-process-shell-command "linkup!" nil "puter-linkup")
  (message "Linked Up! Sneed it or Keep it?"))

(defun adam/puter-xsettings ()
  "Apply XSettings."
  (interactive)
  (start-process-shell-command "xsettings" nil "puter-xsettings")
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

(require 'cl-lib)

(cl-defun adam/puter-notify (title &optional body &key urgency timeout icon app-name)
  "Send a desktop notification with TITLE and BODY.

Uses D-Bus (`notifications') when available, falls back to
`notify-send' with the same options.

Keyword options:
  :urgency   low, normal or critical (nil = daemon default)
  :timeout   expiry timeout in milliseconds (nil = daemon default)
  :icon      icon name or path (`:app-icon' for D-Bus, `-i' for notify-send)
  :app-name  app name shown by the notification daemon"
  (ignore-errors
    (require 'notifications nil t)
    (if (fboundp 'notifications-notify)
        (apply #'notifications-notify
               (append (list :title title :body (or body ""))
                       (when urgency (list :urgency urgency))
                       (when timeout (list :timeout timeout))
                       (when icon (list :app-icon icon))
                       (when app-name (list :app-name app-name))))
      (apply #'start-process "adam-puter-notify" nil "notify-send"
             (append (list title (or body ""))
                     (when urgency (list "-u" (symbol-name urgency)))
                     (when timeout (list "-t" (number-to-string timeout)))
                     (when icon (list "-i" icon))
                     (when app-name (list "-a" app-name)))))))

(provide 'adam-puter)
;;; adam-puter.el ends here
