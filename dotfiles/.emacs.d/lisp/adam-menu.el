;;; package --- Summary -*- lexical-binding: nil -*-
;;; Commentary:
;;; Code:

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

(defhydra adam/window-panel (:hint nil)
  "
Window
---------------------------------------------------------------------------------------------
_h_: split left     _H_: move left       _C-h_: swap left       _m_: maximize           _U_: page up
_j_: split down     _J_: move down       _C-j_: swap down       _t_: toggle split       _D_: page down
_k_: split up       _K_: move up         _C-k_: swap up         _c_: close              _n_: buffer next
_l_: split right    _L_: move right      _C-l_: swap right      _x_: kill buffer        _p_: buffer previous

"
  ("h" awin/split-left)
  ("j" awin/split-down)
  ("k" awin/split-up)
  ("l" awin/split-right)
  ("H" awin/move-left)
  ("J" awin/move-down)
  ("K" awin/move-up)
  ("L" awin/move-right)
  ("C-h" awin/swap-left)
  ("C-j" awin/swap-down)
  ("C-k" awin/swap-up)
  ("C-l" awin/swap-right)
  ("m" awin/maximize)
  ("t" awin/toggle-split)
  ("c" awin/kill-window)
  ("C" awin/kill-window "close close" :color blue)
  ("s" window-swap-states)
  ("x" kill-current-buffer)
  ("U" adam/page-k)
  ("D" adam/page-j)
  ("n" next-buffer)
  ("p" previous-buffer)
  ("b" adam/switch-buffer "buffer" :color blue)
  ("RET" nil "quit" :color blue)
  ("q" nil "quit" :color blue))

(defhydra adam/zoomer (:hint nil)
  "
Font Size: %(adam/font-size)
-------------
_+_: increase
_-_: decrease
_d_: default: % `adam/font-size-default

"
  ("-" adam/font-size-decrease)
  ("=" adam/font-size-increase)
  ("_" adam/font-size-decrease)
  ("+" adam/font-size-increase)
  ("d" adam/font-size-default)
  ("RET" nil "quit" :color blue)
  ("q" nil "quit" :color blue))

(defhydra adam/lookup-panel (:hint nil :exit t)
  "
Lookup
-------------------
_?_: lsp
_x_: xref definitions
_r_: xref references
_s_: emacs symbol
_v_: emacs variable
_f_: emacs function

"
  ("?" lsp-describe-thing-at-point)
  ("x" xref-find-definitions)
  ("r" xref-find-references)
  ("s" describe-symbol)
  ("v" describe-variable)
  ("f" describe-function)
  ("RET" nil "quit" :color blue)
  ("q" nil "quit" :color blue))

(defhydra adam/finder (:hint nil :exit t)
  "
Finder
----------
_f_: fuzzy
_/_: swiper
_._: file
_,_: project file
_b_: buffer
_x_: M-x
_a_: app
_i_: internet
_r_: grep
___: regex
_m_: man

"
  ("b" adam/switch-buffer)
  ("x" adam/M-x)
  ("a" counsel-linux-app)
  ("." adam/find-file-new)
  ("," projectile-find-file)
  ("f" adam/fuzzy-find)
  ("/" swiper)
  ("r" rgrep)
  ("i" adam/internet-search)
  ("_" query-replace-regexp)
  ("m" man)
  ("RET" nil "quit" :color blue)
  ("q" nil "quit" :color blue))

(defhydra adam/shellder (:hint nil :exit t)
  "
Shellder
-----------
_c_ compile
_p_ project compile
_s_ shell
_a_ async shell
_z_ zombie shell

"
  ("c" compile)
  ("p" projectile-compile-project)
  ("s" shell-command)
  ("a" async-shell-command)
  ("z" adam/zombie-command)
  ("RET" nil "quit" :color blue)
  ("q" nil "quit" :color blue))

(defhydra adam/launcher (:hint nil :exit t)
  "
Launcher
-------------
_s_: symbols
_b_: buffer
_p_: processes
_d_: diagnostics
_a_: agent shell
_e_: eshell
_E_: eshell new
_l_: elisp shell
_g_: git status
_G_: git diff
_?_: cheatsheet

"
  ("s" lsp-treemacs-symbols)
  ("b" adam/ibuffer)
  ("d" flycheck-list-errors)
  ("l" ielm)
  ("e" adam/eshell)
  ("E" adam/eshell-new)
  ("g" magit-status)
  ("G" adam/toggle-file-diff)
  ("?" meow-cheatsheet)
  ("p" list-processes)
  ("a" agent-shell)
  ("RET" nil "quit" :color blue)
  ("q" nil "quit" :color blue))

(defhydra adam/goto (:exit t)
  "
Goto
-------------
_i_: init file
_h_: homepage
_p_: current project
_c_: castle
_t_: misc todos
_P_: philsophy
_l_: line

"
  
  ("i" adam/goto-init-file)
  ("h" adam/goto-homepage)
  ("p" adam/goto-current-project)
  ("c" adam/goto-castle)
  ("t" adam/goto-misc-todos)
  ("P" adam/goto-philosophy)
  ("l" goto-line)
  ("RET" nil "quit" :color blue)
  ("q" nil "quit" :color blue))

(provide 'adam-menu)
;;; adam-menu.el ends here
