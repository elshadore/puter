;;; package --- Summary
;;; Commentary:
;;: note: on first install call M-x all-the-icons-install-fonts
;;; Code:

;; (server-start)

(push "/home/adam/.emacs.d/lisp/" load-path)
(push "/home/adam/.emacs.d/themes/" custom-theme-load-path)
(setq custom-theme-directory "/home/adam/.emacs.d/themes/")

(require 'adam-settings)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(straight-use-package 'org)

(setq straight-use-package-by-default t)

(require 'adam-utils)
(require 'adam-mode)
(require 'adam-window)
(require 'adam-eshell)
(require 'adam-music)
(require 'adam-puter)
(require 'adam-font)
(require 'adam-keys)
(require 'adam-config)
(require 'adam-menu)
(require 'adam-markdown-tools)

(when (adam/puter-is-xwindows?)
  (adam/puter-xsettings))

(when (adam/puter-is-wayland?)

  (setq select-enable-primary nil)
  (setq select-enable-clipboard t)
  (setq x-select-enable-primary nil)
  (setq x-select-enable-clipboard t)

  (use-package xclip
    :config
    (setq xclip-program "wl-copy")
    (setq xclip-select-enable-clipboard t)
    (setq xclip-mode t)
    (setq xclip-method 'wl-copy)
    (setq xclip-select-enable-clipboard t)))

(defun adam/set-frame-default-params ()
  "Set all frame params."
  (adam/font-init))

;; Emacs daemon-mode doesn't load frame params correctly.
(if (daemonp)
      (add-hook 'after-make-frame-functions
                (lambda (frame)
                  (with-selected-frame frame
                    (adam/set-frame-default-params))))
  (adam/set-frame-default-params))


(setq doom-ir-black-brighter-comments t)
(setq doom-ir-black-padded-modeline nil)
(setq doom-winter-is-coming-brighter-comments t)
(setq doom-winter-is-coming-brighter-modeline t)
;; (adam/load-theme 'doom-winter-is-coming-dark-blue)
;; (adam/load-theme 'modus-vivendi-tinted)
(adam/load-theme 'doom-ir-black)

(load-file custom-file)
(adam/goto-homepage)

(provide 'init)

;;; init.el ends here
(put 'list-timers 'disabled nil)
