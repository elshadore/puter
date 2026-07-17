(defun kill/ring-element-to-string (x)
  (substring-no-properties x))

(defun kill/menu ()
  (interactive)
  (ivy-read "Copy To Front: "
            (mapcar #'kill/ring-element-to-string kill-ring)
            :action (lambda (x) (message x))))

(provide 'adam-kill)
