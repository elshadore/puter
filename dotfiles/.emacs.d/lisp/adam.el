;;; package -- Summary
;;; Commentary:
;;; Code:

(require 'json)

(defun adam/is-wayland? ()
  "Is the current desktop a Wayland session?"
  (when (getenv "WAYLAND_DISPLAY") t))

(defun adam/quitter ()
  "A Better C-g Quit that works in the Minibuffer.
I Stole this from: https://emacsredux.com/blog/2025/06/01/let-s-make-keyboard-quit-smarter"
  (interactive)
  (cond
   ((region-active-p)
    (keyboard-quit))
   ((derived-mode-p 'completion-list-mode)
    (delete-completion-window))
   ((> (minibuffer-depth) 0)
    (abort-recursive-edit))
   (t (keyboard-quit))))


(defun adam/selection-reverse (beg end)
  "Reverse characters in the selected region."
  (interactive "r")
  (let ((text (buffer-substring beg end)))
    (delete-region beg end)
    (insert (reverse text))))

(defun adam/disable-all-themes ()
  "Disable all currently active themes."
  (interactive)
  (dolist (el custom-enabled-themes)
    (disable-theme el)))

(defun adam/load-theme (theme)
  "Cleanly load the theme THEME disabling all currently enabled theming."
  (interactive (list (intern (completing-read "Load custom theme: " (mapcar #'symbol-name (custom-available-themes))))))
  (adam/disable-all-themes)
  (load-theme theme t))

(defun symbol-value-or (symbol &optional value)
  "Get the value of a symbol or return the optional value, default nil."
  (if (boundp symbol)
      (symbol-value symbol)
    value))

(defun adam/shell-command-to-number (command)
  "Launch sync shell command and return its output throught the string-to-number function."
  (string-to-number (shell-command-to-string command)))

(defun adam/string-match (pattern string &optional match)
  "Slice a String based on a Given Pattern and Match Predicate, Returns NIL, if not Pattern is Recognized."
  (when-let ((a (string-match pattern string)))
    (match-string-no-properties (or match 0) string)))

(defun adam/stringify (any)
  "Turn ANY Lisp Data into a string, if already a string, return."
  (if (stringp any)
      any
    (format "%S" any)))

(defun adam/read-current-line ()
  "Reads the Current Line of a Buffer and Returns it as a String."
  (interactive)
  (save-excursion
    (let (a b)
      (beginning-of-line)
      (setq a (point))
      (end-of-line)
      (setq b (point))
      (buffer-substring-no-properties a b))))

(defvar %-assert-result-% nil
  "Special Variable used in ASSERT Macro.")

(defmacro assert! (form &optional message)
  `(if-let (%-assert-result-% ,form)
       %-assert-result-%
     ,(if message
         `(error "ASSERT! %S, %s\n", form ,message)
         `(error "ASSERT! %S\n", form))))

(defmacro cadrq (symbol)
  "Returns the CAR of a LIST bound the SYMBOL, then SETS the SYMBOL to the CDR of the LIST."
  (assert! (symbolp symbol) "CDRQ form expects a symbol as its argument")
  `(prog1
       (if (null ,symbol)
           (error "CDRQ does not cdr nil => nil.")
           (car ,symbol))
     (setq ,symbol (cdr ,symbol))))


(defvar %-bind-let-form-% nil
  "Special Symbol Used in the BIND-LET Macro.")
(defvar %-bind-let-eval-% nil
  "Special Symbol Used in the BIND-LET Macro.")
(defvar %-bind-let-iter-% nil
  "Special Symbol Used in the BIND-LET Macro.")

(defmacro bind-let (form &rest body)
  "A Better Destructing Bind Macro."
  (let ((%-bind-let-form-% (car form))
        (%-bind-let-eval-% (cadr form)))
    (assert! (null (cddr form)) "bind-let excepts two forms in FORM (*destructing-bind* eval-form)")
    `(let ((%-bind-let-iter-% ,%-bind-let-eval-%))
       (assert! (listp %-bind-let-iter-%))
       ,(seq-concatenate 'list
                         (list 'let (mapcar (lambda (x) (list x '(cadrq %-bind-let-iter-%))) %-bind-let-form-%))
                         (list '(assert! (null %-bind-let-iter-%) "Binding List has too Many Elements."))
                         body
                         ))))

(defvar %-operate-symbol-% nil
  "Special Symbol Used in the OPERATE Macro.")
(defvar %-operate-init-% nil
  "Special Symbol Used in the OPERATE Macro.")

(defmacro operate (form &rest body)
  "TODO: Description."
  (bind-let ((%-operate-symbol-% %-operate-init-%) form)
            (assert! (symbolp %-operate-symbol-%) "Expected symbol for Operate First Form.")
            (seq-concatenate 'list
                             (list 'let `((,%-operate-symbol-% ,%-operate-init-%)))
                             (mapcar (lambda (x) (list 'setq %-operate-symbol-% x)) body)
                             (list %-operate-symbol-%)
                             )))

(defun adam/move-to-top ()
  (interactive)
  (if (eq major-mode 'eshell-mode)
      (recenter 1)
    (recenter 0)))

(defun adam/qoutize-string (str)
  "Surround a string STR in \"\" qoutes."
  (concat "\"" str "\""))

(defun adam/change-file-suffix (path new-suffix)
  "Change the file path PATHs format suffix to NEW-SUFFIX."
  (interactive)
  (concat (car (string-split (car (last (string-split path "/"))) "\\.")) "." new-suffix))

(defun adam/set-font (font-name font-size)
  "Set frame font FONT-NAME and size FONT-SIZE."
  (let ((font-height (* font-size 10)))
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


(defun adam/goto-init-file ()
  "Open init file."
  (interactive)
  (find-file user-init-file))

(defun adam/goto-homepage ()
  "Find main EMACS page."
  (interactive)
  (find-file "~/adam/homepage.org"))

(defun adam/reload-init-file ()
  "Reload EMACS config."
  (interactive)
  (load-file user-init-file))

(defun adam/switch-buffer ()
  "Switch to buffer command."
  (interactive)
  (let ((ivy-use-virtual-buffers nil))
    (call-interactively #'counsel-switch-buffer)))

(defun adam/ibuffer ()
  "Interactive buffer menu."
  (interactive)
  (call-interactively #'ibuffer))

(defun adam/find-file ()
  "Find file."
  (interactive)
  (call-interactively #'find-file-existing))

(defun adam/find-file-new ()
  "File file new."
  (interactive)
  (call-interactively #'counsel-find-file))

(defun adam/imenu ()
  "Interactive menu."
  (interactive)
  (call-interactively #'counsel-imenu))

(defun adam/M-x ()
  "Meta X."
  (interactive)
  (call-interactively #'counsel-M-x))

(defun adam/occur ()
  "Occur."
  (interactive)
  (call-interactively #'occur))

(defun adam/grep ()
  "Grep."
  (interactive)
  (call-interactively #'rgrep))

(defun adam/lookup-func ()
  "Lookup symbol under cursor."
  (interactive)
  (cond ((eq major-mode 'emacs-lisp-mode)
         (call-interactively #'describe-symbol))
        ((eq lsp-mode t)
         (call-interactively #'lsp-describe-thing-at-point))
        (t (call-interactively #'man))))

(defvar adam/fuzzy-find-alist
  '((dired-mode . adam/find-file)
    (eshell-mode . adam/find-file)
    (ibuffer-mode . adam/switch-to-buffer)
    (t . adam/imenu)))

(defun adam/fuzzy-find ()
  "Fuzzy find based on the contents of the current buffer."
  (interactive)
  (if-let ((a (assoc major-mode adam/fuzzy-find-alist)))
      (call-interactively (cdr a))
    (if-let ((b (assoc t adam/fuzzy-find-alist)))
        (call-interactively (cdr b))
      (error "no fallback value found"))))

(defun adam/tar-file (file-path &optional output-path)
  "Use linux tar util to tar a file FILE-PATH and output to OUTPUT-PATH."
  (interactive "Ftar: ")
  (let* ((output (or output-path (concat "./" (adam/change-file-suffix file-path "tar.gz"))))
         (cmd (concat "tar -cavf" " " output " " file-path)))
    (start-process-shell-command cmd nil cmd)))

(defun adam/untar-file (file-path)
  "Use linux tar util to untar the compressed file FILE-PATH."
  (interactive "Funtar: ")
  (let ((cmd (concat "tar -xvf" " " file-path)))
    (start-process-shell-command cmd nil cmd)))

(defun adam/yt-music (url)
  "Use commandline util yt-dlp to download a youtube link URL as a mp3 file."
  (interactive "surl: ")
  (let ((cmd (concat "yt-dlp -f bestaudio -x --audio-format mp3 --audio-quality 330k" " " url)))
    (start-process-shell-command cmd nil cmd)))

(defvar adam/auth-file "~/adam/auth.json")

(defun adam/lookup-auth (auth-sym)
  "Fetch a given auth string from the auth-file with a given symbol: AUTH-SYM."
  (cdr (assoc auth-sym (json-read-file adam/auth-file))))

(defun adam/display-startup-time ()
  "Display EMACS starting time."
  (message "EMACS loaded in: %s, gc collects: %d."
           (format "%.2f seconds"
                   (float-time
                    (time-subtract after-init-time before-init-time)))
           gcs-done))
(add-hook 'emacs-startup-hook #'adam/display-startup-time)

(defun adam/empty-buffer ()
  "Creates a new empty buffer in the current window."
  (interactive)
  ;; TODO:
  )

(defun adam/eshell ()
  "Start eshell mode in the current directory."
  (interactive)
  (let ((cached-cwd default-directory)
        (eshell-buf (get-buffer "*eshell*")))
    (when eshell-buf
      (let ((kill-buf (not (with-current-buffer eshell-buf
                             (equal cached-cwd default-directory)))))
        (when kill-buf
          (kill-buffer eshell-buf))))
    (eshell)))

(defun adam/eshell-command (cmd &optional to-current-buffer)
  "Launch an Eshell Command in a Eshell Buffer."
  (interactive (list (eshell-read-command)
                     current-prefix-arg))
  ;; This is a really good use of the `operate' macro.
  (let ((v (operate (x (adam/get-buffer-names))
                    (adam/fap (lambda (y) (adam/string-match "\\*eshell\\*<\\([[:digit:]]+\\)>" y 1)) x)
                    (mapcar #'string-to-number x)
                    (sort x #'>)
                    (car x)
                    (if x (1+ x) 0))))
    (eshell v))
  (insert cmd)
  (eshell-send-input))

(defun adam/get-buffer-names ()
  "Return all Currently open buffers and Strings."
  (mapcar #'buffer-name (buffer-list)))

(defun adam/fap (function sequence)
  "Maps then Filters the List for NIL elements."
  (seq-filter #'identity (seq-map function sequence)))

(defun adam/dump-file (file-path)
  "Dump the contents of a file FILE-PATH as a string."
  (with-temp-buffer
    (insert-file-contents file-path)
    (buffer-string)))

(defun adam/strip-ending-newline (str)
  "Strip the Ending Newline from a String."
  (replace-regexp-in-string "\n\\'" "" str))

(defun adam/shell-command (cmd)
  "Launch a Synchronous Shell Command, return the output as a STRING on SUCCESS, return NIL on FAILURE."
  (with-temp-buffer
    (let ((exit-status (call-process-shell-command cmd nil t)))
      (if (zerop exit-status)
          (buffer-string)
        nil))))

(defun million (x)
  "Take a given number X, and return X million."
  (* x 1000000))

(defun thousand (x)
  "Take a given number X, and return X thousand."
  (* x 1000))

(defun true? (value)
  "If the VALUE is not NIL return T, else NIL."
  (if value t nil))

(defvar kill-all-buffers-last
  nil
  "History for the `Kill-All-Buffers' Command.")

(defun adam/kill-all-buffers-match (match-input buffer)
  "The Matching Function for the `Kill-All-Buffers' Function."
  (when-let (y (string-match match-input buffer))
    (when (= y 0) buffer)))

(defun adam/kill-all-buffers (input)
  "`Kill-All-Buffers' matching the string predicate.
    Example => `Example' will kill `Example<1>', `Example<2>'..."
  (interactive "sbuffer: ")
  (dolist (el (seq-keep #'kill-all-buffers-match (mapcar #'buffer-name (buffer-list))))
    (kill-buffer input el)
    (message "Buffer %s Killed!" el)))

(provide 'adam)
;;; adam.el ends here
