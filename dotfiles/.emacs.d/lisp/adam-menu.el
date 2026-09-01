(defhydra adam/music-panel (:hint nil)
  "
Music
--------------------------------------------------
_b_: browse        _s_: start         _r_: repeat: % `adam/mpd-repeat
_d_: directory     _S_: stop          _z_: random: % `adam/mpd-random
_u_: update        _c_: pause         _+_: volume raise
^ ^                _n_: next          _-_: volume lower
^ ^                _p_: previous      Volume: % `adam/mpd-volume

"
  
  ("b" emms-browser :color blue)
  ("n" emms-next)
  ("p" emms-previous)
  ("u" emms-player-mpd-update-all-reset-cache)
  ("S" emms-stop)
  ("s" emms-start)
  ("c" emms-pause)
  ("r" adam/mpd-repeat-toggle)
  ("z" adam/mpd-random-toggle)
  ("d" emms-play-directory)
  ("_" adam/mpd-volume-lower)
  ("-" adam/mpd-volume-lower)
  ("=" adam/mpd-volume-raise)
  ("+" adam/mpd-volume-raise)
  ("RET" nil "quit" :color blue)
  ("q" nil "quit" :color blue))

(defhydra adam/window-panel ()
  "Window panel"
  ("h" awin/move-left "move left")
  ("j" awin/move-down "move down")
  ("k" awin/move-up "move up")
  ("l" awin/move-right "right")
  ("H" awin/swap-left "swap left")
  ("J" awin/swap-down "swap down")
  ("K" awin/swap-up "swap up")
  ("L" awin/swap-right "swap right")
  ("C-h" awin/split-left "split left")
  ("C-j" awin/split-down "split down")
  ("C-k" awin/split-up "split up")
  ("C-l" awin/split-right "split right")
  ("m" awin/maximize "maximize")
  ("t" awin/toggle-split "toggle split")
  ("c" awin/kill-window "close")
  ("C" awin/kill-window "close close" :color blue)
  ("s" window-swap-states "swap states")
  ("x" kill-current-buffer "kill buffer")
  ("U" adam/page-k "page up")
  ("D" adam/page-j "page down")
  ("n" next-buffer "buffer next")
  ("p" previous-buffer "buffer previous")
  ("b" adam/switch-buffer "buffer" :color blue)
  ("RET" nil "quit" :color blue)
  ("q" nil "quit" :color blue))

(defhydra adam/zoomer ()
  "Text scale"
  ("-" text-scale-decrease "decrease")
  ("=" text-scale-increase "increase")
  ("RET" nil "quit" :color blue)
  ("q" nil "quit" :color blue))

(defhydra adam/lookup-panel (:exit t)
  "Lookup"
  ("x" xref-find-definitions "xref definitions")
  ("r" xref-find-references "xref references")
  ("s" describe-symbol "emacs symbol")
  ("l" lsp-describe-thing-at-point "lsp")
  ("RET" nil "quit" :color blue)
  ("q" nil "quit" :color blue))

(defhydra adam/finder (:exit t)
  "Find"
  ("b" adam/switch-buffer "buffer")
  ("x" adam/M-x "meta x")
  ("a" counsel-linux-app "app")
  ("." adam/find-file-new "find file")
  ("," projectile-find-file "project find file")
  ("f" adam/fuzzy-find "fuzzy find")
  ("/" swiper "swiper")
  ("r" rgrep "rgrep")
  ("i" adam/internet-search "internet")
  ("_" query-replace-regexp "query replace")
  ("m" man "man")
  ("RET" nil "quit" :color blue)
  ("q" nil "quit" :color blue))

(defhydra adam/launcher (:exit t)
  "Launch"
  ("b" adam/ibuffer "buffer")
  ("c" compile "compile")
  ("p" projectile-compile-project "project compile")
  ("d" flycheck-list-errors "errors")
  ("l" ielm "elisp")
  ("e" adam/eshell "eshell")
  ("E" adam/eshell-new "eshell new")
  ("g" magit-status "magit")
  ("G" adam/toggle-file-diff "magit diff")
  ("s" shell-command "shell")
  ("S" async-shell-command "async shell")
  ("z" adam/zombie-command "zombie shell")
  ("?" meow-cheatsheet "meow cheatsheet")
  ("P" list-processes "processes")
  ("a" agent-shell "agent shell")
  ("RET" nil "quit" :color blue)
  ("q" nil "quit" :color blue))

(defhydra adam/goto (:exit t)
  "Goto"
  ("i" adam/goto-init-file "init file")
  ("h" adam/goto-homepage "homepage")
  ("c" adam/goto-current-project "current project")
  ("t" adam/goto-misc-todos "todos")
  ("p" adam/goto-philosophy "philosophy")
  ("l" goto-line "line")
  ("RET" nil "quit" :color blue)
  ("q" nil "quit" :color blue))

(provide 'adam-menu)
