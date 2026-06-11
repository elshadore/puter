(defun puter/quiet-kill-process (process)
  "Kill a Process PROCESS, but if it's already dead, ignore."
  (when (process-live-p process)
    (kill-process process)
    t))

(defvar puter/services (make-hash-table :test 'eq))

(defun puter/register-service (define-symbol shell-command)
  "The Function used by the PUTER/DEFSERVICE Macro."
  (assert! (symbolp define-symbol) "register-service DEFINE-SYMBOL is supposed to be of type SYMBOL.")
  (let ((restarted (when-let ((old (gethash define-symbol puter/services)))
                     (puter/quiet-kill-process old)
                     t))
        (proc (start-process-shell-command
               (concat "SERVICE: " (symbol-name define-symbol))
               nil
               shell-command)))
    (puthash define-symbol proc puter/services)
    (if restarted
        (message (concat "Service Restarted: " (symbol-name define-symbol)))
        (message (concat "Service Started: " (symbol-name define-symbol))))))

(defun puter/service-status (define-symbol)
  (assert! (symbolp define-symbol) "service-status DEFINE-SYMBOL is supposed to be of type SYMBOL.")
  (if-let ((a (gethash define-symbol puter/services)))
      (if a
          (process-status a)
        (quote not-started))
    (quote not-registered)))

(defmacro puter/defservice (define-symbol shell-command)
  "Define and Run a Managed Service by Emacs."
  (list 'puter/register-service (list 'quote define-symbol) shell-command))

;; (defun puter/xgfxtablet ()
;;   "Setup XGFXtablet."
;;   (interactive)
;;   (if (when-let ((a (adam/shell-command "xinput list --id-only \"UGTABLET 10 inch PenTablet stylus\"")))
;;         (adam/shell-command
;;          (format "xinput map-to-output %s HDMI-1"
;;                  (adam/strip-ending-newline a))))
;;       (message "XGFXTablet Set Up!")
;;       (message "XGFXTablet Setup Failed!")))

;; (defvar puter/xsettings-commands
;;   '("setxkbmap gb"
;;     "xset r rate 200 80"
;;     "xset s off -dpms"
;;     "xrandr --output HDMI-1 --primary --output HDMI-2 --right-of HDMI-1"))

;; (defun puter/xsettings ()
;;   "Apply XSettings."
;;   (interactive)
;;   (dolist (el puter/xsettings-commands)
;;     (shell-command el))
;;   (message "XSetting Applied!")
;;   (puter/xgfxtablet))

(defun puter/linkup ()
  "Linked Up! Sneed it or Keep it?"
  (interactive)
  (shell-command "puter-linkup")
  (message "Linked Up! Sneed it or Keep it?"))

(defun puter/xsettings ()
  "Apply XSettings"
  (interactive)
  (shell-command "puter-xsettings")
  (message "XSettings Applied!"))

(defun puter/spawn-app ()
  "Spawn a Linux App."
  (interactive)
  (call-interactively #'counsel-linux-app))

(defun puter/can-load-exwm? ()
  "Detects if Emacs is being used as a Desktop Window Manager or not."
  (and (display-graphic-p)
       (eq system-type 'gnu/linux)
       (getenv "ADAM_EXWM_ENABLE")))

(defun puter/notify-severity (severity)
  "Validate SEVERITY symbol and return the dunstify urgency string.
Must be :low, :normal, or :critical."
  (pcase severity
    (:low "low")
    (:normal "normal")
    (:critical "critical")
    (_ (error "Invalid severity: %s. Must be :low, :normal, or :critical"
              severity))))

(defun puter/notify-send (message &optional severity)
  "Send Notification to Desktop with optional SEVERITY (:low, :normal, :critical)."
  (let ((final (adam/stringify message)))
    (if severity
        (start-process "dunst-notify" nil "dunstify"
                       "-u" (puter/notify-severity severity) final)
      (start-process "dunst-notify" nil "dunstify" final))))

;;  TODO: this doesn't work in EXWM due to not having the correct shell ENV for xclip.
(defun puter/clipboard-command (command)
  "Run the Command COMMAND, Asynchronosly and Copy the Result the EMACS Clipboard."
  (start-process-shell-command command nil (concat command " | xclip -selection clipboard")))

(defun puter/colour-picker ()
  "Start XCOLOR as a colour picker."
  (interactive)
  (puter/clipboard-command "xcolor"))

(defun puter/copy-to-clipboard (string)
  "Push STRING to the kill ring and copy to clipboard."
  (interactive "sClip: ")
  (kill-new string))

(defun puter/screen-shot ()
  "Screen Shot using the SCROT Utility."
  (interactive)
  (start-process-shell-command "scrot" nil "scrot -s"))

(defun puter/emacsclient (command)
  "Use the EMACS SERVER to run the command COMMAND."
  (let ((fmt (format "%S" command)))
    (start-process-shell-command fmt nil (format "emacsclient -e %S" fmt)))
  t)

(defmacro puter/emacsclientq (command)
  "A Macro version of the puter/emacsclient function that QUOTES the COMMAND."
  (list 'puter/emacsclient (list 'quote command)))

(when (puter/can-load-exwm?)
  (use-package exwm
    :config

    (defun puter/exwm-update-class ()
      (exwm-workspace-rename-buffer exwm-class-name))

    (add-hook 'exwm-update-class-hook #'puter/exwm-update-class)

    (setq exwm-workspace-number 10)

    (setq exwm-input-prefix-keys
          '(?\C-x
            ?\C-u
            ?\C-h
            ?\M-x
            ?\M-`
            ?\M-&
            ?\M-:
            ?\C-\M-j
            ;; ?\C-\
            ))

    (define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)

    (setq exwm-input-global-keys
          `(
            ;; ([?\s-Q] . save-buffers-kill-emacs)

            ([?\s-r] . exwm-reset)

            ([s-left] . awin/move-left)
            ([s-down] . awin/move-down)
            ([s-up] . awin/move-up)
            ([s-right] . awin/move-right)

            ([?\s-\;] . puter/spawn-app)

            ([?\s-h] . awin/move-left)
            ([?\s-j] . awin/move-down)
            ([?\s-k] . awin/move-up)
            ([?\s-l] . awin/move-right)

            ([?\s-H] . awin/swap-left)
            ([?\s-J] . awin/swap-down)
            ([?\s-K] . awin/swap-up)
            ([?\s-L] . awin/swap-right)

            ([?\C-\s-h] . awin/split-left)
            ([?\C-\s-j] . awin/split-down)
            ([?\C-\s-k] . awin/split-up)
            ([?\C-\s-l] . awin/split-right)

            ([?\s-q] . awin/kill-window)
            ([?\s-w] . awin/kill-window-and-buffer)

            ([?\s-m] . awin/maximize)

            ([?\s-¬] . (lambda () (interactive) (exwm-workspace-move-window 0)))
            ([?\s-!] . (lambda () (interactive) (exwm-workspace-move-window 1)))
            ([?\s-\"] . (lambda () (interactive) (exwm-workspace-move-window 2)))
            ([?\s-£] . (lambda () (interactive) (exwm-workspace-move-window 3)))
            ([?\s-$] . (lambda () (interactive) (exwm-workspace-move-window 4)))
            ([?\s-%] . (lambda () (interactive) (exwm-workspace-move-window 5)))
            ([?\s-^] . (lambda () (interactive) (exwm-workspace-move-window 6)))
            ([?\s-&] . (lambda () (interactive) (exwm-workspace-move-window 7)))
            ([?\s-*] . (lambda () (interactive) (exwm-workspace-move-window 8)))
            ([?\s-\(] . (lambda () (interactive) (exwm-workspace-move-window 9)))
            ([?\s-\)] . (lambda () (interactive) (exwm-workspace-move-window 0)))

            ([?\s-`] . (lambda () (interactive) (exwm-workspace-switch-create 0)))
            ,@(mapcar (lambda (i)
                        `(,(kbd (format "s-%d" i)) .
                          (lambda ()
                            (interactive)
                            (exwm-workspace-switch-create ,i))))
                      (number-sequence 0 9))
            ))

    (require 'exwm-randr)
    (setq exwm-randr-workspace-monitor-plist '(0 "HDMI-1" 9 "HDMI-2"))
    ;; (add-hook 'exwm-randr-screen-change-hook 'puter/xsettings)
    (exwm-randr-mode 1)

    (exwm-enable))

  (puter/xsettings)

  (defun puter/polybar-exwm-workspace ()
    "Returns the Current Workspace ID."
    exwm-workspace-current-index)

  (defun puter/polybar-workspace-hook ()
    (start-process-shell-command "polybar-msg" nil "polybar-msg action \"#exwm-workspace.hook.0\""))

  (add-hook 'exwm-workspace-switch-hook #'puter/polybar-workspace-hook)

  ;; Desktop Services
  (puter/defservice network-manager "nm-applet")
  (puter/defservice dunst "dunst")
  (puter/defservice picom "picom")
  (puter/defservice polybar "polybar")
  (puter/defservice keyboard-daemon "sxhkd")
  )

(defun puter/app-launcher ()
  "Create and select a frame called emacs-counsel-launcher which consists only of a minibuffer and has specific dimensions.
Runs counsel-linux-app on that frame, which is an emacs command that prompts you to select an app and open it in a dmenu like behaviour.
Delete the frame after that command has exited."
  (interactive)
  (with-selected-frame 
    (make-frame '((name . "emacs-run-launcher")
                  (minibuffer . only)
                  (fullscreen . 0)
                  (undecorated . t)
                  (auto-raise . t)
                  ;;(tool-bar-lines . 0)
                  ;;(menu-bar-lines . 0)
                  (internal-border-width . 10)
                  (width . 80)
                  (height . 11)))
                  (unwind-protect
                    (counsel-linux-app)
                    (delete-frame))))

(provide 'puter)
