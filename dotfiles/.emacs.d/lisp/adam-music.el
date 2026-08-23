;;; package -- Summary
;;; Commentary:
;;; Code:

(defvar adam/music-dir "~/Music/"
  "My music directory :).")

(defvar adam/enable-mpd-on-launch t
  "Control variable to launch `mpd' on emacs statup.")

(defvar adam/mpd-volume 40
  "A cached variable of the current `mpd' volume.")

(defvar adam/mpd-repeat nil
  "A cached variable of the current `mpd' repeat flag.")

(defvar adam/mpd-random nil
  "A cached variable of the current `mpd' random flag.")

(defun adam/mpd--on-off (boolean)
  "Converts a `t' or `nil' value to MPD complient `1' or `0' respectively."
  (if boolean "1" "0"))

(defun adam/mpd--from-on-off (value)
  "Does the opposite of `adam/mpd--on-off'."
  (if (string= value "1") t nil))

(defun adam/mpd--on-off-new (name boolean)
  (concat name " " (adam/mpd--on-off boolean)))

(cl-defmacro adam/with-mpd-status ((status value) &rest body)
  (declare (indent 1))
  `(emms-player-mpd-get-status-part
   nil
   (lambda (_closure ,value) ,@body)
   ,(adam/stringify ',status)))

(defun adam/mpd-random (set)
  (interactive)
  (emms-player-mpd-get-status-part
   set
   (lambda (value current)
     (emms-player-mpd-send (if value "random 1" "random 0") nil #'ignore)
     (message "MPD Random: %s" (if value "on" "off"))
     (setq adam/mpd-random value))
   "random"))

(defun adam/mpd-random? ()
  "Are we currently set to random."
  (interactive)
  adam/mpd-random)

(defun adam/mpd-random-toggle ()
  (interactive)
  (adam/mpd-random (not (adam/mpd-random?))))

(defun adam/mpd-repeat (set)
  (interactive)
  (emms-player-mpd-get-status-part
   set
   (lambda (value current)
     (emms-player-mpd-send (if value "repeat 1" "repeat 0") nil #'ignore)
     (message "MPD Repeat: %s" (if value "on" "off"))
     (setq adam/mpd-repeat value))
   "repeat"))

(defun adam/mpd-repeat? ()
  "Are we currently set to repeat."
  (interactive)
  adam/mpd-repeat)

(defun adam/mpd-repeat-toggle ()
  (interactive)
  (adam/mpd-repeat (not (adam/mpd-repeat?))))

(defun adam/mpd-volume-set (value)
  (let ((new (adam/clamp value 0 100)))
    (emms-player-mpd-send
     (concat "setvol \"" (number-to-string new) "\"")
     nil #'ignore)
    (message "Volume: %d%%" new)
    (setq adam/mpd-volume new)))

(defun adam/mpd-volume-get ()
  "Get the current `mpd' volume. Returns the cached variable `adam/mpd-volume'."
  adam/mpd-volume)

(defun adam/mpd-volume-sync ()
  "Sync the current `mpd' volume value `adam/mpd-volume'."
  (emms-player-mpd-send
   "getvol"
   nil
   (lambda (_closure value)
     (let ((current-volume (adam/loosy-goosy-string->number value)))
       (if (>= current-volume 100)
           (adam/mpd-volume-set adam/mpd-volume)
         (setq adam/mpd-volume current-volume)))
     )))

(defun adam/mpd--callback-volume-change (amount)
  "Change MPD volume by AMOUNT and display new level."
  (emms-player-mpd-get-volume
   amount
   (lambda (change volume)
     (adam/mpd-volume-set (+ (string-to-number (or volume "100")) change)))))

(defun adam/mpd-on-init-function ()
  "A hook function to be called after `mpd' has initialized."
  (emms-cache 1)
  (emms-player-mpd-connect)
  (emms-player-mpd-update-all-reset-cache)
  (adam/mpd-volume-sync)
  (adam/mpd-random t)
  (adam/mpd-repeat t))

(defun adam/mpd-init ()
  "Launch MPD and await it's initialization."
  (make-process
   :name "mpd init"
   :command '("mpd")
   :sentinel (lambda (_ _)
               (funcall 'adam/mpd-on-init-function))))

(defun adam/mpd-launch ()
  "Launch MPD and initialize some variables."
  (adam/mpd-init))

(use-package emms
  :config
  (require 'emms-player-mpd)
  (setq emms-player-list '(emms-player-mpd))
  (setq emms-info-functions '(emms-info-mpd))
  (setq emms-source-file-default-directory adam/music-dir)
  (setq emms-player-mpd-server-name "localhost")
  (setq emms-player-mpd-server-port 6969)
  (setq emms-player-mpd-music-directory adam/music-dir)
  (setq emms-volume-change-amount 1)
  (setq emms-volume-change-function #'adam/mpd--callback-volume-change)
  (require 'emms-browser)
  (when adam/enable-mpd-on-launch
    (adam/mpd-launch))
  (emms-mode-line-mode 1)
  (require 'emms-playing-time)
  (emms-playing-time-mode 1))

(provide 'adam-music)
;;; adam-music.el ends here
