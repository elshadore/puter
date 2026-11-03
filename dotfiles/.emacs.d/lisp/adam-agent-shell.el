;;; adam-agent-shell.el --- agent-shell helpers -*- lexical-binding: nil -*-
;;; Commentary:
;; Desktop notifications for `agent-shell' events.
;;
;; Subscribes (buffer-locally, via `agent-shell-mode-hook') to the
;; `turn-complete' and `error' events emitted by `agent-shell' and
;; raises a desktop notification when the agent shell buffer is not
;; visible (e.g. prompt finished while working in another window).
;;
;; This is very vibecoded code lmao.
;; Have fun.
;;
;;; Code:

(require 'agent-shell)

(defgroup adam/agent-shell nil
  "agent-shell helpers."
  :prefix "adam/agent-shell"
  :group 'agent-shell)

(defcustom adam/agent-shell-notify-turn t
  "Send a desktop notification when an agent turn completes."
  :group 'adam/agent-shell
  :type 'boolean)

(defcustom adam/agent-shell-notify-error t
  "Send a desktop notification when an agent request fails."
  :group 'adam/agent-shell
  :type 'boolean)

(defcustom adam/agent-shell-notify-when-visible nil
  "If non-nil, notify even when the agent-shell buffer is visible.

When nil (the default), notifications are suppressed while the
agent-shell buffer is displayed in some window."
  :group 'adam/agent-shell
  :type 'boolean)

(defcustom adam/agent-shell-notify-title "Agent Shell"
  "Title used for agent-shell desktop notifications."
  :group 'adam/agent-shell
  :type 'string)

(defcustom adam/agent-shell-notify-urgency nil
  "Urgency for agent-shell notifications (`low', `normal' or `critical')."
  :group 'adam/agent-shell
  :type 'symbol)

(defvar adam/agent-shell-notify-subscriptions nil
  "List of subscription tokens, buffer-locally set.")

(defvar adam/agent-shell-stop-reason-messages
  '(("end_turn" . "Prompt finished")
    ("cancelled" . "Prompt cancelled")
    ("refusal" . "Agent refused the request")
    ("max_tokens" . "Hit the token limit")
    ("max_turn_requests" . "Hit the request limit")
    ("other" . "Prompt ended"))
  "Alist mapping ACP stop reasons to human-readable messages.")

(defun adam/agent-shell--notify (title &optional body)
  "Send a desktop notification with TITLE and BODY.
Uses D-Bus (`notifications') when available, falls back to
`notify-send'."
  (ignore-errors
    (require 'notifications nil t)
    (if (fboundp 'notifications-notify)
        (apply #'notifications-notify
               (append (list :title title :body (or body ""))
                       (when adam/agent-shell-notify-urgency
                         (list :urgency adam/agent-shell-notify-urgency))))
      (start-process "adam-agent-shell-notify" nil "notify-send"
                     title (or body "")))))

(defun adam/agent-shell--stop-reason-message (stop-reason)
  "Return a human-readable string for STOP-REASON."
  (or (cdr (assoc stop-reason adam/agent-shell-stop-reason-messages))
      (format "Prompt ended (%s)" (or stop-reason "unknown"))))

(defun adam/agent-shell--session-title ()
  "Return the current agent-shell session title, or the buffer name."
  (or (ignore-errors
        (map-nested-elt (agent-shell--state) '(:session :title)))
      (buffer-name)))

(defun adam/agent-shell-on-turn-complete (event)
  "Raise a desktop notification for a `turn-complete' EVENT."
  (when adam/agent-shell-notify-turn
    (let* ((data (map-elt event :data))
           (stop-reason (map-elt data :stop-reason))
           (visible (get-buffer-window (current-buffer) t)))
      (when (or adam/agent-shell-notify-when-visible (not visible))
        (adam/agent-shell--notify
         adam/agent-shell-notify-title
         (format "%s (%s)"
                 (adam/agent-shell--stop-reason-message stop-reason)
                 (adam/agent-shell--session-title)))))))

(defun adam/agent-shell-on-error (event)
  "Raise a desktop notification for an `error' EVENT."
  (when adam/agent-shell-notify-error
    (let ((data (map-elt event :data))
          (visible (get-buffer-window (current-buffer) t)))
      (unless (and visible (not adam/agent-shell-notify-when-visible))
        (adam/agent-shell--notify
         adam/agent-shell-notify-title
         (format "Agent error %s: %s"
                 (or (map-elt data :code) "?")
                 (or (map-elt data :message) "unknown")))))))

(defun adam/agent-shell-viewport-hook ()
  "Visual viewport configurations for `agent-shell'."
  (visual-line-mode))

(defun adam/agent-shell-hook ()
  "Visual shell configurations for `agent-shell'."
  (visual-line-mode -1)
  (adam-markdown-tools-mode -1))

(defun adam/agent-shell-setup ()
  "Subscribe to `agent-shell' events in the current buffer."
  (when (derived-mode-p 'agent-shell-mode)
    (let ((tokens
           (list (agent-shell-subscribe-to
                  :shell-buffer (current-buffer)
                  :event 'turn-complete
                  :on-event #'adam/agent-shell-on-turn-complete)
                 (agent-shell-subscribe-to
                  :shell-buffer (current-buffer)
                  :event 'error
                  :on-event #'adam/agent-shell-on-error))))
      (setq-local adam/agent-shell-notify-subscriptions tokens))))

(provide 'adam-agent-shell)
;;; adam-agent-shell.el ends here
