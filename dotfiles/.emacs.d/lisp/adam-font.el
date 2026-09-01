(defvar adam/font-size-default 12
  "The default size of the font.")

(defvar adam/font-size-cache adam/font-size-default)

(defun adam/font-size ()
  "Return the current font size."
  adam/font-size-cache)

(defun adam/font-size-increase ()
  (interactive)
  (adam/font-size-set (1+ adam/font-size-cache)))

(defun adam/font-size-decrease ()
  (interactive)
  (adam/font-size-set (1- adam/font-size-cache)))

(defun adam/font-size-default ()
  (interactive)
  (adam/font-size-set adam/font-size-default))

(require 'adam-utils)

(defun adam/font-size-set (font-size)
  "Set the current font size with FONT-SIZE."
  (interactive)
  (let* ((font-size (adam/clamp font-size 8 64))
         (font-height (* font-size 10)))
    (setq adam/font-size-cache font-size)
    (set-face-attribute
     'default nil :height font-height)
    (set-face-attribute
     'variable-pitch nil :height font-height)
    (set-face-attribute
     'fixed-pitch nil :height font-height)))

(defun adam/font-set (font-name font-size)
  "Set frame font FONT-NAME and size FONT-SIZE."
  (let* ((font-size (adam/clamp font-size 8 64))
         (font-height (* font-size 10)))
    (setq adam/font-size-cache font-size)
    (set-face-attribute
     'default nil
     :font font-name :height font-height)
    (set-face-attribute
     'variable-pitch nil
     :font font-name :height font-height)
    (set-face-attribute
     'fixed-pitch nil
     :font font-name :height font-height))
  (let
      ((font-frame (concat font-name "-" (number-to-string font-size))))
    (add-to-list
     'default-frame-alist
     `(font . ,font-frame))))

(defun adam/font-init ()
  "Initialize the font and the size."
  (adam/font-set "Iosevka Nerd Font Mono" adam/font-size-default))

(provide 'adam-font)
;;; adam-font.el ends here
