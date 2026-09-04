;;; package --- Summary -*- lexical-binding: nil -*-
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

(defun awin/swap-with-direction (windmove-fn)
  "Swap the buffer of the current window with the window in the direction of WINDMOVE-FN."
  (let* ((this-window (selected-window))
         (this-buffer (window-buffer this-window)))
    (condition-case nil
        (progn
          (funcall windmove-fn)
          (let ((other-buffer (window-buffer (selected-window))))
            (set-window-buffer (selected-window) this-buffer)
            (set-window-buffer this-window other-buffer)))
      (error
       (with-selected-window this-window nil)))))

(defun awin/swap-left ()
  (interactive)
  (awin/swap-with-direction #'windmove-left))

(defun awin/swap-right ()
  (interactive)
  (awin/swap-with-direction #'windmove-right))

(defun awin/swap-up ()
  (interactive)
  (awin/swap-with-direction #'windmove-up))

(defun awin/swap-down ()
  (interactive)
  (awin/swap-with-direction #'windmove-down))

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
  (split-window-right))

(defun awin/split-down ()
  "Split the window down and move cursor to the newly spawned window."
  (interactive)
  (split-window-below)
  (other-window 1))

(defun awin/split-up ()
  "Split the window up and move cursor to the newly spawned window."
  (interactive)
  (split-window-below))

(defun awin/split-right ()
  "Split the window right and move cursor to the newly spawned window."
  (interactive)
  (split-window-right)
  (other-window 1))

(defun awin/toggle-split ()
  "Toggle the current window split between horizontal and vertical."
  (interactive)
  (let* ((this-window (selected-window))
         (other-window (next-window this-window 'nomini))
         (this-buffer (window-buffer this-window))
         (other-buffer (window-buffer other-window))
         (is-vertical (window-combined-p this-window)))
    (when (eq (next-window other-window 'nomini) this-window)
      (delete-window other-window)
      (if is-vertical
          (split-window-right)
        (split-window-below))
      (set-window-buffer (selected-window) this-buffer)
      (set-window-buffer (next-window) other-buffer))))

(provide 'adam-window)
;;; adam-window.el ends here
