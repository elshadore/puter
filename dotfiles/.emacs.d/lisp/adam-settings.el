(setq custom-file "~/.emacs.d/custom.el")
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode -1)
(menu-bar-mode -1)
(setq visible-bell nil)
(setq inhibit-startup-screen t)
(column-number-mode 1)
(setq-default cursor-in-non-selected-windows nil)

(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

(defalias 'yes-or-no-p 'y-or-n-p)
(setq vc-follow-symlinks t)

(setq find-file-visit-truename t)

(global-display-line-numbers-mode 1)
(set-default 'truncate-lines t)
(setq global-visual-wrap-prefix-mode t)

;; (global-prettify-symbols-mode 1)
(global-auto-revert-mode 1)

(setq blink-cursor-interval 0.15)
(setq blink-cursor-blinks -1)
(setq focus-follows-mouse nil)
(setq mouse-autoselect-window nil)
(setq scroll-preserve-screen-position t)
(setq redisplay-skip-fontification-on-input t)
(global-hl-line-mode)
;; (global-visual-line-mode)

(global-flycheck-mode)

(display-line-numbers-mode 1)
(setq-default display-line-numbers-type 'relative)
(setq browse-url-browser-function #'browse-url-firefox)

(setq debug-on-error nil)
(setq edebug-all-forms nil)

(setq message-log-max 16384)
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(setq make-backup-files t)
(setq version-control nil)
(setq backup-by-copying t)
(setq vc-make-backup-files t)
(setq delete-old-versions t)
(setq backup-directory-alist '(("." . "~/.emacs.d/backup")))

(electric-pair-mode 1)
(setq compile-command "")

(setq read-process-output-max (* 1024 1024))
(setq gc-cons-threshold (* 100 1024 1024))

(provide 'adam-settings)
