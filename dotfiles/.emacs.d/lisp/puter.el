(defun puter/quiet-kill-process (process)
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
      (process-status a)
    (quote not-registered)))

(defmacro puter/defservice (define-symbol shell-command)
  "Define and Run a Managed Service by Emacs."
  (list 'puter/register-service (list 'quote define-symbol) shell-command))

;; (puter/defservice keyboard-daemon "sxhkd")

(defun puter/xgfxtablet ()
  "Setup XGFXtablet."
  (interactive)
  (if (when-let ((a (adam/shell-command "xinput list --id-only \"UGTABLET 10 inch PenTablet stylus\"")))
        (adam/shell-command
         (format "xinput map-to-output %s HDMI-1"
                 (adam/strip-ending-newline a))))
      (message "XGFXTablet Set Up!")
      (message "XGFXTablet Setup Failed!")))

(defun puter/linkup ()
  "Linked Up! Sneed it or Keep it?"
  (interactive)
  (let ((default-directory "~/puter/"))
    (shell-command "stow --no-folding dotfiles"))
  (message "Linked Up! Sneed it or Keep it?"))

(defvar puter/xsettings-commands
  '("setxkbmap gb"
    "xset r rate 200 80"
    "xset s off -dpms"
    "xrandr --output HDMI-1 --primary --output HDMI-2 --right-of HDMI-1"))

(defun puter/xsettings ()
  "Apply XSettings."
  (interactive)
  (dolist (el puter/xsettings-commands)
    (shell-command el))
  (message "XSetting Applied!")
  (puter/xgfxtablet))

(defun puter/spawn-app ()
  "Spawn a Linux App."
  (interactive)
  (call-interactively #'counsel-linux-app))

(defun puter/can-load-exwm? ()
  "Detects if Emacs is being used as a Desktop Window Manager or not."
  (and (display-graphic-p)
       (eq system-type 'gnu/linux)
       (getenv "ADAM/EXWM-ENABLE")))

(when (puter/can-load-exwm?)
  (use-package exwm
    :config
    (defun puter/exwm-update-class ()
      (exwm-workspace-rename-buffer exwm-class-name))

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
            ?\C-\ ))

    (define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)

    (setq exwm-input-global-keys
          `(
            ([?\s-r] . exwm-reset)

            ([s-left] . awin/move-left)
            ([s-down] . awin/move-down)
            ([s-up] . awin/move-up)
            ([s-right] . awin/move-right)

            ([?\s-p] . puter/spawn-app)

            ([?\s-h] . awin/move-left)
            ([?\s-j] . awin/move-down)
            ([?\s-k] . awin/move-up)
            ([?\s-l] . awin/move-right)

            ([?\s-&] . (lambda (command)
                         (interactive (list (read-shell-command "$ ")))
                         (start-process-shell-command command nil command)))

            ([?\s-w] . exwm-workspace-switch)
            ([?\s-`] . (lambda () (interactive) (exwm-workspace-switch-create 0)))
            ,@(mapcar (lambda (i)
                        `(,(kbd (format "s-%d" i)) .
                          (lambda ()
                            (interactive)
                            (exwm-workspace-switch-create ,i))))
                      (number-sequence 0 9))))

    (require 'exwm-randr)
    (setq exwm-randr-workspace-monitor-plist '(0 "HDMI-1" 9 "HDMI-2"))
    (add-hook 'exwm-randr-screen-change-hook 'puter/xsettings)
    (exwm-randr-mode 1)

    (exwm-enable)))


(provide 'puter)
