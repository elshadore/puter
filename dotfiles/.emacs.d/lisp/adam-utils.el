;;; package -- Summary
;;; Commentary:
;;; Code:

(require 'json)

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
  "Reads the current line of a buffer and returns it as a string."
  (interactive)
  (save-excursion
    (let (a b)
      (beginning-of-line)
      (setq a (point))
      (end-of-line)
      (setq b (point))
      (buffer-substring-no-properties a b))))

(defmacro assert! (form &optional message &rest format-args)
  "Assert that the result of the value FORM is not NIL, otherwise throw an error for MESSAGE with FORMAT-ARGS."
  (cl-with-gensyms (result)
    `(if-let (,result ,form)
         ,result
       ,(if message
            (if format-args
                `(error ,message ,@format-args)
                `(error ,message))
          `(error "assert triggered!")))))

(defmacro cadrq (symbol)
  "Returns the CAR of a LIST bound the SYMBOL, then SETS the SYMBOL to the CDR of the LIST."
  (assert! (symbolp symbol) "CDRQ form expects a symbol as its argument")
  `(prog1
       (if (null ,symbol)
           (error "CDRQ does not cdr nil => nil.")
           (car ,symbol))
     (setq ,symbol (cdr ,symbol))))

(defun adam/move-to-top ()
  (interactive)
  (if (eq major-mode 'eshell-mode)
      (recenter 1)
    (recenter 0)))

(defun adam/qoutize-string (str)
  "Surround a string STR in \"\" qoutes."
  (format "%S" str))

(defun adam/change-file-suffix (path new-suffix)
  "Change the file path PATHs format suffix to NEW-SUFFIX."
  (interactive)
  (concat (car (string-split (car (last (string-split path "/"))) "\\.")) "." new-suffix))

(defun adam/goto-init-file ()
  "Open init file."
  (interactive)
  (find-file user-init-file))

(defun adam/goto-homepage ()
  "Find main EMACS page."
  (interactive)
  (find-file "~/adam/HOMEPAGE.md"))

(defun adam/goto-current-project ()
  "Find the current project."
  (interactive)
  (find-file "~/adam/root/current-project.md"))

(defun adam/goto-misc-todos ()
  "Find the misc todos page."
  (interactive)
  (find-file "~/adam/root/misc.md"))

(defun adam/goto-philosophy ()
  "Find philosophy page."
  (interactive)
  (find-file "~/adam/root/philsophy.md"))

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

(cl-defun adam/shell (cmd &key (custom-name) (buffer))
  "Run the shell command `cmd'."
  (start-process-shell-command (or custom-name cmd) buffer cmd))

(defun adam/display-startup-time ()
  "Display EMACS starting time."
  (message "EMACS loaded in: %s, gc collects: %d."
           (format "%.2f seconds"
                   (float-time
                    (time-subtract after-init-time before-init-time)))
           gcs-done))
(add-hook 'emacs-startup-hook #'adam/display-startup-time)

(defun adam/empty-buffer (&optional name)
  "Creates a new empty buffer in the current window."
  (interactive)
  (display-buffer-same-window (get-buffer-create (or name "*Empty*")) nil))

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

(defun billion (x)
  "Take a given number X, and return X billion."
  (* x 1000000000))

(defun thousand (x)
  "Take a given number X, and return X thousand."
  (* x 1000))

(defun true? (value)
  "If the VALUE is not NIL return T, else NIL."
  (if value t nil))

(defun adam/kill-all-buffers-match (match-input buffer)
  "The Matching Function for the `Kill-All-Buffers' Function."
  (when-let (y (string-match match-input buffer))
    (when (= y 0) buffer)))

(defun adam/kill-all-buffers (input)
  "`Kill-All-Buffers' matching the string predicate.
    Example => `Example' will kill `Example<1>', `Example<2>'..."
  (interactive "sbuffer: ")
  (dolist (el (seq-keep #'kill-all-buffers-match (mapcar #'buffer-name (buffer-list))))
    (adam/kill-all-buffers input el)
    (message "Buffer %s Killed!" el)))

(defun adam/kill-char ()
  "Kills a character adding it to killring, like x in vim"
  (interactive)
  (kill-region (point) (1+ (point))))

(defun adam/j (&optional n)
  "Move down, or with line selection extend or contract downward."
  (interactive "p")
  (if (and (region-active-p) (eq 'line (cdr (meow--selection-type))))
      (let ((mark-pos (mark t)))
        (forward-line n)
        (if (< (point) mark-pos)
            (beginning-of-line)
          (end-of-line)))
    (next-line n)))

(defun adam/k (&optional n)
  "Move up, or with line selection extend or contract upward."
  (interactive "p")
  (if (and (region-active-p) (eq 'line (cdr (meow--selection-type))))
      (let ((mark-pos (mark t)))
        (forward-line (- n))
        (if (< (point) mark-pos)
            (beginning-of-line)
          (end-of-line)))
    (next-line (- n))))

(defun adam/sticky-forward-char ()
  "Move forward one character, but not past the end of the line."
  (interactive)
  (unless (eolp)
    (forward-char 1)))

(defun adam/sticky-backward-char ()
  "Move backward one character, but not past the beginning of the line."
  (interactive)
  (unless (bolp)
    (backward-char 1)))

(defun adam/join-line ()
  "Join the current line with the next line (Vim's J).
Moves to the next line and joins it back, trimming whitespace."
  (interactive)
  (forward-line 1)
  (join-line))

(defun adam/testicle ()
  "A simple testicle function."
  (message "henlo word!"))

(defun adam/save-all ()
  "Save `ALL' the buffers and display a desktop notification of the buffers saved."
  (interactive)
  (let ((modified (cl-loop for b in (buffer-list)
                           when (and (buffer-file-name b)
                                     (buffer-modified-p b))
                           collect (abbreviate-file-name (buffer-file-name b)))))
    (save-some-buffers t)
    (let ((saved (cl-set-difference modified
                                    (cl-loop for b in (buffer-list)
                                             when (and (buffer-file-name b)
                                                       (buffer-modified-p b))
                                             collect (abbreviate-file-name (buffer-file-name b)))
                                    :test #'string=)))
      (if saved
          (message "Saved %d file(s): %s" (length saved) saved)
        (message "No files needed saving")))))

(defun adam/flash-region (start end)
  "Flash the region between START and END."
  (require 'sly-messages)
  (sly-flash-region start end))

(defun adam/flash-eval-region (start end)
  "Flash eval a region of elisp code."
  (interactive "r")
  (adam/flash-region start end)
  (eval-region start end t))

(defun adam/C-c-C-c ()
  "Evaluate current top-level form and flash it, like Sly's C-c C-c, but for elisp mode."
  (interactive)
  (let (start end)
    (save-excursion
      (adam/sticky-forward-char)
      (beginning-of-defun)
      (setq start (point))
      (end-of-defun)
      (setq end (point)))
    (when (and start end)
      (adam/flash-eval-region start end))))

(defun adam/C-x-C-e ()
  "Evaluate expression before point and flash it, like C-x C-e with flash."
  (interactive)
  (let (start end)
    (save-excursion
      (adam/sticky-forward-char)
      (setq end (point))
      (backward-sexp)
      (setq start (point))
      (let ((start (point)))))
    (when (and start end)
      (adam/flash-eval-region start end))))

(defun adam/C-c-C-a ()
  "Evaluate the entire buffer and give it a flash for good measure."
  (interactive)
  (adam/flash-eval-region (point-min) (point-max)))

(defun adam/clipboard-kill-line-or-fold ()
  "Kill line to clipboard. If the line has a folded region, kill the entire fold."
  (interactive)
  (let* ((eol (line-end-position))
         (fold-ov (seq-find (lambda (o) (overlay-get o 'invisible))
                            (overlays-in eol (1+ eol)))))
    (if fold-ov
        (clipboard-kill-region (line-beginning-position)
                               (1+ (overlay-end fold-ov)))
      (meow-clipboard-kill))))

(defun adam/indent-right ()
  "Indent region or line right."
  (interactive)
  (if (use-region-p)
      (indent-rigidly (region-beginning) (region-end) tab-width)
    (indent-rigidly (line-beginning-position) (line-end-position) tab-width)))

(defun adam/indent-left ()
  "Indent region or line left."
  (interactive)
  (if (use-region-p)
      (indent-rigidly (region-beginning) (region-end) (- tab-width))
    (indent-rigidly (line-beginning-position) (line-end-position) (- tab-width))))

(defun adam/increment-number (arg)
  "Increment number at point by ARG."
  (interactive "p")
  (save-excursion
    (skip-chars-backward "0-9")
    (when (looking-at "[0-9]+")
      (replace-match
       (number-to-string (+ arg (string-to-number (match-string 0))))))))

(defun adam/decrement-number (arg)
  "Decrement number at point by ARG."
  (interactive "p")
  (adam/increment-number (- arg)))

(defun adam/block-maximum ()
  "Select the outermost enclosing block by repeatedly expanding."
  (interactive)
  (meow-block 1)
  (when (region-active-p)
    (let ((last-beg (region-beginning))
          (last-end (region-end)))
      (while t
        (meow-block 1)
        (unless (region-active-p)
          (cl-return))
        (when (and (= (region-beginning) last-beg)
                   (= (region-end) last-end))
          (cl-return))
        (setq last-beg (region-beginning)
              last-end (region-end))))))

(defun adam/paste-below ()
  "Vim p: paste on the line below the current line.
If region is active, replace it with the yanked text."
  (interactive)
  (if (null kill-ring)
      (user-error "Kill ring is empty")
    (let* ((text (current-kill 0))
           (content (if (string-suffix-p "\n" text)
                        (substring text 0 -1)
                      text)))
      (cond
       ((use-region-p)
        (let ((beg (region-beginning)))
          (delete-region beg (region-end))
          (insert text)
          (goto-char beg)))
       (t
        (end-of-line)
        (newline)
        (insert content)
        (back-to-indentation))))))

(defun adam/paste-above ()
  "Vim P: paste on the line above the current line.
If region is active, replace it with the yanked text."
  (interactive)
  (if (null kill-ring)
      (user-error "Kill ring is empty")
    (let* ((text (current-kill 0))
           (content (if (string-suffix-p "\n" text)
                        (substring text 0 -1)
                      text)))
      (cond
       ((use-region-p)
        (let ((beg (region-beginning)))
          (delete-region beg (region-end))
          (insert text)
          (goto-char beg)))
       (t
        (beginning-of-line)
        (insert content "\n")
        (back-to-indentation))))))

(defun adam/meow-cancel-or-mc-quit ()
  "Cancel selection or exit multiple-cursors if active."
  (interactive)
  (if (and (bound-and-true-p multiple-cursors-mode)
           (not (meow-insert-mode-p)))
      (mc/keyboard-quit)
    (meow-cancel-selection)))

(defun adam/meow-left-select ()
  "Move left one char, extending selection."
  (interactive)
  (unless (region-active-p)
    (push-mark (point) nil t))
  (backward-char 1))

(defun adam/meow-right-select ()
  "Move right one char, extending selection."
  (interactive)
  (unless (region-active-p)
    (push-mark (point) nil t))
  (forward-char 1))

(defun adam/yank-line ()
  "Yank the current line and flash the copied region."
  (interactive)
  (let ((beg (line-beginning-position))
        (end (line-end-position)))
    (kill-ring-save beg end)
    (adam/flash-region beg end)))

(defun adam/toggle-file-diff ()
  "Toggle git diff for the current file using magit."
  (interactive)
  (if-let ((win (seq-find (lambda (w)
                            (with-current-buffer (window-buffer w)
                              (derived-mode-p 'magit-diff-mode)))
                          (window-list))))
      (delete-window win)
    (magit-diff-buffer-file)))

(cl-defmacro adam/do-plist ((key value list) &rest body)
  "Iterate over a property list."
  (declare (indent 1))
  `(cl-loop for (,key ,value) on ,list by 'cddr
            do (progn
                  ,@body)))

(defmacro adam/anti-mode (mode)
  "Creates a macro to toggle a mode MODE, but negates the argument to produce the opposite toggle."
  `(lambda (enable) (funcall ',mode (- enable))))

(defun adam/buffer-grep ()
  "Grep the current buffer."
   (interactive)
   (counsel-grep))

(defun adam/clamp (value min max)
  "Clamp a value VALUE between MIN and MAX."
  (max min (min max value)))

(defun adam/negative? (value)
  "Is the current number VALUE negetive?"
  (< value 0))

(defun adam/positive? (value)
  "Is the current number VALUE positive?"
  (not (adam/negative? value)))

(defun adam/loosy-goosy-string->number (string &optional index)
  "Take the first numberlike thing from a string STRING and return it. Returns `0' if no number."
  (string-to-number (and (string-match "[0-9]+" string)
                         (match-string (or index 0) string))))

(defun adam/minutes (minutes)
  "Returns the number of minutes MINUTES in seconds."
  (* minutes 60))

(defun adam/compile-new ()
  "Call the `compile' command but with a new prompt."
  (interactive)
  (let ((compile-command ""))
    (call-interactively 'compile)))

(defun adam/page-j ()
  "Go down a page."
  (interactive)
  (adam/j 16)
  (recenter))

(defun adam/page-k ()
  "Go up a page."
  (interactive)
  (adam/k 16)
  (recenter))

(defun adam/get-all-buffers-of-major-mode (major-mode-query)
  "Get all buffers of `major-mode' MAJOR-MODE-QUERY."
  (seq-filter
   (lambda (x) (with-current-buffer x (eq major-mode major-mode-query)))
   (buffer-list)))

(defun adam/internet-search (query)
  "Search the internet using the query QUERY."
  (interactive "sBrowse: ")
  (browse-url (concat "https://duckduckgo.com/?q="
                      (url-hexify-string query))))

(defun adam/comment ()
  "Basically `comment-dwim', but if no region is selected. It comments the current line."
  (interactive)
  (if (use-region-p)
      (comment-dwim nil)
    (comment-or-uncomment-region (line-beginning-position) (line-end-position))))

(defun adam/char-jump (char)
  (interactive "cJump: ")
  (let ((end (line-end-position))
        (start (point)))
    (goto-char (min end (1+ start)))
    (if (search-forward (string char) end t)
        (backward-char 1)
      (goto-char start))))

(defun adam/char-jump-fast ()
  (interactive)
  (let ((char (read-char "Jump: " t t)))
    (unless (<= 32 char 126)
      (error "Quit"))
    (adam/char-jump char)))

(defun adam/expand-region-char ()
  "Expand the selection by one char in both directions."
  (interactive)
  (unless (use-region-p)
    (push-mark (point) nil t))
  (let ((beg (max (point-min) (1- (region-beginning))))
        (end (min (point-max) (1+ (region-end)))))
    (goto-char end)
    (push-mark beg nil t)))

(defun adam/shrink-region-char ()
  "Shrink the selection by one char in both directions."
  (interactive)
  (when (use-region-p)
    (let* ((len (- (region-end) (region-beginning)))
           (beg (1+ (region-beginning)))
           (end (1- (region-end))))
      (when (> len 2)
        (goto-char end)
        (push-mark beg nil t)))))

(defun adam/meow-mode-toggle ()
  "Toggle `meow' modes `meow-motion-mode' and `meow-normal-mode'."
  (interactive)
  (if (meow-motion-mode-p)
      (meow-normal-mode)
    (meow-motion-mode)))

(defun adam/zombie-command (cmd)
  "Run a command CMD like `async-shell-command', but spawn it as a zombie process.
Does not kill the process when `emacs' closes."
  (interactive (list (read-shell-command "Zombie: ")))
  (start-process-shell-command
   (format "zombie: %s" cmd)
   nil
   (format "setsid nohup sh -c '%s' > /tmp/zombie.log 2>&1 < /dev/null &" cmd)))

(defun adam/zombie-command (cmd)
  "Run a command CMD like `async-shell-command', but spawn it as a zombie process.
Does not kill the process when `emacs' closes."
  (interactive (list (read-shell-command "Zombie shell: ")))
  (let* ((detached-session-origin 'shell-command)
         (detached-session-action detached-shell-command-session-action)
         (detached-session-mode 'detached)
         (session (detached-create-session cmd)))
    (detached-start-session session)))

(provide 'adam-utils)
;;; adam-utils.el ends here
