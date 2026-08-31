(defun adam/eshell-find-replacement-buffers ()
  "Find `eshell' buffers that can be reused."
  (let ((cached-cwd default-directory))
    (seq-filter
     (lambda (x) (with-current-buffer x
                   (equal cached-cwd default-directory)))
     (adam/get-all-buffers-of-major-mode 'eshell-mode))))

(defun adam/eshell-get-all-eshell-buffer-numbers ()
  (seq-keep
   (lambda (x)
     (when (string-match "\\*eshell\\*<\\([0-9]+\\)>" (buffer-name x))
       (string-to-number (match-string 1 (buffer-name x)))))
   (adam/get-all-buffers-of-major-mode 'eshell-mode)))

(defun adam/eshell-buffer-next-number ()
  "Get the next valid number for a new `eshell' buffer"
  (1+ (seq-reduce #'max (adam/eshell-get-all-eshell-buffer-numbers) -1)))

(defun adam/eshell-buffer-silent (n)
  "Create an eshell buffer silently."
  (let ((buf (get-buffer-create (format "*eshell*<%d>" n))))
    (with-current-buffer buf (eshell-mode))
    buf))

(defun adam/eshell-new ()
  "Create a new `eshell' buffer"
  (interactive)
  (switch-to-buffer (adam/eshell-buffer-silent (adam/eshell-buffer-next-number))))

(defun adam/eshell ()
  "Start `eshell' mode in the current directory."
  (interactive)
  (switch-to-buffer (if-let ((buffers (adam/eshell-find-replacement-buffers)))
                        (car buffers)
                      (adam/eshell-buffer-silent (adam/eshell-buffer-next-number)))))

(provide 'adam-eshell)
