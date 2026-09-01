(defvar adam/emacs-symbol-regex "\\(?:\\sw\\|\\s_\\|\\\\.\\)+\\(?:\\sw\\|\\s_\\|\\\\.\\|[0-9]\\)*")

(defun adam/elisp-regex-generate (matches)
    (mapcar (lambda (m)
              (list (car m) (concat "^\\s-*(" (cdr m) (concat "\\s-+\\(" adam/emacs-symbol-regex "\\)")) 1))
            matches))

(defvar adam/elisp-regex (adam/elisp-regex-generate
                          '(("hydra" . "defhydra")
                            ("function" . "defun")
                            ("variable" . "defvar")
                            ("macro" . "defmacro")
                            ("require" . "require")
                            ("package" . "use-package")
                            ("minor-mode" . "define-minor-mode"))))

(defun adam/elisp-setup ()
    "custom elisp setup."
    (setq-local imenu-generic-expression adam/elisp-regex))

(use-package emacs
  :hook (emacs-lisp-mode . adam/elisp-setup)
  :config
  (context-menu-mode t)
  (define-key emacs-lisp-mode-map (kbd "C-c C-c") #'adam/C-c-C-c)
  (define-key emacs-lisp-mode-map (kbd "C-x C-e") #'adam/C-x-C-e)
  (define-key emacs-lisp-mode-map (kbd "C-c C-a") #'adam/C-c-C-a))

(progn
  (add-to-list 'auto-mode-alist '("\\.rasi\\'" . css-mode))
  (add-to-list 'auto-mode-alist '(".semanrc" . conf-mode))
  (add-to-list 'auto-mode-alist '("\\.sex\\'" . lisp-data-mode))
  (add-to-list 'auto-mode-alist '("\\.sexp\\'" . lisp-data-mode)))

(use-package counsel
  :config
  (setq counsel-linux-app-format-function #'counsel-linux-app-format-function-name-pretty))

(defun adam/fuzzy-re-builder (str)
  "Fuzzy finding ivy-rebuilder."
  (let ((case-fold-search t))
    (ivy--regex-plus str)))

(use-package ivy
  :bind
  (:map ivy-minibuffer-map
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
  ;; Disabling the regex inserts at the start of the prompt => ("^" "^+") ect..
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

(use-package hydra)

(use-package flash)

(use-package multiple-cursors
  :config
  (setq mc/always-run-for-all t))

(use-package expand-region)

(use-package paredit)

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
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  :custom ((projectile-completion-system 'ivy))
  :init
  (when (file-directory-p "~/work")
    (setq projectile-project-search-path '("~/work")))
  (setq projectile-switch-project-action #'projectile-dired))

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

(use-package magit
  :bind (:map magit-mode-map
              ("L" . magit-log)))

;; (use-package magit-todos
;;   :after magit
;;   :config (magit-todos-mode 1))

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

(use-package agent-shell
  :config
  (setq agent-shell-prefer-viewport-interaction t)
  (add-hook 'agent-shell-viewport-view-mode-hook (lambda () (adam-markdown-tools-mode -1)))
  (add-hook 'agent-shell-viewport-edit-mode-hook (lambda () (adam-markdown-tools-mode -1)))
  :bind
  (:map agent-shell-viewport-edit-mode-map
        ("R" . agent-shell-viewport-reply))
        ("M-n" . agent-shell-viewport-next-history)
        ("M-p" . agent-shell-viewport-previous-history)
  (:map agent-shell-viewport-view-mode-map
        ("M-n" . agent-shell-viewport-next-item)
        ("M-p" . agent-shell-viewport-previous-item)))

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

(use-package visual-fill-column)

(use-package writeroom-mode
  :config
  (setopt writeroom-maximize-window nil)
  (setopt writeroom-width 120)
  (setopt writeroom-local-effects (list (adam/anti-mode display-line-numbers-mode)
                                        (adam/anti-mode git-gutter-mode)))
  (setopt writeroom-global-effects '(writeroom-set-alpha
                                     writeroom-set-menu-bar-lines
                                     writeroom-set-tool-bar-lines
                                     writeroom-set-vertical-scroll-bars
                                     writeroom-set-bottom-divider-width)))

(defun adam/markdown-hook ()
  (visual-line-mode)
  (flyspell-mode)
  (writeroom-mode)
  (adam-markdown-tools-mode 1))

(use-package markdown-mode
  :straight t
  :config
  (require 'adam-markdown-tools)
  (add-hook 'markdown-mode-hook 'adam/markdown-hook)
  :bind
  (:map markdown-mode-map
        ("C-c o" . markdown-follow-thing-at-point)
        ("C-c m" . adam-markdown-tools-mode)))

(use-package markdown-indent-mode)

(defun adam/org-hook ()
  "Hook for setting indentation on org-mode."
  (org-indent-mode)
  (visual-line-mode)
  (flyspell-mode)
  (writeroom-mode))

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

;; (use-package mu4e
;;   :config
;;   (setq mu4e-change-filenames-when-moving t)
  
;;   (setq mu4e-use-fancy-chars t)

;;   (setq mu4e-update-interval (adam/minutes 5))
;;   (setq mu4e-get-mail-command "mbsync -a")
;;   (setq mu4e-maildir "~/Mail")

;;   (setq mu4e-drafts-folder "/[Gmail]/Drafts")
;;   (setq mu4e-sent-folder   "/[Gmail]/Sent Mail")
;;   (setq mu4e-refile-folder "/[Gmail]/All Mail")
;;   (setq mu4e-trash-folder  "/[Gmail]/Trash")

;;   (setq mu4e-maildir-shortcuts
;;       '(("/Inbox"             . ?i)
;;         ("/[Gmail]/Sent Mail" . ?s)
;;         ("/[Gmail]/Trash"     . ?t)
;;         ("/[Gmail]/Drafts"    . ?d)
;;         ("/[Gmail]/All Mail"  . ?a)))
  
;;   (mu4e t))

(use-package sly
  :config
  ;; (setq inferior-lisp-program "ros dynamic-space-size=4Gb -L sbcl -Q -l ~/.sbclrc run")
  (setq inferior-lisp-program "sbcl")
  (add-to-list 'auto-mode-alist '(".sbclrc" . lisp-mode)))

(use-package clojure-mode)
(use-package cider)

(use-package geiser)
(use-package geiser-guile)

(use-package haskell-mode)

(use-package cc-mode
  :straight t
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
  (adam/add-lsp-hook 'c-mode-hook)
  (adam/add-lsp-hook 'c++-mode-hook)
  (adam/add-lsp-hook 'simpc-mode-hook)
  (when adam/lsp-enabled
    (setq lsp-clients-clangd-args '("--fallback-style=none" "--clang-tidy=0" "--header-insertion=never"))))

(use-package zig-mode
  :config
  (add-hook 'zig-mode-hook (lambda () (zig-format-on-save-mode -1)))
  (adam/add-lsp-hook 'zig-mode-hook))

(defun adam/rust-fixup ()
  (interactive)
  (adam/shell "cargo fix --allow-dirty --allow-staged && cargo fmt --all"))

(use-package rust-mode
  :config
  (setq rust-rustfmt-switches '("--edition" "2024"))
  (add-hook 'rust-mode-hook (lambda () (prettify-symbols-mode -1)))
  (adam/add-lsp-hook 'rust-mode-hook)
  (adam/add-fixup 'rust-cargo 'adam/rust-fixup))

(use-package go-mode
  :config
  (adam/add-lsp-hook 'go-mode-hook))

(use-package lua-mode
  :config
  (adam/add-lsp-hook 'lua-mode-hook)
  (setq lua-indent-level 4)
  (setq lua-indent-nested-block-content-align nil))

(use-package nix-mode)

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

(defun adam/flycheck-error-list-hook ()
  (visual-line-mode 1))

(use-package flycheck
  :config
  (add-hook 'flycheck-error-list-mode-hook 'adam/flycheck-error-list-hook))

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
  (("C-x C-j" . dired-jump)
   :map dired-mode-map
   ("r" . revert-buffer)
   ("C-c C-o" . dired-find-file-other-window)
   ("DEL" . dired-up-directory))
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

(use-package sudo-edit)

(provide 'adam-config)
