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
  (find-file "~/adam/HOMEPAGE.org"))

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

(defun adam/lookup ()
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
          (puter/notify-send (format "Saved %d file(s):\n%s" (length saved) (string-join saved "\n"))
                             :normal)
        (puter/notify-send "No files needed saving" :low)))))

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
  "Vim p: paste after cursor (charwise) or below current line (linewise)."
  (interactive)
  (if (null kill-ring)
      (user-error "Kill ring is empty")
    (let ((text (current-kill 0)))
      (cond
       ((use-region-p)
        (let ((beg (region-beginning)))
          (delete-region beg (region-end))
          (insert text)
          (goto-char beg)))
       ((string-suffix-p "\n" text)
        (let ((content (substring text 0 -1)))
          (end-of-line)
          (newline)
          (insert content)
          (back-to-indentation)))
       (t
        (insert text)
        (backward-char 1))))))

(defun adam/paste-above ()
  "Vim P: paste before cursor (charwise) or above current line (linewise)."
  (interactive)
  (if (null kill-ring)
      (user-error "Kill ring is empty")
    (let ((text (current-kill 0)))
      (cond
       ((use-region-p)
        (let ((beg (region-beginning)))
          (delete-region beg (region-end))
          (insert text)
          (goto-char beg)))
       ((string-suffix-p "\n" text)
        (let ((content (substring text 0 -1)))
          (beginning-of-line)
          (insert content "\n")
          (back-to-indentation)))
       (t
        (insert text)
        (backward-char 1))))))

(defun adam/display-buffer-other-window (buffer)
  "Display BUFFER in another window, Magit-style.
If only one window exists, split it using `split-window-right'.
If multiple windows exist, reuse another window.
Returns the selected window."
  (when (one-window-p)
    (split-window-right))
  (select-window (display-buffer buffer '(display-buffer-reuse-window
                                           display-buffer-use-some-window)
                                 '((inhibit-same-window . t)))))

(defvar adam/agent-shell-provider 'opencode
  "The default provider for agent-shell.")

(defvar adam/agent-shell-model "opencode/deepseek-v4-flash-free"
  "The default model for agent-shell.")

(defun adam/agent-shell-default ()
  "Open or switch to an agent shell with the opencode provider."
  (interactive)
  (let ((buffers (agent-shell-buffers)))
    (if buffers
        (adam/display-buffer-other-window (car buffers))
      (let ((config (or (seq-find (lambda (c)
                                    (eq (map-elt c :identifier) adam/agent-shell-provider))
                                  agent-shell-agent-configs)
                        (error "No opencode agent config found"))))
        (setq config (copy-alist config))
        (map-put! config :default-model-id (lambda () adam/agent-shell-model))
        (let ((shell (agent-shell--start :config config
                                        :session-strategy 'new
                                        :no-focus t)))
          (adam/display-buffer-other-window shell))))))

(defvar-local adam/agent-shell--notify-subscribed nil
  "Whether turn-complete notification has been set up for this buffer.")

(defvar-local adam/agent-shell--last-prompt nil
  "Last prompt sent to the agent, stored buffer-locally.")

(defun adam/agent-shell--capture-prompt (oldfun &rest args)
  "Capture the :prompt argument before agent-shell sends it."
  (let ((prompt (car (cdr (memq :prompt args)))))
    (when prompt
      (setq-local adam/agent-shell--last-prompt prompt))
    (apply oldfun args)))

(defun adam/agent-shell-notify-event (_event)
  "The function called when the agent-shell turn is complete."
  (interactive)
  (let ((input (or (bound-and-true-p adam/agent-shell--last-prompt) "")))
    (puter/notify-send (format "agent-shell finished!\n> %s" input) :critical)))

(defun adam/agent-shell-notify-turn-complete ()
  "Send desktop notification when an opencode agent shell turn completes."
  (when (and (derived-mode-p 'agent-shell-mode)
             (not adam/agent-shell--notify-subscribed))
    (let ((config (agent-shell-get-config (current-buffer))))
      (when (eq (map-elt config :identifier) adam/agent-shell-provider)
        (agent-shell-subscribe-to
         :shell-buffer (current-buffer)
         :event 'turn-complete
         :on-event 'adam/agent-shell-notify-event)
        (setq-local adam/agent-shell--notify-subscribed t)))))

(advice-add 'agent-shell--send-command :around
            #'adam/agent-shell--capture-prompt)

(defun adam/agent-shell (&optional arg)
  "Like `agent-shell', but does not copy any context to the prompt."
  (interactive "P")
  (let ((agent-shell-context-sources '()))
    (agent-shell arg)))

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

(provide 'adam)
;;; adam.el ends here
