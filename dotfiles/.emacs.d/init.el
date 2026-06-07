;;; package --- Summary
;;; Commentary:
;;: note: on first install call M-x all-the-icons-install-fonts
;;; Code:

(server-start)

(setq custom-file "~/.emacs.d/custom.el")
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode -1)
(menu-bar-mode -1)
(setq visible-bell nil)
(column-number-mode 1)
(setq-default cursor-in-non-selected-windows nil)

(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

(defalias 'yes-or-no-p 'y-or-n-p)
(setq vc-follow-symlinks t)

(global-display-line-numbers-mode 1)
(set-default 'truncate-lines t)
(setq global-visual-wrap-prefix-mode t)

(global-prettify-symbols-mode 1)
(global-auto-revert-mode 1)

(setq blink-cursor-interval 0.15)
(setq blink-cursor-blinks -1)
(setq focus-follows-mouse t)
(setq mouse-autoselect-window t)
(setq scroll-preserve-screen-position t)
(setq redisplay-skip-fontification-on-input t)
(global-hl-line-mode)
;; (global-visual-line-mode)

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

(push "/home/adam/.emacs.d/lisp/" load-path)

(push "/home/adam/.emacs.d/themes/" custom-theme-load-path)
(setq custom-theme-directory "/home/adam/.emacs.d/themes/")

(electric-pair-mode 1)
(setq compile-command "")

(setq read-process-output-max (* 1024 1024))
(setq gc-cons-threshold (* 100 1024 1024))

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

(require 'adam)
(require 'adam-window)

;; Quitting is always an option...
(global-set-key (kbd "<escape>") #'adam/quitter)
(global-set-key [remap keyboard-quit] #'adam/quitter)

(defun adam/set-frame-default-params ()
  "Set all frame params."
  (adam/set-font "Iosevka Nerd Font Mono" 12)
  (set-frame-parameter nil 'alpha-background 90))

;; Emacs daemon-mode doesn't load frame params correctly.
(if (daemonp)
      (add-hook 'after-make-frame-functions
                (lambda (frame)
                  (with-selected-frame frame
                    (adam/set-frame-default-params))))
  (adam/set-frame-default-params))

(defvar adam/emacs-symbol-regex "\\(?:\\sw\\|\\s_\\|\\\\.\\)+\\(?:\\sw\\|\\s_\\|\\\\.\\|[0-9]\\)*")

(defun adam/elisp-regex-generate (matches)
    (mapcar (lambda (m)
              (list (car m) (concat "^\\s-*(" (cdr m) (concat "\\s-+\\(" adam/emacs-symbol-regex "\\)")) 1))
            matches))

(defvar adam/elisp-regex (adam/elisp-regex-generate
                          '(("function" . "defun")
                            ("variable" . "defvar")
                            ("macro" . "defmacro")
                            ("require" . "require")
                            ("package" . "use-package")
                            ("minor-mode" . "define-minor-mode"))))

(defun adam/elisp-setup ()
    "custom elisp setup."
    (setq-local imenu-generic-expression adam/elisp-regex))

(defvar adam/lsp-enabled t)

(defun adam/add-lsp-hook (hook)
  "Add a hook HOOK to lsp mode, if lsp mode is enabled."
  (when adam/lsp-enabled
    (add-hook hook 'lsp-mode)))

(defun adam/prog-hook ()
  "Hook for running basic PROG-MODE."
  ;; (flyspell-prog-mode)
  ;; (whitespace-mode)
  )

(add-hook 'prog-mode-hook 'adam/prog-hook)

(use-package emacs
  :hook (emacs-lisp-mode . adam/elisp-setup)
  :config
  (context-menu-mode t)
  (define-key emacs-lisp-mode-map (kbd "C-c C-c") #'adam/C-c-C-c)
  (define-key emacs-lisp-mode-map (kbd "C-x C-e") #'adam/C-x-C-e))

(use-package counsel
  :config
  (setq counsel-linux-app-format-function #'counsel-linux-app-format-function-name-pretty))

(defun adam/fuzzy-re-builder (str)
  "Fuzzy finding ivy-rebuilder."
  (let ((case-fold-search t))
    (ivy--regex-plus str)))

(use-package ivy
  :bind
  (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         ;; ("M-RET" . ivy-immediate-done)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         ;; ("M-RET" . ivy-immediate-done)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill)
         ;; ("M-RET" . ivy-immediate-done)
         )
  :config
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq enable-recursive-minibuffers t)
  (setq ivy-height 20)
  (setq ivy-re-builders-alist '((t . adam/fuzzy-re-builder)))
  ;; Disableing the regex inserts at the start of the prompt => ("^" "^+") ect..
  (setq ivy-initial-inputs-alist nil)
  (ivy-mode 1)
  )

(use-package ivy-rich
  :after ivy)

(use-package swiper)

(use-package flx)

(use-package all-the-icons)
;; on first install call M-x all-the-icons-install-fonts

(use-package all-the-icons-completion)
(use-package all-the-icons-dired)
(use-package all-the-icons-ibuffer)
(use-package all-the-icons-nerd-fonts)

(use-package colorful-mode
  :config
  (global-colorful-mode 1))

(use-package which-key
  :init
  (which-key-mode 1)
  :config
  (setq which-key-side-window-location 'bottom
        which-key-sort-order #'which-key-key-order-alpha
        which-key-sort-uppercase-first nil
        which-key-max-display-columns nil
        which-key-min-display-lines 6))

(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package company
  :bind
  (:map company-active-map
        ("C-l" . company-complete-selection)
        ("<return>" . nil)
        ("RET" . nil))
  :config
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0.0))

(global-company-mode 1)

(use-package meow
  :config
  (meow-leader-define-key
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("?" . meow-cheatsheet)
   '("." . adam/find-file-new)
   '("," . projectile-find-file)
   
   '("/" . adam/fuzzy-find)
   '("f c" . adam/goto-init-file)
   '("f h" . adam/goto-homepage)
   
   '(";" . (lambda () (interactive) (require 'magit) (magit-status)))
   '("b b" . adam/switch-buffer)
   '("b x" . (lambda () (interactive) (kill-buffer (current-buffer))))
   '("b l" . (lambda () (interactive) (switch-to-buffer nil)))
   '("w h" . awin/move-left)
   '("w j" . awin/move-down)
   '("w k" . awin/move-up)
   '("w l" . awin/move-right)
   '("s h" . awin/swap-left)
   '("s j" . awin/swap-down)
   '("s k" . awin/swap-up)
   '("s l" . awin/swap-right)
   '("q h" . awin/split-left)
   '("q j" . awin/split-down)
   '("q k" . awin/split-up)
   '("q l" . awin/split-right)
   '("w x" . awin/kill-window)
   '("w m" . awin/maximize)
   '("w q" . awin/toggle-split)
   '("q q" . window-swap-states)
   '("z e" . adam/eshell)
   '("z z" . (lambda () (interactive)
               (call-interactively 'compile)))
   '("z n" . (lambda () (interactive)
               (let ((compile-command ""))
                 (call-interactively 'compile))))
   '("z p" . (lambda () (interactive)
               (when (projectile-project-p)
                 (call-interactively 'projectile-compile-project))))

   '("a" . agent-shell)
   '("<SPC>" . adam/M-x)
   )
  (meow-motion-define-key
   '("y" . meow-clipboard-save)
   '("d" . meow-clipboard-kill)
   '("g" . meow-cancel-selection)
   '("v" . meow-line)
   )
  (meow-normal-define-key
   '("i" . meow-insert)
   '("I" . (lambda () (interactive) (beginning-of-line) (meow-insert)))
   '("q" . meow-quit)
   '("Q" . kmacro-start-macro-or-insert-counter)
   '("@" . kmacro-end-or-call-macro)
   '("w" . meow-next-word)
   '("W" . meow-next-symbol)
   '("b" . meow-back-word)
   '("m" . meow-block)
   '("d" . meow-clipboard-kill)
   '("y" . meow-clipboard-save)
   '("p" . adam/paste-below)
   '("P" . adam/paste-above)
   '("c" . meow-change)
   '("o" . meow-open-below)
   '("O" . meow-open-above)
   '("a" . (lambda () (interactive) (meow-append)))
   '("A" . (lambda () (interactive) (end-of-line) (meow-insert)))
   '("g" . meow-cancel-selection)
   '("h" . meow-left)
   '("j" . next-line)
   '("V" . meow-line)
   '("x" . adam/kill-char)
   '("k" . (lambda () (interactive) (next-line -1)))
   '("l" . meow-right)
   '("u" . undo)
   '("U" . undo-redo)
   '("v" . meow-search)
   '("/" . meow-visit)
   '("y" . meow-clipboard-save)
   ))

(meow-global-mode 1)

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t)
  (setq doom-themes-enable-italic nil)
  (setq doom-winter-is-coming-no-italics t)
  (setq doom-winter-is-coming-brighter-comments t)
  (setq doom-ir-black-brighter-comments t))

(use-package modus-themes)

(use-package doom-modeline
  :init
  (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 28)
  (setq doom-modeline-enable-word-count t))

(use-package projectile
  :config
  (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/work")
    (setq projectile-project-search-path '("~/work")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package flycheck)

(use-package yasnippet
  :config
  (yas-global-mode 1))

(use-package eshell
  :config
  (setq eshell-banner-message "")
  (mapc (lambda (alias) (defalias (car alias) (cdr alias)))
        '((ll . (lambda () (eshell/ls '-lah)))
          (dir . dired))))

(use-package eshell-syntax-highlighting
  :after
  eshell
  :config
  (eshell-syntax-highlighting-global-mode 1))

(use-package eshell-prompt-extras
  :config
  (setq eshell-highlight-prompt nil)
  (setq eshell-prompt-function 'epe-theme-multiline-with-status))

(use-package vterm)

(use-package sudo-edit)

(use-package helpful)

(use-package magit)

(use-package magit-todos
  :after magit
  :config (magit-todos-mode 1))

(use-package git-gutter
  :config
  (global-git-gutter-mode 1))

(use-package forge)

(use-package gptel
  :config
  (setq gptel-model 'deepseek-chat)
  (setq gptel-backend
        (gptel-make-openai "DeepSeek"
          :host "api.deepseek.com"
          :endpoint "/chat/completions"
          :stream t
          :key (adam/lookup-auth 'deepseek)
          :models '(deepseek-chat deepseek-coder))))

(use-package agent-shell)

(use-package i3wm-config-mode)
(use-package css-mode)
(use-package yaml-mode)
(use-package js2-mode
  :config
  (add-hook 'js-mode-hook 'js2-minor-mode)
  (add-hook 'js2-mode-hook 'ac-js2-mode)
  (adam/add-lsp-hook 'js-mode-hook))

(use-package flyspell
  :straight t
  :config
  (setq ispell-program-name "hunspell")
  (setq ispell-dictionary "en_GB"))

(defun adam/markdown-hook ()
  (visual-line-mode)
  (flyspell-mode))

(use-package markdown-mode
  :straight t
  :config
  (add-hook 'markdown-mode-hook 'adam/markdown-hook))

(defun adam/org-hook ()
  "Hook for setting indentation on org-mode."
  (org-indent-mode)
  (visual-line-mode)
  (flyspell-mode))

(use-package org
  :config
  (add-hook 'org-mode-hook 'adam/org-hook)
  (setq org-edit-src-content-indentation 0)
  (setq org-link-descriptive t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq org-imenu-depth 67)
  (setq org-agenda-files '("~/adam/HOMEPAGE.org")))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :config
  (setq org-bullets-bullet-list '("*")))

(use-package sly
  :config
  (setq inferior-lisp-program "ros dynamic-space-size=4Gb -L sbcl -Q -l ~/.sbclrc run"))

;; EWW Yuck
(add-to-list 'auto-mode-alist '("\\.yuck\\'" . lisp-mode))

(use-package clojure-mode)
(use-package cider)

(use-package geiser)
(use-package geiser-guile)

(use-package haskell-mode)

(use-package simpc-mode
  :straight (simpc-mode :type git :host github :repo "rexim/simpc-mode")
  :after lsp-mode
  :config
  (c-add-style
   "adam"
   '((c-auto-align-backslashes . nil)
     (c-continued-statement-offset . 4)
     (c-basic-offset . 4)
     (c-offsets-alist
      (arglist-intro . +)
      (substatement-open . +)
      (inline-open . +)
      (block-open . +)
      (brace-list-open . +)
      (case-label . +))))
  (setq c-default-style "adam")
  (add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))
  (adam/add-lsp-hook 'c-mode-hook)
  (adam/add-lsp-hook 'c++-mode-hook)
  (adam/add-lsp-hook 'simpc-mode-hook)
  (when adam/lsp-enabled
    (setq lsp-clients-clangd-args '("--fallback-style=none" "--clang-tidy=0" "--header-insertion=never"))
    (add-to-list 'lsp-language-id-configuration '(simpc-mode . "c"))))

(use-package zig-mode
  :config
  (add-hook 'zig-mode-hook
            #'(lambda ()(interactive)(zig-format-on-save-mode -1)))
  (adam/add-lsp-hook 'zig-mode-hook))

(use-package rust-mode
  :config
  (setq rust-rustfmt-switches '("--edition" "2024"))
  (adam/add-lsp-hook 'rust-mode-hook))

(use-package go-mode
  :config
  (adam/add-lsp-hook 'go-mode-hook))

(use-package lua-mode
  :config
  (define-key lua-mode-map (kbd "<normal-state> K") nil)
  (adam/add-lsp-hook 'lua-mode-hook))

(use-package js
  :straight t)

(use-package python
  :straight nil
  :config
  (setq python-shell-interpreter "python3")
  (adam/add-lsp-hook 'python-mode-hook))

(use-package gdscript-mode
  :config
  (setq gdscript-godot-executable "/bin/godot/godot")
  (setq gdscript-use-tab-indents t)
  (setq gdscript-gdformat-save-and-format nil)
  (adam/add-lsp-hook 'gdscript-mode-hook))

(use-package glsl-mode)
(use-package wgsl-mode)

(use-package lsp-mode
  :init
  (setq lsp-log-io nil)
  (setq lsp-keymap-prefix "C-c l")
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-enable-which-key-integration t)
  :config
  (setq lsp-enable-on-type-formatting nil)
  (setq lsp-enable-indentation nil))

(use-package lsp-ui
  :config
  (setq lsp-ui-doc-enable nil)
  (setq lsp-ui-doc-show-with-cursor nil)
  (setq lsp-ui-doc-show-with-mouse nil))

(use-package lsp-ivy)

(use-package dired
  :straight nil
  :commands (dired dired-jump)
  :bind
  (("C-x C-j" . dired-jump))
  :custom
  ((dired-listing-switches "-lah --group-directories-first"))
  :config
  (setq dired-kill-when-opening-new-dired-buffer t)
  (setq dired-dwim-target t)
  (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

(setq adam/pdf-reader "okular")
(setq adam/image-viewer "ristretto")
(setq adam/video-player "mpv")

(use-package dired-open
  :config
  (setq dired-open-extensions
        `(("gif" . ,adam/image-viewer)
          ("jpg" . ,adam/image-viewer)
          ("png" . ,adam/image-viewer)
          ("mkv" . ,adam/video-player)
          ("mp4" . ,adam/video-player)
          ("webm" . ,adam/video-player)
          ("xcf" . "gimp")
          ("kra" . "krita")
          ("pdf" . ,adam/pdf-reader)
          ("cbr" . ,adam/pdf-reader)
          ("epub" . "epub-reader")
          ("blend" . "blender"))))

(use-package dired-hide-dotfiles)

(defun adam/buffer-grep ()
  "Grep the current buffer."
  (interactive)
  (counsel-grep))

(use-package emms)

;; Wayland clipboard support
(when (adam/is-wayland?)

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

(require 'adam-mode)
(require 'puter)

(setq doom-ir-black-brighter-comments t)
(setq doom-ir-black-padded-modeline nil)
(adam/load-theme 'doom-ir-black)
;; (adam/load-theme 'modus-vivendi-tinted)

(load-file custom-file)
(setq inhibit-startup-screen t)
(adam/goto-homepage)

(provide 'init)
;;; init.el ends here
(put 'list-timers 'disabled nil)
