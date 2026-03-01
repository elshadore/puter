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

(defun awin/swap-left ()
  (interactive)
  (windmove-left))

(defun awin/swap-right ()
  (interactive)
  (windmove-right))

(defun awin/swap-up ()
  (interactive)
  (windmove-up))

(defun awin/swap-down ()
  (interactive)
  (windmove-down))

(defun awin/kill-window ()
  "Kill the current window."
  (interactive)
  (if (one-window-p)
      (scratch-buffer)
    (delete-window)))

(defun awin/kill-window-and-buffer ()
  "Kill the current window it's buffer."
  (interactive)
  (kill-buffer)
  (awin/kill-window))

(defun awin/kill-other-windows ()
  "Kill the other windows making the current window the main one."
  (interactive)
  (delete-other-windows-internal))

(defun awin/maximize ()
  "Make the currently selected window the only window."
  (interactive)
  (awin/kill-other-windows))

(defun awin/split-left ()
  "Split the window left and move cursor to the newly spawned window."
  (interactive)
  (split-window-right)
  (other-window 1))

(defun awin/split-down ()
  "Split the window down and move cursor to the newly spawned window."
  (interactive)
  (split-window-below)
  (other-window 1))

(defun awin/split-up ()
  "Split the window up and move cursor to the newly spawned window."
  (interactive)
  (split-window-below)
  (other-window 1))

(defun awin/split-right ()
  "Split the window right and move cursor to the newly spawned window."
  (interactive)
  (split-window-right)
  (other-window 1))

(provide 'adam-window)
;;; adam-window.el ends here
