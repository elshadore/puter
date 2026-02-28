;;; package -- Summary
;;; Commentary:
;;; Code:

(defun awin/move-left ()
  (interactive)
  (windmove-left))

(defun awin/move-right ()
  (interactive)
  (windmove-right))

(defun awin/move-up ()
  (interactive)
  (windmove-up))

(defun awin/move-down ()
  (interactive)
  (windmove-down))

(defun awin/kill-window ()
  "Kill the current window."
  (interactive)
  (evil-window-delete))

(defun awin/kill-other-windows ()
  "Kill the other windows making the current window the main one."
  (interactive)
  (delete-other-windows-internal))

(defun awin/split-window-below ()
  "Split the window below and move cursor to the newly spawned window."
  (interactive)
  (split-window-below)
  (other-window 1))

(defun awin/split-window-right ()
  "Split the window right and move cursor to the newly spawned window."
  (interactive)
  (split-window-right)
  (other-window 1))

(provide 'adam-window)
;;; adam-window.el ends here
